import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/delete_source.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

String librarySourceDetails(
  BuildContext context,
  LibrarySourceGroup group, {
  int? entryCount,
}) {
  final l10n = context.l10n;
  final type = switch (group.itemType) {
    ItemType.manga => l10n.manga,
    ItemType.anime => l10n.anime,
    ItemType.novel => l10n.novel,
  };
  return [
    type,
    if (group.lang?.isNotEmpty ?? false) group.lang!,
    '${l10n.library_entries}: ${entryCount ?? group.mangaCount}',
  ].join(' · ');
}

/// Selection returns the original group, including its source ID and media
/// type. Filtering labels must never rebuild or merge source identities.
Future<LibrarySourceGroup?> showMobileLibrarySourcePicker(
  BuildContext context, {
  required List<LibrarySourceGroup> groups,
  required String title,
  required String? description,
  required String emptyMessage,
}) async {
  final picked = await showMobileSettingsPicker<LibrarySourceGroup?>(
    context,
    title: title,
    current: null,
    searchable: groups.isNotEmpty,
    description: description,
    emptyMessage: emptyMessage,
    options: [
      for (final group in groups)
        MobileSettingOption(
          group,
          group.sourceName,
          subtitle: librarySourceDetails(context, group),
          leading: const Icon(Icons.extension_outlined),
        ),
    ],
  );
  return picked?.value;
}

typedef LibraryDeleteChoices = ({
  bool keepHistory,
  bool keepDownloads,
  bool removeExtension,
});

/// Presentation-only drafts. The caller still creates the safety snapshot and
/// executes deletion, after this page explicitly returns the choices.
class MobileDeleteSourceChoices extends StatefulWidget {
  const MobileDeleteSourceChoices({
    super.key,
    required this.group,
    required this.counts,
  });
  final LibrarySourceGroup group;
  final DeleteSourceCounts counts;

  @override
  State<MobileDeleteSourceChoices> createState() =>
      _MobileDeleteSourceChoicesState();
}

class _MobileDeleteSourceChoicesState extends State<MobileDeleteSourceChoices> {
  bool _keepHistory = false, _keepDownloads = false;
  late bool _removeExtension = widget.group.sourceId != null;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final counts = widget.counts;
    return _ChoicePage(
      title: l10n.delete_source_title,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            widget.group.sourceName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(librarySourceDetails(context, widget.group)),
          const SizedBox(height: 20),
          Text(
            l10n.library_delete_summary(
              counts.mangaCount,
              counts.chapterCount,
              counts.historyCount,
              counts.updateCount,
            ),
          ),
          const SizedBox(height: 20),
          MobileSettingsGroup(
            children: [
              NodeLaneSwitchRow(
                title: l10n.delete_source_keep_history,
                icon: Icons.history_rounded,
                value: _keepHistory,
                onChanged: (value) => setState(() => _keepHistory = value),
              ),
              NodeLaneSwitchRow(
                title: l10n.delete_source_keep_downloads,
                icon: Icons.download_outlined,
                value: _keepDownloads,
                onChanged: (value) => setState(() => _keepDownloads = value),
              ),
              if (widget.group.sourceId != null)
                NodeLaneSwitchRow(
                  title: l10n.delete_source_also_remove_extension,
                  icon: Icons.extension_off_outlined,
                  value: _removeExtension,
                  onChanged: (value) =>
                      setState(() => _removeExtension = value),
                ),
            ],
          ),
          Text(
            l10n.library_safety_snapshot_note,
            style: TextStyle(color: NodeLaneTokens.of(context).muted),
          ),
          const SizedBox(height: 24),
          _ChoiceActions(
            label: l10n.delete_source_button,
            destructive: true,
            onConfirm: () => Navigator.pop<LibraryDeleteChoices>(context, (
              keepHistory: _keepHistory,
              keepDownloads: _keepDownloads,
              removeExtension: _removeExtension,
            )),
          ),
        ],
      ),
    );
  }
}

class MobileMergePrimary extends StatefulWidget {
  const MobileMergePrimary({
    super.key,
    required this.manga,
    required this.chapterCounts,
  }) : assert(manga.length > 0);

  /// Already sorted by the existing flow, most chapters first.
  final List<Manga> manga;
  final Map<int, int> chapterCounts;

  @override
  State<MobileMergePrimary> createState() => _MobileMergePrimaryState();
}

class _MobileMergePrimaryState extends State<MobileMergePrimary> {
  late Manga _primary = widget.manga.first;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _ChoicePage(
      title: l10n.merge_manga_title,
      child: RadioGroup<Manga>(
        groupValue: _primary,
        onChanged: (value) {
          if (value != null) setState(() => _primary = value);
        },
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: widget.manga.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.merge_manga_choose_primary_title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(l10n.merge_manga_choose_primary_message),
                  ],
                ),
              );
            }
            if (index == widget.manga.length + 1) {
              return _ChoiceActions(
                label: l10n.next(''),
                onConfirm: () => Navigator.pop(context, _primary),
              );
            }
            final manga = widget.manga[index - 1];
            return MobileSettingsGroup(
              children: [
                RadioListTile<Manga>(
                  key: ValueKey('merge-primary-${manga.id}'),
                  value: manga,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  title: Text(manga.name ?? ''),
                  subtitle: Text(
                    l10n.merge_manga_chapters_subtitle(
                      widget.chapterCounts[manga.id] ?? 0,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChoicePage extends StatelessWidget {
  const _ChoicePage({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => NodeLaneSurface(
    child: Scaffold(
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SafeArea(top: false, child: child),
    ),
  );
}

class _ChoiceActions extends StatelessWidget {
  const _ChoiceActions({
    required this.label,
    required this.onConfirm,
    this.destructive = false,
  });
  final String label;
  final VoidCallback onConfirm;
  final bool destructive;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          backgroundColor: destructive
              ? Theme.of(context).colorScheme.error
              : null,
          foregroundColor: destructive
              ? Theme.of(context).colorScheme.onError
              : null,
        ),
        onPressed: onConfirm,
        child: Text(label, textAlign: TextAlign.center),
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
    ],
  );
}
