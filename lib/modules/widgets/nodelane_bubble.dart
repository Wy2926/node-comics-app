import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

Future<T?> showNodeLaneBubbleMenu<T>(
  BuildContext anchor, {
  required String label,
  required List<PopupMenuEntry<T>> items,
  Offset? localPoint,
}) => showNodeLaneBubble<T>(
  anchor,
  label: label,
  localPoint: localPoint,
  child: Semantics(
    role: SemanticsRole.menu,
    container: true,
    explicitChildNodes: true,
    child: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: NodeLaneTokens.space4),
      children: items,
    ),
  ),
);

/// Builds choices on opening so inactive menus don't subscribe or load data.
class NodeLaneBubbleButton<T> extends StatelessWidget {
  const NodeLaneBubbleButton({
    super.key,
    required this.itemBuilder,
    required this.onSelected,
    this.onOpened,
    this.enabled = true,
    this.tooltip,
    this.icon,
    this.child,
    this.style,
  });
  final PopupMenuItemBuilder<T> itemBuilder;
  final ValueChanged<T> onSelected;
  final VoidCallback? onOpened;
  final bool enabled;
  final String? tooltip;
  final Widget? icon, child;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final label = tooltip ?? MaterialLocalizations.of(context).showMenuTooltip;
    Future<void> open() async {
      final items = itemBuilder(context);
      if (items.isEmpty) return;
      onOpened?.call();
      final result = await showNodeLaneBubbleMenu<T>(
        context,
        label: label,
        items: items,
      );
      if (context.mounted && result != null) onSelected(result);
    }

