package com.nodelane.comics

import android.content.Context
import android.util.Base64
import org.mozilla.geckoview.*
import java.security.MessageDigest
import java.util.UUID

internal class SourceCacheScope(context: Context) : WebExtension.MessageDelegate {
    private val prefs = context.getSharedPreferences("source-cache-scopes", Context.MODE_PRIVATE)
    private fun key(host: String) = Base64.encodeToString(
        MessageDigest.getInstance("SHA-256").digest(host.lowercase().toByteArray()), Base64.NO_WRAP)
    private fun next() = UUID.randomUUID().toString()
    private fun rotate(key: String) {
        if (prefs.contains(key)) prefs.edit().putString(key, next()).apply()
    }
    fun scope(hosts: List<String>): String {
        // Domain cookies apply to children (e.g. .pixiv.net -> www.pixiv.net).
        val keys = sortedSetOf<String>()
        for (host in hosts) {
            var domain = host
            do {
                keys.add(key(domain))
                domain = domain.substringAfter('.', "")
            } while (domain.contains('.'))
        }
        return keys.joinToString(":") { k -> prefs.getString(k, null) ?: next().also {
            prefs.edit().putString(k, it).apply()
        } }
    }
    fun cleared(host: String?) {
        if (host == null) prefs.all.keys.forEach(::rotate) else rotate(key(host))
    }
    override fun onMessage(nativeApp: String, message: Any, sender: WebExtension.MessageSender): GeckoResult<Any>? {
        if (sender.webExtension.id == "reader@nodelane.net" && sender.session == null &&
            sender.environmentType == WebExtension.MessageSender.ENV_TYPE_EXTENSION && message is String)
            rotate(key(message.trimStart('.')))
        return null
    }
}
