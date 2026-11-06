import 'dart:ui';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/managers/chapter_preload_manager.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_page_index_math.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/modules/manga/reader/providers/manga_reader_provider.dart';

final ch1 = Chapter(id: 101, mangaId: 1, name: 'Chapter 1', url: '/c1');
final ch2 = Chapter(id: 102, mangaId: 1, name: 'Chapter 2', url: '/c2');

UChapDataPreload page(Chapter ch, int index, {bool wide = false}) =>
    UChapDataPreload(ch, null, null, null, null, index, null, index)
      ..loadedWidth = wide ? 2000 : 1000
      ..loadedHeight = 1400;

List<UChapDataPreload> chapterPages(Chapter ch, int count, {int? wideAt}) => [
  for (var i = 0; i < count; i++) page(ch, i, wide: i == wideAt),
];

UChapDataPreload transition() => UChapDataPreload.transition(
  currentChapter: ch1,
  nextChapter: ch2,
  mangaName: 'Manga',
  pageIndex: 0,
);

GetChapterPagesModel _model(List<UChapDataPreload> pages) =>
    GetChapterPagesModel(
      path: null,
      pageUrls: [],
      isLocaleList: [],
      archiveImages: [],
      uChapDataPreload: pages,
      localImagePaths: [],
    );

ReaderPageIndexMath doublePage(List<UChapDataPreload> pages) =>
    ReaderPageIndexMath(
      isDoublePageActive: true,
      singleFirst: false,
      pageCount: pages.length,
      pages: pages,
    );

