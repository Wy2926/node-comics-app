import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Keep the player at a stable position while the reading controls are hidden.
class MobileNovelPanel extends StatelessWidget {
  const MobileNovelPanel({
    super.key,
    required this.controlsVisible,
    required this.controls,
    this.player,
  });
  final bool controlsVisible;
  final Widget controls;
  final Widget? player;

  @override
  Widget build(BuildContext context) => MobileReaderPanel(
    visible: controlsVisible || player != null,
    top: false,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [?player, if (controlsVisible) controls],
    ),
  );
}

/// The reader supplies its existing pagination/scroll mapping and chapter
/// callbacks. Showing these controls never changes the reading viewport.
class MobileNovelControls extends StatelessWidget {
  const MobileNovelControls({
    super.key,
    required this.progress,
    required this.progressLabel,
    required this.chapterAction,
    required this.onFontSize,
    required this.onSettings,
    required this.listening,
    this.onSeek,
    this.onPreviousChapter,
    this.onNextChapter,
    this.onListen,
  });
  final double progress;
  final String progressLabel;
  final Widget chapterAction;
  final VoidCallback onFontSize, onSettings;
  final VoidCallback? onPreviousChapter, onNextChapter, onListen;
  final ValueChanged<double>? onSeek;
  final bool listening;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: l10n.previous(l10n.chapter),
              onPressed: onPreviousChapter,
              icon: const Icon(Icons.skip_previous_rounded),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    progressLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: NodeLaneTokens.of(context).muted),
                  ),
                  Slider(value: progress.clamp(0, 1), onChanged: onSeek),
                ],
              ),
            ),
            IconButton(
              tooltip: l10n.next_chapter,
              onPressed: onNextChapter,
              icon: const Icon(Icons.skip_next_rounded),
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final actions = [
              chapterAction,
              NodeLaneToolbarAction(
                label: l10n.font_size,
                icon: Icons.format_size_rounded,
                onPressed: onFontSize,
              ),
              if (onListen != null)
                NodeLaneToolbarAction(
                  label: l10n.tts,
                  icon: Icons.record_voice_over_outlined,
                  active: listening,
                  onPressed: onListen,
                ),
              NodeLaneToolbarAction(
                label: l10n.settings,
                icon: Icons.tune_rounded,
                onPressed: onSettings,
              ),
            ];
            final columns = MediaQuery.textScalerOf(context).scale(12) > 20
                ? 2
                : actions.length;
            return Wrap(
              children: [
                for (final action in actions)
                  SizedBox(
                    width: constraints.maxWidth / columns,
                    child: action,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// A local slider draft avoids repaginating the novel at every drag update.
class MobileNovelFontSize extends StatefulWidget {
  const MobileNovelFontSize({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final int value;
  final ValueChanged<int> onChanged;

  @override
  State<MobileNovelFontSize> createState() => _MobileNovelFontSizeState();
}

class _MobileNovelFontSizeState extends State<MobileNovelFontSize> {
  late int _draft = widget.value;

  @override
  void didUpdateWidget(covariant MobileNovelFontSize oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) _draft = widget.value;
  }

  void _set(int value) {
    setState(() => _draft = value);
    if (value != widget.value) widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.font_size,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton(
              tooltip: l10n.close,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        Text('$_draft px', style: Theme.of(context).textTheme.headlineSmall),
        Row(
          children: [
            IconButton.filledTonal(
              tooltip: l10n.decrease,
              onPressed: _draft > 8 ? () => _set(_draft - 1) : null,
              icon: const Icon(Icons.remove_rounded),
            ),
            Expanded(
              child: Slider(
                min: 8,
                max: 40,
                divisions: 32,
                value: _draft.toDouble().clamp(8, 40),
                onChanged: (value) => setState(() => _draft = value.round()),
                onChangeEnd: (value) => _set(value.round()),
              ),
            ),
            IconButton.filledTonal(
              tooltip: l10n.increase,
              onPressed: _draft < 40 ? () => _set(_draft + 1) : null,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in [12, 14, 16, 18, 20, 24, 28])
              ChoiceChip(
                label: Text('$value'),
                selected: _draft == value,
                showCheckmark: false,
                onSelected: (_) => _set(value),
              ),
          ],
        ),
      ],
    );
  }
}
