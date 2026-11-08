import 'dart:convert';

import 'package:mangayomi/utils/nodelane_brand.dart';
import 'package:mangayomi/utils/version.dart';

/// One installable target, independent of transport and installation.
class UpdateInfo {
  const UpdateInfo({
    required this.version,
    required this.build,
    required this.url,
    required this.sha256,
    this.platform = 'android',
    this.arch = 'universal',
    this.notes = '',
    this.pageUrl = '',
  });
  final String version, platform, arch, notes, pageUrl, url, sha256;
  final int build;
}

List<UpdateInfo> parseAppUpdateManifest(String body) {
  final root = jsonDecode(body);
  if (root is! Map<String, dynamic> ||
      root['schema'] != 1 ||
      root['updates'] is! List) {
    throw const FormatException('Invalid update manifest');
  }
  final result = <UpdateInfo>[];
  for (final entry in root['updates'] as List) {
    if (entry is! Map<String, dynamic> ||
        entry['version'] is! String ||
        !RegExp(r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$')
            .hasMatch(entry['version'] as String) ||
        entry['build'] is! int ||
        (entry['build'] as int) <= 0 ||
        !const {
          'android',
          'android-tv',
          'ios',
          'macos',
          'windows',
          'linux',
        }.contains(entry['platform']) ||
        entry['arch'] is! String ||
        entry['notes'] is! String ||
        entry['sha256'] is! String ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(entry['sha256'] as String) ||
        !_isReleaseUrl(entry['url'], 'download') ||
        !_isReleaseUrl(entry['page_url'], 'tag')) {
      throw const FormatException('Invalid update entry');
    }
    final platform = entry['platform'] as String;
    final arch = entry['arch'] as String;
    if (platform.startsWith('android')
        ? !const {
            'arm64-v8a',
            'armeabi-v7a',
            'x86_64',
            'x86',
            'universal',
          }.contains(arch)
        : arch != 'any') {
      throw const FormatException('Invalid update architecture');
    }
    result.add(
      UpdateInfo(
        version: entry['version'] as String,
        build: entry['build'] as int,
        platform: platform,
        arch: arch,
        notes: entry['notes'] as String,
        pageUrl: entry['page_url'] as String,
        url: entry['url'] as String,
        sha256: entry['sha256'] as String,
      ),
    );
  }
  return result;
}

bool _isReleaseUrl(Object? value, String kind) {
  if (value is! String) return false;
  final uri = Uri.tryParse(value);
  return uri != null &&
      uri.scheme == 'https' &&
      uri.host == 'github.com' &&
      uri.userInfo.isEmpty &&
      !uri.hasPort &&
      !uri.hasQuery &&
      !uri.hasFragment &&
      uri.path.startsWith('/${NodeLaneBrand.repository}/releases/$kind/');
}

UpdateInfo? selectAppUpdate(
  List<UpdateInfo> updates, {
  required String platform,
  required String currentVersion,
  required int currentBuild,
  List<String> androidAbis = const [],
  bool androidTv = false,
}) {
  final target = platform == 'android' && androidTv ? 'android-tv' : platform;
  final abis = [...androidAbis, 'universal'];
  UpdateInfo? latest;
  for (final update in updates) {
    if (update.platform != target ||
        compareVersions(update.version, currentVersion) <= 0) {
      continue;
    }
    if (platform == 'android' &&
        (!abis.contains(update.arch) || update.build <= currentBuild)) {
      continue;
    }
    final order = latest == null
        ? 1
        : compareVersions(update.version, latest.version);
    if (order > 0 ||
        (order == 0 &&
            platform == 'android' &&
            abis.indexOf(update.arch) < abis.indexOf(latest!.arch))) {
      latest = update;
    }
  }
  return latest;
}
