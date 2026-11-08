import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';

/// Sort/identity keys that only bucket by season if numbering actually
/// repeats across seasons (a real reset) — otherwise chapters key by raw
/// number. Precise (not truncated) so split chapters (12, 12.1, 12.5, ...)
/// sort and dedup correctly instead of colliding at the same integer. A
/// null value means the name had no detectable number at all (e.g.
/// "Special") — distinct from a genuine chapter 0, so callers know not to
/// treat every such chapter as a duplicate of every other one.
Map<int?, double?> _chapterSortKeys(
  String mangaTitle,
  List<Chapter> chapterList,
) {
  final recognition = ChapterRecognition();
  final raw = <int?, (int, double?)>{
    for (final c in chapterList)
      c.id: recognition.rawSeasonAndNumber(mangaTitle, c.name ?? ''),
  };
  final episodeToSeasons = <double, Set<int>>{};
  for (final pair in raw.values) {
    if (pair.$2 == null) continue;
    episodeToSeasons.putIfAbsent(pair.$2!, () => {}).add(pair.$1);
  }
  final numbered = raw.values.where((pair) => pair.$2 != null).length;
  final seasonLabelled = raw.values
      .where((pair) => pair.$2 != null && pair.$1 > 0)
      .length;
  final mostlySeasonLabelled = numbered > 0 && seasonLabelled / numbered >= 0.5;
  // A single collision is more likely a stray "S1-5 Recap"-style title
  // falsely matching the season regex than a real reset — require several
  // before trusting it, since a genuine per-season reset repeats numbers
  // across many chapters, not just one.
  final collisions = episodeToSeasons.values
      .where((seasons) => seasons.length > 1)
      .length;
  final resets = collisions >= 3 || (collisions >= 1 && mostlySeasonLabelled);
  return {
    for (final entry in raw.entries)
      entry.key: switch (entry.value.$2) {
        null => null,
        final ep =>
          resets
              ? (entry.value.$1 > 0 ? entry.value.$1 * 100000 + ep : ep)
              : ep,
      },
  };
}

extension MangaExtensions on Manga {
  /// Number of unread chapters, excluding chapters from scanlators the user has
  /// filtered out for this manga. Mirrors the chapter list's scanlator filter,
  /// so the library "unread" badge and the unread sort reflect what the user
  /// actually sees rather than counting duplicate chapters from hidden
  /// scanlators (#796).
  int unreadChaptersCount(Settings settings) {
    final filter = settings.filterScanlatorList
        ?.where((e) => e.mangaId == id)
        .firstOrNull
        ?.scanlators;
    if (filter == null || filter.isEmpty) {
      return chapters.where((c) => !(c.isRead ?? false)).length;
    }
    return chapters
        .where((c) => !(c.isRead ?? false) && !filter.contains(c.scanlator))
        .length;
  }

  /// Filtered chapters respecting the user's active filters (unread,
  /// bookmarked, downloaded, scanlator). Sorted by chapter number ascending.
  /// Base list — no user-chosen sort, no deduplication.
  List<Chapter> getFilteredChapters([Settings? settingsOverride]) =>
      _getFilteredChapters(settingsOverride);

  List<Chapter> _getFilteredChapters(
    Settings? settingsOverride, {
    Chapter? anchor,
  }) {
    final settings = settingsOverride ?? settingsRepository.current;

    final filterUnread =
        (settings.chapterFilterUnreadList!
                    .where((e) => e.mangaId == id)
                    .firstOrNull ??
                ChapterFilterUnread(mangaId: id, type: 0))
            .type!;

    final filterBookmarked =
        (settings.chapterFilterBookmarkedList!
                    .where((e) => e.mangaId == id)
                    .firstOrNull ??
                ChapterFilterBookmarked(mangaId: id, type: 0))
            .type!;

    final filterDownloaded =
        (settings.chapterFilterDownloadedList!
                    .where((e) => e.mangaId == id)
                    .firstOrNull ??
                ChapterFilterDownloaded(mangaId: id, type: 0))
            .type!;

    final scanlators = settings.filterScanlatorList ?? [];
    final filter = scanlators.where((e) => e.mangaId == id);
    final filterScanlator = filter.firstOrNull?.scanlators ?? [];

    final data = chapters.toList();
    final sortKeys = _chapterSortKeys(name ?? '', data);
    // List.sort isn't stable, so chapters tying at the same key (notably
    // every unrecognized-number chapter, which falls back to 0) would
    // otherwise shuffle unpredictably between rebuilds. Break ties by
    // original position to keep them in a consistent, deterministic order.
    final originalIndex = {for (var i = 0; i < data.length; i++) data[i].id: i};
    data.sort((a, b) {
      final cmp = (sortKeys[a.id] ?? 0).compareTo(sortKeys[b.id] ?? 0);
      if (cmp != 0) return cmp;
      return (originalIndex[a.id] ?? 0).compareTo(originalIndex[b.id] ?? 0);
    });

    final chapterIds = data.map((c) => c.id).whereType<int>().toList();
    final downloadedIds = (filterDownloaded == 0 || chapterIds.isEmpty)
        ? const <int>{}
        : downloadRepository.getDownloadedIdsAmong(chapterIds).toSet();

    return data.where((entry) {
      if (anchor != null && entry.id == anchor.id) return true;
      if (filterUnread == 1 && entry.isRead != false) return false;
      if (filterUnread == 2 && entry.isRead != true) return false;
      if (filterBookmarked == 1 && entry.isBookmarked != true) return false;
      if (filterBookmarked == 2 && entry.isBookmarked != false) return false;
      if (filterDownloaded != 0 &&
          downloadedIds.contains(entry.id) != (filterDownloaded == 1)) {
        return false;
      }
      return !filterScanlator.contains(entry.scanlator);
    }).toList();
  }

