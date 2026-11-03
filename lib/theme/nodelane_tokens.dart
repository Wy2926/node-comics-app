import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
    required this.searchSurface,
    required this.searchLine,
    required this.accent,
    required this.onAccent,
    this.usesGlass = false,
  });

  final Color canvas, surface, soft, ink, muted, line, accent, onAccent;
  final Color searchSurface, searchLine;
  final bool usesGlass;
  static const disclosureDuration = Duration(milliseconds: 200);
  static const space4 = 4.0, space8 = 8.0, space12 = 12.0;
  static const space16 = 16.0, space20 = 20.0, space24 = 24.0;
  static const gutter = space20, coverRadius = 10.0, controlRadius = 12.0;
  static const groupRadius = 18.0, capsuleRadius = 24.0;
  static const glassBlur = 16.0, glassStroke = .75;
  static const searchOpacity = .92, searchBlur = 8.0;
  static const searchShadowBlur = 4.0, searchShadowOffset = 2.0;
  static const rowHeight = 56.0, iconSize = 24.0, smallIconSize = 20.0;
  static const emptyStateIconSize = 48.0, progressTrackHeight = 3.0;
  static const formLabelWidth = 88.0;
  static const avatarSize = 64.0, searchHeight = 48.0;
  static const brandMarkSize = 80.0, brandCompactMarkSize = 40.0;
  static const accountHeroAvatarSize = 96.0, accountHeroIconSize = 56.0;
  static const coverAspectRatio = 1.43, shelfGap = 14.0;
  static const bookTitleSize = 15.0, captionSize = 12.0;
  static const shelfComfortableWidth = 168.0, shelfCompactWidth = 96.0;
  static const shelfThumbnailWidth = 64.0, shelfThumbnailHeight = 92.0;
  static const badgeHeight = 22.0, badgeIconSize = 14.0;
  static const choicePreviewHeight = 40.0;
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
  // Reader concept: all overlays use the same geometry, type and controls.
  static const readerSheetFraction = .78, readerDisplayFraction = .86;
  static const readerRowHeight = 62.0, readerModeRowHeight = 48.0;
  static const readerChapterHeight = 68.0, readerActionHeight = 64.0;
  static const readerImageActionHeight = 72.0;
  static const readerFilterRowHeight = 56.0;
  static const readerPickerRowHeight = 56.0;
  static const readerPickerPreviewRowHeight = 88.0;
  static const readerPickerColorRowHeight = 80.0;
  static const readerPickerLeadingWidth = 44.0, readerPickerSwatchSize = 40.0;
  static const readerValueSwatchSize = 28.0;
  static const readerPickerIconSize = 28.0;
  static const readerPickerPreviewSize = Size(42, 48);
  static const readerIconSize = 24.0, readerSliderTrack = 3.0;
  static const readerSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(modalRadius)),
  );
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
  static const buttonPadding = EdgeInsets.symmetric(
    horizontal: space20,
    vertical: space12,
  );
  static const rowPadding = EdgeInsets.symmetric(
    horizontal: space16,
    vertical: space8,
  );
  static const modalRadius = 24.0, menuRadius = 16.0;
  static const minTapTarget = 44.0, menuItemHeight = 52.0;
  static const catalogRowHeight = 72.0, websiteIconSize = 40.0;
  static const browserToolbarHeight = 56.0, browserTabHeight = 244.0;
  static const browserTabGap = 12.0;
  static const browserAddressHeight = 44.0, browserBackWidth = 64.0;
  static const browserTranslationWidth = 132.0, browserDisplayWidth = 176.0;
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
      searchSurface: dark ? const Color(0xff303844) : Colors.white,
      searchLine: dark ? const Color(0xff46505f) : const Color(0xffdde2e9),
      accent: theme.colorScheme.primary,
      onAccent: theme.colorScheme.onPrimary,
      usesGlass: theme.platform == TargetPlatform.iOS,
    );
  }

  Color get accentSoft =>
      Color.alphaBlend(accent.withValues(alpha: .11), surface);

  OutlinedBorder get buttonShape => usesGlass
      ? const StadiumBorder()
      : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(controlRadius),
        );

  BorderRadius get inputRadius =>
      BorderRadius.circular(usesGlass ? capsuleRadius : controlRadius);

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
  TextStyle get readerTitle =>
      title.copyWith(fontSize: 22, fontWeight: FontWeight.w700);
  TextStyle get readerLabel =>
      body.copyWith(fontSize: 17, fontWeight: FontWeight.w500);
  TextStyle get readerSecondary => secondary.copyWith(fontSize: 14);
  TextStyle get readerValue => body.copyWith(fontSize: 15, color: muted);
  TextStyle get caption =>
      TextStyle(fontSize: captionSize, height: 1.3, color: muted);
  TextStyle get sectionTitle => secondary.copyWith(fontWeight: FontWeight.w600);

  InputDecoration inputDecoration(
    String hint, {
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool formRow = false,
    bool search = false,
  }) => InputDecoration(
    hintText: hint,
    hintStyle: body.copyWith(color: muted),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: formRow
        ? surface
        : search
        ? searchSurface
        : soft,
    isDense: true,
    constraints: BoxConstraints(minHeight: formRow ? rowHeight : searchHeight),
    prefixIconConstraints: BoxConstraints(
      minWidth: searchHeight,
      minHeight: formRow ? rowHeight : searchHeight,
    ),
    suffixIconConstraints: const BoxConstraints(
      minWidth: minTapTarget,
      minHeight: searchHeight,
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: space16,
      vertical: space12,
    ),
    border: formRow
        ? InputBorder.none
        : OutlineInputBorder(
            borderRadius: inputRadius,
            borderSide: search
                ? BorderSide(color: searchLine, width: glassStroke)
                : BorderSide.none,
          ),
    enabledBorder: formRow
        ? InputBorder.none
        : OutlineInputBorder(
            borderRadius: inputRadius,
            borderSide: search
                ? BorderSide(color: searchLine, width: glassStroke)
                : BorderSide.none,
          ),
    focusedBorder: formRow
        ? InputBorder.none
        : OutlineInputBorder(
            borderRadius: inputRadius,
            borderSide: search
                ? BorderSide(color: searchLine, width: glassStroke)
                : BorderSide(color: accent, width: 1.5),
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
  final buttonStyle = ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(
      Size(NodeLaneTokens.minTapTarget, NodeLaneTokens.minTapTarget),
    ),
    shape: WidgetStatePropertyAll(colors.buttonShape),
    textStyle: WidgetStatePropertyAll(colors.label),
    padding: const WidgetStatePropertyAll(NodeLaneTokens.buttonPadding),
  );
  final input = colors.inputDecoration('');
  return base.copyWith(
    cupertinoOverrideTheme:
        (base.cupertinoOverrideTheme ?? const CupertinoThemeData()).copyWith(
          primaryColor: colors.accent,
          applyThemeToAll: true,
        ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: colors.accent)
          .merge(buttonStyle),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.accent,
        foregroundColor: colors.onAccent,
      ).merge(buttonStyle),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.accent,
        side: BorderSide(color: colors.line),
      ).merge(buttonStyle),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.soft,
        foregroundColor: colors.accent,
        elevation: 0,
      ).merge(buttonStyle),
    ),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      filled: input.filled,
      fillColor: input.fillColor,
      border: input.border,
      enabledBorder: input.enabledBorder,
      focusedBorder: input.focusedBorder,
      contentPadding: input.contentPadding,
      constraints: input.constraints,
      prefixIconConstraints: input.prefixIconConstraints,
      suffixIconConstraints: input.suffixIconConstraints,
      hintStyle: input.hintStyle,
      isDense: input.isDense,
    ),
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
        borderRadius: BorderRadius.circular(
          colors.usesGlass
              ? NodeLaneTokens.capsuleRadius
              : NodeLaneTokens.menuRadius,
        ),
        side: BorderSide(color: colors.line),
      ),
      menuPadding: const EdgeInsets.all(6),
      textStyle: base.textTheme.bodyLarge?.copyWith(color: colors.ink),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => colors.readerLabel.copyWith(
          color: states.contains(WidgetState.disabled)
              ? colors.muted
              : colors.ink,
        ),
      ),
      position: PopupMenuPosition.under,
    ),
  );
}

/// Page colors and the shared control theme; surface materials own their effects.
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
