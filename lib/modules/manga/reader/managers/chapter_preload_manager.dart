import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';

/// Manages the preloading and memory of chapters in the manga reader.
///
/// Each edge has one request and a retryable boundary, independent of the UI.
class ChapterPreloadManager {
  ChapterPreloadManager(List<UChapDataPreload> initialPages)
    : _pages = List.of(initialPages) {
    final chapterId = _getChapterIdentifier(initialPages.firstOrNull?.chapter);
    if (chapterId != null) {
      _loadedChapterIds.add(chapterId);
      _chapterOrder.add(chapterId);
    }
  }

  final List<UChapDataPreload> _pages;

  /// Set of chapter IDs currently in memory
  final Set<String> _loadedChapterIds = {};

  /// Chapter IDs in reading order, including evicted chapters. Reloading a
  /// previous chapter must not move it after the tail of the reading list.
  final List<String> _chapterOrder = [];

  /// Set of chapter IDs whose page data has been evicted (image/archive data
  /// cleared but the pages themselves still sit in [_pages]). Lets callers
  /// cheaply check "does this chapter need a reload?" in O(1) instead of
  /// scanning every page of the chapter looking for cleared data.
  final Set<String> _evictedChapterIds = {};

  final Set<ChapterDirection> _loading = {};
  bool _disposed = false;

  /// Callbacks
  VoidCallback? onPagesUpdated;

  /// The viewport may defer a prepend until scrolling stops, then preserve
  /// its visible item around this synchronous mutation. No scroll/provider
  /// dependency belongs in the chapter loader.
  Future<void> Function(VoidCallback commit)? commitPrepend;

  /// Gets the list of pages (read-only)
  List<UChapDataPreload> get pages => List.unmodifiable(_pages);

