import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Routes use the Navigator's clock. In-place navigation uses the same timing
/// without mounting a duplicate page, Navigator or platform view.
abstract final class NodeLaneMotion {
  static const duration = Duration(milliseconds: 200);
  static const curve = Curves.easeOutCubic;
  static Duration time(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
  static Duration get _systemTime =>
      WidgetsBinding
          .instance
          .platformDispatcher
          .accessibilityFeatures
          .disableAnimations
      ? Duration.zero
      : duration;
  static const _style = AnimationStyle(
    duration: duration,
    reverseDuration: duration,
    curve: curve,
    reverseCurve: curve,
  );
  static AnimationStyle style(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context)
      ? AnimationStyle.noAnimation
      : _style;

  static final _bubbleScale = Tween(
    begin: .93,
    end: 1.0,
  ).chain(CurveTween(curve: curve));
  static final _bubbleFade = CurveTween(
    curve: const Interval(0, .72, curve: Curves.easeOut),
  );

  /// Only the bounded overlay participates; its Navigator owns the clock in both directions.
  static Widget anchored(
    BuildContext context,
    Animation<double> animation,
    Alignment pivot,
    Widget child,
  ) {
    final progress = MediaQuery.disableAnimationsOf(context)
        ? kAlwaysCompleteAnimation
        : animation;
    return FadeTransition(
      opacity: progress.drive(_bubbleFade),
      child: ScaleTransition(
        alignment: pivot,
        scale: progress.drive(_bubbleScale),
        child: child,
      ),
    );
  }

  static const _travel = .055;
  static final _enter = Tween(
    begin: const Offset(_travel, 0),
    end: Offset.zero,
  ).chain(CurveTween(curve: curve));
  static const _still = AlwaysStoppedAnimation(Offset.zero);

  static Widget _content(
    BuildContext context,
    Animation<Offset> position,
    Widget child, {
    bool reverse = false,
  }) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // Lists and platform views already isolate their own paint. At rest this
    // outlet needs neither a clip layer nor a full-page raster cache.
    return ValueListenableBuilder<Offset>(
      valueListenable: position,
      child: child,
      builder: (_, offset, child) => ClipRect(
        clipBehavior: offset == Offset.zero ? Clip.none : Clip.hardEdge,
        child: FractionalTranslation(
          translation: rtl != reverse ? -offset : offset,
          child: child,
        ),
      ),
    );
  }

  /// For a tab body replaced in place. A swipeable TabBarView already moves itself.
  static Widget tabBody(
    BuildContext context,
    TabController tabs,
    Widget child,
  ) {
    final index = tabs.index, distance = (index - tabs.previousIndex).abs();
    final still =
        !tabs.indexIsChanging ||
        distance == 0 ||
        MediaQuery.disableAnimationsOf(context);
    return _content(
      context,
      still
          ? _still
          : tabs.animation!.drive(
              Animatable<Offset>.fromCallback(
                (v) => Offset(
                  ((index - v) / distance).clamp(-1.0, 1.0) * _travel,
                  0,
                ),
              ),
            ),
      child,
    );
  }

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
  Duration get animationDuration => NodeLaneMotion._systemTime;
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
  Duration get transitionDuration => NodeLaneMotion._systemTime;
  @override
  Duration get reverseTransitionDuration => transitionDuration;

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

/// Animate only the current destination, with no outgoing tree or full-page opacity.
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
  AnimationController? _clock;

  @override
  void didUpdateWidget(NodeLaneContentMotion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value &&
        TickerMode.valuesOf(context).enabled &&
        !MediaQuery.disableAnimationsOf(context)) {
      (_clock ??= AnimationController(
        vsync: this,
        duration: NodeLaneMotion.duration,
      )).forward(from: 0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if ((MediaQuery.disableAnimationsOf(context) ||
            !TickerMode.valuesOf(context).enabled) &&
        _clock?.isAnimating == true) {
      _clock!.value = 1;
    }
  }

  @override
  void dispose() {
    _clock?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NodeLaneMotion._content(
    context,
    _clock?.drive(NodeLaneMotion._enter) ?? NodeLaneMotion._still,
    widget.child,
    reverse: widget.reverse,
  );
}
