import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/eval/aidoku/service.dart';
import 'package:mangayomi/eval/mihon/source_identity.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/isolate_service.dart';
import 'package:mangayomi/services/extension_store_service.dart';
import 'package:mangayomi/services/source_package.dart';
import 'package:mangayomi/utils/version.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> fetchSourcesList({
  int? id,
  required String androidProxyServer,
  required bool autoUpdateExtensions,
  bool installMissingExtensions = false,
  required ItemType itemType,
  required Repo? repo,
  bool Function()? canContinueUpdates,
  void Function()? onCatalogReady,
}) async {
  final url = repo?.jsonUrl;
  if (url == null) {
    onCatalogReady?.call();
    return;
  }
  final http = _downloadClient();
  try {
    if (repo != null &&
        (repo.name == null ||
            repo.name!.isEmpty ||
            repo.name == '.dist' ||
            repo.name == 'dist')) {
      final uri = Uri.tryParse(url);
      if (uri != null &&
          uri.host == 'raw.githubusercontent.com' &&
          uri.pathSegments.length >= 2) {
        repo.name = uri.pathSegments[1];
      }
    }

    final storeResult = await ExtensionStoreService.fetchStore(
      url,
      http,
    ).timeout(_networkDeadline);
    var sourceList =
        storeResult?.sources
            .where((source) => source.itemType == itemType)
            .toList() ??
        <Source>[];

    // A failed/empty response must not erase cached catalog entries as obsolete.
    if (sourceList.isEmpty) throw StateError('目录为空或暂时无法读取');
    final allCatalogSources = sourceList;

    final catalogIds = <int>{};
    for (final source in allCatalogSources) {
      if (source.id == null || !catalogIds.add(source.id!)) {
        throw StateError('来源目录包含无效或重复 ID，未修改已有来源');
      }
      validatePackageLocation(source, url);
    }
    final appVersion = (await PackageInfo.fromPlatform()).version;
    sourceList = sourceList
        .where(
          (source) =>
              (source.sourceCodeLanguage == SourceCodeLanguage.aidoku ||
                  source.sourceCodeLanguage == SourceCodeLanguage.lnreader ||
                  compareVersions(appVersion, source.appMinVerReq ?? '') >=
                      0) &&
              (SourcePackage.of(source)?.compatible ?? true),
        )
        .toList();
    if (sourceList.isEmpty) throw StateError('此目录需要更新 App，已保留已安装版本');

    // Publish the complete catalog in one transaction before starting any package.
    final candidates = await sourceRepository.writeTransaction(() {
      for (final source in allCatalogSources) {
        final existing = sourceRepository.getById(source.id!);
        if (existing != null && !canReplaceSource(existing, source, url)) {
          throw StateError('来源 ID 与另一仓库冲突，未修改已有来源');
        }
      }
      final entries = <Source>[];
      final install = <Source>[];
      for (final source in sourceList) {
        final existing = sourceRepository.getById(source.id!);
        final installed =
            existing?.isAdded == true &&
            existing?.sourceCode?.isNotEmpty == true;
        final hasUpdate =
            installed &&
            compareVersions(existing!.version!, source.version!) < 0;
        final freshMetadata =
            existing == null ||
            compareVersions(
                  source.version ?? '',
                  existing.versionLast ?? existing.version ?? '',
                ) >=
                0;
        if (!installed) {
          entries.add(
            _catalogEntry(source, repo, itemType)
              ..isActive = existing?.isActive ?? true
              ..isPinned = existing?.isPinned ?? false
              ..lastUsed = existing?.lastUsed ?? false,
          );
        } else if (hasUpdate ||
            existing!.repo?.jsonUrl != url ||
            freshMetadata &&
                (existing.catalogMetadataJson != source.catalogMetadataJson ||
                    existing.isNsfw != source.isNsfw ||
                    source.sourceCodeLanguage == SourceCodeLanguage.mihon &&
                        existing.additionalParams != source.additionalParams)) {
          existing.repo = repo;
          if (freshMetadata) {
            existing.catalogMetadataJson = source.catalogMetadataJson;
            existing.isNsfw = source.isNsfw;
            if (source.sourceCodeLanguage == SourceCodeLanguage.mihon) {
              existing.additionalParams = source.additionalParams;
            }
          }
          if (compareVersions(existing.versionLast ?? '', source.version!) <
              0) {
            existing.versionLast = source.version;
          }
          entries.add(existing);
        }
        if (id == source.id ||
            id == null &&
                (installed
                    ? hasUpdate && autoUpdateExtensions
                    : installMissingExtensions)) {
          install.add(source);
        }
      }
      sourceRepository.putAllSync(entries);
      return install;
    });
    await checkIfSourceIsObsolete(allCatalogSources, repo!, itemType);
    onCatalogReady?.call();
    if (id != null && candidates.isEmpty) {
      throw StateError('此来源已不在目录中，已保留已安装版本');
    }
    var failed = false, paused = false;
    await Future.wait(
      candidates.map((source) async {
        try {
          await installSource(
            source,
            androidProxyServer,
            repo,
            itemType,
            priority: id != null,
            canContinue: canContinueUpdates,
          );
        } on SourceInstallationPaused {
          paused = true;
        } catch (_) {
          failed = true;
        }
      }),
    );
    if (paused) throw const SourceInstallationPaused();
    if (failed) throw StateError('部分扩展尚未安装或更新，已保留可用版本，可重试');
  } finally {
    http.close();
  }
}

