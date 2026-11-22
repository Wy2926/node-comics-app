import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// The toolbar shows the current image; activating it shows the other one.
class TranslationDisplayButton extends StatelessWidget {
  const TranslationDisplayButton({
    super.key,
    required this.translated,
    required this.onChanged,
  });
  final bool translated;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    return Tooltip(
      message: translated
          ? l.translation_show_original
          : l.translation_show_translated,
      child: NodeLaneToolbarAction(
        label: translated ? l.translation_translated : l.translation_original,
        alternateLabel: translated
            ? l.translation_original
            : l.translation_translated,
        icon: translated ? icons.translate : icons.image,
        active: translated,
        enabled: onChanged != null,
        onPressed: onChanged == null ? null : () => onChanged!(!translated),
      ),
    );
  }
}

/// Explicit choices in the reader's settings.
class TranslationDisplaySwitch extends StatelessWidget {
  const TranslationDisplaySwitch({
    super.key,
    required this.translated,
    required this.onChanged,
  });
  final bool translated;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => NodeLaneSegments<bool>(
    value: translated,
    pill: true,
    labelStyle: NodeLaneTokens.of(context).readerLabel,
    segments: [
      ButtonSegment(
        value: false,
        label: Text(context.l10n.translation_original),
        enabled: onChanged != null,
      ),
      ButtonSegment(
        value: true,
        label: Text(context.l10n.translation_translated),
        enabled: onChanged != null,
      ),
    ],
    onChanged: onChanged ?? (_) {},
  );
}
