import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/services/chapter_cache.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';

void main() {
  late Directory directory;
  late Isar database;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Isar.initializeIsarCore(download: true);
    directory = await Directory.systemTemp.createTemp('chapter-catalog-');
    database = await Isar.open(
      [SettingsSchema, SourceSchema, MangaSchema, ChapterSchema, UpdateSchema],
      directory: directory.path,
      name: 'chapter_catalog',
    );
    app.isar = database;
    ChapterCache().customCacheDir = Directory('${directory.path}/cache');
  });
  tearDownAll(() async {
    ChapterCache().customCacheDir = null;
    await database.close(deleteFromDisk: true);
    await directory.delete(recursive: true);
  });

  Manga book(int id) => Manga(
    id: id,
    name: 'Fixture',
    sourceId: 123,
    source: 'Fixture',
    lang: 'en',
    link: 'https://fixture.test/book-$id/',
    imageUrl: '',
    author: '',
    artist: '',
    description: '',
    genre: [],
    status: Status.ongoing,
  );
  setUp(() {
    database.writeTxnSync(() {
      database.clearSync();
      database.sources.putSync(
        Source(
          id: 123,
          name: 'Fixture',
          lang: 'en',
          baseUrl: 'https://fixture.test',
          sourceCode: 'fixture',
          isAdded: true,
        ),
      );
      database.settings.putSync(
        Settings(id: 227)
          ..chapterFilterUnreadList = []
          ..chapterFilterBookmarkedList = []
          ..chapterFilterDownloadedList = [],
      );
      database.mangas.putAllSync([book(1), book(2)]);
    });
  });

  MChapter entry(String name, String path, [String group = '']) => MChapter(
    name: name,
    url: 'https://fixture.test/$path/',
    scanlator: group,
  );
  Future<List<Chapter>> refresh(
    List<MChapter> entries, {
    int mangaId = 1,
    bool fail = false,
  }) async {
    final container = ProviderContainer(
      overrides: [
        getDetailProvider.overrideWith((ref, args) async {
          if (fail) throw StateError('incomplete source response');
          return MManga(name: 'Fixture', chapters: entries);
        }),
      ],
    );
    try {
      await container.read(
        updateMangaDetailProvider(
          mangaId: mangaId,
          isInit: false,
          showToast: false,
        ).future,
      );
    } finally {
      container.dispose();
    }
    return chapterRepository.getAllByMangaId(mangaId);
  }

  void saveProgress(Chapter chapter) {
    database.writeTxnSync(() {
      chapter
        ..isRead = true
        ..isBookmarked = true
        ..lastPageRead = '7';
      database.chapters.putSync(chapter);
    });
  }

  List<Chapter> readingList() {
    final manga = database.mangas.getSync(1)!;
    manga.chapters.loadSync();
    return manga.getChapterListForReading();
  }

  test(
    'catalog and sequential reader retain same-name and decimal URL variants',
    () async {
      final entries = [
        entry('Chapter 0', 'chapter-0'),
        entry('Chapter 64.2', 'chapter-64.2'),
        entry('Chapter 64.20', 'chapter-64.20'),
        entry('Chapter 116', 'chapter-116'),
        entry('Chapter 116', 'chapter-116_1'),
        entry('Chapter 116', 'chapter-116-1'),
        entry('Chapter 116', 'chapter-116_1'),
      ];
      final first = await refresh(entries);
      expect(first, hasLength(6));
      expect(readingList(), hasLength(6));
      final selected = first.singleWhere(
        (c) => c.url!.endsWith('/chapter-116_1/'),
      );
      saveProgress(selected);
      final again = await refresh(entries.reversed.toList());
      expect(again.map((c) => c.id).toSet(), first.map((c) => c.id).toSet());
      expect(again.singleWhere((c) => c.id == selected.id).lastPageRead, '7');
      expect(again.where((c) => c.isRead == true), hasLength(1));
      expect(readingList(), hasLength(6));
    },
  );

  test('a previously omitted same-number part is restored without copying progress', () async {
    final original = entry('Chapter 33', 'chapter-33');
    final first = (await refresh([original])).single;
    saveProgress(first);
    final repaired = await refresh([
      entry('Chapter 33', 'chapter-33_1'),
      original,
    ]);
    expect(repaired, hasLength(2));
    expect(repaired.singleWhere((c) => c.id == first.id).lastPageRead, '7');
    expect(repaired.singleWhere((c) => c.id != first.id).isRead, isFalse);
    expect(repaired.singleWhere((c) => c.id != first.id).lastPageRead, isEmpty);
  });

  test('one-to-one URL replacement preserves state and chapter ID', () async {
    final first = (await refresh([entry('Chapter 1', 'old-1')])).single;
    saveProgress(first);
    final renamed = (await refresh([entry('Chapter 1', 'new-1')])).single;
    expect(renamed.id, first.id);
    expect(renamed.url, endsWith('/new-1/'));
    expect(renamed.lastPageRead, '7');
    expect(renamed.isBookmarked, isTrue);
    expect(renamed.isRead, isTrue);
  });

  test(
    'ambiguous replacements never delete or steal existing progress',
    () async {
      final first = await refresh([
        entry('Chapter 1', 'one-a'),
        entry('Chapter 1', 'one-b'),
      ]);
      saveProgress(first.first);
      final changed = await refresh([entry('Chapter 1', 'one-c')]);
      expect(changed, hasLength(3));
      expect(
        changed.singleWhere((c) => c.id == first.first.id).lastPageRead,
        '7',
      );
      expect(
        changed.singleWhere((c) => c.url!.endsWith('/one-c/')).isRead,
        isFalse,
      );
    },
  );

  test('full URLs and manga boundaries isolate chapters', () async {
    final a = entry('Chapter 1', 'same');
    final b = MChapter(name: 'Chapter 1', url: 'https://mirror.test/same/');
    final first = await refresh([a, b]);
    expect(first, hasLength(2));
    saveProgress(first.first);
    final otherBook = (await refresh([a], mangaId: 2)).single;
    expect(otherBook.id, isNot(first.first.id));
    expect(otherBook.isRead, isFalse);
  });

  test('failed refresh keeps the stored catalog and reading state', () async {
    final first = (await refresh([entry('Chapter 1', 'one')])).single;
    saveProgress(first);
    await expectLater(refresh([], fail: true), throwsStateError);
    final kept = chapterRepository.getAllByMangaId(1).single;
    expect(kept.id, first.id);
    expect(kept.lastPageRead, '7');
  });

  test(
    'refresh corrects imported upload dates without changing reading state',
    () async {
      final source = entry('Chapter 1', 'one');
      final first = (await refresh([source])).single;
      saveProgress(first);
      database.writeTxnSync(() {
        first.dateUpload = DateTime.now().millisecondsSinceEpoch.toString();
        database.chapters.putSync(first);
      });
      source.dateUpload = DateTime(
        2023,
        10,
        17,
      ).millisecondsSinceEpoch.toString();
      for (var attempt = 0; attempt < 2; attempt++) {
        final corrected = (await refresh([source])).single;
        expect(corrected.id, first.id);
        expect(corrected.dateUpload, source.dateUpload);
        expect(corrected.lastPageRead, '7');
        expect(corrected.isBookmarked, isTrue);
        expect(corrected.isRead, isTrue);
        expect(database.updates.countSync(), 0);
      }
    },
  );

  test(
    'unknown dates never become today; omitted dates preserve known metadata',
    () async {
      final source = entry('Chapter 1', 'one');
      expect((await refresh([source])).single.dateUpload, isEmpty);
      source.dateUpload = 'not a timestamp';
      expect((await refresh([source])).single.dateUpload, isEmpty);
      final date = DateTime(2024, 2, 29).millisecondsSinceEpoch.toString();
      source.dateUpload = date;
      expect((await refresh([source])).single.dateUpload, date);
      for (final omitted in [null, 'invalid', '9999999999999999999']) {
        source.dateUpload = omitted;
        expect((await refresh([source])).single.dateUpload, date);
      }
      source.dateUpload = '';
      expect((await refresh([source])).single.dateUpload, isEmpty);
    },
  );

  test('explicit scanlator alternatives still share read state and reading selection', () async {
    final a = entry('Chapter 2', 'two-a', 'Group A');
    saveProgress((await refresh([a])).single);
    final both = await refresh([a, entry('Chapter 2', 'two-b', 'Group B')]);
    expect(both, hasLength(2));
    expect(both.every((c) => c.isRead == true), isTrue);
    expect(readingList(), hasLength(1));
    await refresh([
      a,
      entry('Chapter 2', 'two-b', 'Group B'),
      entry('Chapter 2', 'two-b-extra', 'Group B'),
    ]);
    expect(readingList(), hasLength(3));
  });
}
