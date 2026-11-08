import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UpdateDownloadPhase { queued, downloading, waiting, ready, failed }

enum UpdateInstallResult { opened, permissionRequired }

/// A platform-neutral snapshot. Native task IDs and file paths stay native.
class UpdateDownload {
  const UpdateDownload({
    required this.version,
    required this.build,
    required this.sha256,
    required this.url,
    required this.phase,
    this.notes = '',
    this.received = 0,
    this.total = 0,
  });

  final String version, url, notes, sha256;
  final int build;
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
    required int build,
    required String url,
    required String sha256,
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
          build: (value['build'] as num).toInt(),
          sha256: value['sha256'] as String,
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
    required int build,
    required String url,
    required String sha256,
    required String title,
    required String notes,
  }) async {
    return _decode(
      await _channel.invokeMapMethod('start', {
        'version': version,
        'build': build,
        'sha256': sha256,
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
