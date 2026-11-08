import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Collects the user's choice and waits for the existing repository action.
/// Queries and deletion rules stay with the browse settings screen.
class MobileBrowseCleanupDialog extends StatefulWidget {
  const MobileBrowseCleanupDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.chooseTypes = false,
  });

  final String title, message;
  final bool chooseTypes;
  final Future<void> Function(List<ItemType>) onConfirm;

  @override
  State<MobileBrowseCleanupDialog> createState() =>
      _MobileBrowseCleanupDialogState();
}

class _MobileBrowseCleanupDialogState extends State<MobileBrowseCleanupDialog> {
  final _selected = <ItemType>{};
  bool _busy = false, _failed = false;

  Future<void> _confirm() async {
    if (_busy || (widget.chooseTypes && _selected.isEmpty)) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      await widget.onConfirm(
        ItemType.values.where(_selected.contains).toList(),
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    return PopScope(
      canPop: !_busy,
      child: NodeLaneAlertDialog(
        scrollable: true,
        title: Text(widget.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.message, style: colors.readerSecondary),
            if (widget.chooseTypes) ...[
              const SizedBox(height: 16),
              NodeLaneGroupSurface(
                children: [
                  for (final type in ItemType.values)
                    NodeLaneRow(
                      title: switch (type) {
                        ItemType.manga => l10n.manga,
                        ItemType.anime => l10n.anime,
                        ItemType.novel => l10n.novel,
                      },
                      checkable: true,
                      selected: _selected.contains(type),
                      enabled: !_busy,
                      onTap: _busy
                          ? null
                          : () => setState(() {
                              if (!_selected.add(type)) _selected.remove(type);
                            }),
                    ),
                ],
              ),
            ],
            if (_failed) ...[
              const SizedBox(height: NodeLaneTokens.space16),
              NodeLaneNotice(
                message: l10n.failed,
                kind: NodeLaneNoticeKind.error,
                contained: false,
              ),
            ],
          ],
        ),
        actions: [
          NodeLaneDialogAction(
            label: l10n.cancel,
            secondary: true,
            onPressed: _busy ? null : () => Navigator.pop(context),
          ),
          NodeLaneDialogAction(
            label: l10n.dialog_confirm,
            destructive: true,
            busy: _busy,
            onPressed: _busy || (widget.chooseTypes && _selected.isEmpty)
                ? null
                : _confirm,
          ),
        ],
      ),
    );
  }
}
