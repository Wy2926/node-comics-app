import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/repositories/manga_repository.dart';

void main() {
  late Directory directory;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = overrides;
    }
  });

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('manga_repository');
    isar = await Isar.open(
      [MangaSchema, ChapterSchema],
      directory: directory.path,
      name: 'manga_repository_${directory.path.hashCode}',
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  test(
    'local queries use source identity and only configured folders resolve',
    () async {
      Manga entry(
        String name,
        ItemType type,
        String source,
        String link,
        int date,
      ) => Manga(
        name: name,
        itemType: type,
        source: source,
        link: link,
        dateAdded: date,
        author: '',
        artist: '',
        genre: const [],
        imageUrl: '',
        lang: '',
        status: Status.unknown,
        description: '',
        sourceId: null,
      );
      await isar.writeTxn(() async {
        await isar.mangas.putAll([
          entry('A comic', ItemType.manga, 'local', 'local/A', 1),
          entry('B comic', ItemType.manga, 'local', 'Shelf/B', 2),
          entry('C anime', ItemType.anime, 'local', 'local/C', 3),
          entry('D novel', ItemType.novel, 'local', 'local/D', 4),
          entry(
            'Old comic',
            ItemType.manga,
            'remote',
            '/Mangayomi/local/Old',
            5,
          ),
          entry(
            'Windows comic',
            ItemType.manga,
            'remote',
            r'C:\Mangayomi\local\Old',
            6,
          ),
        ]);
      });
      expect(
        (await mangaRepository.getAllLocal()).map((m) => m.name),
        unorderedEquals(['A comic', 'B comic', 'C anime', 'D novel']),
      );
      expect(
        (await mangaRepository.getLocalByItemTypeSortedByName(
          ItemType.manga,
          0,
          10,
        )).map((m) => m.name),
        ['A comic', 'B comic'],
      );
      expect(
        (await mangaRepository.getLocalByItemTypeSortedByDateAdded(
          ItemType.manga,
          0,
          1,
        )).single.name,
        'B comic',
      );
      expect(
        (await mangaRepository.searchLocalByItemType(
          ItemType.manga,
          'comic',
          1,
          10,
        )).single.name,
        'B comic',
      );

      final folders = [
        LocalFolder(name: 'local', path: '/data/nodelane-comics/local'),
      ];
      expect(
        localVirtualPathFromStoredPath(
          '/data/nodelane-comics/local/A',
          folders,
        ),
        'local/A',
      );
      expect(localVirtualPathFromStoredPath('local/A', folders), 'local/A');
      expect(
        localVirtualPathFromStoredPath('/data/Mangayomi/local/A', folders),
        '/data/Mangayomi/local/A',
      );
    },
  );

  test('save queues behind an active async Isar write', () async {
    final transactionStarted = Completer<void>();
    final releaseTransaction = Completer<void>();
    final activeTransaction = isar.writeTxn(() async {
      transactionStarted.complete();
      await releaseTransaction.future;
    });
    await transactionStarted.future;

    final manga = Manga(
      source: 'test',
      author: 'author',
      artist: 'artist',
      genre: const [],
      imageUrl: '',
      lang: 'en',
      link: '/test',
      name: 'Test',
      status: Status.unknown,
      description: '',
      sourceId: 1,
    )..favorite = true;

    final save = mangaRepository.save(manga);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    releaseTransaction.complete();
    await activeTransaction;
    await save;

    expect(manga.id, isNotNull);
    expect(isar.mangas.getSync(manga.id!)?.favorite, true);
  });
}
