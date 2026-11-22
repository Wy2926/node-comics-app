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
import 'package:mangayomi/repositories/browser_reader_repository.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/global_search/global_search_screen.dart';
import 'package:mangayomi/modules/browse/global_search/search_activity.dart';
import 'package:mangayomi/modules/browse/mobile_sources_screen.dart';
import 'package:mangayomi/modules/browse/widgets/source_website_card.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_main.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/services/get_popular.dart';
import 'package:mangayomi/services/get_source_baseurl.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/services/supports_latest.dart';
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

  test(
    'browser reader requires one exact installed-source title or chapter',
    () async {
      const base = 'https://catalog.example/series',
          url = '$base/one',
          chapterUrl = '$url/read?ch=2';
      final site = Source(
        id: 701,
        baseUrl: base,
        name: 'Site',
        lang: 'en',
        isAdded: true,
        sourceCode: 'fixture',
      );
      final book = Manga.fromJson({
        'id': 702,
        'link': 'one',
        'sourceId': 701,
        'status': 0,
        'favorite': false,
      });
      final chapter = Chapter(
        id: 703,
        mangaId: 702,
        name: 'Two',
        url: '/series/one/read?ch=2',
      )..manga.value = book;
      database.writeTxnSync(() {
        database.sources.putSync(site);
        database.mangas.putSync(book);
        database.chapters.putSync(chapter);
        chapter.manga.saveSync();
      });
      expect(await findBrowserReaderTarget(url), (chapter: false, id: 702));
      expect(await findBrowserReaderTarget(chapterUrl), (
        chapter: true,
        id: 703,
      ));
      for (final other in [
        base,
        '$base/two',
        '$url/read?ch=3',
        chapterUrl.replaceFirst('.example', '.other.example'),
      ]) {
        expect(await findBrowserReaderTarget(other), isNull);
      }
      database.writeTxnSync(
        () => database.sources.putSync(site..isAdded = false),
      );
      expect(await findBrowserReaderTarget(chapterUrl), isNull);
      book.link = chapterUrl;
      database.writeTxnSync(() {
        database.sources.putSync(site..isAdded = true);
        database.mangas.putSync(book);
      });
      expect(await findBrowserReaderTarget(chapterUrl), isNull);
      database.writeTxnSync(() {
        database.chapters.deleteSync(703);
        database.mangas.deleteSync(702);
        database.sources.deleteSync(701);
      });
    },
  );

  test(
    'opening a source only dirties changed last-used records of its media',
    () async {
      final rows = [
        for (var i = 0; i < 4; i++)
          Source(
            id: 900 + i,
            itemType: i == 3 ? ItemType.novel : ItemType.anime,
            lastUsed: i == 0 || i == 3,
            updatedAt: 7,
          ),
      ];
      await database.writeTxn(() => database.sources.putAll(rows));
      await sourceRepository.markLastUsed(ItemType.anime, 901);
      Source row(int i) => database.sources.getSync(900 + i)!;
      expect(
        [for (var i = 0; i < 4; i++) row(i).lastUsed],
        [false, true, false, true],
      );
      expect([row(2).updatedAt, row(3).updatedAt], [7, 7]);
      final timestamps = [row(0).updatedAt, row(1).updatedAt];
      await sourceRepository.markLastUsed(ItemType.anime, 901);
      expect([row(0).updatedAt, row(1).updatedAt], timestamps);
      await sourceRepository.markLastUsed(ItemType.anime, null);
      expect(row(1).lastUsed, isFalse);
      await database.writeTxn(
        () => database.sources.deleteAll([900, 901, 902, 903]),
      );
    },
  );

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
        await tap(find.text('管理'));
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
    'installed site opens its usable version and back restores the filtered directory anchor',
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
          mobileCatalogEntriesProvider(ItemType.manga).overrideWith(
            (ref) => Stream.value([
              for (var i = 0; i < 30; i++)
                Source.fromJson(installed.toJson())
                  ..id = 300 + i
                  ..name = 'Local ${i.toString().padLeft(2, '0')}'
                  ..catalogMetadataJson = i.isEven
                      ? '{"schema":1,"formats":["page"]}'
                      : null,
            ]),
          ),
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
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
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
        await tester.enterText(find.byType(TextField), 'Local');
        await tester.pumpAndSettle();
        final l10n = AppLocalizations.of(
          tester.element(find.byType(MobileSourcesScreen)),
        )!;
        await tester.tap(find.byTooltip(l10n.filter));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(Tab, l10n.source_format));
        await tester.pumpAndSettle();
        final pageChoice = find.widgetWithText(
          FilterChip,
          l10n.source_format_page,
        );
        if (pageChoice.hitTestable().evaluate().isEmpty) {
          await tester.ensureVisible(pageChoice);
        }
        await tester.tap(pageChoice);
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byTooltip(l10n.filter));
        await tester.tap(find.byTooltip(l10n.filter));
        await tester.pumpAndSettle();
        final filter = find.byTooltip(l10n.filter);
        final count = find.descendant(of: filter, matching: find.text('15'));
        expect(
          tester.getCenter(count).dy,
          closeTo(tester.getCenter(find.byType(TextField)).dy, 3),
        );
        final summary = find.descendant(
          of: find.byType(PinnedHeaderSliver),
          matching: find.textContaining(l10n.source_format_page),
        );
        final catalog = find.byKey(const PageStorageKey('catalog-manga-false'));
        final position = Scrollable.of(tester.element(find.text('Local 00')))
            .position;
        await tester.drag(catalog, const Offset(0, -960));
        await tester.pumpAndSettle();
        expect(find.byType(TextField).hitTestable(), findsNothing);
        expect(summary.hitTestable(), findsOneWidget);
        expect(
          find.byTooltip(l10n.feedback_source).hitTestable(),
          findsNothing,
        );
        await tester.drag(catalog, const Offset(0, 180));
        await tester.pumpAndSettle();
        expect(position.pixels, greaterThan(300));
        expect(find.byType(TextField).hitTestable(), findsOneWidget);
        await tester.drag(catalog, const Offset(0, -230));
        await tester.pumpAndSettle();
        final y = position.pixels;
        final name = tester
            .widget<Text>(
              find.textContaining(RegExp(r'^Local \d+$')).hitTestable().first,
            )
            .data!;
        final before = tester.getRect(find.text(name));
        await tester.tap(find.text(name));
        await tester.pumpAndSettle();
        expect(find.text('Opened existing website'), findsOneWidget);
        router.pop();
        await tester.pumpAndSettle();
        expect(summary.hitTestable(), findsOneWidget);
        expect(find.byType(TextField).hitTestable(), findsNothing);
        expect(position.pixels, y);
        expect(tester.getRect(find.text(name)), before);
        await database.sources.count();
        await tester.pumpWidget(const SizedBox());
        expect(tester.takeException(), isNull);
      });
    },
  );

  testWidgets(
    'tablet opens site and book progressively, and back restores the filtered grid anchor',
    (tester) async {
      final reads = <String>[];
      final container = ProviderContainer(
        overrides: [
          nodeLaneCatalogRepositoryProvider(ItemType.manga)
              .overrideWithValue(repo),
          nodeLaneCatalogLoadProvider(ItemType.manga)
              .overrideWith((_) async {}),
          fetchItemSourcesListProvider(
            reFresh: false,
            itemType: ItemType.manga,
          ).overrideWith((_) async {}),
          mobileCatalogEntriesProvider(ItemType.manga).overrideWith(
            (_) => Stream.value([
              for (var i = 0; i < 64; i++)
                Source.fromJson(source.toJson())
                  ..id = 1000 + i
                  ..name = 'Pane $i'
                  ..lang = 'en',
            ]),
          ),
          sourceBaseUrlProvider.overrideWith((_, _) => ''),
          supportsLatestProvider.overrideWith((_, _) => true),
          getPopularProvider.overrideWith((_, args) async {
            final name = args.source.name!;
            reads.add(name);
            return MPages(
              list: [MManga(name: 'Book $name', link: '/book')],
            );
          }),
          getMangaDetailStreamProvider.overrideWith(
            (_, _) => Stream.value(null),
          ),
          updateMangaDetailProvider.overrideWith((_, _) async {}),
        ],
      );
      addTearDown(container.dispose);
      final router = GoRouter(
        initialLocation: '/browse',
        routes: [
          GoRoute(
            path: '/browse',
            builder: (_, _) => const MobileSourcesScreen(),
          ),
        ],
      );
      addTearDown(router.dispose);
      tester.view.physicalSize = const Size(1180, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.runAsync(() async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              routerConfig: router,
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(platform: TargetPlatform.android),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final directory = find.byKey(
          const PageStorageKey('catalog-manga-false'),
        );
        final site = find.byType(MangaHomeScreen),
            book = find.byType(MangaReaderDetail);
        expect(site, findsNothing);
        await tester.enterText(find.byType(TextField), 'Pane');
        await tester.tap(find.widgetWithText(FilterChip, 'English'));
        await tester.tap(find.byTooltip('Filter'));
        await tester.pumpAndSettle();
        await tester.drag(directory, const Offset(0, -820));
        await tester.pumpAndSettle();
        final card = find.byType(SourceWebsiteCard).hitTestable().first;
        final name = tester.widget<SourceWebsiteCard>(card).source.name!;
        final row = find.widgetWithText(SourceWebsiteCard, name);
        final original = tester.getRect(row);
        final width = tester.getSize(directory).width;
        final scroll = tester.widget<CustomScrollView>(directory).controller!;
        final offset = scroll.offset;
        expect(offset, greaterThan(300));
        await tester.tap(card);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 60));
        final during = tester.getRect(site).left;
        expect(
          tester.getSize(directory).width,
          width,
          reason: 'the grid is clipped, not laid out on each tick',
        );
        await tester.pumpAndSettle();
        expect(
          during,
          inExclusiveRange(tester.getSize(directory).width, width),
        );
        expect(
          tester.getRect(directory).right,
          closeTo(tester.getRect(site).left, 1),
        );
        expect(row.hitTestable(), findsOneWidget);
        final cells = find.byType(SourceWebsiteCard, skipOffstage: false);
        final beforePressure = cells.evaluate().length;
        tester.binding.handleMemoryPressure();
        await tester.pumpAndSettle();
        expect(cells.evaluate().length, lessThan(beforePressure));
        expect(row.hitTestable(), findsOneWidget);
        final siteState = tester.state(site);
        final draft = find.descendant(
          of: site,
          matching: find.byType(TextField),
        );
        await tester.enterText(draft, 'unfinished search');
        await tester.tap(find.byTooltip('Display'));
        await tester.pumpAndSettle();
        final coverChoice = find.widgetWithText(
          CheckedPopupMenuItem<DisplayType>,
          'Cover and title',
        );
        await tester.tap(coverChoice);
        await tester.pumpAndSettle();
        expect(reads, [name]);
        expect(find.text('unfinished search'), findsOneWidget);
        await tester.tap(find.byTooltip('Display'));
        await tester.pumpAndSettle();
        expect(
          tester.widget<CheckedPopupMenuItem<DisplayType>>(coverChoice).checked,
          isTrue,
        );
        await tester.tap(
          find.widgetWithText(CheckedPopupMenuItem<DisplayType>, 'List'),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Book $name'));
        // The Isar ID is resolved before the detail opens; its remote contents
        // are independent of the pane navigation exercised here.
        final deadline = DateTime.now().add(const Duration(seconds: 5));
        while (book.evaluate().isEmpty && DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          await tester.pump();
        }
        expect(book, findsOneWidget);
        Future<void> settleLayout() async {
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 250));
          await tester.pump();
        }

        await settleLayout();
        final bookId = tester.widget<MangaReaderDetail>(book).mangaId;
        expect(database.mangas.getSync(bookId)?.name, 'Book $name');
        expect(
          tester.getRect(directory).right,
          closeTo(tester.getRect(site).left, 1),
        );
        expect(
          tester.getRect(site).right,
          closeTo(tester.getRect(book).left, 1),
        );
        tester.view.physicalSize = const Size(900, 720);
        await settleLayout();
        expect(directory, findsNothing);
        expect(
          tester.getRect(site).right,
          closeTo(tester.getRect(book).left, 1),
        );
        tester.view.physicalSize = const Size(540, 800);
        await settleLayout();
        expect(tester.getRect(book).width, 540);
        expect(find.text('Book $name').hitTestable(), findsNothing);
        expect(await router.routerDelegate.popRoute(), isTrue);
        await tester.pumpAndSettle();
        expect(book, findsNothing);
        expect(tester.state(site), same(siteState));
        expect(draft.hitTestable(), findsOneWidget);
        expect(find.text('unfinished search'), findsOneWidget);
        tester.view.physicalSize = const Size(1180, 720);
        await tester.pumpAndSettle();
        final other = tester
            .widgetList<SourceWebsiteCard>(
              find.byType(SourceWebsiteCard).hitTestable(),
            )
            .firstWhere((card) => card.source.name != name)
            .source
            .name!;
        await tester.tap(find.widgetWithText(SourceWebsiteCard, other));
        await tester.pumpAndSettle();
        expect(find.text('Book $other'), findsOneWidget);
        expect(reads, [name, other]);
        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();
        expect(site, findsNothing);
        expect(scroll.offset, closeTo(offset, 1));
        expect(tester.getRect(row), original);
        final summary = find.byType(PinnedHeaderSliver);
        expect(
          find.descendant(of: summary, matching: find.text('English')),
          findsOneWidget,
        );
        await tester.drag(directory, const Offset(0, 240));
        await tester.pumpAndSettle();
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          'Pane',
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        await database.sources.count();
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
          expect(find.text('Search across sources'), findsOneWidget);
          if (entry == 'keyboard') {
            await tester.testTextInput.receiveAction(TextInputAction.search);
          } else if (entry == 'menu') {
            await tester.tap(find.text('Manage'));
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
                of: find.byType(SearchActivityPage),
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
