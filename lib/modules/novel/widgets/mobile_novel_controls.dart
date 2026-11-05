import 'package:mangayomi/theme/nodelane_icons.dart';
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
    required this.fontSize,
    required this.onFontSizeChanged,
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
  final int fontSize;
  final ValueChanged<int> onFontSizeChanged;
  final VoidCallback onSettings;
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
              icon: Icon(NodeLaneIcons.of(context).previousChapter),
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
              icon: Icon(NodeLaneIcons.of(context).nextChapter),
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final actions = [
              chapterAction,
              NodeLaneNumberPicker(
                value: fontSize,
                min: 8,
                max: 40,
                label: (value) => '$value px',
                onChanged: onFontSizeChanged,
                builder: (context, toggle, isOpen) => NodeLaneToolbarAction(
                  label: l10n.font_size,
                  icon: NodeLaneIcons.of(context).font,
                  active: isOpen,
                  onPressed: toggle,
                ),
              ),
              if (onListen != null)
                NodeLaneToolbarAction(
                  label: l10n.tts,
                  icon: NodeLaneIcons.of(context).speech,
                  active: listening,
                  onPressed: onListen,
                ),
              NodeLaneToolbarAction(
                label: l10n.settings,
                icon: NodeLaneIcons.of(context).adjustments,
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