void main() {
  test(
    'chapter context survives page failure and is shared during retry',
    () async {
      final firstRequest = Completer<GetChapterPagesModel>();
      var lookups = 0, requests = 0;
      final pages = _model([]);
      final container = ProviderContainer(
        overrides: [
          readerChapterProvider(ch1.id!).overrideWith((ref) async {
            lookups++;
            return ch1;
          }),
          getChapterPagesProvider(chapter: ch1).overrideWith((ref) {
            ref.keepAlive();
            requests++;
            return requests == 1 ? firstRequest.future : Future.value(pages);
          }),
        ],
      );
      addTearDown(container.dispose);
      container.listen(mangaReaderProvider(ch1.id!), (_, _) {});
      final failure = expectLater(
        container.read(mangaReaderProvider(ch1.id!).future),
        throwsA(isA<StateError>()),
      );
      expect(
        await container.read(readerChapterProvider(ch1.id!).future),
        same(ch1),
      );
      firstRequest.completeError(StateError('source temporarily unavailable'));
      await failure;
      expect(
        container.read(readerChapterProvider(ch1.id!)).requireValue,
        same(ch1),
      );
      container.invalidate(getChapterPagesProvider(chapter: ch1));
      container.invalidate(mangaReaderProvider(ch1.id!));
      final ready = await container.read(mangaReaderProvider(ch1.id!).future);
      expect(ready.chapter, same(ch1));
      expect(ready.pages, same(pages));
      expect((lookups, requests), (1, 2));
    },
  );
  group('page counter in double-page mode', () {
    test('a page of the next chapter is labelled from its own spread', () {
      // Chapter 1 has 5 pages, then the transition, then chapter 2. Chapter
      // 2's page 6 (index 5) used to be looked up at slot 5, the transition,
      // and the counter came out blank.
      final pages = [
        ...chapterPages(ch1, 5),
        transition(),
        ...chapterPages(ch2, 8),
      ];

      final math = doublePage(pages);

      expect(math.chapterPageLabel(5, ch2.id, 8), '5-6');
      expect(math.chapterPageLabel(0, ch2.id, 8), '1-2');
    });

    test('a wide page earlier in the list does not shift the next chapter', () {
      final pages = [
        ...chapterPages(ch1, 6, wideAt: 2),
        transition(),
        ...chapterPages(ch2, 6),
      ];

      // Chapter 1's own spreads are 1-2, 3, 4-5, 6; chapter 2 pairs from 1.
      expect(doublePage(pages).chapterPageLabel(2, ch2.id, 6), '3-4');
    });

    test('single-page mode shows the page number as is', () {
      final pages = chapterPages(ch1, 4);
      final math = ReaderPageIndexMath(
        isDoublePageActive: false,
        singleFirst: false,
        pageCount: pages.length,
        pages: pages,
      );

      expect(math.chapterPageLabel(2, ch1.id, 4), '3');
    });

    test('a page that is not loaded falls back to its number', () {
      expect(
        doublePage(chapterPages(ch1, 4)).chapterPageLabel(9, 999, 4),
        '10',
      );
    });
  });

  group('spread boundaries and mode changes', () {
    test(
      'chapters and transitions stay separate with either first-page mode',
      () {
        final pages = [
          ...chapterPages(ch1, 3),
          transition(),
          ...chapterPages(ch2, 2),
        ];
        for (final singleFirst in [false, true]) {
          final math = ReaderPageIndexMath(
            isDoublePageActive: true,
            singleFirst: singleFirst,
            pageCount: pages.length,
            pages: pages,
          );
          expect(
            math.spreads,
            singleFirst
                ? const [
                    DoublePageSpread(0),
                    DoublePageSpread(1, 2),
                    DoublePageSpread(3),
                    DoublePageSpread(4),
                    DoublePageSpread(5),
                  ]
                : const [
                    DoublePageSpread(0, 1),
                    DoublePageSpread(2),
                    DoublePageSpread(3),
                    DoublePageSpread(4, 5),
                  ],
          );
          expect(
            List.generate(6, math.actualToPageViewIndex),
            singleFirst ? [0, 1, 1, 2, 3, 4] : [0, 0, 1, 2, 3, 3],
          );
          expect(
            List.generate(math.pageViewPageCount, math.pageViewToActualIndex),
            singleFirst ? [0, 1, 3, 4, 5] : [0, 2, 3, 4],
          );
          expect(math.currentIndexLabel(3, 3), isEmpty);
          expect(math.currentIndexLabel(4, 2), singleFirst ? '1' : '1-2');
        }
        expect(
          ReaderPageIndexMath.buildSpreads([page(ch1, 0), page(ch2, 0)]),
          const [DoublePageSpread(0), DoublePageSpread(1)],
        );
      },
    );

    test('wide pages stay single without changing neighboring page labels', () {
      final math = doublePage(chapterPages(ch1, 4, wideAt: 1));
      expect(math.spreads, const [
        DoublePageSpread(0),
        DoublePageSpread(1),
        DoublePageSpread(2, 3),
      ]);
      expect(List.generate(4, math.actualToPageViewIndex), [0, 1, 2, 2]);
      expect(List.generate(3, math.pageViewToActualIndex), [0, 1, 2]);
      expect(List.generate(4, (index) => math.currentIndexLabel(index, 4)), [
        '1',
        '2',
        '3-4',
        '3-4',
      ]);
      expect(
        ReaderPageIndexMath.buildSpreads([
          page(ch1, 0, wide: true),
          page(ch1, 1, wide: true),
          page(ch1, 2),
        ]),
        const [DoublePageSpread(0), DoublePageSpread(1), DoublePageSpread(2)],
      );
    });

    test('synthetic spreads handle empty catalogs and a single first page', () {
      for (final singleFirst in [false, true]) {
        for (final count in [0, 1, 5]) {
          final math = ReaderPageIndexMath(
            isDoublePageActive: true,
            singleFirst: singleFirst,
            pageCount: count,
          );
          final expected = count == 0
              ? const <DoublePageSpread>[]
              : count == 1
              ? const [DoublePageSpread(0)]
              : singleFirst
              ? const [
                  DoublePageSpread(0),
                  DoublePageSpread(1, 2),
                  DoublePageSpread(3, 4),
                ]
              : const [
                  DoublePageSpread(0, 1),
                  DoublePageSpread(2, 3),
                  DoublePageSpread(4),
                ];
          expect(math.spreads, expected);
          expect(math.pageViewPageCount, expected.length);
          expect(math.pageViewToActualIndex(0), 0);
          expect(math.actualToPageViewIndex(0), 0);
        }
      }
    });

    test('mode changes retain the active page in the second chapter', () {
      final pages = [
        ...chapterPages(ch1, 4),
        transition(),
        ...chapterPages(ch2, 4),
      ];
      const activeIndex = 6;
      final math = doublePage(pages);
      final spread = math.actualToPageViewIndex(activeIndex);
      expect(spread, 3);
      expect(math.spreads[spread], const DoublePageSpread(5, 6));
      final restored = math.pageViewToActualIndex(spread);
      expect(restored, 5);
      expect(pages[restored].chapter?.id, ch2.id);
    });
  });

  group('splitting a wide page', () {
    test('every later page moves one slot down', () {
      final manager = ChapterPreloadManager()..initialize(chapterPages(ch1, 4));
      final wide = manager.pages[1];

      manager.splitPage(
        1,
        UChapDataPreload(ch1, null, null, null, null, 1, null, 1)
          ..srcRect = const Rect.fromLTWH(0, 0, 500, 1400),
        UChapDataPreload(ch1, null, null, null, null, 1, null, 1)
          ..srcRect = const Rect.fromLTWH(500, 0, 500, 1400),
      );

      expect(manager.pages, hasLength(5));
      expect(manager.pages.map((p) => p.pageIndex), [0, 1, 2, 3, 4]);
      // The pages after the split still know which page of the chapter
      // they are.
      expect(manager.pages.map((p) => p.index), [0, 1, 1, 2, 3]);
      expect(manager.pages, isNot(contains(wide)));
    });

    test('the two halves get different widget keys', () {
      final left = UChapDataPreload(ch1, null, null, null, null, 1, null, 1)
        ..srcRect = const Rect.fromLTWH(0, 0, 500, 1400);
      final right = UChapDataPreload(ch1, null, null, null, null, 1, null, 2)
        ..srcRect = const Rect.fromLTWH(500, 0, 500, 1400);

      expect(left.widgetKey(1), isNot(right.widgetKey(2)));
      expect(page(ch1, 1).widgetKey(1), '101-1');
    });
  });

  group('preloading', () {
    test('the next chapter follows a transition page', () async {
      final manager = ChapterPreloadManager()..initialize(chapterPages(ch1, 3));

      final added = await manager.preloadNextChapter(
        _model(chapterPages(ch2, 2)),
        ch1,
      );

      expect(added, isTrue);
      expect(manager.pages[3].isTransitionPage, isTrue);
      expect(manager.pages.sublist(4).map((p) => p.chapter?.id), [102, 102]);
      expect(manager.pages.sublist(4).map((p) => p.pageIndex), [4, 5]);
    });

    test(
      'only the chapters around the current one keep their images',
      () async {
        final ch3 = Chapter(id: 103, mangaId: 1, name: 'Chapter 3', url: '/c3');
        final ch4 = Chapter(id: 104, mangaId: 1, name: 'Chapter 4', url: '/c4');
        final manager = ChapterPreloadManager()
          ..initialize(chapterPages(ch1, 2));
        for (final ch in [ch2, ch3, ch4]) {
          await manager.preloadNextChapter(_model(chapterPages(ch, 2)), ch1);
        }

        final evicted = manager.evictOldChapters(ch3);

        expect(evicted.map((i) => manager.pages[i].chapter?.id).toSet(), {101});
        expect(manager.isChapterEvicted(ch1), isTrue);
        expect(manager.isChapterLoaded(ch2), isTrue);
        expect(manager.isChapterLoaded(ch4), isTrue);
      },
    );
  });
}
