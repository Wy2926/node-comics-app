package eu.kanade.tachiyomi.network

import android.content.Context
import eu.kanade.tachiyomi.network.interceptor.UserAgentInterceptor
import okhttp3.Protocol
import okhttp3.Request
import okhttp3.Response
import okhttp3.ResponseBody.Companion.toResponseBody
import org.mockito.Mockito.mock
import kotlin.test.Test
import kotlin.test.assertEquals

class SourceUserAgentTest {
    @Test
    fun sourceRequestsKeepTheirOwnIdentityUnlessTheHostHasAVerifiedSession() {
        val network = NetworkHelper(mock(Context::class.java))
        network.setUA("WebView/1")
        val client = network.client.newBuilder().addInterceptor { chain ->
            val request = chain.request()
            Response.Builder().request(request).protocol(Protocol.HTTP_1_1).code(200).message("OK")
                .body(request.header("User-Agent").orEmpty().toResponseBody()).build()
        }.build()
        fun sent(host: String, ua: String? = null): String {
            val request = Request.Builder().url("https://$host/")
            if (ua != null) request.header("User-Agent", ua)
            return client.newCall(request.build()).execute().use { it.body.string() }
        }
        try {
            network.client.interceptors.filterIsInstance<UserAgentInterceptor>().single()
            assertEquals("Extension/2", sent("api.example.test", "Extension/2"))
            assertEquals("Desktop reader/3", sent("reader.example.test", "Desktop reader/3"))
            assertEquals("WebView/1", sent("reader.example.test"))
            network.setSolvedUA("reader.example.test", "Verified/4")
            assertEquals("Verified/4", sent("reader.example.test", "Desktop reader/3"))
            assertEquals("Extension/2", sent("api.example.test", "Extension/2"))
        } finally {
            client.cache?.close()
            client.cache?.directory?.deleteRecursively()
        }
    }
}
