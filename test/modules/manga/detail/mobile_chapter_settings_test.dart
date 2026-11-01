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
    WidgetTester tester,
  ) async {
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
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  builder: (_) => ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 555),
                    child: MobileMangaChapterSettings(
                      manga: manga,
                      localArchive: false,
                    ),
                  ),
                ),
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
    'chapter controls select explicit states and keep sort direction independent',
    (tester) async {
      final (container, _) = await start(tester);
      expect(find.text('Display'), findsNothing);
      Finder option(String name, String value) => find.descendant(
        of: find.byKey(ValueKey('chapter-filter-$name')),
        matching: find.text(value),
      );
      await tester.tap(option('Downloaded', 'Include'));
      await tester.tap(option('Unread', 'Exclude'));
      await tester.ensureVisible(option('Bookmarked', 'Include'));
      await tester.tap(option('Bookmarked', 'Include'));
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
        find.descendant(
          of: find.byType(NodeLaneTabSegments),
          matching: find.text('Sort'),
        ),
      );
      await tester.pumpAndSettle();
      final chooseDirection = tester
          .widget<NodeLaneSegments<bool>>(find.byType(NodeLaneSegments<bool>))
          .onChanged!;
      final chooseSort = tester
          .widget<RadioGroup<int>>(find.byType(RadioGroup<int>))
          .onChanged;
      chooseDirection(true);
      chooseDirection(true);
      chooseSort(3);
      chooseSort(3);
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
      await tester.tap(
        find.descendant(
          of: find.byType(NodeLaneTabSegments),
          matching: find.text('Filter'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(option('Bookmarked', 'Include'));
      expect(
        tester
            .widget<NodeLaneSegments<int>>(
              find.descendant(
                of: find.byKey(const ValueKey('chapter-filter-Bookmarked')),
                matching: find.byType(NodeLaneSegments<int>),
              ),
            )
            .value,
        1,
      );
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Open settings'), findsOneWidget);
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
        await tester.ensureVisible(find.text('Filter scanlator groups'));
        await tester.tap(find.text('Filter scanlator groups'));
        await tester.pumpAndSettle();
      }

      Future<void> search(String query) async {
        await tester.enterText(find.byType(TextField), query);
        await tester.pumpAndSettle();
      }

      await openGroups();
      await search('39');
      await tester.tap(find.text('Team 39'));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(container.read(provider).$2, ['Team 00']);
      await openGroups();
      await search('39');
      expect(
        tester
            .widget<CheckboxListTile>(
              find.widgetWithText(CheckboxListTile, 'Team 39'),
            )
            .value,
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