const _networkDeadline = Duration(seconds: 25);
InterceptedClient _downloadClient() => MClient.init(
  // Distribution already uses Dart HTTP. Give each operation ownership without
  // changing the transport or closing MClient's shared source-reading client.
  transport: IOClient(HttpClient()..connectionTimeout = _networkDeadline),
  reqcopyWith: const {'useDartHttpClient': true},
  showCloudFlareError: false,
);

class _SourceInstallation {
  _SourceInstallation(
    this.source,
    this.proxy,
    this.repo,
    this.type,
    this.canContinue,
  );
  final Source source;
  final String proxy;
  final Repo repo;
  final ItemType type;
  final bool Function()? canContinue;
  final result = Completer<void>();
  Object get key => (
    repo.jsonUrl,
    source.id,
    source.version,
    SourcePackage.of(source)?.hash ?? source.sourceCodeUrl,
  );
}

final _installations = <Object, _SourceInstallation>{};
final _installationQueue = <_SourceInstallation>[];
bool _installing = false;

/// Shared by catalog automation and explicit installation. No UI or policy reads.
Future<void> installSource(
  Source source,
  String proxy,
  Repo repo,
  ItemType type, {
  bool priority = false,
  bool Function()? canContinue,
}) {
  final task = _SourceInstallation(
    Source.fromJson(source.toJson()),
    proxy,
    repo,
    type,
    canContinue,
  );
  final existing = _installations[task.key];
  if (existing != null) {
    if (priority && _installationQueue.remove(existing)) {
      _installationQueue.insert(0, existing);
    }
    return existing.result.future;
  }
  _installations[task.key] = task;
  if (priority) {
    _installationQueue.insert(0, task);
  } else {
    _installationQueue.add(task);
  }
  task.result.future.ignore();
  unawaited(_drainInstallations());
  return task.result.future;
}

Future<void> _drainInstallations() async {
  if (_installing) return;
  _installing = true;
  try {
    while (_installationQueue.isNotEmpty) {
      final task = _installationQueue.removeAt(0);
      try {
        if (task.canContinue?.call() == false) {
          throw const SourceInstallationPaused();
        }
        if (!_alreadyInstalled(task.source, task.repo)) {
          await _installSource(task.source, task.proxy, task.repo, task.type);
        }
        task.result.complete();
      } catch (error, stack) {
        task.result.completeError(error, stack);
      } finally {
        _installations.remove(task.key);
      }
    }
  } finally {
    _installing = false;
  }
}

bool _alreadyInstalled(Source source, Repo repo) {
  validatePackageLocation(source, repo.jsonUrl!);
  final existing = sourceRepository.getById(source.id!);
  if (existing == null) return false;
  if (!canReplaceSource(existing, source, repo.jsonUrl!)) {
    throw StateError('来源归属已改变，未覆盖已有来源');
  }
  if (existing.isAdded != true || existing.sourceCode?.isNotEmpty != true) {
    return false;
  }
  final version = compareVersions(existing.version ?? '', source.version!);
  if (version > 0) throw StateError('拒绝安装较旧版本');
  if (version != 0) return false;
  final installed = SourcePackage.of(existing),
      incoming = SourcePackage.of(source);
  if (installed != null && installed.hash != incoming?.hash) {
    throw StateError('同版本插件内容已改变，已保留已安装版本');
  }
  return true;
}

