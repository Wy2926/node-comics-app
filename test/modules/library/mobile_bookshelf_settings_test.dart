// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
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

  Future<void> start(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    settingsEvents = StreamController<Settings>.broadcast(sync: true);
    final container = ProviderContainer(
      overrides: [
        getSettingsStreamProvider.overrideWith((_) => settingsEvents.stream),
        getAllMangaStreamProvider(
          categoryId: null,
          itemType: ItemType.manga,
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
            body: MobileBookshelfSettings(
              settings: settingsRepository.current,
              entries: entries,
            ),
          ),
        ),
      ),
    );
    await settle(tester);
  }

  Future<void> reveal(WidgetTester tester, Finder finder, String list) async {
    final scrollable = find
        .descendant(
          of: find.byKey(PageStorageKey(list)),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(finder, 220, scrollable: scrollable);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  Future<void> tab(WidgetTester tester, String name) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NodeLaneTabSegments),
        matching: find.text(name),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'explicit filter states persist only manga settings and retain tab position',
    (tester) async {
      await start(tester);
      Finder choice(int index, String text) => find.descendant(
        of: find.byKey(ValueKey('bookshelf-filter-$index')),
        matching: find.text(text),
      );
      await tester.tap(choice(0, 'Include'));
      await settle(tester);
      await tester.tap(choice(1, 'Exclude'));
      await settle(tester);
      expect(settingsRepository.current.libraryFilterMangasDownloadType, 1);
      expect(settingsRepository.current.libraryFilterMangasUnreadType, 2);
      expect(settingsRepository.current.libraryFilterAnimeUnreadType, 2);
      expect(settingsRepository.current.libraryFilterNovelStartedType, 1);
      await reveal(tester, choice(5, 'Include'), 'bookshelf-filters');
      final scrollable = find
          .descendant(
            of: find.byKey(const PageStorageKey('bookshelf-filters')),
            matching: find.byType(Scrollable),
          )
          .first;
      final before = tester.state<ScrollableState>(scrollable).position.pixels;
      await tab(tester, 'Sort');
      await tab(tester, 'Filter');
      expect(
        tester.state<ScrollableState>(scrollable).position.pixels,
        closeTo(before, .1),
      );
      await tester.tap(choice(5, 'Include'));
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
          .widget<ListTile>(find.widgetWithText(ListTile, 'Date added'))
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
            .widget<ListTile>(find.widgetWithText(ListTile, 'Date added'))
            .selected,
        true,
      );
      await tester.tap(find.text('Date added'));
      await settle(tester);
      expect(settingsRepository.current.sortLibraryManga?.index, 6);
      expect(settingsRepository.current.sortLibraryManga?.reverse, true);
      await tab(tester, 'Display');
      await tester.tap(find.widgetWithText(ChoiceChip, 'List'));
      await settle(tester);
      expect(settingsRepository.current.displayType, DisplayType.list);
      expect(find.byType(Slider), findsNothing);
      await tester.tap(find.widgetWithText(ChoiceChip, 'Comfortable grid'));
      await settle(tester);
      var slider = tester.widget<Slider>(find.byType(Slider));
      slider.onChanged!(4);
      await tester.pump();
      expect(settingsRepository.current.mangaGridSize, 2);
      slider = tester.widget<Slider>(find.byType(Slider));
      slider.onChangeEnd!(4);
      await settle(tester);
      expect(settingsRepository.current.mangaGridSize, 4);
      await reveal(tester, find.text('Source'), 'bookshelf-display');
      await tester.tap(find.text('Source'));
      await settle(tester);
      await tester.ensureVisible(find.text('Language'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Language'));
      await settle(tester);
      expect(settingsRepository.current.showSourceBadge, true);
      expect(settingsRepository.current.libraryShowLanguage, true);
      expect(settingsRepository.current.mangaGridSize, 4);
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
      await tester.tap(find.text('Source 01'));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(settingsRepository.current.libraryFilterMangasSourceIds, [
        'Source 00',
      ]);
      await open();
      expect(
        tester
            .widget<CheckboxListTile>(
              find.widgetWithText(CheckboxListTile, 'Source 01'),
            )
            .value,
        false,
      );
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      await tester.enterText(find.byType(TextField), 'Source 39');
      await tester.pumpAndSettle();
      final lastSource = find.widgetWithText(CheckboxListTile, 'Source 39');
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
      await tester.tap(find.widgetWithText(TextButton, 'Reset'));
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
