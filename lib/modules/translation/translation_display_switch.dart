import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Shared display selector; the controller decides whether automatic work resumes.
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
