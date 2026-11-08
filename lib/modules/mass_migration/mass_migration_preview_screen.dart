import 'package:flutter/material.dart';
import 'package:mangayomi/modules/mass_migration/mass_migration_destination_screen.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mobile_mass_migration.dart';

class MassMigrationPreviewScreen extends StatefulWidget {
  const MassMigrationPreviewScreen({required this.sourceGroup, super.key});

  final MassMigrationSourceGroup sourceGroup;

  @override
  State<MassMigrationPreviewScreen> createState() =>
      _MassMigrationPreviewScreenState();
}

class _MassMigrationPreviewScreenState
    extends State<MassMigrationPreviewScreen> {
  // Indices of the entries that will actually be migrated. Everything starts
  // selected (previous behaviour was "migrate the whole group"), and the user
  // can trim it down.
  late final Set<int> _selected = {
    for (var i = 0; i < widget.sourceGroup.items.length; i++) i,
  };

  // Anchor for range selection: long-pressing an entry selects everything
  // between the last tapped entry and it (inclusive).
  int? _anchor;

  void _toggle(int index) {
    setState(() {
      if (!_selected.remove(index)) _selected.add(index);
      _anchor = index;
    });
  }

  void _selectRange(int index) {
    final anchor = _anchor;
    if (anchor == null) {
      _toggle(index);
      return;
    }
    setState(() {
      final start = anchor < index ? anchor : index;
      final end = anchor < index ? index : anchor;
      for (var i = start; i <= end; i++) {
        _selected.add(i);
      }
      _anchor = index;
    });
  }

  void _setAll(bool selectAll) {
    setState(() {
      _selected.clear();
      if (selectAll) {
        _selected.addAll([
          for (var i = 0; i < widget.sourceGroup.items.length; i++) i,
        ]);
      }
      _anchor = null;
    });
  }

  void _openDestination() {
    final group = widget.sourceGroup;
    final filtered = MassMigrationSourceGroup(
      sourceName: group.sourceName,
      itemType: group.itemType,
      items: [
        for (var i = 0; i < group.items.length; i++)
          if (_selected.contains(i)) group.items[i],
      ],
      source: group.source,
      lang: group.lang,
      sourceId: group.sourceId,
    );
    Navigator.push(
      context,
      createRoute(page: MassMigrationDestinationScreen(sourceGroup: filtered)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sourceGroup = widget.sourceGroup;
    final total = sourceGroup.items.length;
    final allSelected = _selected.length == total;
    if (isMobile && !isTv) {
      return MobileBrowsePage(
        title: l10n.mass_migration_preview_items,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      sourceGroup.sourceName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      [
                        if (sourceGroup.lang?.isNotEmpty == true)
                          completeLanguageName(sourceGroup.lang!),
                        l10n.mass_migration_item_count(total),
                      ].join(' · '),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: total == 0
                            ? null
                            : () => _setAll(!allSelected),
                        child: Text(
                          allSelected
                              ? l10n.mass_migration_deselect_all
                              : l10n.mass_migration_select_all,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList.builder(
              itemCount: total,
              itemBuilder: (_, index) => MobileMassMigrationSelectionCard(
                key: ValueKey(index),
                item: sourceGroup.items[index],
                source: sourceGroup.source,
                selected: _selected.contains(index),
                onToggle: () => _toggle(index),
                onSelectRange: () => _selectRange(index),
              ),
            ),
          ],
        ),
        bottomAction: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.mass_migration_selected_to_migrate(_selected.length)),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _selected.isEmpty ? null : _openDestination,
              child: Text(l10n.mass_migration_select_destination_source),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mass_migration_preview_items),
        actions: [
          TextButton(
            onPressed: total == 0 ? null : () => _setAll(!allSelected),
            child: Text(
              allSelected
                  ? l10n.mass_migration_deselect_all
                  : l10n.mass_migration_select_all,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: MassMigrationSourceIcon(source: sourceGroup.source),
            title: Text(sourceGroup.sourceName),
            subtitle: Text(
              [
                if ((sourceGroup.lang ?? '').isNotEmpty)
                  completeLanguageName(sourceGroup.lang!),
                context.l10n.selection_progress(_selected.length, total),
              ].join(' • '),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: sourceGroup.items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final manga = sourceGroup.items[index];
                final selected = _selected.contains(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Card(
                    color: selected
                        ? Theme.of(context).colorScheme.primaryContainer
                              .withValues(alpha: 0.4)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tap the header row to toggle; long-press to select a
                          // range from the last tapped entry. The chapter
                          // expander below stays independently tappable.
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _toggle(index),
                            onLongPress: () => _selectRange(index),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IgnorePointer(
                                  child: Checkbox(
                                    value: selected,
                                    onChanged: (_) {},
                                  ),
                                ),
                                const SizedBox(width: 4),
                                MassMigrationCover(
                                  libraryItem: manga,
                                  source: sourceGroup.source,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        manga.name ??
                                            l10n.mass_migration_unknown_title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        [
                                          if ((manga.author ?? '')
                                              .trim()
                                              .isNotEmpty)
                                            manga.author!,
                                          if ((manga.artist ?? '')
                                              .trim()
                                              .isNotEmpty)
                                            manga.artist!,
                                          l10n.mass_migration_chapter_count(
                                            manga.chapters.length,
                                          ),
                                        ].join(' • '),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          MassMigrationChapterSection(
                            title: l10n.mass_migration_source_chapters,
                            chapters: manga.chapters
                                .map(
                                  (chapter) =>
                                      chapter.name ??
                                      l10n.mass_migration_unknown_chapter,
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selected.isEmpty ? null : _openDestination,
                child: Text(l10n.mass_migration_select_destination_source),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
