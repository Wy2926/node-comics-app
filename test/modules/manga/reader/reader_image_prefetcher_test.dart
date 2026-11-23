import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/reader/managers/reader_image_prefetcher.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_page_window.dart';
import 'package:mangayomi/models/chapter.dart';

void main() {
  test('reverse reading still reserves six forward originals across splits and chapter edges', () {
    final one = Chapter(id: 1, mangaId: 1, name: 'One'),
        two = Chapter(id: 2, mangaId: 1, name: 'Two');
    UChapDataPreload p(Chapter c, int i) =>
        UChapDataPreload(c, null, null, false, null, i, null, i);
    final wide = p(one, 3);
    final pages = [
      for (var i = 0; i < 3; i++) p(one, i),
      wide,
      wide,
      UChapDataPreload.transition(currentChapter: one, pageIndex: 5),
      for (var i = 0; i < 8; i++) p(two, i),
    ];
    final window = ReaderPageWindow(pages, 3, 3, backward: true);
    expect(window.forward, [wide, ...pages.skip(6).take(6)]);
    expect(window.prefetch, [
      wide,
      pages[2],
      pages[1],
      pages[0],
      ...window.forward.skip(1),
    ]);
    expect(window.needsNextChapter, isFalse);
    expect(
      ReaderPageWindow(
        pages,
        pages.length - 3,
        pages.length - 1,
        backward: false,
      ).needsNextChapter,
      isTrue,
    );
  });

  test(
    'rapid window changes keep three active loads and discard stale work',
    () async {
      final pages = List.generate(
        12,
        (i) => UChapDataPreload(null, null, null, false, null, i, null, i),
      );
      final pending = <int, Completer<void>>{};
      final started = <int>[];
      final released = <int>[];
      final prefetcher = ReaderImagePrefetcher(
        load: (page) async {
          started.add(page.index!);
          await (pending[page.index!] = Completer<void>()).future;
          return () => released.add(page.index!);
        },
      );
      prefetcher.update(pages.take(6));
      expect(started, [0, 1, 2]);
      prefetcher.update(pages.skip(2).take(6));
      prefetcher.update(pages.skip(6));
      expect(started, [0, 1, 2]);
      pending[0]!.complete();
      await Future<void>.delayed(Duration.zero);
      expect(started, [0, 1, 2, 6]);
      expect(released, [0]);
      prefetcher.update(pages.skip(6)); // Do not duplicate active page 6.
      pending[1]!.completeError(StateError('offline'));
      await Future<void>.delayed(Duration.zero);
      expect(started, [0, 1, 2, 6, 7]);
      prefetcher.clear(); // Backgrounded: finish in-flight only.
      pending[2]!.complete();
      pending[6]!.complete();
      pending[7]!.complete();
      await Future<void>.delayed(Duration.zero);
      expect(started, [0, 1, 2, 6, 7]);
      prefetcher.update(pages.skip(9)); // Resume at the current window.
      expect(started, [0, 1, 2, 6, 7, 9, 10, 11]);
      prefetcher.dispose();
      prefetcher.update(pages);
      for (final i in [9, 10, 11]) {
        pending[i]!.complete();
      }
      await Future<void>.delayed(Duration.zero);
      expect(started, [0, 1, 2, 6, 7, 9, 10, 11]);
      expect(released, unorderedEquals([0, 2, 6, 7, 9, 10, 11]));
    },
  );
  test('overlapping windows keep successful files pinned and only fill the missing tail', () async {
    final pages = List.generate(
      9,
      (i) => UChapDataPreload(null, null, null, false, null, i, null, i),
    );
    final loaded = <int>[], held = <int>{};
    final queue = ReaderImagePrefetcher(
      load: (p) async {
        loaded.add(p.index!);
        held.add(p.index!);
        return () => held.remove(p.index);
      },
    );
    queue.update(pages.take(7));
    await Future<void>.delayed(Duration.zero);
    expect(held, {0, 1, 2, 3, 4, 5, 6});
    queue.update(pages.skip(1).take(7));
    await Future<void>.delayed(Duration.zero);
    expect(loaded, [0, 1, 2, 3, 4, 5, 6, 7]);
    expect(held, {1, 2, 3, 4, 5, 6, 7});
    queue.dispose();
    expect(held, isEmpty);
  });
}
