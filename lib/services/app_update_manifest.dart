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
    this.abis = const [],
    this.notes = '',
    this.pageUrl = '',
    this.size = 0,
    this.sha256,
    this.delta,
  });
  final String version, platform, arch, notes, pageUrl, url;
  final List<String> abis;
  final int build, size;
  final String? sha256;
  final UpdateDelta? delta;

  String get externalUrl => pageUrl.isEmpty ? url : pageUrl;

  UpdateDelta? deltaFrom(String? version, int? build) =>
      delta?.fromVersion == version && delta?.fromBuild == build ? delta : null;
}

class UpdateDelta {
  const UpdateDelta(
    this.fromVersion,
    this.fromBuild,
    this.fromSha,
    this.url,
    this.size,
    this.sha256,
  );
  final String fromVersion, fromSha, url, sha256;
  final int fromBuild, size;
}

bool _sha(Object? value) =>
    value is String && RegExp(r'^[0-9a-f]{64}$').hasMatch(value);

UpdateDelta? _delta(Map<String, dynamic> entry, int size) {
  final d = entry['delta'];
  // Optional patch metadata must never prevent a valid full update.
  if ((entry.containsKey('full_only') && entry['full_only'] != false) ||
      !const {'android', 'android-tv'}.contains(entry['platform']) ||
      size <= 0 ||
      !_sha(entry['sha256']) ||
      d is! Map ||
      d['format'] != 'nld1' ||
      d['from_version'] is! String ||
      !RegExp(r'^\d+\.\d+\.\d+$').hasMatch(d['from_version']) ||
      compareVersions(d['from_version'], '0.2.0') < 0 ||
      compareVersions(d['from_version'], entry['version']) > 0 ||
      d['from_build'] is! int ||
      d['from_build'] <= 0 ||
      entry['build'] is! int ||
      d['from_build'] >= entry['build'] ||
      !_sha(d['from_sha256']) ||
      !_sha(d['sha256']) ||
      !_isWebUrl(d['url']) ||
      d['size'] is! int ||
      d['size'] <= 0 ||
      d['size'] >= size) {
    return null;
  }
  return UpdateDelta(
    d['from_version'],
    d['from_build'],
    d['from_sha256'],
    d['url'],
    d['size'],
    d['sha256'],
  );
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
        (entry.containsKey('sha256') && !_sha(entry['sha256'])) ||
        (entry['size'] != null &&
            (entry['size'] is! int || (entry['size'] as int) < 0)) ||
        entry['platform'] is! String ||
        (entry['platform'] as String).isEmpty ||
        (entry['arch'] != null &&
            (entry['arch'] is! String || (entry['arch'] as String).isEmpty)) ||
        (entry.containsKey('abis') &&
            (entry['abis'] is! List ||
                (entry['abis'] as List).isEmpty ||
                (entry['abis'] as List).any(
                  (a) => a is! String || a.isEmpty,
                ))) ||
        (entry['notes'] != null && entry['notes'] is! String) ||
        !_isWebUrl(entry['url']) ||
        (entry['page_url'] != null &&
            entry['page_url'] != '' &&
            !_isWebUrl(entry['page_url']))) {
      continue;
    }
    final platform = entry['platform'] as String;
    final size = entry['size'] as int? ?? 0;
    result.add(
      UpdateInfo(
        version: entry['version'] as String,
        build: entry['build'] as int? ?? 0,
        platform: platform,
        arch:
            entry['arch'] as String? ??
            (platform.startsWith('android') ? 'universal' : 'any'),
        abis: (entry['abis'] as List?)?.cast<String>() ?? const [],
        notes: entry['notes'] as String? ?? '',
        pageUrl: entry['page_url'] as String? ?? '',
        url: entry['url'] as String,
        size: size,
        sha256: entry['sha256'] as String?,
        delta: _delta(entry, size),
      ),
    );
  }
  if (result.isEmpty && (root['updates'] as List).isNotEmpty) {
    throw const FormatException('No valid update entries');
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
    if (platform == 'android' &&
        (!abis.contains(update.arch) ||
            (update.abis.isNotEmpty &&
                !update.abis.any(androidAbis.contains)) ||
            (update.build > 0 && update.build < currentBuild))) {
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
