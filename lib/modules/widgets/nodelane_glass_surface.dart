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
    this.fillColor,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final bool elevated, grouped;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final glass = t.usesGlass && !MediaQuery.highContrastOf(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fill = fillColor ?? (grouped ? t.canvas : t.surface);
    final content = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: glass ? null : fill,
        gradient: glass
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
          color: glass
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
                  color: Colors.black.withValues(alpha: dark ? .16 : .06),
                  blurRadius: NodeLaneTokens.space12,
                  offset: const Offset(0, NodeLaneTokens.space4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: glass
            ? BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: NodeLaneTokens.glassBlur,
                  sigmaY: NodeLaneTokens.glassBlur,
                ),
                child: content,
              )
            : content,
      ),
    );
  }
}
