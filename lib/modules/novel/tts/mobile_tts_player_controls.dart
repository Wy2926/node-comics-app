import 'package:flutter/material.dart';
import 'package:mangayomi/modules/novel/tts/novel_tts_service.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Playback ownership stays with TtsPlayerBar and the existing speech service.
class MobileTtsPlayerControls extends StatelessWidget {
  const MobileTtsPlayerControls({
    super.key,
    required this.state,
    required this.index,
    required this.total,
    required this.onPrevious,
    required this.onNext,
    required this.onPlayPause,
    required this.onStop,
    this.failed = false,
    this.busy = false,
  });
  final TtsState state;
  final int index, total;
  final bool failed, busy;
  final VoidCallback onPrevious, onNext, onPlayPause, onStop;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final ready = !failed && !busy && total > 0 && state != TtsState.stopped;
    final current = total == 0 ? 0 : (index + 1).clamp(1, total);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.soft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            failed
                ? l10n.failed
                : total > 0
                ? l10n.tts_paragraph_progress('$current', '$total')
                : l10n.tts,
          ),
          const SizedBox(height: 8),
          if (total > 0)
            ExcludeSemantics(
              child: LinearProgressIndicator(value: current / total),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                tooltip: l10n.tts_previous,
                onPressed: ready && index > 0 ? onPrevious : null,
                icon: const Icon(Icons.skip_previous_rounded),
              ),
              FilledButton.icon(
                onPressed: ready ? onPlayPause : null,
                icon: Icon(
                  state == TtsState.playing
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
                label: Text(
                  state == TtsState.playing ? l10n.tts_pause : l10n.tts_play,
                ),
              ),
              IconButton(
                tooltip: l10n.tts_next,
                onPressed: ready && index < total - 1 ? onNext : null,
                icon: const Icon(Icons.skip_next_rounded),
              ),
              IconButton(
                tooltip: l10n.tts_stop,
                onPressed: onStop,
                icon: const Icon(Icons.stop_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
