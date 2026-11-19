package eu.kanade.tachiyomi.network.interceptor

import okhttp3.HttpUrl
import okhttp3.Interceptor
import okhttp3.Response

// Extensions locate this interceptor by class and may construct it using either upstream signature.
class UserAgentInterceptor(
    private val userAgentFor: (HttpUrl) -> String,
    private val hasVerifiedSession: (String) -> Boolean,
) : Interceptor {
    constructor(provider: (HttpUrl) -> String) : this(provider, { false })
    constructor(provider: () -> String) : this({ _: HttpUrl -> provider() })

    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()
        if (!request.header("User-Agent").isNullOrBlank() && !hasVerifiedSession(request.url.host)) {
            return chain.proceed(request)
        }
        val fallback = userAgentFor(request.url).trim()
        return chain.proceed(
            if (fallback.isEmpty()) request else request.newBuilder().header("User-Agent", fallback).build(),
        )
    }
}
