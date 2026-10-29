import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MobileMangaImportDialog extends StatefulWidget {
  const MobileMangaImportDialog({super.key, required this.onImport});
  final Future<int> Function() onImport;
  @override
  State<MobileMangaImportDialog> createState() =>
      _MobileMangaImportDialogState();
}

class _MobileMangaImportDialogState extends State<MobileMangaImportDialog> {
  bool _busy = false, _failed = false, _leaving = false;

  Future<void> _choose() async {
    if (_busy || _failed || _leaving) return;
    setState(() => _busy = true);
    try {
      final count = await widget.onImport();
      if (!mounted) return;
      if (count > 0) {
        _leaving = true;
        Navigator.pop(context, count);
      } else {
        // Cancelling the system picker leaves this choice available.
        setState(() => _busy = false);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _failed = true;
        });
      }
    }
  }

  void _close() {
    if (_busy || _leaving) return;
    _leaving = true;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    return PopScope(
      canPop: !_busy,
      child: AlertDialog(
        backgroundColor: colors.surface,
        scrollable: true,
        title: Text(l10n.import_local_file),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.bookshelf_import_hint),
            const SizedBox(height: 12),
            Text(
              'ZIP · CBZ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colors.accent,
              ),
            ),
            if (_busy) ...[
              const SizedBox(height: 20),
              const LinearProgressIndicator(),
              const SizedBox(height: 12),
              Semantics(
                liveRegion: true,
                child: Text(l10n.bookshelf_import_wait),
              ),
            ],
            if (_failed) ...[
              const SizedBox(height: 20),
              Semantics(
                liveRegion: true,
                child: Text(
                  l10n.bookshelf_import_incomplete,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: _busy ? null : _close,
            child: Text(_failed ? l10n.close : l10n.cancel),
          ),
          if (!_failed)
            FilledButton.icon(
              onPressed: _busy ? null : _choose,
              icon: const Icon(Icons.folder_open_outlined),
              label: Text(l10n.bookshelf_choose_files),
            ),
        ],
      ),
    );
  }
}
