import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Skips building the real cover — a network fetch + decode — while the
/// nearest Scrollable is flinging fast, showing an empty box of the same
/// size instead. Swaps in the real image once scrolling settles.
class DeferredCoverImage extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final double width;
  final double height;

  const DeferredCoverImage({
    super.key,
    required this.builder,
    required this.width,
    required this.height,
  });

  @override
  State<DeferredCoverImage> createState() => _DeferredCoverImageState();
}

class _DeferredCoverImageState extends State<DeferredCoverImage> {
  ScrollPosition? _scrollPosition;
  bool _rebuildScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (!identical(position, _scrollPosition)) {
      _scrollPosition?.isScrollingNotifier.removeListener(_onScrollingChanged);
      _scrollPosition = position;
      _scrollPosition?.isScrollingNotifier.addListener(_onScrollingChanged);
    }
  }

  void _onScrollingChanged() {
    // A shrinking list can change its scroll activity during layout.
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      if (_rebuildScheduled) return;
      _rebuildScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _rebuildScheduled = false;
        if (mounted) setState(() {});
      });
      return;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _scrollPosition?.isScrollingNotifier.removeListener(_onScrollingChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Scrollable.recommendDeferredLoadingForContext(context)) {
      return SizedBox(width: widget.width, height: widget.height);
    }
    return widget.builder(context);
  }
}
