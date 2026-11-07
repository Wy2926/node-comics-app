import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/reader/managers/reader_image_prefetcher.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';

void main() {
  test(
    'rapid window changes keep three active loads and discard stale work',
    () async {
      final pages = List.generate(
        12,
        (i) => UChapDataPreload(null, null, null, false, null, i, null, i),
      );
      final pending = <int, Completer<void>>{};
      final started = <int>[];
      final current = <int, bool Function()>{};
      final prefetcher = ReaderImagePrefetcher(
        load: (page, isCurrent) {
          started.add(page.index!);
          current[page.index!] = isCurrent;
          return (pending[page.index!] = Completer<void>()).future;
        },
      );
      prefetcher.update(pages.take(6));
      expect(started, [0, 1, 2]);
      prefetcher.update(pages.skip(2).take(6));
      prefetcher.update(pages.skip(6));
      expect(started, [0, 1, 2]);
      expect(current[0]!(), isFalse);
      pending[0]!.complete();
      await Future<void>.delayed(Duration.zero);
      expect(started, [0, 1, 2, 6]);
      expect(current[6]!(), isTrue);
      prefetcher.update(pages.skip(6)); // Do not duplicate active page 6.
      pending[1]!.completeError(StateError('offline'));
      await Future<void>.delayed(Duration.zero);
      expect(started, [0, 1, 2, 6, 7]);
      prefetcher.clear(); // Backgrounded: finish in-flight only.
      expect(current[6]!(), isFalse);
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
        expect(current[i]!(), isFalse);
        pending[i]!.complete();
      }
      await Future<void>.delayed(Duration.zero);
      expect(started, [0, 1, 2, 6, 7, 9, 10, 11]);
    },
  );
}
