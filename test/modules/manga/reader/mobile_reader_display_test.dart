// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_display.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/utils/riverpod.dart';

void main() {
  late Directory root;
  late Isar database;
  late Chapter a, b;
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    root = await Directory.systemTemp.createTemp('nodelane-reader-display-');
    database = await Isar.open(
      [SettingsSchema, MangaSchema, SourceSchema, ChapterSchema],
      directory: root.path,
      name: 'reader_display',
    );
    app.isar = database;
    Manga comic(int id) => Manga(
      id: id,
      name: 'Comic $id',
      source: '',
      lang: 'en',
      imageUrl: '',
      link: '',
      author: '',
      artist: '',
      genre: [],
      status: Status.unknown,
      description: '',
      sourceId: null,
    );
    a = Chapter(id: 1, mangaId: 1, name: 'One')..manga.value = comic(1);
    b = Chapter(id: 2, mangaId: 2, name: 'Two')..manga.value = comic(2);
    database.writeTxnSync(() {
      database.mangas.putAllSync([a.manga.value!, b.manga.value!]);
      database.chapters.putAllSync([a, b]);
      a.manga.saveSync();
      b.manga.saveSync();
    });
  });
  setUp(
    () => database.writeTxnSync(
      () => database.settings.putSync(
        Settings(
          id: 227,
          cropBorders: false,
          doublePageAuto: true,
          personalPageModeList: [
            PersonalPageMode(mangaId: 2, pageMode: PageMode.doublePage),
          ],
          personalReaderModeList: [
            PersonalReaderMode(mangaId: 2, readerMode: ReaderMode.webtoon),
          ],
        ),
      ),
    ),
  );
  tearDownAll(() async {
    await dbWriteQueue.run(() {});
    await database.close(deleteFromDisk: true);
    await root.delete(recursive: true);
  });

  test(
    'manual layout and consecutive comic preferences preserve each other',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final first = container.read(
        readerControllerProvider(chapter: a).notifier,
      );
      final second = container.read(
        readerControllerProvider(chapter: b).notifier,
      );
      container.read(doublePageAutoStateProvider.notifier).set(false);
      first.setPageMode(PageMode.doublePage);
      second.setReaderMode(ReaderMode.verticalContinuous);
      container.read(cropBordersStateProvider.notifier).set(true);
      first.setReaderMode(ReaderMode.rtl);
      await dbWriteQueue.run(() {});
      final settings = settingsRepository.current;
      expect(settings.doublePageAuto, isFalse);
      expect(settings.cropBorders, isTrue);
      expect(
        settings.personalPageModeList!.map(
          (entry) => (entry.mangaId, entry.pageMode),
        ),
        unorderedEquals([(1, PageMode.doublePage), (2, PageMode.doublePage)]),
      );
      expect(
        settings.personalReaderModeList!.map(
          (entry) => (entry.mangaId, entry.readerMode),
        ),
        unorderedEquals([
          (1, ReaderMode.rtl),
          (2, ReaderMode.verticalContinuous),
        ]),
      );
    },
  );

  Future<void> mount(
    WidgetTester tester,
    ProviderContainer container,
    Widget child,
  ) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: Center(child: child)),
        ),
      ),
    );
  }

  Future<void> open(WidgetTester tester) async {
    await tester.tap(find.text('Display'));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'seven modes, current choice, cancellation and repeated callbacks dispatch only once',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final mode = StateProvider<ReaderMode?>(() => ReaderMode.rtl);
      final changes = <ReaderMode>[];
      await mount(
        tester,
        container,
        MobileReaderDisplayButton(
          bookTitle: 'A complete comic title',
          currentReaderModeProvider: mode,
          readPageMode: () => PageMode.onePage,
          onReaderModeChanged: (value, ref) {
            changes.add(value);
            ref.read(mode.notifier).state = value;
          },
          onPageModeToggle: () {},
        ),
      );
      await open(tester);
      for (final option in ReaderMode.values) {
        expect(find.byKey(ValueKey(option)), findsOneWidget);
      }
      expect(
        tester
            .widget<ListTile>(find.widgetWithText(ListTile, 'Right to Left'))
            .onTap,
        isNull,
      );
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
      await open(tester);
      final choose = tester
          .widget<ListTile>(find.widgetWithText(ListTile, 'Vertical'))
          .onTap!;
      choose();
      choose();
      await tester.pumpAndSettle();
      expect(changes, [ReaderMode.vertical]);
      expect(find.text('Display'), findsOneWidget);
      choose();
      await tester.pump();
      expect(changes, hasLength(1));
      await open(tester);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(changes, hasLength(1));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'crop scope, current page getter and horizontal restriction survive stale choices and rotation',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final mode = StateProvider<ReaderMode?>(() => ReaderMode.rtl);
      var page = PageMode.onePage, toggles = 0;
      await mount(
        tester,
        container,
        MobileReaderDisplayButton(
          bookTitle: 'Comic',
          currentReaderModeProvider: mode,
          readPageMode: () => page,
          onReaderModeChanged: (value, ref) =>
              ref.read(mode.notifier).state = value,
          onPageModeToggle: () {
            toggles++;
            page = page == PageMode.onePage
                ? PageMode.doublePage
                : PageMode.onePage;
          },
        ),
      );
      await open(tester);
      final crop = find.byType(SwitchListTile);
      await tester.ensureVisible(crop);
      expect(find.text('Applies to all comics.'), findsOneWidget);
      tester.widget<SwitchListTile>(crop).onChanged!(true);
      await tester.pumpAndSettle();
      await tester.runAsync(() => dbWriteQueue.run(() {}));
      expect(settingsRepository.current.cropBorders, isTrue);
      expect(settingsRepository.current.doublePageAuto, isTrue);
      await open(tester);
      final segment = find.byType(SegmentedButton<PageMode>);
      await tester.ensureVisible(segment);
      final staleChoose = tester
          .widget<SegmentedButton<PageMode>>(segment)
          .onSelectionChanged!;
      container.read(mode.notifier).state = ReaderMode.horizontalContinuous;
      await tester.pumpAndSettle();
      expect(
        tester.widget<SegmentedButton<PageMode>>(segment).onSelectionChanged,
        isNull,
      );
      expect(
        find.text('Horizontal continuous reading uses single pages.'),
        findsOneWidget,
      );
      staleChoose({PageMode.doublePage});
      await tester.pumpAndSettle();
      expect(toggles, 0);
      container.read(mode.notifier).state = ReaderMode.rtl;
      await open(tester);
      page = PageMode.doublePage;
      tester.view.physicalSize = const Size(740, 360);
      await tester.pumpAndSettle();
      expect(tester.widget<SegmentedButton<PageMode>>(segment).selected, {
        PageMode.doublePage,
      });
      await tester.ensureVisible(segment);
      await tester.pumpAndSettle();
      final choose = tester
          .widget<SegmentedButton<PageMode>>(segment)
          .onSelectionChanged!;
      choose({PageMode.onePage});
      choose({PageMode.onePage});
      await tester.pumpAndSettle();
      expect(toggles, 1);
      expect(page, PageMode.onePage);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a display menu cannot apply changes after its reader is removed',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final mode = StateProvider<ReaderMode?>(() => ReaderMode.rtl);
      var showReader = true, changes = 0;
      late StateSetter change;
      await mount(
        tester,
        container,
        StatefulBuilder(
          builder: (_, setState) {
            change = setState;
            return showReader
                ? MobileReaderDisplayButton(
                    bookTitle: 'Comic',
                    currentReaderModeProvider: mode,
                    readPageMode: () => PageMode.onePage,
                    onReaderModeChanged: (_, _) => changes++,
                  )
                : const Text('Reader closed');
          },
        ),
      );
      await open(tester);
      change(() => showReader = false);
      await tester.pump();
      await tester.tap(find.widgetWithText(ListTile, 'Vertical'));
      await tester.pumpAndSettle();
      expect(changes, 0);
      expect(find.text('Reader closed'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
