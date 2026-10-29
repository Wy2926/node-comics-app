import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// These values continue to dispatch through the existing library actions.
class MobileBookshelfMenu extends StatelessWidget {
  const MobileBookshelfMenu({
    super.key,
    required this.hasEntries,
    required this.updating,
    required this.ignoreFilters,
    required this.onSelected,
  });
  final bool hasEntries, updating, ignoreFilters;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final l10n = context.l10n;
    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.bookshelf_actions,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colors.ink,
                      ),
                    ),
                  ),
                  CloseButton(color: colors.ink),
                ],
              ),
              ListTile(
                enabled: updating || hasEntries,
                leading: Icon(
                  updating ? Icons.stop_circle_outlined : Icons.refresh,
                ),
                title: Text(
                  updating ? l10n.bookshelf_stop_update : l10n.update_library,
                ),
                minTileHeight: 56,
                onTap: () => onSelected(updating ? 5 : 0),
              ),
              ListTile(
                enabled: hasEntries,
                leading: const Icon(Icons.shuffle_rounded),
                title: Text(l10n.open_random_entry),
                minTileHeight: 56,
                onTap: () => onSelected(1),
              ),
              Divider(color: colors.line),
              SwitchListTile.adaptive(
                title: Text(l10n.bookshelf_ignore_filters),
                subtitle: Text(
                  l10n.bookshelf_ignore_filters_hint,
                  style: TextStyle(fontSize: 13, color: colors.muted),
                ),
                value: ignoreFilters,
                onChanged: (_) => onSelected(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Only collects removal choices and presents the existing operation's state.
/// A failed operation may have partially written, so it cannot be resubmitted
/// from this confirmation. Cancelling keeps the owner's selection intact.
class MobileBookshelfRemoveDialog extends StatefulWidget {
  const MobileBookshelfRemoveDialog({
    super.key,
    required this.titles,
    required this.hasLocalArchives,
    required this.onRemove,
  });
  final List<String> titles;
  final bool hasLocalArchives;
  final Future<void> Function(bool fromLibrary, bool downloads) onRemove;

  @override
  State<MobileBookshelfRemoveDialog> createState() =>
      _MobileBookshelfRemoveDialogState();
}

class _MobileBookshelfRemoveDialogState
    extends State<MobileBookshelfRemoveDialog> {
  bool _fromLibrary = false, _downloads = false, _busy = false, _failed = false;

  Future<void> _submit() async {
    if (_busy ||
        _failed ||
        widget.titles.isEmpty ||
        (!_fromLibrary && !_downloads)) {
      return;
    }
    setState(() => _busy = true);
    try {
      await widget.onRemove(_fromLibrary, _downloads);
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
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final l10n = context.l10n;
    return PopScope(
      canPop: !_busy,
      child: AlertDialog(
        backgroundColor: colors.surface,
        scrollable: true,
        title: Text(l10n.remove),
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                title: Text(
                  l10n.bookshelf_selected_count(widget.titles.length),
                  style: TextStyle(fontSize: 16, color: colors.ink),
                ),
                children: [
                  SizedBox(
                    height: (widget.titles.length * 52.0).clamp(0, 156),
                    child: ListView.builder(
                      itemCount: widget.titles.length,
                      itemBuilder: (_, index) => ListTile(
                        title: Text(
                          widget.titles[index],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_failed)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    l10n.bookshelf_remove_incomplete,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                )
              else ...[
                CheckboxListTile.adaptive(
                  value: _fromLibrary,
                  onChanged: _busy
                      ? null
                      : (value) => setState(() => _fromLibrary = value!),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.bookshelf_remove_library,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    l10n.bookshelf_remove_library_hint,
                    style: TextStyle(fontSize: 13, color: colors.muted),
                  ),
                ),
                CheckboxListTile.adaptive(
                  value: _downloads,
                  onChanged: _busy
                      ? null
                      : (value) => setState(() => _downloads = value!),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.bookshelf_remove_downloads,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    widget.hasLocalArchives
                        ? l10n.bookshelf_remove_local_files_hint
                        : l10n.bookshelf_remove_downloads_hint,
                    style: TextStyle(fontSize: 13, color: colors.muted),
                  ),
                ),
                if (_busy) ...[
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(),
                  const SizedBox(height: 8),
                  Text(l10n.bookshelf_processing),
                ],
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _busy ? null : () => Navigator.pop(context, false),
            child: Text(_failed ? l10n.close : l10n.cancel),
          ),
          if (!_failed)
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed:
                  !_busy &&
                      widget.titles.isNotEmpty &&
                      (_fromLibrary || _downloads)
                  ? _submit
                  : null,
              child: Text(l10n.remove),
            ),
        ],
      ),
    );
  }
}
