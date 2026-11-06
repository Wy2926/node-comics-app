package com.nodelane.comics

import android.app.Activity
import android.app.DownloadManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import java.io.File

/** One app-update download owned by the OS, never by a Flutter page. */
class AppUpdateDownloads(private val activity: Activity, messenger: BinaryMessenger) {
    private val context = activity.applicationContext
    private val downloads = context.getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
    // Device-local OS handles must not be restored by backup/device transfer.
    private val prefs = context.getSharedPreferences("app_update_download", Context.MODE_PRIVATE)
    private val channel = MethodChannel(
        messenger, "com.nodelane.comics/app_updates", StandardMethodCodec.INSTANCE,
        messenger.makeBackgroundTaskQueue()
    )
    private val destination: File
        get() = File(checkNotNull(context.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS)),
            "app-updates/update.apk")

    init {
        channel.setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "current" -> result.success(current())
                    "start" -> result.success(start(call))
                    "cancel" -> {
                        requireIdentity(call)
                        clear()
                        result.success(null)
                    }
                    "install" -> install(call, result)
                    else -> result.notImplemented()
                }
            } catch (error: Exception) {
                result.error("UPDATE_FAILED", error.message, null)
            }
        }
    }

    fun close() = channel.setMethodCallHandler(null)

    private fun requireIdentity(call: MethodCall) {
        check(call.argument<String>("version") == prefs.getString("version", null) &&
            call.argument<String>("url") == prefs.getString("url", null)) {
            "The update task has changed"
        }
    }

    private fun clear() {
        val id = prefs.getLong("id", -1)
        if (id != -1L) downloads.remove(id)
        destination.delete()
        check(prefs.edit().clear().commit()) { "Unable to clear update state" }
    }

    private fun installedVersion() =
        context.packageManager.getPackageInfo(context.packageName, 0)

    private fun alreadyInstalled(version: String): Boolean {
        fun parts(value: String?): List<Int>? {
            return value?.split('.')?.map { it.toIntOrNull() ?: return null }
        }
        val installed = parts(installedVersion().versionName) ?: return false
        val target = parts(version) ?: return false
        for (index in 0 until maxOf(installed.size, target.size)) {
            val comparison = (installed.getOrElse(index) { 0 }).compareTo(target.getOrElse(index) { 0 })
            if (comparison != 0) return comparison > 0
        }
        return true
    }

    private fun current(): Map<String, Any>? {
        val version = prefs.getString("version", null) ?: return null
        if (alreadyInstalled(version)) {
            clear()
            return null
        }
        val url = checkNotNull(prefs.getString("url", null))
        var id = prefs.getLong("id", -1)
        // Recover the narrow process-death window between enqueue and saving ID.
        if (id == -1L) {
            downloads.query(DownloadManager.Query()).use { cursor ->
                while (cursor.moveToNext()) {
                    val candidateUrl = cursor.getString(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_URI))
                    val local = cursor.getString(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_LOCAL_URI))
                    val description = cursor.getString(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_DESCRIPTION))
                    // A queued/retrying download may not have a local URI yet.
                    if (candidateUrl == url && description == version &&
                        (local == null || local == Uri.fromFile(destination).toString())) {
                        id = cursor.getLong(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_ID))
                        check(prefs.edit().putLong("id", id).commit())
                        break
                    }
                }
            }
        }
        downloads.query(DownloadManager.Query().setFilterById(id)).use { cursor ->
            if (!cursor.moveToFirst()) {
                clear()
                return null
            }
            val status = cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_STATUS))
            val received = cursor.getLong(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR))
            val total = cursor.getLong(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_TOTAL_SIZE_BYTES))
            val phase = when (status) {
                DownloadManager.STATUS_PENDING -> "queued"
                DownloadManager.STATUS_RUNNING -> "downloading"
                DownloadManager.STATUS_PAUSED -> "waiting"
                DownloadManager.STATUS_SUCCESSFUL -> if (validPackage(version, total)) "ready" else "failed"
                else -> "failed"
            }
            return mapOf("version" to version, "url" to url, "phase" to phase,
                "notes" to (prefs.getString("notes", "") ?: ""),
                "received" to received.coerceAtLeast(0), "total" to total.coerceAtLeast(0))
        }
    }

    private fun start(call: MethodCall): Map<String, Any> {
        val version = checkNotNull(call.argument<String>("version"))
        val url = checkNotNull(call.argument<String>("url"))
        val uri = Uri.parse(url)
        val debug = context.applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE != 0
        require(uri.scheme == "https" || (debug && uri.scheme == "http" &&
            uri.host in listOf("10.0.2.2", "127.0.0.1", "localhost"))) { "HTTPS is required" }
        require(Regex("[0-9]+\\.[0-9]+\\.[0-9]+").matches(version) && !alreadyInstalled(version)) {
            "Expected a newer app version"
        }
        val existing = current()
        if (existing != null && existing["phase"] != "failed") {
            // Starting a different version must not silently cancel an active task.
            check(existing["version"] == version && existing["url"] == url) {
                "Another update is already downloaded or downloading"
            }
            return existing
        }
        clear()
        check(destination.parentFile!!.mkdirs() || destination.parentFile!!.isDirectory)
        check(prefs.edit().putString("version", version).putString("url", url)
            .putString("notes", call.argument<String>("notes") ?: "").commit())
        // Leave an uncertain enqueue for current() to reconcile before retrying.
        val request = DownloadManager.Request(uri)
            .setTitle(call.argument<String>("title") ?: "NodeLane Comics")
            .setDescription(version)
            .setMimeType("application/vnd.android.package-archive")
            .setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
            .setDestinationInExternalFilesDir(context, Environment.DIRECTORY_DOWNLOADS, "app-updates/update.apk")
        val id = downloads.enqueue(request)
        check(prefs.edit().putLong("id", id).commit()) { "Unable to save update state" }
        return checkNotNull(current())
    }

    @Suppress("DEPRECATION")
    private fun validPackage(version: String, total: Long): Boolean {
        val file = destination
        if (!file.isFile || file.length() <= 0 || (total > 0 && file.length() != total)) return false
        val archive = context.packageManager.getPackageArchiveInfo(file.path, 0) ?: return false
        val installed = installedVersion()
        val archiveCode = if (Build.VERSION.SDK_INT >= 28) archive.longVersionCode else archive.versionCode.toLong()
        val installedCode = if (Build.VERSION.SDK_INT >= 28) installed.longVersionCode else installed.versionCode.toLong()
        return archive.packageName == context.packageName && archive.versionName == version && archiveCode > installedCode
    }

    private fun install(call: MethodCall, result: MethodChannel.Result) {
        requireIdentity(call)
        check(current()?.get("phase") == "ready") { "No valid downloaded update" }
        activity.runOnUiThread {
            try {
                check(!activity.isFinishing && !activity.isDestroyed) { "Update page is unavailable" }
                if (Build.VERSION.SDK_INT >= 26 && !context.packageManager.canRequestPackageInstalls()) {
                    activity.startActivity(Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                        Uri.parse("package:${context.packageName}")))
                    result.success("permissionRequired")
                } else {
                    val uri = FileProvider.getUriForFile(context, "${context.packageName}.fileprovider", destination)
                    activity.startActivity(Intent(Intent.ACTION_VIEW)
                        .setDataAndType(uri, "application/vnd.android.package-archive")
                        .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION))
                    result.success("opened")
                }
            } catch (error: Exception) {
                result.error("INSTALL_FAILED", error.message, null)
            }
        }
    }
}
