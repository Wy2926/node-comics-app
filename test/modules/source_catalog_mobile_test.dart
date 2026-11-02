import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/modules/manga/home/widget/mobile_source_catalog.dart';
import 'package:mangayomi/modules/manga/home/widget/mobile_source_filters.dart';
import 'package:mangayomi/modules/widgets/listview_widget.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/services/get_popular.dart';
import 'package:mangayomi/services/local_source_page.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/headers.dart';

const _cover =
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aX1cAAAAASUVORK5CYII=';
MManga _book(String title) =>
    MManga(name: title, link: '/$title', imageUrl: _cover);

void main() {
  Future<void> mount(
    WidgetTester tester,
    Widget child, {
    double scale = 1,
    double inset = 0,
  }) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
            viewInsets: EdgeInsets.only(bottom: inset),
            padding: const EdgeInsets.only(top: 24, bottom: 34),
          ),
          child: child!,
        ),
        home: child,
      ),
    );
    await tester.pump();
  }

  testWidgets(
    'source header preserves a draft and lazy results remain usable with keyboard',
    (tester) async {
      final input = TextEditingController(text: 'Seed');
      final scroll = ScrollController();
      addTearDown(input.dispose);
      addTearDown(scroll.dispose);
      final submitted = <String>[];
      var opened = 0, added = 0;
      await mount(
        tester,
        MobileSourceCatalog(
          title: 'A source with a long name',
          search: input,
          onSubmit: () => submitted.add(input.text),
          onClear: input.clear,
          selected: 2,
          supportsLatest: true,
          filtering: true,
          onSelect: (_) {},
          onFilter: () {},
          onOptions: () {},
          results: MobileSourceResults(
            controller: scroll,
            display: DisplayType.comfortableGrid,
            count: 80,
            status: 'Results for Seed',
            gridSize: 6,
            itemBuilder: (_, index) => MobileSourceMangaCard(
              title: 'Book $index with a long title',
              cover: const ColoredBox(color: Colors.blueGrey),
              onOpen: () => opened++,
              onQuickAdd: () => added++,
              inLibrary: index == 0,
            ),
            footer: const MobileSourceStatus(message: 'Reached end'),
          ),
        ),
        inset: 260,
      );
      await tester.enterText(find.byType(TextField), 'Draft');
      await tester.pump();
      expect(submitted, isEmpty);
      expect(find.text('Results for Seed'), findsOneWidget);
      expect(
        find.byType(MobileSourceMangaCard).evaluate().length,
        lessThan(12),
      );
      await tester.tap(find.byTooltip('Search...'));
      expect(submitted, ['Draft']);
      // Results have their own scroll viewport; the header never consumes it all.
      final resultScroll = find.descendant(
        of: find.byType(MobileSourceResults),
        matching: find.byType(Scrollable),
      );
      await tester.drag(resultScroll, const Offset(0, -80));
      await tester.pumpAndSettle();
      final coverPoint =
          tester.getTopLeft(find.byType(MobileSourceMangaCard).first) +
          const Offset(40, 90);
      await tester.tapAt(coverPoint);
      await tester.longPressAt(coverPoint);
      expect(opened, 1);
      expect(added, 1);
      await tester.tap(find.byTooltip('Reset'));
      expect(input.text, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'filter route cancels a deep draft, resets nonempty defaults and returns typed values only on apply',
    (tester) async {
      final initial = <dynamic>[
        TextFilter(
          'author',
          'Author with a long label',
          'TextFilter',
          state: 'Initial',
        ),
        GroupFilter('group', 'Genres', [
          CheckBoxFilter('genre', 'Adventure', 'adventure', 'CheckBox'),
        ], 'GroupFilter'),
        SelectFilter('order', 'A long ordering choice', 0, [
          SelectFilterOption('Original order', 'first', 'SelectOption'),
          SelectFilterOption(
            'A long alternate order that must wrap completely',
            'second',
            'SelectOption',
          ),
        ], 'SelectFilter'),
        HeaderFilter('Explanation', 'HeaderFilter', type: 'preserve-header'),
      ];
      List<dynamic>? applied;
      await mount(
        tester,
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () async {
                  applied = await showNodeLaneCatalogSheet<List<dynamic>>(
                    context,
                    MobileSourceFilterSheet(
                      filters: initial,
                      defaults: () => [
                        TextFilter(
                          'author',
                          'Author with a long label',
                          'TextFilter',
                          state: 'Default',
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Open filters'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open filters'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Draft');
      await tester.ensureVisible(find.text('Adventure'));
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect((initial[0] as TextFilter).state, 'Initial');
      expect(
        ((initial[1] as GroupFilter).state[0] as CheckBoxFilter).state,
        false,
      );
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(applied, isNull);
      await tester.tap(find.text('Open filters'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Initial',
      );
      await tester.ensureVisible(find.text('A long ordering choice'));
      await tester.tap(find.text('A long ordering choice'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('A long alternate order that must wrap completely'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, '应用筛选'));
      await tester.pumpAndSettle();
      expect((applied![2] as SelectFilter).state, 1);
      expect((applied![3] as HeaderFilter).type, 'preserve-header');
      expect((initial[2] as SelectFilter).state, 0);
      await tester.tap(find.text('Open filters'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Reset'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Default',
      );
      await tester.tap(find.widgetWithText(FilledButton, '应用筛选'));
      await tester.pumpAndSettle();
      expect((applied!.single as TextFilter).state, 'Default');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sort selection preserves direction and tri-state is explicit in an isolated draft',
    (tester) async {
      final original = [
        SortFilter('sort', '排序', SortState(0, false, 'SortState'), [
          SelectFilterOption('最近更新', 'updated', 'SelectOption'),
          SelectFilterOption('人气', 'popular', 'SelectOption'),
        ], 'SortFilter'),
        TriStateFilter('genre', '冒险', 'adventure', 'TriState', state: 0),
      ];
      final draft = copySourceFilters(original);
      await mount(tester, Scaffold(body: SourceFilterFields(filters: draft)));
      await tester.tap(find.text('排序'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('人气'));
      await tester.pumpAndSettle();
      expect((draft[0] as SortFilter).state.index, 1);
      expect((draft[0] as SortFilter).state.ascending, isFalse);
      await tester.tap(find.text('升序'));
      await tester.tap(find.text('排除'));
      await tester.pumpAndSettle();
      expect((draft[0] as SortFilter).state.ascending, isTrue);
      expect((draft[1] as TriStateFilter).state, 2);
      expect((original[0] as SortFilter).state.index, 0);
      expect((original[0] as SortFilter).state.ascending, isFalse);
      expect((original[1] as TriStateFilter).state, 0);
      expect(tester.takeException(), isNull);
    },
  );

  test('local source ends at an empty or partial page and retains the original 50-row window', () async {
    for (final count in [0, 49, 50]) {
      final result = await localSourcePage((offset, limit) async {
        expect(offset, 50);
        expect(limit, 50);
        return List.generate(
          count,
          (i) => Manga(
            name: 'Local $i',
            source: 'local',
            sourceId: 120,
            author: '',
            artist: '',
            genre: [],
            imageUrl: '',
            lang: '',
            link: '/$i',
            status: Status.unknown,
            description: '',
          ),
        );
      }, 2);
      expect(result.list.length, count);
      expect(result.hasNextPage, count == 50);
    }
  });

  group(
    'source request owner with isolated database and service substitutes',
    () {
      late Directory directory;
      late Isar database;
      final source = Source(
        id: 120,
        name: 'local',
        lang: '',
        itemType: ItemType.manga,
      );
      setUpAll(() async {
        await Isar.initializeIsarCore(download: true);
        directory = await Directory.systemTemp.createTemp(
          'nodelane-source-test-',
        );
        database = await Isar.open(
          [SourceSchema, SettingsSchema, MangaSchema, ChapterSchema],
          directory: directory.path,
          name: 'source_catalog_test',
        );
        app.isar = database;
        database.writeTxnSync(
          () => database.settings.putSync(
            Settings(id: 227, mangaHomeDisplayType: DisplayType.list),
          ),
        );
      });
      tearDownAll(() async {
        await database.close(deleteFromDisk: true);
        await directory.delete(recursive: true);
      });

      testWidgets(
        'seed clear and pagination retry preserve results, discard old completion and stop on empty last page',
        (tester) async {
          final oldPage = Completer<MPages?>();
          final calls = <String>[];
          var attempts = 0;
          await tester.runAsync(
            () => mount(
              tester,
              ProviderScope(
                overrides: [
                  headersProvider.overrideWith((ref, args) => {}),
                  searchProvider.overrideWith((ref, args) async {
                    calls.add('${args.query}:${args.page}');
                    if (args.query == 'Seed' && args.page == 2) {
                      return oldPage.future;
                    }
                    return MPages(list: [_book(args.query)], hasNextPage: true);
                  }),
                  getPopularProvider.overrideWith((ref, args) async {
                    calls.add('popular:${args.page}');
                    if (args.page == 2 && attempts++ == 0) {
                      throw StateError('Page two failed');
                    }
                    return MPages(
                      list: args.page == 1 ? [_book('Popular')] : [],
                      hasNextPage: args.page == 1,
                    );
                  }),
                ],
                retry: (_, _) => null,
                child: MangaHomeScreen(
                  source: source,
                  isSearch: true,
                  query: 'Seed',
                ),
              ),
              scale: 1,
            ),
          );
          await tester.pumpAndSettle();
          await tester.tap(find.widgetWithText(FilledButton, 'Load More'));
          await tester.pump();
          expect(calls, ['Seed:1', 'Seed:2']);
          final field = tester.widget<SeachFormTextField>(
            find.byType(SeachFormTextField),
          );
          field.onSuffixPressed();
          await tester.pumpAndSettle();
          expect(calls.last, 'popular:1');
          oldPage.complete(
            MPages(list: [_book('Old late result')], hasNextPage: false),
          );
          await tester.pumpAndSettle();
          expect(find.text('Old late result'), findsNothing);
          expect(find.text('Popular'), findsWidgets);
          await tester.tap(find.widgetWithText(FilledButton, 'Load More'));
          await tester.pumpAndSettle();
          expect(find.text('暂时无法加载'), findsOneWidget);
          await tester.tap(find.text('查看错误详情'));
          await tester.pumpAndSettle();
          expect(find.textContaining('Page two failed'), findsOneWidget);
          expect(find.byType(MangaHomeImageCardListTile), findsOneWidget);
          await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
          await tester.pumpAndSettle();
          expect(calls, [
            'Seed:1',
            'Seed:2',
            'popular:1',
            'popular:2',
            'popular:2',
          ]);
          expect(find.widgetWithText(FilledButton, 'Load More'), findsNothing);
          expect(find.byType(MangaHomeImageCardListTile), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.runAsync(() => database.mangas.count());
          await tester.pump();
          await tester.pumpWidget(const SizedBox());
          await tester.runAsync(() => database.mangas.count());
          await tester.pump();
        },
      );

      testWidgets(
        'full-data sources reveal a finite local window without requesting a second page',
        (tester) async {
          final calls = <int>[];
          await tester.runAsync(
            () => mount(
              tester,
              ProviderScope(
                overrides: [
                  headersProvider.overrideWith((ref, args) => {}),
                  getPopularProvider.overrideWith((ref, args) async {
                    calls.add(args.page);
                    return MPages(
                      list: List.generate(60, (i) => _book('Book $i')),
                    );
                  }),
                ],
                child: MangaHomeScreen(
                  source: Source(
                    id: 121,
                    name: 'local',
                    lang: '',
                    itemType: ItemType.manga,
                    isFullData: true,
                  ),
                ),
              ),
              scale: 1,
            ),
          );
          await tester.pumpAndSettle();
          expect(
            tester
                .widget<SuperListViewWidget>(find.byType(SuperListViewWidget))
                .itemCount,
            51,
          );
          // Ask the existing lazy builder for its footer instead of rendering every cover.
          final view = tester.widget<SuperListViewWidget>(
            find.byType(SuperListViewWidget),
          );
          final footer = view.itemBuilder(
            tester.element(find.byType(SuperListViewWidget)),
            50,
          ) as MobileSourceStatus;
          footer.onLoadMore!();
          await tester.pumpAndSettle();
          expect(
            tester
                .widget<SuperListViewWidget>(find.byType(SuperListViewWidget))
                .itemCount,
            61,
          );
          expect(calls, [1]);
          expect(tester.takeException(), isNull);
          await tester.runAsync(() => database.mangas.count());
          await tester.pump();
          await tester.pumpWidget(const SizedBox());
          await tester.runAsync(() => database.mangas.count());
          await tester.pump();
        },
      );
    },
  );
}
