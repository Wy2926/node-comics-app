import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class ReaderGestureHandler extends StatelessWidget {
  /// Whether tap zones are enabled for navigation
  final bool usePageTapZones;

  /// Whether the reader is in RTL mode
  final bool isRTL;

  /// Whether there's an image loading error
  final bool hasImageError;

  /// Whether the reader is in continuous scroll mode
  final bool isContinuousMode;

  final bool vertical;

  /// Callback when UI should be toggled
  final VoidCallback onToggleUI;

  /// Callback to go to previous page
  final VoidCallback onPreviousPage;

  /// Callback to go to next page
  final VoidCallback onNextPage;

  /// Callback for double-tap to zoom (with position)
  final void Function(Offset position)? onDoubleTapDown;

  /// Callback for double-tap gesture complete
  final VoidCallback? onDoubleTap;

  /// Callback for secondary tap (right-click on desktop)
  final void Function(Offset position)? onSecondaryTapDown;

  /// Callback for secondary tap complete
  final VoidCallback? onSecondaryTap;

  const ReaderGestureHandler({
    super.key,
    required this.usePageTapZones,
    required this.isRTL,
    required this.hasImageError,
    required this.isContinuousMode,
    required this.onToggleUI,
    required this.onPreviousPage,
    required this.onNextPage,
    this.vertical = false,
    this.onDoubleTapDown,
    this.onDoubleTap,
    this.onSecondaryTapDown,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (hasImageError && !isContinuousMode) {
      // When the visible page has an error:
      // - The center box (25% to 65% height, 20% to 80% width) is left empty
      //   so hit-tests fall straight through to the Retry button.
      // - Top & bottom center zones trigger onToggleUI (to show/hide menus).
      // - Left & right strips allow page navigation.
      final topHeight = context.height(0.25);
      final bottomHeight = context.height(0.35);
      final sideWidth = context.width(0.20);
      final prevAction = _prev();
      final nextAction = _next();

      return Stack(
        children: [
          // Top zone: left/right turn pages, center toggles UI
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topHeight,
            child: Row(
              children: [
                SizedBox(width: sideWidth, child: _zone(prevAction)),
                Expanded(child: _uiZone()),
                SizedBox(width: sideWidth, child: _zone(nextAction)),
              ],
            ),
          ),
          // Bottom zone: left/right turn pages, center toggles UI
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: bottomHeight,
            child: Row(
              children: [
                SizedBox(width: sideWidth, child: _zone(prevAction)),
                Expanded(child: _uiZone()),
                SizedBox(width: sideWidth, child: _zone(nextAction)),
              ],
            ),
          ),
          // Left middle strip (between top and bottom)
          Positioned(
            top: topHeight,
            bottom: bottomHeight,
            left: 0,
            width: sideWidth,
            child: _zone(prevAction),
          ),
          // Right middle strip (between top and bottom)
          Positioned(
            top: topHeight,
            bottom: bottomHeight,
            right: 0,
            width: sideWidth,
            child: _zone(nextAction),
          ),
        ],
      );
    }

    return vertical
        ? Column(
            children: [
              Expanded(child: _zone(onPreviousPage)),
              Expanded(child: _uiZone()),
              Expanded(child: _zone(onNextPage)),
            ],
          )
        : Row(
            children: [
              Expanded(child: _zone(_prev())),
              Expanded(child: _uiZone()),
              Expanded(child: _zone(_next())),
            ],
          );
  }

  VoidCallback _prev() => isRTL ? onNextPage : onPreviousPage;
  VoidCallback _next() => isRTL ? onPreviousPage : onNextPage;

  _ZoneGestureDetector _zone(VoidCallback onTap) => _ZoneGestureDetector(
    onTap: usePageTapZones ? onTap : onToggleUI,
    onDoubleTapDown: isContinuousMode ? onDoubleTapDown : null,
    onDoubleTap: isContinuousMode ? onDoubleTap : null,
    onSecondaryTapDown: isContinuousMode ? onSecondaryTapDown : null,
    onSecondaryTap: isContinuousMode ? onSecondaryTap : null,
  );

  _ZoneGestureDetector _uiZone() => _ZoneGestureDetector(
    onTap: onToggleUI,
    onDoubleTapDown: isContinuousMode ? onDoubleTapDown : null,
    onDoubleTap: isContinuousMode ? onDoubleTap : null,
    onSecondaryTapDown: isContinuousMode ? onSecondaryTapDown : null,
    onSecondaryTap: isContinuousMode ? onSecondaryTap : null,
  );
}

/// Individual gesture detector for a zone.
class _ZoneGestureDetector extends StatelessWidget {
  final VoidCallback onTap;
  final void Function(Offset position)? onDoubleTapDown;
  final VoidCallback? onDoubleTap;
  final void Function(Offset position)? onSecondaryTapDown;
  final VoidCallback? onSecondaryTap;

  const _ZoneGestureDetector({
    required this.onTap,
    this.onDoubleTapDown,
    this.onDoubleTap,
    this.onSecondaryTapDown,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      onDoubleTapDown: onDoubleTapDown != null
          ? (details) => onDoubleTapDown!(details.globalPosition)
          : null,
      onDoubleTap: onDoubleTap,
      onSecondaryTapDown: onSecondaryTapDown != null
          ? (details) => onSecondaryTapDown!(details.globalPosition)
          : null,
      onSecondaryTap: onSecondaryTap,
    );
  }
}
