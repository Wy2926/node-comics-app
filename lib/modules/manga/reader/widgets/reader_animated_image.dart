import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

import 'reader_content_status.dart';

/// Flutter owns animation decoding. This view applies the same fit, rotation,
/// half-page projection and first-frame border crop without freezing GIFs.
class ReaderAnimatedImage extends StatefulWidget {
  const ReaderAnimatedImage({
    super.key,
    required this.image,
    required this.fit,
    required this.cropBorders,
    this.rightHalf,
    this.onImageLoaded,
    this.naturalHeight = false,
    this.onFailure,
  });
  final ImageProvider image;
  final BoxFit fit;
  final bool cropBorders;
  final bool naturalHeight;
  final ValueChanged<bool>? onFailure;
  final bool? rightHalf;
  final void Function(int, int)? onImageLoaded;
  @override
  State<ReaderAnimatedImage> createState() => _ReaderAnimatedImageState();
}

class _ReaderAnimatedImageState extends State<ReaderAnimatedImage> {
  ImageStream? _stream;
  ImageStreamListener? _listener;
  ui.Image? _frame;
  Rect? _borderRect;
  bool _failed = false;
  int _generation = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_stream == null) _resolve();
  }

  @override
  void didUpdateWidget(ReaderAnimatedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _resolve();
    } else if (widget.cropBorders != oldWidget.cropBorders) {
      _generation++;
      if (widget.cropBorders && _frame != null) {
        _findBorders(_frame!.clone(), _generation);
      }
    }
  }

  void _detach() {
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
    _stream = null;
    _listener = null;
  }

  void _resolve() {
    _detach();
    final generation = ++_generation;
    _failed = false;
    _borderRect = null;
    _frame?.dispose();
    _frame = null;
    _stream = widget.image.resolve(createLocalImageConfiguration(context));
    var first = true;
    _listener = ImageStreamListener(
      (info, _) {
        if (!mounted) {
          info.dispose();
          return;
        }
        final previous = _frame;
        setState(() => _frame = info.image.clone());
        previous?.dispose();
        if (first) {
          first = false;
          widget.onFailure?.call(false);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && generation == _generation) {
              widget.onImageLoaded?.call(_frame!.width, _frame!.height);
            }
          });
          if (widget.cropBorders) _findBorders(info.image.clone(), generation);
        }
        info.dispose();
      },
      onError: (Object _, StackTrace? _) {
        if (mounted) {
          setState(() => _failed = true);
          widget.onFailure?.call(true);
        }
      },
    );
    _stream!.addListener(_listener!);
  }

  Future<void> _findBorders(ui.Image image, int generation) async {
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (bytes == null || !mounted || generation != _generation) return;
      final w = image.width, h = image.height;
      // Match the native static-image classifier: an edge majority selects
      // white, black or transparent margins. Inspect only the first frame so
      // animation never changes the reading layout on each frame.
      int type(int x, int y) {
        final i = (y * w + x) * 4;
        final r = bytes.getUint8(i),
            g = bytes.getUint8(i + 1),
            b = bytes.getUint8(i + 2);
        if (bytes.getUint8(i + 3) < 30) return 0;
        if (r > 240 && g > 240 && b > 240) return 1;
        if (r < 25 && g < 25 && b < 25) return 2;
        return 3;
      }

      final counts = List.filled(4, 0);
      for (final (x, y) in [
        (0, 0),
        (w - 1, 0),
        (0, h - 1),
        (w - 1, h - 1),
        (w ~/ 2, 0),
        (w ~/ 2, h - 1),
        (0, h ~/ 2),
        (w - 1, h ~/ 2),
      ]) {
        counts[type(x, y)]++;
      }
      final background = counts.indexWhere((count) => count >= 5);
      if (background < 0 || background == 3) return;
      bool blank(int x, int y) {
        final i = (y * w + x) * 4;
        final r = bytes.getUint8(i),
            g = bytes.getUint8(i + 1),
            b = bytes.getUint8(i + 2),
            a = bytes.getUint8(i + 3);
        return switch (background) {
          0 => a < 40,
          1 => r > 235 && g > 235 && b > 235 && a > 100,
          _ => r < 30 && g < 30 && b < 30 && a > 100,
        };
      }

      bool row(int y) {
        var content = 0;
        for (var x = 0; x < w; x++) {
          if (!blank(x, y) && ++content > w ~/ 100 + 1) return false;
        }
        return true;
      }

      bool column(int x) {
        var content = 0;
        for (var y = 0; y < h; y++) {
          if (!blank(x, y) && ++content > h ~/ 100 + 1) return false;
        }
        return true;
      }

      var left = 0, top = 0, right = w, bottom = h;
      while (top < bottom && row(top)) {
        top++;
      }
      while (bottom > top && row(bottom - 1)) {
        bottom--;
      }
      while (left < right && column(left)) {
        left++;
      }
      while (right > left && column(right - 1)) {
        right--;
      }
      if (right - left < w / 4 || bottom - top < h / 4) return;
      if (right > left && bottom > top) {
        setState(
          () => _borderRect = Rect.fromLTRB(
            left.toDouble(),
            top.toDouble(),
            right.toDouble(),
            bottom.toDouble(),
          ),
        );
      }
    } finally {
      image.dispose();
    }
  }

  @override
  void dispose() {
    _generation++;
    _detach();
    _frame?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Center(
        child: ReaderContentStatus(
          message: context.l10n.image_loading_error,
          description: context.l10n.reader_image_failure_hint,
          onRetry: () async {
            await widget.image.evict();
            if (mounted) setState(_resolve);
          },
        ),
      );
    }
    final frame = _frame;
    if (frame == null) {
      return Center(
        child: ReaderContentStatus(
          message: context.l10n.reader_image_loading,
          loading: true,
        ),
      );
    }
    var source = widget.cropBorders && _borderRect != null
        ? _borderRect!
        : Rect.fromLTWH(0, 0, frame.width.toDouble(), frame.height.toDouble());
    if (widget.rightHalf != null) {
      source = Rect.fromLTWH(
        source.left + (widget.rightHalf! ? source.width / 2 : 0),
        source.top,
        source.width / 2,
        source.height,
      );
    }
    final paint = CustomPaint(
      painter: _AnimatedPagePainter(frame, source, widget.fit),
      size: Size.infinite,
    );
    return widget.naturalHeight
        ? AspectRatio(aspectRatio: source.width / source.height, child: paint)
        : paint;
  }
}

class _AnimatedPagePainter extends CustomPainter {
  _AnimatedPagePainter(this.image, this.source, this.fit);
  final ui.Image image;
  final Rect source;
  final BoxFit fit;
  @override
  void paint(Canvas canvas, Size size) {
    final fitted = applyBoxFit(fit, source.size, size);
    final crop = Alignment.center.inscribe(fitted.source, source);
    final target = Alignment.center.inscribe(
      fitted.destination,
      Offset.zero & size,
    );
    canvas.clipRect(Offset.zero & size);
    canvas.drawImageRect(
      image,
      crop,
      target,
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(_AnimatedPagePainter old) =>
      image != old.image || source != old.source || fit != old.fit;
}
