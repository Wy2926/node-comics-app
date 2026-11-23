import 'dart:async';
import 'dart:math';

import 'package:mangayomi/modules/manga/reader/controllers/reader_viewport_anchor.dart';

import 'package:mangayomi/modules/manga/reader/reader_translation.dart';
import 'package:mangayomi/modules/manga/reader/managers/reader_image_prefetcher.dart';

import 'settings/comic_reader_preferences.dart';
import 'settings/comic_reader_preferences_provider.dart';
import 'settings/comic_reader_scope.dart';
import 'settings/comic_page_projection.dart';
import 'settings/comic_reader_settings.dart';

import 'package:photo_view/photo_view.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart'
    as ssiv;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_gestures.dart';
import 'package:mangayomi/modules/manga/reader/services/page_navigation_service.dart';
import 'package:mangayomi/modules/manga/reader/managers/chapter_preload_manager.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_app_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_bottom_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_overlays.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_page_content.dart';
import 'package:mangayomi/modules/manga/reader/widgets/auto_scroll_button.dart';
import 'package:mangayomi/modules/manga/reader/widgets/page_indicator.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

import 'reader_page_image.dart';

import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/services/chapter_cache.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/utils/double_page_zoom_pan.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_page_index_math.dart';

import 'utils/reader_page_window.dart';

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

