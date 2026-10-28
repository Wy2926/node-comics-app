import 'package:flutter/material.dart';

/// Presentation tokens shared by the mobile shelf and Android navigation.
/// The user's existing accent and font preferences remain authoritative.
class NodeLaneTokens {
  const NodeLaneTokens({
    required this.canvas,
    required this.surface,
    required this.soft,
    required this.ink,
    required this.muted,
    required this.line,
    required this.accent,
    required this.onAccent,
  });

  final Color canvas, surface, soft, ink, muted, line, accent, onAccent;
  static const gutter = 20.0, coverRadius = 14.0, controlRadius = 12.0;

  static NodeLaneTokens of(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final pureBlack = dark && theme.scaffoldBackgroundColor == Colors.black;
    return NodeLaneTokens(
      canvas: pureBlack
          ? Colors.black
          : dark
          ? const Color(0xff13171d)
          : const Color(0xfff7f8fa),
      surface: pureBlack
          ? const Color(0xff0a0a0a)
          : dark
          ? const Color(0xff1e242c)
          : Colors.white,
      soft: dark ? const Color(0xff292f39) : const Color(0xffedf0f4),
      ink: dark ? const Color(0xfff0f3f8) : const Color(0xff202b3a),
      muted: dark ? const Color(0xffa9b4c4) : const Color(0xff637084),
      line: dark ? const Color(0xff353e4a) : const Color(0xffe0e5ed),
      accent: theme.colorScheme.primary,
      onAccent: theme.colorScheme.onPrimary,
    );
  }

  Color get accentSoft =>
      Color.alphaBlend(accent.withValues(alpha: .11), surface);
}

/// No fonts, image assets, or blur layers are added by the mobile visual system.
class NodeLaneSurface extends StatelessWidget {
  const NodeLaneSurface({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final base = Theme.of(context);
    return Theme(
      data: base.copyWith(
        scaffoldBackgroundColor: colors.canvas,
        dividerColor: colors.line,
        appBarTheme: base.appBarTheme.copyWith(
          backgroundColor: colors.canvas,
          foregroundColor: colors.ink,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      child: child,
    );
  }
}
