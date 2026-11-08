import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation only. The existing screens own selection, matching and writes.
class MobileMigrationBook extends StatelessWidget {
  const MobileMigrationBook({
    super.key,
    required this.title,
    required this.cover,
    this.subtitle,
  });
  final String title;
  final Widget cover;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ExcludeSemantics(child: SizedBox(width: 48, height: 70, child: cover)),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (subtitle?.isNotEmpty == true) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: TextStyle(color: NodeLaneTokens.of(context).muted),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

class MobileMassMigrationSelectionCard extends StatelessWidget {
  const MobileMassMigrationSelectionCard({
    super.key,
    required this.item,
    required this.source,
    required this.selected,
    required this.onToggle,
    required this.onSelectRange,
  });
  final Manga item;
  final Source? source;
  final bool selected;
  final VoidCallback onToggle, onSelectRange;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = item.name ?? l10n.mass_migration_unknown_title;
    return NodeLaneGroupSurface(
      margin: const EdgeInsets.fromLTRB(
        NodeLaneTokens.gutter,
        0,
        NodeLaneTokens.gutter,
        NodeLaneTokens.space12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            label: title,
            enabled: true,
            checked: selected,
            onTap: onToggle,
            onLongPress: onSelectRange,
            excludeSemantics: true,
            child: InkWell(
              onTap: onToggle,
              onLongPress: onSelectRange,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 16, 12),
                child: Row(
                  children: [
                    Checkbox(value: selected, onChanged: (_) => onToggle()),
                    Expanded(
                      child: MobileMigrationBook(
                        title: title,
                        cover: MassMigrationCover(
                          libraryItem: item,
                          source: source,
                          width: 48,
                          height: 70,
                        ),
                        subtitle: [
                          if (item.author?.trim().isNotEmpty == true)
                            item.author!,
                          if (item.artist?.trim().isNotEmpty == true &&
                              item.artist != item.author)
                            item.artist!,
                          l10n.mass_migration_chapter_count(
                            item.chapters.length,
                          ),
                        ].join(' · '),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MassMigrationChapterSection(
              key: PageStorageKey(('mass-selection-chapters', item.id ?? item)),
              title: l10n.mass_migration_source_chapters,
              chapters: item.chapters.map(
                (chapter) =>
                    chapter.name ?? l10n.mass_migration_unknown_chapter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileMassMigrationMatchCard extends StatelessWidget {
  const MobileMassMigrationMatchCard({
    super.key,
    required this.item,
    required this.source,
    required this.destination,
    required this.loading,
    required this.onSelect,
    required this.onChoose,
    this.canChoose = true,
  });
  final MassMigrationResolvedItem item;
  final Source? source;
  final Source destination;
  final bool loading;
  final bool canChoose;
  final ValueChanged<bool> onSelect;
  final VoidCallback? onChoose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chapters = item.destinationPreview?.chapters;
    return NodeLaneGroupSurface(
      margin: const EdgeInsets.fromLTRB(
        NodeLaneTokens.gutter,
        0,
        NodeLaneTokens.gutter,
        NodeLaneTokens.space12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MobileMigrationBook(
              title: item.sourceItem.name ?? l10n.mass_migration_unknown_title,
              cover: MassMigrationCover(
                libraryItem: item.sourceItem,
                source: source,
                width: 48,
                height: 70,
              ),
              subtitle: l10n.mass_migration_source_chapter_count(
                item.sourceItem.chapters.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.arrow_downward_rounded,
                  color: NodeLaneTokens.of(context).muted,
                ),
              ),
            ),
            MobileMigrationBook(
              title: item.hasMatch
                  ? item.selectedCandidate?.name ??
                        l10n.mass_migration_unknown_match
                  : l10n.mass_migration_no_destination_match,
              cover: MassMigrationCover(
                remoteItem: item.selectedCandidate,
                source: destination,
                width: 48,
                height: 70,
              ),
              subtitle: chapters == null
                  ? null
                  : l10n.mass_migration_destination_chapter_count(
                      chapters.length,
                    ),
            ),
            if (item.searchResult.usedQuery?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(l10n.mass_migration_query(item.searchResult.usedQuery!)),
            ],
            if (item.errorMessage?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(item.errorMessage!),
            ],
            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ChoiceChip(
                  label: Text(l10n.mass_migration_skip),
                  selected: !item.shouldMigrate,
                  onSelected: loading ? null : (_) => onSelect(false),
                ),
                ChoiceChip(
                  label: Text(l10n.migrate),
                  selected: item.shouldMigrate,
                  onSelected: !loading && item.canMigrate
                      ? (_) => onSelect(true)
                      : null,
                ),
                if (onChoose != null)
                  TextButton(
                    onPressed: loading || !canChoose ? null : onChoose,
                    child: Text(
                      !item.canMigrate &&
                              item.searchResult.candidates.length == 1
                          ? l10n.retry
                          : l10n.mass_migration_choose_another_result,
                    ),
                  ),
              ],
            ),
            MassMigrationChapterSection(
              key: PageStorageKey((
                'mass-review-source',
                item.sourceItem.id ?? item.sourceItem,
              )),
              title: l10n.mass_migration_source_chapters,
              chapters: item.sourceItem.chapters.map(
                (chapter) =>
                    chapter.name ?? l10n.mass_migration_unknown_chapter,
              ),
            ),
            MassMigrationChapterSection(
              key: PageStorageKey((
                'mass-review-target',
                item.sourceItem.id ?? item.sourceItem,
                item.selectedCandidate?.link,
              )),
              title: l10n.mass_migration_destination_chapters,
              chapters:
                  chapters?.map(
                    (chapter) =>
                        chapter.name ?? l10n.mass_migration_unknown_chapter,
                  ) ??
                  const [],
            ),
          ],
        ),
      ),
    );
  }
}

class MobileMassMigrationProgress extends StatelessWidget {
  const MobileMassMigrationProgress({
    super.key,
    required this.heading,
    required this.progressLabel,
    required this.completed,
    required this.total,
    required this.current,
    this.destination,
    this.note,
    this.status,
  });
  final String heading, progressLabel;
  final int completed, total;
  final Widget? current, destination;
  final String? note, status;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.symmetric(vertical: 12),
    children: [
      NodeLaneGroupSurface(
        margin: const EdgeInsets.fromLTRB(
          NodeLaneTokens.gutter,
          0,
          NodeLaneTokens.gutter,
          NodeLaneTokens.space12,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(heading, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: total == 0 ? 1 : completed / total,
              ),
              const SizedBox(height: 12),
              Text(progressLabel),
              if (note != null) ...[const SizedBox(height: 8), Text(note!)],
              if (status != null) ...[
                const SizedBox(height: 12),
                Text(status!),
              ],
            ],
          ),
        ),
      ),
      if (current != null)
        NodeLaneGroupSurface(
          margin: const EdgeInsets.fromLTRB(
            NodeLaneTokens.gutter,
            0,
            NodeLaneTokens.gutter,
            NodeLaneTokens.space12,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                current!,
                if (destination != null) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Icon(Icons.arrow_downward_rounded),
                  ),
                  destination!,
                ],
              ],
            ),
          ),
        ),
    ],
  );
}

