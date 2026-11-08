import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/global_search/global_search_screen.dart';
import 'package:mangayomi/modules/browse/global_search/search_activity.dart';
import 'package:mangayomi/modules/browse/mobile_sources_screen.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/services/get_popular.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/headers.dart';

const _cover =
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGNwq9jyHwAE7AJy5WV9CAAAAABJRU5ErkJggg==';

void main() {
  late Directory directory;
  late Isar database;
  final repo = Repo(name: 'Sample', jsonUrl: 'https://example.org/index.json');
  final source = Source(
    id: 101,
    name: 'local',
    lang: '',
    isAdded: true,
    isActive: true,
    sourceCode: 'existing',
    repo: repo,
  );

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    directory = await Directory.systemTemp.createTemp('source-search-flow-');
    database = await Isar.open(
      [
        SourceSchema,
        SettingsSchema,
        MangaSchema,
        ChapterSchema,
        SourcePreferenceSchema,
        SourcePreferenceStringValueSchema,
      ],
      directory: directory.path,
      name: 'source_search_flow',
    );
    app.isar = database;
    database.writeTxnSync(() {
      database.settings.putSync(
        Settings(
          id: 227,
          mangaHomeDisplayType: DisplayType.list,
          onlyIncludePinnedSources: false,
          showNSFW: false,
          hideItems: [],
          mangaExtensionsRepo: [repo],
        ),
      );
      database.sources.putSync(source);
    });
  });

  tearDownAll(() async {
    await database.close(deleteFromDisk: true);
    await directory.delete(recursive: true);
  });

  testWidgets('batch actions persist and release the shared selection mode', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await database.writeTxn(
        () async => database.sources.putAll([
          for (var id = 201; id <= 203; id++)
            Source.fromJson(source.toJson())
              ..id = id
              ..name = 'Batch $id'
              ..isAdded = id != 203,
        ]),
      );
      final container = ProviderContainer(
        overrides: [
          nodeLaneCatalogRepositoryProvider(ItemType.manga)
              .overrideWithValue(null),
          nodeLaneCatalogLoadProvider(ItemType.manga)
              .overrideWith((ref) async {}),
          fetchItemSourcesListProvider(
            reFresh: false,
            itemType: ItemType.manga,
          ).overrideWith((ref) async {}),
          mobileCatalogEntriesProvider(ItemType.manga).overrideWith(
            (ref) => database.sources
                .filter()
                .idBetween(201, 203)
                .watch(fireImmediately: true),
          ),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('zh'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const MobileSourcesScreen(),
          ),
        ),
      );
      await container.read(mobileCatalogEntriesProvider(ItemType.manga).future);
      await tester.pumpAndSettle();
      Future<void> tap(Finder finder) async {
        await tester.tap(finder);
        await database.sources.count();
        await tester.pumpAndSettle();
      }

      await tap(find.text('第三方'));
      for (final action in ['设为常用', '取消常用', '卸载']) {
        await tap(find.byTooltip('来源操作'));
        await tap(find.text('批量管理'));
        await tap(find.text('全选'));
        if (action == '取消常用') await tap(find.text('更多'));
        await tap(find.text(action));
        if (action == '卸载') {
          expect(find.text('卸载 2 个来源？'), findsOneWidget);
          await tap(find.widgetWithText(NodeLaneDialogAction, '取消'));
          expect(database.sources.getSync(201)!.isAdded, isTrue);
          await tap(find.text('卸载'));
          await tap(find.widgetWithText(NodeLaneDialogAction, '卸载'));
          expect(database.sources.getSync(201)!.sourceCode, isEmpty);
          expect(database.sources.getSync(202)!.isAdded, isFalse);
        } else {
          expect([
            for (var id = 201; id <= 203; id++)
              database.sources.getSync(id)!.isPinned,
          ], everyElement(action == '设为常用'));
        }
        expect(container.read(isLongPressedStateProvider), isFalse);
      }
      expect(database.sources.getSync(101)!.isAdded, isTrue);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await database.writeTxn(
        () async => database.sources.deleteAll([201, 202, 203]),
      );
    });
  });

  testWidgets(
    'installed official website opens its usable version while an update is available',
    (tester) async {
      final installed = Source.fromJson(source.toJson())
        ..version = '1.0.0'
        ..versionLast = '2.0.0';
      final container = ProviderContainer(
        overrides: [
          nodeLaneCatalogRepositoryProvider(ItemType.manga)
              .overrideWithValue(repo),
          nodeLaneCatalogLoadProvider(ItemType.manga)
              .overrideWith((ref) async {}),
          fetchItemSourcesListProvider(
            reFresh: false,
            itemType: ItemType.manga,
          ).overrideWith((ref) async {}),
          mobileCatalogEntriesProvider(ItemType.manga)
              .overrideWith((ref) => Stream.value([installed])),
        ],
      );
      final router = GoRouter(
        initialLocation: '/browse',
        routes: [
          GoRoute(
            path: '/browse',
            builder: (_, _) => const MobileSourcesScreen(),
          ),
          GoRoute(
            path: '/mangaHome',
            builder: (_, state) {
              final (opened, latest) = state.extra! as (Source, bool);
              expect(opened.sourceCode, 'existing');
              expect(opened.version, '1.0.0');
              expect(latest, isFalse);
              return const Scaffold(body: Text('Opened existing website'));
            },
          ),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(router.dispose);
      await tester.runAsync(() async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              routerConfig: router,
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(platform: TargetPlatform.iOS),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('local'));
        await tester.pumpAndSettle();
        expect(find.text('Opened existing website'), findsOneWidget);
        await database.sources.count();
        await tester.pumpWidget(const SizedBox());
        expect(tester.takeException(), isNull);
      });
    },
  );

  testWidgets(
    'failed update keeps card geometry and installed content; retry repeats only the failed action',
    (tester) async {
      await tester.runAsync(() async {
        final overrides = HttpOverrides.current;
        HttpOverrides.global = null;
        final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        final gate = Completer<void>(), started = Completer<void>();
        final localRepo = Repo(
          jsonUrl: 'http://127.0.0.1:${server.port}/index.json',
        );
        final installed = Source(
          id: 102,
          name: 'Retry fixture',
          lang: 'en',
          isAdded: true,
          sourceCode: 'existing',
          repo: localRepo,
          version: '1.0.0',
          versionLast: '2.0.0',
        );
        var requests = 0;
        PackageInfo.setMockInitialValues(
          appName: 'NodeLane',
          packageName: 'test',
          version: '0.1.0',
          buildNumber: '1',
          buildSignature: '',
        );
        await database.writeTxn(() async => database.sources.put(installed));
        server.listen((request) async {
          if (request.uri.path == '/index.json') {
            requests++;
            if (requests == 1) {
              started.complete();
              await gate.future;
              request.response.statusCode = 503;
            } else {
              request.response.write(jsonEncode([installed.toJson()]));
            }
          } else if (request.uri.path == '/repo.json') {
            request.response.write('{"name":"Fixture"}');
          } else {
            request.response.statusCode = 404;
          }
          await request.response.close();
        });
        final container = ProviderContainer(
          overrides: [
            nodeLaneCatalogRepositoryProvider(ItemType.manga)
                .overrideWithValue(null),
            nodeLaneCatalogLoadProvider(ItemType.manga)
                .overrideWith((ref) async {}),
            fetchItemSourcesListProvider(
              reFresh: false,
              itemType: ItemType.manga,
            ).overrideWith((ref) async {}),
            mobileCatalogEntriesProvider(ItemType.manga)
                .overrideWith((ref) => Stream.value([installed])),
          ],
        );
        final router = GoRouter(
          initialLocation: '/browse',
          observers: [BotToastNavigatorObserver()],
          routes: [
            GoRoute(
              path: '/browse',
              builder: (_, _) => const MobileSourcesScreen(),
            ),
            GoRoute(
              path: '/mangaHome',
              builder: (_, state) {
                final (opened, _) = state.extra! as (Source, bool);
                expect(opened.sourceCode, 'existing');
                return const Scaffold(body: Text('Existing website'));
              },
            ),
          ],
        );
        try {
          tester.view.physicalSize = const Size(390, 844);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: MaterialApp.router(
                routerConfig: router,
                builder: BotToastInit(),
                locale: const Locale('zh'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: ThemeData(platform: TargetPlatform.iOS),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text('第三方'));
          await tester.pumpAndSettle();
          final card = find.byKey(const ValueKey('source-102'));
          final before = tester.getRect(card);
          await tester.tap(find.text('更新'));
          await tester.pump();
          await started.future.timeout(const Duration(seconds: 5));
          expect(tester.getRect(card), before);
          gate.complete();
          Future<void> until(bool Function() done) async {
            for (var i = 0; i < 100 && !done(); i++) {
              await Future<void>.delayed(const Duration(milliseconds: 20));
              await tester.pump();
            }
            expect(done(), isTrue);
          }

          await until(() => find.text('重试').evaluate().isNotEmpty);
          expect(tester.getRect(card), before);
          expect(database.sources.getSync(102)!.sourceCode, 'existing');
          await tester.tap(find.text('重试'));
          await until(
            () =>
                requests == 2 &&
                find.text('重试').evaluate().isEmpty &&
                find.byType(CircularProgressIndicator).evaluate().isEmpty,
          );
          expect(router.routeInformationProvider.value.uri.path, '/browse');
          expect(tester.getRect(card), before);
          await tester.tap(find.text('Retry fixture'));
          await tester.pumpAndSettle();
          expect(find.text('Existing website'), findsOneWidget);
          expect(tester.takeException(), isNull);
        } finally {
          if (!gate.isCompleted) gate.complete();
          await tester.pumpWidget(const SizedBox());
          router.dispose();
          container.dispose();
          await database.writeTxn(() async => database.sources.delete(102));
          await server.close(force: true);
          HttpOverrides.global = overrides;
        }
      });
    },
  );

  for (final (entry, destination) in [
    ('menu', 'header'),
    ('empty state', 'details'),
    ('keyboard', 'view all'),
  ]) {
    testWidgets(
      '$entry carries the query through $destination and preserves cached pages and drafts on return',
      (tester) async {
        final calls = <String>[];
        final container = ProviderContainer(
          retry: (_, _) => null,
          overrides: [
            nodeLaneCatalogRepositoryProvider(ItemType.manga)
                .overrideWithValue(repo),
            nodeLaneCatalogLoadProvider(ItemType.manga)
                .overrideWith((ref) async {}),
            fetchItemSourcesListProvider(
              reFresh: false,
              itemType: ItemType.manga,
            ).overrideWith((ref) async {}),
            mobileCatalogEntriesProvider(ItemType.manga)
                .overrideWith((ref) => Stream.value([source])),
            headersProvider.overrideWith((ref, args) => {}),
            searchProvider.overrideWith((ref, args) async {
              expect(args.filterList, isEmpty);
              calls.add('${args.query}:${args.page}');
              return MPages(
                list: [
                  MManga(
                    name: 'Match ${args.page}',
                    link: '/match-${args.page}',
                    imageUrl: _cover,
                  ),
                ],
                hasNextPage: args.page == 1,
              );
            }),
            getPopularProvider.overrideWith((ref, args) async {
              calls.add('popular');
              return MPages(list: []);
            }),
          ],
        );
        final router = GoRouter(
          initialLocation: '/browse',
          routes: [
            GoRoute(
              path: '/browse',
              builder: (_, _) => const MobileSourcesScreen(),
            ),
            GoRoute(
              path: '/globalSearch',
              builder: (_, state) {
                final (query, type) = state.extra! as (String?, ItemType);
                return GlobalSearchScreen(search: query, itemType: type);
              },
            ),
          ],
        );
        addTearDown(container.dispose);
        addTearDown(router.dispose);
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        // Isar watcher transactions must run outside the fake async clock.
        await tester.runAsync(() async {
          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: MaterialApp.router(
                routerConfig: router,
                locale: const Locale('en'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: ThemeData(platform: TargetPlatform.iOS),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(TextField), '  海岸来信  ');
          await tester.pump();
          expect(calls, isEmpty);
          expect(find.text('添加第三方仓库'), findsNothing);
          expect(find.text('Search titles'), findsNothing);
          expect(
            find.text('Search titles in installed sources'),
            findsOneWidget,
          );
          if (entry == 'keyboard') {
            await tester.testTextInput.receiveAction(TextInputAction.search);
          } else if (entry == 'menu') {
            await tester.tap(find.byTooltip('Source actions'));
            await tester.pumpAndSettle();
            await tester.tap(find.text('Search titles'));
          } else {
            await tester.tap(find.text('Search across sources'));
          }
          await tester.pumpAndSettle();
          expect(calls, ['海岸来信:1']);
          expect(
            tester
                .widget<GlobalSearchScreen>(find.byType(GlobalSearchScreen))
                .search,
            '海岸来信',
          );
          // Editing the next draft must not change the query of visible results.
          await tester.enterText(find.byType(TextFormField), '尚未提交');
          await tester.pump();
          if (destination == 'details') {
            await tester.tap(find.text('Search details'));
            await tester.pumpAndSettle();
            await tester.tap(
              find.descendant(
                of: find.byType(SearchActivitySheet),
                matching: find.text('local'),
              ),
            );
          } else {
            await tester.tap(
              find.descendant(
                of: find.byType(SourceSearchScreen),
                matching: find.text(
                  destination == 'header' ? 'local' : 'View all',
                ),
              ),
            );
          }
          await tester.pumpAndSettle();
          expect(
            tester.widget<MangaHomeScreen>(find.byType(MangaHomeScreen)).query,
            '海岸来信',
          );
          expect(find.text('Match 1'), findsOneWidget);
          expect(calls, ['海岸来信:1']);
          await tester.tap(find.widgetWithText(FilledButton, 'Load More'));
          await tester.pumpAndSettle();
          expect(calls, ['海岸来信:1', '海岸来信:2']);
          expect(find.text('Match 2'), findsOneWidget);
          Navigator.of(tester.element(find.byType(MangaHomeScreen))).pop();
          await tester.pumpAndSettle();
          expect(find.byType(GlobalSearchScreen), findsOneWidget);
          expect(
            tester
                .widget<NodeLaneTextField>(find.byType(NodeLaneTextField))
                .controller!
                .text,
            '尚未提交',
          );
          expect(calls, ['海岸来信:1', '海岸来信:2']);
          expect(tester.takeException(), isNull);
          await database.mangas.count();
          await tester.pumpWidget(const SizedBox());
          await database.mangas.count();
          await tester.pump();
        });
      },
    );
  }
}