  /// Failed/empty requests require an explicit retry. Eviction releases image
  /// data, but never makes an existing chapter eligible for insertion again.
  Future<bool> loadAdjacentChapter(
    ChapterDirection direction, {
    required Chapter? Function(Chapter edge) findChapter,
    required Future<GetChapterPagesModel> Function(Chapter, bool) loadPages,
    bool retry = false,
  }) async {
    if (_disposed || _loading.contains(direction) || _pages.isEmpty) {
      return false;
    }
    final previous = direction == ChapterDirection.previous;
    UChapDataPreload edge() => previous ? _pages.first : _pages.last;
    final current = edge();
    if (current.chapterState == ChapterLoadState.exhausted ||
        (current.chapterState != null && !retry)) {
      return false;
    }

    final boundary =
        current.isTransitionPage && current.boundaryDirection == direction
        ? current
        : UChapDataPreload.transition(
            currentChapter: current.chapter!,
            pageIndex: previous ? 0 : _pages.length,
            boundaryDirection: direction,
          );
    _loading.add(direction);
    boundary.chapterState = ChapterLoadState.loading;
    boundary.onRetryChapter = null;

    Future<void> publish(VoidCallback change) async {
      void commit() {
        if (_disposed) return;
        change();
        for (var i = 0; i < _pages.length; i++) {
          _pages[i].pageIndex = i;
        }
        onPagesUpdated?.call();
      }

      if (previous && commitPrepend != null) {
        await commitPrepend!(commit);
      } else {
        commit();
      }
    }

    try {
      Chapter? adjacent;
      late GetChapterPagesModel data;
      // Start source I/O even while the viewport is waiting for a gesture to
      // finish. Future.wait observes errors immediately and keeps one result.
      await Future.wait<void>([
        if (!identical(current, boundary))
          publish(
            () => previous ? _pages.insert(0, boundary) : _pages.add(boundary),
          )
        else
          Future<void>.sync(() => onPagesUpdated?.call()),
        () async {
          final target = adjacent = findChapter(current.chapter!);
          if (target == null) return;
          if (_chapterOrder.contains(_getChapterIdentifier(target))) {
            throw StateError('Chapter is already in the reading list');
          }
          data = await loadPages(target, retry);
        }(),
      ]);
      if (_disposed) return false;
      final target = adjacent;
      if (target == null) {
        boundary.chapterState = ChapterLoadState.exhausted;
        return false;
      }
      final chapterId = _getChapterIdentifier(target)!;
      if (data.uChapDataPreload.isEmpty) {
        boundary.chapterState = ChapterLoadState.empty;
        return false;
      }
      if (data.uChapDataPreload.any(
        (page) => page.chapter?.id != target.id || page.isTransitionPage,
      )) {
        throw StateError('Invalid adjacent chapter pages');
      }
      await publish(() {
        // The opposite edge may have completed while this prepend waited for
        // scroll idle. Validate membership at the actual insertion point.
        if (_chapterOrder.contains(chapterId)) {
          throw StateError('Chapter is already in the reading list');
        }
        _pages.remove(boundary);
        if (previous) {
          _pages.insertAll(0, data.uChapDataPreload);
          _chapterOrder.insert(0, chapterId);
        } else {
          _pages.addAll(data.uChapDataPreload);
          _chapterOrder.add(chapterId);
        }
        _loadedChapterIds.add(chapterId);
        boundary.chapterState = null;
      });
      return !_disposed;
    } catch (_) {
      if (!_disposed) boundary.chapterState = ChapterLoadState.failed;
      return false;
    } finally {
      if (!_disposed) {
        _loading.remove(direction);
        if (boundary.chapterState == ChapterLoadState.failed ||
            boundary.chapterState == ChapterLoadState.empty) {
          boundary.onRetryChapter = () {
            if (_disposed || !identical(edge(), boundary)) return;
            unawaited(
              loadAdjacentChapter(
                direction,
                findChapter: findChapter,
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

    // Reuse the chapter order instead of scanning all page slots to derive it.
    final currentIndex = _chapterOrder.indexOf(currentId);
    if (currentIndex == -1) return [];

    final idsToKeep = <String>{currentId};
    if (currentIndex - 1 >= 0) {
      idsToKeep.add(_chapterOrder[currentIndex - 1]);
    }
    if (currentIndex + 1 < _chapterOrder.length) {
      idsToKeep.add(_chapterOrder[currentIndex + 1]);
    }

    final evictedIndices = <int>[];
    final idsToEvict = _loadedChapterIds.difference(idsToKeep);
    if (idsToEvict.isEmpty) return [];
    final clearedModels = <GetChapterPagesModel>{};

    // Single linear pass over pages to evict old chapters in O(N)
    for (int i = 0; i < _pages.length; i++) {
      final page = _pages[i];
      if (page.isTransitionPage || page.chapter == null) continue;
      final id = _getChapterIdentifier(page.chapter);
      if (id != null && idsToEvict.contains(id)) {
        page.archiveImage = null;
        page.decodedImage?.dispose();
        page.decodedImage = null;
        page.resolvedFilePath = null;
        final model = page.chapterUrlModel;
        if (model != null && clearedModels.add(model)) {
          // The model also retains the archive bytes and original unsplit
          // pages. Clearing only the visible page did not release that memory.
          model.archiveImages.fillRange(0, model.archiveImages.length, null);
          for (final original in model.uChapDataPreload) {
            original.archiveImage = null;
            original.decodedImage?.dispose();
            original.decodedImage = null;
            original.resolvedFilePath = null;
          }
        }
        evictedIndices.add(i);
      }
    }

    _loadedChapterIds.removeAll(idsToEvict);
    _evictedChapterIds.addAll(idsToEvict);

    return evictedIndices;
  }

  /// Marks a chapter as loaded again (used after reloading evicted pages).
  void markChapterAsLoaded(Chapter chapter) {
    final chapterId = _getChapterIdentifier(chapter);
    if (chapterId != null) {
      _loadedChapterIds.add(chapterId);
      if (!_chapterOrder.contains(chapterId)) {
        _chapterOrder.add(chapterId);
      }
      _evictedChapterIds.remove(chapterId);
    }
  }

  /// Disposes of all resources.
  void dispose() {
    _disposed = true;
    _loading.clear();
    // Clear pages
    for (final page in _pages) {
      page.onRetryChapter = null;
      page.decodedImage?.dispose();
      page.decodedImage = null;
      page.resolvedFilePath = null;
    }
    _pages.clear();
    _loadedChapterIds.clear();
    _chapterOrder.clear();
    _evictedChapterIds.clear();

    // Clear callbacks
    onPagesUpdated = null;
    commitPrepend = null;
  }
}
