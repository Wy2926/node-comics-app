import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// Waits for the existing operation; a failed operation keeps its confirmation
/// visible. The caller owns persistence and file handling.
class MobilePlayerActionDialog extends StatefulWidget {
  const MobilePlayerActionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.destructive = false,
  });
  final String title, message, confirmLabel;
  final bool destructive;
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
    child: NodeLaneAlertDialog(
      scrollable: true,
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
        NodeLaneDialogAction(
          label: context.l10n.cancel,
          secondary: true,
          onPressed: _busy ? null : () => Navigator.pop(context),
        ),
        NodeLaneDialogAction(
          label: widget.confirmLabel,
          destructive: widget.destructive,
          busy: _busy,
          onPressed: _busy ? null : _confirm,
        ),
      ],
    ),
  );
}
