import 'dart:async';
import 'dart:io';
import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_chapter_settings.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

void main() {
  late Directory root;
  late Isar database;
  late Manga manga;
  late List<Chapter> chapters;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    root = await Directory.systemTemp.createTemp('nodelane-chapter-settings-');
    database = await Isar.open(
      [SettingsSchema, SourceSchema, MangaSchema, ChapterSchema],
      directory: root.path,
      name: 'chapter_settings',
    );
    app.isar = database;
    manga = Manga(
      id: 1,
      source: 'fixture',
      author: '',
      artist: '',
      genre: [],
      imageUrl: '',
      lang: 'en',
      link: '',
      name: 'Comic A',
      status: Status.unknown,
      description: '',
      sourceId: null,
    );
    chapters = [
      for (var index = 0; index < 40; index++)
        Chapter(
          id: index + 1,
          mangaId: 1,
          name: 'Chapter $index',
          scanlator: 'Team ${index.toString().padLeft(2, '0')}',
        )..manga.value = manga,
    ];
    database.writeTxnSync(() {
      database.mangas.putSync(manga);
      database.chapters.putAllSync(chapters);
      for (final chapter in chapters) {
        chapter.manga.saveSync();
      }
    });
    manga = database.mangas.getSync(1)!;
  });
  setUp(() {
    database.writeTxnSync(
      () => database.settings.putSync(
        Settings(
            id: 227,
            sortChapterList: [
              SortChapter(mangaId: 1, index: 1, reverse: false),
              SortChapter(mangaId: 2, index: 2, reverse: true),
            ],
            chapterFilterDownloadedList: [
              ChapterFilterDownloaded(mangaId: 2, type: 1),
            ],
          )
          ..chapterFilterUnreadList = [ChapterFilterUnread(mangaId: 2, type: 2)]
          ..chapterFilterBookmarkedList = [
            ChapterFilterBookmarked(mangaId: 2, type: 1),
          ]
          ..filterScanlatorList = [
            FilterScanlator(mangaId: 2, scanlators: ['Other team']),
          ],
      ),
    );
  });
  tearDownAll(() async {
    await dbWriteQueue.run(() {});
    await database.close(deleteFromDisk: true);
    await root.delete(recursive: true);
  });

  Future<void> flush(WidgetTester tester) async {
    await tester.runAsync(() => dbWriteQueue.run(() {}));
    await tester.pumpAndSettle();
  }

  Future<(ProviderContainer, StreamController<List<Chapter>>)> start(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
  }) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final events = StreamController<List<Chapter>>.broadcast(sync: true);
    final container = ProviderContainer(
      overrides: [
        getChaptersStreamProvider(mangaId: manga.id!).overrideWith((_) async* {
          yield chapters;
          yield* events.stream;
        }),
      ],
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await events.close();
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => MobileChapterSettingsPanel(
                  manga: manga,
                  localArchive: false,
                ).show(context),
                child: const Text('Open settings'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    return (container, events);
  }

  Finder option<T>(String group, String label) => find.descendant(
    of: find.widgetWithText(NodeLaneOptionSwitch<T>, group),
    matching: find.widgetWithText(InkWell, label),
  );
  Future<void> reveal(WidgetTester tester, Finder target) async {
    await Scrollable.ensureVisible(tester.element(target), alignment: .6);
    await tester.pumpAndSettle();
  }

  test('queued chapter preferences preserve other fields and books', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final groups = scanlatorsFilterStateProvider(manga);
    container.listen(groups, (_, _) {});
    container
        .read(chapterFilterDownloadedStateProvider(mangaId: 1).notifier)
        .setType(1);
    container
        .read(chapterFilterUnreadStateProvider(mangaId: 1).notifier)
        .setType(2);
    container
        .read(chapterFilterBookmarkedStateProvider(mangaId: 1).notifier)
        .setType(1);
    container.read(sortChapterStateProvider(mangaId: 1).notifier).set(3);
    container.read(sortChapterStateProvider(mangaId: 2).notifier).set(1);
    container.read(groups.notifier).set(['Team 00']);
    await dbWriteQueue.run(() {});
    final saved = settingsRepository.current;
    expect(
      saved.chapterFilterDownloadedList!
          .firstWhere((value) => value.mangaId == 1)
          .type,
      1,
    );
    expect(
      saved.chapterFilterUnreadList!
          .firstWhere((value) => value.mangaId == 1)
          .type,
      2,
    );
    expect(
      saved.chapterFilterBookmarkedList!
          .firstWhere((value) => value.mangaId == 1)
          .type,
      1,
    );
    expect(
      saved.chapterFilterUnreadList!
          .firstWhere((value) => value.mangaId == 2)
          .type,
      2,
    );
    expect(
      saved.sortChapterList!.firstWhere((value) => value.mangaId == 1).index,
      3,
    );
    expect(
      saved.sortChapterList!.firstWhere((value) => value.mangaId == 2).index,
      1,
    );
    expect(
      saved.filterScanlatorList!
          .firstWhere((value) => value.mangaId == 2)
          .scanlators,
      ['Other team'],
    );
    expect(container.read(groups).$2, ['Team 00']);
  });

  testWidgets(
    'episode filters and sort use episode labels and stay bound to the same title',
    (tester) async {
      manga.itemType = ItemType.anime;
      addTearDown(() => manga.itemType = ItemType.manga);
      await start(tester);
      expect(find.text('Unwatched'), findsOneWidget);
      expect(find.text('Settings'), findsNothing);
      await tester.tap(find.text('Sort'));
      await tester.pump();
      final option = find.text('By episode number');
      final entering = tester.getTopLeft(option).dx;
      expect(find.text('Unwatched', skipOffstage: false), findsNothing);
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(option).dx, lessThan(entering));
    },
  );

  testWidgets(
    'chapter controls select explicit states and keep sort direction independent',
    (tester) async {
      final (container, _) = await start(tester);
      for (final (filter, state) in [
        ('Downloaded', 'Include'),
        ('Unread', 'Exclude'),
        ('Bookmarked', 'Include'),
      ]) {
        final button = option<int>(filter, state);
        await reveal(tester, button);
        await tester.tap(button);
      }
      await flush(tester);
      expect(
        container.read(chapterFilterDownloadedStateProvider(mangaId: 1)),
        1,
      );
      expect(container.read(chapterFilterUnreadStateProvider(mangaId: 1)), 2);
      expect(
        container.read(chapterFilterBookmarkedStateProvider(mangaId: 1)),
        1,
      );
      await tester.tap(
        find.descendant(of: find.byType(TabBar), matching: find.text('Sort')),
      );
      await tester.pumpAndSettle();
      final chooseDirection = tester
          .widget<InkWell>(find.widgetWithText(InkWell, 'Ascending'))
          .onTap!;
      final chooseSort = tester
          .widget<InkWell>(find.widgetWithText(InkWell, 'By name'))
          .onTap!;
      chooseDirection();
      chooseDirection();
      chooseSort();
      chooseSort();
      await flush(tester);
      final saved = settingsRepository.current;
      final sort = saved.sortChapterList!.firstWhere(
        (value) => value.mangaId == 1,
      );
      expect(sort.index, 3);
      expect(sort.reverse, true);
      expect(
        saved.chapterFilterUnreadList!
            .firstWhere((value) => value.mangaId == 1)
            .type,
        2,
      );
      expect(
        saved.sortChapterList!.firstWhere((value) => value.mangaId == 2).index,
        2,
      );
      tester.view.physicalSize = const Size(320, 700);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.tap(
        find.descendant(of: find.byType(TabBar), matching: find.text('Filter')),
      );
      await tester.pumpAndSettle();
      final include = option<int>('Bookmarked', 'Include');
      await reveal(tester, include);
      expect(
        tester.getSemantics(include).flagsCollection.isSelected,
        Tristate.isTrue,
      );
      final unread = option<int>('Unread', 'Include');
      await reveal(tester, unread);
      await tester.tap(unread);
      await flush(tester);
      expect(container.read(chapterFilterUnreadStateProvider(mangaId: 1)), 1);
      expect(container.read(chapterFilterUnreadStateProvider(mangaId: 2)), 2);
      await reveal(tester, find.byTooltip('Close'));
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Open settings'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Chinese swipe labels stay whole at phone width and reflow at 200% without losing the selection',
    (tester) async {
      await start(tester, locale: const Locale('zh'));
      tester.view.physicalSize = const Size(390, 844);
      await tester.pumpAndSettle();
      await tester.tap(find.text('设置'));
      await tester.pumpAndSettle();
      const right = '向右滑动', left = '向左滑动', read = '切换已读状态', bookmark = '切换书签';
      final first = option<ChapterSwipeAction>(right, bookmark);
      final second = option<ChapterSwipeAction>(right, read);
      void checkLabel(Finder button, String label) {
        final paragraph = tester.renderObject<RenderParagraph>(
          find.descendant(
            of: find.descendant(of: button, matching: find.text(label)),
            matching: find.byType(RichText),
          ),
        );
        final lines = paragraph
            .getBoxesForSelection(
              TextSelection(baseOffset: 0, extentOffset: label.length),
            )
            .map((box) => box.top)
            .toSet();
        expect(lines, hasLength(1), reason: label);
        expect(tester.getSize(button).height, greaterThanOrEqualTo(44));
      }

      expect(
        tester.getBottomLeft(find.text(right)).dy,
        lessThan(tester.getTopLeft(first).dy),
      );
      expect(tester.getTopLeft(first).dy, tester.getTopLeft(second).dy);
      checkLabel(second, read);
      await tester.tap(second);
      final disabled = option<ChapterSwipeAction>(left, '已禁用');
      await reveal(tester, disabled);
      await tester.tap(disabled);
      await flush(tester);
      expect(
        settingsRepository.current.chapterSwipeStartAction,
        ChapterSwipeAction.toggleRead.index,
      );
      expect(
        settingsRepository.current.chapterSwipeEndAction,
        ChapterSwipeAction.disabled.index,
      );

      tester.view.physicalSize = const Size(320, 700);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpAndSettle();
      await reveal(tester, second);
      expect(
        tester.getTopLeft(second).dy,
        greaterThan(tester.getBottomLeft(first).dy),
      );
      checkLabel(second, read);
      expect(tester.getSemantics(second).label, '$right, $read');
      expect(
        tester.getSemantics(second).flagsCollection.isSelected,
        Tristate.isTrue,
      );
      await reveal(tester, disabled);
      expect(
        tester.getSemantics(disabled).flagsCollection.isSelected,
        Tristate.isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'scanlator draft cancels, keeps hidden search choices and filters vanished groups',
    (tester) async {
      final (container, events) = await start(tester);
      final provider = scanlatorsFilterStateProvider(manga);
      container.read(provider.notifier).set(['Team 00']);
      await flush(tester);
      Future<void> openGroups() async {
        await reveal(tester, find.text('Filter scanlator groups'));
        await tester.tap(find.text('Filter scanlator groups'));
        await tester.pumpAndSettle();
      }

      Future<void> search(String query) async {
        await tester.enterText(find.byType(TextField), query);
        await tester.pumpAndSettle();
      }

      await openGroups();
      expect(
        find.ancestor(
          of: find.byType(TextField),
          matching: find.byType(NodeLaneBubbleFlow),
        ),
        findsOneWidget,
      );
      await search('39');
      await tester.tap(find.text('Team 39'));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(container.read(provider).$2, ['Team 00']);
      await openGroups();
      await search('39');
      expect(
        tester
            .widget<NodeLaneRow>(find.widgetWithText(NodeLaneRow, 'Team 39'))
            .selected,
        false,
      );
      await tester.tap(find.text('Team 39'));
      database.writeTxnSync(() {
        database.chapters.putSync(
          database.chapters.getSync(40)!..scanlator = '',
        );
      });
      events.add(
        chapters.where((chapter) => chapter.scanlator != 'Team 39').toList(),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Filter'));
      await flush(tester);
      expect(container.read(provider).$2, ['Team 00']);
      await openGroups();
      await search('01');
      await tester.tap(find.text('Team 01'));
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.widgetWithText(FilledButton, 'Filter')).bottom,
        lessThanOrEqualTo(460),
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Filter'));
      tester.view.resetViewInsets();
      await flush(tester);
      expect(container.read(provider).$2, ['Team 00', 'Team 01']);
      await openGroups();
      await tester.tap(find.widgetWithText(TextButton, 'Reset'));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(container.read(provider).$2, ['Team 00', 'Team 01']);
      expect(
        settingsRepository.current.filterScanlatorList!
            .firstWhere((value) => value.mangaId == 2)
            .scanlators,
        ['Other team'],
      );
      expect(tester.takeException(), isNull);
    },
  );
}
