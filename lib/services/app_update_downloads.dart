import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/utils/platform_utils.dart';

enum UpdateDownloadPhase { queued, downloading, waiting, ready, failed }

enum UpdateInstallResult { opened, permissionRequired }

/// A platform-neutral snapshot. Native task IDs and file paths stay native.
class UpdateDownload {
  const UpdateDownload({
    required this.version,
    required this.url,
    required this.phase,
    this.notes = '',
    this.received = 0,
    this.total = 0,
  });

  final String version, url, notes;
  final UpdateDownloadPhase phase;
  final int received, total;
  bool get active => switch (phase) {
    UpdateDownloadPhase.queued ||
    UpdateDownloadPhase.downloading ||
    UpdateDownloadPhase.waiting => true,
    _ => false,
  };
}

/// Optional capability, independent of release discovery and page lifetime.
abstract class AppUpdateDownloads {
  Future<UpdateDownload?> current();
  Future<UpdateDownload> start({
    required String version,
    required List<String> assets,
    required String title,
    required String notes,
  });
  Future<void> cancel(UpdateDownload download);
  Future<UpdateInstallResult> install(UpdateDownload download);
}

final appUpdateDownloadsProvider = Provider<AppUpdateDownloads?>((ref) {
  return Platform.isAndroid ? AndroidAppUpdateDownloads() : null;
});

class AndroidAppUpdateDownloads implements AppUpdateDownloads {
  static const _channel = MethodChannel('com.nodelane.comics/app_updates');

  UpdateDownload? _decode(Map<Object?, Object?>? value) => value == null
      ? null
      : UpdateDownload(
          version: value['version'] as String,
          url: value['url'] as String,
          phase: UpdateDownloadPhase.values.byName(value['phase'] as String),
          notes: value['notes'] as String? ?? '',
          received: (value['received'] as num).toInt(),
          total: (value['total'] as num).toInt(),
        );

  @override
  Future<UpdateDownload?> current() async =>
      _decode(await _channel.invokeMapMethod('current'));

  @override
  Future<UpdateDownload> start({
    required String version,
    required List<String> assets,
    required String title,
    required String notes,
  }) async {
    final abis = (await DeviceInfoPlugin().androidInfo).supportedAbis;
    final url = selectAndroidUpdateAsset(assets, abis, androidTv: isTv);
    if (url == null) throw StateError('No compatible update package');
    return _decode(
      await _channel.invokeMapMethod('start', {
        'version': version,
        'url': url,
        'title': '$title $version',
        'notes': notes,
      }),
    )!;
  }

  Map<String, String> _identity(UpdateDownload download) => {
    'version': download.version,
    'url': download.url,
  };

  @override
  Future<void> cancel(UpdateDownload download) =>
      _channel.invokeMethod('cancel', _identity(download));

  @override
  Future<UpdateInstallResult> install(UpdateDownload download) async =>
      UpdateInstallResult.values.byName(
        (await _channel.invokeMethod<String>('install', _identity(download)))!,
      );
}

/// Never fall back to a known incompatible ABI or a TV/phone package.
String? selectAndroidUpdateAsset(
  List<String> assets,
  List<String> abis, {
  required bool androidTv,
}) {
  final candidates = assets.where((url) {
    final path = Uri.parse(url).path.toLowerCase();
    return path.endsWith('.apk') && path.contains('android-tv') == androidTv;
  }).toList();
  for (final abi in abis) {
    final suffix = '/${abi.toLowerCase()}.apk';
    final namedSuffix = '-${abi.toLowerCase()}.apk';
    for (final url in candidates) {
      final path = Uri.parse(url).path.toLowerCase();
      if (path.endsWith(suffix) || path.endsWith(namedSuffix)) {
        return url;
      }
    }
  }
  const knownAbis = ['arm64-v8a', 'armeabi', 'x86', 'arm64'];
  for (final url in candidates) {
    final path = Uri.parse(url).path.toLowerCase();
    if (!knownAbis.any(path.contains)) return url;
  }
  return null;
}
