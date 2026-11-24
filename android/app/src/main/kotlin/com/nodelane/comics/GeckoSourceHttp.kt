package com.nodelane.comics

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mozilla.geckoview.GeckoRuntime
import org.mozilla.geckoview.GeckoResult
import org.mozilla.geckoview.GeckoWebExecutor
import org.mozilla.geckoview.WebRequest
import org.mozilla.geckoview.WebResponse
import java.io.InputStream
import java.net.URI
import java.nio.ByteBuffer
import java.util.concurrent.CompletableFuture

/** One HTTP hop in the browser profile. Gecko alone selects and stores the site's cookies. */
internal class GeckoSourceHttp(messenger: BinaryMessenger, val runtime: () -> GeckoRuntime) {
    private val channel = MethodChannel(messenger, "nodelane/browser/source-http")
    private val main = Handler(Looper.getMainLooper())
    private val executor by lazy { GeckoWebExecutor(runtime()) }
    private var next = 0L
    private val calls = mutableMapOf<Long, Exchange>()
    private inner class Exchange(val id: Long, var pending: MethodChannel.Result?) {
        var opening: GeckoResult<WebResponse>? = null
        var stream: InputStream? = null
        val expire = Runnable { finish("timeout") }
        fun arm() { main.removeCallbacks(expire); main.postDelayed(expire, 30_000) }
        fun finish(error: String? = null) {
            main.removeCallbacks(expire)
            calls.remove(id)
            opening?.cancel()
            opening = null
            runCatching { stream?.close() }
            stream = null
            pending?.error(error ?: "closed", null, null)
            pending = null
        }
    }

    init {
        channel.setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "open" -> open(call, result)
                    "read" -> read(calls[(call.arguments as Number).toLong()], result)
                    "close" -> {
                        calls[(call.arguments as Number).toLong()]?.finish()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (_: Exception) { result.error("request", null, null) }
        }
    }

    private fun open(call: MethodCall, result: MethodChannel.Result) {
        val uri = URI(checkNotNull(call.argument<String>("url")))
        require(uri.host != null && uri.rawUserInfo == null && uri.scheme in setOf("http", "https"))
        val method = call.argument<String>("method")
        require(method in setOf("GET", "HEAD", "POST", "PUT", "PATCH", "DELETE"))
        val request = WebRequest.Builder(uri.toASCIIString()).method(checkNotNull(method))
        for ((key, value) in call.argument<Map<String, String>>("headers").orEmpty()) {
            require('\r' !in value && '\n' !in value)
            when (key.lowercase()) {
                "host", "cookie", "cookie2", "connection", "content-length", "transfer-encoding",
                "accept-encoding", "proxy-authorization" -> continue
                "referer" -> request.referrer(value)
                else -> request.header(key, value)
            }
        }
        call.argument<ByteArray>("body")?.takeIf { it.isNotEmpty() }?.let {
            request.body(ByteBuffer.allocateDirect(it.size).apply { put(it); flip() })
        }
        val flags = GeckoWebExecutor.FETCH_FLAGS_NO_REDIRECTS or
            (if (call.argument<Boolean>("anonymous") == true) GeckoWebExecutor.FETCH_FLAGS_ANONYMOUS else 0)
        val fetch = executor.fetch(request.build(), flags)
        val exchange = Exchange(++next, result)
        exchange.opening = fetch
        calls[exchange.id] = exchange
        exchange.arm()
        fetch.accept({ response ->
            exchange.opening = null
            if (response == null) { exchange.finish("request"); return@accept }
            if (calls[exchange.id] !== exchange) { response.body?.close(); return@accept }
            response.setReadTimeoutMillis(30_000)
            exchange.stream = response.body
            exchange.pending = null
            exchange.arm()
            result.success(mapOf("id" to exchange.id, "status" to response.statusCode,
                "headers" to response.headers.mapKeys { it.key.lowercase() }
                    .filterKeys { it != "set-cookie" && it != "set-cookie2" }))
        }, { exchange.opening = null; exchange.finish("network") })
    }

    private fun read(exchange: Exchange?, result: MethodChannel.Result) {
        if (exchange == null || exchange.pending != null) { result.error("closed", null, null); return }
        val input = exchange.stream
        if (input == null) { exchange.finish(); result.success(null); return }
        exchange.pending = result
        exchange.arm()
        CompletableFuture.supplyAsync {
            val bytes = ByteArray(64 * 1024)
            val count = input.read(bytes)
            if (count < 0) null else if (count == bytes.size) bytes else bytes.copyOf(count)
        }.whenComplete { bytes, error -> main.post {
            if (exchange.pending !== result) return@post
            if (error != null) { exchange.finish("network"); return@post }
            exchange.pending = null
            if (bytes == null) exchange.finish() else exchange.arm()
            result.success(bytes)
        } }
    }

    fun close() {
        channel.setMethodCallHandler(null)
        calls.values.toList().forEach { it.finish() }
    }
}
