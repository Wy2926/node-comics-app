package com.nodelane.comics

import androidx.annotation.NonNull
import libmtorrentserver.Libmtorrentserver
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import io.flutter.embedding.android.FlutterFragmentActivity
import android.app.UiModeManager
import android.content.Context
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.ColorSpace
import android.os.Build
import java.io.File

class MainActivity: FlutterFragmentActivity() {
    private var appUpdates: AppUpdateDownloads? = null
    private var browser: GeckoBrowser? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.kodjodevf.mangayomi.libmtorrentserver",
            StandardMethodCodec.INSTANCE,
            flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue()
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    val config = call.argument<String>("config")
                    try {
                        val port = Libmtorrentserver.start(config)
                        result.success(port)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        appUpdates = AppUpdateDownloads(this, flutterEngine.dartExecutor.binaryMessenger)
        val abis = if (android.os.Process.is64Bit()) android.os.Build.SUPPORTED_64_BIT_ABIS else android.os.Build.SUPPORTED_32_BIT_ABIS
        if (android.os.Build.VERSION.SDK_INT >= 26 && abis.firstOrNull() in setOf("arm64-v8a", "armeabi-v7a", "x86_64")) {
            browser = GeckoBrowser(this, flutterEngine.dartExecutor.binaryMessenger).also {
                flutterEngine.platformViewsController.registry.registerViewFactory(GeckoBrowser.TYPE, it)
            }
        }

        val messenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(
            messenger, "nodelane/translation_image", StandardMethodCodec.INSTANCE,
            messenger.makeBackgroundTaskQueue()
        ).setMethodCallHandler { call, result ->
            if (call.method != "srgbPng") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            if (Build.VERSION.SDK_INT < 26) {
                result.success(false)
                return@setMethodCallHandler
            }
            try {
                val options = BitmapFactory.Options().apply {
                    inScaled = false
                    inPreferredConfig = Bitmap.Config.ARGB_8888
                    inPreferredColorSpace = ColorSpace.get(ColorSpace.Named.SRGB)
                }
                val bitmap = checkNotNull(BitmapFactory.decodeFile(call.argument<String>("source"), options))
                try {
                    File(checkNotNull(call.argument<String>("output"))).outputStream().use {
                        check(bitmap.compress(Bitmap.CompressFormat.PNG, 100, it))
                    }
                } finally {
                    bitmap.recycle()
                }
                result.success(true)
            } catch (_: Exception) {
                result.error("INVALID_IMAGE", null, null)
            } catch (_: OutOfMemoryError) {
                result.error("INVALID_IMAGE", null, null)
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "nodelane/browser/charset")
            .setMethodCallHandler { call, result ->
                if (call.method == "gb18030") result.success((call.arguments as? ByteArray)?.toString(charset("GB18030")))
                else result.notImplemented()
            }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.kodjodevf.mangayomi.device",
            StandardMethodCodec.INSTANCE
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isTv" -> {
                    result.success(isTvDevice())
                }
                "hasGeckoBrowser" -> result.success(browser != null)
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // Reports whether this is an Android TV / leanback device. Used by the
    // Dart side to branch the UI on form factor (see #729). Kept conservative
    // so a phone is never misdetected as a TV: a phone has neither the
    // television UI mode nor the leanback feature.
    private fun isTvDevice(): Boolean {
        val uiModeManager = getSystemService(Context.UI_MODE_SERVICE) as? UiModeManager
        if (uiModeManager?.currentModeType == Configuration.UI_MODE_TYPE_TELEVISION) {
            return true
        }
        return packageManager.hasSystemFeature(PackageManager.FEATURE_LEANBACK)
    }

    override fun cleanUpFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        browser?.close()
        browser = null
        appUpdates?.close()
        appUpdates = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
