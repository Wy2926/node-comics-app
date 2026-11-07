import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';

/// Manages the preloading and memory of chapters in the manga reader.
///
/// Fetches and appends the next chapter with a retryable boundary.
class ChapterPreloadManager {
  /// The list of preloaded chapter data
  final List<UChapDataPreload> _pages = [];

  /// Set of chapter IDs currently in memory
  final Set<String> _loadedChapterIds = {};

  /// Queue of chapter IDs in order of loading (for LRU eviction)
  final Queue<String> _chapterLoadOrder = Queue();

  /// Set of chapter IDs whose page data has been evicted (image/archive data
  /// cleared but the pages themselves still sit in [_pages]). Lets callers
  /// cheaply check "does this chapter need a reload?" in O(1) instead of
  /// scanning every page of the chapter looking for cleared data.
  final Set<String> _evictedChapterIds = {};

  /// At most one next-chapter request per reader.
  bool _isPreloadingNext = false;
  bool _disposed = false;
  int _requestGeneration = 0;

  /// Callbacks
  void Function()? onPagesUpdated;

  /// Gets the list of pages (read-only)
  List<UChapDataPreload> get pages => List.unmodifiable(_pages);

  /// Gets the current number of pages
  int get pageCount => _pages.length;

  /// Gets the loaded chapter count
  int get loadedChapterCount => _loadedChapterIds.length;

  /// Returns `true` if pages from [chapter] are already in memory.
  bool isChapterLoaded(Chapter? chapter) {
    final id = _getChapterIdentifier(chapter);
    return id != null && _loadedChapterIds.contains(id);
  }

  /// Initializes the manager with the first chapter's pages.
  void initialize(List<UChapDataPreload> initialPages) {
    _requestGeneration++;
    _disposed = false;
    _isPreloadingNext = false;
    for (final page in _pages) {
      page.onRetryChapter = null;
    }
    _pages.clear();
    _loadedChapterIds.clear();
    _chapterLoadOrder.clear();
    _evictedChapterIds.clear();

    _pages.addAll(initialPages);

    // Track the initial chapter
    if (initialPages.isNotEmpty) {
      final chapterId = _getChapterIdentifier(initialPages.first.chapter);
      if (chapterId != null) {
        _loadedChapterIds.add(chapterId);
        _chapterLoadOrder.add(chapterId);
      }
    }

    if (kDebugMode) {
      debugPrint(
        '[ChapterPreload] Initialized with ${initialPages.length} pages',
      );
    }
  }

  /// Adds a transition page between chapters.
  UChapDataPreload createTransitionPage({
    required Chapter currentChapter,
    required Chapter? nextChapter,
    required String mangaName,
    bool isLastChapter = false,
  }) {
    return UChapDataPreload.transition(
      currentChapter: currentChapter,
      nextChapter: nextChapter,
      mangaName: mangaName,
      pageIndex: _pages.length,
      isLastChapter: isLastChapter,
    );
  }

  /// Keeps a stable boundary at the end while the next chapter is fetched.
  /// Failed/empty requests wait for an explicit retry, not every scroll frame.
  Future<bool> loadNextChapter(
    Chapter currentChapter, {
    required Chapter? Function() findNextChapter,
    required Future<GetChapterPagesModel> Function(Chapter, bool) loadPages,
    bool retry = false,
  }) async {
    if (_disposed || _isPreloadingNext || _pages.isEmpty) return false;
    final tail = _pages.last;
    if (tail.chapter?.id != currentChapter.id ||
        (tail.isLastChapter ?? false)) {
      return false;
    }
    if (tail.nextChapterState != null && !retry) return false;

    final boundary = tail.nextChapterState != null
        ? tail
        : createTransitionPage(
            currentChapter: currentChapter,
            nextChapter: null,
            mangaName: currentChapter.manga.value?.name ?? '',
          );
    if (!identical(boundary, tail)) _pages.add(boundary);
    final generation = _requestGeneration;
    bool isCurrent() => !_disposed && generation == _requestGeneration;
    _isPreloadingNext = true;
    boundary.nextChapterState = NextChapterState.loading;
    boundary.onRetryChapter = null;
    onPagesUpdated?.call();

    try {
      final next = findNextChapter();
      boundary.nextChapter = next;
      if (next == null) {
        boundary.isLastChapter = true;
        boundary.nextChapterState = null;
        return false;
      }
      final data = await loadPages(next, retry);
      if (!isCurrent()) return false;
      if (data.uChapDataPreload.isEmpty) {
        boundary.nextChapterState = NextChapterState.empty;
        return false;
      }
      if (data.uChapDataPreload.any((page) => page.chapter?.id != next.id) ||
          isChapterLoaded(next)) {
        throw StateError('Invalid next chapter pages');
      }

      final startIndex = _pages.length;
      for (final entry in data.uChapDataPreload.asMap().entries) {
        entry.value.pageIndex = startIndex + entry.key;
      }
      _pages.addAll(data.uChapDataPreload);
      final chapterId = _getChapterIdentifier(next)!;
      _loadedChapterIds.add(chapterId);
      _chapterLoadOrder.add(chapterId);
      boundary.nextChapterState = null;
      return true;
    } catch (_) {
      if (isCurrent()) boundary.nextChapterState = NextChapterState.failed;
      return false;
    } finally {
      if (isCurrent()) {
        _isPreloadingNext = false;
        if (boundary.nextChapterState != null) {
          boundary.onRetryChapter = () {
            if (!isCurrent() || !identical(_pages.lastOrNull, boundary)) return;
            unawaited(
              loadNextChapter(
                currentChapter,
                findNextChapter: findNextChapter,
                loadPages: loadPages,
                retry: true,
              ),
            );
          };
        }
        onPagesUpdated?.call();
      }
    }
  }

