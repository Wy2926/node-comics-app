import 'package:flutter/material.dart';

/// Presentation tokens shared by mobile screens and Android navigation.
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
  static const space4 = 4.0, space8 = 8.0, space12 = 12.0;
  static const space16 = 16.0, space20 = 20.0, space24 = 24.0;
  static const gutter = space20, coverRadius = 10.0, controlRadius = 12.0;
  static const groupRadius = 18.0, capsuleRadius = 24.0;
  static const rowHeight = 56.0, iconSize = 24.0, smallIconSize = 20.0;
  static const avatarSize = 64.0, searchHeight = 48.0;
  static const coverAspectRatio = 1.43, shelfGap = 14.0;
  static const bookTitleSize = 15.0, captionSize = 12.0;
  // Measured against the 390-point detail overview in the iOS concept.
  static const detailGutter = 16.0, detailToolbarHeight = 44.0;
  static const detailCoverWidth = 132.0, detailCoverHeight = 188.0;
  static const detailActionHeight = 56.0, detailMoreHeight = 48.0;
  static const detailChipHeight = 32.0, chapterRowHeight = 72.0;
  static const detailSheetRadius = 32.0;
  static const detailSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(detailSheetRadius),
    ),
  );
  static const defaultMobileAccent = Color(0xff006eff);
  static const segmentInset = 3.0, segmentRadius = 10.0;
  static const pagePadding = EdgeInsets.fromLTRB(
    gutter,
    space8,
    gutter,
    space24,
  );
  static const headerPadding = EdgeInsets.fromLTRB(
    gutter,
    space8,
    gutter,
    space16,
  );
  static const groupPadding = EdgeInsets.all(space16);
  static const rowPadding = EdgeInsets.symmetric(
    horizontal: space16,
    vertical: space8,
  );
  static const modalRadius = 24.0, menuRadius = 16.0;
  static const minTapTarget = 44.0, menuItemHeight = 52.0;
  static const dialogMaxWidth = 480.0;
  static const modalInset = EdgeInsets.symmetric(horizontal: 20, vertical: 24);
  static const modalTitlePadding = EdgeInsets.fromLTRB(20, 20, 20, 12);
  static const modalContentPadding = EdgeInsets.fromLTRB(20, 0, 20, 20);
  static const modalActionsPadding = EdgeInsets.fromLTRB(12, 0, 12, 12);
  static const modalTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static NodeLaneTokens of(BuildContext context) =>
      fromTheme(Theme.of(context));

  static NodeLaneTokens fromTheme(ThemeData theme) {
    final dark = theme.brightness == Brightness.dark;
    final pureBlack = dark && theme.scaffoldBackgroundColor == Colors.black;
    return NodeLaneTokens(
      canvas: pureBlack
          ? Colors.black
          : dark
          ? const Color(0xff13171d)
          : const Color(0xfff5f6fa),
      surface: pureBlack
          ? const Color(0xff0a0a0a)
          : dark
          ? const Color(0xff1e242c)
          : Colors.white,
      soft: dark ? const Color(0xff292f39) : const Color(0xffebeef4),
      ink: dark ? const Color(0xfff0f3f8) : const Color(0xff171a21),
      muted: dark ? const Color(0xffa9b4c4) : const Color(0xff697180),
      line: dark ? const Color(0xff353e4a) : const Color(0xffe7eaf0),
      accent: theme.colorScheme.primary,
      onAccent: theme.colorScheme.onPrimary,
    );
  }

  Color get accentSoft =>
      Color.alphaBlend(accent.withValues(alpha: .11), surface);

  TextStyle get pageTitle => TextStyle(
    fontSize: 34,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -.6,
    color: ink,
  );
  TextStyle get title => modalTitleStyle.copyWith(color: ink, height: 1.25);
  TextStyle get detailTitle => TextStyle(
    fontSize: 26,
    letterSpacing: 0,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: ink,
  );
  TextStyle get detailMetadata =>
      TextStyle(fontSize: 15, height: 1.6, color: muted);
  TextStyle get detailSectionTitle => TextStyle(
    fontSize: 18,
    letterSpacing: 0,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: ink,
  );
  Color get detailChipSurface =>
      Color.alphaBlend(soft.withValues(alpha: .55), surface);
  TextStyle get body => TextStyle(fontSize: 16, height: 1.3, color: ink);
  TextStyle get label => TextStyle(
    fontSize: bookTitleSize,
    letterSpacing: 0,
    height: 1.25,
    fontWeight: FontWeight.w600,
    color: ink,
  );
  TextStyle get secondary =>
      TextStyle(fontSize: 13, letterSpacing: 0, height: 1.35, color: muted);
  TextStyle get caption =>
      TextStyle(fontSize: captionSize, height: 1.3, color: muted);
  TextStyle get sectionTitle => secondary.copyWith(fontWeight: FontWeight.w600);

  InputDecoration searchDecoration(
    String hint, {
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) => InputDecoration(
    hintText: hint,
    hintStyle: body.copyWith(color: muted),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: soft,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: space12,
      vertical: space12,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(controlRadius),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(controlRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(controlRadius),
      borderSide: BorderSide(color: accent, width: 1.5),
    ),
  );
}

