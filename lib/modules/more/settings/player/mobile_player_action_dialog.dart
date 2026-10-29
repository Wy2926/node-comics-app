import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Waits for the existing operation; a failed operation keeps its confirmation
/// visible. The caller owns persistence and file handling.
class MobilePlayerActionDialog extends StatefulWidget {
  const MobilePlayerActionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
  });
  final String title, message, confirmLabel;
  final Future<void> Function() onConfirm;
  @override
  State<MobilePlayerActionDialog> createState() =>
      _MobilePlayerActionDialogState();
}

class _MobilePlayerActionDialogState extends State<MobilePlayerActionDialog> {
  bool _busy = false, _failed = false;
  Future<void> _confirm() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      await widget.onConfirm();
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _failed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: AlertDialog(
      scrollable: true,
      backgroundColor: NodeLaneTokens.of(context).surface,
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.message),
          if (_busy) ...[
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
          ],
          if (_failed) ...[
            const SizedBox(height: 16),
            Semantics(liveRegion: true, child: Text(context.l10n.failed)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: _busy ? null : _confirm,
          child: Text(widget.confirmLabel),
        ),
      ],
    ),
  );
}
