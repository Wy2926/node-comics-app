// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_source_badge_provider.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/mobile_bookshelf_settings.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

void main() {
  late Directory root;
  late Isar database;
  late StreamController<Settings> settingsEvents;
  final entries = [
    for (var i = 0; i < 40; i++)
      Manga(
        source: 'Source ${i.toString().padLeft(2, '0')}',
        name: 'Comic $i',
        author: '',
        artist: '',
        genre: [],
        imageUrl: '',
        lang: 'en',
        link: '',
        status: Status.unknown,
        description: '',
        sourceId: null,
      ),
  ];
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    root = await Directory.systemTemp.createTemp('nodelane-shelf-settings-');
    database = await Isar.open(
      [SettingsSchema, SourceSchema],
      directory: root.path,
      name: 'shelf_settings',
    );
    app.isar = database;
  });
  setUp(() {
    database.writeTxnSync(
      () => database.settings.putSync(
        Settings(
          id: 227,
          mangaGridSize: 2,
          libraryFilterMangasSourceIds: ['Source 00'],
          libraryFilterAnimeUnreadType: 2,
          libraryFilterNovelStartedType: 1,
        ),
      ),
    );
  });
  tearDownAll(() async {
    await Isar.getInstance('shelf_settings')?.close(deleteFromDisk: true);
    await root.delete(recursive: true);
  });

  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() => dbWriteQueue.run(() {}));
    // Deliver the actual persisted snapshot through a controlled stream. Native
    // Isar watch delivery is verified in the simulator, not the fake test clock.
    settingsEvents.add(settingsRepository.current);
    await tester.pumpAndSettle();
  }

  Future<void> start(
    WidgetTester tester, {
    ItemType type = ItemType.manga,
  }) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    settingsEvents = StreamController<Settings>.broadcast(sync: true);
    final container = ProviderContainer(
      overrides: [
        getSettingsStreamProvider.overrideWith((_) => settingsEvents.stream),
        getAllMangaStreamProvider(
          categoryId: null,
          itemType: type,
        ).overrideWith((_) => Stream.value(entries)),
      ],
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await settingsEvents.close();
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Align(
              alignment: Alignment.topRight,
              child: Builder(
                builder: (anchor) => TextButton(
                  onPressed: () => showNodeLaneBubble<void>(
                    anchor,
                    label: 'Shelf tools',
                    width: 440,
                    child: NodeLaneBubbleFlow(
                      home: MobileBookshelfSettings(
                        itemType: type,
                        settings: settingsRepository.current,
                        entries: entries,
                      ),
                    ),
                  ),
                  child: const Text('Shelf tools'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Shelf tools'));
    await settle(tester);
  }

  Finder scrollable(String list) => find
      .descendant(
        of: find.byKey(PageStorageKey(list)),
        matching: find.byType(Scrollable),
      )
      .first;

  Finder choice(String filter, String text) => find.descendant(
    of: find.widgetWithText(NodeLaneOptionSwitch<int>, filter),
    matching: find.text(text),
  );

  Future<void> reveal(WidgetTester tester, Finder finder, String list) async {
    await tester.scrollUntilVisible(finder, 220, scrollable: scrollable(list));
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  Future<void> tab(WidgetTester tester, String name) async {
    await tester.tap(
      find.descendant(of: find.byType(TabBar), matching: find.text(name)),
    );
    await tester.pumpAndSettle();
  }

  for (final type in ItemType.values) {
    test('cached ${type.name} settings callbacks preserve other writes', () async {
      final container = ProviderContainer();
      final original = settingsRepository.current;
      addTearDown(container.dispose);
      // A covered route can retain distinct settings snapshots until its native
      // stream resumes. Capture every callback before any write is delivered.
      final display = container.read(
        libraryDisplayTypeStateProvider(
          itemType: type,
          settings: settingsRepository.current,
        ).notifier,
      );
      final toggles = [
        container
            .read(
              libraryDownloadedChaptersStateProvider(
                itemType: type,
                settings: settingsRepository.current,
              ).notifier,
            )
            .set,
        container
            .read(
              libraryLanguageStateProvider(
                itemType: type,
                settings: settingsRepository.current,
              ).notifier,
            )
            .set,
        container
            .read(
              libraryLocalSourceStateProvider(
                itemType: type,
                settings: settingsRepository.current,
              ).notifier,
            )
            .set,
        container
            .read(
              libraryShowCategoryTabsStateProvider(
                itemType: type,
                settings: settingsRepository.current,
              ).notifier,
            )
            .set,
        container
            .read(
              libraryShowNumbersOfItemsStateProvider(
                itemType: type,
                settings: settingsRepository.current,
              ).notifier,
            )
            .set,
        container
            .read(
              libraryShowContinueReadingButtonStateProvider(
                itemType: type,
                settings: settingsRepository.current,
              ).notifier,
            )
            .set,
      ];
      final unread = container.read(
        mangaFilterUnreadStateProvider(
          mangaList: const [],
          itemType: type,
          settings: settingsRepository.current,
        ).notifier,
      );
      final sources = container.read(
        mangaFilterSourceStateProvider(
          mangaList: entries,
          itemType: type,
          settings: settingsRepository.current,
        ).notifier,
      );
      final sort = container.read(
        sortLibraryMangaStateProvider(
          itemType: type,
          settings: settingsRepository.current,
        ).notifier,
      );

      display.setLibraryDisplayType(DisplayType.coverOnlyGrid);
      container.read(librarySourceBadgeProvider.notifier).set(true);
      for (final toggle in toggles) {
        toggle(false);
      }
      unread.setType(1);
      sources.set(['Source 01']);
      sort.update(false, 4);
      await dbWriteQueue.run(() {});

      final saved = settingsRepository.current;
      expect(saved.showSourceBadge, isTrue);
      final values = switch (type) {
        ItemType.manga => (
          saved.displayType,
          saved.libraryDownloadedChapters,
          saved.libraryShowLanguage,
          saved.libraryLocalSource,
          saved.libraryShowCategoryTabs,
          saved.libraryShowNumbersOfItems,
          saved.libraryShowContinueReadingButton,
          saved.libraryFilterMangasUnreadType,
          saved.libraryFilterMangasSourceIds,
          saved.sortLibraryManga,
        ),
        ItemType.anime => (
          saved.animeDisplayType,
          saved.animeLibraryDownloadedChapters,
          saved.animeLibraryShowLanguage,
          saved.animeLibraryLocalSource,
          saved.animeLibraryShowCategoryTabs,
          saved.animeLibraryShowNumbersOfItems,
          saved.animeLibraryShowContinueReadingButton,
          saved.libraryFilterAnimeUnreadType,
          saved.libraryFilterAnimeSourceIds,
          saved.sortLibraryAnime,
        ),
        ItemType.novel => (
          saved.novelDisplayType,
          saved.novelLibraryDownloadedChapters,
          saved.novelLibraryShowLanguage,
          saved.novelLibraryLocalSource,
          saved.novelLibraryShowCategoryTabs,
          saved.novelLibraryShowNumbersOfItems,
          saved.novelLibraryShowContinueReadingButton,
          saved.libraryFilterNovelUnreadType,
          saved.libraryFilterNovelSourceIds,
          saved.sortLibraryNovel,
        ),
      };
      expect(values.$1, DisplayType.coverOnlyGrid);
      expect([
        values.$2,
        values.$3,
        values.$4,
        values.$5,
        values.$6,
        values.$7,
      ], everyElement(isFalse));
      expect(values.$8, 1);
      expect(values.$9, ['Source 01']);
      expect(values.$10?.index, 4);
      for (final other in ItemType.values.where((value) => value != type)) {
        expect(
          container.read(
            libraryDisplayTypeStateProvider(itemType: other, settings: saved),
          ),
          container.read(
            libraryDisplayTypeStateProvider(
              itemType: other,
              settings: original,
            ),
          ),
        );
      }
    });
  }

  testWidgets('anime filters keep manga and novel preferences isolated', (
    tester,
  ) async {
    await start(tester, type: ItemType.anime);
    expect(find.text('Unwatched'), findsOneWidget);
    await tester.tap(choice('Unwatched', 'Include'));
    await settle(tester);
    expect(settingsRepository.current.libraryFilterAnimeUnreadType, 1);
    expect(settingsRepository.current.libraryFilterMangasUnreadType, 0);
    expect(settingsRepository.current.libraryFilterNovelStartedType, 1);
    await tab(tester, 'Display');
    expect(find.text('Show continue watching buttons'), findsOneWidget);
    expect(find.byType(Slider), findsNothing);
  });

  testWidgets(
    'narrow large text wraps the shelf filter options without clipping the choice',
    (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await start(tester, type: ItemType.novel);
      tester.view.physicalSize = const Size(320, 740);
      await tester.pumpAndSettle();
      final exclude = choice('Downloaded', 'Exclude');
      expect(
        tester.getTopLeft(exclude).dy,
        greaterThan(tester.getTopLeft(choice('Downloaded', 'Any')).dy),
      );
      await tester.ensureVisible(exclude);
      await tester.tap(exclude);
      await settle(tester);
      expect(settingsRepository.current.libraryFilterNovelDownloadType, 2);
      expect(settingsRepository.current.libraryFilterMangasDownloadType, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'explicit filter states persist only manga settings and retain tab position',
    (tester) async {
      await start(tester);
      await tester.tap(choice('Downloaded', 'Include'));
      await settle(tester);
      await tester.tap(choice('Unread', 'Exclude'));
      await settle(tester);
      expect(settingsRepository.current.libraryFilterMangasDownloadType, 1);
      expect(settingsRepository.current.libraryFilterMangasUnreadType, 2);
      expect(settingsRepository.current.libraryFilterAnimeUnreadType, 2);
      expect(settingsRepository.current.libraryFilterNovelStartedType, 1);
      await reveal(tester, choice('Tracked', 'Include'), 'bookshelf-filters');
      double offset() => tester
          .state<ScrollableState>(scrollable('bookshelf-filters'))
          .position
          .pixels;
      final before = offset();
      await tab(tester, 'Sort');
      await tab(tester, 'Filter');
      expect(offset(), closeTo(before, .1));
      await tester.tap(choice('Tracked', 'Include'));
      await settle(tester);
      expect(settingsRepository.current.libraryFilterMangasTrackingType, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sort direction is explicit and display writes keep other preferences',
    (tester) async {
      await start(tester);
      await tab(tester, 'Sort');
      await tester.tap(find.text('Descending'));
      await settle(tester);
      expect(
        settingsRepository.current.sortLibraryManga?.reverse,
        true,
        reason: 'explicit direction applies to the initial criterion',
      );
      await reveal(tester, find.text('Date added'), 'bookshelf-sort');
      final chooseDate = tester
          .widget<NodeLaneRow>(find.widgetWithText(NodeLaneRow, 'Date added'))
          .onTap!;
      chooseDate();
      chooseDate();
      await settle(tester);
      expect(
        settingsRepository.current.sortLibraryManga?.reverse,
        true,
        reason: 'changing criterion keeps the chosen direction',
      );
      expect(
        tester
            .widget<NodeLaneRow>(find.widgetWithText(NodeLaneRow, 'Date added'))
            .selected,
        true,
      );
      await tester.tap(find.text('Date added'));
      await settle(tester);
      expect(settingsRepository.current.sortLibraryManga?.index, 6);
      expect(settingsRepository.current.sortLibraryManga?.reverse, true);
      await tab(tester, 'Display');
      expect(
        tester
            .widget<NodeLaneChoiceCard>(
              find.widgetWithText(NodeLaneChoiceCard, 'Comfortable grid'),
            )
            .selected,
        true,
      );
      await tester.tap(find.widgetWithText(NodeLaneChoiceCard, 'List'));
      await settle(tester);
      expect(settingsRepository.current.displayType, DisplayType.list);
      expect(find.byType(Slider), findsNothing);
      await tester.tap(
        find.widgetWithText(NodeLaneChoiceCard, 'Comfortable grid'),
      );
      await settle(tester);
      expect(find.byType(Slider), findsNothing);
      expect(settingsRepository.current.mangaGridSize, 2);
      await reveal(
        tester,
        find.text('More display options'),
        'bookshelf-display',
      );
      await tester.tap(find.text('More display options'));
      await tester.pumpAndSettle();
      await reveal(tester, find.text('Source'), 'bookshelf-display');
      await tester.tap(find.text('Source'));
      await settle(tester);
      await tester.ensureVisible(find.text('Language'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Language'));
      await settle(tester);
      expect(settingsRepository.current.showSourceBadge, false);
      expect(settingsRepository.current.libraryShowLanguage, false);
      expect(settingsRepository.current.mangaGridSize, 2);
      expect(settingsRepository.current.sortLibraryManga?.reverse, true);
      expect(settingsRepository.current.libraryFilterMangasSourceIds, [
        'Source 00',
      ]);
      await reveal(
        tester,
        find.text('Show numbers of items'),
        'bookshelf-display',
      );
      expect(find.byTooltip('Close').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'source search preserves hidden choices and cancellation discards the draft',
    (tester) async {
      await start(tester);
      Future<void> open() async {
        await reveal(tester, find.text('Sources'), 'bookshelf-filters');
        await tester.tap(find.text('Sources'));
        await tester.pumpAndSettle();
      }

      await open();
      expect(
        find.ancestor(
          of: find.byType(MobileBookshelfSourceFilter),
          matching: find.byType(NodeLaneBubbleFlow),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Source 01'));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(settingsRepository.current.libraryFilterMangasSourceIds, [
        'Source 00',
      ]);
      await open();
      expect(
        tester
            .widget<NodeLaneRow>(find.widgetWithText(NodeLaneRow, 'Source 01'))
            .selected,
        false,
      );
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      await tester.enterText(find.byType(TextField), 'Source 39');
      await tester.pumpAndSettle();
      final lastSource = find.widgetWithText(NodeLaneRow, 'Source 39');
      await tester.ensureVisible(lastSource);
      await tester.tap(lastSource);
      await tester.pump();
      expect(find.text('2 sources selected'), findsOneWidget);
      expect(tester.getBottomLeft(find.text('Cancel')).dy, lessThan(460));
      await tester.tap(find.widgetWithText(FilledButton, 'Filter'));
      tester.view.viewInsets = const FakeViewPadding();
      await settle(tester);
      expect(settingsRepository.current.libraryFilterMangasSourceIds, [
        'Source 00',
        'Source 39',
      ]);
      await open();
      await tester.tap(
        find.descendant(
          of: find.byType(MobileBookshelfSourceFilter),
          matching: find.widgetWithText(TextButton, 'Reset'),
        ),
      );
      await tester.pump();
      expect(find.text('All sources'), findsOneWidget);
      expect(settingsRepository.current.libraryFilterMangasSourceIds, [
        'Source 00',
        'Source 39',
      ]);
      await tester.tap(find.widgetWithText(FilledButton, 'Filter'));
      await settle(tester);
      expect(settingsRepository.current.libraryFilterMangasSourceIds, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
}
