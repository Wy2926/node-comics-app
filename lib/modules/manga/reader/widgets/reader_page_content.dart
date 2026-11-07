import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/reader/controllers/reader_viewport_anchor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/image_view_paged.dart';
import 'package:mangayomi/modules/manga/reader/image_view_webtoon.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart'
    as ssiv;
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_page_index_math.dart';
import 'package:mangayomi/modules/manga/reader/widgets/double_page_view.dart';
import 'package:mangayomi/modules/manga/reader/widgets/image_actions_dialog.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_content_status.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_settings_labels.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// The reader's actual page content: the continuous (webtoon) list, or the
/// paged (single/double-page) PageView, depending on [readerMode] and
/// [pageMode]. Everything else in the reader (app bar, bottom bar, gesture
/// overlay, flash overlay...) is layered on top of this by the caller, which
/// also owns all the mutable state this widget only reads or reports back
/// through callbacks.
class ReaderPageContent extends ConsumerWidget {
  final List<UChapDataPreload> pages;
  final Chapter chapter;
  final ReaderMode readerMode;
  final PageMode pageMode;
  final BackgroundColor backgroundColor;
  final int pagePreloadAmount;

  /// The page currently shown by the paged PageView, for the single-page
  /// branch's `isVisible` check.
  final int currentPageViewIndex;

  final bool isReverseHorizontal;
  final bool isCurrentPageZoomed;

  final ReaderViewportAnchorController viewportAnchor;
  final ListController listController;
  final ScrollController continuousScrollController;
  final PageController extendedController;
  final Axis scrollDirection;

  /// Looks up (creating if needed) the single-page zoom controller for
  /// [page]. Owned by the caller so the zoom-state listener it attaches
  /// keeps seeing the same instances across rebuilds.
  final ssiv.SubsamplingScaleImageViewController Function(UChapDataPreload page)
  pageControllerFor;

  final void Function(UChapDataPreload page, bool failed) onFailedToLoadImage;
  final void Function(UChapDataPreload page, double width, double height)
  onWidePage;

  /// A single page's image finished loading wider than tall; the caller
  /// schedules a delayed rebuild once the layout has had a chance to settle.
  final void Function(UChapDataPreload page) onWideSinglePageLoaded;

  final void Function(String identity, bool zoomed) onDoublePageZoomChanged;
  final void Function(
    String identity,
    PhotoViewController controller,
    bool attached,
  )
  onDoublePageControllerChanged;
  final Future<void> Function(int index) onPageChanged;

