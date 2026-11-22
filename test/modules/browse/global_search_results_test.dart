import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:mangayomi/modules/browse/global_search/search_activity.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_main.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/modules/widgets/source_result_widgets.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

void main() {
  late Directory directory;
  late Isar database;
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    directory = await Directory.systemTemp.createTemp('search-results-');
    database = await Isar.open(
      [SourceSchema, SettingsSchema, MangaSchema, ChapterSchema],
      directory: directory.path,
      name: 'search_results',
    );
    app.isar = database;
  });
  setUp(() {
    database.writeTxnSync(() {
      database.sources.clearSync();
      database.settings.putSync(
        Settings(id: 227, onlyIncludePinnedSources: false, showNSFW: false),
      );
      database.sources.putAllSync([
        for (var i = 1; i <= 4; i++)
          Source(
            id: i,
            name: 'Website $i',
            lang: 'en',
            isAdded: true,
            isActive: true,
            isPinned: i == 1,
          ),
        Source(
          id: 5,
          name: 'Hidden adult',
          lang: 'en',
          isAdded: true,
          isNsfw: true,
        ),
        Source(
          id: 6,
          name: 'Other media',
          lang: 'en',
          isAdded: true,
          itemType: ItemType.novel,
        ),
      ]);
    });
  });
  tearDownAll(() async {
    await database.close(deleteFromDisk: true);
    await directory.delete(recursive: true);
  });

  Future<void> mount(WidgetTester tester, ProviderContainer container) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: const GlobalSearchScreen(
            search: 'Ocean',
            itemType: ItemType.manga,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  MPages matches(String title) => MPages(
    list: [for (var i = 0; i < 6; i++) MManga(name: '$title $i', link: '/$i')],
  );

  Future<void> pumpActivity(WidgetTester tester) async {
    // Waiting for settle would wait forever for deliberately pending requests.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
  }

  testWidgets(
    'only results appear; details update live and retry only the failed website',
    (tester) async {
      await tester.runAsync(() async {
        final pending = {for (var i = 1; i <= 4; i++) i: Completer<MPages?>()};
        final recovered = Completer<MPages?>();
        final calls = <int>[];
        var active = 0, maxActive = 0;
        final container = ProviderContainer(
          retry: (_, _) => null,
          overrides: [
            searchProvider.overrideWith((ref, args) async {
              final id = args.source.id!;
              calls.add(id);
              active++;
              if (active > maxActive) maxActive = active;
              try {
                return await (id == 3 && calls.where((v) => v == 3).length > 1
                    ? recovered.future
                    : pending[id]!.future);
              } finally {
                active--;
              }
            }),
          ],
        );
        addTearDown(container.dispose);
        await mount(tester, container);
        expect(calls, [1, 2, 3]);
        expect(find.byType(SourceResultSection), findsNothing);
        expect(find.textContaining('Website'), findsNothing);
        pending[1]!.complete(matches('Ocean'));
        pending[2]!.complete(MPages(list: []));
        pending[3]!.completeError(StateError('private diagnostic'));
        await pumpActivity(tester);
        expect(calls, [1, 2, 3, 4]);
        expect(maxActive, 3);
        expect(find.text('Website 1'), findsOneWidget);
        for (final id in [2, 3, 4]) {
          expect(find.text('Website $id'), findsNothing);
        }
        expect(find.textContaining('private diagnostic'), findsNothing);
        final strip = find.descendant(
          of: find.byType(SourceResultSection),
          matching: find.byType(ListView),
        );
        await tester.drag(strip, const Offset(-450, 0));
        await pumpActivity(tester);
        final stripState = tester.state<ScrollableState>(
          find.descendant(of: strip, matching: find.byType(Scrollable)),
        );
        final offset = stripState.position.pixels;
        expect(offset, greaterThan(0));
        await tester.tap(find.text('搜索详情'));
        await pumpActivity(tester);
        expect(find.text('Website 2'), findsOneWidget);
        expect(find.textContaining('没有匹配结果'), findsOneWidget);
        expect(find.textContaining('搜索失败'), findsOneWidget);
        expect(find.textContaining('正在搜索'), findsOneWidget);
        await tester.tap(find.widgetWithText(TextButton, '重试'));
        await pumpActivity(tester);
        expect(calls, [1, 2, 3, 4, 3]);
        expect(find.text('重试'), findsNothing);
        recovered.complete(matches('Recovered'));
        pending[4]!.complete(MPages(list: []));
        await pumpActivity(tester);
        expect(find.textContaining('搜索失败'), findsNothing);
        expect(find.textContaining('正在搜索'), findsNothing);
        await tester.tap(find.byTooltip('关闭').hitTestable());
        await tester.pumpAndSettle();
        expect(find.text('Website 3'), findsOneWidget);
        expect(find.text('Website 2'), findsNothing);
        expect(find.text('Website 4'), findsNothing);
        expect(find.byType(SourceResultSection), findsNWidgets(2));
        expect(stripState.position.pixels, offset);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });
    },
  );

  testWidgets(
    'one toolbar serves both result columns and a direct title opens below without querying another level',
    (tester) async {
      await tester.runAsync(() async {
        final calls = <int>[];
        final container = ProviderContainer(
          overrides: [
            searchProvider.overrideWith((_, args) async {
              final id = args.source.id!;
              calls.add(id);
              return id.isOdd ? matches('Match $id') : MPages(list: []);
            }),
            getMangaDetailStreamProvider.overrideWith(
              (_, _) => Stream.value(null),
            ),
            updateMangaDetailProvider.overrideWith((_, _) async {}),
          ],
        );
        addTearDown(container.dispose);
        await mount(tester, container);
        tester.view.physicalSize = const Size(1180, 760);
        await tester.pumpAndSettle();
        final sections = find.byType(SourceResultSection),
            field = find.byType(TextField);
        final left = tester.getRect(sections.first),
            right = tester.getRect(sections.last);
        expect(sections, findsNWidgets(2));
        expect(field, findsOneWidget);
        expect(tester.getRect(field).bottom, lessThan(left.top));
        expect(left.top, right.top);
        expect(left.right, closeTo(right.left, 1));
        expect(left.left, 0);
        expect(right.right, 1180);
        final feed = find.byKey(const ValueKey('Ocean'));
        final initial = tester.getRect(feed);
        final cover = find.text('Match 3 0');
        final book = find.byType(MangaReaderDetail);
        Future<void> openCover() async {
          await tester.tap(cover);
          final deadline = DateTime.now().add(const Duration(seconds: 4));
          do {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            await pumpActivity(tester);
          } while ((book.evaluate().isEmpty ||
                  tester.getRect(book).top > initial.top + 1) &&
              DateTime.now().isBefore(deadline));
          expect(tester.getRect(book), initial);
        }

        await tester.enterText(field, 'next draft');
        await openCover();
        final detailState = tester.state(book);
        expect(tester.getSize(feed), initial.size);
        expect(
          tester.getRect(book).top,
          closeTo(tester.getRect(feed).bottom, 1),
        );
        expect(find.byType(MangaHomeScreen), findsNothing);
        expect(field, findsOneWidget);
        await tester.ensureVisible(cover);
        await tester.pump();
        expect(cover.hitTestable(), findsOneWidget);
        await openCover();
        expect(tester.state(book), same(detailState));
        expect(calls, [1, 2, 3, 4]);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(book, findsNothing);
        expect(tester.getRect(sections.first), left);
        expect(tester.widget<TextField>(field).controller!.text, 'next draft');
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        await database.mangas.count();
      });
    },
  );

  testWidgets(
    'scope changes keep retained results and positions without changing global preferences',
    (tester) async {
      await tester.runAsync(() async {
        final calls = <int>[];
        final container = ProviderContainer(
          retry: (_, _) => null,
          overrides: [
            searchProvider.overrideWith((ref, args) async {
              calls.add(args.source.id!);
              return matches('Ocean');
            }),
          ],
        );
        addTearDown(container.dispose);
        await mount(tester, container);
        await tester.pumpAndSettle();
        expect(calls, [1, 2, 3, 4]);
        final section = find.byType(SourceResultSection).first;
        final scrollable = find.descendant(
          of: section,
          matching: find.byType(Scrollable),
        );
        await tester.drag(scrollable, const Offset(-450, 0));
        await tester.pumpAndSettle();
        final state = tester.state<ScrollableState>(scrollable);
        final offset = state.position.pixels;
        await tester.tap(find.textContaining('全部网站 · 4'));
        await tester.pumpAndSettle();
        expect(find.text('Hidden adult'), findsNothing);
        expect(find.text('Other media'), findsNothing);
        await tester.tap(find.text('常用'));
        await tester.pumpAndSettle();
        expect(find.text('已选 1 个网站'), findsOneWidget);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.byType(SourceResultSection), findsOneWidget);
        expect(state.position.pixels, offset);
        expect(calls, [1, 2, 3, 4]);
        expect(
          database.settings.getSync(227)!.onlyIncludePinnedSources,
          isFalse,
        );
        await tester.tap(find.textContaining('常用网站 · 1'));
        await tester.pumpAndSettle();
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(calls, [1, 2, 3, 4]);
        expect(state.position.pixels, offset);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });
    },
  );

  for (final (reason, installed, hidden) in [
    ('uninstalled', false, false),
    ('unselected', true, false),
    ('hidden', true, true),
  ]) {
    testWidgets('unavailable websites show the $reason recovery action', (
      tester,
    ) async {
      database.writeTxnSync(() {
        database.sources.clearSync();
        database.settings.putSync(
          Settings(id: 227, onlyIncludePinnedSources: true, showNSFW: false),
        );
        database.sources.putAllSync([
          if (installed)
            Source(
              id: 1,
              name: 'Manga website',
              lang: 'en',
              isAdded: true,
              isPinned: hidden,
              isNsfw: hidden,
            ),
          Source(
            id: 2,
            name: 'Novel website',
            itemType: ItemType.novel,
            isAdded: true,
          ),
        ]);
      });
      final calls = <int>[];
      final container = ProviderContainer(
        overrides: [
          searchProvider.overrideWith((ref, args) async {
            calls.add(args.source.id!);
            return MPages(list: []);
          }),
        ],
      );
      addTearDown(container.dispose);
      await mount(tester, container);
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(
        tester.element(find.byType(GlobalSearchScreen)),
      )!;
      final (message, action) = !installed
          ? (
              l10n.global_search_no_sources(ItemType.manga.localized(l10n)),
              l10n.show_extensions,
            )
          : hidden
          ? (l10n.global_search_all_nsfw, l10n.settings)
          : ('当前范围没有可搜索的网站', '搜索范围');
      expect(find.text(message), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, action).hitTestable(),
        findsOneWidget,
      );
      expect(find.byType(SearchActivitySummary), findsNothing);
      expect(calls, isEmpty);
      if (installed && !hidden) {
        await tester.tap(find.widgetWithText(FilledButton, action));
        await tester.pumpAndSettle();
        expect(find.text('Novel website'), findsNothing);
        await tester.tap(find.text('全部'));
        await tester.pumpAndSettle();
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(calls, [1]);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  for (final fail in [false, true]) {
    testWidgets(
      'all ${fail ? 'failed' : 'empty'} websites show one honest empty state',
      (tester) async {
        final container = ProviderContainer(
          retry: (_, _) => null,
          overrides: [
            searchProvider.overrideWith((ref, args) async {
              if (fail) throw StateError('unavailable');
              return MPages(list: []);
            }),
          ],
        );
        addTearDown(container.dispose);
        await mount(tester, container);
        await tester.pumpAndSettle();
        expect(find.byType(SourceResultSection), findsNothing);
        expect(find.textContaining('Website'), findsNothing);
        expect(find.text(fail ? '暂未取得搜索结果' : '未找到相关作品'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(SearchActivitySummary), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
}
