package com.nodelane.comics

import android.app.Activity
import android.content.Context
import android.graphics.Bitmap
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import org.json.JSONObject
import org.mozilla.geckoview.*
import java.io.ByteArrayOutputStream
import java.net.URI
import java.util.concurrent.CompletableFuture

private const val HOST = "nodelane/browser"
private const val READER = "reader@nodelane.net"
private const val UBLOCK = "uBlock0@raymondhill.net"
private const val LOCAL_PAGE = "data:text/html,%3Ctitle%3E%3C/title%3E"

private fun webUrl(value: String?): Boolean = value != null && value.length <= 8192 &&
    runCatching {
        val uri = URI(value)
        uri.scheme?.lowercase() in setOf("http", "https") && uri.host != null && uri.rawUserInfo == null
    }.getOrDefault(false)

/** The runtime is process-wide; views, sessions and extension popups belong to the Flutter engine. */
internal class GeckoBrowser(private val activity: Activity, val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE), WebExtension.ActionDelegate, WebExtension.TabDelegate {
    companion object {
        const val TYPE = HOST
        private var processRuntime: GeckoRuntime? = null
    }

    val runtime by lazy {
        processRuntime ?: GeckoRuntime.create(activity.applicationContext,
            GeckoRuntimeSettings.Builder().debugLogging(false).consoleOutput(false).build()
        ).also { processRuntime = it }
    }
    private val manager = MethodChannel(messenger, HOST)
    private val sourceHttp = GeckoSourceHttp(messenger) { runtime }
    val sourceCache = SourceCacheScope(activity.applicationContext)
    val sourcePages = mutableMapOf<String, GeckoSourcePage>()
    private var sourceScripts: GeckoResult<WebExtension>? = null
    private var installingReader: GeckoResult<WebExtension>? = null
    private var readerAddon: WebExtension? = null
    private val pages = mutableMapOf<String, GeckoPage>()
    private var installing: GeckoResult<WebExtension>? = null
    private var blocker: WebExtension? = null
    var filtersReady = false
        private set
    private var action: WebExtension.Action? = null
    private var active: GeckoSession? = null
    private var activeEvents: MethodChannel? = null
    private var panelId = 0
    private var panel: GeckoSession? = null
    private var disposed = false
    private var previewing = false

