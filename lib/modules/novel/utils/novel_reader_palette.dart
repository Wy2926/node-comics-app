import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// Existing reader palettes shared by the global and in-reader views.
enum NovelReaderThemePreset {
  dark('#292832', '#CCCCCC'),
  light('#FFFFFF', '#000000'),
  black('#000000', '#FFFFFF'),
  sepia('#F5E6D3', '#5F4B32');

  const NovelReaderThemePreset(this.background, this.text);
  final String background, text;

  String label(BuildContext context) => switch (this) {
    dark => context.l10n.theme_dark,
    light => context.l10n.theme_light,
    black => context.l10n.theme_black,
    sepia => context.l10n.theme_sepia,
  };
}

final novelReaderColorPalette = List<Color>.unmodifiable([
  Colors.white,
  Colors.black,
  const Color(0xFF292832),
  const Color(0xFFF5E6D3),
  const Color(0xFF5F4B32),
  const Color(0xFFCCCCCC),
  Colors.grey[800]!,
  Colors.grey[300]!,
  Colors.brown[100]!,
  Colors.blue[100]!,
  Colors.green[100]!,
  Colors.amber[100]!,
]);