    if (child == null) {
      return IconButton(
        tooltip: label,
        style: style,
        onPressed: enabled ? open : null,
        icon: icon ?? const Icon(Icons.more_vert),
      );
    }
    return MergeSemantics(
      child: Semantics(
        button: enabled,
        container: true,
        tooltip: label,
        child: Tooltip(
          message: label,
          excludeFromSemantics: true,
          child: InkWell(
            onTap: enabled ? open : null,
            borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// The route owns focus and dismissal. Only the bubble animates; the native
/// page underneath stays in its original layer.
Future<T?> showNodeLaneBubble<T>(
  BuildContext anchor, {
  required String label,
  required Widget child,
  double width = NodeLaneTokens.menuMaxWidth,
  Offset? localPoint,
  bool requestFocus = true,
  bool dismissible = true,
}) {
  final navigator = Navigator.of(anchor, rootNavigator: true);
  final overlay = navigator.overlay!.context.findRenderObject()! as RenderBox;
  final themes = InheritedTheme.capture(from: anchor, to: navigator.context);
  final nested =
      ModalRoute.of(anchor) is _BubbleRoute ||
      NodeLaneBubbleFlow.contains(anchor);
  final render = anchor.findRenderObject();
  final box = render is RenderBox
      ? render
      : anchor.findAncestorRenderObjectOfType<RenderBox>() ?? overlay;
  Rect measure() => localPoint == null
      ? MatrixUtils.transformRect(
          box.getTransformTo(overlay),
          Offset.zero & box.size,
        )
      : box.localToGlobal(localPoint, ancestor: overlay) & Size.zero;
  var lastRect = measure();
  return navigator.push<T>(
    _BubbleRoute<T>(
      barrierDismissible: dismissible,
      barrierLabel: MaterialLocalizations.of(anchor).menuDismissLabel,
      requestFocus: requestFocus,
      transitionDuration: NodeLaneMotion.time(anchor),
      pageBuilder: (context, animation, _) => themes.wrap(
        LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest, media = MediaQuery.of(context);
            final safe = EdgeInsets.fromLTRB(
              math.max(media.viewPadding.left, media.viewInsets.left),
              math.max(media.viewPadding.top, media.viewInsets.top),
              math.max(media.viewPadding.right, media.viewInsets.right),
              math.max(media.viewPadding.bottom, media.viewInsets.bottom),
            ).deflateRect(Offset.zero & size);
            final bounds = EdgeInsets.symmetric(
              horizontal: nested
                  ? NodeLaneTokens.space16
                  : NodeLaneTokens.space8,
              vertical: NodeLaneTokens.space8,
            ).deflateRect(safe);
            if (bounds.isEmpty) return const SizedBox.shrink();
            if (box.attached && box.hasSize) lastRect = measure();
            var rect = lastRect;
            // A keyboard-invoked action can originate in the document rather than a button.
            if (rect.height > bounds.height * .6) {
              rect = rect.center & Size.zero;
            }
            final layout = _BubbleLayout(
              bounds,
              rect,
              width,
              keepFieldVisible: !requestFocus,
            );
            final pivot = Alignment(
              rect.center.dx.clamp(bounds.left, bounds.right) / size.width * 2 -
                  1,
              rect.center.dy.clamp(bounds.top, bounds.bottom) /
                      size.height *
                      2 -
                  1,
            );
            final colors = NodeLaneTokens.of(context);
            return NodeLaneMotion.anchored(
              context,
              animation,
              pivot,
              CustomSingleChildLayout(
                delegate: layout,
                child: RepaintBoundary(
                  child: Material(
                    color: colors.surface,
                    surfaceTintColor: Colors.transparent,
                    elevation: 7,
                    shadowColor: Colors.black26,
                    animationDuration: Duration.zero,
                    shape: _BubbleOutline(layout, colors.line),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(
                        NodeLaneTokens.bubbleTipHeight,
                      ),
                      child: Semantics(
                        namesRoute: true,
                        scopesRoute: true,
                        explicitChildNodes: true,
                        label: label,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

class _BubbleRoute<T> extends RawDialogRoute<T> {
  _BubbleRoute({
    required super.barrierDismissible,
    required super.pageBuilder,
    required super.barrierLabel,
    required super.requestFocus,
    required super.transitionDuration,
  }) : super(
         barrierColor: NodeLaneTokens.bubbleBarrier,
         transitionBuilder: (_, _, _, page) => page,
       );

  // Keep the scrim in its own static overlay entry while the small bubble scales.
  @override
  Widget buildModalBarrier() => ModalBarrier(
    color: offstage ? null : barrierColor,
    dismissible: barrierDismissible,
    semanticsLabel: barrierLabel,
    barrierSemanticsDismissible: semanticsDismissible,
  );
}

/// A compact home with a local history for multi-step tools. The outer route
/// keeps the original anchor; Back and barrier taps must honor the active form.
class NodeLaneBubbleFlow extends StatefulWidget {
  const NodeLaneBubbleFlow({super.key, required this.home});
  final Widget home;

  static bool contains(BuildContext context) =>
      context.findAncestorStateOfType<_NodeLaneBubbleFlowState>() != null;

  static bool _isStep(BuildContext context) {
    final flow = context.findAncestorStateOfType<_NodeLaneBubbleFlowState>();
    return flow != null &&
        (flow._panel != null ||
            Navigator.of(context) == flow._navigator.currentState);
  }

  static Future<T?> open<T>(
    BuildContext anchor, {
    required String title,
    required Widget child,
    Offset? localPoint,
    double width = NodeLaneTokens.bubblePanelWidth,
  }) => showNodeLaneBubble<T>(
    anchor,
    label: title,
    localPoint: localPoint,
    width: width,
    child: NodeLaneBubbleFlow(home: child),
  );

  /// The editor owns a popup above its trigger; closing it never pops the parent.
  static Future<T?> edit<T>(
    BuildContext anchor, {
    required String title,
    required Widget Function(BuildContext, ValueChanged<T?> finish) body,
    double width = NodeLaneTokens.bubbleToolWidth,
  }) => showNodeLaneBubble<T>(
    anchor,
    label: title,
    width: width,
    child: NodeLaneBubblePanel(
      title: title,
      child: Builder(
        builder: (context) => body(context, (value) {
          if (context.mounted && ModalRoute.isCurrentOf(context) == true) {
            Navigator.pop<T>(context, value);
          }
        }),
      ),
    ),
  );

  static Future<T?> push<T>(BuildContext context, Widget step) => context
      .findAncestorStateOfType<_NodeLaneBubbleFlowState>()!
      ._push<T>(context, step);

  /// Replace the contents of this bubble at their natural height. Back
  /// restores the originating menu or form without pushing a page.
  static Future<void> showPanel(BuildContext context, Widget panel) => context
      .findAncestorStateOfType<_NodeLaneBubbleFlowState>()!
      ._showPanel(context, panel);

  @override
  State<NodeLaneBubbleFlow> createState() => _NodeLaneBubbleFlowState();
}

class _NodeLaneBubbleFlowState extends State<NodeLaneBubbleFlow> {
  final _navigator = GlobalKey<NavigatorState>();
  bool _expanded = false, _covered = false;
  Widget? _panel;
  LocalHistoryEntry? _panelEntry;

  Future<void> _showPanel(BuildContext origin, Widget panel) async {
    if (_panel != null || ModalRoute.isCurrentOf(origin) != true) return;
    final closed = Completer<void>();
    final entry = _panelEntry = LocalHistoryEntry(
      onRemove: () {
        if (_panelEntry != null && mounted) {
          setState(() {
            _panel = null;
            _panelEntry = null;
          });
        }
        closed.complete();
      },
    );
    ModalRoute.of(context)!.addLocalHistoryEntry(entry);
    setState(() => _panel = panel);
    return closed.future;
  }

  @override
  void dispose() {
    final entry = _panelEntry;
    _panelEntry = null;
    entry?.remove();
    super.dispose();
  }

  void _onFirstTransition(AnimationStatus status) {
    final covered = status == AnimationStatus.completed;
    if (mounted && covered != _covered) setState(() => _covered = covered);
  }

  Future<T?> _push<T>(BuildContext origin, Widget step) async {
    final navigator = _navigator.currentState;
    if (_panel != null ||
        ModalRoute.isCurrentOf(origin) != true ||
        (navigator != null && Navigator.of(origin) != navigator)) {
      return null;
    }
    final route = MaterialPageRoute<T>(
      builder: (context) => Material(
        color: NodeLaneTokens.of(context).surface,
        animationDuration: Duration.zero,
        child: step,
      ),
    );
    if (navigator != null) return navigator.push(route);
    if (_expanded) return null;
    setState(() => _expanded = true);
    try {
      // Initial routes are installed without a push transition. Mount the local
      // navigator first, then let the real route animate onto and off its stack.
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return null;
      final popped = _navigator.currentState!.push(route);
      final progress = route.animation!..addStatusListener(_onFirstTransition);
      _onFirstTransition(progress.status);
      // Deliver the choice at pop just like Navigator.push; only teardown waits for paint.
      route.completed.then((_) {
        progress.removeStatusListener(_onFirstTransition);
        if (mounted) setState(() => _expanded = _covered = false);
      });
      return await popped;
    } catch (_) {
      if (mounted) setState(() => _expanded = _covered = false);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) => NodeLaneContentMotion(
    value: _panel != null,
    reverse: _panel == null,
    child: Stack(
      children: [
        Visibility(
          visible: !_covered && _panel == null,
          maintainState: true,
          child: ExcludeFocus(
            excluding: _expanded,
            child: ExcludeSemantics(
              excluding: _expanded,
              child: IgnorePointer(ignoring: _expanded, child: widget.home),
            ),
          ),
        ),
        if (_expanded)
          Visibility(
            visible: _panel == null,
            maintainState: true,
            child: PopScope<Object?>(
              canPop: _panel != null,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop && _panel == null) {
                  _navigator.currentState?.maybePop();
                }
              },
              child: LayoutBuilder(
                builder: (context, box) => MediaQuery(
                  // The outer bubble already avoids the keyboard and system bars.
                  data: MediaQuery.of(context).copyWith(
                    size: box.biggest,
                    padding: EdgeInsets.zero,
                    viewPadding: EdgeInsets.zero,
                    viewInsets: EdgeInsets.zero,
                  ),
                  child: Navigator(
                    key: _navigator,
                    onGenerateInitialRoutes: (_, _) => [
                      // The menu paints behind this placeholder. There is no
                      // underlying page for a platform exit animation to composite.
                      PageRouteBuilder<void>(
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                        pageBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ?_panel,
      ],
    ),
  );
}

/// Live preferences and pending writes keep updating a detached popup.
class NodeLaneLiveBubbleButton extends StatefulWidget {
  const NodeLaneLiveBubbleButton({
    super.key,
    required this.title,
    required this.editor,
    required this.builder,
    this.enabled = true,
    this.openOnMount = false,
    this.onClose,
  });
  final String title;
  final Widget editor;
  final Widget Function(BuildContext, VoidCallback?, bool) builder;
  final bool enabled, openOnMount;
  final VoidCallback? onClose;
  @override
  State<NodeLaneLiveBubbleButton> createState() => _LiveBubbleButtonState();
}

class _LiveBubbleButtonState extends State<NodeLaneLiveBubbleButton> {
  ValueNotifier<Widget>? _editor;
  VoidCallback? _dismiss;
  @override
  void initState() {
    super.initState();
    if (widget.openOnMount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _open();
      });
    }
  }

  @override
  void didUpdateWidget(NodeLaneLiveBubbleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_editor != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _editor?.value = widget.editor;
      });
    }
  }

  @override
  void dispose() {
    final dismiss = _dismiss;
    if (dismiss != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => dismiss());
    }
    super.dispose();
  }

  Future<void> _open() async {
    if (_editor != null || !widget.enabled) return;
    final editor = ValueNotifier(widget.editor);
    setState(() => _editor = editor);
    try {
      await NodeLaneBubbleFlow.edit<void>(
        context,
        title: widget.title,
        body: (_, finish) {
          _dismiss = () => finish(null);
          return ValueListenableBuilder<Widget>(
            valueListenable: editor,
            builder: (_, child, _) => child,
          );
        },
      );
    } finally {
      _dismiss = null;
      editor.dispose();
      if (mounted) {
        setState(() => _editor = null);
        widget.onClose?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.enabled ? _open : null, _editor != null);
}

typedef _BubbleFrame = ({Offset origin, AxisDirection? direction, Offset tip});

class _BubbleLayout extends SingleChildLayoutDelegate {
  const _BubbleLayout(
    this.bounds,
    this.anchor,
    this.width, {
    required this.keepFieldVisible,
  });
  final Rect bounds, anchor;
  final double width;
  final bool keepFieldVisible;
  static const tip = NodeLaneTokens.bubbleTipHeight;
  static const inset = Offset(tip, tip);
  static const gap = NodeLaneTokens.space4 + tip;

  double get above =>
      (anchor.top - gap).clamp(bounds.top, bounds.bottom) - bounds.top;
  double get below =>
      bounds.bottom - (anchor.bottom + gap).clamp(bounds.top, bounds.bottom);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final full = math.min(NodeLaneTokens.bubbleMaxHeight, bounds.height);
    final room = math.max(above, below);
    // Prefer scrolling by one row to covering a nearby trigger. An underlying editor always stays clear.
    final height =
        keepFieldVisible ||
            full - room <= math.min(NodeLaneTokens.rowHeight, full * .15)
        ? math.min(full, room)
        : full;
    return BoxConstraints.tightFor(
      width: math.min(width, bounds.width) + 2 * tip,
    ).copyWith(maxHeight: height + 2 * tip);
  }

  _BubbleFrame place(Size outer) {
    final body = (Offset.zero & outer).deflate(tip).size;
    final right = bounds.right - anchor.right - gap,
        left = anchor.left - gap - bounds.left;
    final AxisDirection? direction;
    if (keepFieldVisible || outer.height <= math.max(above, below) + 2 * tip) {
      direction = below >= above ? AxisDirection.down : AxisDirection.up;
    } else if (body.width <= math.max(left, right)) {
      direction = right >= left ? AxisDirection.right : AxisDirection.left;
    } else {
      direction = null;
    }
    final center = direction == null ? bounds.center : anchor.center;
    final x = switch (direction) {
      AxisDirection.left => anchor.left - gap - body.width,
      AxisDirection.right => anchor.right + gap,
      _ => center.dx - body.width / 2,
    };
    final y = switch (direction) {
      AxisDirection.up => anchor.top - gap - body.height,
      AxisDirection.down => anchor.bottom + gap,
      _ => center.dy - body.height / 2,
    };
    final origin = Offset(
      x.clamp(bounds.left, math.max(bounds.left, bounds.right - body.width)),
      y.clamp(bounds.top, math.max(bounds.top, bounds.bottom - body.height)),
    );
    double along(double value, double length) {
      final margin = math.min(
        NodeLaneTokens.groupRadius + NodeLaneTokens.space4,
        length / 2,
      );
      return value.clamp(margin, length - margin);
    }

    final target = anchor.center - origin;
    final apex = switch (direction) {
      AxisDirection.down => Offset(along(target.dx, body.width), -tip),
      AxisDirection.up => Offset(
        along(target.dx, body.width),
        body.height + tip,
      ),
      AxisDirection.right => Offset(-tip, along(target.dy, body.height)),
      AxisDirection.left => Offset(
        body.width + tip,
        along(target.dy, body.height),
      ),
      null => Offset.zero,
    };
    return (origin: origin - inset, direction: direction, tip: apex + inset);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) =>
      place(childSize).origin;

  @override
  bool shouldRelayout(_BubbleLayout old) =>
      old.bounds != bounds ||
      old.anchor != anchor ||
      old.width != width ||
      old.keepFieldVisible != keepFieldVisible;
}

class _BubbleOutline extends ShapeBorder {
  const _BubbleOutline(this.layout, this.line);
  final _BubbleLayout layout;
  final Color line;
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
  @override
  ShapeBorder scale(double t) => this;
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const h = NodeLaneTokens.bubbleTipHeight;
    final body = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect.deflate(h),
          const Radius.circular(NodeLaneTokens.groupRadius),
        ),
      );
    final frame = layout.place(rect.size);
    if (frame.direction == null) return body;
    final angle = switch (frame.direction!) {
      AxisDirection.down => 0.0,
      AxisDirection.up => math.pi,
      AxisDirection.left => math.pi / 2,
      AxisDirection.right => -math.pi / 2,
    };
    final tip = rect.topLeft + frame.tip;
    final transform = Matrix4.translationValues(tip.dx, tip.dy, 0)
      ..rotateZ(angle);
    final pointer = Path()
      ..moveTo(-10, h + 1)
      ..cubicTo(-5, h, -2, 0, 0, 0)
      ..cubicTo(2, 0, 5, h, 10, h + 1)
      ..close();
    return Path.combine(
      PathOperation.union,
      body,
      pointer.transform(transform.storage),
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect);
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) =>
      canvas.drawPath(
        getOuterPath(rect),
        Paint()
          ..color = line
          ..style = PaintingStyle.stroke
          ..strokeWidth = NodeLaneTokens.glassStroke,
      );
}

/// Common header commands. A panel can also put its own widgets in [NodeLaneBubbleHeading.actions].
enum NodeLaneBubbleAction {
  close,
  back,
  manage,
  done,
  reset,
  clear;

  Widget button(BuildContext context, VoidCallback? onPressed) {
    final material = MaterialLocalizations.of(context);
    final label = switch (this) {
      close => material.closeButtonTooltip,
      back => material.backButtonTooltip,
      manage => context.l10n.manage,
      done => context.l10n.action_done,
      reset => context.l10n.reset,
      clear => context.l10n.action_clear,
    };
    if (this == close) {
      return NodeLaneCloseButton(tooltip: label, onPressed: onPressed);
    }
    if (this == back) {
      return NodeLaneIconButton(
        icon: NodeLaneIcons.of(context).back,
        tooltip: label,
        style: NodeLaneIconButtonStyle.plain,
        onPressed: onPressed,
      );
    }
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size.square(NodeLaneTokens.minTapTarget),
        padding: const EdgeInsets.symmetric(horizontal: NodeLaneTokens.space8),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: NodeLaneTokens.of(context).label,
      ),
      onPressed: onPressed,
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class NodeLaneBubbleHeading extends StatelessWidget {
  const NodeLaneBubbleHeading(
    this.title, {
    super.key,
    this.actions = const [],
    this.closeButton,
    this.onDismiss,
    this.dismissEnabled = true,
    this.titleContent,
    this.subtitle,
  });
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? closeButton;
  final VoidCallback? onDismiss;
  final bool dismissEnabled;
  final Widget? titleContent;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(
      NodeLaneTokens.space16,
      NodeLaneTokens.space4,
      NodeLaneTokens.space8,
      NodeLaneTokens.space4,
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: DefaultTextStyle(
                  style: NodeLaneTokens.of(context).readerLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  child: titleContent ?? Text(title),
                ),
              ),
              if (subtitle?.isNotEmpty == true)
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: NodeLaneTokens.of(context).readerSecondary,
                ),
            ],
          ),
        ),
        ...actions,
        closeButton ??
            (NodeLaneBubbleFlow._isStep(context)
                    ? NodeLaneBubbleAction.back
                    : NodeLaneBubbleAction.close)
                .button(
                  context,
                  dismissEnabled
                      ? onDismiss ?? () => Navigator.maybePop(context)
                      : null,
                ),
      ],
    ),
  );
}

/// A fixed heading over a scrollable body; the route accounts for keyboard and safe area.
class NodeLaneBubblePanel extends StatelessWidget {
  const NodeLaneBubblePanel({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    this.closeButton,
    this.onDismiss,
    this.dismissEnabled = true,
    this.titleContent,
    this.footer,
  });
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? closeButton;
  final VoidCallback? onDismiss;
  final bool dismissEnabled;
  final Widget? titleContent;
  final Widget? footer;
  final Widget child;

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: dismissEnabled,
    child: LayoutBuilder(
      builder: (context, box) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NodeLaneBubbleHeading(
            title,
            subtitle: subtitle,
            actions: actions,
            closeButton: closeButton,
            onDismiss: onDismiss,
            dismissEnabled: dismissEnabled,
            titleContent: titleContent,
          ),
          Flexible(child: child),
          if (footer != null)
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: box.maxHeight * .42),
              child: SingleChildScrollView(
                primary: false,
                padding: NodeLaneTokens.sheetFooterPadding,
                child: footer!,
              ),
            ),
        ],
      ),
    ),
  );
}
