import 'dart:async';
import 'dart:ffi';
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_content_status.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart';

class MinSubsamplingImage extends ConsumerStatefulWidget {
  final UChapDataPreload data;
  final BoxFit fit;
  final Color backgroundColor;
  final Color? color;
  final BlendMode? colorBlendMode;
  final bool cropBorders;
  final bool isHorizontal;
  final Function(bool) failedToLoadImage;

  final Widget? Function(SubsamplingImageState)? loadStateChanged;
  final int rotation;
  final Function(double width, double height)? onImageLoaded;

  const MinSubsamplingImage({
    super.key,
    required this.data,
    required this.fit,
    this.backgroundColor = Colors.transparent,
    this.color,
    this.colorBlendMode,
    required this.cropBorders,
    required this.isHorizontal,
    required this.failedToLoadImage,
    this.loadStateChanged,
    this.rotation = 0,
    this.onImageLoaded,
  });

  @override
  ConsumerState<MinSubsamplingImage> createState() =>
      _MinSubsamplingImageState();
}

class _MinSubsamplingImageState extends ConsumerState<MinSubsamplingImage> {
  ui.Image? _uiImage;
  int _loadGeneration = 0;
  bool _isCurrent(int generation, UChapDataPreload data) =>
      mounted && generation == _loadGeneration && identical(data, widget.data);
  bool _isLoading = true;
  bool _hasError = false;
  ImageStreamListener? _streamListener;
  ImageStream? _imageStream;
  ImageChunkEvent? _loadingProgress;

  @override
  void initState() {
    super.initState();
    if ((widget.data.decodedImage != null &&
        widget.data.decodedImageCropped == widget.cropBorders)) {
      _uiImage = widget.data.decodedImage!.clone();
      _isLoading = false;
      _hasError = false;
    } else {
      _loadImage();
    }
  }

  @override
  void didUpdateWidget(MinSubsamplingImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool dataChanged = widget.data != oldWidget.data;
    if (dataChanged) {
      _loadGeneration++;
      _cleanStream();
      ffiImageDecoder.cancel(this);
      _uiImage?.dispose();
      _uiImage = null;
      if ((widget.data.decodedImage != null &&
          widget.data.decodedImageCropped == widget.cropBorders)) {
        _uiImage = widget.data.decodedImage!.clone();
        _isLoading = false;
        _hasError = false;
        return;
      }
      _loadImage(refresh: false);
      return;
    }
    if (widget.cropBorders != oldWidget.cropBorders) {
      _loadImage(refresh: true, evictCache: false);
      return;
    }
    final bool imageLoaded =
        _uiImage == null &&
        (widget.data.decodedImage != null &&
            widget.data.decodedImageCropped == widget.cropBorders);
    if (imageLoaded) {
      _uiImage?.dispose();
      _uiImage = widget.data.decodedImage!.clone();
      _isLoading = false;
      _hasError = false;
      return;
    }
  }

  @override
  void dispose() {
    _loadGeneration++;
    _cleanStream();
    ffiImageDecoder.cancel(this);
    _uiImage?.dispose();
    super.dispose();
  }

  void _cleanStream() {
    if (_streamListener != null && _imageStream != null) {
      _imageStream!.removeListener(_streamListener!);
    }
    _streamListener = null;
    _imageStream = null;
  }

