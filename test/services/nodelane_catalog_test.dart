import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:mangayomi/services/source_catalog_refresh.dart';
import 'package:mangayomi/services/source_package.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/services/extension_store_service.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  test('refresh persists cooldowns, coalesces work, retries failures and isolates endpoint moves', () async {
    final directory = await Directory.systemTemp.createTemp(
      'catalog_schedule_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/receipt.json');
    var now = DateTime(2026), calls = 0;
    var fail = false;
    Completer<void>? gate;
    SourceCatalogRefresh updater([
      String url = 'https://one.test/stable/index.json',
    ]) => SourceCatalogRefresh(
      url: url,
      stateFile: () async => file,
      now: () => now,
      update: () async {
        calls++;
        await gate?.future;
        if (fail) throw StateError('offline');
      },
    );
    var refresh = updater();
    gate = Completer<void>();
    final first = refresh.refresh();
    final second = refresh.refresh(force: true);
    gate.complete();
    await Future.wait([first, second]);
    expect(calls, 1);
    gate = null;
    refresh = updater(); // Process restart keeps the receipt.
    await refresh.refresh();
    expect(calls, 1);
    now = now.add(const Duration(hours: 12));
    fail = true;
    await expectLater(refresh.refresh(), throwsStateError);
    await refresh.refresh();
    expect(calls, 2);
    fail = false;
    await refresh.refresh(force: true);
    expect(calls, 3);
    await updater('https://two.test/stable/index.json').refresh();
    expect(calls, 4);
    await file.writeAsString('broken');
    await updater().refresh();
    expect(calls, 5);
  });

  test(
    'unavailable refresh storage keeps loading and in-memory cooldowns',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'catalog_storage_',
      );
      addTearDown(() => directory.delete(recursive: true));
      final blockedParent = File('${directory.path}/not-a-directory');
      await blockedParent.writeAsString('occupied');
      final locations = <Future<File> Function()>[
        () async => throw const FileSystemException('no support directory'),
        () async => File('${blockedParent.path}/receipt.json'),
      ];
      for (final location in locations) {
        var now = DateTime(2026), calls = 0;
        var offline = false;
        final refresh = SourceCatalogRefresh(
          url: nodeLaneCatalogUrl,
          stateFile: location,
          now: () => now,
          update: () async {
            calls++;
            if (offline) throw StateError('offline');
          },
        );
        await refresh.refresh();
        await refresh.refresh();
        expect(calls, 1);
        await refresh.refresh(force: true);
        expect(calls, 2);
        now = now.add(const Duration(hours: 12));
        offline = true;
        await expectLater(refresh.refresh(), throwsStateError);
        await refresh.refresh();
        expect(calls, 3);
        now = now.add(const Duration(minutes: 15));
        offline = false;
        await refresh.refresh();
        expect(calls, 4);
      }
    },
  );

  test('official catalog is independent and does not choose a third-party provider', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final repo = container.read(
      nodeLaneCatalogRepositoryProvider(ItemType.manga),
    );
    expect(repo?.jsonUrl, nodeLaneCatalogUrl);
    expect(repo?.name, contains('NodeLane 官方'));
    expect(isNodeLaneCatalogSource(Source(repo: repo), repo), isTrue);
    expect(isNodeLaneCatalogSource(Source(), repo), isFalse);
    // A missing official anime/novel catalog must not hide custom extensions.
    expect(isNodeLaneCatalogSource(Source(), null), isFalse);
    expect(
      container.read(nodeLaneCatalogRepositoryProvider(ItemType.novel)),
      isNull,
    );
    expect(
      container.read(nodeLaneCatalogRepositoryProvider(ItemType.anime)),
      isNull,
    );
  });

  test('plain official catalogs resolve HTTPS and development packages without changing source ID', () async {
    final catalog = jsonEncode([
      {
        'id': 86001001,
        'name': 'Fixture',
        'baseUrl': 'https://comix.to',
        'sourceCodeUrl': 'packages/comix/0.2.0.js',
        'sourceCodeLanguage': 1,
        'itemType': 0,
        'version': '0.2.0',
        'nodelane': {
          'schema': 1,
          'repositoryId': 'net.nodelane.extensions',
          'slug': 'comix',
          'sha256': sha256.convert([1]).toString(),
          'size': 1,
          'requestHosts': ['comix.to'],
          'requires': [],
        },
      },
    ]);
    final client = InterceptedClient.build(
      client: MockClient(
        (request) async => http.Response(
          request.url.path.endsWith('repo.json')
              ? '{"name":"NodeLane 官方"}'
              : catalog,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      ),
      interceptors: [],
    );
    addTearDown(client.close);
    for (final origin in [
      'http://127.0.0.1:8787',
      'http://192.168.1.10:8787',
      'https://comics-extensions.nodelane.net/stable',
    ]) {
      final result = await ExtensionStoreService.fetchStore(
        '$origin/index.json',
        client,
      );
      expect(result, isNotNull);
      final source = result!.sources.single;
      expect(source.id, 86001001);
      expect(source.sourceCodeUrl, '$origin/packages/comix/0.2.0.js');
      expect(source.baseUrl, 'https://comix.to');
      expect(source.sourceCodeLanguage, SourceCodeLanguage.javascript);
    }
  });

  group('catalog reconciliation', () {
    late Directory directory;
    final official = Repo(jsonUrl: nodeLaneCatalogUrl);
    final thirdParty = Repo(jsonUrl: 'https://example.test/index.json');
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final overrides = HttpOverrides.current;
      HttpOverrides.global = null;
      try {
        await Isar.initializeIsarCore(download: true);
      } finally {
        HttpOverrides.global = overrides;
      }
    });
    setUp(() async {
      directory = await Directory.systemTemp.createTemp('nodelane_catalog_');
      app.isar = await Isar.open(
        [SourceSchema, SettingsSchema],
        directory: directory.path,
        name: directory.path.hashCode.toString(),
      );
      await sourceRepository.putAll([
        Source(
          id: 1,
          repo: official,
          isAdded: true,
          sourceCode: 'installed',
          isPinned: true,
        ),
        Source(id: 2, repo: official),
        Source(
          id: 3,
          repo: thirdParty,
          isAdded: true,
          isObsolete: true,
          sourceCode: 'third-party',
        ),
      ]);
    });
    tearDown(() async {
      await app.isar.close(deleteFromDisk: true);
      await directory.delete(recursive: true);
    });
    test('failure/empty catalog preserves cache; refresh is isolated and repeatable', () async {
      await checkIfSourceIsObsolete([], official, ItemType.manga);
      expect(sourceRepository.getAll(), hasLength(3));
      for (var i = 0; i < 2; i++) {
        await checkIfSourceIsObsolete(
          [Source(id: 1)],
          official,
          ItemType.manga,
        );
      }
      expect(sourceRepository.getById(2), isNull);
      expect(sourceRepository.getById(1)?.sourceCode, 'installed');
      expect(sourceRepository.getById(1)?.isPinned, isTrue);
      expect(sourceRepository.getById(3)?.isObsolete, isTrue);
      expect(sourceRepository.getById(3)?.sourceCode, 'third-party');
      await checkIfSourceIsObsolete([Source(id: 4)], official, ItemType.manga);
      expect(sourceRepository.getById(1)?.isObsolete, isTrue);
      await checkIfSourceIsObsolete([Source(id: 1)], official, ItemType.manga);
      expect(sourceRepository.getById(1)?.isObsolete, isFalse);
    });
    test('automatic updates isolate failures, skip unchanged and uninstalled plugins, and stop new downloads in background', () async {
      PackageInfo.setMockInitialValues(
        appName: 'NodeLane',
        packageName: 'test',
        version: '0.1.0',
        buildNumber: '1',
        buildSignature: '',
      );
      final overrides = HttpOverrides.current;
      HttpOverrides.global = null;
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() async {
        await server.close(force: true);
        HttpOverrides.global = overrides;
      });
      final repo = Repo(jsonUrl: 'http://127.0.0.1:${server.port}/index.json');
      for (final id in [1, 2]) {
        await sourceRepository.save(
          sourceRepository.getById(id)!
            ..repo = repo
            ..version = '0.0.1'
            ..isAdded = true
            ..sourceCode = 'old-$id',
        );
      }
      const code =
          'class DefaultExtension extends MProvider { getHeaders() { return {}; } }';
      var corruptFirst = true, foreground = true;
      var version = '1.0.0';
      final downloads = <int, int>{};
      server.listen((request) async {
        if (request.uri.path.startsWith('/packages/')) {
          final id = int.parse(request.uri.pathSegments.last);
          downloads.update(id, (count) => count + 1, ifAbsent: () => 1);
          request.response.write(id == 1 && corruptFirst ? 'bad' : code);
        } else if (request.uri.path == '/repo.json') {
          request.response.write('{"name":"Fixture"}');
        } else {
          request.response.write(
            jsonEncode([
              for (final id in [1, 2, 4])
                {
                  'id': id,
                  'name': 'Fixture $id',
                  'version': version,
                  'baseUrl': 'https://example.test',
                  'sourceCodeUrl': 'packages/$id',
                  'itemType': 0,
                  'sourceCodeLanguage': 1,
                  'nodelane': {
                    'schema': 1,
                    'repositoryId': 'net.nodelane.extensions',
                    'slug': 'fixture-$id',
                    'sha256': sha256.convert(utf8.encode(code)).toString(),
                    'size': utf8.encode(code).length,
                    'requestHosts': ['example.test'],
                    'requires': <String>[],
                  },
                },
            ]),
          );
        }
        await request.response.close();
      });
      Future<void> refresh() => fetchSourcesList(
        refresh: true,
        androidProxyServer: '',
        autoUpdateExtensions: true,
        itemType: ItemType.manga,
        repo: repo,
        canContinueUpdates: () => foreground,
      );
      await expectLater(refresh(), throwsStateError);
      expect(sourceRepository.getById(1)?.sourceCode, 'old-1');
      expect(sourceRepository.getById(2)?.version, '1.0.0');
      expect(sourceRepository.getById(4)?.isAdded, isFalse);
      expect(sourceRepository.getById(3)?.sourceCode, 'third-party');
      expect(downloads, {1: 1, 2: 1});
      corruptFirst = false;
      await refresh();
      await refresh();
      expect(downloads, {1: 2, 2: 1});
      expect(sourceRepository.getById(1)?.isPinned, isTrue);
      version = '1.0.1';
      foreground = false;
      await expectLater(refresh(), throwsStateError);
      expect(downloads, {1: 2, 2: 1});
      foreground = true;
      await refresh();
      expect(downloads, {1: 3, 2: 2});
    });
    test('local HTTP and integrity failures preserve installed code before a successful retry', () async {
      PackageInfo.setMockInitialValues(
        appName: 'NodeLane',
        packageName: 'test',
        version: '0.1.0',
        buildNumber: '1',
        buildSignature: '',
      );
      final overrides = HttpOverrides.current;
      HttpOverrides.global = null;
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() async {
        await server.close(force: true);
        HttpOverrides.global = overrides;
      });
      final url = 'http://127.0.0.1:${server.port}';
      final repo = Repo(name: 'NodeLane 官方 · 本地开发', jsonUrl: '$url/index.json');
      final installed = sourceRepository.getById(1)!
        ..name = 'Comix'
        ..baseUrl = 'https://comix.to'
        ..repo = repo;
      await sourceRepository.save(installed);
      var offline = false;
      var pluginAvailable = false;
      var corrupt = false;
      var damagedCatalog = false;
      var version = '0.2.0';
      const pluginCode =
          'class DefaultExtension extends MProvider { getHeaders() { return {"X-Fixture": "中文 · 漫画"}; } }';
      server.listen((request) async {
        request.response.headers.contentType = ContentType.json;
        if (request.uri.path == '/comix.js' && pluginAvailable && !offline) {
          // Match Python's static server: JavaScript with no charset.
          request.response.headers.set(
            HttpHeaders.contentTypeHeader,
            'text/javascript',
          );
          request.response.add(utf8.encode(corrupt ? 'bad' : pluginCode));
        } else if (offline || request.uri.path == '/comix.js') {
          request.response.statusCode = HttpStatus.serviceUnavailable;
        } else if (request.uri.path == '/repo.json') {
          request.response.write(jsonEncode({'name': repo.name}));
        } else {
          request.response.write(
            jsonEncode([
              {
                ...installed.toJson(),
                'sourceCodeUrl': 'comix.js',
                'sourceCodeLanguage': 1,
                'version': version,
                'nodelane': {
                  'schema': 1,
                  'repositoryId': 'net.nodelane.extensions',
                  'slug': 'comix',
                  'sha256': sha256.convert(utf8.encode(pluginCode)).toString(),
                  'size': utf8.encode(pluginCode).length,
                  'requestHosts': ['comix.to'],
                  'requires': [],
                },
              },
              if (damagedCatalog) {'id': 2, 'name': null},
            ]),
          );
        }
        await request.response.close();
      });
      Future<void> refresh({int? id}) => fetchSourcesList(
        id: id,
        refresh: true,
        androidProxyServer: '',
        autoUpdateExtensions: false,
        itemType: ItemType.manga,
        repo: repo,
      );
      await expectLater(refresh(id: 1), throwsStateError);
      expect(sourceRepository.getById(1)?.sourceCode, 'installed');
      await refresh();
      final moved = sourceRepository.getById(1)!;
      expect(moved.repo?.jsonUrl, repo.jsonUrl);
      expect(moved.sourceCodeUrl, '');
      expect(moved.isPinned, isTrue);
      expect(moved.sourceCode, 'installed');
      expect(moved.versionLast, '0.2.0');
      damagedCatalog = true;
      await expectLater(refresh(), throwsStateError);
      expect(sourceRepository.getById(1)?.sourceCode, 'installed');
      expect(sourceRepository.getById(1)?.isObsolete, isFalse);
      damagedCatalog = false;
      offline = true;
      await expectLater(refresh(), throwsStateError);
      expect(sourceRepository.getById(1)?.isObsolete, isFalse);
      expect(sourceRepository.getById(3)?.isObsolete, isTrue);
      offline = false;
      pluginAvailable = true;
      corrupt = true;
      await expectLater(refresh(id: 1), throwsStateError);
      expect(sourceRepository.getById(1)?.sourceCode, 'installed');
      corrupt = false;
      await Future.wait([refresh(id: 1), refresh(id: 1)]);
      expect(sourceRepository.getById(1)?.sourceCode, pluginCode);
      expect(
        jsonDecode(sourceRepository.getById(1)!.headers!)['X-Fixture'],
        '中文 · 漫画',
      );
      expect(sourceRepository.getById(1)?.isPinned, isTrue);
      expect(
        SourcePackage.of(sourceRepository.getById(1)!)?.hash,
        sha256.convert(utf8.encode(pluginCode)).toString(),
      );
      version = '0.1.9';
      await expectLater(refresh(id: 1), throwsStateError);
      expect(sourceRepository.getById(1)?.version, '0.2.0');
    });
  });
}