Future<void> _openChapterWebView(
  BuildContext context,
  WidgetRef ref,
  Chapter chapter,
) async {
  try {
    final data = await buildWebViewData(
      chapter,
      ref.read(androidProxyServerStateProvider),
    );
    if (context.mounted && data != null) {
      await context.push('/mangawebview', extra: data);
    }
  } catch (error) {
    if (context.mounted) {
      showNodeLaneNotice(error.toString(), kind: NodeLaneNoticeKind.error);
    }
  }
}

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
          onOpenWebView: chapter != null && !(manga?.isLocalArchive ?? false)
              ? () => _openChapterWebView(context, ref, chapter)
              : null,
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
  bool get canAutoScroll => _readerMode.isContinuous && !_restoringPosition;

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

    _imagePrefetcher.dispose();
    _hasCurrentPageImageError.dispose();
    _forwardPages.dispose();
    _panAnimator.dispose();
    disposeAutoScroll();
    _autoScroll.removeListener(onAutoScrollChanged);
    _autoScroll.value = false;
    _autoScroll.dispose();
    _pageOffset.dispose();
    _currentPageDisplayIndex.dispose();
    _keyboardFocusNode.dispose();
    _continuousScrollController.removeListener(_scheduleReadProgressListener);
    _listController.removeListener(_scheduleReadProgressListener);
    _continuousScrollController.dispose();
    _listController.dispose();
    _viewportAnchor.dispose();

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
    _saveCurrentPage(_pageViewToActualIndex(_currentIndex ?? 0));
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
    final keepOn = _preferences.habits.keepAwake;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _autoScroll.value = false;
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
      _resourceRange = null;
      _syncPageWindow();
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
      _readerController.setPageIndex(
        index,
        true,
        _chapterUrlModel.pageUrls,
        _readerMode.isContinuous,
      );
    }
  }

  final _autoScroll = ValueNotifier(false);
  int get _bookId => widget.chapter.manga.value!.id!;
  late ComicReaderPreferences _preferences = ref.read(
    comicReaderPreferencesProvider,
  );
  late ComicReadingProfile _profile = _preferences.resolve(_bookId);
  double _viewportWidth = 0;
  late List<UChapDataPreload> _displayPages = _preloadManager.pages;
  void _projectPages() {
    _displayPages = projectComicPages(
      _preloadManager.pages,
      _profile,
      _viewportWidth,
    );
  }

  double _requestedViewportWidth = 0;
  bool _applyingLayout = false;

  void _applyPreferences(ComicReaderPreferences next) {
    final keepAwakeChanged =
        _preferences.habits.keepAwake != next.habits.keepAwake;
    _preferences = next;
    final requested = next.resolve(_bookId);
    // Session controls and paint-only settings must not wait for scrolling,
    // image loading, foreground restoration, or a sheet to be reopened.
    _pageOffset.value = next.scrollSpeed / 10;
    if (requested.mode != ComicReadingMode.scroll) _autoScroll.value = false;
    if (keepAwakeChanged) {
      WakelockPlus.toggle(enable: next.habits.keepAwake && _readerInForeground);
    }
    setState(() => _profile = _profile.withEffects(requested));
    unawaited(_applyRequestedLayout());
  }

  bool get _needsLayout =>
      _viewportWidth != _requestedViewportWidth ||
      _profile.geometryKey(_viewportWidth) !=
          _preferences.resolve(_bookId).geometryKey(_requestedViewportWidth);

  Future<void> _applyRequestedLayout() async {
    if (_applyingLayout || !_needsLayout) return;
    _applyingLayout = true;
    try {
      do {
        // Read the latest request at commit time, not a settings snapshot
        // captured before another layout/scroll operation finished.
        await _commitWithAnchor(() {
          final next = _preferences.resolve(_bookId);
          final width = _requestedViewportWidth;
          final regroup =
              _profile.readerMode != next.readerMode ||
              _profile.doublePage(_viewportWidth) != next.doublePage(width) ||
              _profile.splitPages(_viewportWidth) != next.splitPages(width);
          _profile = next;
          _viewportWidth = width;
          _projectPages();
          if (regroup) _isCurrentPageZoomed = false;
        });
      } while (!_disposed.isCompleted && _needsLayout);
    } finally {
      _applyingLayout = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.sizeOf(context).width;
    if (width == _requestedViewportWidth) return;
    _requestedViewportWidth = width;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_applyRequestedLayout());
    });
  }

  late GetChapterPagesModel _chapterUrlModel = widget.chapterUrlModel;
  late final _preloadManager = ChapterPreloadManager(
    widget.chapterUrlModel.uChapDataPreload,
  );
  List<UChapDataPreload> get pages => _displayPages;

  late Chapter chapter = widget.chapter;

  final _failedPages = <String>{};
  final _hasCurrentPageImageError = ValueNotifier<bool>(false);
  final _forwardPages = ValueNotifier<List<UChapDataPreload>>(const []);
  (List<UChapDataPreload>, int, int, bool, int?)? _resourceRange;

  void _updateHasCurrentError() {
    final actual = _getCurrentPagesActualIndex();
    final spread = _isDoublePageActive && pages.isNotEmpty
        ? _indexMath.spreads[_actualToPageViewIndex(actual)]
        : null;
    final indices = spread == null
        ? <int?>[actual]
        : <int?>[spread.firstIndex, spread.secondIndex];
    final hasError =
        !_readerMode.isContinuous &&
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

  ReaderMode get _readerMode => _profile.readerMode;
  PageMode get _pageMode => _profile.doublePage(_viewportWidth)
      ? PageMode.doublePage
      : PageMode.onePage;

  /// The saved position within the chapter. It can point past the end when
  /// the source now serves fewer pages than when the chapter was last read.
  late final int _savedPageIndex = min(
    _readerController.getPageIndex(),
    max(0, widget.chapterUrlModel.uChapDataPreload.length - 1),
  );

  late int? _currentIndex = () {
    final saved = _savedPageIndex;
    if (_isDoublePageActive) {
      return _actualToPageViewIndex(saved);
    }
    return saved;
  }();
  late final ValueNotifier<int> _currentPageDisplayIndex = ValueNotifier(
    _savedPageIndex,
  );

  late final ListController _listController = ListController();
  final _continuousScrollController = ReaderScrollController();
  bool _readProgressScheduled = false;
  final _viewportAnchor = ReaderViewportAnchorController();
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
      final scroll = _readerMode.isContinuous
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

  Future<void> _restoreViewportAnchor(ReaderViewportAnchor anchor, int index) =>
      _viewportAnchor.restore(
        anchor,
        index: index,
        isCurrent: () => !_disposed.isCompleted,
      );

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
        _scheduleReadProgressListener();
      }
    }
  }

  /// Prepend, split, or regroup spreads after a width discovery. Capture at
  /// commit time because the reader can move while source I/O is pending.
  Future<void> _commitWithAnchor([VoidCallback? commit]) => _withIdleViewport(
    () async {
      final before = pages;
      if (before.isEmpty) {
        commit?.call();
        setState(() {});
        return;
      }
      var actual = _getCurrentPagesActualIndex();
      if (before[actual].isTransitionPage) {
        actual += before[actual].boundaryDirection == ChapterDirection.previous
            ? 1
            : -1;
      }
      final anchor = _viewportAnchor.capture(_continuousScrollController);
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
      _updateChapterIfNeeded(currentActual);
      _updateDisplayIndex(currentActual);
      setState(() {});
      if (_readerMode.isContinuous) {
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
        final held = ReaderViewportAnchor(
          after[currentActual].identity,
          anchor?.leading ?? 0,
        );
        await _restoreViewportAnchor(held, index);
      } else {
        await WidgetsBinding.instance.endOfFrame;
        if (_disposed.isCompleted) return;
        navigationService.jumpToPage(index: index, readerMode: _readerMode);
        await WidgetsBinding.instance.endOfFrame;
      }
      if (!_disposed.isCompleted) {
        _syncPageWindow();
      }
    },
  );

  void _scheduleReadProgressListener() {
    if (_readProgressScheduled) return;
    _readProgressScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _readProgressScheduled = false;
      if (!mounted) return;
      _readProgressListener();
    });
  }

  final StreamController<double> _rebuildDetail =
      StreamController<double>.broadcast();
  @override
  void initState() {
    super.initState();
    _readingStopwatch.start();
    ref.listenManual(
      comicReaderPreferencesProvider,
      (_, next) => _applyPreferences(next),
    );

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
    _initWakelock();
  }

  void _initWakelock() {
    final keepOn = _preferences.habits.keepAwake;
    if (keepOn) {
      WakelockPlus.enable();
    }
  }

  bool _readerInForeground = true;
  late final _imagePrefetcher = ReaderImagePrefetcher(
    load: (page) => page.retainReaderFile(
      ProviderScope.containerOf(context, listen: false),
    ),
  );

  late bool _isBookmarked = _readerController.getChapterBookmarked();

  bool _isView = false;
  final _keyboardFocusNode = FocusNode();
  final Map<String, ssiv.SubsamplingScaleImageViewController> _pageControllers =
      {};

  bool _isCurrentPageZoomed = false;
  final Map<String, PhotoViewController> _doublePageControllers = {};
  late final _panAnimator = DoublePagePanAnimator(this);
  static const _zoomNav = DoublePageZoomNavigation();

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

  late final _extendedController = PageController(initialPage: _currentIndex!);

  Axis get _scrollDirection =>
      _readerMode == ReaderMode.vertical ? Axis.vertical : Axis.horizontal;
  bool get _isReverseHorizontal => _readerMode.isRTL;

  Color _backgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9);

  void _setFullScreen() async {
    if (isDesktop) setFullScreen(value: !await windowManager.isFullScreen());
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
    final backgroundColor = _preferences.habits.canvas.color(context);
    final readerMode = _readerMode;
    const scrollHideThreshold = 13.0;
    final effectivePageMode = _pageMode;

    return ComicReaderScope(
      profile: _profile,
      habits: _preferences.habits,
      child:
          ReaderKeyboardHandler(
            onPreviousPage: () => _handlePageNavigation(forward: false),
            onNextPage: () => _handlePageNavigation(forward: true),
            onEscape: () => _goBack(context),
            onFullScreen: () => _setFullScreen(),
            onNextChapter: () => _goToChapter(true),
            onPreviousChapter: () => _goToChapter(false),
          ).wrapWithKeyboardListener(
            isReverseHorizontal: _isReverseHorizontal,
            focusNode: _keyboardFocusNode,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification) {
                  if (notification.dragDetails != null) {
                    isUserDragging = true;
                    _autoScroll.value = false;
                    _viewportAnchor.cancelRestore();
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
                  top: false,
                  bottom: false,
                  child: ReaderTranslationHost(
                    window: _forwardPages,
                    child: Stack(
                      children: [
                        ReaderPageContent(
                          pages: pages,
                          chapter: widget.chapter,
                          readerMode: readerMode,
                          pageMode: effectivePageMode,
                          backgroundColor: backgroundColor,
                          currentPageViewIndex: _currentIndex!,
                          viewportAnchor: _viewportAnchor,
                          isReverseHorizontal: _isReverseHorizontal,
                          isCurrentPageZoomed: _isCurrentPageZoomed,
                          listController: _listController,
                          continuousScrollController:
                              _continuousScrollController,
                          extendedController: _extendedController,
                          scrollDirection: _scrollDirection,
                          pageControllerFor: (page) =>
                              _pageControllers.putIfAbsent(
                                page.identity,
                                () => ssiv.SubsamplingScaleImageViewController()
                                  ..addListener(
                                    () => _updateZoomState(page.identity),
                                  ),
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
                              onPreviousPage: () =>
                                  _handlePageNavigation(forward: false),
                              onNextPage: () =>
                                  _handlePageNavigation(forward: true),
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
                              (chapter.manga.value!.isLocalArchive ?? false) ==
                                  false
                              ? () => _openChapterWebView(context, ref, chapter)
                              : null,
                          onRefreshPressed:
                              (chapter.manga.value!.isLocalArchive ?? false) ==
                                  false
                              ? () async {
                                  // Drop the cached page list first: rebuilding the
                                  // reader reads it, and a list left in place would be
                                  // reused as-is.
                                  await ChapterCache().remove(chapter);
                                  ref.invalidate(
                                    getChapterPagesProvider(chapter: chapter),
                                  );
                                  if (chapter.id != null) {
                                    ref.invalidate(
                                      mangaReaderProvider(chapter.id!),
                                    );
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
                          hasPreviousChapter:
                              _readerController.hasPreviousChapter,
                          hasNextChapter: _readerController.hasNextChapter,
                          onPreviousChapter: () => _goToChapter(false),
                          onNextChapter: () => _goToChapter(true),
                          onChaptersOpened: () => _autoScroll.value = false,
                          onChaptersClosed: () {
                            if (!mounted) return;
                            final bookmarked = chapterRepository
                                .findByIdSync(chapter.id!)
                                ?.isBookmarked;
                            if (bookmarked != null &&
                                bookmarked != _isBookmarked) {
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
                                pages[_pageViewToActualIndex(jumpIndex)]
                                    .identity;
                            _readingBackward = jumpIndex < (_currentIndex ?? 0);
                            _backwardScrollPending = _readingBackward;
                            _currentIndex = jumpIndex;
                            if (_readerMode.isContinuous) {
                              unawaited(
                                _restoreViewportAnchor(
                                  ReaderViewportAnchor(
                                    _visiblePageIdentity!,
                                    0,
                                  ),
                                  jumpIndex,
                                ),
                              );
                            } else {
                              navigationService.jumpToPage(
                                index: jumpIndex,
                                readerMode: _readerMode,
                              );
                            }
                            _syncPageWindow(
                              first: _pageViewToActualIndex(jumpIndex),
                            );
                          },
                          onSettingsPressed: (context) =>
                              showComicReaderSettings(
                                context: context,
                                bookId: _bookId,
                                autoScroll: _autoScroll,
                              ),
                          currentPageListenable: _currentPageDisplayIndex,
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
          ),
    );
  }

  void _splitWidePage(UChapDataPreload page, double width, double height) {
    if (!mounted ||
        page.srcRect != null ||
        !_profile.splitPages(_viewportWidth) ||
        _pendingSplits.contains(page.identity)) {
      return;
    }
    _pendingSplits.add(page.identity);
    unawaited(
      _commitWithAnchor(() {
        final source = _preloadManager.pages.firstWhere(
          (p) => p.identity == page.identity,
        );
        source.loadedWidth = width;
        source.loadedHeight = height;
        _projectPages();
      }).whenComplete(() => _pendingSplits.remove(page.identity)),
    );
  }

  void _handlePageNavigation({required bool forward}) {
    _viewportAnchor.cancelRestore();
    _readingBackward = !forward;
    _backwardScrollPending = !forward;
    final readerMode = _readerMode;
    final animatePageTransitions = !MediaQuery.disableAnimationsOf(context);
    if (_currentIndex == null) return;

    final spread = _doublePageControllers[_currentIdentity];
    if (_isCurrentPageZoomed && spread != null) {
      final width = MediaQuery.sizeOf(context).width;
      final panTarget = forward
          ? _zoomNav.nextPanTarget
          : _zoomNav.previousPanTarget;
      final target = panTarget(
        dx: spread.position.dx,
        maxX: width * ((spread.scale ?? 1) - 1) / 2,
        step: width * .4,
        isReverseHorizontal: _isReverseHorizontal,
      );
      if (target != null) {
        _panAnimator.animateTo(
          controllerLookup: () => _doublePageControllers[_currentIdentity],
          targetDx: target,
        );
        return;
      }
    }

    if (readerMode == ReaderMode.webtoon) {
      final dimension = MediaQuery.sizeOf(context).height;
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

    final actualIdx = _pageViewToActualIndex(_currentIndex!);
    final controller = _pageControllers[pages[actualIdx].identity];
    if (readerMode != ReaderMode.vertical &&
        controller != null &&
        controller.isReady) {
      final toLeft = forward == _isReverseHorizontal;
      if (toLeft ? controller.canPanLeft() : controller.canPanRight()) {
        toLeft ? controller.panLeft() : controller.panRight();
        return;
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
        !_readerMode.isContinuous ||
        _restoringPosition ||
        !_listController.isAttached) {
      return;
    }
    final range = _listController.visibleRange;
    if (range == null) return;
    final (first, last) = range;
    final visible = _viewportAnchor.capture(_continuousScrollController);
    var actual = visible == null
        ? -1
        : pages.indexWhere((p) => p.identity == visible.identity);
    // The finished banner can be visible below several short final images.
    if (last == pages.length - 1 &&
        pages.last.chapterState == ChapterLoadState.exhausted &&
        pages.last.boundaryDirection == ChapterDirection.next) {
      actual = pages.length - 2;
    }
    final newIndex = actual >= 0 ? _actualToPageViewIndex(actual) : first;
    final bool pageChanged = _currentIndex != newIndex;
    if (pageChanged) _readingBackward = newIndex < (_currentIndex ?? newIndex);
    _currentIndex = newIndex;
    final pagesLength = pages.length;
    if (_currentIndex! >= 0 && _currentIndex! < pagesLength) {
      final actualIndex = _pageViewToActualIndex(_currentIndex!);
      _visiblePageIdentity = pages[actualIndex].identity;
      _updateChapterIfNeeded(actualIndex);

      _syncPageWindow(first: first, last: last);
      // Layout/prepend notifications alone never recursively fetch earlier
      // chapters. Only a backward reading action re-arms the leading edge.
      if (_backwardScrollPending && actualIndex <= 2) {
        _backwardScrollPending = false;
        _triggerChapterPreload(ChapterDirection.previous);
      }

      _updateDisplayIndex(actualIndex);
      if (pageChanged) _updateHasCurrentError();
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
    final readerMode = _readerMode;
    _currentPageDisplayIndex.value = _savedPageIndex;

    _preloadManager.commitPrepend = (commit) => _commitWithAnchor(() {
      commit();
      _projectPages();
    });
    _preloadManager.onPagesUpdated = () {
      if (!mounted) return;
      _projectPages();
      setState(() {});
      if (_restoringPosition) return;
      // A waiting slot can become the next chapter's first image without
      // scrolling. Reconcile progress after the new list has been laid out.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _restoringPosition) return;
        final mode = _readerMode;
        if (mode.isContinuous) {
          _readProgressListener();
        } else {
          _syncPageWindow();
          if (_extendedController.hasClients &&
              _currentIndex != null &&
              _currentIndex! < _pageViewPageCount) {
            final actual = _pageViewToActualIndex(_currentIndex!);
            if (pages[actual].chapter?.id != chapter.id) {
              _onPageChanged(_currentIndex!);
            }
          }
        }
      });
    };

    _visiblePageIdentity = pages[_getCurrentPagesActualIndex()].identity;
    if (readerMode.isContinuous) {
      unawaited(
        _restoreViewportAnchor(
          ReaderViewportAnchor(_visiblePageIdentity!, 0),
          _currentIndex!,
        ),
      );
    }

    // Kick off ordered prefetch before the first frame so lower-indexed pages
    // win the HTTP race against the simultaneous widget-driven loads.
    _syncPageWindow();

    // Start the next chapter in the background, keeping a visible boundary.
    _triggerChapterPreload(ChapterDirection.next);

    _readerController.setHistoryUpdate();
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    if (isDesktop) {
      setFullScreen(value: true);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }
    if (_getCurrentPagesActualIndex() <= 2) {
      _triggerChapterPreload(ChapterDirection.previous);
    }

    if (_readerController.getPageLength(_chapterUrlModel.pageUrls) == 1 &&
        (_readerMode.isHorizontalPaged || _readerMode == ReaderMode.vertical)) {
      _onPageChanged(0);
    }
  }

  void _syncPageWindow({int? first, int? last}) {
    if (!mounted || !_readerInForeground || pages.isEmpty) return;
    if (first == null &&
        _readerMode.isContinuous &&
        _listController.isAttached) {
      final range = _listController.visibleRange;
      first = range?.$1;
      last = range?.$2;
    }
    first ??= _pageViewToActualIndex(_currentIndex ?? 0);
    last ??= _isDoublePageActive
        ? _indexMath.spreads[_actualToPageViewIndex(first)].secondIndex ?? first
        : first;
    final range = (pages, first, last, _readingBackward, chapter.id);
    if (_resourceRange == range) return;
    _resourceRange = range;
    final window = ReaderPageWindow(
      pages,
      first,
      last,
      backward: _readingBackward,
    );
    final evicted = _preloadManager.evictOldChapters(
      chapter,
      inWindow: window.prefetch,
    );
    if (evicted.isNotEmpty) {
      final sources = _preloadManager.pages;
      final gone = {for (final i in evicted) sources[i].chapter?.id};
      for (final page in pages.where((p) => gone.contains(p.chapter?.id))) {
        _failedPages.remove(page.identity);
        _pageControllers.remove(page.identity)?.dispose();
      }
    }
    _imagePrefetcher.update(window.prefetch);
    if (!listEquals(_forwardPages.value, window.forward)) {
      _forwardPages.value = window.forward;
    }
    if (window.needsNextChapter) _triggerChapterPreload(ChapterDirection.next);
  }

  void _onPageChanged(int index) {
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

    _updateDisplayIndex(actualIndex);

    _syncPageWindow(first: actualIndex);

    if (pageChanged && _readingBackward && actualIndex <= 2) {
      _triggerChapterPreload(ChapterDirection.previous);
    }
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
      _readerController.setPageIndex(
        idx,
        false,
        _chapterUrlModel.pageUrls,
        _readerMode.isContinuous,
      );
      ref.read(currentIndexProvider(chapter).notifier).setCurrentIndex(idx);
    }
  }

  late final _pageOffset = ValueNotifier(_preferences.scrollSpeed / 10);

  void _goBack(BuildContext context) {
    restoreSystemUI();
    Navigator.pop(context);
  }

  void _isViewFunction() {
    if (context.mounted) {
      setState(() {
        _isView = !_isView;
      });
    }
    if (_isView) {
      restoreSystemUI();
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }
  }

  /// Page geometry uses the applied profile, including during disposal.
  ReaderPageIndexMath get _indexMath => ReaderPageIndexMath(
    isDoublePageActive: _isDoublePageActive,
    singleFirst: _profile.singleCover,
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

  bool get _isDoublePageActive => _pageMode == PageMode.doublePage;

  int _pageViewToActualIndex(int pageViewIndex) =>
      _indexMath.pageViewToActualIndex(pageViewIndex);

  int _actualToPageViewIndex(int actualIndex) =>
      _indexMath.actualToPageViewIndex(actualIndex);

  /// Returns the actual index in the [pages] array for the currently viewed page.
  /// Unlike [_currentPageDisplayIndex.value] (which is local to the active chapter, e.g. 0..N),
  /// this index spans the full continuous [pages] array across preloaded chapters.
  int _getCurrentPagesActualIndex() {
    if (pages.isEmpty) return 0;
    final math = _indexMath;
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
}
