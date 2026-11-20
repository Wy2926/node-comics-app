package com.nodelane.comics

import android.app.Activity
import android.app.DownloadManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.content.pm.PackageManager
import android.os.Environment
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import java.io.File
import java.util.concurrent.Executors
import java.util.concurrent.Future
import java.util.UUID

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
    private val isDelta get() = prefs.contains("patchUrl")
    private val transferFile get() = if (isDelta) File(destination.parentFile, "update.nld1") else destination
    private val transferUrl get() = checkNotNull(prefs.getString(if (isDelta) "patchUrl" else "url", null))
    private val installedApk get() = File(context.applicationInfo.sourceDir)
    private companion object {
        val lock = Any()
        val worker = Executors.newSingleThreadExecutor()
        var processing: Future<*>? = null
        val hashPattern = Regex("[0-9a-f]{64}")
    }

    init {
        channel.setMethodCallHandler { call, result ->
            try {
                synchronized(lock) {
                    when (call.method) {
                        "current" -> result.success(current())
                        "start" -> result.success(start(call))
                        "cancel" -> {
                            requireIdentity(call)
                            clear()
                            result.success(null)
                        }
                        "discardFailed" -> {
                            val task = current()
                            if (task?.get("phase") == "failed" && matchesIdentity(call)) {
                                clear()
                                result.success(null)
                            } else {
                                result.success(task)
                            }
                        }
                        "install" -> install(call, result)
                        else -> result.notImplemented()
                    }
                }
            } catch (error: Exception) {
                result.error("UPDATE_FAILED", "Update action failed", null)
            }
        }
    }

    fun close() = channel.setMethodCallHandler(null)

    private fun matchesIdentity(call: MethodCall) =
        call.argument<String>("version") == prefs.getString("version", null) &&
            call.argument<Number>("build")?.toLong() == prefs.getLong("build", 0) &&
            (call.argument<Boolean>("delta") == true) == isDelta &&
            call.argument<String>("token") == prefs.getString("token", null) &&
            call.argument<String>("url") == prefs.getString("url", null)

    private fun requireIdentity(call: MethodCall) {
        check(matchesIdentity(call)) { "The update task has changed" }
    }

    private fun clear() {
        processing?.cancel(true)
        processing = null
        val id = prefs.getLong("id", -1)
        if (id != -1L) downloads.remove(id)
        transferFile.delete()
        prefs.getString("token", null)?.let { File(destination.parentFile, "$it.tmp").delete() }
        destination.delete()
        check(prefs.edit().clear().commit()) { "Unable to clear update state" }
    }

    private fun installedVersion() =
        context.packageManager.getPackageInfo(context.packageName, 0)

    private fun current(): Map<String, Any>? {
        val version = prefs.getString("version", null) ?: return null
        // Installation is owned by Android; discard the old task once this app changes.
        if (prefs.getLong("installedAt", 0) != installedVersion().lastUpdateTime) {
            clear()
            return null
        }
        val url = transferUrl
        prefs.getString("finished", null)?.let {
            val size = prefs.getLong("size", 0)
            return snapshot(if (it == "ready" && (!destination.isFile || (size > 0 && destination.length() != size))) "failed" else it)
        }
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
                        (local == null || local == Uri.fromFile(transferFile).toString())) {
                        id = cursor.getLong(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_ID))
                        check(prefs.edit().putLong("id", id).commit())
                        break
                    }
                }
            }
        }
        downloads.query(DownloadManager.Query().setFilterById(id)).use { cursor ->
            if (!cursor.moveToFirst()) {
                if (isDelta) {
                    finish("failed")
                    return snapshot("failed")
                }
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
                DownloadManager.STATUS_SUCCESSFUL -> when {
                    !transferFile.isFile || transferFile.length() == 0L -> "failed"
                    prefs.contains("sha256") -> {
                        prepare()
                        "preparing"
                    }
                    else -> "ready"
                }
                else -> "failed"
            }
            if (phase == "failed") finish(phase)
            return snapshot(phase, received.coerceAtLeast(0), total.coerceAtLeast(0))
        }
    }

    private fun snapshot(phase: String, received: Long = 0, total: Long = 0): Map<String, Any> =
        buildMap {
            put("version", prefs.getString("version", "")!!)
            put("url", prefs.getString("url", "")!!)
            put("phase", phase)
            put("build", prefs.getLong("build", 0))
            put("notes", prefs.getString("notes", "")!!)
            put("received", received)
            put("total", total)
            put("delta", isDelta)
            prefs.getString("token", null)?.let { put("token", it) }
            prefs.getString("patchUrl", null)?.let { put("patchUrl", it) }
            put("size", prefs.getLong("size", 0))
            prefs.getString("sha256", null)?.let { put("sha256", it) }
        }

    private fun finish(phase: String) {
        check(prefs.edit().putString("finished", phase).commit())
        if (isDelta || phase == "failed") {
            val id = prefs.getLong("id", -1)
            if (id != -1L) downloads.remove(id)
            transferFile.delete()
        }
    }

    // Recovery restarts only the local verification/assembly, never the network request.
    private fun prepare() {
        if (processing?.isDone == false) return
        val token = checkNotNull(prefs.getString("token", null))
        val sha = checkNotNull(prefs.getString("sha256", null))
        val size = prefs.getLong("size", 0)
        val patchSha = prefs.getString("patchSha", null)
        val patchSize = prefs.getLong("patchSize", 0)
        val version = prefs.getString("version", null)
        val build = prefs.getLong("build", 0)
        val input = transferFile
        val temp = File(destination.parentFile, "$token.tmp")
        processing = worker.submit {
            try {
                if (patchSha != null) {
                    check(input.length() == patchSize && ApkDelta.sha256(input) == patchSha)
                    ApkDelta.apply(installedApk, input, temp, size, sha)
                } else {
                    check((size == 0L || input.length() == size) && ApkDelta.sha256(input) == sha)
                }
                @Suppress("DEPRECATION")
                val flags = if (patchSha == null) 0 else PackageManager.GET_SIGNATURES
                val apk = if (patchSha == null) input else temp
                val archive = checkNotNull(context.packageManager.getPackageArchiveInfo(apk.path, flags))
                check(archive.packageName == context.packageName &&
                    archive.versionName?.trimStart('v', 'V') == version?.trimStart('v', 'V') &&
                    (build == 0L || androidx.core.content.pm.PackageInfoCompat.getLongVersionCode(archive) == build))
                // A full APK can legitimately use a signing lineage; Android checks it on install.
                if (patchSha != null) {
                    @Suppress("DEPRECATION")
                    val installed = context.packageManager.getPackageInfo(context.packageName, flags).signatures
                    @Suppress("DEPRECATION")
                    check(!installed.isNullOrEmpty() && installed.toSet() == archive.signatures?.toSet())
                }
                synchronized(lock) {
                    if (token == prefs.getString("token", null)) {
                        if (patchSha != null) check(temp.renameTo(destination))
                        finish("ready")
                    }
                }
            } catch (_: Exception) {
                synchronized(lock) {
                    if (token == prefs.getString("token", null)) finish("failed")
                }
            } finally {
                temp.delete()
            }
        }
    }

    private fun start(call: MethodCall): Map<String, Any> {
        val version = checkNotNull(call.argument<String>("version"))
        val url = checkNotNull(call.argument<String>("url"))
        val build = checkNotNull(call.argument<Number>("build")).toLong()
        fun web(value: String): Uri = Uri.parse(value).also {
            require(it.scheme in listOf("https", "http") && !it.host.isNullOrEmpty())
        }
        web(url)
        val size = call.argument<Number>("size")?.toLong() ?: 0L
        val sha = call.argument<String>("sha256")
        require(size >= 0 && (sha == null || hashPattern.matches(sha)))
        val delta = call.argument<Map<String, Any>>("delta")
        val existing = current()
        if (existing != null && existing["phase"] != "failed") {
            // Starting a different version must not silently cancel an active task.
            check(existing["version"] == version && existing["url"] == url &&
                existing["build"] == build) {
                "Another update is already downloaded or downloading"
            }
            return existing
        }
        if (existing != null && existing["delta"] == true) {
            check(delta == null && url == existing["url"] && build == existing["build"] && version == existing["version"])
        }
        clear()
        check(destination.parentFile!!.mkdirs() || destination.parentFile!!.isDirectory)
        val installed = installedVersion()
        val state = prefs.edit().putString("version", version).putString("url", url)
            .putLong("build", build).putLong("installedAt", installed.lastUpdateTime)
            .putLong("size", size).putString("sha256", sha).putString("token", UUID.randomUUID().toString())
            .putString("notes", call.argument<String>("notes") ?: "")
        if (delta != null) {
            val base = delta["base"] as String
            val patchSha = delta["sha256"] as String
            val patchSize = (delta["size"] as Number).toLong()
            val patchUrl = delta["url"] as String
            web(patchUrl)
            require(sha != null && size > 0 && patchSize > 0 && patchSize < size &&
                hashPattern.matches(base) && hashPattern.matches(patchSha))
            state.putString("patchUrl", patchUrl).putString("patchSha", patchSha).putLong("patchSize", patchSize)
            if (installed.versionName != delta["version"] ||
                androidx.core.content.pm.PackageInfoCompat.getLongVersionCode(installed) != (delta["build"] as Number).toLong() ||
                !context.applicationInfo.splitSourceDirs.isNullOrEmpty() ||
                destination.parentFile!!.usableSpace - patchSize < size ||
                ApkDelta.sha256(installedApk) != base) {
                check(state.putString("finished", "failed").commit())
                return snapshot("failed")
            }
        }
        check(state.commit())
        // Leave an uncertain enqueue for current() to reconcile before retrying.
        val request = DownloadManager.Request(web(transferUrl))
            .setTitle(call.argument<String>("title") ?: "NodeLane Comics")
            .setDescription(version)
            .setMimeType(if (isDelta) "application/octet-stream" else "application/vnd.android.package-archive")
            .setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
            .setDestinationInExternalFilesDir(context, Environment.DIRECTORY_DOWNLOADS, "app-updates/${transferFile.name}")
        val id = downloads.enqueue(request)
        check(prefs.edit().putLong("id", id).commit()) { "Unable to save update state" }
        return checkNotNull(current())
    }

    private fun install(call: MethodCall, result: MethodChannel.Result) {
        requireIdentity(call)
        check(current()?.get("phase") == "ready") { "No downloaded update" }
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
