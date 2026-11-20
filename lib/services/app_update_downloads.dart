import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/services/app_update_manifest.dart';

enum UpdateDownloadPhase {
  queued,
  downloading,
  waiting,
  preparing,
  ready,
  failed,
}

enum UpdateInstallResult { opened, permissionRequired }

/// A platform-neutral snapshot. Native task IDs and file paths stay native.
class UpdateDownload {
  const UpdateDownload({
    required this.version,
    required this.build,
    required this.url,
    required this.phase,
    this.notes = '',
    this.received = 0,
    this.total = 0,
    this.fullSize = 0,
    this.sha256,
    this.isDelta = false,
    this.patchUrl,
    this.token,
  });

  final String version, url, notes;
  final int build;
  final UpdateDownloadPhase phase;
  final int received, total, fullSize;
  final String? sha256, patchUrl, token;
  final bool isDelta;
  Object get identity => token ?? (version, build, url, isDelta);
  bool get active => switch (phase) {
    UpdateDownloadPhase.queued ||
    UpdateDownloadPhase.downloading ||
    UpdateDownloadPhase.preparing ||
    UpdateDownloadPhase.waiting => true,
    _ => false,
  };
}

/// Optional capability, independent of release discovery and page lifetime.
abstract class AppUpdateDownloads {
  Future<UpdateDownload?> current();
  Future<UpdateDownload> start({
    required UpdateInfo release,
    required String title,
    UpdateDelta? delta,
  });
  Future<void> cancel(UpdateDownload download);
  Future<UpdateDownload?> discardFailed(UpdateDownload download);
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
          build: (value['build'] as num).toInt(),
          url: value['url'] as String,
          phase: UpdateDownloadPhase.values.byName(value['phase'] as String),
          notes: value['notes'] as String? ?? '',
          received: (value['received'] as num).toInt(),
          total: (value['total'] as num).toInt(),
          fullSize: (value['size'] as num?)?.toInt() ?? 0,
          sha256: value['sha256'] as String?,
          isDelta: value['delta'] == true,
          patchUrl: value['patchUrl'] as String?,
          token: value['token'] as String?,
        );

  @override
  Future<UpdateDownload?> current() async =>
      _decode(await _channel.invokeMapMethod('current'));

  @override
  Future<UpdateDownload> start({
    required UpdateInfo release,
    required String title,
    UpdateDelta? delta,
  }) async {
    return _decode(
      await _channel.invokeMapMethod('start', {
        'version': release.version,
        'build': release.build,
        'url': release.url,
        'title': '$title ${release.version}',
        'notes': release.notes,
        'size': release.size,
        'sha256': release.sha256,
        if (delta != null)
          'delta': {
            'version': delta.fromVersion,
            'build': delta.fromBuild,
            'base': delta.fromSha,
            'url': delta.url,
            'sha256': delta.sha256,
            'size': delta.size,
          },
      }),
    )!;
  }

  Map<String, Object?> _identity(UpdateDownload download) => {
    'version': download.version,
    'build': download.build,
    'url': download.url,
    'delta': download.isDelta,
    'token': download.token,
  };

  @override
  Future<void> cancel(UpdateDownload download) =>
      _channel.invokeMethod('cancel', _identity(download));

  @override
  Future<UpdateDownload?> discardFailed(UpdateDownload download) async =>
      _decode(
        await _channel.invokeMapMethod('discardFailed', _identity(download)),
      );

  @override
  Future<UpdateInstallResult> install(UpdateDownload download) async =>
      UpdateInstallResult.values.byName(
        (await _channel.invokeMethod<String>('install', _identity(download)))!,
      );
}
