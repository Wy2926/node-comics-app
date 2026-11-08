import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

IconData getReaderModeIcon(ReaderMode mode, BuildContext context) {
  final icons = NodeLaneIcons.of(context);
  return switch (mode) {
    ReaderMode.vertical => icons.manga,
    ReaderMode.ltr => icons.readingRight,
    ReaderMode.rtl => icons.readingLeft,
    ReaderMode.verticalContinuous => icons.continuousVertical,
    ReaderMode.webtoon => icons.pageLayout,
    ReaderMode.horizontalContinuous => icons.manga,
    ReaderMode.horizontalContinuousRTL => icons.horizontalPages,
  };
}

String getReaderModeName(ReaderMode readerMode, BuildContext context) {
  return switch (readerMode) {
    ReaderMode.vertical => context.l10n.reading_mode_vertical,
    ReaderMode.verticalContinuous =>
      context.l10n.reading_mode_vertical_continuous,
    ReaderMode.ltr => context.l10n.reading_mode_left_to_right,
    ReaderMode.rtl => context.l10n.reading_mode_right_to_left,
    ReaderMode.horizontalContinuous => context.l10n.horizontal_continious,
    ReaderMode.horizontalContinuousRTL =>
      "${context.l10n.horizontal_continious} (RTL)",
    _ => context.l10n.reading_mode_webtoon,
  };
}

String getChapterSwipeActionName(
  ChapterSwipeAction action,
  BuildContext context,
) {
  return switch (action) {
    ChapterSwipeAction.toggleBookmark =>
      context.l10n.chapter_swipe_toggle_bookmark,
    ChapterSwipeAction.toggleRead => context.l10n.chapter_swipe_toggle_read,
    ChapterSwipeAction.download => context.l10n.chapter_swipe_download,
    ChapterSwipeAction.disabled => context.l10n.chapter_swipe_disabled,
  };
}
