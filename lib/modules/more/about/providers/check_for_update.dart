import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/app_update_feed.dart';
import 'package:mangayomi/services/app_update_manifest.dart';
import 'package:mangayomi/utils/nodelane_brand.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'check_for_update.g.dart';

@riverpod
class CheckForAppUpdates extends _$CheckForAppUpdates {
  @override
  bool build() => settingsRepository.current.checkForAppUpdates ?? true;

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.checkForAppUpdates = value);
  }
}

final _appUpdateFeedProvider = Provider<AppUpdateFeed>((ref) {
  final feed = AppUpdateFeed(
    uri: Uri.parse(NodeLaneBrand.updateManifestUrl),
    cacheFile: () async => File(
      '${(await getApplicationSupportDirectory()).path}/app-update-manifest.json',
    ),
  );
  ref.onDispose(feed.close);
  return feed;
});

@riverpod
Future<UpdateInfo?> checkForUpdate(Ref ref) async {
  if (!ref.read(checkForAppUpdatesProvider)) return null;
  return _getUpdateIfAvailable(ref.read(_appUpdateFeedProvider));
}

/// Manual checks bypass the automatic interval and revalidate the static feed.
final manualAppUpdateCheckProvider = Provider<Future<UpdateInfo?> Function()>(
  (ref) =>
      () =>
          _getUpdateIfAvailable(ref.read(_appUpdateFeedProvider), force: true),
);

Future<UpdateInfo?> _getUpdateIfAvailable(
  AppUpdateFeed feed, {
  bool force = false,
}) async {
  final info = await PackageInfo.fromPlatform();
  final abis = Platform.isAndroid
      ? (await DeviceInfoPlugin().androidInfo).supportedAbis
      : const <String>[];
  return selectAppUpdate(
    await feed.load(force: force),
    platform: Platform.operatingSystem,
    currentVersion: info.version,
    currentBuild: Platform.isAndroid ? int.parse(info.buildNumber) : 0,
    androidAbis: abis,
    androidTv: isTv,
  );
}