  Future<void> _loadImage({
    bool refresh = false,
    bool evictCache = false,
  }) async {
    final data = widget.data;
    final generation = ++_loadGeneration;
    _cleanStream();
    ffiImageDecoder.cancel(this);

    if (evictCache) {
      data.decodedImage?.dispose();
      data.decodedImage = null;
      data.resolvedFilePath = null;
      _uiImage?.dispose();
      _uiImage = null;
      try {
        final provider = data.getImageProvider(ref, true);
        await provider.evict();
      } catch (_) {}
      if (!_isCurrent(generation, data)) return;
    } else if (refresh) {
      data.decodedImage?.dispose();
      data.decodedImage = null;
    }

    if ((data.decodedImage != null &&
            data.decodedImageCropped == widget.cropBorders) &&
        !refresh &&
        !evictCache) {
      _uiImage ??= data.decodedImage!.clone();
      if (_isCurrent(generation, data)) {
        setState(() {
          _isLoading = false;
          _hasError = false;
          _loadingProgress = null;
        });
        widget.failedToLoadImage(false);
      }
      return;
    }
    if (_isCurrent(generation, data)) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _loadingProgress = null;
      });
    }

    final String? path = data.resolvedFilePath ?? await data.getLocalFilePath;
    if (!_isCurrent(generation, data)) return;
    if (path != null) {
      data.resolvedFilePath = path;
    }
    if (path != null && widget.cropBorders) {
      await _loadFromPath(path, generation, data);
    } else {
      final provider = data.getImageProvider(ref, true);
      _imageStream = provider.resolve(ImageConfiguration.empty);
      _streamListener = ImageStreamListener(
        (info, syncCall) async {
          _cleanStream();
          final cachedPath =
              data.resolvedFilePath ?? await data.getLocalFilePath;
          if (!_isCurrent(generation, data)) {
            info.dispose();
            return;
          }
          if (cachedPath != null) {
            data.resolvedFilePath = cachedPath;
          }
          if (widget.cropBorders) {
            if (cachedPath != null) {
              info.dispose();
              await _loadFromPath(cachedPath, generation, data);
              return;
            }
          }
          if (_isCurrent(generation, data)) {
            data.loadedWidth = info.image.width.toDouble();
            data.loadedHeight = info.image.height.toDouble();
            data.decodedImage?.dispose();
            data.decodedImage = info.image.clone();
            data.decodedImageCropped = false;
            final old = _uiImage;
            setState(() {
              _uiImage = info.image.clone();
              _isLoading = false;
              _loadingProgress = null;
            });
            old?.dispose();
            widget.failedToLoadImage(false);
            widget.onImageLoaded?.call(
              info.image.width.toDouble(),
              info.image.height.toDouble(),
            );
          }
          info.dispose();
        },
        onChunk: (ImageChunkEvent event) {
          if (_isCurrent(generation, data)) {
            setState(() {
              _loadingProgress = event;
            });
          }
        },
        onError: (err, stack) {
          _cleanStream();
          if (_isCurrent(generation, data)) {
            setState(() {
              _hasError = true;
              _isLoading = false;
              _loadingProgress = null;
            });
            widget.failedToLoadImage(true);
          }
        },
      );
      _imageStream!.addListener(_streamListener!);
    }
  }

  Future<void> _loadFromPath(
    String path,
    int generation,
    UChapDataPreload data,
  ) async {
    if (!_isCurrent(generation, data)) return;

    final viewport = MediaQuery.of(context);
    try {
      final dims = await ffiImageDecoder.getImageDimensionsAsync(
        path,
        cropBorders: widget.cropBorders,
        cancelToken: this,
      );

      if (dims == null || dims.length < 2) {
        // If operation was cancelled by a quick toggle, return quietly without error
        return;
      }

      final int croppedWidth = dims[0];
      final int croppedHeight = dims[1];

      if (!_isCurrent(generation, data)) return;

      final bool isRotated = widget.rotation == 90 || widget.rotation == 270;
      final double aspect = isRotated
          ? (croppedHeight / croppedWidth)
          : (croppedWidth / croppedHeight);
      double targetWidth;
      double targetHeight;

      if (widget.isHorizontal) {
        final screenHeight =
            viewport.size.height -
            viewport.padding.top -
            viewport.padding.bottom;
        targetHeight = screenHeight;
        targetWidth = screenHeight * aspect;
      } else {
        final screenWidth = viewport.size.width;
        targetWidth = screenWidth;
        targetHeight = screenWidth / aspect;
      }

      data.loadedWidth = targetWidth;
      data.loadedHeight = targetHeight;

      const int sampleSize = 1;

      if (!_isCurrent(generation, data)) return;
      final result = await ffiImageDecoder.decodeRegionAsync(
        DecodeParams(
          filePath: path,
          left: 0,
          top: 0,
          right: croppedWidth,
          bottom: croppedHeight,
          sampleSize: sampleSize,
          cropBorders: widget.cropBorders,
        ),
        cancelToken: this,
      );

      if (result == null || result.error == 'Cancelled') {
        return;
      }

      if (result.pointerAddress == null || result.error != null) {
        throw Exception(result.error ?? "Failed to decode region");
      }

      final decodedWidth = croppedWidth ~/ sampleSize;
      final decodedHeight = croppedHeight ~/ sampleSize;

      final pointer = Pointer<Uint8>.fromAddress(result.pointerAddress!);
      final bytes = pointer.asTypedList(decodedWidth * decodedHeight * 4);

      final Completer<ui.Image> completer = Completer<ui.Image>();
      try {
        ui.decodeImageFromPixels(
          bytes,
          decodedWidth,
          decodedHeight,
          ui.PixelFormat.rgba8888,
          (ui.Image img) {
            calloc.free(pointer);
            completer.complete(img);
          },
        );
      } catch (e) {
        calloc.free(pointer);
        rethrow;
      }

      final ui.Image img = await completer.future;

      if (_isCurrent(generation, data)) {
        data.resolvedFilePath = path;
        data.decodedImage?.dispose();
        data.decodedImage = img.clone();
        data.decodedImageCropped = widget.cropBorders;
        final old = _uiImage;
        setState(() {
          _uiImage = img;
          _isLoading = false;
          _hasError = false;
        });
        old?.dispose();
        widget.failedToLoadImage(false);
        widget.onImageLoaded?.call(
          croppedWidth.toDouble(),
          croppedHeight.toDouble(),
        );
      } else {
        img.dispose();
      }
    } catch (e) {
      if (e.toString().contains('Cancelled')) return;
      if (_isCurrent(generation, data)) {
        setState(() {
          _hasError = true;
          _isLoading = false;
          _loadingProgress = null;
        });
        widget.failedToLoadImage(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_uiImage == null &&
        (widget.data.decodedImage != null &&
            widget.data.decodedImageCropped == widget.cropBorders)) {
      _uiImage?.dispose();
      _uiImage = widget.data.decodedImage!.clone();
      _isLoading = false;
      _hasError = false;
    }

    final backgroundColor = widget.backgroundColor;
    final subsamplingState = SubsamplingImageState(
      loadState: _isLoading
          ? LoadState.loading
          : _hasError
          ? LoadState.failed
          : LoadState.completed,
      loadingProgress: _loadingProgress,
      reLoadCallback: () {
        widget.failedToLoadImage(false);
        _loadImage(refresh: true, evictCache: true);
      },
    );

    if (widget.loadStateChanged != null) {
      final customWidget = widget.loadStateChanged!(subsamplingState);
      if (customWidget != null) return customWidget;
    }

    if (_hasError || _uiImage == null) {
      final progress = _loadingProgress?.expectedTotalBytes != null
          ? _loadingProgress!.cumulativeBytesLoaded /
                _loadingProgress!.expectedTotalBytes!
          : null;
      return ReaderImagePlaceholder(
        imageWidth: widget.data.loadedWidth,
        imageHeight: widget.data.loadedHeight,
        horizontal: widget.isHorizontal,
        backgroundColor: backgroundColor,
        child: ReaderContentStatus(
          message: _hasError
              ? context.l10n.image_loading_error
              : context.l10n.reader_image_loading,
          description: _hasError
              ? context.l10n.reader_image_failure_hint
              : null,
          loading: !_hasError,
          progress: progress,
          onRetry: _hasError ? subsamplingState.reLoadImage : null,
        ),
      );
    }

    final Widget rawImage = RawImage(
      image: _uiImage,
      fit: widget.fit,
      color: widget.color,
      colorBlendMode: widget.colorBlendMode,
      filterQuality: FilterQuality.medium,
    );

    if (widget.rotation != 0) {
      final quarterTurns = (widget.rotation ~/ 90) % 4;
      if (quarterTurns != 0) {
        return RotatedBox(quarterTurns: quarterTurns, child: rawImage);
      }
    }

    return rawImage;
  }
}