/// Applied at the mobile app root so overlays on any navigator share tokens.
/// Route ownership, dismissal, scrolling and save semantics stay with callers.
ThemeData nodeLaneModalTheme(ThemeData base) {
  final colors = NodeLaneTokens.fromTheme(base);
  final dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(NodeLaneTokens.modalRadius),
    side: BorderSide(color: colors.line),
  );
  return base.copyWith(
    dialogTheme: base.dialogTheme.copyWith(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: dialogShape,
      insetPadding: NodeLaneTokens.modalInset,
      constraints: const BoxConstraints(
        minWidth: 280,
        maxWidth: NodeLaneTokens.dialogMaxWidth,
      ),
      clipBehavior: Clip.antiAlias,
      titleTextStyle: base.textTheme.titleLarge?.merge(
        NodeLaneTokens.modalTitleStyle.copyWith(color: colors.ink),
      ),
      contentTextStyle: base.textTheme.bodyMedium?.copyWith(color: colors.ink),
      actionsPadding: NodeLaneTokens.modalActionsPadding,
      barrierColor: Colors.black54,
    ),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      backgroundColor: colors.surface,
      modalBackgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      modalBarrierColor: Colors.black54,
      elevation: 0,
      modalElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(NodeLaneTokens.modalRadius),
        ),
        side: BorderSide(color: colors.line),
      ),
      clipBehavior: Clip.antiAlias,
      dragHandleColor: colors.muted,
      dragHandleSize: const Size(32, 4),
    ),
    popupMenuTheme: base.popupMenuTheme.copyWith(
      color: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NodeLaneTokens.menuRadius),
        side: BorderSide(color: colors.line),
      ),
      menuPadding: const EdgeInsets.all(6),
      textStyle: base.textTheme.bodyLarge?.copyWith(color: colors.ink),
      position: PopupMenuPosition.under,
    ),
  );
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
      data: nodeLaneModalTheme(base).copyWith(
        scaffoldBackgroundColor: colors.canvas,
        dividerColor: colors.line,
        listTileTheme: base.listTileTheme.copyWith(
          minLeadingWidth: 28,
          horizontalTitleGap: NodeLaneTokens.space12,
          selectedColor: colors.accent,
          selectedTileColor: colors.accentSoft,
          textColor: colors.ink,
          iconColor: colors.accent,
        ),
        badgeTheme: base.badgeTheme.copyWith(
          backgroundColor: colors.accent,
          textColor: colors.onAccent,
          textStyle: colors.caption,
          largeSize: 22,
        ),
        chipTheme: base.chipTheme.copyWith(
          selectedColor: colors.accentSoft,
          backgroundColor: colors.soft,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
          ),
          labelStyle: colors.label,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: colors.accent,
            minimumSize: const Size(
              NodeLaneTokens.minTapTarget,
              NodeLaneTokens.minTapTarget,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.accent,
            side: BorderSide(color: colors.line),
            minimumSize: const Size(
              NodeLaneTokens.minTapTarget,
              NodeLaneTokens.minTapTarget,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: NodeLaneTokens.space20,
              vertical: NodeLaneTokens.space12,
            ),
            textStyle: colors.label,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: colors.accent,
            foregroundColor: colors.onAccent,
            minimumSize: const Size(
              NodeLaneTokens.minTapTarget,
              NodeLaneTokens.minTapTarget,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: NodeLaneTokens.space20,
              vertical: NodeLaneTokens.space12,
            ),
            textStyle: colors.label,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
            ),
          ),
        ),
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
