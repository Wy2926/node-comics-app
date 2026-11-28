import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/library/widgets/continue_reader_button.dart';
import 'package:mangayomi/modules/library/widgets/mobile_bookshelf_card.dart';
import 'package:mangayomi/modules/webview/browser_manga_widgets.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';

void main() {
  late Directory root;
  late Isar database;
  late Manga comic;
  late List<Chapter> chapters;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    root = await Directory.systemTemp.createTemp('nodelane-continue-reading-');
    database = await Isar.open(
      [SettingsSchema, MangaSchema, ChapterSchema, HistorySchema, SourceSchema],
      directory: root.path,
      name: 'continue_reading',
    );
    app.isar = database;
  });
  setUp(() {
    comic = Manga(
      id: 1,
      name: 'Finished comic',
      isLocalArchive: true,
      source: 'Local',
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
    chapters = [
      for (var id = 1; id <= 3; id++)
        Chapter(id: id, mangaId: 1, name: 'Chapter $id', isRead: true)
          ..manga.value = comic,
    ];
    database.writeTxnSync(() {
      database.historys.clearSync();
      database.chapters.clearSync();
      database.mangas.clearSync();
      database.settings.putSync(
        Settings(
            id: 227,
            chapterPageIndexList: [
              ChapterPageIndex(chapterId: 1, index: 9),
              ChapterPageIndex(chapterId: 2, index: 4),
            ],
          )
          ..chapterFilterUnreadList = []
          ..chapterFilterBookmarkedList = []
          ..chapterFilterDownloadedList = [],
      );
      database.mangas.putSync(comic);
      database.chapters.putAllSync(chapters);
      for (final chapter in chapters) {
        chapter.manga.saveSync();
      }
      // Source/storage insertion order must not decide where a book begins.
      comic.chapters.addAll(chapters.reversed);
      comic.chapters.saveSync();
    });
  });
  tearDownAll(() async {
    await database.close(deleteFromDisk: true);
    await root.delete(recursive: true);
  });

  void historyAt(int id) {
    final history = History(
      id: 1,
      itemType: ItemType.manga,
      chapterId: id,
      mangaId: 1,
      date: '1',
    )..chapter.value = chapters[id - 1];
    database.writeTxnSync(() {
      database.historys.putSync(history);
      history.chapter.saveSync();
    });
  }

  Future<void> mount(
    WidgetTester tester, {
    Widget Function(BuildContext)? action,
    List<Override> overrides = const [],
  }) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(
            body: Center(
              child: SizedBox(
                width: 180,
                height: 340,
                child: MobileBookshelfCard(
                  title: comic.name!,
                  selected: false,
                  onTap: () {},
                  onLongPress: () {},
                  image: MemoryImage(
                    base64Decode(
                      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScLbtAAAAABJRU5ErkJggg==',
                    ),
                  ),
                  continueButton:
                      action?.call(context) ??
                      ContinueReaderButton(entry: comic, large: true),
                ),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/mangaReaderView',
          builder: (_, state) => Consumer(
            builder: (context, ref, _) {
              final chapter = chapterRepository.getById(state.extra! as int);
              final index = ref
                  .read(readerControllerProvider(chapter: chapter).notifier)
                  .getPageIndex();
              return Scaffold(
                body: Text('${chapter.name} / page ${index + 1}'),
              );
            },
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        retry: (_, _) => null,
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      router.dispose();
    });
    await tester.pumpAndSettle();
  }

  testWidgets(
    'browser add persists when chapter lookup fails, retry opens the first chapter directly',
    (tester) async {
      const url = 'https://books.test/work';
      const preview = (
        sourceId: 75,
        targetUrl: url,
        link: url,
        name: 'New book',
        imageUrl: null,
        author: null,
        status: Status.ongoing,
        chapterName: null,
      );
      final source = Source(
        id: 75,
        name: 'Books',
        lang: 'en',
        baseUrl: 'https://books.test',
        isAdded: true,
        sourceCode: 'fixture',
        packageInfoJson: jsonEncode({
          'schema': 1,
          'repositoryId': 'net.nodelane.extensions',
          'slug': 'books',
          'size': 7,
          'sha256': '0' * 64,
          'requires': [],
          'requestHosts': ['books.test'],
          'capabilities': ['browser.manga-preview.v1'],
        }),
      )..sourceCodeLanguage = SourceCodeLanguage.javascript;
      database.writeTxnSync(() {
        database.sources.putSync(source);
        // 全新书架尚未从详情页建立任何作品筛选偏好。
        database.settings.putSync(Settings());
      });
      var calls = 0;
      await tester.runAsync(() async {
        await mount(
          tester,
          overrides: [
            getDetailProvider.overrideWith((_, args) async {
              expect(args.url, url);
              if (++calls == 1) throw StateError('offline');
              return MManga(
                name: 'New book',
                link: url,
                chapters: [
                  MChapter(name: 'New book chapter 2', url: '$url/2'),
                  MChapter(name: 'New book chapter 1', url: '$url/1'),
                ],
              );
            }),
          ],
          action: (context) => BrowserMangaButton(
            preview,
            openChapter: (id) => context.push('/mangaReaderView', extra: id),
          ),
        );
        Future<void> visible(Finder target) async {
          // Isar 的原生查询在真实事件循环上完成，等实际状态再点下一步。
          final until = DateTime.now().add(const Duration(seconds: 4));
          while (target.evaluate().isEmpty && DateTime.now().isBefore(until)) {
            await tester.pump();
            await Future<void>.delayed(const Duration(milliseconds: 10));
          }
          expect(target, findsOneWidget);
        }

        await tester.tap(find.byTooltip('Manga · New book'));
        await visible(find.text('Not in library'));
        await tester.tap(find.text('Add to library'));
        await visible(find.text('In library'));
        final read = find.text('Open in the app reader');
        await tester.tap(read);
        final l = AppLocalizations.of(tester.element(read))!;
        await visible(find.text(l.operation_retry));
        expect(database.mangas.filter().favoriteEqualTo(true).countSync(), 1);
        await tester.tap(read);
        await visible(find.text('New book chapter 1 / page 1'));
        expect(calls, 2);
      });
    },
  );

  testWidgets(
    'finished book without history opens the first chapter at page one',
    (tester) async {
      await mount(tester);
      await tester.tap(find.byTooltip('Resume'));
      await tester.pumpAndSettle();
      expect(find.text('Chapter 1 / page 1'), findsOneWidget);
      expect(chapterRepository.getById(1).isRead, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'finished last chapter falls back to the beginning without clearing progress',
    (tester) async {
      historyAt(3);
      await mount(tester);
      await tester.tap(find.byTooltip('Resume'));
      await tester.pumpAndSettle();
      expect(find.text('Chapter 1 / page 1'), findsOneWidget);
      expect(
        database.settings.getSync(227)!.chapterPageIndexList!.first.index,
        9,
      );
      expect(chapters.every((chapter) => chapter.isRead!), isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('unfinished reading resumes its saved chapter and page', (
    tester,
  ) async {
    chapters[1].isRead = false;
    database.writeTxnSync(() => database.chapters.putSync(chapters[1]));
    historyAt(2);
    await mount(tester);
    await tester.tap(find.byTooltip('Resume'));
    await tester.pumpAndSettle();
    expect(find.text('Chapter 2 / page 5'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'completed chapter advances by identity even when its metadata changed',
    (tester) async {
      final stale = Chapter.fromJson(chapters[1].toJson())..manga.value = comic;
      chapters[1].name = 'Chapter 2 updated';
      chapters[2].isRead = false;
      database.writeTxnSync(() => database.chapters.putAllSync(chapters));
      await mount(
        tester,
        action: (context) => TextButton(
          onPressed: () => stale.pushToReaderView(context),
          child: const Text('Continue'),
        ),
      );
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Chapter 3 / page 1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'explicit chapter selection still opens the chosen completed chapter',
    (tester) async {
      await mount(
        tester,
        action: (context) => TextButton(
          onPressed: () =>
              chapters[1].pushToReaderView(context, ignoreIsRead: true),
          child: const Text('Read chapter'),
        ),
      );
      await tester.tap(find.text('Read chapter'));
      await tester.pumpAndSettle();
      expect(find.text('Chapter 2 / page 1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
