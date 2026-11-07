import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:mangayomi/modules/manga/reader/controllers/reader_viewport_anchor.dart';

import 'package:mangayomi/modules/manga/reader/reader_translation.dart';
import 'package:mangayomi/modules/manga/reader/managers/reader_image_prefetcher.dart';

import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:photo_view/photo_view.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/services/downloaded_chapter.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart'
    as ssiv;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_gestures.dart';
import 'package:mangayomi/modules/manga/reader/services/page_navigation_service.dart';
import 'package:mangayomi/modules/manga/reader/managers/chapter_preload_manager.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_app_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_bottom_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_overlays.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_page_content.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_settings_modal.dart';
import 'package:mangayomi/modules/manga/reader/widgets/auto_scroll_button.dart';
import 'package:mangayomi/modules/manga/reader/widgets/page_indicator.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/services/chapter_cache.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/utils/double_page_zoom_pan.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_page_index_math.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/manga_reader_provider.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart'
    show resolveCoverImage;
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_entry_state.dart';
import 'package:mangayomi/utils/system_ui.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_auto_scroll.dart';

typedef DoubleClickAnimationListener = void Function();

class MangaReaderView extends ConsumerWidget {
  final int chapterId;
  const MangaReaderView({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final chapterData = ref.watch(mangaReaderProvider(chapterId));
    final chapter = ref.watch(readerChapterProvider(chapterId)).asData?.value;
    final manga = chapter?.manga.value;
    Future<void> retry() async {
      if (chapter != null) {
        await ChapterCache().remove(chapter);
        if (!context.mounted) return;
        ref.invalidate(getChapterPagesProvider(chapter: chapter));
      }
      if (!context.mounted) return;
      if (chapter == null) ref.invalidate(readerChapterProvider(chapterId));
      ref.invalidate(mangaReaderProvider(chapterId));
    }

    Widget entryState({String? failure, Object? error}) {
      if (isMobile && !isTv) {
        return MobileReaderEntryState(
          cover: manga == null ? null : resolveCoverImage(manga, ref),
          bookTitle: manga?.name,
          chapterTitle: chapter?.name,
          failureMessage: failure,
          onRetry: failure == null ? null : retry,
          onBack: () {
            restoreSystemUI();
            Navigator.of(context).pop();
          },
        );
      }
      return scaffoldWith(
        context,
        failure == null
            ? const NodeLaneEmptyState.loading()
            : NodeLaneEmptyState.error(
                title: failure,
                message: error?.toString(),
                onRetry: retry,
              ),
        restoreUi: failure != null,
      );
    }

    return chapterData.when(
      skipLoadingOnRefresh: false,
      skipLoadingOnReload: false,
      loading: () => entryState(),
      error: (error, _) =>
          entryState(failure: l10n.reader_loading_failed, error: error),
      data: (data) {
        final chapter = data.chapter;
        final model = data.pages;

        if (model.pageUrls.isEmpty &&
            !(chapter.manga.value?.isLocalArchive ?? false)) {
          return entryState(failure: l10n.reader_no_pages);
        }

        return MangaChapterPageGallery(
          chapter: chapter,
          chapterUrlModel: model,
        );
      },
    );
  }

  Widget scaffoldWith(
    BuildContext context,
    Widget body, {
    bool restoreUi = false,
  }) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(''),
        // scaffoldWith is only the loading / error / no-pages states, whose
        // bodies have nothing focusable. Without this the d-pad has no starting
        // point on TV and cannot even reach the back button. IconButton, not
        // BackButton, because only IconButton takes autofocus.
        leading: IconButton(
          autofocus: isTv,
          icon: const BackButtonIcon(),
          onPressed: () {
            if (restoreUi) {
              restoreSystemUI();
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      body: body,
    );
  }
}

class MangaChapterPageGalleryState {
  static void setNavigatingToChapter() {
    _MangaChapterPageGalleryState._isNavigatingToChapter = true;
  }
}

class MangaChapterPageGallery extends ConsumerStatefulWidget {
  const MangaChapterPageGallery({
    super.key,
    required this.chapter,
    required this.chapterUrlModel,
  });
  final GetChapterPagesModel chapterUrlModel;

  final Chapter chapter;

  @override
  ConsumerState createState() {
    return _MangaChapterPageGalleryState();
  }
}

class _MangaChapterPageGalleryState
    extends ConsumerState<MangaChapterPageGallery>
    with
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        PageNavigationMixin,
        ReaderAutoScroll {
  @override
  ValueNotifier<bool> get autoScrollEnabled => _autoScroll;
  @override
  ValueNotifier<double> get autoScrollSpeed => _pageOffset;
  @override
  ScrollController get autoScrollController => _continuousScrollController;
  @override
  bool get canAutoScroll => _isContinuousMode() && !_restoringPosition;

  late ReaderController _readerController = ref.read(
    readerControllerProvider(chapter: chapter).notifier,
  );

  final Stopwatch _readingStopwatch = Stopwatch();
  int? _discordReaderSession;

  /// Flag to prevent fullscreen from being disabled when navigating between
  /// chapters via pushReplacement. The old widget's dispose runs after the new
  /// widget is created, which would clobber the new reader's fullscreen state.
  static bool _isNavigatingToChapter = false;

  @override
  void dispose() {
    _disposed.complete();
    WidgetsBinding.instance.removeObserver(this);
    _readingStopwatch.stop();
    _readerController.setHistoryUpdate(
      elapsedSeconds: _readingStopwatch.elapsed.inSeconds,
    );
    _rebuildDetail.close();

    _evictionAndPrefetchDebounce?.cancel();
    _imagePrefetcher.dispose();
    _hasCurrentPageImageError.dispose();
    _currentPageViewIndex.dispose();
    _panAnimator.dispose();
    disposeAutoScroll();
    _autoScroll.removeListener(onAutoScrollChanged);
    _autoScroll.value = false;
    _autoScroll.dispose();
    _autoScrollPage.dispose();
    _currentPageDisplayIndex.dispose();
    _keyboardFocusNode.dispose();
    _continuousScrollController.removeListener(_scheduleReadProgressListener);
    _listController.removeListener(_scheduleReadProgressListener);
    _continuousScrollController.dispose();
    _listController.dispose();

    _extendedController.dispose();
    if (_isNavigatingToChapter) {
      _isNavigatingToChapter = false;
    } else if (isDesktop) {
      setFullScreen(value: false);
    } else {
      restoreSystemUI();
    }
    final discordReaderSession = _discordReaderSession;
    if (discordReaderSession != null) {
      unawaited(discordRpc?.endReaderSession(discordReaderSession));
    }
    _saveCurrentPage(_pageViewToActualIndexSync(_currentIndex ?? 0));
    for (final controller in _pageControllers.values) {
      controller.dispose();
    }
    _pageControllers.clear();
    _preloadManager.dispose();
    _readerController.keepAliveLink?.close();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final keepOn = ref.read(keepScreenOnReaderStateProvider);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _readingStopwatch.stop();
      _readerInForeground = false;
      _imagePrefetcher.clear();
      if (keepOn) {
        WakelockPlus.disable();
      }
      _saveCurrentPage(_pageViewToActualIndex(_currentIndex ?? 0));
    } else if (state == AppLifecycleState.resumed) {
      _readingStopwatch.start();
      _readerInForeground = true;
      _foregroundWaiter?.complete();
      _foregroundWaiter = null;
      _prefetchPagesInOrder();
      _scheduleReadProgressListener();
      if (keepOn) {
        WakelockPlus.enable();
      }
    }
  }

  /// Persists the page at [actualIndex] as this chapter's reading position.
  /// Bounds-checked: it runs from dispose, where a throw would skip the rest
  /// of the cleanup (wakelock, super.dispose).
  void _saveCurrentPage(int actualIndex) {
    if (actualIndex < 0 || actualIndex >= pages.length) return;
    final index = pages[actualIndex].index;
    if (index != null) {
      _readerController.setPageIndex(index, true, _chapterUrlModel.pageUrls);
    }
  }

  late final _autoScroll = ValueNotifier(
    _readerController.autoScrollValues().$1,
  );
  late final _autoScrollPage = ValueNotifier(_autoScroll.value);
  late GetChapterPagesModel _chapterUrlModel = widget.chapterUrlModel;
  late final _preloadManager = ChapterPreloadManager(
    widget.chapterUrlModel.uChapDataPreload,
  );
  List<UChapDataPreload> get pages => _preloadManager.pages;

  late Chapter chapter = widget.chapter;

  final _failedPages = <String>{};
  final _hasCurrentPageImageError = ValueNotifier<bool>(false);
  Timer? _evictionAndPrefetchDebounce;

  void _updateHasCurrentError() {
    final actual = _getCurrentPagesActualIndex();
    final spread = _isDoublePageActive && pages.isNotEmpty
        ? _indexMath.spreads[_actualToPageViewIndex(actual)]
        : null;
    final indices = spread == null
        ? <int?>[actual]
        : <int?>[spread.firstIndex, spread.secondIndex];
    final hasError =
        !_cachedReaderMode.isContinuous &&
        indices.any(
          (i) =>
              i != null &&
              i < pages.length &&
              _failedPages.contains(pages[i].identity),
        );
    if (_hasCurrentPageImageError.value != hasError) {
      _hasCurrentPageImageError.value = hasError;
    }
  }

  void _onFailedToLoadImage(UChapDataPreload page, bool failed) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _disposed.isCompleted) return;
      final changed = failed
          ? _failedPages.add(page.identity)
          : _failedPages.remove(page.identity);
      if (changed) _updateHasCurrentError();
    });
  }

  late ReaderMode _cachedReaderMode = _readerController.getReaderMode();
  late PageMode _pageMode = _readerController.getPageMode();
  Orientation? _lastOrientation;
  PageMode? _lastEffectivePageMode;
  late final _currentReaderMode = StateProvider<ReaderMode?>(
    () => _cachedReaderMode,
  );

  /// The saved position within the chapter. It can point past the end when
  /// the source now serves fewer pages than when the chapter was last read.
  late final int _savedPageIndex = min(
    _readerController.getPageIndex(),
    max(0, widget.chapterUrlModel.uChapDataPreload.length - 1),
  );

  late int? _currentIndex = () {
    final saved = _savedPageIndex;
    if (_isDoublePageActiveSync) {
      return _actualToPageViewIndexSync(saved);
    }
    return saved;
  }();
  late final ValueNotifier<int?> _currentPageViewIndex = ValueNotifier(
    _currentIndex,
  );
  late final ValueNotifier<int> _currentPageDisplayIndex = ValueNotifier(
    _savedPageIndex,
  );

  late final ListController _listController = ListController();
  late final ScrollController _continuousScrollController = ScrollController();
  bool _readProgressScheduled = false;
  ReaderViewportAnchor? _heldViewportAnchor;
  bool _anchorCorrectionPending = false;
  late final _viewportAnchor = ReaderViewportAnchorController(
    onLayoutChanged: _correctViewportAnchor,
  );
  final _disposed = Completer<void>();
  Completer<void>? _foregroundWaiter;
  Completer<void>? _anchorCommit;
  bool _restoringPosition = false;
  bool _readingBackward = false;
  bool _backwardScrollPending = false;
  String? _visiblePageIdentity;
  final _pendingSplits = <String>{};

  String? get _currentIdentity =>
      pages.isEmpty ? null : pages[_getCurrentPagesActualIndex()].identity;

  Future<void> _waitForScrollIdle() async {
    while (!_disposed.isCompleted) {
      if (!_readerInForeground) {
        _foregroundWaiter ??= Completer<void>();
        await Future.any([_foregroundWaiter!.future, _disposed.future]);
        continue;
      }
      final scroll = _cachedReaderMode.isContinuous
          ? _continuousScrollController
          : _extendedController;
      if (!scroll.hasClients || !scroll.position.isScrollingNotifier.value) {
        // The final scroll update may not have laid out yet. Measure only
        // after that frame, and recheck if another gesture has started.
        await Future.any([
          WidgetsBinding.instance.endOfFrame,
          _disposed.future,
        ]);
        if (_disposed.isCompleted) return;
        if (!_readerInForeground) continue;
        if (!scroll.hasClients || !scroll.position.isScrollingNotifier.value) {
          return;
        }
      }
      final scrolling = scroll.position.isScrollingNotifier;
      final idle = Completer<void>();
      void changed() {
        if (!scrolling.value && !idle.isCompleted) idle.complete();
      }

      scrolling.addListener(changed);
      try {
        await Future.any([idle.future, _disposed.future]);
      } finally {
        scrolling.removeListener(changed);
      }
    }
  }

  void _releaseViewportAnchor() {
    _heldViewportAnchor = null;
    _anchorCorrectionPending = false;
  }

  void _correctViewportAnchor() {
    if (_disposed.isCompleted || _heldViewportAnchor == null) return;
    _anchorCorrectionPending = true;
    if (_anchorCommit != null) return;
    unawaited(
      _withIdleViewport(() async {
        _anchorCorrectionPending = false;
        final anchor = _heldViewportAnchor;
        if (anchor == null) return;
        final actual = pages.indexWhere((p) => p.identity == anchor.identity);
        if (actual < 0) {
          _releaseViewportAnchor();
          return;
        }
        await _restoreViewportAnchor(anchor, _actualToPageViewIndex(actual));
      }),
    );
  }

  Future<void> _restoreViewportAnchor(ReaderViewportAnchor anchor, int index) =>
      _viewportAnchor.restore(
        anchor,
        index: index,
        list: _listController,
        scroll: _continuousScrollController,
        isCurrent: () =>
            !_disposed.isCompleted && identical(_heldViewportAnchor, anchor),
      );

  @override
  void startAutoScroll() {
    _releaseViewportAnchor();
    super.startAutoScroll();
  }

  /// One viewport update at a time. Progress stays live while waiting for a
  /// drag/fling; only the actual layout correction pauses progress reporting.
  Future<void> _withIdleViewport(Future<void> Function() update) async {
    while (_anchorCommit != null && !_disposed.isCompleted) {
      await Future.any([_anchorCommit!.future, _disposed.future]);
    }
    if (_disposed.isCompleted) return;
    final done = _anchorCommit = Completer<void>();
    try {
      await _waitForScrollIdle();
      if (_disposed.isCompleted) return;
      _restoringPosition = true;
      stopAutoScroll();
      await update();
    } finally {
      _restoringPosition = false;
      _anchorCommit = null;
      done.complete();
      if (!_disposed.isCompleted) {
        onAutoScrollChanged();
        if (_anchorCorrectionPending) _correctViewportAnchor();
        _scheduleReadProgressListener();
      }
    }
  }

  /// Prepend, split, or regroup spreads after a width discovery. Capture at
  /// commit time because the reader can move while source I/O is pending.
  Future<void> _commitWithAnchor([
    VoidCallback? commit,
  ]) => _withIdleViewport(() async {
    final before = pages;
    if (before.isEmpty) return;
    _anchorCorrectionPending = false;
    var actual = _getCurrentPagesActualIndex();
    if (before[actual].isTransitionPage) {
      actual += before[actual].boundaryDirection == ChapterDirection.previous
          ? 1
          : -1;
    }
    final anchor =
        _heldViewportAnchor ??
        _viewportAnchor.capture(_continuousScrollController);
    if (anchor != null) {
      actual = before.indexWhere((p) => p.identity == anchor.identity);
    }
    assert(actual >= 0, 'The viewport anchor must belong to the page list');
    final page = before[actual];
    _backwardScrollPending = false;
    final oldItems = [
      for (final spread in _indexMath.spreads)
        before[spread.firstIndex].identity,
    ];
    commit?.call();
    final after = pages;
    var target = after.indexWhere((p) => p.identity == page.identity);
    // A split replaces the original by two crops of the same source image.
    if (target < 0) {
      target = after.indexWhere(
        (p) =>
            !p.isTransitionPage &&
            p.chapter?.id == page.chapter?.id &&
            p.index == page.index,
      );
    }
    assert(target >= 0, 'A list mutation must preserve the visible image');
    final index = _actualToPageViewIndex(target);
    final currentActual = _pageViewToActualIndex(index);
    _visiblePageIdentity = after[currentActual].identity;
    _currentIndex = index;
    _currentPageViewIndex.value = index;
    _updateChapterIfNeeded(currentActual);
    _updateDisplayIndex(currentActual);
    setState(() {});
    if (_cachedReaderMode.isContinuous) {
      if (commit == null) {
        // Width discovery has already changed the grouping, even if the
        // number of spreads is unchanged. None of its old sizes is valid.
        if (_listController.isAttached) {
          _listController.invalidateAllExtents();
        }
      } else {
        _viewportAnchor.reindex(
          oldItems: oldItems,
          newItems: [
            for (final spread in _indexMath.spreads)
              after[spread.firstIndex].identity,
          ],
          list: _listController,
        );
      }
      final held = _heldViewportAnchor = ReaderViewportAnchor(
        after[currentActual].identity,
        anchor?.leading ?? 0,
      );
      await _restoreViewportAnchor(held, index);
    } else {
      await WidgetsBinding.instance.endOfFrame;
      if (_disposed.isCompleted) return;
      navigationService.jumpToPage(index: index, readerMode: _cachedReaderMode);
      await WidgetsBinding.instance.endOfFrame;
    }
    if (!_disposed.isCompleted) {
      _scheduleEvictionsAndPrefetch();
    }
  });

  void _scheduleReadProgressListener() {
    if (_readProgressScheduled) return;
    _readProgressScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _readProgressScheduled = false;
      if (!mounted) return;
      _readProgressListener();
    });
  }

  List<double> doubleTapScales = <double>[1.0, 2.0];
  final StreamController<double> _rebuildDetail =
      StreamController<double>.broadcast();
  @override
  void initState() {
    super.initState();
    _readingStopwatch.start();

    _continuousScrollController.addListener(_scheduleReadProgressListener);
    _listController.addListener(_scheduleReadProgressListener);
    initPageNavigation(
      listController: _listController,
      continuousScrollController: _continuousScrollController,
      extendedController: _extendedController,
    );
    _initCurrentIndex();
    _discordReaderSession = discordRpc?.beginReaderSession();
    discordRpc?.showChapterDetails(ref, chapter);
    WidgetsBinding.instance.addObserver(this);
    _autoScroll.addListener(onAutoScrollChanged);
    if (_autoScroll.value && _isContinuousMode()) {
      startAutoScroll();
    }
    _initWakelock();
  }

  void _initWakelock() {
    final keepOn = ref.read(keepScreenOnReaderStateProvider);
    if (keepOn) {
      WakelockPlus.enable();
    }
  }

  // final double _horizontalScaleValue = 1.0; TODO
  bool _readerInForeground = true;
  late final _imagePrefetcher = ReaderImagePrefetcher(
    load: (page, isCurrent) async {
      final path = page.resolvedFilePath ?? await page.getLocalFilePath;
      if (!mounted || !isCurrent()) return;
      if (path != null) {
        page.resolvedFilePath = path;
        return;
      }
      final provider = page.getImageProvider(ref, false);
      if (provider is CustomExtendedNetworkImageProvider) {
        await provider.getNetworkImageData();
        if (!mounted || !isCurrent()) return;
        final cachedPath = await page.getLocalFilePath;
        if (mounted && isCurrent()) page.resolvedFilePath = cachedPath;
      }
    },
  );

  int get pagePreloadAmount => ref.read(pagePreloadAmountStateProvider);
  late bool _isBookmarked = _readerController.getChapterBookmarked();

  bool _isView = false;
  final _keyboardFocusNode = FocusNode();
  final Map<String, ssiv.SubsamplingScaleImageViewController> _pageControllers =
      {};

  int _flashPageCount = 0;
  bool _isFlashing = false;
  Color _flashOverlayColor = Colors.black;
  bool _showNavigationOverlay = false;
  bool _isCurrentPageZoomed = false;
  final Map<String, PhotoViewController> _doublePageControllers = {};
  late final _panAnimator = DoublePagePanAnimator(this);
  static const _zoomNav = DoublePageZoomNavigation();

  void _handleNextPageZoomed() {
    final controller = _doublePageControllers[_currentIdentity];
    if (controller == null) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final scale = controller.scale ?? 1.0;
    final maxX = screenWidth * (scale - 1.0) / 2.0;

    final targetDx = _zoomNav.nextPanTarget(
      dx: controller.position.dx,
      maxX: maxX,
      step: screenWidth * 0.4,
      isReverseHorizontal: _isReverseHorizontal,
    );
    if (targetDx == null) {
      _handlePageNavigation(forward: true);
    } else {
      _panAnimator.animateTo(
        controllerLookup: () => _doublePageControllers[_currentIdentity],
        targetDx: targetDx,
      );
    }
  }

  void _handlePreviousPageZoomed() {
    final controller = _doublePageControllers[_currentIdentity];
    if (controller == null) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final scale = controller.scale ?? 1.0;
    final maxX = screenWidth * (scale - 1.0) / 2.0;

    final targetDx = _zoomNav.previousPanTarget(
      dx: controller.position.dx,
      maxX: maxX,
      step: screenWidth * 0.4,
      isReverseHorizontal: _isReverseHorizontal,
    );
    if (targetDx == null) {
      _handlePageNavigation(forward: false);
    } else {
      _panAnimator.animateTo(
        controllerLookup: () => _doublePageControllers[_currentIdentity],
        targetDx: targetDx,
      );
    }
  }

  void _updateZoomState(String identity) {
    if (!mounted) return;
    if (identity != _currentIdentity) return;
    final controller = _pageControllers[identity];
    if (controller == null) return;
    final bool isZoomed = controller.scale > controller.minScale * 1.01;
    if (_isCurrentPageZoomed != isZoomed) {
      setState(() {
        _isCurrentPageZoomed = isZoomed;
      });
    }
  }

  void _triggerFlash() async {
    if (!mounted) return;
    final flashOn = ref.read(flashOnPageChangeStateProvider);
    if (!flashOn) return;

    final interval = ref.read(flashIntervalStateProvider);
    _flashPageCount++;
    if (_flashPageCount % interval != 0) return;

    final durationMs = ref.read(flashDurationStateProvider);
    final colorOption = ref.read(flashColorStateProvider);

    setState(() {
      _isFlashing = true;
      _flashOverlayColor = colorOption == 0 ? Colors.black : Colors.white;
    });

    if (colorOption == 2) {
      await Future.delayed(Duration(milliseconds: (durationMs ~/ 2)));
      if (!mounted) return;
      setState(() {
        _flashOverlayColor = Colors.black;
      });
      await Future.delayed(Duration(milliseconds: (durationMs ~/ 2)));
    } else {
      await Future.delayed(Duration(milliseconds: durationMs));
    }

    if (!mounted) return;
    setState(() {
      _isFlashing = false;
    });
  }

  late final _extendedController = PageController(initialPage: _currentIndex!);

  late Axis _scrollDirection = _cachedReaderMode == ReaderMode.vertical
      ? Axis.vertical
      : Axis.horizontal;
  late bool _isReverseHorizontal = _cachedReaderMode.isRTL;

  Color _backgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9);

  /// Toggles fullscreen. [value] is whether it is on now; F11 passes none,
  /// so off desktop the reader's own setting stands in for it.
  void _setFullScreen({bool? value}) async {
    if (isDesktop) {
      value = await windowManager.isFullScreen();
      setFullScreen(value: !value);
    }
    if (!mounted) return;
    final bool isOn = value ?? ref.read(fullScreenReaderStateProvider);
    ref.read(fullScreenReaderStateProvider.notifier).set(!isOn);
  }

  /// Goes to either next or previous chapter
  ///
  /// The [next] parameter determines the navigation direction:
  /// - `true` -> navigate to next chapter
  /// - `false` -> navigate to previous chapter
  ///
  /// If the reader is already at the first or last chapter (depending on
  /// the direction), the method returns without navigating.
  void _goToChapter(bool next) {
    if (next && !_readerController.hasNextChapter) return;
    if (!next && !_readerController.hasPreviousChapter) return;
    _isNavigatingToChapter = true;
    try {
      pushReplacementMangaReaderView(
        context: context,
        chapter: next
            ? _readerController.getNextChapter()
            : _readerController.getPrevChapter(),
      );
    } catch (_) {
      // If the replacement fails, dispose() never runs to reset this flag, so reset it here instead.
      _isNavigatingToChapter = false;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    final readerMode = ref.watch(_currentReaderMode);
    if (readerMode == null) return const SizedBox.shrink();

    final thresholdIdx = ref.watch(readerHideThresholdStateProvider);
    final double scrollHideThreshold = switch (thresholdIdx) {
      0 => 5.0,
      1 => 13.0,
      2 => 31.0,
      _ => 47.0,
    };

    final doublePageAuto = ref.watch(doublePageAutoStateProvider);
    final orientation = MediaQuery.orientationOf(context);
    final effectivePageMode = doublePageAuto
        ? (orientation == Orientation.landscape
              ? PageMode.doublePage
              : PageMode.onePage)
        : _pageMode;

    final prevEffectiveMode = _lastEffectivePageMode ?? _pageMode;
    if (prevEffectiveMode != effectivePageMode) {
      final currentActual = _getCurrentPagesActualIndex(prevEffectiveMode);
      final targetIndex = effectivePageMode == PageMode.doublePage
          ? ReaderPageIndexMath(
              isDoublePageActive: true,
              singleFirst: ref.read(doublePageSingleFirstPageStateProvider),
              pageCount: pages.length,
              pages: pages,
            ).actualToPageViewIndex(currentActual)
          : currentActual;
      _currentIndex = targetIndex;
      _currentPageViewIndex.value = targetIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final mode = ref.read(_currentReaderMode);
        if (mode != null) {
          navigationService.jumpToPage(index: targetIndex, readerMode: mode);
        }
      });
    }
    _lastOrientation = orientation;
    _lastEffectivePageMode = effectivePageMode;

    ref.listen<bool>(doublePageSingleFirstPageStateProvider, (previous, next) {
      if (previous != null &&
          previous != next &&
          _isDoublePageActive &&
          mounted) {
        final currentActual = _getCurrentPagesActualIndex();
        final newPvIndex = ReaderPageIndexMath(
          isDoublePageActive: true,
          singleFirst: next,
          pageCount: pages.length,
          pages: pages,
        ).actualToPageViewIndex(currentActual);
        _currentIndex = newPvIndex;
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          navigationService.jumpToPage(
            index: newPvIndex,
            readerMode: ref.read(_currentReaderMode)!,
          );
        });
      }
    });

    return ReaderKeyboardHandler(
      onPreviousPage: () {
        if (_isCurrentPageZoomed &&
            _doublePageControllers[_currentIdentity] != null) {
          _handlePreviousPageZoomed();
        } else {
          _handlePageNavigation(forward: false);
        }
      },
      onNextPage: () {
        if (_isCurrentPageZoomed &&
            _doublePageControllers[_currentIdentity] != null) {
          _handleNextPageZoomed();
        } else {
          _handlePageNavigation(forward: true);
        }
      },
      onEscape: () => _goBack(context),
      onFullScreen: () => _setFullScreen(),
      onNextChapter: () => _goToChapter(true),
      onPreviousChapter: () => _goToChapter(false),
    ).wrapWithKeyboardListener(
      isReverseHorizontal: _isReverseHorizontal,
      focusNode: _keyboardFocusNode,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is UserScrollNotification &&
              notification.direction != ScrollDirection.idle) {
            _releaseViewportAnchor();
          }
          if (notification is ScrollStartNotification) {
            if (notification.dragDetails != null) {
              isUserDragging = true;
              _releaseViewportAnchor();
            }
          } else if (notification is ScrollEndNotification) {
            isUserDragging = false;
          }
          if (notification is ScrollUpdateNotification) {
            final delta = notification.scrollDelta ?? 0.0;
            if (!_restoringPosition && isUserDragging && delta != 0) {
              _readingBackward = delta < 0;
              if (delta < 0) _backwardScrollPending = true;
            }
            if (delta.abs() > scrollHideThreshold && _isView) {
              _isViewFunction();
            }
          }
          return true;
        },
        child: Material(
          child: SafeArea(
            top: !fullScreenReader,
            bottom: false,
            child: ReaderTranslationHost(
              pages: pages,
              currentIndex: _getCurrentPagesActualIndex(),
              pageListenable: _currentPageViewIndex,
              actualIndex: () => _getCurrentPagesActualIndex(),
              visibleCount: effectivePageMode == PageMode.doublePage ? 2 : 1,
              child: Stack(
                children: [
                  ReaderPageContent(
                    pages: pages,
                    chapter: widget.chapter,
                    readerMode: readerMode,
                    pageMode: effectivePageMode,
                    backgroundColor: backgroundColor,
                    pagePreloadAmount: pagePreloadAmount,
                    currentPageViewIndex: _currentIndex!,
                    viewportAnchor: _viewportAnchor,
                    isReverseHorizontal: _isReverseHorizontal,
                    isCurrentPageZoomed: _isCurrentPageZoomed,
                    listController: _listController,
                    continuousScrollController: _continuousScrollController,
                    extendedController: _extendedController,
                    scrollDirection: _scrollDirection,
                    pageControllerFor: (page) => _pageControllers.putIfAbsent(
                      page.identity,
                      () => ssiv.SubsamplingScaleImageViewController()
                        ..addListener(() => _updateZoomState(page.identity)),
                    ),
                    onFailedToLoadImage: _onFailedToLoadImage,
                    onWidePage: _splitWidePage,
                    onWideSinglePageLoaded: _onWideSinglePageLoaded,
                    onDoublePageZoomChanged: (identity, zoomed) {
                      if (identity == _currentIdentity) {
                        if (mounted && _isCurrentPageZoomed != zoomed) {
                          setState(() {
                            _isCurrentPageZoomed = zoomed;
                          });
                        }
                      }
                    },
                    onDoublePageControllerChanged:
                        (identity, controller, attached) {
                          if (attached) {
                            _doublePageControllers[identity] = controller;
                          } else if (identical(
                            _doublePageControllers[identity],
                            controller,
                          )) {
                            // A spread rebuilt under a new key registers its
                            // controller before the old one is disposed; only
                            // drop the entry if it is still the disposed one's.
                            _doublePageControllers.remove(identity);
                          }
                        },
                    onPageChanged: _onPageChanged,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _hasCurrentPageImageError,
                    builder: (context, hasCurrentError, child) {
                      return ReaderOverlays(
                        isReverseHorizontal: _isReverseHorizontal,
                        hasCurrentPageImageError: hasCurrentError,
                        isContinuousMode: readerMode.isContinuous,
                        onToggleUI: _isViewFunction,
                        onPreviousPage: () {
                          if (_isCurrentPageZoomed &&
                              _doublePageControllers[_currentIdentity] !=
                                  null) {
                            _handlePreviousPageZoomed();
                          } else {
                            _handlePageNavigation(forward: false);
                          }
                        },
                        onNextPage: () {
                          if (_isCurrentPageZoomed &&
                              _doublePageControllers[_currentIdentity] !=
                                  null) {
                            _handleNextPageZoomed();
                          } else {
                            _handlePageNavigation(forward: true);
                          }
                        },
                        isFlashing: _isFlashing,
                        flashOverlayColor: _flashOverlayColor,
                        showNavigationOverlay: _showNavigationOverlay,
                        onCloseNavigationOverlay: () {
                          setState(() {
                            _showNavigationOverlay = false;
                          });
                        },
                      );
                    },
                  ),
                  ReaderAppBar(
                    chapter: chapter,
                    mangaName: _readerController.getMangaName(),
                    chapterTitle: _readerController.getChapterTitle(),
                    isVisible: _isView,
                    isBookmarked: _isBookmarked,
                    backgroundColor: _backgroundColor,
                    onBackPressed: () => Navigator.pop(context),
                    onBookmarkPressed: () {
                      _readerController.setChapterBookmarked();
                      setState(() {
                        _isBookmarked = !_isBookmarked;
                      });
                    },
                    onWebViewPressed:
                        (chapter.manga.value!.isLocalArchive ?? false) == false
                        ? () {
                            final data = buildWebViewData(chapter);
                            if (data != null) {
                              context.push("/mangawebview", extra: data);
                            }
                          }
                        : null,
                    onRefreshPressed:
                        (chapter.manga.value!.isLocalArchive ?? false) == false
                        ? () async {
                            // Drop the cached page list first: rebuilding the
                            // reader reads it, and a list left in place would be
                            // reused as-is.
                            await ChapterCache().remove(chapter);
                            ref.invalidate(
                              getChapterPagesProvider(chapter: chapter),
                            );
                            if (chapter.id != null) {
                              ref.invalidate(mangaReaderProvider(chapter.id!));
                            }
                            if (context.mounted) {
                              pushReplacementMangaReaderView(
                                chapter: chapter,
                                context: context,
                              );
                            }
                          }
                        : null,
                  ),
                  ReaderBottomBar(
                    chapter: chapter,
                    isVisible: _isView,
                    hasPreviousChapter: _readerController.hasPreviousChapter,
                    hasNextChapter: _readerController.hasNextChapter,
                    onPreviousChapter: () => _goToChapter(false),
                    onNextChapter: () => _goToChapter(true),
                    onChaptersClosed: () {
                      if (!mounted) return;
                      final bookmarked = chapterRepository
                          .findByIdSync(chapter.id!)
                          ?.isBookmarked;
                      if (bookmarked != null && bookmarked != _isBookmarked) {
                        setState(() => _isBookmarked = bookmarked);
                      }
                    },
                    onSliderChanged: (value, ref) {
                      _currentPageDisplayIndex.value = value;
                      ref
                          .read(currentIndexProvider(chapter).notifier)
                          .setCurrentIndex(value);
                    },
                    onSliderChangeEnd: (value) {
                      // The slider uses chapter-local image numbers; the
                      // reading list can include earlier chapters and splits.
                      int jumpIndex = _actualIndexOfChapterPage(value);
                      if (jumpIndex == -1) return;
                      // In double page mode, convert array index to page view index
                      if (_isDoublePageActive) {
                        jumpIndex = _actualToPageViewIndex(jumpIndex);
                      }
                      _visiblePageIdentity =
                          pages[_pageViewToActualIndex(jumpIndex)].identity;
                      _readingBackward = jumpIndex < (_currentIndex ?? 0);
                      _backwardScrollPending = _readingBackward;
                      _heldViewportAnchor = _cachedReaderMode.isContinuous
                          ? ReaderViewportAnchor(_visiblePageIdentity!, 0)
                          : null;
                      _currentIndex = jumpIndex;
                      _currentPageViewIndex.value = jumpIndex;
                      navigationService.jumpToPage(
                        index: jumpIndex,
                        readerMode: ref.read(_currentReaderMode)!,
                      );
                      _correctViewportAnchor();
                      _scheduleEvictionsAndPrefetch();
                    },
                    onReaderModeChanged: (mode, ref) {
                      ref.read(_currentReaderMode.notifier).state = mode;
                      _setReaderMode(mode, ref);
                    },
                    onPageModeToggle: () async {
                      final readerMode = ref.read(_currentReaderMode);
                      if (!(readerMode?.isHorizontalContinuous ?? false)) {
                        final currentEffective = _effectivePageMode;
                        final currentActual = _getCurrentPagesActualIndex(
                          currentEffective,
                        );
                        final PageMode newPageMode =
                            currentEffective == PageMode.onePage
                            ? PageMode.doublePage
                            : PageMode.onePage;
                        ref
                            .read(doublePageAutoStateProvider.notifier)
                            .set(false);
                        _readerController.setPageMode(newPageMode);

                        final singleFirst = ref.read(
                          doublePageSingleFirstPageStateProvider,
                        );
                        final int targetIndex =
                            newPageMode == PageMode.doublePage
                            ? ReaderPageIndexMath(
                                isDoublePageActive: true,
                                singleFirst: singleFirst,
                                pageCount: pages.length,
                                pages: pages,
                              ).actualToPageViewIndex(currentActual)
                            : currentActual;

                        _currentIndex = targetIndex;
                        _currentPageViewIndex.value = targetIndex;
                        if (mounted) {
                          setState(() {
                            _pageMode = newPageMode;
                            _lastEffectivePageMode = newPageMode;
                          });
                        }

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          navigationService.jumpToPage(
                            index: targetIndex,
                            readerMode: ref.read(_currentReaderMode)!,
                          );
                        });
                      }
                    },
                    onSettingsPressed: () => ReaderSettingsModal.show(
                      context: context,
                      bookTitle: _readerController.getMangaName(),
                      vsync: this,
                      currentReaderModeProvider: _currentReaderMode,
                      autoScroll: _autoScroll,
                      autoScrollPage: _autoScrollPage,
                      pageOffset: _pageOffset,
                      onAutoPageScroll: onAutoScrollChanged,
                      onReaderModeChanged: (mode, widgetRef) {
                        widgetRef.read(_currentReaderMode.notifier).state =
                            mode;
                        _setReaderMode(mode, widgetRef);
                      },
                      onAutoScrollSave: (enabled, offset) {
                        _readerController.setAutoScroll(enabled, offset);
                      },
                      onFullScreenToggle: () {
                        final fullScreen = ref.read(
                          fullScreenReaderStateProvider,
                        );
                        _setFullScreen(value: !fullScreen);
                      },
                    ),
                    currentReaderModeProvider: _currentReaderMode,
                    currentPageListenable: _currentPageDisplayIndex,
                    currentPageMode: effectivePageMode,
                    readPageMode: () =>
                        mounted ? _effectivePageMode : _pageMode,
                    isReverseHorizontal: _isReverseHorizontal,
                    totalPages: _readerController.getCachedPageLength(
                      _chapterUrlModel.pageUrls,
                    ),
                    currentIndexLabel: _currentIndexLabel,
                    backgroundColor: _backgroundColor,
                  ),
                  RepaintBoundary(
                    child: PageIndicator(
                      isUiVisible: _isView,
                      currentPageListenable: _currentPageDisplayIndex,
                      totalPages: _readerController.getCachedPageLength(
                        _chapterUrlModel.pageUrls,
                      ),
                      formatCurrentIndex: _currentIndexLabel,
                    ),
                  ),
                  ReaderAutoScrollButton(
                    isContinuousMode: readerMode.isContinuous,
                    isUiVisible: _isView,
                    autoScrollPage: _autoScrollPage,
                    autoScroll: _autoScroll,
                    onToggle: () {
                      _autoScroll.value = !_autoScroll.value;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _splitWidePage(UChapDataPreload page, double width, double height) {
    if (!mounted || _pendingSplits.contains(page.identity)) return;
    if (page.srcRect != null || page.isTransitionPage) return;
    if (_isDoublePageActive) return;

    final isRTL = _isReverseHorizontal;
    final dualPageInvert = ref.read(dualPageInvertStateProvider);
    final shouldInvert = isRTL ^ dualPageInvert;
    final halfWidth = width / 2;

    final Rect firstRect;
    final Rect secondRect;

    if (shouldInvert) {
      firstRect = Rect.fromLTWH(halfWidth, 0, halfWidth, height);
      secondRect = Rect.fromLTWH(0, 0, halfWidth, height);
    } else {
      firstRect = Rect.fromLTWH(0, 0, halfWidth, height);
      secondRect = Rect.fromLTWH(halfWidth, 0, halfWidth, height);
    }

    final page1 =
        UChapDataPreload(
            page.chapter,
            page.directory,
            page.pageUrl,
            page.isLocale,
            page.archiveImage,
            page.index,
            page.chapterUrlModel,
            page.pageIndex,
            srcRect: firstRect,
            localImagePath: page.localImagePath,
          )
          ..loadedWidth = halfWidth
          ..loadedHeight = height;

    final page2 =
        UChapDataPreload(
            page.chapter,
            page.directory,
            page.pageUrl,
            page.isLocale,
            page.archiveImage,
            page.index,
            page.chapterUrlModel,
            page.pageIndex,
            srcRect: secondRect,
            localImagePath: page.localImagePath,
          )
          ..loadedWidth = halfWidth
          ..loadedHeight = height;

    _pendingSplits.add(page.identity);
    unawaited(
      _commitWithAnchor(() {
        final index = pages.indexWhere((p) => p.identity == page.identity);
        if (index >= 0) _preloadManager.splitPage(index, page1, page2);
      }).whenComplete(() => _pendingSplits.remove(page.identity)),
    );
  }

  void _handlePageNavigation({required bool forward}) {
    _releaseViewportAnchor();
    _readingBackward = !forward;
    _backwardScrollPending = !forward;
    final readerMode = ref.read(_currentReaderMode);
    final animatePageTransitions = ref.read(
      animatePageTransitionsStateProvider,
    );
    if (readerMode == null || _currentIndex == null) return;

    if (readerMode == ReaderMode.webtoon) {
      final isHorizontal = readerMode.isHorizontalContinuous;
      final viewportSize = MediaQuery.sizeOf(context);
      final dimension = isHorizontal ? viewportSize.width : viewportSize.height;
      final offset = dimension * 0.60 * (forward ? 1 : -1);
      final duration = animatePageTransitions
          ? const Duration(milliseconds: 160)
          : const Duration(milliseconds: 10);
      if (_continuousScrollController.hasClients) {
        final target = (_continuousScrollController.offset + offset).clamp(
          _continuousScrollController.position.minScrollExtent,
          _continuousScrollController.position.maxScrollExtent,
        );
        _continuousScrollController.animateTo(
          target,
          duration: duration,
          curve: Curves.easeInOut,
        );
      }
      return;
    }

    final navigateToPan = ref.read(navigateToPanStateProvider);
    final actualIdx = _pageViewToActualIndex(_currentIndex!);
    final controller = _pageControllers[pages[actualIdx].identity];
    if (navigateToPan && controller != null && controller.isReady) {
      if (forward) {
        if (_isReverseHorizontal) {
          if (controller.canPanLeft()) {
            controller.panLeft();
            return;
          }
        } else {
          if (controller.canPanRight()) {
            controller.panRight();
            return;
          }
        }
      } else {
        if (_isReverseHorizontal) {
          if (controller.canPanRight()) {
            controller.panRight();
            return;
          }
        } else {
          if (controller.canPanLeft()) {
            controller.panLeft();
            return;
          }
        }
      }
    }

    if (forward) {
      navigationService.nextPage(
        readerMode: readerMode,
        currentIndex: _currentIndex!,
        maxPages: _pageViewPageCount,
        animate: animatePageTransitions,
      );
    } else {
      navigationService.previousPage(
        readerMode: readerMode,
        currentIndex: _currentIndex!,
        animate: animatePageTransitions,
      );
    }
  }

  /// Reconcile visible images, chapter progress and adjacent-page demand.
  void _readProgressListener() {
    if (!mounted ||
        !_cachedReaderMode.isContinuous ||
        _restoringPosition ||
        _anchorCorrectionPending ||
        !_listController.isAttached) {
      return;
    }
    final range = _listController.visibleRange;
    if (range == null) return;
    final (first, last) = range;
    final visible = _viewportAnchor.capture(_continuousScrollController);
    final actual = visible == null
        ? -1
        : pages.indexWhere((p) => p.identity == visible.identity);
    final newIndex = actual >= 0 ? _actualToPageViewIndex(actual) : first;
    final bool pageChanged = _currentIndex != newIndex;
    if (pageChanged) _readingBackward = newIndex < (_currentIndex ?? newIndex);
    _currentIndex = newIndex;
    _currentPageViewIndex.value = newIndex;
    if (pageChanged) _triggerFlash();
    final currentReaderMode = ref.read(_currentReaderMode);
    int pagesLength =
        (_effectivePageMode == PageMode.doublePage &&
            !(currentReaderMode?.isHorizontalContinuous ?? false))
        ? _pageViewPageCount
        : pages.length;
    if (_currentIndex! >= 0 && _currentIndex! < pagesLength) {
      final actualIndex = _pageViewToActualIndex(_currentIndex!);
      _visiblePageIdentity = pages[actualIndex].identity;
      _updateChapterIfNeeded(actualIndex);

      if (pagesLength - 1 - last <= pagePreloadAmount) {
        _triggerChapterPreload(ChapterDirection.next);
      }
      // Layout/prepend notifications alone never recursively fetch earlier
      // chapters. Only a backward reading action re-arms the leading edge.
      if (_backwardScrollPending && actualIndex <= 2) {
        _backwardScrollPending = false;
        _triggerChapterPreload(ChapterDirection.previous);
      }

      // Ensure the current chapter's pages are reloaded if they were evicted,
      // and evict old chapters' pages to free memory. Gated on pageChanged
      // (not just index-in-bounds) since this listener fires on every scroll
      // frame during a fling, not just once per settled page - unlike the
      // paged-mode handler, which only runs on discrete PageView transitions.
      // Both checks below do a linear scan over `pages`, so running them
      // unconditionally here would re-scan dozens of times per second during
      // continuous scrolling.
      _updateDisplayIndex(actualIndex);
      if (pageChanged) {
        _updateHasCurrentError();
        _scheduleEvictionsAndPrefetch();
      }
    }
  }

  void _onWideSinglePageLoaded(UChapDataPreload page) {
    if (!mounted ||
        !_isDoublePageActive ||
        !pages.any((p) => p.identity == page.identity)) {
      return;
    }
    unawaited(_commitWithAnchor());
  }

  void _triggerChapterPreload(ChapterDirection direction) {
    if (!mounted || !_readerInForeground) return;
    unawaited(
      _preloadManager.loadAdjacentChapter(
        direction,
        findChapter: (edge) {
          if (!mounted) throw StateError('Reader closed');
          final active = edge.id == chapter.id;
          final controller = active
              ? _readerController
              : ref.read(readerControllerProvider(chapter: edge).notifier);
          try {
            return direction == ChapterDirection.next
                ? (controller.hasNextChapter
                      ? controller.getNextChapter()
                      : null)
                : (controller.hasPreviousChapter
                      ? controller.getPrevChapter()
                      : null);
          } finally {
            if (!active) controller.keepAliveLink?.close();
          }
        },
        loadPages: (adjacent, retry) async {
          if (!mounted) throw StateError('Reader closed');
          final provider = getChapterPagesProvider(chapter: adjacent);
          if (retry) {
            await ChapterCache().remove(adjacent);
            if (!mounted) throw StateError('Reader closed');
            ref.invalidate(provider);
          }
          return ref.read(provider.future);
        },
      ),
    );
  }

  void _initCurrentIndex() async {
    final readerMode = _cachedReaderMode;
    _currentPageDisplayIndex.value = _savedPageIndex;

    _preloadManager.commitPrepend = _commitWithAnchor;
    _preloadManager.onPagesUpdated = () {
      if (!mounted) return;
      setState(() {});
      if (_restoringPosition) return;
      // A waiting slot can become the next chapter's first image without
      // scrolling. Reconcile progress after the new list has been laid out.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _restoringPosition) return;
        final mode = ref.read(_currentReaderMode);
        if (mode == null) return;
        _prefetchPagesInOrder();
        if (mode.isContinuous) {
          _readProgressListener();
        } else if (_extendedController.hasClients &&
            _currentIndex != null &&
            _currentIndex! < _pageViewPageCount) {
          final actual = _pageViewToActualIndex(_currentIndex!);
          if (pages[actual].chapter?.id != chapter.id) {
            unawaited(_onPageChanged(_currentIndex!));
          }
        }
      });
    };

    _visiblePageIdentity = pages[_getCurrentPagesActualIndex()].identity;
    if (readerMode.isContinuous) {
      _heldViewportAnchor = ReaderViewportAnchor(_visiblePageIdentity!, 0);
      _anchorCorrectionPending = true;
    }

    // Kick off ordered prefetch before the first frame so lower-indexed pages
    // win the HTTP race against the simultaneous widget-driven loads.
    _prefetchPagesInOrder();

    // Start the next chapter in the background, keeping a visible boundary.
    _triggerChapterPreload(ChapterDirection.next);

    _readerController.setHistoryUpdate();
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    final fullScreenReader = ref.read(fullScreenReaderStateProvider);
    if (fullScreenReader) {
      if (isDesktop) {
        setFullScreen(value: true);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    }
    ref.read(_currentReaderMode.notifier).state = readerMode;
    await _setReaderMode(
      readerMode,
      ref,
      forceIndex: _getCurrentPagesActualIndex(),
    );
    if (!mounted) return;
    if (_getCurrentPagesActualIndex() <= 2) {
      _triggerChapterPreload(ChapterDirection.previous);
    }

    if (!readerMode.isVerticalContinuous) {
      _autoScroll.value = false;
    }
    onAutoScrollChanged();
    if (_readerController.getPageLength(_chapterUrlModel.pageUrls) == 1 &&
        (readerMode.isHorizontalPaged || readerMode == ReaderMode.vertical)) {
      _onPageChanged(0);
    }
  }

  /// Reloads a chapter's page image data if it was previously evicted by
  /// [ChapterPreloadManager.evictOldChapters] (e.g. the reader scrolled
  /// forward far enough that this chapter's data was cleared to free memory,
  /// then scrolled back into it). Re-reads the local `.cbz` archive and
  /// re-populates each page's `archiveImage`.
  ///
  /// Only applies to archive-backed local chapters (cbz/zip/etc.) - plain
  /// image-folder chapters carry [UChapDataPreload.localImagePath] pointing
  /// straight at their real file on disk, so there's nothing to evict or
  /// reload for them in the first place.
  ///
  /// Cheap no-op for the common case where [currentChapter] was never
  /// evicted, via [ChapterPreloadManager.isChapterEvicted] - avoids scanning
  /// every page of the chapter on every page-change.
  Future<void> _checkAndReloadEvictedPages(Chapter currentChapter) async {
    if (!_preloadManager.isChapterEvicted(currentChapter)) return;

    final chapterId = currentChapter.id;
    bool needsReload = false;
    for (final page in pages) {
      if (page.chapter?.id == chapterId &&
          !page.isTransitionPage &&
          page.isLocale == true &&
          page.archiveImage == null &&
          page.localImagePath == null) {
        needsReload = true;
        break;
      }
    }

    if (needsReload) {
      final isLocalArchive = (currentChapter.archivePath ?? '').isNotEmpty;
      final archivePath = isLocalArchive
          ? await resolveLocalArchivePath(currentChapter.archivePath!)
          : (await findDownloadedChapter(currentChapter))?.archive?.path;
      if (!mounted) return;

      if (archivePath != null && await File(archivePath).exists()) {
        try {
          final local = await ref.read(
            getArchiveDataFromFileProvider(archivePath).future,
          );
          if (!mounted) return;
          final images = local.images ?? [];
          for (final page in pages) {
            // A page's index is its image's position in the archive. Not a
            // running count: both halves of a split wide page share one.
            final imgIdx = page.index;
            if (page.chapter?.id == currentChapter.id &&
                !page.isTransitionPage &&
                imgIdx != null &&
                imgIdx < images.length) {
              page.archiveImage = images[imgIdx].image;
            }
          }
          _preloadManager.markChapterAsLoaded(currentChapter);
          if (mounted) {
            setState(() {});
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Error reloading evicted chapter pages: $e');
          }
        }
      }
    } else {
      // Remote pages and image folders can resolve from their existing URLs /
      // paths. Restore their membership so subsequent eviction stays bounded.
      _preloadManager.markChapterAsLoaded(currentChapter);
    }
  }

  /// Fetch encoded images in the current window without decoding offscreen
  /// pages. Replacing the queue preserves a reader-wide limit of three workers.
  void _prefetchPagesInOrder() {
    if (!mounted || !_readerInForeground || pages.isEmpty) return;
    final snapshot = pages;
    final actualIdx = _pageViewToActualIndexSync(_currentIndex ?? 0);
    final startIdx = actualIdx.clamp(0, snapshot.length - 1);
    final preloadAmount = ref.read(pagePreloadAmountStateProvider);
    final forwardLimit = (startIdx + (_readingBackward ? 2 : preloadAmount))
        .clamp(0, snapshot.length - 1);
    final backwardLimit = (startIdx - (_readingBackward ? preloadAmount : 2))
        .clamp(0, snapshot.length - 1);
    _imagePrefetcher.update([
      snapshot[startIdx],
      if (_readingBackward) ...[
        for (var i = startIdx - 1; i >= backwardLimit; i--) snapshot[i],
        for (var i = startIdx + 1; i <= forwardLimit; i++) snapshot[i],
      ] else ...[
        for (var i = startIdx + 1; i <= forwardLimit; i++) snapshot[i],
        for (var i = startIdx - 1; i >= backwardLimit; i--) snapshot[i],
      ],
    ]);
  }

  /// Handles page changes in PageView mode (discrete pages).
  ///
  /// Responsibilities:
  /// - Convert PageView index -> actual page index (handles double-page mode).
  /// - Update reader progress and chapter if the new page belongs to another chapter.
  /// - Reset zoom/scale of the previous page so swiping back works smoothly.
  /// - Trigger flash animation on page change.
  /// - Update display index and persist progress.
  /// - Preload next chapter when nearing the end of the current one.
  /// - Reload evicted pages if needed and evict old chapter pages to free memory.
  /// - Prefetch pages in correct order for smoother reading.
  ///
  /// This is the main handler for all logic that should occur when the user
  /// swipes to a new page in PageView mode.
  Future<void> _onPageChanged(int index) async {
    if (!mounted ||
        _restoringPosition ||
        index < 0 ||
        index >= _pageViewPageCount) {
      return;
    }
    // In non-continuous double page mode, convert page view index to actual
    // pages array index for correct lookups.
    final int actualIndex = _pageViewToActualIndex(index);
    final int prevActualIndex = _pageViewToActualIndex(_currentIndex!);

    _updateChapterIfNeeded(actualIndex);
    // Avoid rebuilding the tile map when an untransformed page crosses
    // PageView's 50% onPageChanged threshold.
    if (_isCurrentPageZoomed) {
      _pageControllers[pages[prevActualIndex].identity]?.resetScaleAndCenter();
      if (_isDoublePageActive) {
        final previousController = _doublePageControllers[_currentIdentity];
        if (previousController != null) {
          previousController.scale = 1.0;
          previousController.position = Offset.zero;
        }
      }
    }

    final bool pageChanged = _currentIndex != index;
    if (pageChanged) _readingBackward = index < (_currentIndex ?? index);
    _visiblePageIdentity = pages[actualIndex].identity;
    _currentIndex = index;
    _currentPageViewIndex.value = index;

    if (pageChanged) _triggerFlash();
    _updateDisplayIndex(actualIndex);

    // ── Next-chapter preloading: trigger when near the end ──
    final distToEnd = pages.length - 1 - actualIndex;
    if (distToEnd <= pagePreloadAmount) {
      _triggerChapterPreload(ChapterDirection.next);
    }

    if (pageChanged && _readingBackward && actualIndex <= 2) {
      _triggerChapterPreload(ChapterDirection.previous);
    }
    await _handleEvictionsAndPrefetch();
  }

  Future<void> _handleEvictionsAndPrefetch() async {
    // Ensure the current chapter's pages are reloaded if they were evicted
    await _checkAndReloadEvictedPages(chapter);
    if (!mounted) return;

    // Evict old chapters' pages to free memory
    final snapshot = pages;
    for (final index in _preloadManager.evictOldChapters(chapter)) {
      final identity = snapshot[index].identity;
      _failedPages.remove(identity);
      _pageControllers.remove(identity)?.dispose();
    }

    // Prefetch pages in order for the new page window
    _prefetchPagesInOrder();
  }

  void _scheduleEvictionsAndPrefetch() {
    _evictionAndPrefetchDebounce?.cancel();
    _evictionAndPrefetchDebounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      _handleEvictionsAndPrefetch();
    });
  }

  /// Updates the active chapter when the user scrolls or swipes into a page
  /// belonging to a different chapter.
  ///
  /// This:
  /// - Detects if the newly visible page belongs to another chapter.
  /// - Rebuilds the reader controller for that chapter.
  /// - Updates the current chapter, chapter URL model, and bookmark state.
  ///
  /// Called by both page‑based and continuous scrolling listeners to keep
  /// chapter state in sync with the visible page.
  void _updateChapterIfNeeded(int actualIndex) {
    if (actualIndex < 0 ||
        actualIndex >= pages.length ||
        pages[actualIndex].isTransitionPage) {
      return;
    }
    final newChapter = pages[actualIndex].chapter!;
    if (_readerController.chapter.id == newChapter.id) return;

    if (!mounted) return;

    final previousController = _readerController;

    setState(() {
      _readerController = ref.read(
        readerControllerProvider(chapter: newChapter).notifier,
      );
      chapter = newChapter;

      final chapterUrlModel = pages[actualIndex].chapterUrlModel;
      if (chapterUrlModel != null) {
        _chapterUrlModel = chapterUrlModel;
      }

      _isBookmarked = _readerController.getChapterBookmarked();
    });

    // dispose() only closes the last controller, so this releases every chapter crossed during continuous scrolling.
    previousController.keepAliveLink?.close();
  }

  /// Updates the user-facing page index (e.g., "Page 5 of 32") and syncs
  /// progress to the reader controller + Riverpod state.
  ///
  /// This:
  /// - Converts the actual page index into the display index used in UI.
  /// - Updates the reader controller's internal page index.
  /// - Persists the current index via `currentIndexProvider`.
  ///
  /// Used by both PageView mode and continuous scrolling mode.
  (int?, int)? _displayProgress;

  void _updateDisplayIndex(int actualIndex) {
    final idx = pages[actualIndex].index;
    if (idx == null) return;
    final progress = (chapter.id, idx);
    if (_displayProgress != progress) {
      _displayProgress = progress;
      _currentPageDisplayIndex.value = idx;
      _updateHasCurrentError();
      _readerController.setPageIndex(idx, false, _chapterUrlModel.pageUrls);
      ref.read(currentIndexProvider(chapter).notifier).setCurrentIndex(idx);
    }
  }

  late final _pageOffset = ValueNotifier(
    _readerController.autoScrollValues().$2,
  );

  Future<void> _setReaderMode(
    ReaderMode value,
    WidgetRef ref, {
    int? forceIndex,
  }) async {
    final actualIndex = forceIndex ?? _getCurrentPagesActualIndex();
    final showOverlay = ref.read(showNavigationOverlayOnStartStateProvider);
    if (!value.isVerticalContinuous) {
      _autoScroll.value = false;
    } else if (_autoScrollPage.value) {
      onAutoScrollChanged();
      _autoScroll.value = true;
    }

    _failedPages.clear();
    _readerController.setReaderMode(value);

    // Cache the reader mode for safe access in dispose
    _cachedReaderMode = value;

    ref.read(_currentReaderMode.notifier).state = value;
    if (!mounted) return;
    setState(() {
      _isReverseHorizontal = value.isRTL;

      if (value == ReaderMode.vertical) {
        _scrollDirection = Axis.vertical;
      } else if (value.isHorizontalPaged) {
        _scrollDirection = Axis.horizontal;
      }

      if (showOverlay) {
        _showNavigationOverlay = true;
      }
    });
    // Wait for the next frame so the scroll view rebuilds
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    final isDoubleInNewMode =
        _effectivePageMode == PageMode.doublePage &&
        !value.isHorizontalContinuous;
    final int targetIndex = isDoubleInNewMode
        ? _actualToPageViewIndex(actualIndex)
        : actualIndex;
    _currentIndex = targetIndex;
    _visiblePageIdentity = pages[_pageViewToActualIndex(targetIndex)].identity;
    _currentPageViewIndex.value = targetIndex;
    _heldViewportAnchor = value.isContinuous && !_autoScroll.value
        ? ReaderViewportAnchor(_visiblePageIdentity!, 0)
        : null;

    if (value == ReaderMode.vertical || value.isHorizontalPaged) {
      if (_extendedController.hasClients) {
        _extendedController.jumpToPage(targetIndex);
      }
    } else {
      if (_listController.isAttached &&
          _continuousScrollController.hasClients) {
        _listController.jumpToItem(
          index: targetIndex,
          scrollController: _continuousScrollController,
          alignment: 0.0,
        );
        _correctViewportAnchor();
      }
    }
  }

  void _goBack(BuildContext context) {
    restoreSystemUI();
    Navigator.pop(context);
  }

  void _isViewFunction() {
    final fullScreenReader = ref.read(fullScreenReaderStateProvider);
    if (context.mounted) {
      setState(() {
        _isView = !_isView;
      });
    }
    if (fullScreenReader) {
      if (_isView) {
        restoreSystemUI();
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    }
  }

  /// Live inputs for [ReaderPageIndexMath], read via the current provider
  /// state. Not safe to call during dispose - use [_indexMathSync] there.
  ReaderPageIndexMath get _indexMath => ReaderPageIndexMath(
    isDoublePageActive: _isDoublePageActive,
    singleFirst: ref.read(doublePageSingleFirstPageStateProvider),
    pageCount: pages.length,
    pages: pages,
  );

  /// Same as [_indexMath] but sourced entirely from cached/settings-only
  /// state, safe to call during dispose (reading a provider there would hit
  /// a Riverpod assertion error).
  ReaderPageIndexMath get _indexMathSync => ReaderPageIndexMath(
    isDoublePageActive: _isDoublePageActiveSync,
    singleFirst: settingsRepository.current.doublePageSingleFirstPage ?? false,
    pageCount: pages.length,
    pages: pages,
  );

  /// [index] is the page within the current chapter, as held by
  /// [_currentPageDisplayIndex] and the bottom bar slider.
  String _currentIndexLabel(int index) => _indexMath.chapterPageLabel(
    index,
    chapter.id,
    _readerController.getCachedPageLength(_chapterUrlModel.pageUrls),
  );

  /// Where page [pageInChapter] of the current chapter sits in [pages], or
  /// -1 if it is not loaded.
  int _actualIndexOfChapterPage(int pageInChapter) => pages.indexWhere(
    (p) =>
        !p.isTransitionPage &&
        p.chapter?.id == chapter.id &&
        p.index == pageInChapter,
  );

  /// Effective [PageMode] accounting for automatic double-page orientation detection.
  PageMode get _effectivePageMode {
    final auto = ref.read(doublePageAutoStateProvider);
    if (auto && mounted) {
      final orientation =
          _lastOrientation ??
          (context.mounted ? MediaQuery.maybeOrientationOf(context) : null);
      if (orientation != null) {
        return orientation == Orientation.landscape
            ? PageMode.doublePage
            : PageMode.onePage;
      }
    }
    return _pageMode;
  }

  /// Safe version of [_effectivePageMode] for use during dispose.
  PageMode get _effectivePageModeSync {
    final auto = settingsRepository.current.doublePageAuto ?? false;
    if (auto) {
      final orientation =
          _lastOrientation ??
          (mounted && context.mounted
              ? MediaQuery.maybeOrientationOf(context)
              : null);
      if (orientation != null) {
        return orientation == Orientation.landscape
            ? PageMode.doublePage
            : PageMode.onePage;
      }
    }
    return _pageMode;
  }

  /// Whether double page mode is active (continuous or paged).
  /// Horizontal continuous mode does NOT use double page layout.
  /// Uses ref.read() so cannot be called during dispose.
  bool get _isDoublePageActive {
    final currentMode = ref.read(_currentReaderMode) ?? _cachedReaderMode;
    return _effectivePageMode == PageMode.doublePage &&
        !currentMode.isHorizontalContinuous;
  }

  /// Safe version of _isDoublePageActive that uses cached reader mode.
  /// Safe to call during dispose without Riverpod assertion errors.
  bool get _isDoublePageActiveSync =>
      _effectivePageModeSync == PageMode.doublePage &&
      !_cachedReaderMode.isHorizontalContinuous;

  /// Converts a page view index (from ExtendedPageController) to the actual
  /// index in the [pages] array for double page mode.
  int _pageViewToActualIndex(int pageViewIndex) =>
      _indexMath.pageViewToActualIndex(pageViewIndex);

  /// Safe version that uses cached reader mode for use in dispose.
  int _pageViewToActualIndexSync(int pageViewIndex) =>
      _indexMathSync.pageViewToActualIndex(pageViewIndex);

  /// Converts an actual [pages] array index to a page view index
  /// for double page mode.
  int _actualToPageViewIndex(int actualIndex) =>
      _indexMath.actualToPageViewIndex(actualIndex);

  /// Safe version of _actualToPageViewIndex that uses cached reader mode and repository settings.
  int _actualToPageViewIndexSync(int actualIndex) =>
      _indexMathSync.actualToPageViewIndex(actualIndex);

  /// Returns the actual index in the [pages] array for the currently viewed page.
  /// Unlike [_currentPageDisplayIndex.value] (which is local to the active chapter, e.g. 0..N),
  /// this index spans the full continuous [pages] array across preloaded chapters.
  int _getCurrentPagesActualIndex([PageMode? fromMode]) {
    if (pages.isEmpty) return 0;
    final currentMode = ref.read(_currentReaderMode) ?? _cachedReaderMode;
    final math = ReaderPageIndexMath(
      isDoublePageActive:
          (fromMode ?? _effectivePageMode) == PageMode.doublePage &&
          !currentMode.isHorizontalContinuous,
      singleFirst: ref.read(doublePageSingleFirstPageStateProvider),
      pageCount: pages.length,
      pages: pages,
    );
    final actual = pages.indexWhere((p) => p.identity == _visiblePageIdentity);
    // A width discovery or mode change may pair the anchor with an earlier
    // image. Translation, zoom and progress all start at that spread's first.
    return math
        .pageViewToActualIndex(
          actual >= 0
              ? math.actualToPageViewIndex(actual)
              : (_currentIndex ?? 0),
        )
        .clamp(0, pages.length - 1);
  }

  /// Total page count as seen by the page view controller.
  /// In double page mode, each PV page shows 2 actual pages (except PV 0 if singleFirst).
  int get _pageViewPageCount => _indexMath.pageViewPageCount;

  bool _isContinuousMode([ReaderMode? mode]) {
    final readerMode = mode ?? ref.read(_currentReaderMode);
    return readerMode!.isContinuous;
  }
}
