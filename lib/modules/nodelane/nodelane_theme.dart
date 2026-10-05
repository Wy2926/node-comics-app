import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

/// Flutter mapping of the extension's ui/theme/tokens.css and surfaces.css.
/// Keep these semantic colors and comic shapes aligned with that source.
abstract final class NodeLaneTheme {
  static int get schemeIndex => FlexColor.schemesList.length;
  static const panelRadius = BorderRadius.only(
    topLeft: Radius.circular(8),
    topRight: Radius.circular(24),
    bottomLeft: Radius.circular(24),
    bottomRight: Radius.circular(24),
  );
  static const cardRadius = BorderRadius.only(
    topLeft: Radius.circular(5),
    topRight: Radius.circular(16),
    bottomLeft: Radius.circular(16),
    bottomRight: Radius.circular(16),
  );
  static const controlRadius = BorderRadius.all(Radius.circular(5));

  static ThemeData apply(ThemeData base, {bool? pureBlack}) {
    final dark = base.brightness == Brightness.dark;
    final black =
        pureBlack ??
        (dark &&
            base.scaffoldBackgroundColor == Colors.black &&
            base.colorScheme.surface == Colors.black);
    final ink = dark ? const Color(0xffedf2fc) : const Color(0xff202d43);
    final muted = dark ? const Color(0xffb0bdd1) : const Color(0xff5e6d82);
    final accent = dark ? const Color(0xff8dc7ff) : const Color(0xff1769b3);
    final paper = black
        ? Colors.black
        : dark
        ? const Color(0xff1d2737)
        : Colors.white;
    final soft = black
        ? Colors.black
        : dark
        ? const Color(0xff263246)
        : const Color(0xfff0f3f8);
    final colors = base.colorScheme.copyWith(
      primary: accent,
      onPrimary: dark ? const Color(0xff132b43) : Colors.white,
      primaryContainer: dark
          ? const Color(0xff253e58)
          : const Color(0xffeaf3ff),
      onPrimaryContainer: ink,
      secondary: accent,
      onSecondary: dark ? const Color(0xff132b43) : Colors.white,
      surface: paper,
      onSurface: ink,
      onSurfaceVariant: muted,
      surfaceContainerLowest: paper,
      surfaceContainerLow: soft,
      surfaceContainer: soft,
      surfaceContainerHigh: soft,
      surfaceContainerHighest: soft,
      outline: dark ? const Color(0xff3b485d) : const Color(0xffdce3ed),
      error: dark ? const Color(0xffffacb5) : const Color(0xffaf3845),
      errorContainer: dark ? const Color(0xff452b35) : const Color(0xfffff0f1),
      onErrorContainer: dark
          ? const Color(0xffffacb5)
          : const Color(0xffaf3845),
    );
    final button = ButtonStyle(
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: controlRadius),
      ),
      side: WidgetStateProperty.resolveWith(
        (states) => BorderSide(
          color: states.contains(WidgetState.disabled)
              ? colors.outline
              : stroke(colors),
          width: 2,
        ),
      ),
      minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      elevation: const WidgetStatePropertyAll(0),
    );
    final text = base.textTheme.apply(bodyColor: ink, displayColor: ink);
    return base.copyWith(
      colorScheme: colors,
      primaryColor: accent,
      scaffoldBackgroundColor: black
          ? Colors.black
          : dark
          ? const Color(0xff151b27)
          : const Color(0xfff6f8fc),
      dividerColor: colors.outline,
      textTheme: text.copyWith(
        titleLarge: text.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        headlineSmall: text.headlineSmall?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: text.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
        bodyMedium: text.bodyMedium?.copyWith(fontSize: 14, height: 1.5),
        bodySmall: text.bodySmall?.copyWith(
          fontSize: 12,
          color: muted,
          height: 1.6,
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: paper,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: paper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: cardRadius,
          side: BorderSide(color: stroke(colors), width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(style: button),
      outlinedButtonTheme: OutlinedButtonThemeData(style: button),
      elevatedButtonTheme: ElevatedButtonThemeData(style: button),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: paper,
        border: OutlineInputBorder(
          borderRadius: controlRadius,
          borderSide: BorderSide(color: colors.outline, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: controlRadius,
          borderSide: BorderSide(color: colors.outline, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: controlRadius,
          borderSide: BorderSide(color: accent, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: controlRadius,
          borderSide: BorderSide(color: colors.outline, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: controlRadius,
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: controlRadius,
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: paper,
        indicatorColor: colors.primaryContainer,
      ),
    );
  }

  static Color stroke(ColorScheme colors) =>
      colors.brightness == Brightness.dark
      ? const Color(0xff53627a)
      : colors.onSurface;

  static BoxDecoration panel(ColorScheme colors, {bool accented = false}) =>
      BoxDecoration(
        color: accented ? colors.primaryContainer : colors.surface,
        borderRadius: panelRadius,
        border: Border.all(color: stroke(colors), width: 2),
        boxShadow: [
          BoxShadow(
            color: colors.brightness == Brightness.dark
                ? const Color(0xff080f1a)
                : colors.onSurface,
            offset: const Offset(4, 4),
          ),
        ],
      );

  static BoxDecoration action(ColorScheme colors, {required bool enabled}) =>
      BoxDecoration(
        borderRadius: controlRadius,
        boxShadow: [
          BoxShadow(
            color: colors.brightness == Brightness.dark
                ? (enabled ? const Color(0xff080f1a) : const Color(0xff101722))
                : (enabled ? stroke(colors) : colors.outline),
            offset: enabled ? const Offset(4, 4) : const Offset(2, 2),
          ),
        ],
      );
}
