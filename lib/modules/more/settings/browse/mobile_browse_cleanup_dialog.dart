import 'package:flutter/material.dart';
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
      child: AlertDialog(
        scrollable: true,
        backgroundColor: colors.surface,
        title: Text(widget.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.message, style: TextStyle(color: colors.muted)),
            if (widget.chooseTypes) ...[
              const SizedBox(height: 16),
              for (final type in ItemType.values)
                CheckboxListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(switch (type) {
                    ItemType.manga => l10n.manga,
                    ItemType.anime => l10n.anime,
                    ItemType.novel => l10n.novel,
                  }),
                  value: _selected.contains(type),
                  onChanged: _busy
                      ? null
                      : (selected) => setState(() {
                          if (selected == true) {
                            _selected.add(type);
                          } else {
                            _selected.remove(type);
                          }
                        }),
                ),
            ],
            if (_busy) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            if (_failed) ...[
              const SizedBox(height: 16),
              Semantics(
                liveRegion: true,
                child: Text(
                  l10n.failed,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: _busy ? null : () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: _busy || (widget.chooseTypes && _selected.isEmpty)
                ? null
                : _confirm,
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(l10n.dialog_confirm),
          ),
        ],
      ),
    );
  }
}
