import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// Both controls keep their elements (and input focus) when the second wraps.
class NodeLaneToolbarPair extends StatelessWidget {
  const NodeLaneToolbarPair({
    super.key,
    required this.first,
    required this.second,
    this.gap = NodeLaneTokens.space16,
    this.alignment = WrapCrossAlignment.center,
  });
  final Widget first, second;
  final double gap;
  final WrapCrossAlignment alignment;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = context.tabletPanesFit(constraints.maxWidth)
          ? (constraints.maxWidth - gap) / 2
          : constraints.maxWidth;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        crossAxisAlignment: alignment,
        children: [
          SizedBox(width: width, child: first),
          SizedBox(width: width, child: second),
        ],
      );
    },
  );
}

class NodeLaneFormColumn extends StatelessWidget {
  const NodeLaneFormColumn({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    heightFactor: 1,
    child: SizedBox(
      width: context.isAndroidTablet
          ? NodeLaneTokens.tabletFormWidth
          : double.infinity,
      child: child,
    ),
  );
}

/// The body stays in the same slot when the supporting pane opens or closes.
class NodeLanePaneLayout extends StatelessWidget {
  const NodeLanePaneLayout({
    super.key,
    required this.pane,
    required this.body,
    this.paneWidth = NodeLaneTokens.tabletSupportingWidth,
    this.useAvailableWidth = false,
  });

  final WidgetBuilder? pane;
  final Widget Function(BuildContext, bool split) body;
  final double paneWidth;
  final bool useAvailableWidth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final split =
          pane != null &&
          (useAvailableWidth
              ? context.hasPaneWidth(constraints.maxWidth)
              : context.tabletPanesFit(constraints.maxWidth));
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (split) ...[
            SizedBox(
              width: math.min(
                paneWidth,
                constraints.maxWidth * NodeLaneTokens.paneMaxFraction,
              ),
              child: PrimaryScrollController.none(child: pane!(context)),
            ),
            VerticalDivider(
              width: NodeLaneTokens.glassStroke,
              thickness: NodeLaneTokens.glassStroke,
              color: NodeLaneTokens.of(context).line,
            ),
          ],
          Expanded(child: body(context, split)),
        ],
      );
    },
  );
}
