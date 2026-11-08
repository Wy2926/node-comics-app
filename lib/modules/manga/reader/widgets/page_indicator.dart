import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/comic_reader_scope.dart';

import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Page indicator widget showing current page / total pages.
///
/// Displayed at the bottom center when the UI is hidden and
/// "show page numbers" setting is enabled.
class PageIndicator extends ConsumerWidget {
  /// Whether the UI overlay is currently visible.
  final bool isUiVisible;

  /// Session-local current page index for the visible reader state.
  final ValueListenable<int> currentPageListenable;

  /// Total number of pages.
  final int totalPages;

  /// Function to format the current index for display.
  final String Function(int index) formatCurrentIndex;

  const PageIndicator({
    super.key,
    required this.isUiVisible,
    required this.currentPageListenable,
    required this.totalPages,
    required this.formatCurrentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPagesNumber = ComicReaderScope.of(context).habits.pageNumber;

    // Don't show when UI is visible or setting is disabled
    if (isUiVisible || !showPagesNumber) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: ValueListenableBuilder<int>(
        valueListenable: currentPageListenable,
        builder: (context, currentIndex, child) {
          final label = '${formatCurrentIndex(currentIndex)} / $totalPages';
          if (isMobile && !isTv) {
            final media = MediaQuery.of(context);
            return Padding(
              padding: EdgeInsets.only(
                bottom:
                    max(
                      media.viewPadding.bottom,
                      media.systemGestureInsets.bottom,
                    ) +
                    8,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: Text(
                    label,
                    style: NodeLaneTokens.of(context).readerValue
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            );
          }
          return Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              shadows: [
                Shadow(offset: Offset(-1, -1), blurRadius: 1),
                Shadow(offset: Offset(1, -1), blurRadius: 1),
                Shadow(offset: Offset(1, 1), blurRadius: 1),
                Shadow(offset: Offset(-1, 1), blurRadius: 1),
              ],
            ),
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }
}