  /// Returns `true` if [chapter]'s pages were evicted and still need a
  /// reload before they can render. O(1) - use this to skip the more
  /// expensive per-page scan in the common case where nothing was evicted.
  bool isChapterEvicted(Chapter? chapter) {
    final id = _getChapterIdentifier(chapter);
    return id != null && _evictedChapterIds.contains(id);
  }

  /// Gets a unique identifier for a chapter.
  String? _getChapterIdentifier(Chapter? chapter) {
    if (chapter == null) return null;

    final url = chapter.url?.trim() ?? '';
    final archivePath = chapter.archivePath?.trim() ?? '';

    if (url.isNotEmpty) return 'url:$url';
    if (archivePath.isNotEmpty) return 'archive:$archivePath';

    return 'id:${chapter.id}';
  }

  /// Evicts old chapters when the loaded chapters exceed the threshold.
  /// Returns the indices of the pages that were evicted.
  List<int> evictOldChapters(Chapter currentChapter) {
    final currentId = _getChapterIdentifier(currentChapter);
    if (currentId == null) return [];

    // _chapterLoadOrder is already maintained incrementally in the same
    // left-to-right order chapters appear in _pages (appended on next-chapter
    // preload, pruned on eviction) - reuse
    // it directly instead of re-deriving the same ordering with a full O(N)
    // scan over every page on every call.
    final loadedIdsInOrder = _chapterLoadOrder.toList();

    final currentIndex = loadedIdsInOrder.indexOf(currentId);
    if (currentIndex == -1) return [];

    final idsToKeep = <String>{currentId};
    if (currentIndex - 1 >= 0) {
      idsToKeep.add(loadedIdsInOrder[currentIndex - 1]);
    }
    if (currentIndex + 1 < loadedIdsInOrder.length) {
      idsToKeep.add(loadedIdsInOrder[currentIndex + 1]);
    }

    final evictedIndices = <int>[];
    final idsToEvict = _loadedChapterIds.difference(idsToKeep);
    if (idsToEvict.isEmpty) return [];

    // Single linear pass over pages to evict old chapters in O(N)
    for (int i = 0; i < _pages.length; i++) {
      final page = _pages[i];
      if (page.isTransitionPage || page.chapter == null) continue;
      final id = _getChapterIdentifier(page.chapter);
      if (id != null && idsToEvict.contains(id)) {
        if (kDebugMode) {
          debugPrint('[ChapterPreload] Evicting chapter page index $i for $id');
        }
        page.archiveImage = null;
        page.decodedImage?.dispose();
        page.decodedImage = null;
        page.resolvedFilePath = null;
        evictedIndices.add(i);
      }
    }

    _loadedChapterIds.removeAll(idsToEvict);
    _chapterLoadOrder.removeWhere((id) => idsToEvict.contains(id));
    _evictedChapterIds.addAll(idsToEvict);

    return evictedIndices;
  }

  /// Marks a chapter as loaded again (used after reloading evicted pages).
  void markChapterAsLoaded(Chapter chapter) {
    final chapterId = _getChapterIdentifier(chapter);
    if (chapterId != null) {
      _loadedChapterIds.add(chapterId);
      if (!_chapterLoadOrder.contains(chapterId)) {
        _chapterLoadOrder.add(chapterId);
      }
      _evictedChapterIds.remove(chapterId);
    }
  }

  /// Splits a single page into two pages dynamically.
  void splitPage(int index, UChapDataPreload page1, UChapDataPreload page2) {
    if (index < 0 || index >= _pages.length) return;
    _pages.removeAt(index);
    _pages.insert(index, page1);
    _pages.insert(index + 1, page2);
    // Every page after the split moved one slot down.
    for (int i = index; i < _pages.length; i++) {
      _pages[i].pageIndex = i;
    }
    onPagesUpdated?.call();
  }

  /// Disposes of all resources.
  Future<void> dispose() async {
    _disposed = true;
    _requestGeneration++;
    _isPreloadingNext = false;
    // Clear pages
    for (final page in _pages) {
      page.onRetryChapter = null;
      page.decodedImage?.dispose();
      page.decodedImage = null;
      page.resolvedFilePath = null;
    }
    _pages.clear();
    _loadedChapterIds.clear();
    _chapterLoadOrder.clear();
    _evictedChapterIds.clear();

    // Clear callbacks
    onPagesUpdated = null;

    if (kDebugMode) {
      debugPrint('[ChapterPreload] Disposed');
    }
  }
}
