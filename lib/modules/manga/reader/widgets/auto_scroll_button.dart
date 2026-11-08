import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// Auto-scroll play/pause button for continuous reading modes.
///
/// Shows a play/pause button at the bottom-right corner when auto-scroll is enabled.
/// Only visible in vertical/horizontal continuous modes.
class ReaderAutoScrollButton extends StatelessWidget {
  /// Whether the current mode supports auto-scroll (continuous modes).
  final bool isContinuousMode;

  /// Whether the UI is currently visible (hide button when UI is hidden).
  final bool isUiVisible;

  /// ValueNotifier for auto-scroll running state.
  final ValueNotifier<bool> autoScroll;
  final ValueNotifier<bool>? autoScrollPage;

  /// Callback when play/pause is toggled.
  final VoidCallback onToggle;

  const ReaderAutoScrollButton({
    super.key,
    required this.isContinuousMode,
    required this.isUiVisible,
    required this.autoScroll,
    this.autoScrollPage,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (!isContinuousMode) {
      return const SizedBox.shrink();
    }

    final mobile = isMobile && !isTv;
    final media = MediaQuery.of(context);
    if (autoScrollPage != null) {
      return ValueListenableBuilder<bool>(
        valueListenable: autoScrollPage!,
        builder: (context, enabled, _) =>
            enabled ? _button(context, mobile, media) : const SizedBox.shrink(),
      );
    }
    return _button(context, mobile, media);
  }

  Widget _button(BuildContext context, bool mobile, MediaQueryData media) {
    return Positioned(
      bottom: mobile
          ? max(media.viewPadding.bottom, media.systemGestureInsets.bottom) + 8
          : 0,
      right: mobile ? 12 : 0,
      child: isUiVisible
          ? const SizedBox.shrink()
          : ValueListenableBuilder(
              valueListenable: autoScroll,
              builder: (context, isPlaying, child) => IconButton(
                tooltip: isPlaying
                    ? context.l10n.tts_pause
                    : context.l10n.resume,
                style: mobile
                    ? IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: .6),
                        foregroundColor: Colors.white,
                      )
                    : null,
                onPressed: onToggle,
                icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
              ),
            ),
    );
  }
}