  /// Filtered chapters for display in the chapter list UI: same filters as
  /// [getFilteredChapters] with the user's chosen sort order and direction applied.
  List<Chapter> getSortedFilteredChapters() {
    final settings = settingsRepository.current;

    final sortChapterEntry =
        settings.sortChapterList!.where((e) => e.mangaId == id).firstOrNull ??
        SortChapter(mangaId: id, index: 1);
    final sortIndex = sortChapterEntry.index!;
    final reverse = sortChapterEntry.reverse!;

    // Build on getFilteredChapters so filter logic lives in one place.
    List<Chapter> list = getFilteredChapters(settings);

    switch (sortIndex) {
      case 0: // by scanlator, then chapter number
        final sortKeys = _chapterSortKeys(name ?? '', chapters.toList());
        // Same stability concern as getFilteredChapters: break remaining
        // ties by list's current (already deterministic) order.
        final originalIndex = {
          for (var i = 0; i < list.length; i++) list[i].id: i,
        };
        list.sort((a, b) {
          final s = (a.scanlator ?? '').compareTo(b.scanlator ?? '');
          if (s != 0) return s;
          final cmp = (sortKeys[a.id] ?? 0).compareTo(sortKeys[b.id] ?? 0);
          if (cmp != 0) return cmp;
          return (originalIndex[a.id] ?? 0).compareTo(originalIndex[b.id] ?? 0);
        });
        break;
      case 2: // by upload date
        list.sort((a, b) {
          if (a.dateUpload == null || b.dateUpload == null) return 0;
          return (int.tryParse(a.dateUpload!) ?? 0).compareTo(
            int.tryParse(b.dateUpload!) ?? 0,
          );
        });
        break;
      case 3: // by name
        list.sort((a, b) {
          if (a.name == null || b.name == null) return 0;
          return a.name!.compareTo(b.name!);
        });
        break;
      case 1:
      default:
        // getFilteredChapters already sorted by chapter number; nothing to do.
        break;
    }

    return reverse ? list : list.reversed.toList();
  }

  /// Preserve distinct URLs, including same-number parts with no group label.
  /// Only collapse alternatives with different, explicit scanlator labels and
  /// one entry per group; ambiguous same-group numbering retains every part.
  List<Chapter> getChapterListForReading({Chapter? anchor}) {
    // Reading can mark the current chapter read or change its bookmark. Keep
    // that chapter as the navigation anchor while filtering its neighbours.
    final list = _getFilteredChapters(null, anchor: anchor);
    final sortKeys = _chapterSortKeys(name ?? '', list);
    final groups = <(double, String), int>{};
    final ambiguous = <double>{};
    for (final c in list) {
      final key = sortKeys[c.id];
      final group = c.scanlator?.trim() ?? '';
      if (key == null) continue;
      final count = groups.update(
        (key, group),
        (n) => n + 1,
        ifAbsent: () => 1,
      );
      if (group.isEmpty || count > 1) ambiguous.add(key);
    }
    final seen = <double>{};
    return list.where((c) {
      final key = sortKeys[c.id];
      if (anchor != null &&
          key != null &&
          key == sortKeys[anchor.id] &&
          !ambiguous.contains(key)) {
        return c.id == anchor.id;
      }
      return key == null || ambiguous.contains(key) || seen.add(key);
    }).toList();
  }

  /// Number of currently-filtered chapters whose name has no detectable
  /// chapter/episode number at all — surfaced to the user since it means
  /// automatic sort/dedup can't place them reliably.
  int unrecognizedChapterNumberCount() {
    final list = getFilteredChapters();
    final sortKeys = _chapterSortKeys(name ?? '', list);
    return list.where((c) => sortKeys[c.id] == null).length;
  }

  /// Estimate numbering gaps in the full imported catalog. Display filters
  /// (read, bookmarked, downloaded, scanlator) cannot make a chapter missing.
  int missingChapterCount() => ChapterRecognition().missingChapterCount(
    name ?? '',
    chapters.map((chapter) => chapter.name ?? ''),
  );
}
