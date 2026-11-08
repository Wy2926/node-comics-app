import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mangayomi/modules/manga/reader/image_view_vertical.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_content_status.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart';
import 'package:photo_view/photo_view.dart';

/// Two source pages in one zoomable, paged reading surface.
class DoublePageView extends StatefulWidget {
  /// The two pages to display side by side.
  final List<UChapDataPreload?> pages;

  /// Callback when an image is long-pressed.
  final Function(UChapDataPreload data)? onLongPressData;

  /// Background color setting.
  final Color backgroundColor;

  /// Callback for image load failure state.
  final void Function(UChapDataPreload page, bool failed)? onFailedToLoadImage;

  /// The scroll direction of the parent PageView (for gesture interception).
  final Axis scrollDirection;

  /// Callback when the zoom state changes.
  final Function(bool isZoomed)? onZoomChanged;

  /// Called with this view's PhotoViewController and true once it exists,
  /// then with false when the view is disposed.
  final void Function(PhotoViewController controller, bool attached)?
  onControllerChanged;

  /// Callback when an image finishes loading with its dimensions.
  final void Function(UChapDataPreload page, double width, double height)?
  onImageLoaded;

  /// Callback when a wide single page is loaded.
  final void Function(UChapDataPreload page)? onWideSinglePageLoaded;

  /// Creates a paged mode double page view.
  const DoublePageView.paged({
    super.key,
    required this.pages,
    required this.backgroundColor,
    this.onLongPressData,
    this.onFailedToLoadImage,
    required this.scrollDirection,
    this.onZoomChanged,
    this.onControllerChanged,
    this.onImageLoaded,
    this.onWideSinglePageLoaded,
  });

  @override
  State<DoublePageView> createState() => _DoublePageViewState();
}

class _DoublePageViewState extends State<DoublePageView>
    with TickerProviderStateMixin {
  // Controllers for paged mode zoom
  late AnimationController _scaleAnimationController;
  late Animation<double> _animation;
  late VoidCallback _animationListener;
  Alignment _scalePosition = Alignment.center;
  final PhotoViewController _photoViewController = PhotoViewController();
  final PhotoViewScaleStateController _photoViewScaleStateController =
      PhotoViewScaleStateController();
  StreamSubscription? _zoomSubscription;

  void _onScaleEnd(
    BuildContext context,
    ScaleEndDetails details,
    PhotoViewControllerValue controllerValue,
  ) {
    if (controllerValue.scale! < 1) {
      _photoViewScaleStateController.reset();
    }
  }

  double get pixelRatio => View.of(context).devicePixelRatio;
  Size get size => View.of(context).physicalSize / pixelRatio;

  Alignment _computeAlignmentByTapOffset(Offset offset) {
    return Alignment(
      (offset.dx - size.width / 2) / (size.width / 2),
      (offset.dy - size.height / 2) / (size.height / 2),
    );
  }

  @override
  void initState() {
    super.initState();
    {
      _scaleAnimationController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
      _animation = Tween(begin: 1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.ease, parent: _scaleAnimationController),
      );
      _animationListener = () {
        _photoViewController.scale = _animation.value;
      };
      _animation.addListener(_animationListener);

      _zoomSubscription = _photoViewController.outputStateStream.listen((
        value,
      ) {
        final isZoomed = value.scale! > 1.01;
        widget.onZoomChanged?.call(isZoomed);
      });

      widget.onControllerChanged?.call(_photoViewController, true);
    }
  }

  @override
  void dispose() {
    {
      widget.onControllerChanged?.call(_photoViewController, false);
      _animation.removeListener(_animationListener);
      _scaleAnimationController.dispose();
      _zoomSubscription?.cancel();
      _photoViewController.dispose();
      _photoViewScaleStateController.dispose();
    }
    super.dispose();
  }

  void _toggleScale(Offset tapPosition) {
    if (!mounted) return;

    _scaleAnimationController.duration = Duration(
      milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 200,
    );
    setState(() {
      if (_scaleAnimationController.isAnimating) return;

      if (_photoViewController.scale == 1.0) {
        _scalePosition = _computeAlignmentByTapOffset(tapPosition);

        if (_scaleAnimationController.isCompleted) {
          _scaleAnimationController.reset();
        }

        _scaleAnimationController.forward();
        return;
      }

      if (_photoViewController.scale == 2.0) {
        _scaleAnimationController.reverse();
        return;
      }

      _photoViewScaleStateController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final boundary = widget.pages.firstWhereOrNull(
      (page) => page?.isTransitionPage ?? false,
    );
    if (boundary != null) {
      return ReaderChapterBoundary(data: boundary, paged: true);
    }
    return _buildPagedMode();
  }

  Widget _buildPagedMode() {
    return PhotoViewGestureDetectorScope(
      axis: widget.scrollDirection,
      child: PhotoView.customChild(
        backgroundDecoration: BoxDecoration(color: widget.backgroundColor),
        controller: _photoViewController,
        scaleStateController: _photoViewScaleStateController,
        basePosition: _scalePosition,
        onScaleEnd: _onScaleEnd,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onDoubleTapDown: (details) => _toggleScale(details.globalPosition),
          onDoubleTap: () {},
          child: _buildPageRow(),
        ),
      ),
    );
  }

  Widget _buildPageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final page in widget.pages)
          if (page != null)
            Flexible(
              key: ValueKey('dp_page_${page.identity}'),
              child: _buildPageImage(page),
            ),
      ],
    );
  }

  Widget _buildPageImage(UChapDataPreload pageData) {
    final l10n = l10nLocalizations(context)!;
    final onLongPress = widget.onLongPressData ?? (_) {};

    return ImageViewVertical(
      data: pageData,
      failedToLoadImage: (val) {
        widget.onFailedToLoadImage?.call(pageData, val);
      },
      onLongPressData: onLongPress,
      isHorizontal: true,
      onImageLoaded: (width, height) {
        pageData.loadedWidth = width;
        pageData.loadedHeight = height;
        widget.onImageLoaded?.call(pageData, width, height);
        if (width > height) {
          widget.onWideSinglePageLoaded?.call(pageData);
        }
      },
      loadStateChanged: (state) {
        switch (state.loadState) {
          case LoadState.loading:
            return _buildLoadingState(state);
          case LoadState.completed:
            widget.onFailedToLoadImage?.call(pageData, false);
            return null;
          case LoadState.failed:
            return _buildFailedState(pageData, state, l10n);
        }
      },
    );
  }

  Widget _buildLoadingState(SubsamplingImageState state) {
    final loadingProgress = state.loadingProgress;
    final progress = loadingProgress?.expectedTotalBytes != null
        ? loadingProgress!.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
        : null;

    return Container(
      color: widget.backgroundColor,
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

  Widget _buildFailedState(
    UChapDataPreload pageData,
    SubsamplingImageState state,
    dynamic l10n,
  ) {
    widget.onFailedToLoadImage?.call(pageData, true);

    return Container(
      color: widget.backgroundColor,
      height: context.height(0.8),
      child: Center(
        child: SingleChildScrollView(
          child: ReaderContentStatus(
            message: l10n.image_loading_error,
            description: l10n.reader_image_failure_hint,
            onRetry: () {
              state.reLoadImage();
              widget.onFailedToLoadImage?.call(pageData, false);
            },
          ),
        ),
      ),
    );
  }
}
