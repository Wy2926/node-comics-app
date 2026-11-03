import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Owns only the editable draft. Cancel returns null; confirming an empty
/// string remains available for settings whose existing contract allows it.
class MobileSettingsTextDialog extends StatefulWidget {
  const MobileSettingsTextDialog({
    super.key,
    required this.title,
    required this.initialValue,
    this.hint,
    this.helper,
    this.keyboardType = TextInputType.text,
    this.isValid,
  });

  final String title, initialValue;
  final String? hint, helper;
  final TextInputType keyboardType;
  final bool Function(String)? isValid;

  @override
  State<MobileSettingsTextDialog> createState() =>
      _MobileSettingsTextDialogState();
}

class _MobileSettingsTextDialogState extends State<MobileSettingsTextDialog> {
  late final _input = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final l10n = context.l10n;
    return NodeLaneAlertDialog(
      scrollable: true,
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.helper != null) ...[
            Text(widget.helper!, style: colors.readerSecondary),
            const SizedBox(height: 16),
          ],
          NodeLaneTextField(
            controller: _input,
            autofocus: true,
            keyboardType: widget.keyboardType,
            autocorrect: false,
            enableSuggestions: false,
            onChanged: (_) => setState(() {}),
            hint: widget.hint ?? '',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: (widget.isValid?.call(_input.text) ?? true)
              ? () => Navigator.pop(context, _input.text)
              : null,
          child: Text(l10n.dialog_confirm),
        ),
      ],
    );
  }
}
