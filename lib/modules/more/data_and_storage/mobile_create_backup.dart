import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Backup selection is still the existing shared manual/automatic preference.
/// This view owns only the pending-action state, not the backup or its result.
class MobileCreateBackup extends StatefulWidget {
  const MobileCreateBackup({
    super.key,
    required this.libraryOptions,
    required this.settingsOptions,
    required this.extensionOptions,
    required this.selected,
    required this.onToggle,
    required this.onCreate,
  });
  final List<(String, int)> libraryOptions, settingsOptions, extensionOptions;
  final List<int> selected;
  final ValueChanged<int> onToggle;
  final Future<void> Function(List<int>) onCreate;

  @override
  State<MobileCreateBackup> createState() => _MobileCreateBackupState();
}

class _MobileCreateBackupState extends State<MobileCreateBackup> {
  bool _busy = false;
  bool _failed = false;

  Future<void> _create() async {
    if (_busy) return;
    final selection = List<int>.of(widget.selected);
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      await widget.onCreate(selection);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _group(String title, List<(String, int)> options) =>
      MobileSettingsGroup(
        title: title,
        children: [
          for (final (label, id) in options)
            CheckboxListTile(
              key: ValueKey('backup-option-$id'),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(label),
              value: widget.selected.contains(id),
              onChanged: _busy ? null : (_) => widget.onToggle(id),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    return NodeLaneSurface(
      child: PopScope(
        canPop: !_busy,
        child: Scaffold(
          appBar: nodeLaneAppBar(context, title: l10n.create_backup),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 24),
                  child: Text(
                    l10n.backup_selection_shared,
                    style: TextStyle(color: colors.muted),
                  ),
                ),
                _group(l10n.library, widget.libraryOptions),
                _group(l10n.settings, widget.settingsOptions),
                _group(l10n.extensions, widget.extensionOptions),
                if (_failed) ...[
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      l10n.failed,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (_busy) ...[
                  const LinearProgressIndicator(),
                  const SizedBox(height: 16),
                ],
                FilledButton.icon(
                  onPressed: _busy ? null : _create,
                  icon: const Icon(Icons.archive_outlined),
                  label: Text(l10n.create_backup),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
