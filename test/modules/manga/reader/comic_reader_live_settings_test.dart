import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/reader/image_view_webtoon.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/manga/reader/reader_translation.dart';
import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_preferences.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_preferences_provider.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_scope.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_settings_sheet.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/auto_scroll_button.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
// Platform replacement for the plugin in this host-only widget test.
// ignore: depend_on_referenced_packages
import 'package:wakelock_plus_platform_interface/wakelock_plus_platform_interface.dart';

class _Wakelock extends WakelockPlusPlatformInterface {
  bool active = false;
  @override
  Future<void> toggle({required bool enable}) async => active = enable;
  @override
  Future<bool> get enabled async => active;
}

class _Preferences extends ComicReaderPreferencesController {
  @override
  ComicReaderPreferences build() => const ComicReaderPreferences().updateBook(
    1,
    (book) => book.copyWith(mode: ComicReadingMode.scroll),
  );
  @override
  Future<void> update(
    ComicReaderPreferences Function(ComicReaderPreferences) edit,
  ) async {
    state = edit(state);
  }
}

class _Translation extends TranslationService {
  @override
  Future<void> initialize() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory root;
  late Manga manga;
  late Chapter chapter;
  late _Wakelock wakelock;
  final originalWakelock = wakelockPlusPlatformInstance;
  setUpAll(() async {
    await Isar.initializeIsarCore(download: false);
    root = Directory.systemTemp.createTempSync('reader-live-settings-');
    app.isar = await Isar.open(
      [SettingsSchema, MangaSchema, ChapterSchema, SourceSchema],
      directory: root.path,
      name: 'reader_live_settings',
    );
  });
  setUp(() {
    wakelock = _Wakelock();
    wakelockPlusPlatformInstance = wakelock;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('window_manager'),
          (_) async => false,
        );
    manga = Manga(
      id: 1,
      name: 'Fixture',
      source: '',
      sourceId: null,
      author: '',
      artist: '',
      genre: [],
      imageUrl: '',
      lang: 'en',
      link: '',
      description: '',
      status: Status.unknown,
      isLocalArchive: true,
    );
    chapter = Chapter(id: 1, mangaId: 1, name: 'Chapter')..manga.value = manga;
    final preferences = const ComicReaderPreferences().updateBook(
      1,
      (book) => book.copyWith(mode: ComicReadingMode.scroll),
    );
    app.isar.writeTxnSync(() {
      app.isar.settings.putSync(
        Settings()
          ..incognitoMode = true
          ..comicReaderPreferences = preferences.encode()
          ..sortChapterList = []
          ..chapterFilterUnreadList = []
          ..chapterFilterBookmarkedList = []
          ..chapterFilterDownloadedList = [],
      );
      app.isar.mangas.putSync(manga);
      app.isar.chapters.putSync(chapter);
      chapter.manga.saveSync();
      manga.chapters.add(chapter);
      manga.chapters.saveSync();
    });
  });
  tearDownAll(() async {
    wakelockPlusPlatformInstance = originalWakelock;
    await app.isar.close(deleteFromDisk: true);
    root.deleteSync(recursive: true);
  });

  Future<ProviderContainer> mount(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawColor(Colors.blue, BlendMode.src);
    final picture = recorder.endRecording();
    final image = await picture.toImage(200, 400);
    picture.dispose();
    final pages = List.generate(
      8,
      (i) => UChapDataPreload(chapter, null, null, true, null, i, null, i)
        ..decodedImage = image.clone()
        ..loadedWidth = 200
        ..loadedHeight = 400
        ..resolvedFilePath = '/fixture/page-$i.png',
    );
    image.dispose();
    final translation = _Translation();
    final container = ProviderContainer(
      overrides: [
        translationServiceProvider.overrideWithValue(translation),
        comicReaderPreferencesProvider.overrideWith(_Preferences.new),
      ],
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox());
      container.dispose();
      translation.dispose();
      await tester.pump();
    });
    final model = GetChapterPagesModel(
      path: null,
      pageUrls: [
        for (var i = 0; i < pages.length; i++) PageUrl('/fixture/page-$i.png'),
      ],
      isLocaleList: [],
      archiveImages: [],
      localImagePaths: [],
      uChapDataPreload: pages,
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MangaChapterPageGallery(
            chapter: chapter,
            chapterUrlModel: model,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    return container;
  }

  ImageViewWebtoon content(WidgetTester tester) =>
      tester.widget(find.byType(ImageViewWebtoon));
  ReaderAutoScrollButton controls(WidgetTester tester) =>
      tester.widget(find.byType(ReaderAutoScrollButton));
  ComicReaderScope scope(WidgetTester tester) =>
      tester.widget(find.byType(ComicReaderScope));
  Future<void> frames(WidgetTester tester, int count) async {
    for (var i = 0; i < count; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
  }

  testWidgets(
    'real scroll stays paused while nested translation preserves the reading panel',
    (tester) async {
      await mount(tester);
      final scroll = content(tester).scrollController;
      final running = controls(tester).autoScroll;
      controls(tester).onToggle();
      await frames(tester, 20);
      expect(scroll.offset, greaterThan(0));
      final readerContext = tester.element(find.byType(ImageViewWebtoon));
      Future<void> open() => showComicReaderSettings(
        context: readerContext,
        bookId: 1,
        autoScroll: running,
      );
      var closed = open();
      final pausedAt = scroll.offset;
      expect(running.value, isFalse);
      await frames(tester, 25);
      expect(scroll.offset, pausedAt);
      final panel = tester.element(find.byType(ComicReaderSettingsSheet));
      expect(
        find.descendant(
          of: find.byType(ComicReaderSettingsSheet),
          matching: find.text('Fixture'),
        ),
        findsNothing,
      );
      final panelScroll = find
          .descendant(
            of: find.byType(ComicReaderSettingsSheet),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.text('Fine-tune image'),
        100,
        scrollable: panelScroll,
      );
      await tester.tap(find.text('Fine-tune image'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('漫画翻译'),
        200,
        scrollable: panelScroll,
      );
      await tester.pumpAndSettle();
      final position = tester.state<ScrollableState>(panelScroll).position;
      final offset = position.pixels;
      final translation = ReaderTranslationHost.controllerOf(readerContext)!;
      final enabled = translation.enabled;
      await tester.tap(find.text('漫画翻译'));
      await tester.pumpAndSettle();
      expect(find.byType(TranslationControlsContent), findsOneWidget);
      expect(find.byType(NodeLaneCatalogSheet), findsNWidgets(2));
      await tester.tap(find.text('Translation language'));
      await tester.pumpAndSettle();
      expect(find.byType(NodeLaneCatalogSheet), findsNWidgets(3));
      await tester.tap(find.byTooltip('Close').last);
      await tester.pumpAndSettle();
      expect(find.byType(TranslationControlsContent), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(TranslationControlsContent), findsNothing);
      expect(
        tester.element(find.byType(ComicReaderSettingsSheet)),
        same(panel),
      );
      expect(position.pixels, offset);
      expect(find.text('Invert colors'), findsOneWidget);
      expect(translation.enabled, enabled);
      expect(running.value, isFalse);
      expect(scroll.offset, pausedAt);
      await tester.tap(find.byTooltip('Close'));
      await frames(tester, 25);
      await closed;
      expect(scroll.offset, pausedAt);
      expect(running.value, isFalse);
      closed = open();
      await frames(tester, 25);
      await tester.scrollUntilVisible(
        find.text('Start auto scroll'),
        100,
        scrollable: find
            .descendant(
              of: find.byType(ComicReaderSettingsSheet),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(find.text('Start auto scroll'));
      await closed;
      await frames(tester, 25);
      expect(scroll.offset, greaterThan(pausedAt));
      controls(tester).onToggle();
      final stoppedAt = scroll.offset;
      await frames(tester, 25);
      expect(scroll.offset, stoppedAt);
      expect(running.value, isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'effects and habits update while geometry waits; queued layouts use latest values',
    (tester) async {
      final container = await mount(tester);
      final preferences = container.read(
        comicReaderPreferencesProvider.notifier,
      );
      final gesture = await tester.startGesture(const Offset(180, 650));
      await gesture.moveBy(const Offset(0, -150));
      await tester.pump();
      final before = content(tester).scrollController.offset;
      await preferences.update(
        (value) => value.updateBook(
          1,
          (book) => book.copyWith(width: ComicContentWidth.narrow),
        ),
      );
      await tester.pump();
      expect(
        content(tester).widthFactor,
        1,
      ); // Geometry must not interrupt a drag.
      await preferences.update(
        (value) => value
            .copyWith(
              habits: value.habits.copyWith(
                canvas: ComicCanvas.paper,
                keepAwake: false,
                pageNumber: false,
              ),
              scrollSpeed: 100,
            )
            .updateBook(1, (book) => book.copyWith(invert: true)),
      );
      await tester.pump();
      expect(scope(tester).profile.invert, isTrue);
      expect(content(tester).backgroundColor, const Color(0xfff5f1e8));
      expect(scope(tester).habits.pageNumber, isFalse);
      expect(wakelock.active, isFalse);
      expect(content(tester).scrollController.offset, before);
      await preferences.update(
        (value) => value.updateBook(
          1,
          (book) => book.copyWith(width: ComicContentWidth.full, gap: true),
        ),
      );
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(content(tester).widthFactor, 1);
      expect(content(tester).gap, 8);
      controls(tester).onToggle();
      await frames(tester, 3);
      final start = content(tester).scrollController.offset;
      await frames(tester, 20);
      expect(content(tester).scrollController.offset - start, closeTo(32, 1));
      controls(tester).onToggle();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'background updates keep current effects and apply only the latest layout on return',
    (tester) async {
      final container = await mount(tester);
      final preferences = container.read(
        comicReaderPreferencesProvider.notifier,
      );
      controls(tester).onToggle();
      await frames(tester, 20);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      final pausedAt = content(tester).scrollController.offset;
      expect(controls(tester).autoScroll.value, isFalse);
      await preferences.update(
        (value) => value.updateBook(
          1,
          (book) => book.copyWith(mode: ComicReadingMode.paged),
        ),
      );
      await tester.pump();
      await preferences.update(
        (value) => value
            .copyWith(
              habits: value.habits.copyWith(keepAwake: false),
              scrollSpeed: 10,
            )
            .updateBook(
              1,
              (book) => book.copyWith(
                mode: ComicReadingMode.scroll,
                width: ComicContentWidth.narrow,
                brightness: .25,
              ),
            ),
      );
      await tester.pump();
      expect(scope(tester).profile.brightness, .25);
      expect(content(tester).widthFactor, 1);
      expect(wakelock.active, isFalse);
      expect(content(tester).scrollController.offset, pausedAt);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(content(tester).widthFactor, .84);
      expect(scope(tester).profile.brightness, .25);
      expect(controls(tester).autoScroll.value, isFalse);
      final restored = content(tester).scrollController.offset;
      await frames(tester, 20);
      expect(content(tester).scrollController.offset, restored);
      expect(tester.takeException(), isNull);
    },
  );
}
