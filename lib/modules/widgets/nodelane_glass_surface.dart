import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// A bounded Flutter material for floating controls and sheets. Content rows
/// keep their solid surfaces; the native iOS tab bar keeps its UIKit material.
class NodeLaneGlassSurface extends StatelessWidget {
  const NodeLaneGlassSurface({
    super.key,
    required this.child,
    required this.borderRadius,
    this.elevated = false,
    this.grouped = false,
    this.input = false,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final bool elevated, grouped;

  /// Neutral, evenly filled material for readable floating input fields.
  final bool input;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final glass = t.usesGlass && !MediaQuery.highContrastOf(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fill = input
        ? t.searchSurface
        : grouped
        ? t.canvas
        : t.surface;
    final content = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: glass && input
            ? fill.withValues(alpha: NodeLaneTokens.searchOpacity)
            : glass
            ? null
            : fill,
        gradient: glass && !input
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  fill.withValues(alpha: grouped ? .97 : .82),
                  fill.withValues(alpha: grouped ? .95 : .70),
                ],
              )
            : null,
        border: Border.all(
          width: NodeLaneTokens.glassStroke,
          color: input
              ? MediaQuery.highContrastOf(context)
                    ? t.muted
                    : t.searchLine
              : glass
              ? Colors.white.withValues(alpha: dark ? .16 : .8)
              : t.line,
        ),
      ),
      child: Material(type: MaterialType.transparency, child: child),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: elevated && glass
            ? [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: input ? (dark ? .12 : .04) : (dark ? .16 : .06),
                  ),
                  blurRadius: input
                      ? NodeLaneTokens.searchShadowBlur
                      : NodeLaneTokens.space12,
                  offset: Offset(
                    0,
                    input
                        ? NodeLaneTokens.searchShadowOffset
                        : NodeLaneTokens.space4,
                  ),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: glass
            ? BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: input
                      ? NodeLaneTokens.searchBlur
                      : NodeLaneTokens.glassBlur,
                  sigmaY: input
                      ? NodeLaneTokens.searchBlur
                      : NodeLaneTokens.glassBlur,
                ),
                child: content,
              )
            : content,
      ),
    );
  }
}
