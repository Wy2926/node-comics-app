import 'dart:convert';

import 'package:mangayomi/utils/version.dart';

/// One installable target, independent of transport and installation.
class UpdateInfo {
  const UpdateInfo({
    required this.version,
    required this.url,
    this.build = 0,
    this.platform = 'android',
    this.arch = 'universal',
    this.notes = '',
    this.pageUrl = '',
  });
  final String version, platform, arch, notes, pageUrl, url;
  final int build;

  String get externalUrl => pageUrl.isEmpty ? url : pageUrl;
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
        !RegExp(
          r'^[vV]?\d+(?:\.\d+)*(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$',
        ).hasMatch(entry['version'] as String) ||
        (entry['build'] != null &&
            (entry['build'] is! int || (entry['build'] as int) < 0)) ||
        entry['platform'] is! String ||
        (entry['platform'] as String).isEmpty ||
        (entry['arch'] != null &&
            (entry['arch'] is! String || (entry['arch'] as String).isEmpty)) ||
        (entry['notes'] != null && entry['notes'] is! String) ||
        !_isWebUrl(entry['url']) ||
        (entry['page_url'] != null &&
            entry['page_url'] != '' &&
            !_isWebUrl(entry['page_url']))) {
      throw const FormatException('Invalid update entry');
    }
    final platform = entry['platform'] as String;
    result.add(
      UpdateInfo(
        version: entry['version'] as String,
        build: entry['build'] as int? ?? 0,
        platform: platform,
        arch:
            entry['arch'] as String? ??
            (platform.startsWith('android') ? 'universal' : 'any'),
        notes: entry['notes'] as String? ?? '',
        pageUrl: entry['page_url'] as String? ?? '',
        url: entry['url'] as String,
      ),
    );
  }
  return result;
}

bool _isWebUrl(Object? value) {
  if (value is! String) return false;
  final uri = Uri.tryParse(value);
  return uri != null &&
      (uri.scheme == 'https' || uri.scheme == 'http') &&
      uri.host.isNotEmpty;
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
    final installedOrder = compareVersions(update.version, currentVersion);
    if (update.platform != target ||
        installedOrder < 0 ||
        (installedOrder == 0 && update.build <= currentBuild)) {
      continue;
    }
    if (platform == 'android' && !abis.contains(update.arch)) {
      continue;
    }
    final order = latest == null
        ? 1
        : compareVersions(update.version, latest.version);
    if (order > 0 ||
        (order == 0 &&
            (update.build > latest!.build ||
                (update.build == latest.build &&
                    platform == 'android' &&
                    abis.indexOf(update.arch) < abis.indexOf(latest.arch))))) {
      latest = update;
    }
  }
  return latest;
}
