import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/detail/chapter_bulk_actions.dart';

void main() {
  test(
    'fresh chapter records retain selection by ID through range and invert',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final selection = container.read(chaptersListStateProvider.notifier);
      List<Chapter> records() => [
        for (final id in [1, 2, 3])
          Chapter(id: id, mangaId: 7, name: 'Part $id'),
      ];
      selection.update(records().first);
      selection.selectRange(records().last, records());
      expect(container.read(chaptersListStateProvider).map((c) => c.id), [
        1,
        2,
        3,
      ]);
      selection.invert(records().skip(1));
      expect(container.read(chaptersListStateProvider).single.id, 1);
      selection.update(records().first);
      expect(container.read(chaptersListStateProvider), isEmpty);
    },
  );
  Chapter chapter(bool isRead) =>
      Chapter(mangaId: 1, name: 'Chapter', isRead: isRead);

  test('multiple read chapters are uniformly marked unread', () {
    expect(bulkChapterTargetReadState([chapter(true), chapter(true)]), isFalse);
  });

  test('mixed selection is uniformly marked read', () {
    expect(bulkChapterTargetReadState([chapter(true), chapter(false)]), isTrue);
  });
}
