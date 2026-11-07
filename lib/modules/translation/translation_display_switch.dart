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
        label: const Text('原图'),
        enabled: onChanged != null,
      ),
      ButtonSegment(
        value: true,
        label: const Text('译图'),
        enabled: onChanged != null,
      ),
    ],
    onChanged: onChanged ?? (_) {},
  );
}