  const ReaderPageContent({
    super.key,
    required this.pages,
    required this.chapter,
    required this.readerMode,
    required this.pageMode,
    required this.backgroundColor,
    required this.pagePreloadAmount,
    required this.currentPageViewIndex,
    required this.viewportAnchor,
    required this.isReverseHorizontal,
    required this.isCurrentPageZoomed,
    required this.listController,
    required this.continuousScrollController,
    required this.extendedController,
    required this.scrollDirection,
    required this.pageControllerFor,
    required this.onFailedToLoadImage,
    required this.onWidePage,
    required this.onWideSinglePageLoaded,
    required this.onDoublePageZoomChanged,
    required this.onDoublePageControllerChanged,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isHorizontalContinuous = readerMode.isHorizontalContinuous;

    if (readerMode.isContinuous) {
      return ImageViewWebtoon(
        pages: pages,
        viewportAnchor: viewportAnchor,
        listController: listController,
        scrollController: continuousScrollController,
        scrollDirection: isHorizontalContinuous
            ? Axis.horizontal
            : Axis.vertical,
        // Keep the *built* (decoded, in-memory) range small and constant;
        // pagePreloadAmount only drives the network prefetch in
        // _prefetchPagesInOrder. Tying this to pagePreloadAmount pinned up to
        // 20 screens of decoded pages at once (OOM on webtoons).
        minCacheExtent: isHorizontalContinuous
            ? (pagePreloadAmount.clamp(1, 3) * 1.5) * context.width(1)
            : (pagePreloadAmount.clamp(1, 3) * 1.5) * context.height(1),
        physics: const ClampingScrollPhysics(),
        onLongPressData: (data) => ImageActionsDialog.show(
          context: context,
          data: data,
          manga: chapter.manga.value!,
          chapterName: chapter.name!,
        ),
        onFailedToLoadImage: onFailedToLoadImage,
        backgroundColor: backgroundColor,
        isDoublePageMode:
            pageMode == PageMode.doublePage && !isHorizontalContinuous,
        isHorizontalContinuous: isHorizontalContinuous,
        readerMode: readerMode,
        webtoonSidePadding: ref.watch(webtoonSidePaddingStateProvider),
        showPageGaps: ref.watch(showPageGapsStateProvider),
        reverse: isReverseHorizontal,
        zoomOutDisabled: ref.watch(webtoonDisableZoomOutStateProvider),
        doubleTapZoomEnabled: ref.watch(
          webtoonDoubleTapZoomEnabledStateProvider,
        ),
        onImageLoaded: (page, width, height) {
          if (ref.read(splitWidePagesStateProvider) && width > height * 1.2) {
            onWidePage(page, width, height);
          }
          if (width > height) onWideSinglePageLoaded(page);
        },
      );
    }

    final doublePage =
        pageMode == PageMode.doublePage && !isHorizontalContinuous;
    final spreads = ReaderPageIndexMath(
      isDoublePageActive: doublePage,
      singleFirst: ref.watch(doublePageSingleFirstPageStateProvider),
      pageCount: pages.length,
      pages: pages,
    ).spreads;
    final indices = <Key, int>{
      for (var i = 0; i < spreads.length; i++)
        ValueKey(pages[spreads[i].firstIndex].identity): i,
    };

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        end:
            getBackgroundColor(backgroundColor) ??
            Theme.of(context).scaffoldBackgroundColor,
      ),
      duration: const Duration(milliseconds: 300),
      builder: (context, animColor, animChild) {
        return Material(
          color: animColor,
          shadowColor: animColor,
          child: animChild,
        );
      },
      child: doublePage
          ? PageView.builder(
              controller: extendedController,
              scrollDirection: scrollDirection,
              reverse: isReverseHorizontal,
              physics: isCurrentPageZoomed
                  ? const NeverScrollableScrollPhysics()
                  : const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                final spread = spreads[index];
                final index1 = spread.firstIndex;
                final index2 = spread.secondIndex;
                final identity = pages[index1].identity;
                final List<UChapDataPreload?> pageList = [
                  if (index1 < pages.length) pages[index1],
                  if (index2 != null && index2 < pages.length) pages[index2],
                ];
                return DoublePageView.paged(
                  key: ValueKey(identity),
                  pages: isReverseHorizontal
                      ? pageList.reversed.toList()
                      : pageList,
                  backgroundColor: backgroundColor,
                  scrollDirection: scrollDirection,
                  onZoomChanged: (zoomed) {
                    onDoublePageZoomChanged(identity, zoomed);
                  },
                  onControllerChanged: (controller, attached) {
                    onDoublePageControllerChanged(
                      identity,
                      controller,
                      attached,
                    );
                  },
                  onFailedToLoadImage: onFailedToLoadImage,
                  onImageLoaded: (pIdx, width, height) {
                    if (ref.read(splitWidePagesStateProvider) &&
                        width > height * 1.2) {
                      onWidePage(pIdx, width, height);
                    }
                  },
                  onWideSinglePageLoaded: onWideSinglePageLoaded,
                  onLongPressData: (datas) {
                    ImageActionsDialog.show(
                      context: context,
                      data: datas,
                      manga: chapter.manga.value!,
                      chapterName: chapter.name!,
                    );
                  },
                );
              },
              itemCount: spreads.length,
              findChildIndexCallback: (key) => indices[key],
              onPageChanged: onPageChanged,
            )
          : PageView.builder(
              controller: extendedController,
              scrollDirection: scrollDirection,
              reverse: isReverseHorizontal,
              physics: isCurrentPageZoomed
                  ? const NeverScrollableScrollPhysics()
                  : const ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final page = pages[index];
                return ReaderPagedItem(
                  key: ValueKey(page.identity),
                  page: page,
                  chapter: chapter,
                  pageController: extendedController,
                  controller: pageControllerFor(page),
                  isVisible: index == currentPageViewIndex,
                  backgroundColor: backgroundColor,
                  onFailedToLoadImage: onFailedToLoadImage,
                  onWidePage: onWidePage,
                  onWideSinglePageLoaded: onWideSinglePageLoaded,
                );
              },
              itemCount: pages.length,
              findChildIndexCallback: (key) => indices[key],
              onPageChanged: onPageChanged,
            ),
    );
  }
}

