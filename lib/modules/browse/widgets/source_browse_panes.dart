import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// Each operation reveals a level. At smaller widths the newest levels win.
class SourceBrowsePanes extends StatelessWidget {
  const SourceBrowsePanes({
    super.key,
    required this.directory,
    this.website,
    this.book,
    this.lockParents = false,
    this.onDirectorySettled,
  }) : assert(book == null || website != null);

  final Widget directory;
  final Widget? website, book;
  final bool lockParents;
  final VoidCallback? onDirectorySettled;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final split = context.tabletPanesFit(width);
      final side = math.min(NodeLaneTokens.tabletSupportingWidth, width * .43);
      final triple = split && context.tabletPanesFit(width - side);
      final dirVisible = website == null || (split && (book == null || triple));
      final siteVisible = website != null && (book == null || split);
      final dirWidth = website != null && split ? side : width;
      final siteStart = split && (book == null || triple) ? side : 0.0;
      final siteWidth = book != null && split ? side : width - siteStart;
      final bookStart = split ? (triple ? side * 2 : side) : 0.0;
      Widget pane(
        Widget? child, {
        required double start,
        required double width,
        required bool interactive,
        bool divider = false,
        VoidCallback? onEnd,
      }) => NodeLaneMotionPane(
        start: start,
        width: width,
        viewport: constraints.maxWidth,
        interactive: interactive,
        onSettled: onEnd,
        child: child == null
            ? null
            : DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  border: divider
                      ? BorderDirectional(
                          start: BorderSide(
                            color: NodeLaneTokens.of(context).line,
                            width: NodeLaneTokens.glassStroke,
                          ),
                        )
                      : null,
                ),
                child: PrimaryScrollController.none(
                  child: child.key == null
                      ? child
                      : NodeLaneContentMotion(value: child.key, child: child),
                ),
              ),
      );

      return Stack(
        fit: StackFit.expand,
        children: [
          pane(
            directory,
            start: dirVisible ? 0 : -dirWidth,
            width: dirWidth,
            interactive: dirVisible && !lockParents,
            onEnd: onDirectorySettled,
          ),
          pane(
            website,
            start: website == null
                ? width
                : siteVisible
                ? siteStart
                : -siteWidth,
            width: siteWidth,
            interactive: siteVisible && !lockParents,
            divider: siteStart > 0,
          ),
          pane(
            book,
            start: book == null ? width : bookStart,
            width: width - bookStart,
            interactive: book != null,
            divider: bookStart > 0,
          ),
        ],
      );
    },
  );
}
