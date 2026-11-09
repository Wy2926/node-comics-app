import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/services/source_catalog_refresh.dart';
import 'package:mangayomi/services/source_package.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/isolate_service.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/proto/mihon_extension_store.pb.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/source_catalog_metadata.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/modules/more/settings/security/providers/security_state_provider.dart';
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
      update: (_) async {
        calls++;
        await gate?.future;
        if (fail) throw StateError('offline');
      },
    );
    var refresh = updater();
    gate = Completer<void>();
    final first = refresh.refreshAndInstall();
    final second = refresh.refreshAndInstall(force: true);
    gate.complete();
    await Future.wait([first, second]);
    expect(calls, 1);
    gate = null;
    refresh = updater(); // Process restart keeps the receipt.
    await refresh.refreshAndInstall();
    expect(calls, 1);
    now = now.add(const Duration(hours: 12));
    fail = true;
    await expectLater(refresh.refreshAndInstall(), throwsStateError);
    await refresh.refreshAndInstall();
    expect(calls, 2);
    fail = false;
    await refresh.refreshAndInstall(force: true);
    expect(calls, 3);
    await updater('https://two.test/stable/index.json').refreshAndInstall();
    expect(calls, 4);
    await file.writeAsString('broken');
    await updater().refreshAndInstall();
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
          update: (_) async {
            calls++;
            if (offline) throw StateError('offline');
          },
        );
        await refresh.refreshAndInstall();
        await refresh.refreshAndInstall();
        expect(calls, 1);
        await refresh.refreshAndInstall(force: true);
        expect(calls, 2);
        now = now.add(const Duration(hours: 12));
        offline = true;
        await expectLater(refresh.refreshAndInstall(), throwsStateError);
        await refresh.refreshAndInstall();
        expect(calls, 3);
        now = now.add(const Duration(minutes: 15));
        offline = false;
        await refresh.refreshAndInstall();
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

  test('catalog readiness does not wait for packages; interruption resumes without failure cooldown', () async {
    final directory = await Directory.systemTemp.createTemp('catalog_ready_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/receipt.json');
    final package = Completer<void>();
    var calls = 0;
    final refresh = SourceCatalogRefresh(
      url: nodeLaneCatalogUrl,
      stateFile: () async => file,
      update: (ready) async {
        calls++;
        ready();
        if (calls == 1) await package.future;
      },
    );
    await refresh.refresh();
    await refresh.refresh(force: true);
    expect(calls, 1);
    expect(jsonDecode(await file.readAsString()), {'url': nodeLaneCatalogUrl});
    final paused = expectLater(
      refresh.completion,
      throwsA(isA<SourceInstallationPaused>()),
    );
    package.completeError(const SourceInstallationPaused());
    await paused;
    await refresh.refreshAndInstall();
    expect(calls, 2);
    expect(jsonDecode(await file.readAsString())['success'], isA<int>());
    await refresh.refreshAndInstall();
    expect(calls, 2);
  });

  test('shared catalog parser accepts whitespace JSON and binary stores and resolves package URLs', () async {
    final catalog = jsonEncode([
      {
        'id': 86001001,
        'name': 'Fixture',
        'baseUrl': 'https://comix.to',
        'sourceCodeUrl': 'packages/comix/0.2.0.js',
        'sourceCodeLanguage': 1,
        'itemType': 0,
        'version': '0.2.0',
        'appMinVerReq': '0.1.0',
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
    // This valid binary prefix contains a newline tag and a "{" length byte.
    final binaryStore = NetworkExtensionStore(
      name: List.filled(123, 'A').join(),
    );
    final client = InterceptedClient.build(
      client: MockClient((request) async {
        if (request.url.path.endsWith('.pb')) {
          return http.Response.bytes(binaryStore.writeToBuffer(), 200);
        }
        return http.Response(
          request.url.path.endsWith('repo.json')
              ? '{"name":"NodeLane 官方"}'
              : '\n\t $catalog',
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
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
    final binary = await ExtensionStoreService.fetchStore(
      'https://third-party.test/index.pb',
      client,
    );
    expect(binary?.name, binaryStore.name);
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
      PackageInfo.setMockInitialValues(
        appName: 'NodeLane',
        packageName: 'test',
        version: '0.1.0',
        buildNumber: '1',
        buildSignature: '',
      );
      directory = await Directory.systemTemp.createTemp('nodelane_catalog_');
      app.isar = await StorageProvider().openDB(
        directory.path,
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
      await getIsolateService.stop();
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

    test('installation CPU work stays off the UI isolate and a timed-out worker is replaced', () async {
      final executor = GetIsolateService(
        responseTimeout: const Duration(seconds: 2),
      );
      addTearDown(executor.stop);
      var ticks = 0;
      final timer = Timer.periodic(
        const Duration(milliseconds: 50),
        (_) => ticks++,
      );
      addTearDown(timer.cancel);
      final stuck = Source(
        id: 70,
        sourceCode: '''
void main(dynamic source) { while (true) {} }
''',
      );
      await expectLater(
        executor.get<Map<String, String>>(
          source: stuck,
          serviceType: 'prepareInstallation',
        ),
        throwsA(isA<TimeoutException>()),
      );
      expect(ticks, greaterThan(2));
      final healthy = Source(
        id: 71,
        sourceCode: '''
class DefaultExtension extends MProvider {
  getHeaders() { return {"X-Fixture": "ready"}; }
}
''',
      )..sourceCodeLanguage = SourceCodeLanguage.javascript;
      expect(
        await executor.get<Map<String, String>>(
          source: healthy,
          serviceType: 'prepareInstallation',
        ),
        {'X-Fixture': 'ready'},
      );
    });

    test('QuickJS initialization is interrupted and subsequent installation still succeeds', () async {
      final source = Source(
        id: 72,
        sourceCode: '''
class DefaultExtension extends MProvider { getHeaders() { while (true) {} } }
''',
      )..sourceCodeLanguage = SourceCodeLanguage.javascript;
      await expectLater(
        getIsolateService.get<Map<String, String>>(
          source: source,
          serviceType: 'prepareInstallation',
        ),
        throwsA(predicate((error) => error.toString().contains('interrupted'))),
      );
      source.sourceCode = 'class DefaultExtension extends MProvider { getHeaders() { return {}; } }';
      expect(
        await getIsolateService.get<Map<String, String>>(
          source: source,
          serviceType: 'prepareInstallation',
        ),
        isEmpty,
      );
    });

    test('metadata refresh persists without code updates and rejects older catalog descriptions', () async {
      final overrides = HttpOverrides.current;
      HttpOverrides.global = null;
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() async {
        await server.close(force: true);
        HttpOverrides.global = overrides;
      });
      final repo = Repo(jsonUrl: 'http://127.0.0.1:${server.port}/index.json');
      await sourceRepository.save(
        sourceRepository.getById(1)!
          ..repo = repo
          ..isActive = false
          ..lastUsed = true
          ..version = '1.0.0'
          ..versionLast = '1.0.0',
      );
      var pricing = 'free', version = '1.0.0';
      const mihonId = '5724751873601868259';
      await sourceRepository.save(
        Source(
          id: 5,
          repo: repo,
          isAdded: true,
          sourceCode: 'original-apk',
          version: version,
          versionLast: version,
        )..sourceCodeLanguage = SourceCodeLanguage.mihon,
      );
      var downloads = 0;
      server.listen((request) async {
        if (request.uri.path == '/index.json') {
          request.response.write(
            jsonEncode([
              for (final id in [1, 4, 5])
                {
                  'id': id,
                  'name': 'Fixture $id',
                  'version': version,
                  'baseUrl': 'https://example.test',
                  'sourceCodeUrl': 'plugin.js',
                  'itemType': 0,
                  'sourceCodeLanguage': id == 5 ? 2 : 1,
                  if (id == 5)
                    'additionalParams': jsonEncode({'mihonSourceId': mihonId}),
                  'isNsfw': false,
                  'catalogMetadata': {
                    'schema': 1,
                    'pricing': pricing,
                    'regions': ['kr'],
                    'formats': ['vertical'],
                  },
                },
            ]),
          );
        } else if (request.uri.path == '/repo.json') {
          request.response.write('{"name":"Fixture"}');
        } else {
          downloads++;
          request.response.statusCode = 500;
        }
        await request.response.close();
      });
      Future<void> refresh() => fetchSourcesList(
        androidProxyServer: '',
        autoUpdateExtensions: true,
        itemType: ItemType.manga,
        repo: repo,
      );
      await refresh();
      expect(sourceRepository.getById(4)!.catalogMetadata.formats, [
        'vertical',
      ]);
      pricing = 'partial';
      await refresh();
      final source = sourceRepository.getById(1)!;
      expect(source.catalogMetadata.pricing, SourcePricing.partial);
      expect(source.isNsfw, isFalse);
      expect(source.sourceCode, 'installed');
      expect(source.isPinned, isTrue);
      expect(source.isActive, isFalse);
      expect(source.lastUsed, isTrue);
      final mihon = sourceRepository.getById(5)!;
      expect(jsonDecode(mihon.additionalParams!)['mihonSourceId'], mihonId);
      expect(mihon.sourceCode, 'original-apk');
      expect(mihon.id, 5);
      version = '0.9.0';
      pricing = 'free';
      await refresh();
      expect(
        sourceRepository.getById(1)!.catalogMetadata.pricing,
        SourcePricing.partial,
      );
      expect(downloads, 0);
    });

    test('catalog publishes first; manual and automatic installs share one queue, preserve edits and resume pending work', () async {
      final overrides = HttpOverrides.current;
      HttpOverrides.global = null;
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final gates = {1: Completer<void>(), 4: Completer<void>()};
      final started = {1: Completer<void>(), 4: Completer<void>()};
      addTearDown(() async {
        for (final gate in gates.values) {
          if (!gate.isCompleted) gate.complete();
        }
        await server.close(force: true);
        HttpOverrides.global = overrides;
      });
      final repo = Repo(jsonUrl: 'http://127.0.0.1:${server.port}/index.json');
      for (final id in [1, 2]) {
        await sourceRepository.save(
          sourceRepository.getById(id)!
            ..repo = repo
            ..version = '0.0.1',
        );
      }
      const code =
          'class DefaultExtension extends MProvider { getHeaders() { return {}; } }';
      final downloads = <int>[];
      server.listen((request) async {
        if (request.uri.path.startsWith('/packages/')) {
          final id = int.parse(request.uri.pathSegments.last);
          downloads.add(id);
          started[id]?.complete();
          await gates[id]?.future;
          request.response.write(code);
        } else if (request.uri.path == '/repo.json') {
          request.response.write('{"name":"Fixture"}');
        } else {
          request.response.write(
            jsonEncode([
              for (final id in [1, 2, 4, 5])
                {
                  'id': id,
                  'name': 'Fixture $id',
                  'version': '1.0.0',
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
      var foreground = true;
      final ready = Completer<void>();
      final batch = fetchSourcesList(
        androidProxyServer: '',
        autoUpdateExtensions: true,
        installMissingExtensions: true,
        itemType: ItemType.manga,
        repo: repo,
        canContinueUpdates: () => foreground,
        onCatalogReady: ready.complete,
      );
      final paused = expectLater(
        batch,
        throwsA(isA<SourceInstallationPaused>()),
      );
      await ready.future;
      expect(sourceRepository.getById(5)?.name, 'Fixture 5');
      expect(sourceRepository.getById(1)?.sourceCode, 'installed');
      await started[1]!.future;
      final manual = installSource(
        sourceRepository.getById(4)!,
        '',
        repo,
        ItemType.manga,
        priority: true,
      );
      final repeated = installSource(
        sourceRepository.getById(4)!,
        '',
        repo,
        ItemType.manga,
        priority: true,
      );
      // Edits made while the package is in flight must survive its final write.
      await sourceRepository.save(
        sourceRepository.getById(1)!
          ..isPinned = false
          ..isActive = false
          ..lastUsed = true
          ..catalogMetadataJson = jsonEncode({
            'schema': 1,
            'pricing': 'partial',
          }),
      );
      gates[1]!.complete();
      await started[4]!.future;
      foreground = false;
      gates[4]!.complete();
      await Future.wait([manual, repeated]);
      await paused;
      expect(downloads, [1, 4]);
      final installed = sourceRepository.getById(1)!;
      expect(installed.sourceCode, code);
      expect(installed.catalogMetadata.pricing, SourcePricing.partial);
      expect(
        [installed.isPinned, installed.isActive, installed.lastUsed],
        [false, false, true],
      );
      expect(sourceRepository.getById(2)?.isAdded, isFalse);
      expect(sourceRepository.getById(5)?.isAdded, isFalse);
      foreground = true;
      await fetchSourcesList(
        androidProxyServer: '',
        autoUpdateExtensions: true,
        installMissingExtensions: true,
        itemType: ItemType.manga,
        repo: repo,
        canContinueUpdates: () => foreground,
      );
      expect(downloads, [1, 4, 2, 5]);
      await installSource(
        sourceRepository.getById(4)!,
        '',
        repo,
        ItemType.manga,
      );
      expect(downloads, [1, 4, 2, 5]);
      expect(sourceRepository.getById(3)?.sourceCode, 'third-party');
      // Recheck user changes and repository ownership after the last await.
      for (final id in [1, 4]) {
        gates[id] = Completer<void>();
        started[id] = Completer<void>();
        final incoming = Source.fromJson(sourceRepository.getById(id)!.toJson())
          ..version = '1.0.1';
        final rejected = expectLater(
          installSource(incoming, '', repo, ItemType.manga),
          throwsStateError,
        );
        await started[id]!.future;
        final current = sourceRepository.getById(id)!;
        if (id == 1) {
          current
            ..isAdded = false
            ..sourceCode = '';
        } else {
          current.repo = thirdParty;
        }
        await sourceRepository.save(current);
        gates[id]!.complete();
        await rejected;
        expect(sourceRepository.getById(id)?.sourceCode, current.sourceCode);
        expect(
          sourceRepository.getById(id)?.repo?.jsonUrl,
          current.repo?.jsonUrl,
        );
      }
    });
    for (final isOfficial in [false, true]) {
      testWidgets(
        '${isOfficial ? "official" : "third-party"} sync respects installation policy, isolates failures and resumes without repeating downloads',
        (tester) async {
          await tester.runAsync(() async {
            await settingsRepository.save(
              Settings(
                id: 227,
                checkForExtensionUpdates: false,
                autoExtensionsUpdates: false,
              ),
            );
            const pathChannel = MethodChannel(
              'plugins.flutter.io/path_provider',
            );
            tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
              pathChannel,
              (_) async => directory.path,
            );
            final overrides = HttpOverrides.current;
            HttpOverrides.global = null;
            final server = await HttpServer.bind(
              InternetAddress.loopbackIPv4,
              0,
            );
            addTearDown(() async {
              await server.close(force: true);
              HttpOverrides.global = overrides;
              tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
                pathChannel,
                null,
              );
              tester.binding.handleAppLifecycleStateChanged(
                AppLifecycleState.resumed,
              );
            });
            final repo = Repo(
              jsonUrl: 'http://127.0.0.1:${server.port}/index.json',
            );
            for (final id in [1, 2]) {
              await sourceRepository.save(
                sourceRepository.getById(id)!
                  ..repo = repo
                  ..version = '0.0.1'
                  ..isAdded = id == 1 || !isOfficial
                  ..isActive = id != 2
                  ..sourceCode = id == 1 || !isOfficial ? 'old-$id' : '',
              );
            }
            const code =
                'class DefaultExtension extends MProvider { getHeaders() { return {}; } }';
            var corrupt = true, foreground = true, newEntry = false;
            var version = '1.0.0';
            var catalogRequests = 0;
            final downloads = <int, int>{};
            server.listen((request) async {
              if (request.uri.path.startsWith('/packages/')) {
                final id = int.parse(request.uri.pathSegments.last);
                downloads.update(id, (count) => count + 1, ifAbsent: () => 1);
                request.response.write(
                  corrupt && (id == 1 || id == 4) ? 'bad' : code,
                );
              } else if (request.uri.path == '/repo.json') {
                request.response.write('{"name":"Fixture"}');
              } else {
                catalogRequests++;
                request.response.write(
                  jsonEncode([
                    for (final id in [1, 2, 4, if (newEntry) 6])
                      {
                        'id': id,
                        'name': 'Fixture $id',
                        'version': version,
                        'appMinVerReq': '0.1.0',
                        'baseUrl': 'https://example.test',
                        'sourceCodeUrl': 'packages/$id',
                        'itemType': 0,
                        'sourceCodeLanguage': 1,
                        'nodelane': {
                          'schema': 1,
                          'repositoryId': 'net.nodelane.extensions',
                          'slug': 'fixture-$id',
                          'sha256': sha256
                              .convert(utf8.encode(code))
                              .toString(),
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
            final container = ProviderContainer(
              overrides: [
                nodeLaneCatalogRepositoryProvider(ItemType.manga)
                    .overrideWithValue(repo),
              ],
            );
            addTearDown(container.dispose);
            late WidgetRef widgetRef;
            await tester.pumpWidget(
              UncontrolledProviderScope(
                container: container,
                child: Consumer(
                  builder: (_, ref, _) {
                    widgetRef = ref;
                    ref.watch(appUnlockedStateProvider);
                    return const SizedBox.shrink();
                  },
                ),
              ),
            );
            tester.binding.handleAppLifecycleStateChanged(
              AppLifecycleState.resumed,
            );
            Future<void> refresh({bool autoUpdate = true}) => isOfficial
                ? container
                      .read(nodeLaneCatalogRefreshProvider)
                      .refreshAndInstall(force: true)
                : fetchSourcesList(
                    androidProxyServer: '',
                    autoUpdateExtensions: autoUpdate,
                    itemType: ItemType.manga,
                    repo: repo,
                    canContinueUpdates: () => foreground,
                  );
            if (isOfficial) {
              // Launch/resume ignores both third-party switches; errors remain quiet.
              await refreshOfficialCatalogIfDue(widgetRef);
            } else {
              await refresh(autoUpdate: false);
              expect(downloads, isEmpty);
              expect(sourceRepository.getById(1)?.versionLast, '1.0.0');
              await expectLater(refresh(), throwsStateError);
            }
            expect(sourceRepository.getById(1)?.sourceCode, 'old-1');
            expect(sourceRepository.getById(2)?.version, '1.0.0');
            expect(sourceRepository.getById(4)?.isAdded, isFalse);
            expect(sourceRepository.getById(3)?.sourceCode, 'third-party');
            expect(downloads, {1: 1, 2: 1, if (isOfficial) 4: 1});
            corrupt = false;
            await refresh();
            await refresh();
            expect(downloads, {1: 2, 2: 1, if (isOfficial) 4: 2});
            expect(sourceRepository.getById(1)?.isPinned, isTrue);
            expect(sourceRepository.getById(2)?.isActive, isFalse);
            expect(sourceRepository.getById(4)?.isAdded, isOfficial);
            version = '1.0.1';
            newEntry = true;
            foreground = false;
            tester.binding.handleAppLifecycleStateChanged(
              AppLifecycleState.paused,
            );
            await expectLater(
              refresh(),
              throwsA(isA<SourceInstallationPaused>()),
            );
            expect(downloads, {1: 2, 2: 1, if (isOfficial) 4: 2});
            expect(sourceRepository.getById(6)?.isAdded, isFalse);
            foreground = true;
            tester.binding.handleAppLifecycleStateChanged(
              AppLifecycleState.resumed,
            );
            await refresh();
            expect(downloads, {
              1: 3,
              2: 2,
              if (isOfficial) ...{4: 3, 6: 1},
            });
            expect(sourceRepository.getById(6)?.isAdded, isOfficial);
            expect(
              settingsRepository.current.checkForExtensionUpdates,
              isFalse,
            );
            expect(settingsRepository.current.autoExtensionsUpdates, isFalse);
            if (isOfficial) {
              container.read(appUnlockedStateProvider.notifier).lock();
              final before = catalogRequests;
              await refreshOfficialCatalogIfDue(widgetRef);
              expect(catalogRequests, before);
            }
            await tester.pumpWidget(const SizedBox.shrink());
          });
        },
      );
    }
    test('unsupported app versions, damaged catalogs and HTTP failures preserve installed code before retry', () async {
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
      var damagedCatalog = false;
      var version = '0.2.0';
      var minimumAppVersion = '0.1.0';
      var catalogRequests = 0;
      const pluginCode =
          'class DefaultExtension extends MProvider { getHeaders() { return {"X-Fixture": "中文 · 漫画"}; } }';
      server.listen((request) async {
        if (request.uri.path == '/index.json') catalogRequests++;
        request.response.headers.contentType = ContentType.json;
        if (request.uri.path == '/comix.js' && pluginAvailable && !offline) {
          // Match Python's static server: JavaScript with no charset.
          request.response.headers.set(
            HttpHeaders.contentTypeHeader,
            'text/javascript',
          );
          request.response.add(utf8.encode(pluginCode));
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
                'appMinVerReq': minimumAppVersion,
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
      minimumAppVersion = '0.2.0';
      await expectLater(
        refresh(),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'reason',
            contains('需要更新 App'),
          ),
        ),
      );
      expect(sourceRepository.getById(1)?.sourceCode, 'installed');
      expect(sourceRepository.getById(1)?.isObsolete, isFalse);
      minimumAppVersion = '0.1.0';
      damagedCatalog = true;
      await expectLater(refresh(), throwsStateError);
      expect(sourceRepository.getById(1)?.sourceCode, 'installed');
      expect(sourceRepository.getById(1)?.isObsolete, isFalse);
      damagedCatalog = false;
      offline = true;
      final before = catalogRequests;
      await expectLater(refresh(), throwsStateError);
      expect(catalogRequests, before + 1);
      expect(sourceRepository.getById(1)?.isObsolete, isFalse);
      expect(sourceRepository.getById(3)?.isObsolete, isTrue);
      offline = false;
      pluginAvailable = true;
      await refresh(id: 1);
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

// Most reconciliation assertions need installed code, not just catalog metadata.
extension on SourceCatalogRefresh {
  Future<void> refreshAndInstall({bool force = false}) async {
    await refresh(force: force);
    await this.completion;
  }
}
