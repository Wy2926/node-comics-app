import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// The route owns focus and dismissal. Only the bubble animates; the native
/// page underneath stays in its original layer.
Future<T?> showNodeLaneBubble<T>(
  BuildContext anchor, {
  required String label,
  required Widget child,
  double width = NodeLaneTokens.menuMaxWidth,
  Offset? localPoint,
  bool requestFocus = true,
}) {
  final navigator = Navigator.of(anchor, rootNavigator: true);
  final overlay = navigator.overlay!.context.findRenderObject()! as RenderBox;
  final themes = InheritedTheme.capture(from: anchor, to: navigator.context);
  final box = anchor.findRenderObject()! as RenderBox;
  Rect measure() => localPoint == null
      ? box.localToGlobal(Offset.zero, ancestor: overlay) & box.size
      : box.localToGlobal(localPoint, ancestor: overlay) & Size.zero;
  var lastRect = measure();
  return navigator.push<T>(
    RawDialogRoute<T>(
      barrierLabel: MaterialLocalizations.of(anchor).menuDismissLabel,
      barrierColor: NodeLaneTokens.bubbleBarrier,
      requestFocus: requestFocus,
      transitionDuration: NodeLaneMotion.time(anchor),
      transitionBuilder: (_, _, _, page) => page,
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
            final bounds = safe.deflate(NodeLaneTokens.space8);
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
            final above = (rect.top - 3).clamp(bounds.top, bounds.bottom);
            final below = (rect.bottom + 3).clamp(bounds.top, bounds.bottom);
            final down = bounds.bottom - below >= above - bounds.top;
            final height = down ? bounds.bottom - below : above - bounds.top;
            final pivot = Alignment(tip / w * 2 - 1, down ? -1 : 1);
            final motion = animation.drive(
              CurveTween(curve: NodeLaneMotion.curve),
            );
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
                    child: FadeTransition(
                      opacity: animation.drive(
                        CurveTween(
                          curve: const Interval(0, .72, curve: Curves.easeOut),
                        ),
                      ),
                      child: ScaleTransition(
                        alignment: pivot,
                        scale: motion.drive(Tween(begin: .93, end: 1.0)),
                        child: Material(
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
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

/// A compact home with a local history for multi-step tools. The outer route
/// keeps the original anchor; Back and barrier taps must honor the active form.
class NodeLaneBubbleFlow extends StatefulWidget {
  const NodeLaneBubbleFlow({super.key, required this.home});
  final Widget home;

  static bool contains(BuildContext context) =>
      context.findAncestorStateOfType<_NodeLaneBubbleFlowState>() != null;

  static Future<T?> push<T>(BuildContext context, Widget step) => context
      .findAncestorStateOfType<_NodeLaneBubbleFlowState>()!
      ._push<T>(context, step);

  @override
  State<NodeLaneBubbleFlow> createState() => _NodeLaneBubbleFlowState();
}

class _NodeLaneBubbleFlowState extends State<NodeLaneBubbleFlow> {
  final _navigator = GlobalKey<NavigatorState>();
  Route<dynamic>? _first;

  Future<T?> _push<T>(BuildContext origin, Widget step) async {
    final navigator = _navigator.currentState;
    if (ModalRoute.isCurrentOf(origin) != true ||
        (navigator != null && Navigator.of(origin) != navigator)) {
      return null;
    }
    final route = MaterialPageRoute<T>(builder: (_) => step);
    if (navigator != null) return navigator.push(route);
    if (_first != null) return null;
    setState(() => _first = route);
    try {
      return await route.popped;
    } finally {
      if (mounted) setState(() => _first = null);
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Visibility(
        visible: _first == null,
        maintainState: true,
        child: widget.home,
      ),
      if (_first != null)
        NavigatorPopHandler<Object?>(
          onPopWithResult: (_) => _navigator.currentState?.maybePop(),
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
                  MaterialPageRoute<void>(
                    builder: (_) => const SizedBox.shrink(),
                  ),
                  _first!,
                ],
              ),
            ),
          ),
        ),
    ],
  );
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
