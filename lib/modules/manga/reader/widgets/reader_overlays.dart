import 'package:flutter/material.dart';

import '../settings/comic_reader_scope.dart';
import '../settings/comic_reader_preferences.dart';
import 'reader_gesture_handler.dart';
import 'reader_interactive_region.dart';

class ReaderOverlays extends StatelessWidget {
  const ReaderOverlays({
    super.key,
    required this.isReverseHorizontal,
    required this.hasCurrentPageImageError,
    required this.isContinuousMode,
    required this.onToggleUI,
    required this.onPreviousPage,
    required this.onNextPage,
  });
  final bool isReverseHorizontal, hasCurrentPageImageError, isContinuousMode;
  final VoidCallback onToggleUI, onPreviousPage, onNextPage;
  @override
  Widget build(BuildContext context) {
    final settings = ComicReaderScope.of(context);
    return ReaderInteractiveHitTestBlocker(
      child: ReaderGestureHandler(
        usePageTapZones: settings.habits.tapToTurn,
        isRTL: isReverseHorizontal,
        hasImageError: hasCurrentPageImageError,
        isContinuousMode: isContinuousMode,
        vertical: isContinuousMode || settings.profile.turn == ComicPageTurn.up,
        onToggleUI: onToggleUI,
        onPreviousPage: onPreviousPage,
        onNextPage: onNextPage,
      ),
    );
  }
}
