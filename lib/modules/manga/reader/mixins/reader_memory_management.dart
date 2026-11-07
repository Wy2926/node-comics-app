import 'package:flutter/foundation.dart';
import 'package:mangayomi/modules/manga/reader/managers/chapter_preload_manager.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';

mixin ReaderMemoryManagement {
  /// The preload manager that handles memory-bounded chapter caching.
  late final ChapterPreloadManager _preloadManager = ChapterPreloadManager();

  /// Whether the preload manager has been initialized.
  bool _isPreloadManagerInitialized = false;

  /// Gets the preload manager.
  ChapterPreloadManager get preloadManager => _preloadManager;

  /// Gets all currently loaded pages.
  List<UChapDataPreload> get pages => _preloadManager.pages;

  /// Gets the total page count.
  int get pageCount => _preloadManager.pageCount;

  /// Initializes the preload manager with initial chapter data.
  ///
  /// [chapterData] - The initial chapter pages to load.
  /// [onPagesUpdated] - Callback when pages are added/removed.
  void initializePreloadManager(
    GetChapterPagesModel chapterData, {
    VoidCallback? onPagesUpdated,
  }) {
    if (_isPreloadManagerInitialized) {
      if (kDebugMode) {
        debugPrint('[ReaderMemoryManagement] Already initialized, skipping');
      }
      return;
    }

    _preloadManager.onPagesUpdated = onPagesUpdated;

    _preloadManager.initialize(chapterData.uChapDataPreload);

    _isPreloadManagerInitialized = true;

    if (kDebugMode) {
      debugPrint(
        '[ReaderMemoryManagement] Initialized with ${chapterData.uChapDataPreload.length} pages',
      );
    }
  }

  /// Disposes the preload manager and clears all cached data.
  Future<void> disposePreloadManager() async {
    if (!_isPreloadManagerInitialized) return;

    await _preloadManager.dispose();
    _isPreloadManagerInitialized = false;

    if (kDebugMode) {
      debugPrint('[ReaderMemoryManagement] Disposed');
    }
  }
}
