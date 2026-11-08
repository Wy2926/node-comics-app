import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_preferences.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_preferences_provider.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_page_projection.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

void main() {
  test('defaults reach untouched fields without creating book overrides', () {
    const initial = ComicReaderPreferences();
    initial.resolve(1);
    expect(initial.books, isEmpty);
    final edited = initial.updateBook(
      1,
      (b) => b.copyWith(fit: ComicPageFit.width),
    );
    final changed = edited.copyWith(
      defaults: edited.defaults.copyWith(
        mode: ComicReadingMode.scroll,
        fit: ComicPageFit.height,
      ),
    );
    expect(changed.resolve(1).mode, ComicReadingMode.scroll);
    expect(changed.resolve(1).fit, ComicPageFit.width);
    expect(changed.resolve(2).fit, ComicPageFit.height);
    expect(changed.resetBook(1).resolve(1).fit, ComicPageFit.height);
    expect(changed.book(1).toJson().keys, ['fit']);
  });

  test('automatic spreads use available width and only horizontal paging', () {
    const defaults = ComicReaderDefaults();
    final automatic = const ComicBookSettings().resolve(defaults);
    expect(automatic.doublePage(647), isFalse);
    expect(automatic.doublePage(648), isTrue);
    expect(
      const ComicBookSettings(
        layout: ComicPageLayout.double,
        turn: ComicPageTurn.up,
      ).resolve(defaults).doublePage(1200),
      isFalse,
    );
    expect(
      const ComicBookSettings(
        layout: ComicPageLayout.double,
        mode: ComicReadingMode.scroll,
      ).resolve(defaults).doublePage(1200),
      isFalse,
    );
  });

  test(
    'split projection reverses and restores without changing source pages',
    () {
      final chapter = Chapter(id: 42, mangaId: 1, name: "Fixture");
      final source =
          UChapDataPreload(chapter, null, null, false, null, 3, null, 0)
            ..loadedWidth = 1600
            ..loadedHeight = 1000;
      final sources = [source];
      const book = ComicBookSettings(
        widePage: ComicWidePage.split,
        layout: ComicPageLayout.single,
      );
      final ltr = projectComicPages(
        sources,
        book.resolve(const ComicReaderDefaults()),
        390,
      );
      expect(ltr, hasLength(2));
      expect(ltr.map((p) => p.srcRect!.left), [0, 800]);
      expect(ltr.map((p) => p.index), [3, 3]);
      expect(ltr.first.identity, isNot(ltr.last.identity));
      final rtl = projectComicPages(
        sources,
        book
            .copyWith(turn: ComicPageTurn.right)
            .resolve(const ComicReaderDefaults()),
        390,
      );
      expect(rtl.map((p) => p.srcRect!.left), [800, 0]);
      for (final settings in [
        book.copyWith(mode: ComicReadingMode.scroll),
        book.copyWith(widePage: ComicWidePage.intact),
        book.copyWith(layout: ComicPageLayout.double),
      ]) {
        expect(
          projectComicPages(
            sources,
            settings.resolve(const ComicReaderDefaults()),
            800,
          ),
          [same(source)],
        );
      }
      expect(source.srcRect, isNull);
      expect(source.loadedWidth, 1600);
    },
  );

  group('persisted scope', () {
    late Directory directory;
    late ProviderContainer container;
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await Isar.initializeIsarCore(download: false);
    });
    setUp(() async {
      directory = Directory.systemTemp.createTempSync(
        'comic_reader_preferences',
      );
      app.isar = await Isar.open(
        [SettingsSchema, SourceSchema],
        directory: directory.path,
        name: directory.path.hashCode.toString(),
      );
      app.isar.writeTxnSync(() => app.isar.settings.putSync(Settings()));
      container = ProviderContainer();
    });
    tearDown(() async {
      container.dispose();
      await app.isar.close(deleteFromDisk: true);
      directory.deleteSync(recursive: true);
    });
    test('concurrent scopes survive restart and a book reset preserves other scopes', () async {
      final controller = container.read(
        comicReaderPreferencesProvider.notifier,
      );
      await Future.wait([
        controller.update(
          (p) => p.updateBook(1, (b) => b.copyWith(crop: true)),
        ),
        controller.update(
          (p) => p.updateBook(2, (b) => b.copyWith(invert: true)),
        ),
        controller.update(
          (p) => p.copyWith(
            defaults: p.defaults.copyWith(turn: ComicPageTurn.right),
            habits: p.habits.copyWith(canvas: ComicCanvas.black),
          ),
        ),
        settingsRepository.update((s) => s.showNSFW = false),
      ]);
      final restarted = ProviderContainer();
      addTearDown(restarted.dispose);
      final saved = restarted.read(comicReaderPreferencesProvider);
      expect(saved.resolve(1).crop, isTrue);
      expect(saved.resolve(2).crop, isFalse);
      expect(saved.resolve(2).invert, isTrue);
      expect(saved.resolve(1).turn, ComicPageTurn.right);
      expect(settingsRepository.current.showNSFW, isFalse);
      final backup = Settings.fromJson(settingsRepository.current.toJson());
      expect(
        ComicReaderPreferences.decode(backup.comicReaderPreferences).encode(),
        saved.encode(),
      );
      await controller.update((p) => p.resetBook(1));
      final reset = ComicReaderPreferences.decode(
        settingsRepository.current.comicReaderPreferences,
      );
      expect(reset.books.containsKey('1'), isFalse);
      expect(reset.resolve(1).crop, isFalse);
      expect(reset.resolve(1).turn, ComicPageTurn.right);
      expect(reset.resolve(2).invert, isTrue);
      expect(reset.habits.canvas, ComicCanvas.black);
    });
    test('reading and unrelated progress changes neither persist nor notify preferences', () async {
      final notifications = <ComicReaderPreferences>[];
      final subscription = container.listen(
        comicReaderPreferencesProvider,
        (_, next) => notifications.add(next),
      );
      addTearDown(subscription.close);
      container.read(comicReaderPreferencesProvider).resolve(1);
      await Future<void>.delayed(Duration.zero);
      await settingsRepository.update((s) => s.showNSFW = false);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(settingsRepository.current.comicReaderPreferences, isNull);
      expect(notifications, isEmpty);
    });
  });
}
