import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Continuous progress shared by NodeLane pages, menus and notices.
class NodeLaneProgress extends StatelessWidget {
  const NodeLaneProgress({super.key, this.value, this.semanticsLabel});
  final double? value;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    return LinearProgressIndicator(
      value: value?.clamp(0, 1),
      semanticsLabel: semanticsLabel,
      minHeight: NodeLaneTokens.progressTrackHeight,
      borderRadius: BorderRadius.circular(NodeLaneTokens.progressTrackHeight),
      color: t.accent,
      backgroundColor: t.line,
      trackGap: 0,
      stopIndicatorRadius: 0,
    );
  }
}
