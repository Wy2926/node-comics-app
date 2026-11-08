import 'settings/comic_reader_scope.dart';
import 'reader_image_format.dart';
import 'widgets/reader_animated_image.dart';

import 'package:mangayomi/utils/extensions/others.dart';

import 'settings/comic_reader_preferences.dart';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/reader/reader_translation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/src/min_subsampling_image_view.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart';

class ImageViewVertical extends ConsumerStatefulWidget {
  final UChapDataPreload data;
  final Function(UChapDataPreload data) onLongPressData;
  final bool isHorizontal;
  final Function(bool) failedToLoadImage;
  final Widget? Function(SubsamplingImageState)? loadStateChanged;
  final int rotation;
  final Function(double width, double height)? onImageLoaded;

  const ImageViewVertical({
    super.key,
    required this.data,
    required this.onLongPressData,
    required this.failedToLoadImage,
    required this.isHorizontal,
    this.loadStateChanged,
    this.rotation = 0,
    this.onImageLoaded,
  });

  @override
  ConsumerState<ImageViewVertical> createState() => _ImageViewVerticalState();
}

class _ImageViewVerticalState extends ConsumerState<ImageViewVertical> {
  bool _animated = false;
  @override
  void initState() {
    super.initState();
    _resolveFormat();
  }

  @override
  void didUpdateWidget(ImageViewVertical oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _animated = false;
      _resolveFormat();
    }
  }

  Future<void> _resolveFormat() async {
    final data = widget.data;
    final animated = await isReaderGif(data);
    if (mounted && identical(data, widget.data) && animated != _animated) {
      setState(() => _animated = animated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ComicReaderScope.of(context);
    final profile = settings.profile;
    final display = ReaderTranslationHost.display(context, widget.data);
    final fit = profile.mode == ComicReadingMode.scroll
        ? BoxFit.fitWidth
        : profile.boxFit;
    final imageWidget = _animated && identical(display, widget.data)
        ? ReaderAnimatedImage(
            image: display.getImageProvider(ref, true),
            fit: fit,
            cropBorders: profile.crop,
            naturalHeight: !widget.isHorizontal,
            reservedSize:
                display.loadedWidth != null && display.loadedHeight != null
                ? Size(display.loadedWidth!, display.loadedHeight!)
                : null,
            onFailure: widget.failedToLoadImage,
            onImageLoaded: (width, height) {
              display.loadedWidth = width.toDouble();
              display.loadedHeight = height.toDouble();
              widget.onImageLoaded?.call(width.toDouble(), height.toDouble());
            },
          )
        : MinSubsamplingImage(
            data: display,
            fit: fit,
            backgroundColor: settings.habits.canvas.color(context),
            cropBorders: profile.crop,
            isHorizontal: widget.isHorizontal,
            failedToLoadImage: widget.failedToLoadImage,
            loadStateChanged: widget.loadStateChanged,
            rotation: widget.rotation,
            onImageLoaded: widget.onImageLoaded,
          );
    return ReaderTranslationHost.withStatus(
      context,
      widget.data,
      child: applyReaderColorFilter(
        GestureDetector(
          onLongPress: () => widget.onLongPressData(widget.data),
          child: SizedBox(width: double.infinity, child: imageWidget),
        ),
        profile,
      ),
    );
  }
}
