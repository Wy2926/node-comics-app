import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';

/// Shared navigation and history logic used by [ReaderController],
/// [NovelReaderController], and [AnimeStreamController].
///
/// Concrete classes must satisfy the single abstract member [chapter].
/// The Riverpod-generated base class already exposes the build parameter as a
/// getter, so no extra boilerplate is needed in normal cases.
///
/// [incognitoMode] and [getIsarSetting] are concrete in the mixin but can be
/// overridden — [ReaderController] overrides [getIsarSetting] to add caching.
mixin ChapterControllerMixin {
  // ---------------------------------------------------------------------------
  // Contract – provided by the Riverpod-generated superclass
  // ---------------------------------------------------------------------------

  /// The current chapter or episode.
  Chapter get chapter;

  // ---------------------------------------------------------------------------
  // Basic helpers
  // ---------------------------------------------------------------------------

  Manga getManga() => chapter.manga.value!;

  // Declared as a getter so concrete classes can override with a `final` field
  // (which is more efficient since incognito status never changes mid-session).
  bool get incognitoMode => settingsRepository.current.incognitoMode!;

  bool get hasNextChapter {
    final chapters = _readingChapters;
    return _chapterIndex(chapters) < chapters.length - 1;
  }

  bool get hasPreviousChapter => _chapterIndex(_readingChapters) > 0;

  Settings getIsarSetting() => settingsRepository.current;

  String getMangaName() => getManga().name!;
  String getSourceName() => getManga().source!;
  String getChapterTitle() => chapter.name!;

  // ---------------------------------------------------------------------------
  // Chapter / episode navigation
  // ---------------------------------------------------------------------------

  Chapter getPrevChapter() => _chapterWithOffset(-1);
  Chapter getNextChapter() => _chapterWithOffset(1);

  /// Preserve the current chapter in the sorted reading list even after its
  /// progress changes a filter match. Raw database link order is not reading order.
  List<Chapter> get _readingChapters =>
      getManga().getChapterListForReading(anchor: chapter);

  int _chapterIndex(List<Chapter> chapters) {
    final index = chapters.indexWhere((entry) => entry.id == chapter.id);
    if (index >= 0) return index;
    throw StateError('Current chapter is missing from the catalog');
  }

  Chapter _chapterWithOffset(int offset) {
    final chapters = _readingChapters;
    final index = _chapterIndex(chapters) + offset;
    if (index < 0 || index >= chapters.length) {
      throw RangeError('No chapter at offset $offset from ${chapter.id}');
    }
    return chapters[index];
  }

  // ---------------------------------------------------------------------------
  // History
  // ---------------------------------------------------------------------------

  /// Writes a history entry for the current chapter/episode and bumps the
  /// parent manga/anime's [lastRead] timestamp.
  ///
  /// [elapsedSeconds] accumulates watch/reading time; pass 0 to skip that
  /// field (the caller is responsible for tracking wall-clock deltas).
  Future<void> setHistoryUpdate({int elapsedSeconds = 0}) async {
    if (incognitoMode) return;
    final manga = getManga();

    final m = chapter.manga.value!;
    m.lastRead = DateTime.now().millisecondsSinceEpoch;
    await mangaRepository.save(m);

    final isEmpty = historyRepository.isEmptyForManga(manga.id);

    final History history;
    if (isEmpty) {
      history = History(
        mangaId: manga.id,
        date: DateTime.now().millisecondsSinceEpoch.toString(),
        itemType: manga.itemType,
        chapterId: chapter.id,
      )..chapter.value = chapter;
    } else {
      history = historyRepository.findFirstByMangaId(manga.id)!
        ..chapterId = chapter.id
        ..chapter.value = chapter
        ..date = DateTime.now().millisecondsSinceEpoch.toString();
    }

    if (elapsedSeconds > 0) {
      history.readingTimeSeconds =
          (history.readingTimeSeconds ?? 0) + elapsedSeconds;
    }
    await historyRepository.save(history);
  }
}