/// A single page in the (non-double-page) paged PageView: a transition page,
/// or a zoomable [ImageViewPaged] with its own loading/error/retry states.
class ReaderPagedItem extends ConsumerWidget {
  final UChapDataPreload page;
  final Chapter chapter;
  final PageController pageController;
  final ssiv.SubsamplingScaleImageViewController controller;
  final bool isVisible;
  final BackgroundColor backgroundColor;
  final void Function(UChapDataPreload page, bool failed) onFailedToLoadImage;
  final void Function(UChapDataPreload page, double width, double height)
  onWidePage;
  final void Function(UChapDataPreload page) onWideSinglePageLoaded;

  const ReaderPagedItem({
    super.key,
    required this.page,
    required this.chapter,
    required this.pageController,
    required this.controller,
    required this.isVisible,
    required this.backgroundColor,
    required this.onFailedToLoadImage,
    required this.onWidePage,
    required this.onWideSinglePageLoaded,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (page.isTransitionPage) {
      return ReaderChapterBoundary(data: page, paged: true);
    }

    return ImageViewPaged(
      data: page,
      pageController: pageController,
      controller: controller,
      isVisible: isVisible,
      onImageLoaded: (width, height) {
        if (ref.read(splitWidePagesStateProvider) && width > height * 1.2) {
          onWidePage(page, width.toDouble(), height.toDouble());
        }
        if (width > height) {
          onWideSinglePageLoaded(page);
        }
      },
      loadStateChanged: (state) {
        if (state.loadState == ssiv.LoadState.loading) {
          final ImageChunkEvent? loadingProgress = state.loadingProgress;
          final double? progress = loadingProgress?.expectedTotalBytes != null
              ? loadingProgress!.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
              : null;
          return Container(
            color:
                getBackgroundColor(backgroundColor) ??
                Theme.of(context).scaffoldBackgroundColor,
            height: context.height(0.8),
            child: Center(
              child: SingleChildScrollView(
                child: ReaderContentStatus(
                  message: context.l10n.reader_image_loading,
                  loading: true,
                  progress: progress,
                ),
              ),
            ),
          );
        }
        if (state.loadState == ssiv.LoadState.completed) {
          onFailedToLoadImage(page, false);
          return null; // Dessine l'image via SubsamplingScaleImageView
        }
        if (state.loadState == ssiv.LoadState.failed) {
          onFailedToLoadImage(page, true);
          final l10n = l10nLocalizations(context)!;
          return Container(
            color:
                getBackgroundColor(backgroundColor) ??
                Theme.of(context).scaffoldBackgroundColor,
            height: context.height(0.8),
            child: Center(
              child: SingleChildScrollView(
                child: ReaderContentStatus(
                  message: l10n.image_loading_error,
                  description: l10n.reader_image_failure_hint,
                  onRetry: () {
                    state.reLoadImage();
                    onFailedToLoadImage(page, false);
                  },
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
      onLongPressData: (datas) => ImageActionsDialog.show(
        context: context,
        data: datas,
        manga: chapter.manga.value!,
        chapterName: chapter.name!,
      ),
    );
  }
}
