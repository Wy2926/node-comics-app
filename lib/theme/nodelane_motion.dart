import 'dart:math' as math;

import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Routes use the Navigator's clock. In-place navigation uses the same timing
/// without mounting a duplicate page, Navigator or platform view.
abstract final class NodeLaneMotion {
  static const duration = Duration(milliseconds: 200);
  static const curve = Curves.easeOutCubic;
  static Duration time(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;

  static TabController tabs({
    required int length,
    required TickerProvider vsync,
    int initialIndex = 0,
  }) => _MotionTabs(length: length, vsync: vsync, initialIndex: initialIndex);

  static const _route = _RouteMotion();
  static const pageTransitions = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: _route,
      TargetPlatform.iOS: _route,
      TargetPlatform.macOS: _route,
      TargetPlatform.windows: _route,
      TargetPlatform.linux: _route,
      TargetPlatform.fuchsia: _route,
    },
  );

  static Widget resize(BuildContext context, Widget child) =>
      MediaQuery.disableAnimationsOf(context)
      ? child
      : AnimatedSize(
          duration: duration,
          alignment: AlignmentDirectional.topStart,
          curve: curve,
          child: child,
        );

  /// One mounted body even if the user reverses a disclosure mid-animation.
  static Widget disclosure(BuildContext context, bool open, Widget body) =>
      TweenAnimationBuilder<double>(
        duration: time(context),
        curve: curve,
        tween: Tween(end: open ? 1.0 : 0.0),
        child: ExcludeFocus(
          excluding: !open,
          child: ExcludeSemantics(
            excluding: !open,
            child: IgnorePointer(ignoring: !open, child: body),
          ),
        ),
        builder: (_, factor, child) => ClipRect(
          child: Align(
            alignment: AlignmentDirectional.topStart,
            heightFactor: factor,
            child: factor == 0 ? null : child,
          ),
        ),
      );
}

class _MotionTabs extends TabController {
  _MotionTabs({
    required super.length,
    required super.vsync,
    required super.initialIndex,
  });
  @override
  Duration get animationDuration =>
      WidgetsBinding
          .instance
          .platformDispatcher
          .accessibilityFeatures
          .disableAnimations
      ? Duration.zero
      : NodeLaneMotion.duration;
  @override
  void animateTo(
    int value, {
    Duration? duration,
    Curve curve = NodeLaneMotion.curve,
  }) => super.animateTo(
    value,
    duration: duration ?? animationDuration,
    curve: curve,
  );
}

class _RouteMotion extends PageTransitionsBuilder {
  const _RouteMotion();
  @override
  Duration get transitionDuration => NodeLaneMotion.duration;
  @override
  Duration get reverseTransitionDuration => NodeLaneMotion.duration;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondary,
    Widget child,
  ) {
    final platform = Theme.of(context).platform;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final native = switch (platform) {
      TargetPlatform.android => const PredictiveBackPageTransitionsBuilder(),
      TargetPlatform.iOS ||
      TargetPlatform.macOS => const CupertinoPageTransitionsBuilder(),
      _ => null,
    };
    if (native != null) {
      // Keep the platform's interactive back handler even with reduced motion.
      return native.buildTransitions(
        route,
        context,
        reduced ? kAlwaysCompleteAnimation : animation,
        reduced ? kAlwaysDismissedAnimation : secondary,
        child,
      );
    }
    return reduced
        ? child
        : SlideTransition(
            position: animation.drive(_slide),
            textDirection: Directionality.of(context),
            child: child,
          );
  }

  static final _slide = Tween(
    begin: const Offset(1, 0),
    end: Offset.zero,
  ).chain(CurveTween(curve: NodeLaneMotion.curve));
}

/// Animate a change of destination, never a data refresh. Only the incoming
/// child paints; the veil is a solid rect, not opacity on the whole subtree.
class NodeLaneContentMotion extends StatefulWidget {
  const NodeLaneContentMotion({
    super.key,
    required this.value,
    required this.child,
    this.reverse = false,
  });
  final Object? value;
  final Widget child;
  final bool reverse;

  @override
  State<NodeLaneContentMotion> createState() => _ContentMotionState();
}