Future<void> _installSource(
  Source source,
  String androidProxyServer,
  Repo repo,
  ItemType itemType,
) async {
  final wasInstalled = sourceRepository.getById(source.id!)?.isAdded == true;
  final http = _downloadClient();
  try {
    final bytes = await downloadSourcePackage(
      http,
      source,
    ).timeout(_networkDeadline);
    final sourceCode =
        (source.sourceCodeLanguage == SourceCodeLanguage.mihon ||
            source.sourceCodeLanguage == SourceCodeLanguage.aidoku)
        ? base64.encode(bytes)
        : utf8.decode(bytes);

    Map<String, String> headers = {};
    bool? supportLatest;
    FilterList? filterList;
    List<SourcePreference>? preferenceList;
    source.sourceCode = sourceCode;
    if (source.sourceCodeLanguage == SourceCodeLanguage.mihon) {
      headers = await fetchHeadersDalvik(
        http,
        source,
        androidProxyServer,
      ).timeout(_networkDeadline);
      supportLatest = await fetchSupportLatestDalvik(
        http,
        source,
        androidProxyServer,
      ).timeout(_networkDeadline);
      filterList = await fetchFilterListDalvik(
        http,
        source,
        androidProxyServer,
      ).timeout(_networkDeadline);
      preferenceList = await fetchPreferencesDalvik(
        http,
        source,
        androidProxyServer,
      ).timeout(_networkDeadline);
    } else if (source.sourceCodeLanguage == SourceCodeLanguage.aidoku) {
      final service = AidokuExtensionService(source);
      try {
        headers = service.getHeaders();
        supportLatest = service.supportsLatest;
        filterList = await service.fetchFilterList();
      } finally {
        service.dispose();
      }
    } else {
      headers = await getIsolateService.get<Map<String, String>>(
        source: source,
        serviceType: 'prepareInstallation',
      );
    }

    await sourceRepository.writeTransaction(() {
      if (_alreadyInstalled(source, repo)) return;
      final existing = sourceRepository.getById(source.id!);
      if (existing == null) throw StateError('来源已被移除，已取消安装');
      if (wasInstalled && existing.isAdded != true) {
        throw StateError('来源已被卸载，已取消更新');
      }
      final updatedSource = _catalogEntry(source, repo, itemType)
        // A directory refresh may have supplied newer descriptive metadata
        // while this package was downloading. Keep that current snapshot.
        ..catalogMetadataJson = existing.catalogMetadataJson
        ..isNsfw = existing.isNsfw
        ..headers = jsonEncode(headers)
        ..supportLatest = supportLatest
        ..filterList = filterList != null
            ? jsonEncode(filterList.toJson())
            : null
        ..preferenceList = preferenceList != null
            ? jsonEncode(preferenceList.map((e) => e.toJson()).toList())
            : null
        ..isAdded = true
        ..isActive = existing.isActive ?? true
        ..isPinned = existing.isPinned ?? false
        ..lastUsed = existing.lastUsed ?? false
        ..sourceCode = sourceCode
        ..versionLast =
            compareVersions(existing.versionLast ?? '', source.version!) > 0
            ? existing.versionLast
            : source.version;

      sourceRepository.putAllSync([updatedSource]);
    });
  } finally {
    http.close();
  }
}

Source _catalogEntry(Source source, Repo? repo, ItemType itemType) {
  final newSource = Source()
    ..sourceCodeUrl = source.sourceCodeUrl
    ..packageInfoJson = source.packageInfoJson
    ..catalogMetadataJson = source.catalogMetadataJson
    ..id = source.id
    ..sourceCode = ''
    ..apiUrl = source.apiUrl
    ..baseUrl = source.baseUrl
    ..dateFormat = source.dateFormat
    ..dateFormatLocale = source.dateFormatLocale
    ..hasCloudflare = source.hasCloudflare
    ..iconUrl = source.iconUrl
    ..typeSource = source.typeSource
    ..lang = source.lang
    ..isNsfw = source.isNsfw
    ..name = source.name
    ..version = source.version
    ..versionLast = source.version
    ..itemType = itemType
    ..sourceCodeLanguage = source.sourceCodeLanguage
    ..isFullData = source.isFullData ?? false
    ..appMinVerReq = source.appMinVerReq
    ..additionalParams = source.additionalParams ?? ''
    ..isObsolete = false
    ..notes = source.notes
    ..repo = repo
    ..updatedAt = DateTime.now().millisecondsSinceEpoch;
  return newSource;
}

Future<void> checkIfSourceIsObsolete(
  List<Source> sourceList,
  Repo repo,
  ItemType itemType,
) async {
  final sourceIds = sourceList.map((source) => source.id).nonNulls.toSet();
  if (sourceIds.isEmpty) return;
  await sourceRepository.writeTransaction(() {
    final toUpdate = <Source>[];
    final toDelete = <int>[];
    for (final source in sourceRepository.getByItemType(itemType)) {
      if (source.isLocal == true || source.repo?.jsonUrl != repo.jsonUrl) {
        continue;
      }
      final obsolete = !sourceIds.contains(source.id);
      if (source.isAdded != true && obsolete) {
        toDelete.add(source.id!);
      } else if (source.isObsolete != obsolete) {
        source.isObsolete = obsolete;
        source.updatedAt = DateTime.now().millisecondsSinceEpoch;
        toUpdate.add(source);
      }
    }
    sourceRepository.putAllSync(toUpdate);
    sourceRepository.deleteAllSync(toDelete);
  });
}

