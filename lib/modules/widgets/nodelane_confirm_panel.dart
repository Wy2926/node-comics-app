import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// Waits for the existing operation; a failed operation keeps its confirmation
/// visible. The caller owns persistence and file handling.
class NodeLaneConfirmPanel extends StatefulWidget {
  const NodeLaneConfirmPanel({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.destructive = false,
    this.enabled = true,
    this.options,
  });
  final String title, message, confirmLabel;
  final bool destructive;
  final bool enabled;
  final Widget Function(bool enabled)? options;
  final Future<void> Function() onConfirm;
  @override
  State<NodeLaneConfirmPanel> createState() => _ConfirmPanelState();
}

class _ConfirmPanelState extends State<NodeLaneConfirmPanel> {
  bool _busy = false, _failed = false;
  Future<void> _confirm() async {
    if (_busy || !widget.enabled || ModalRoute.isCurrentOf(context) != true) {
      return;
    }
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
  Widget build(BuildContext context) => NodeLaneBubblePanel(
    title: widget.title,
    dismissEnabled: !_busy,
    footer: NodeLaneModalActions(
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
          onPressed: _busy || !widget.enabled ? null : _confirm,
        ),
      ],
    ),
    child: SingleChildScrollView(
      primary: false,
      padding: NodeLaneTokens.groupPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.message),
          if (widget.options != null) widget.options!(!_busy),
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
    ),
  );
}
