// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_chapters.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';

void main() {
  late Isar database;
  late Directory root;
  late Manga comic;
  late List<Chapter> chapters;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    root = await Directory.systemTemp.createTemp('nodelane-reader-chapters-');
    database = await Isar.open(
      [SettingsSchema, MangaSchema, ChapterSchema, SourceSchema],
      directory: root.path,
      name: 'reader_chapters',
    );
    app.isar = database;
  });
  setUp(() {
    comic = Manga(
      id: 1,
      name: 'Local comic',
      isLocalArchive: true,
      source: '',
      author: '',
      artist: '',
      genre: [],
      imageUrl: '',
      lang: 'en',
      link: '',
      status: Status.unknown,
      description: '',
      sourceId: null,
    );
    chapters = List.generate(
      3,
      (i) =>
          Chapter(id: i + 1, mangaId: 1, name: 'Chapter ${i + 1}')
            ..manga.value = comic,
    );
    database.writeTxnSync(() {
      database.chapters.clearSync();
      database.mangas.clearSync();
      database.settings.putSync(
        Settings(id: 227)
          ..sortChapterList = []
          ..chapterFilterUnreadList = []
          ..chapterFilterBookmarkedList = []
          ..chapterFilterDownloadedList = [],
      );
      database.mangas.putSync(comic);
      database.chapters.putAllSync(chapters);
      for (final chapter in chapters) {
        chapter.manga.saveSync();
      }
      comic.chapters.addAll(chapters);
      comic.chapters.saveSync();
    });
  });
  tearDownAll(() async {
    await dbWriteQueue.run(() {});
    await database.close(deleteFromDisk: true);
    await root.delete(recursive: true);
  });

  test('bookmark updates only the latest matching record and never recreates removed chapters', () async {
    final stale = chapters.first;
    await chapterRepository.writeTransaction(() {
      final latest = chapterRepository.getById(stale.id!);
      latest.lastPageRead = '19';
      latest.isRead = true;
      latest.name = 'Updated title';
      chapterRepository.putSync(latest);
    });
    await saveReaderChapterBookmark(stale, true);
    await saveReaderChapterBookmark(stale, true);
    final saved = chapterRepository.getById(stale.id!);
    expect(saved.isBookmarked, isTrue);
    expect(saved.lastPageRead, '19');
    expect(saved.name, 'Updated title');
    expect(saved.isRead, isTrue);
    expect(chapterRepository.getById(2).isBookmarked, isFalse);
    await expectLater(
      saveReaderChapterBookmark(Chapter(id: 1, mangaId: 99, name: ''), false),
      throwsStateError,
    );
    await chapterRepository.deleteAll([1]);
    await expectLater(
      saveReaderChapterBookmark(stale, false),
      throwsStateError,
    );
    expect(chapterRepository.findByIdSync(1), isNull);
  });

  Future<void> mount(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Widget host({
    required Chapter current,
    required List<Chapter> items,
    required Future<void> Function(Chapter, bool) save,
    ValueChanged<Chapter?>? result,
  }) => Scaffold(
    body: Builder(
      builder: (context) => TextButton(
        onPressed: () async {
          final value = await showModalBottomSheet<Chapter>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => MobileReaderChaptersSheet(
              chapter: current,
              chapters: items,
              onBookmark: save,
            ),
          );
          result?.call(value);
        },
        child: const Text('Open'),
      ),
    ),
  );

  Finder row(Chapter chapter) => find.descendant(
    of: find.byKey(ValueKey(chapter.id)),
    matching: find.byType(ListTile),
  );

  testWidgets(
    'long variable rows locate by ID, search locally and preserve controls with keyboard or rotation',
    (tester) async {
      final items = List.generate(
        300,
        (i) => Chapter(
          id: 1000 + i,
          mangaId: 1,
          name: i == 250 || i == 0
              ? 'Same title'
              : 'Chapter $i ${'full title ' * (i % 5)}',
          scanlator: i == 299 ? 'Last group' : '',
        )..manga.value = comic,
      );
      await mount(
        tester,
        host(current: items[250], items: items, save: (_, _) async {}),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(row(items[250]).hitTestable(), findsOneWidget);
      expect(find.textContaining('Reading now').hitTestable(), findsOneWidget);
      expect(row(items.first).hitTestable(), findsNothing);
      await tester.enterText(find.byType(TextField), 'last GROUP');
      await tester.pumpAndSettle();
      expect(row(items.last), findsOneWidget);
      expect(find.text('Chapters · 1'), findsOneWidget);
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Close').hitTestable(), findsOneWidget);
      expect(row(items.last).hitTestable(), findsOneWidget);
      tester.view.viewInsets = FakeViewPadding.zero;
      tester.view.physicalSize = const Size(740, 360);
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'last GROUP',
      );
      expect(find.byTooltip('Close').hitTestable(), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'no match');
      await tester.pumpAndSettle();
      expect(find.text('No result'), findsOneWidget);
      await tester.tap(find.byTooltip('Locate current chapter'));
      await tester.pumpAndSettle();
      expect(row(items[250]).hitTestable(), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      await mount(
        tester,
        host(current: items[250], items: [], save: (_, _) async {}),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'The chapter you are reading is outside the current filters.',
        ),
        findsOneWidget,
      );
      expect(
        tester
            .widget<IconButton>(
              find.byWidgetPredicate(
                (w) => w is IconButton && w.tooltip == 'Locate current chapter',
              ),
            )
            .onPressed,
        isNull,
      );
      expect(find.text('No result'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'bookmark completion gates repeats and return, failure does not retry, and selection returns once',
    (tester) async {
      var calls = 0;
      var completion = Completer<void>();
      final results = <Chapter?>[];
      Future<void> save(Chapter chapter, bool value) {
        expect(chapter.id, 1);
        expect(value, calls == 0);
        calls++;
        return completion.future;
      }

      await mount(
        tester,
        host(
          current: chapters.first,
          items: chapters,
          save: save,
          result: results.add,
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final button = find.descendant(
        of: row(chapters.first),
        matching: find.byType(IconButton),
      );
      final staleBookmark = tester.widget<IconButton>(button).onPressed!;
      staleBookmark();
      staleBookmark();
      await tester.pump();
      expect(calls, 1);
      expect(
        tester
            .widget<IconButton>(
              find.byWidgetPredicate(
                (w) => w is IconButton && w.tooltip == 'Close',
              ),
            )
            .onPressed,
        isNull,
      );
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.byType(MobileReaderChaptersSheet), findsOneWidget);
      completion.complete();
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: row(chapters.first),
          matching: find.byTooltip('Unbookmark'),
        ),
        findsOneWidget,
      );
      expect(results, isEmpty);
      completion = Completer<void>();
      await tester.tap(
        find.descendant(
          of: row(chapters.first),
          matching: find.byTooltip('Unbookmark'),
        ),
      );
      await tester.pump();
      completion.completeError(StateError('write unavailable'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Bookmark save could not be confirmed. Close the list and check its current state.',
        ),
        findsOneWidget,
      );
      staleBookmark();
      expect(calls, 2);
      final select = tester.widget<ListTile>(row(chapters[1])).onTap!;
      select();
      select();
      await tester.pumpAndSettle();
      expect(results, [same(chapters[1])]);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(row(chapters.first));
      await tester.pumpAndSettle();
      expect(results, [same(chapters[1]), null]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'reader owner replaces its route once after the sheet closes and ignores a removed owner',
    (tester) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      expect(comic.getSortedFilteredChapters().length, 3);
      var showOwner = true;
      late StateSetter change;
      final selected = <int>[];
      final router = GoRouter(
        initialLocation: '/reader',
        routes: [
          GoRoute(
            path: '/reader',
            builder: (_, _) => Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  change = setState;
                  return showOwner
                      ? MobileReaderChaptersButton(chapter: chapters.first)
                      : const Text('Owner removed');
                },
              ),
            ),
          ),
          GoRoute(
            path: '/mangaReaderView',
            builder: (_, state) {
              final id = state.extra! as int;
              selected.add(id);
              return Scaffold(body: Text('Selected $id'));
            },
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: router,
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chapters'));
      await tester.pumpAndSettle();
      expect(find.byType(MobileReaderChaptersSheet), findsOneWidget);
      change(() => showOwner = false);
      await tester.pump();
      await tester.tap(row(chapters[1]));
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
      expect(find.text('Owner removed'), findsOneWidget);
      change(() => showOwner = true);
      await tester.pump();
      await tester.tap(find.text('Chapters'));
      await tester.pumpAndSettle();
      final select = tester.widget<ListTile>(row(chapters[1])).onTap!;
      select();
      select();
      await tester.pumpAndSettle();
      expect(selected, [2]);
      expect(find.byType(MobileReaderChaptersSheet), findsNothing);
      expect(find.text('Selected 2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