Future<Response> _fetchDalvikMetadata(
  InterceptedClient client,
  Source source,
  String androidProxyServer,
  String method,
) {
  final type = source.itemType == ItemType.anime ? 'Anime' : 'Manga';
  return client.post(
    Uri.parse('$androidProxyServer/dalvik'),
    body: jsonEncode({
      'method': '$method$type',
      'data': source.sourceCode,
      ...source.mihonSourceIdentity,
    }),
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

Future<Map<String, String>> fetchHeadersDalvik(
  InterceptedClient client,
  Source source,
  String androidProxyServer,
) async {
  try {
    final res = await _fetchDalvikMetadata(
      client,
      source,
      androidProxyServer,
      'headers',
    );
    final data = jsonDecode(res.body) as List;
    final Map<String, String> headers = {};
    for (var i = 0; i + 1 < data.length; i += 2) {
      headers[data[i]] = data[i + 1];
    }
    return headers;
  } catch (_) {
    return {};
  }
}

Future<bool> fetchSupportLatestDalvik(
  InterceptedClient client,
  Source source,
  String androidProxyServer,
) async {
  try {
    final res = await _fetchDalvikMetadata(
      client,
      source,
      androidProxyServer,
      'supportLatest',
    );
    return res.body.trim() == "true";
  } catch (_) {
    return false;
  }
}

Future<FilterList?> fetchFilterListDalvik(
  InterceptedClient client,
  Source source,
  String androidProxyServer,
) async {
  try {
    final res = await _fetchDalvikMetadata(
      client,
      source,
      androidProxyServer,
      'filters',
    );
    final data = jsonDecode(res.body) as List;

    return FilterList(filtersFromJson(data));
  } catch (_) {
    return null;
  }
}

List<dynamic> filtersFromJson(List<dynamic> json) {
  return json.expand((e) sync* {
    if (e['name'] is String &&
        e['state'] is Map<String, dynamic> &&
        e['values'] is List) {
      yield SortFilter(
        "${e['name']}Filter",
        e['name'],
        SortState(e['state']['index'], e['state']['ascending'], null),
        (e['values'] as List)
            .map((e) => SelectFilterOption(e, e, null))
            .toList(),
        null,
      );
    } else if (e['name'] is String &&
        e['state'] is int &&
        (e['values'] is List || e['vals'] is List)) {
      yield SelectFilter(
        "${e['name']}Filter",
        e['name'],
        e['state'],
        e['vals'] is List
            ? (e['vals'] as List)
                  .map((e) => SelectFilterOption(e['first'], e['second'], null))
                  .toList()
            : e['values'] is List
            ? (e['values'] as List)
                  .map(
                    (e) => (e is Map)
                        ? SelectFilterOption(e['value'], e['value'], null)
                        : SelectFilterOption(e, e, null),
                  )
                  .toList()
            : [],
        "SelectFilter",
      );
    } else if (e['name'] is String && e['state'] is bool) {
      yield CheckBoxFilter(
        null,
        e['name'],
        e['id'] ?? e['name'],
        null,
        state: e['state'],
      );
    } else if (e['included'] is bool &&
        e['ignored'] is bool &&
        e['excluded'] is bool) {
      yield TriStateFilter(
        null,
        e['name'],
        e['id'] ?? e['name'],
        null,
        state: e['state'],
      );
    } else if (e['name'] is String && e['state'] is List) {
      yield GroupFilter(
        "${e['name']}Filter",
        e['name'],
        filtersFromJson((e['state'] as List)),
        "GroupFilter",
      );
    } else if (e['name'] is String && e['state'] is String) {
      yield TextFilter(
        "${e['name']}Filter",
        e['name'],
        null,
        state: e['state'],
      );
    } else if (e['name'] is String && e['state'] is int) {
      yield HeaderFilter(e['name'], "${e['name']}Filter");
    }
  }).toList();
}

Future<List<SourcePreference>?> fetchPreferencesDalvik(
  InterceptedClient client,
  Source source,
  String androidProxyServer,
) async {
  try {
    final res = await _fetchDalvikMetadata(
      client,
      source,
      androidProxyServer,
      'preferences',
    );
    final data = jsonDecode(res.body) as List;
    return data
        .map(
          (e) => SourcePreference.fromJson(e)
            ..id = null
            ..sourceId = source.id,
        )
        .toList();
  } catch (_) {
    return null;
  }
}
