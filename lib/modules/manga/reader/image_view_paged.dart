import 'widgets/reader_animated_image.dart';
import 'reader_image_format.dart';

import 'package:mangayomi/modules/manga/reader/reader_translation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings/comic_reader_scope.dart';
import 'settings/comic_reader_preferences.dart';

import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart'
    as ssiv;
import 'package:mangayomi/utils/extensions/others.dart';

class ImageViewPaged extends ConsumerStatefulWidget {
  final UChapDataPreload data;
  final Function(UChapDataPreload data) onLongPressData;
  final Widget? Function(ssiv.SubsamplingImageState state) loadStateChanged;
  final bool zoomEnabled;
  final bool panEnabled;
  final void Function(int width, int height)? onImageLoaded;
  final PageController? pageController;
  final ssiv.SubsamplingScaleImageViewController? controller;
  final bool isVisible;
  final ValueChanged<bool>? onFailure;

  const ImageViewPaged({
    super.key,
    required this.data,
    required this.onLongPressData,
    required this.loadStateChanged,
    this.zoomEnabled = true,
    this.panEnabled = true,
    this.onImageLoaded,
    this.pageController,
    this.controller,
    this.isVisible = true,
    this.onFailure,
  });

  @override
  ConsumerState<ImageViewPaged> createState() => _ImageViewPagedState();
}

class _ImageViewPagedState extends ConsumerState<ImageViewPaged> {
  String? _resolvedFilePath;
  bool _isAnimated = false;
  String? _displayPath;
  (double, Offset)? _restoreView;

  @override
  void initState() {
    super.initState();
    _resolvedFilePath = widget.data.resolvedFilePath;
    _resolveFilePath();
    _checkIfAnimated();
  }

  @override
  void didUpdateWidget(covariant ImageViewPaged oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool dataChanged = widget.data != oldWidget.data;
    final bool pathResolved = _resolvedFilePath != widget.data.resolvedFilePath;
    if (dataChanged || pathResolved) {
      _resolvedFilePath = widget.data.resolvedFilePath;
      _resolveFilePath();
      _checkIfAnimated();
    }
  }

  Future<void> _checkIfAnimated() async {
    final data = widget.data;
    final isAnimated = await isReaderGif(data);
    if (mounted && identical(data, widget.data) && _isAnimated != isAnimated) {
      setState(() {
        _isAnimated = isAnimated;
      });
    }
  }

  Future<void> _resolveFilePath() async {
    if (widget.data.resolvedFilePath != null) {
      if (mounted) {
        setState(() {
          _resolvedFilePath = widget.data.resolvedFilePath;
        });
      }
      return;
    }
    final data = widget.data;
    final path = await data.getLocalFilePath;
    if (path != null && mounted && identical(data, widget.data)) {
      data.resolvedFilePath = path;
      if (mounted) {
        setState(() {
          _resolvedFilePath = path;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ComicReaderScope.of(context).profile;
    final display = ReaderTranslationHost.display(context, widget.data);
    final translated = !identical(display, widget.data);
    final displayPath = translated
        ? display.resolvedFilePath
        : _resolvedFilePath;
    if (_displayPath != displayPath && widget.controller?.isReady == true) {
      final control = widget.controller!;
      final center = control.center;
      if (center != null && control.sWidth > 0 && control.sHeight > 0) {
        _restoreView = (
          control.scale / control.minScale,
          Offset(center.dx / control.sWidth, center.dy / control.sHeight),
        );
      }
    }
    _displayPath = displayPath;
    final image = display.getImageProvider(ref, true);
    final cropBorders = profile.crop;
    final rotation =
        profile.widePage == ComicWidePage.rotate &&
            widget.data.loadedWidth != null &&
            widget.data.loadedHeight != null &&
            widget.data.loadedWidth! > widget.data.loadedHeight!
        ? 90
        : 0;
    final effectiveFit = profile.boxFit;

    if (_resolvedFilePath != widget.data.resolvedFilePath &&
        widget.data.resolvedFilePath != null) {
      _resolvedFilePath = widget.data.resolvedFilePath;
    }

    final bool isAnimated = !translated && _isAnimated;

    final ssivScaleType = switch (profile.fit) {
      ComicPageFit.contain => ssiv.ScaleType.centerInside,
      ComicPageFit.width => ssiv.ScaleType.fitWidth,
      ComicPageFit.height => ssiv.ScaleType.fitHeight,
    };

    Widget content;
    if (isAnimated) {
      content = ReaderAnimatedImage(
        image: image,
        fit: effectiveFit,
        cropBorders: cropBorders,
        onFailure: widget.onFailure,
        rightHalf: display.srcRect == null ? null : display.srcRect!.left > 0,
        onImageLoaded: (width, height) {
          widget.data.loadedWidth = width.toDouble();
          widget.data.loadedHeight = height.toDouble();
          widget.onImageLoaded?.call(width, height);
        },
      );
    } else {
      content = ssiv.SubsamplingScaleImageView(
        image: image,
        resolvedFilePath: displayPath,
        preloadData: display,
        minimumScaleType: ssivScaleType,
        filterQuality: FilterQuality.medium,
        zoomEnabled: widget.zoomEnabled,
        panEnabled: widget.panEnabled,
        cropBorders: cropBorders,
        normalizedSrcRect: display.srcRect == null
            ? null
            : Rect.fromLTWH(display.srcRect!.left == 0 ? 0 : .5, 0, .5, 1),
        onImageLoaded: widget.onImageLoaded,
        loadStateChanged: widget.loadStateChanged,
        pageController: widget.pageController,
        rotation: rotation,
        controller: widget.controller,
        isVisible: widget.isVisible,
        doubleTapZoomDuration: Duration(
          milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 200,
        ),
        onReady: () {
          final saved = _restoreView, control = widget.controller;
          _restoreView = null;
          if (saved != null && control != null) {
            control.setScaleAndCenter(
              saved.$1 * control.minScale,
              Offset(
                saved.$2.dx * control.sWidth,
                saved.$2.dy * control.sHeight,
              ),
            );
          }
        },
      );
    }

    if (isAnimated && rotation != 0) {
      content = RotatedBox(quarterTurns: 1, child: content);
    }

    return ReaderTranslationHost.withStatus(
      context,
      widget.data,
      imageController: isAnimated ? null : widget.controller,
      child: applyReaderColorFilter(
        GestureDetector(
          onLongPress: () => widget.onLongPressData.call(widget.data),
          child: content,
        ),
        profile,
      ),
    );
  }
}
