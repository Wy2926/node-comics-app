import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';

/// Chooses one uniform state for the bulk read/unread action.
///
/// If every selected chapter is read, the action marks all of them unread.
/// Otherwise it marks all selected chapters read.
bool bulkChapterTargetReadState(Iterable<Chapter> chapters) {
  final selected = chapters.toList(growable: false);
  return selected.isEmpty ||
      !selected.every((chapter) => chapter.isRead == true);
}

/// Runs the existing record/cache removal sequence for one comic. The view
/// owns confirmation; true means the now-empty local comic was also removed.
Future<bool> deleteMangaChapterSelection({
  required Manga manga,
  required List<Chapter> selected,
  required Set<int> downloadedIds,
}) async {
  final chapters = selected
      .where((chapter) => chapter.mangaId == manga.id)
      .toList();
  if (chapters.isEmpty) return false;
  final localArchive = manga.isLocalArchive == true;
  if (localArchive) {
    await chapterRepository.deleteAll(
      chapters.map((chapter) => chapter.id!).toList(),
    );
  }
  for (final chapter in chapters) {
    if (downloadedIds.contains(chapter.id)) {
      await chapter.deleteDownloadedFiles();
    }
  }
  if (!localArchive) return false;
  // Recheck in the existing queue: an import may have appended chapters while
  // confirmation was open. Do not delete their parent using the old count.
  return mangaRepository.writeTransactionAsync(() async {
    if (await chapterRepository.countByMangaIdAsync(manga.id) != 0) {
      return false;
    }
    return mangaRepository.deleteAsync(manga.id!);
  });
}
