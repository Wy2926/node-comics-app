import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
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
      ? box.localToGlobal(Offset.zero, ancestor: overlay) & box.size
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
            final w = math.min(width, bounds.width);
            final left = (rect.center.dx - w / 2).clamp(
              bounds.left,
              bounds.right - w,
            );
            final tip = (rect.center.dx - left)
                .clamp(math.min(22, w / 2), math.max(w - 22, w / 2))
                .toDouble();
            var above = (rect.top - 3).clamp(bounds.top, bounds.bottom);
            var below = (rect.bottom + 3).clamp(bounds.top, bounds.bottom);
            final down = bounds.bottom - below >= above - bounds.top;
            // A focused form can overlap its trigger. Menus which leave focus in
            // an underlying text field must leave that field visible.
            if (requestFocus) {
              final needed = math.min(
                bounds.height,
                3 *
                    NodeLaneTokens.minTapTarget *
                    math.max(1, media.textScaler.scale(16) / 16),
              );
              if (down) {
                below = math.min(below, bounds.bottom - needed);
              } else {
                above = math.max(above, bounds.top + needed);
              }
            }
            final height = down ? bounds.bottom - below : above - bounds.top;
            final pivot = Alignment(tip / w * 2 - 1, down ? -1 : 1);
            final colors = NodeLaneTokens.of(context);
            return Stack(
              children: [
                Positioned(
                  left: left,
                  width: w,
                  top: down ? below : null,
                  bottom: down ? null : size.height - above,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: math.min(
                        NodeLaneTokens.bubbleMaxHeight,
                        height,
                      ),
                    ),
                    child: NodeLaneMotion.anchored(
                      context,
                      animation,
                      pivot,
                      Material(
                        color: colors.surface,
                        surfaceTintColor: Colors.transparent,
                        elevation: 7,
                        shadowColor: Colors.black26,
                        animationDuration: Duration.zero,
                        shape: _BubbleOutline(down, tip, colors.line),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: down ? NodeLaneTokens.bubbleTipHeight : 0,
                            bottom: down ? 0 : NodeLaneTokens.bubbleTipHeight,
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
                ),
              ],
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

  static Future<T?> open<T>(
    BuildContext anchor, {
    required String title,
    required Widget child,
    Offset? localPoint,
    double width = NodeLaneTokens.bubbleFormWidth,
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

class _BubbleOutline extends ShapeBorder {
  const _BubbleOutline(this.down, this.tip, this.line);
  final bool down;
  final double tip;
  final Color line;
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
  @override
  ShapeBorder scale(double t) => this;
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final body = EdgeInsets.only(
      top: down ? NodeLaneTokens.bubbleTipHeight : 0,
      bottom: down ? 0 : NodeLaneTokens.bubbleTipHeight,
    ).deflateRect(rect);
    final x = rect.left + tip,
        y = down ? body.top : body.bottom,
        sign = down ? -1.0 : 1.0;
    final tipY = y + sign * NodeLaneTokens.bubbleTipHeight;
    final pointer = Path()
      ..moveTo(x - 10, y - sign)
      ..cubicTo(x - 5, y, x - 2, tipY, x, tipY)
      ..cubicTo(x + 2, tipY, x + 5, y, x + 10, y - sign)
      ..close();
    return Path.combine(
      PathOperation.union,
      Path()..addRRect(
        RRect.fromRectAndRadius(
          body,
          const Radius.circular(NodeLaneTokens.groupRadius),
        ),
      ),
      pointer,
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

class NodeLaneBubbleHeading extends StatelessWidget {
  const NodeLaneBubbleHeading(
    this.title, {
    super.key,
    this.actions = const [],
    this.closeButton,
    this.subtitle,
  });
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? closeButton;
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
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: NodeLaneTokens.of(context).readerLabel,
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
            NodeLaneCloseButton(
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: () => Navigator.maybePop(context),
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
    this.footer,
  });
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? closeButton;
  final Widget? footer;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NodeLaneBubbleHeading(
          title,
          subtitle: subtitle,
          actions: actions,
          closeButton: closeButton,
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
  );
}
