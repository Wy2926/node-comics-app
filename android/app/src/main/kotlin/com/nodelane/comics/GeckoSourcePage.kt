package com.nodelane.comics

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import org.mozilla.geckoview.*
import java.net.URI

/** The source never gets a visible browser tab or a privileged extension world. */
internal class GeckoSourcePage(private val host: GeckoBrowser, call: MethodCall, private val result: MethodChannel.Result) :
    GeckoSession.NavigationDelegate, GeckoSession.ProgressDelegate, GeckoSession.ContentDelegate,
    WebExtension.MessageDelegate, WebExtension.PortDelegate {
    private val url = URI(checkNotNull(call.argument<String>("url")))
    val id = checkNotNull(call.argument<String>("id"))
    private val headers = call.argument<Map<String, String>>("headers").orEmpty()
    private val scripts = JSONArray(checkNotNull(call.argument<List<String>>("scripts")))
    private val session = GeckoSession()
    private val handler = Handler(Looper.getMainLooper())
    private val timeout = Runnable { finish() }
    private val duration = checkNotNull(call.argument<Number>("seconds")).toLong()
    private var port: WebExtension.Port? = null
    private var loaded = false
    private var sent = false
    private var closed = false
    var started = false
        private set

    private fun matches(target: String?) = runCatching {
        val uri = URI(target!!)
        fun port(u: URI) = if (u.port != -1) u.port else if (u.scheme == "https") 443 else 80
        uri.rawUserInfo == null && uri.scheme == url.scheme && uri.host.equals(url.host, true) && port(uri) == port(url)
    }.getOrDefault(false)

    fun enqueue() {
        if (url.host == null || url.rawUserInfo != null || url.scheme !in setOf("https", "http") || duration <= 0) {
            finish(); return
        }
        handler.postDelayed(timeout, duration.coerceAtMost(Int.MAX_VALUE.toLong()) * 1000)
        host.startSourcePages()
    }
    fun start() {
        if (closed || started) return
        started = true
        host.sourcePageExtension().accept({ reader ->
            if (closed) return@accept
            if (reader == null) { finish(); return@accept }
            try {
                session.navigationDelegate = this
                session.progressDelegate = this
                session.contentDelegate = this
                session.webExtensionController.setMessageDelegate(reader, this, "reader")
                session.open(host.runtime)
                val loader = GeckoSession.Loader().uri(url.toString()).additionalHeaders(headers)
                headers.entries.firstOrNull { it.key.equals("referer", true) }?.let { loader.referrer(it.value) }
                session.load(loader)
            } catch (_: Exception) { finish() }
        }, { finish() })
    }

    override fun onLoadRequest(session: GeckoSession, request: GeckoSession.NavigationDelegate.LoadRequest): GeckoResult<AllowOrDeny>? =
        if (request.target == GeckoSession.NavigationDelegate.TARGET_WINDOW_NEW || !matches(request.uri)) GeckoResult.deny() else null

    override fun onConnect(port: WebExtension.Port) {
        val sender = port.sender
        if (closed || sender.session !== session || !sender.isTopLevel || sender.webExtension.id != "reader@nodelane.net" ||
            sender.environmentType != WebExtension.MessageSender.ENV_TYPE_CONTENT_SCRIPT || !matches(sender.url)) {
            port.disconnect(); return
        }
        this.port = port
        sent = false
        port.setDelegate(this)
        dispatch()
    }
    override fun onDisconnect(port: WebExtension.Port) { if (this.port === port) this.port = null }
    override fun onPageStart(session: GeckoSession, url: String) { loaded = false; port = null }
    override fun onPageStop(session: GeckoSession, success: Boolean) { if (!success) finish() else { loaded = true; dispatch() } }
    override fun onCrash(session: GeckoSession) = finish()
    override fun onKill(session: GeckoSession) = finish()
    private fun dispatch() {
        val peer = port ?: return
        if (closed || sent || !loaded) return
        sent = true
        peer.postMessage(JSONObject().put("id", 1).put("url", peer.sender.url).put("operation", "sourcePage")
            .put("args", JSONObject().put("scripts", scripts)))
    }
    override fun onPortMessage(message: Any, port: WebExtension.Port) {
        if (this.port === port && sent && message is JSONObject) finish(message.opt("value") as? String)
    }
    fun finish(value: String? = null) {
        if (closed) return
        closed = true
        handler.removeCallbacks(timeout)
        host.sourcePages.remove(id, this)
        if (session.isOpen) session.close()
        result.success(value ?: "")
        host.startSourcePages()
    }
}
