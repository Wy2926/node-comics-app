import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';

import 'comic_reader_preferences.dart';

/// Rendering consumes a resolved profile, with no persistence or UI dependency.
class ComicReaderScope extends InheritedWidget {
  const ComicReaderScope({
    super.key,
    required this.profile,
    required this.habits,
    required super.child,
  });
  final ComicReadingProfile profile;
  final ComicReaderHabits habits;
  static ComicReaderScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ComicReaderScope>()!;
  @override
  bool updateShouldNotify(ComicReaderScope oldWidget) =>
      profile != oldWidget.profile || habits != oldWidget.habits;
}

extension ComicReadingRuntime on ComicReadingProfile {
  ReaderMode get readerMode => mode == ComicReadingMode.scroll
      ? ReaderMode.webtoon
      : switch (turn) {
          ComicPageTurn.left => ReaderMode.ltr,
          ComicPageTurn.right => ReaderMode.rtl,
          ComicPageTurn.up => ReaderMode.vertical,
        };
  BoxFit get boxFit => switch (fit) {
    ComicPageFit.contain => BoxFit.contain,
    ComicPageFit.width => BoxFit.fitWidth,
    ComicPageFit.height => BoxFit.fitHeight,
  };
}

extension ComicCanvasColor on ComicCanvas {
  Color color(BuildContext context) => switch (this) {
    ComicCanvas.system => Theme.of(context).scaffoldBackgroundColor,
    ComicCanvas.black => Colors.black,
    ComicCanvas.gray => const Color(0xff303030),
    ComicCanvas.paper => const Color(0xfff5f1e8),
  };
}