    init {
        manager.setMethodCallHandler { call, result ->
            when (call.method) {
                "sourceCacheScope" -> {
                    val hosts = call.arguments as List<*>
                    readerExtension().accept({ result.success(sourceCache.scope(hosts.filterIsInstance<String>())) },
                        { result.error("sourceCache", null, null) })
                }
                "sourcePage" -> {
                    try { GeckoSourcePage(this, call, result).also {
                        check(!sourcePages.containsKey(it.id))
                        sourcePages[it.id] = it
                        it.enqueue()
                    } }
                    catch (_: Exception) { result.error("sourcePage", null, null) }
                }
                "releaseSourcePage" -> { sourcePages[call.arguments as String]?.finish(); result.success(null) }
                "release" -> {
                    pages.remove(call.arguments as String)?.close()
                    result.success(null)
                }
                "clearCookies" -> runtime.storageController.clearData(
                    StorageController.ClearFlags.COOKIES or StorageController.ClearFlags.AUTH_SESSIONS
                ).accept({ sourceCache.cleared(null); result.success(null) }, { result.error("cookies", null, null) })
                "releasePanel" -> {
                    if (call.arguments == panelId) closePanel(notify = false)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    fun extensions(): GeckoResult<WebExtension> {
        installing?.let { return it }
        val controller = runtime.webExtensionController
        val ready = controller.ensureBuiltIn("resource://android/assets/extensions/ublock/", UBLOCK)
            .then { extension ->
                check(!disposed && extension != null)
                blocker = extension
                extension.setActionDelegate(this)
                extension.setTabDelegate(this)
                readerExtension()
            }
        installing = ready
        ready.accept({}, { if (installing === ready) installing = null })
        return ready
    }

    private fun readerExtension(): GeckoResult<WebExtension> {
        installingReader?.let { return it }
        val ready = runtime.webExtensionController.ensureBuiltIn("resource://android/assets/extensions/reader/", READER).map { reader ->
            check(!disposed && reader != null)
            reader.setMessageDelegate(sourceCache, "sourceCache")
            readerAddon = reader
            reader
        }
        installingReader = ready
        ready.accept({}, { if (installingReader === ready) installingReader = null })
        return ready
    }

    fun sourcePageExtension(): GeckoResult<WebExtension> {
        sourceScripts?.let { return it }
        val controller = runtime.webExtensionController
        val id = "source-page@nodelane.net"
        val ready = controller.ensureBuiltIn("resource://android/assets/extensions/source-page/", id)
            .then { extension ->
                if (extension != null && "userScripts" in extension.metaData!!.grantedOptionalPermissions)
                    GeckoResult.fromValue(extension)
                else controller.addOptionalPermissions(id, arrayOf("userScripts"), emptyArray(), emptyArray())
            }.then { readerExtension() }
        sourceScripts = ready
        ready.accept({}, { if (sourceScripts === ready) sourceScripts = null })
        return ready
    }

    fun startSourcePages() {
        if (disposed) return
        val free = 2 - sourcePages.values.count { it.started }
        if (free > 0) sourcePages.values.filterNot { it.started }.take(free).forEach { it.start() }
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        if (args is Int) {
            // A SurfaceView gives the standalone panel a local origin for its accessibility nodes.
            val view = GeckoView(context)
            if (args == panelId) panel?.let { view.setSession(it) }
            return object : PlatformView {
                override fun getView() = view
                override fun dispose() { view.releaseSession() }
            }
        }
        val key = args as String
        var page: GeckoPage? = null
        // A nested TextureView can keep the previous frame after Gecko paints a translated image.
        val view = GeckoView(context)
        val channel = MethodChannel(messenger, "$HOST/$viewId")
        channel.setMethodCallHandler { call, result ->
            try {
                if (call.method == "attach") page = pages.getOrPut(key) { GeckoPage(this) }
                val owner = page
                if (owner == null) result.error("detached", null, null)
                else owner.command(view, channel, call, result)
            } catch (_: Exception) {
                result.error("browser", null, null)
            }
        }
        return object : PlatformView {
            override fun getView() = view
            override fun dispose() {
                channel.setMethodCallHandler(null)
                page?.detach(view)
            }
        }
    }

    fun activate(session: GeckoSession, events: MethodChannel?) {
        val visible = events != null
        session.setActive(visible)
        if (visible || active === session) {
            if (!visible || active !== session) closePanel()
            active = if (visible) session else null
            activeEvents = events
            runtime.webExtensionController.setTabActive(session, visible)
        }
    }

    fun observeBlocker(session: GeckoSession) = session.webExtensionController.setActionDelegate(blocker!!, this)

    fun isActive(session: GeckoSession) = active === session

    fun preview(view: GeckoView, result: MethodChannel.Result) {
        if (previewing || disposed) { result.success(null); return }
        val pixels = view.capturePixels()
        previewing = true
        fun finish(bytes: ByteArray?) { previewing = false; result.success(bytes) }
        pixels.accept({ bitmap ->
            if (bitmap == null) { finish(null); return@accept }
            CompletableFuture.supplyAsync {
                try {
                    val w = minOf(bitmap.width, 340)
                    val scaled = Bitmap.createScaledBitmap(bitmap, w, maxOf(1, bitmap.height * w / bitmap.width), true)
                    try { ByteArrayOutputStream().use { out ->
                        if (scaled.compress(Bitmap.CompressFormat.JPEG, 55, out)) out.toByteArray() else null
                    } } finally { if (scaled !== bitmap) scaled.recycle() }
                } finally { bitmap.recycle() }
            }.whenComplete { bytes, _ -> activity.runOnUiThread { finish(bytes) } }
        }, { finish(null) })
    }

    fun openBlocker(target: String?) {
        when (target) {
            "tools" -> checkNotNull(action).click()
            "dashboard" -> {
                val base = checkNotNull(blocker?.metaData?.baseUrl)
                newPanel(openNow = true).loadUri("${base}dashboard.html")
            }
            else -> error("Unknown protection action")
        }
    }

    override fun onBrowserAction(extension: WebExtension, session: GeckoSession?, action: WebExtension.Action) {
        if (extension.id != UBLOCK) return
        if (session == null) this.action = action
        if (session != null && session === active && action.badgeText != null)
            activeEvents?.invokeMethod("blockerBadge", action.badgeText)
        // The pinned uBO emits a per-tab toolbar title only after its filter lists are ready.
        if (!filtersReady && session != null && action.title?.startsWith("uBlock Origin (") == true) {
            filtersReady = true
            pages.values.forEach { it.filtersReady() }
        }
    }

    override fun onTogglePopup(extension: WebExtension, action: WebExtension.Action): GeckoResult<GeckoSession>? {
        if (extension.id != UBLOCK || active == null || disposed || activity.isFinishing) return null
        return GeckoResult.fromValue(newPanel(openNow = true))
    }

    override fun onNewTab(source: WebExtension, createDetails: WebExtension.CreateTabDetails): GeckoResult<GeckoSession>? {
        // uBO closes its popup before its background page requests the dashboard tab.
        if (source.id != UBLOCK || active == null || disposed || activity.isFinishing ||
            createDetails.url?.startsWith(source.metaData?.baseUrl ?: return null) != true) return null
        return GeckoResult.fromValue(newPanel(openNow = false))
    }

    private fun newPanel(openNow: Boolean): GeckoSession {
        closePanel()
        val channel = checkNotNull(activeEvents)
        val session = GeckoSession()
        session.contentDelegate = object : GeckoSession.ContentDelegate {
            override fun onCloseRequest(session: GeckoSession) {
                if (panel === session) closePanel()
            }
        }
        if (openNow) session.open(runtime)
        panel = session
        channel.invokeMethod("blockerPanel", ++panelId)
        return session
    }

    private fun closePanel(notify: Boolean = true) {
        val session = panel ?: return
        panel = null
        if (notify) MethodChannel(messenger, "$HOST/panel/$panelId").invokeMethod("close", null)
        if (session.isOpen) session.close()
    }

    fun close() {
        disposed = true
        sourceHttp.close()
        sourcePages.values.toList().forEach { it.finish() }
        readerAddon?.setMessageDelegate(null, "sourceCache")
        closePanel()
        blocker?.setActionDelegate(null)
        blocker?.setTabDelegate(null)
        manager.setMethodCallHandler(null)
        pages.values.forEach { it.close() }
        pages.clear()
    }
}

private class GeckoPage(val host: GeckoBrowser) : GeckoSession.NavigationDelegate, GeckoSession.ProgressDelegate,
    GeckoSession.ContentDelegate, GeckoSession.ScrollDelegate, GeckoSession.HistoryDelegate, WebExtension.MessageDelegate, WebExtension.PortDelegate {
    private val session = GeckoSession(GeckoSessionSettings.Builder().suspendMediaWhenInactive(true).build())
    private var view: GeckoView? = null
    private var events: MethodChannel? = null
    private var port: WebExtension.Port? = null
    private val pending = mutableMapOf<Int, MethodChannel.Result>()
    private val handler = Handler(Looper.getMainLooper())
    private var nextId = 0
    private var url = ""
    private var title = ""
    private var loaded = false
    private var failed = false
    private var stopped = false
    private var back = false
    private var forward = false
    private var firstUrl: String? = null
    private var requested = ""
    private val startupTimeout = Runnable {
        if (firstUrl != null) { firstUrl = null; event("extensionsFailed") }
    }
    private var visible = false
    private var closed = false

    fun filtersReady() {
        val target = firstUrl ?: return
        firstUrl = null
        handler.removeCallbacks(startupTimeout)
        if (!closed && session.isOpen) session.load(GeckoSession.Loader().uri(target).flags(GeckoSession.LOAD_FLAGS_REPLACE_HISTORY))
    }

    private fun load(target: String) {
        requested = target
        if (!session.isOpen) return
        if (host.filtersReady) {
            session.loadUri(target)
        } else {
            val warm = firstUrl == null
            firstUrl = target
            if (warm) {
                handler.postDelayed(startupTimeout, 60000)
                session.loadUri(LOCAL_PAGE)
            }
        }
    }

    fun command(owner: GeckoView, channel: MethodChannel, call: MethodCall, result: MethodChannel.Result) {
        if (closed) { result.error("closed", null, null); return }
        if (call.method == "attach") {
            val initial = call.argument<String>("url")
            require(webUrl(initial))
            view?.takeIf { it !== owner }?.releaseSession()
            view = owner
            events = channel
            requested = initial!!
            visible = call.argument<Boolean>("active") == true
            host.extensions().accept({ reader ->
                if (view !== owner || closed || reader == null) {
                    result.error("closed", null, null)
                } else try {
                    val retained = session.isOpen
                    if (!retained) {
                        session.navigationDelegate = this
                        session.historyDelegate = this
                        session.progressDelegate = this
                        session.contentDelegate = this
                        session.scrollDelegate = this
                        session.webExtensionController.setMessageDelegate(reader, this, "reader")
                        host.observeBlocker(session)
                        session.open(host.runtime)
                    }
                    owner.setSession(session)
                    host.activate(session, if (visible) channel else null)
                    if (!retained) {
                        if (!stopped) load(requested)
                    } else {
                        event("location", url)
                        event("title", title)
                        if (failed) event("error", url) else if (loaded) {
                            event("retained", url)
                            reportReady()
                        }
                    }
                    result.success(retained)
                } catch (_: Exception) {
                    result.error("browser", null, null)
                }
            }, { result.error("extensions", null, null) })
            return
        }
        if (owner !== view) { result.error("detached", null, null); return }
        when (call.method) {
            "load" -> {
                val target = call.arguments as String
                require(webUrl(target))
                stopped = false
                load(target)
            }
            "reload" -> {
                stopped = false
                if (url.isEmpty() && requested.isNotEmpty()) load(requested) else session.reload()
            }
            "stop" -> {
                stopped = true
                firstUrl = null
                handler.removeCallbacks(startupTimeout)
                if (session.isOpen && host.filtersReady) session.stop()
            }
            "visible" -> {
                visible = call.arguments == true
                if (session.isOpen) host.activate(session, if (visible) channel else null)
            }
            "traverse" -> {
                val previous = call.arguments == -1
                val available = session.isOpen && if (previous) back else forward
                if (available) { if (previous) session.goBack(false) else session.goForward(false) }
                result.success(available)
                return
            }
            "blocker" -> {
                check(host.isActive(session) && webUrl(url) && call.argument<String>("url") == url)
                when (val action = call.argument<String>("action")) {
                    "reload" -> session.reload()
                    "clearSite" -> {
                        val domain = URI(url).host
                        host.runtime.storageController.clearDataFromHost(domain,
                            StorageController.ClearFlags.COOKIES or StorageController.ClearFlags.AUTH_SESSIONS
                        ).accept({ host.sourceCache.cleared(domain); result.success(null) }, { result.error("cookies", null, null) })
                        return
                    }
                    else -> host.openBlocker(action)
                }
            }
            "find" -> {
                val forward = call.argument<Boolean>("forward") != false
                session.finder.find(call.argument<String>("text"),
                    if (forward) GeckoSession.FINDER_FIND_FORWARD else GeckoSession.FINDER_FIND_BACKWARDS
                ).accept({ result.success(listOf(it?.current ?: 0, (it?.total ?: 0).coerceAtLeast(0))) },
                    { result.error("find", null, null) })
                return
            }
            "clearFind" -> session.finder.clear()
            "preview" -> {
                host.preview(owner, result)
                return
            }
            "reader" -> {
                val request = JSONObject(call.arguments as String)
                require(request.optString("operation") != "sourcePage")
                val peer = port
                val protection = request.optString("operation") == "siteProtection"
                if (peer == null || request.optString("url").substringBefore('#') != url.substringBefore('#')) {
                    result.error("document", null, null); return
                }
                if (protection && !host.isActive(session)) { result.error("document", null, null); return }
                val id = ++nextId
                peer.postMessage(request.put("id", id))
                pending[id] = result
                handler.postAtTime({ pending.remove(id)?.error("timeout", null, null) }, result,
                    android.os.SystemClock.uptimeMillis() + if (protection) 10000 else 60000)
                return
            }
            else -> { result.notImplemented(); return }
        }
        result.success(null)
    }

    private fun event(name: String, value: Any? = null) = events?.invokeMethod(name, value)
    private fun reportReady() {
        if (loaded && !failed && port != null) event("document", url)
    }
    private fun valid(sender: WebExtension.MessageSender) =
        sender.session === session && sender.webExtension.id == READER && sender.isTopLevel &&
            sender.environmentType == WebExtension.MessageSender.ENV_TYPE_CONTENT_SCRIPT && webUrl(sender.url)

    override fun onCanGoBack(session: GeckoSession, canGoBack: Boolean) { back = canGoBack }
    override fun onCanGoForward(session: GeckoSession, canGoForward: Boolean) { forward = canGoForward }
    override fun onHistoryStateChange(session: GeckoSession, historyList: GeckoSession.HistoryDelegate.HistoryList) {
        if (historyList.isEmpty()) return
        val index = historyList.currentIndex
        if (index !in historyList.indices) return
        val start = maxOf(0, index - 19)
        val urls = historyList.subList(start, minOf(historyList.size, index + 20)).map { it.uri }
        event("history", listOf(index - start, urls))
    }
    override fun onContextMenu(session: GeckoSession, screenX: Int, screenY: Int, element: GeckoSession.ContentDelegate.ContextElement) {
        if (visible && webUrl(element.linkUri))
            event("linkMenu", listOf(url, element.linkUri, element.type == GeckoSession.ContentDelegate.ContextElement.TYPE_IMAGE))
    }

    override fun onConnect(port: WebExtension.Port) {
        if (closed || !valid(port.sender)) { port.disconnect(); return }
        clearPort()
        this.port = port
        port.setDelegate(this)
        reportReady()
    }
    override fun onDisconnect(port: WebExtension.Port) {
        if (port === this.port) clearPort()
    }
    private fun clearPort() {
        // The document disconnects on pagehide (or Gecko on destruction); don't shut down its dispatcher twice.
        port = null
        pending.values.forEach { handler.removeCallbacksAndMessages(it); it.error("document", null, null) }
        pending.clear()
    }
    override fun onPortMessage(message: Any, port: WebExtension.Port) {
        if (this.port !== port || message !is JSONObject) return
        val result = pending.remove(message.optInt("id", -1)) ?: return
        handler.removeCallbacksAndMessages(result)
        result.success(message.toString())
    }
    override fun onMessage(nativeApp: String, message: Any, sender: WebExtension.MessageSender): GeckoResult<Any>? {
        if (!visible || closed || !valid(sender) || message !is JSONObject ||
            message.optString("url").substringBefore('#') != url.substringBefore('#')) return null
        val frame = URI(sender.url)
        val current = URI(url)
        if (frame.scheme != current.scheme || frame.rawAuthority != current.rawAuthority) return null
        val channel = events ?: return null
        val reply = GeckoResult<Any>()
        channel.invokeMethod("images", message.toString(), object : MethodChannel.Result {
            override fun success(result: Any?) = reply.complete(result == true)
            override fun error(code: String, message: String?, details: Any?) = reply.complete(false)
            override fun notImplemented() = reply.complete(false)
        })
        return reply
    }
    override fun onLoadRequest(session: GeckoSession, request: GeckoSession.NavigationDelegate.LoadRequest): GeckoResult<AllowOrDeny>? {
        if (firstUrl != null && request.isDirectNavigation && request.uri == LOCAL_PAGE) return null
        if (!webUrl(request.uri)) return GeckoResult.deny()
        if (request.target == GeckoSession.NavigationDelegate.TARGET_WINDOW_NEW) {
            if (visible && request.hasUserGesture) event("newTab", request.uri)
            return GeckoResult.deny()
        }
        return null
    }
    override fun onPageStart(session: GeckoSession, url: String) {
        if (!webUrl(url)) return
        this.url = url
        loaded = false; failed = false; stopped = false
        clearPort()
        event("start", url)
    }
    override fun onLocationChange(session: GeckoSession, url: String?, perms: List<GeckoSession.PermissionDelegate.ContentPermission>, hasUserGesture: Boolean) {
        if (!webUrl(url) || this.url == url) return
        this.url = url!!
        event("location", url)
        reportReady()
    }
    override fun onLoadError(session: GeckoSession, uri: String?, error: WebRequestError): GeckoResult<String>? {
        if (!stopped && (uri == null || uri == url)) { failed = true; event("error", url) }
        return null
    }
    override fun onPageStop(session: GeckoSession, success: Boolean) {
        if (!webUrl(url)) return
        loaded = success && !failed
        if (!loaded && !stopped) failed = true
        event(if (failed) "error" else if (stopped) "cancelled" else "stop", url)
        reportReady()
    }
    override fun onProgressChange(session: GeckoSession, progress: Int) { event("progress", progress) }
    override fun onTitleChange(session: GeckoSession, title: String?) {
        this.title = title.orEmpty()
        event("title", this.title)
    }
    override fun onScrollChanged(session: GeckoSession, scrollX: Int, scrollY: Int) {
        if (visible && loaded) event("scroll", listOf(scrollX, scrollY))
    }
    override fun onCrash(session: GeckoSession) { clearPort(); failed = true; event("gone") }
    override fun onKill(session: GeckoSession) = onCrash(session)
    fun detach(owner: GeckoView) {
        if (owner !== view) return
        events = null
        visible = false
        if (session.isOpen) host.activate(session, null)
        owner.releaseSession()
        view = null
    }
    fun close() {
        closed = true
        firstUrl = null
        handler.removeCallbacks(startupTimeout)
        view?.let { detach(it) }
        clearPort()
        if (session.isOpen) session.close()
    }
}
