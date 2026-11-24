import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source_image_processing.dart';
import 'package:mangayomi/services/chapter_cache.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChapterCache Tests', () {
    late ChapterCache cache;
    late Directory tempDir;

    setUp(() async {
      cache = ChapterCache();
      tempDir = await Directory.systemTemp.createTemp('chapter_cache_test_');
      cache.customCacheDir = tempDir;
    });

    tearDown(() async {
      cache.customCacheDir = null;
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'page lists preserve duplicate slots and all image metadata',
      () async {
        final chapter = Chapter(name: 'Ch 1', mangaId: 10, url: '/c1');
        final pages = [
          PageUrl(
            'https://example.com/1.jpg',
            headers: {'Referer': 'https://example.com'},
            fileName: '001.jpg',
            imageProcessing: SourceImageProcessing.fromJson({
              'type': 'tile-shuffle-v1',
              'algorithm': 3,
              'seedMasks': {'abc': 123},
            }),
          ),
          PageUrl('https://example.com/1.jpg'),
        ];

        expect(await cache.getPageListFromCache(chapter), isNull);
        await cache.putPageListToCache(chapter, pages);
        final cached = await cache.getPageListFromCache(chapter);
        expect(cached, isNotNull);
        expect(cached!.map((p) => p.toJson()), pages.map((p) => p.toJson()));
      },
    );

    test('page lists are isolated by manga, chapter URL and login', () async {
      final oldChapter = Chapter(name: 'Ch 1', mangaId: 10, url: '/old-url');
      final newChapter = Chapter(name: 'Ch 1', mangaId: 10, url: '/new-url');
      final otherManga = Chapter(name: 'Ch 1', mangaId: 20, url: '/old-url');
      final pages = [PageUrl('https://example.com/1.jpg')];

      await cache.putPageListToCache(oldChapter, pages, sessionScope: 'viewer');
      Future<List<PageUrl>?> read(Chapter c, [String? scope = 'viewer']) =>
          cache.getPageListFromCache(c, sessionScope: scope);
      expect(await read(oldChapter), isNotNull);
      expect(await read(newChapter), isNull);
      expect(await read(otherManga), isNull);
      expect(await read(oldChapter, 'another-viewer'), isNull);
      expect(await read(oldChapter, null), isNull);
    });

    test('Mihon proxy handles never survive a bridge restart', () async {
      final chapter = Chapter(name: 'Ch 1', mangaId: 1, url: '/ch1');
      final token = 'a' * 64;
      final direct = PageUrl('https://example.org/image/$token');
      final proxy = PageUrl('http://127.0.0.1:42001/image/$token');
      await cache.putPageListToCache(chapter, [direct]);
      final file = await tempDir.list().cast<File>().single;
      await file.writeAsString(
        jsonEncode({
          'pages': [direct.toJson(), proxy.url],
        }),
      );
      expect(await cache.getPageListFromCache(chapter), isNull);

      await cache.putPageListToCache(chapter, [direct, proxy]);
      expect(await tempDir.list().isEmpty, isTrue);
      await cache.putPageListToCache(chapter, [direct]);
      expect(
        (await cache.getPageListFromCache(chapter))!.single.url,
        direct.url,
      );
    });

    test('remove and clear methods work properly', () async {
      final chapter1 = Chapter(name: 'Ch 1', mangaId: 10, url: '/c1');
      final chapter2 = Chapter(name: 'Ch 2', mangaId: 10, url: '/c2');
      final pages = [PageUrl('https://example.com/1.jpg')];

      await cache.putPageListToCache(chapter1, pages);
      await cache.putPageListToCache(chapter2, pages);

      expect(await cache.getPageListFromCache(chapter1), isNotNull);
      expect(await cache.getPageListFromCache(chapter2), isNotNull);

      // Remove chapter 1
      await cache.remove(chapter1);
      expect(await cache.getPageListFromCache(chapter1), isNull);
      expect(await cache.getPageListFromCache(chapter2), isNotNull);

      // Clear all
      final deleted = await cache.clear();
      expect(deleted, equals(1));
      expect(await cache.getPageListFromCache(chapter2), isNull);
    });

    test('trimCache evicts oldest entries when exceeding maxBytes', () async {
      final chapter1 = Chapter(name: 'Ch 1', mangaId: 1, url: '/c1');
      final chapter2 = Chapter(name: 'Ch 2', mangaId: 2, url: '/c2');
      final pages = [PageUrl('https://example.com/1.jpg')];

      await cache.putPageListToCache(chapter1, pages);
      final oldest = (await tempDir.list().single) as File;
      await oldest.setLastModified(DateTime.utc(2000));
      await cache.putPageListToCache(chapter2, pages);

      final files = await tempDir.list().cast<File>().toList();
      final total = (await Future.wait(files.map((file) => file.length())))
          .fold(0, (sum, size) => sum + size);
      await cache.trimCache(maxBytes: total - await oldest.length());
      expect(await cache.getPageListFromCache(chapter1), isNull);
      expect(await cache.getPageListFromCache(chapter2), isNotNull);
    });
  });
}
