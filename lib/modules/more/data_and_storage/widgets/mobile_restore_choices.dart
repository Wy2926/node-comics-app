import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// These routes return choices only. Preview, safety snapshots and restore
/// continue in unified_restore in their existing order.
class MobileRestoreMode extends StatelessWidget {
  const MobileRestoreMode({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _RestorePage(
      title: l10n.import_mode_title,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _Explanation(l10n.import_mode_message),
          MobileSettingsGroup(
            children: [
              NodeLaneRow(
                title: l10n.import_mode_keep_existing,
                subtitle: l10n.import_mode_keep_existing_subtitle,
                icon: Icons.merge_type_rounded,
                onTap: () => Navigator.pop(context, true),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                leading: Icon(
                  Icons.delete_sweep_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  l10n.import_mode_replace,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                subtitle: Text(l10n.import_mode_replace_subtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.pop(context, false),
              ),
            ],
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}

class MobileRestoreCategories extends StatefulWidget {
  const MobileRestoreCategories({super.key, required this.conflicts});
  final List<String> conflicts;

  @override
  State<MobileRestoreCategories> createState() =>
      _MobileRestoreCategoriesState();
}

class _MobileRestoreCategoriesState extends State<MobileRestoreCategories> {
  late final _decisions = {for (final name in widget.conflicts) name: true};

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _RestorePage(
      title: l10n.category_conflict_title,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: widget.conflicts.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) return _Explanation(l10n.category_conflict_message);
          if (index == widget.conflicts.length + 1) {
            return _ChoiceActions(
              onConfirm: () =>
                  Navigator.pop(context, Map<String, bool>.of(_decisions)),
            );
          }
          final name = widget.conflicts[index - 1];
          return MobileSettingsGroup(
            children: [
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(name),
                subtitle: Text(
                  _decisions[name]!
                      ? l10n.category_conflict_keep
                      : l10n.category_conflict_delete,
                ),
                value: _decisions[name],
                onChanged: (value) =>
                    setState(() => _decisions[name] = value ?? true),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MobileRestoreSources extends StatefulWidget {
  const MobileRestoreSources({
    super.key,
    required this.unmatched,
    required this.sources,
  });
  final Map<String, ItemType> unmatched;
  final Map<ItemType, List<Source>> sources;

  @override
  State<MobileRestoreSources> createState() => _MobileRestoreSourcesState();
}

class _MobileRestoreSourcesState extends State<MobileRestoreSources> {
  late final _selections = <String, int?>{
    for (final name in widget.unmatched.keys) name: null,
  };
  late final _entries = widget.unmatched.entries.toList();

  String _sourceLabel(Source source) =>
      '${source.name ?? context.l10n.unknown} (${source.lang ?? ''})';

  Future<void> _choose(String name, ItemType type) async {
    final selected = await showMobileSettingsPicker<int?>(
      context,
      title: name,
      current: _selections[name],
      searchable: true,
      options: [
        MobileSettingOption(null, context.l10n.source_conflict_keep),
        for (final source in widget.sources[type] ?? <Source>[])
          if (source.id != null)
            MobileSettingOption(source.id, _sourceLabel(source)),
      ],
    );
    if (mounted && selected != null) {
      setState(() => _selections[name] = selected.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _RestorePage(
      title: l10n.source_conflict_title,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: _entries.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) return _Explanation(l10n.source_conflict_message);
          if (index == _entries.length + 1) {
            return _ChoiceActions(
              onConfirm: () => Navigator.pop(context, {
                for (final entry in _selections.entries)
                  if (entry.value != null) entry.key: entry.value!,
              }),
            );
          }
          final entry = _entries[index - 1];
          final selectedId = _selections[entry.key];
          var selectedLabel = l10n.source_conflict_keep;
          for (final source in widget.sources[entry.value] ?? <Source>[]) {
            if (selectedId != null && source.id == selectedId) {
              selectedLabel = _sourceLabel(source);
              break;
            }
          }
          final typeLabel = switch (entry.value) {
            ItemType.manga => l10n.manga,
            ItemType.anime => l10n.anime,
            ItemType.novel => l10n.novel,
          };
          return MobileSettingsGroup(
            children: [
              NodeLaneRow(
                title: entry.key,
                subtitle: typeLabel,
                value: selectedLabel,
                icon: Icons.extension_outlined,
                onTap: () => _choose(entry.key, entry.value),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RestorePage extends StatelessWidget {
  const _RestorePage({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => NodeLaneSurface(
    child: Scaffold(
      appBar: nodeLaneAppBar(context, title: title),
      body: SafeArea(top: false, child: child),
    ),
  );
}

class _Explanation extends StatelessWidget {
  const _Explanation(this.message);
  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 24),
    child: Text(
      message,
      style: TextStyle(color: NodeLaneTokens.of(context).muted),
    ),
  );
}

class _ChoiceActions extends StatelessWidget {
  const _ChoiceActions({required this.onConfirm});
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      FilledButton(onPressed: onConfirm, child: Text(context.l10n.ok)),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
    ],
  );
}