class MobileMassMigrationSummary extends StatelessWidget {
  const MobileMassMigrationSummary({
    super.key,
    required this.route,
    required this.total,
    required this.matched,
    required this.migrated,
    required this.skipped,
    required this.failures,
  });
  final String route;
  final int total, matched, migrated, skipped;
  final List<String> failures;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stats = [
      (l10n.mass_migration_processed, total),
      (l10n.mass_migration_matched, matched),
      (l10n.mass_migration_migrated, migrated),
      (l10n.mass_migration_skipped, skipped),
      (l10n.mass_migration_failed, failures.length),
    ];
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: NodeLaneGroupSurface(
            margin: const EdgeInsets.fromLTRB(
              NodeLaneTokens.gutter,
              0,
              NodeLaneTokens.gutter,
              NodeLaneTokens.space12,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    failures.isNotEmpty
                        ? l10n.mass_migration_needs_review
                        : migrated == 0
                        ? l10n.mass_migration_finish_review
                        : l10n.mass_migration_complete,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(route),
                  const SizedBox(height: 12),
                  Text(
                    failures.isNotEmpty
                        ? l10n.migration_partial_failure
                        : migrated == 0
                        ? l10n.mass_migration_no_items_selected
                        : l10n.mass_migration_complete_success_message,
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: NodeLaneGroupSurface(
            margin: const EdgeInsets.fromLTRB(
              NodeLaneTokens.gutter,
              0,
              NodeLaneTokens.gutter,
              NodeLaneTokens.space12,
            ),
            child: Column(
              children: [
                for (final stat in stats)
                  ListTile(title: Text(stat.$1), trailing: Text('${stat.$2}')),
              ],
            ),
          ),
        ),
        if (failures.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Text(
                l10n.mass_migration_failed_items,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.builder(
              itemCount: failures.length,
              itemBuilder: (_, index) => ListTile(
                leading: const Icon(Icons.error_outline_rounded),
                title: Text(failures[index]),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
