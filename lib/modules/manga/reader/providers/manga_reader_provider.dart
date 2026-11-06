import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'manga_reader_provider.g.dart';

class ChapterWithPages {
  final Chapter chapter;
  final GetChapterPagesModel pages;

  ChapterWithPages({required this.chapter, required this.pages});
}

/// Shared local context is available before the source finishes loading pages.
final readerChapterProvider = FutureProvider.autoDispose.family<Chapter, int>((
  ref,
  chapterId,
) async {
  final chap = await chapterRepository.findById(chapterId);
  if (chap == null) {
    throw Exception('Chapter #$chapterId not found');
  }
  return chap;
});

@riverpod
Future<ChapterWithPages> mangaReader(Ref ref, int chapterId) async {
  final chap = await ref.watch(readerChapterProvider(chapterId).future);

  final pages = await ref.read(getChapterPagesProvider(chapter: chap).future);

  return ChapterWithPages(chapter: chap, pages: pages);
}
