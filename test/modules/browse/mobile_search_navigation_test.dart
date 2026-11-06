import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/global_search/global_search_screen.dart';
import 'package:mangayomi/modules/browse/mobile_sources_screen.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
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
      [SourceSchema, SettingsSchema, MangaSchema, ChapterSchema],
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

  for (final entry in ['menu', 'empty state', 'keyboard']) {
    testWidgets(
      '$entry carries the query through view-all, reuses page one, and preserves it for pagination and back',
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
          expect(find.text('搜作品'), findsNothing);
          expect(find.text('在已安装来源中搜索作品'), findsOneWidget);
          if (entry == 'keyboard') {
            await tester.testTextInput.receiveAction(TextInputAction.search);
          } else if (entry == 'menu') {
            await tester.tap(find.byTooltip('来源操作'));
            await tester.pumpAndSettle();
            await tester.tap(find.text('搜作品'));
          } else {
            await tester.tap(find.text('跨来源搜索'));
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
          await tester.tap(
            find.descendant(
              of: find.byType(SourceSearchScreen),
              matching: find.text('local'),
            ),
          );
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
                .widget<SeachFormTextField>(find.byType(SeachFormTextField))
                .controller
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