class _ContentMotionState extends State<NodeLaneContentMotion>
    with SingleTickerProviderStateMixin {
  late final _clock = AnimationController(
    vsync: this,
    duration: NodeLaneMotion.duration,
    value: 1,
  );

  @override
  void didUpdateWidget(NodeLaneContentMotion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value &&
        !MediaQuery.disableAnimationsOf(context)) {
      _clock.forward(from: 0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) && _clock.isAnimating) {
      _clock.value = 1;
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final direction =
        (Directionality.of(context) == TextDirection.rtl) != widget.reverse
        ? -1
        : 1;
    final surface = Theme.of(context).scaffoldBackgroundColor;
    return ClipRect(
      child: AnimatedBuilder(
        animation: _clock,
        child: RepaintBoundary(child: widget.child),
        builder: (_, child) {
          final remaining = 1 - NodeLaneMotion.curve.transform(_clock.value);
          return Transform.translate(
            offset: Offset(direction * 24 * remaining, 0),
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                color: remaining == 0
                    ? null
                    : surface.withValues(alpha: remaining),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

/// For a pane in a Stack. Change constraints at the ends, then move and clip
/// in paint. Resizing a catalogue grid on every animation tick rebuilds its rows.
class NodeLaneMotionPane extends StatefulWidget {
  const NodeLaneMotionPane({
    super.key,
    required this.start,
    required this.width,
    required this.viewport,
    required this.interactive,
    required this.child,
    this.onSettled,
  });
  final double start, width, viewport;
  final bool interactive;
  final Widget? child;
  final VoidCallback? onSettled;
  @override
  State<NodeLaneMotionPane> createState() => _MotionPaneState();
}

class _MotionPaneState extends State<NodeLaneMotionPane>
    with SingleTickerProviderStateMixin {
  late final _clock =
      AnimationController(
        vsync: this,
        duration: NodeLaneMotion.duration,
        value: 1,
      )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _outgoing = null);
          widget.onSettled?.call();
        }
      });
  late double _fromStart = widget.start, _fromWidth = widget.width;
  Widget? _outgoing;
  double get _t => NodeLaneMotion.curve.transform(_clock.value);
  double _at(double from, double to) => from + (to - from) * _t;

  @override
  void didUpdateWidget(NodeLaneMotionPane old) {
    super.didUpdateWidget(old);
    if (widget.child != null) _outgoing = null;
    if (old.start == widget.start &&
        old.width == widget.width &&
        old.viewport == widget.viewport) {
      return;
    }
    _fromStart = _at(_fromStart, old.start);
    _fromWidth = _at(_fromWidth, old.width);
    if (old.viewport != widget.viewport ||
        MediaQuery.disableAnimationsOf(context) ||
        (old.child == null && widget.child == null && _outgoing == null)) {
      _outgoing = null;
      if (_clock.isCompleted) {
        widget.onSettled?.call();
      } else {
        _clock.value = 1;
      }
    } else {
      if (widget.child == null) _outgoing ??= old.child;
      _clock.forward(from: 0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) && _clock.isAnimating) {
      _clock.value = 1;
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.child ?? _outgoing;
    if (content == null) return const SizedBox.shrink();
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final layoutWidth = _clock.isCompleted
        ? widget.width
        : math.max(_fromWidth, widget.width);
    return PositionedDirectional(
      start: widget.start,
      width: layoutWidth,
      top: 0,
      bottom: 0,
      child: Offstage(
        offstage:
            _clock.isCompleted &&
            (widget.start >= widget.viewport ||
                widget.start + widget.width <= 0),
        child: AnimatedBuilder(
          animation: _clock,
          child: ExcludeFocus(
            excluding: !widget.interactive,
            child: IgnorePointer(
              ignoring: !widget.interactive,
              child: ExcludeSemantics(
                excluding: !widget.interactive,
                child: TickerMode(
                  enabled: widget.interactive,
                  child: RepaintBoundary(child: content),
                ),
              ),
            ),
          ),
          builder: (_, child) {
            final dx = _at(_fromStart, widget.start) - widget.start;
            return Transform.translate(
              offset: Offset(rtl ? -dx : dx, 0),
              child: ClipRect(
                clipper: _PaneClip(_at(_fromWidth, widget.width), rtl),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PaneClip extends CustomClipper<Rect> {
  const _PaneClip(this.width, this.rtl);
  final double width;
  final bool rtl;
  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(rtl ? size.width - width : 0, 0, width, size.height);
  @override
  bool shouldReclip(_PaneClip old) => old.width != width || old.rtl != rtl;
}
