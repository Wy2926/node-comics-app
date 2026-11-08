import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:http/http.dart' as http;
import 'package:mangayomi/utils/nodelane_brand.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'check_for_update.g.dart';

@riverpod
class CheckForAppUpdates extends _$CheckForAppUpdates {
  @override
  bool build() {
    return settingsRepository.current.checkForAppUpdates ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.checkForAppUpdates = value);
  }
}

/// Convenience alias: (version, body, htmlUrl, assets).
typedef UpdateInfo = (String, String, String, List<dynamic>);

/// Automatic update-check provider.
///
/// Respects the user's [checkForAppUpdatesProvider] preference.  Returns
/// [UpdateInfo] when a newer version exists and downloadable assets are ready,
/// `null` otherwise.
@riverpod
Future<UpdateInfo?> checkForUpdate(Ref ref) async {
  if (!ref.read(checkForAppUpdatesProvider)) return null;
  return _getUpdateIfAvailable();
}

/// Compares the running version against the latest release for this platform.
/// Returns [UpdateInfo] when an update is available and assets for the current
/// platform are ready, or `null` when already up-to-date or assets are still building.
Future<UpdateInfo?> _getUpdateIfAvailable() async {
  final info = await PackageInfo.fromPlatform();
  if (kDebugMode) {
    log(info.data.toString());
  }
  final latest = await fetchLatestAppRelease();
  if (latest == null) {
    return null;
  }
  if (compareVersions(info.version, latest.$1) >= 0) {
    return null;
  }
  return latest;
}

/// Validates that release assets for the current platform are present.
/// Avoids notifying users while CI build workflows are still running.
bool _hasPlatformAssets(
  List<String> assets, {
  required String platform,
  required bool androidTv,
}) {
  if (assets.isEmpty) return false;

  final assetUrls = assets.map((url) => url.toLowerCase()).toList();

  if (platform == 'android') {
    if (androidTv) {
      return assetUrls.any(
        (url) => url.endsWith('.apk') && url.contains('android-tv'),
      );
    }
    return assetUrls.any(
      (url) => url.endsWith('.apk') && !url.contains('android-tv'),
    );
  } else if (platform == 'ios') {
    return assetUrls.any((url) => url.endsWith('.ipa'));
  } else if (platform == 'macos') {
    return assetUrls.any((url) => url.endsWith('.dmg') || url.endsWith('.pkg'));
  } else if (platform == 'windows') {
    return assetUrls.any(
      (url) =>
          url.endsWith('.exe') ||
          url.endsWith('.msix') ||
          (url.endsWith('.zip') && url.contains('windows')),
    );
  } else if (platform == 'linux') {
    return assetUrls.any(
      (url) =>
          url.endsWith('.appimage') ||
          url.endsWith('.deb') ||
          url.endsWith('.rpm') ||
          (url.endsWith('.zip') && url.contains('linux')),
    );
  }
  return true;
}

/// Manual checks ignore the launch preference; the page owns their result.
final manualAppUpdateCheckProvider = Provider<Future<UpdateInfo?> Function()>(
  (ref) => _getUpdateIfAvailable,
);

@visibleForTesting
Future<UpdateInfo?> fetchLatestAppRelease({
  http.Client? client,
  String? platform,
  bool? androidTv,
}) async {
  try {
    final request =
        client ?? MClient.init(reqcopyWith: {'useDartHttpClient': true});
    final target = platform ?? Platform.operatingSystem;
    final tv = androidTv ?? (target == 'android' && isTv);
    final timer = Stopwatch()..start();
    final versionPattern = RegExp(
      r'^[vV]?((?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*))$',
    );
    UpdateInfo? latest;
    for (var page = 1; ; page++) {
      final remaining = const Duration(seconds: 20) - timer.elapsed;
      if (remaining <= Duration.zero) {
        throw TimeoutException('Release check timed out');
      }
      final res = await request
          .get(
            Uri.parse(NodeLaneBrand.releasesApi)
                .replace(queryParameters: {'per_page': '100', 'page': '$page'}),
            headers: {'Accept': 'application/vnd.github+json'},
          )
          .timeout(remaining);
      if (res.statusCode == 404 && page == 1) return null;
      if (res.statusCode != 200) {
        throw const FormatException('Release check failed');
      }
      final releases = jsonDecode(res.body);
      if (releases is! List) {
        throw const FormatException('Expected a release list');
      }
      for (final release in releases) {
        if (release is! Map<String, dynamic>) {
          throw const FormatException('Invalid release');
        }
        if (release['draft'] == true || release['prerelease'] == true) continue;
        final version = versionPattern
            .firstMatch(release['tag_name'] as String? ?? '')
            ?.group(1);
        if (version == null) continue;

        final rawAssets = release['assets'] as List<dynamic>? ?? [];
        final assets = rawAssets
            .where((asset) => asset['state'] == 'uploaded')
            .map((asset) => asset['browser_download_url'] as String?)
            .whereType<String>()
            .toList();
        if (!_hasPlatformAssets(assets, platform: target, androidTv: tv)) {
          continue;
        }
        // Releases may be published per platform or backported out of order.
        if (latest == null || compareVersions(version, latest.$1) > 0) {
          latest = (
            version,
            (release['body'] as String?) ?? '',
            (release['html_url'] as String?) ?? '',
            assets,
          );
        }
      }

      if (releases.length < 100) return latest;
    }
  } catch (e, st) {
    if (kDebugMode) {
      log('Error fetching latest release: $e\n$st');
    }
    rethrow;
  }
}
