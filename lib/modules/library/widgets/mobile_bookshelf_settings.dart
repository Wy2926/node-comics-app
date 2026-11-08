import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_source_badge_provider.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation only. All three media use their existing preference providers.
class MobileBookshelfSettings extends ConsumerWidget {
  const MobileBookshelfSettings({
    super.key,
    required this.settings,
    required this.entries,
    this.itemType = ItemType.manga,
  });
  final Settings settings;
  final List<Manga> entries;
  final ItemType itemType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current =
        ref.watch(getSettingsStreamProvider).asData?.value ?? settings;
    final currentEntries =
        ref
            .watch(
              getAllMangaStreamProvider(categoryId: null, itemType: itemType),
            )
            .asData
            ?.value ??
        entries;
    final l10n = context.l10n;
    return NodeLaneCatalogSheet(
      title: l10n.bookshelf_settings,
      subtitle: l10n.bookshelf_settings_live,
      heightFactor: .9,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NodeLaneTokens.gutter,
              ),
              child: NodeLaneTabSegments(
                labels: [l10n.filter, l10n.sort, l10n.display],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _Filters(
                    settings: current,
                    entries: currentEntries,
                    itemType: itemType,
                  ),
                  _Sort(settings: current, itemType: itemType),
                  _Display(settings: current, itemType: itemType),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Filters extends ConsumerWidget {
  const _Filters({
    required this.settings,
    required this.entries,
    required this.itemType,
  });
  final Settings settings;
  final List<Manga> entries;
  final ItemType itemType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final downloaded = mangaFilterDownloadedStateProvider(
      mangaList: const [],
      itemType: itemType,
      settings: settings,
    );
    final unread = mangaFilterUnreadStateProvider(
      mangaList: const [],
      itemType: itemType,
      settings: settings,
    );
    final started = mangaFilterStartedStateProvider(
      mangaList: const [],
      itemType: itemType,
      settings: settings,
    );
    final bookmarked = mangaFilterBookmarkedStateProvider(
      mangaList: const [],
      itemType: itemType,
      settings: settings,
    );
    final completed = mangaFilterCompletedStateProvider(
      mangaList: const [],
      itemType: itemType,
      settings: settings,
    );
    final tracked = mangaFilterTrackingStateProvider(
      mangaList: const [],
      itemType: itemType,
      settings: settings,
    );
    final sourceProvider = mangaFilterSourceStateProvider(
      mangaList: entries,
      itemType: itemType,
      settings: settings,
    );
    final sources = ref.watch(sourceProvider);
    final filters = <(String, int, ValueChanged<int>)>[
      (
        l10n.downloaded,
        ref.watch(downloaded),
        (v) => ref.read(downloaded.notifier).setType(v),
      ),
      (
        itemType == ItemType.anime ? l10n.unwatched : l10n.unread,
        ref.watch(unread),
        (v) => ref.read(unread.notifier).setType(v),
      ),
      (
        l10n.started,
        ref.watch(started),
        (v) => ref.read(started.notifier).setType(v),
      ),
      (
        l10n.bookmarked,
        ref.watch(bookmarked),
        (v) => ref.read(bookmarked.notifier).setType(v),
      ),
      (
        l10n.completed,
        ref.watch(completed),
        (v) => ref.read(completed.notifier).setType(v),
      ),
      (
        l10n.tracked,
        ref.watch(tracked),
        (v) => ref.read(tracked.notifier).setType(v),
      ),
    ];
    final choices = [
      l10n.bookshelf_filter_any,
      l10n.bookshelf_filter_include,
      l10n.bookshelf_filter_exclude,
    ];
    return ListView(
      key: const PageStorageKey('bookshelf-filters'),
      padding: const EdgeInsets.all(NodeLaneTokens.gutter),
      children: [
        NodeLaneGroupSurface(
          children: [
            for (var i = 0; i < filters.length; i++)
              NodeLaneChoiceRow<int>(
                key: ValueKey('bookshelf-filter-$i'),
                title: filters[i].$1,
                value: filters[i].$2,
                onChanged: filters[i].$3,
                segments: [
                  for (var j = 0; j < 3; j++)
                    ButtonSegment(
                      value: j,
                      label: Text(
                        choices[j],
                        semanticsLabel: '${filters[i].$1}, ${choices[j]}',
                      ),
                    ),
                ],
              ),
          ],
        ),
        const SizedBox(height: NodeLaneTokens.space16),
        NodeLaneGroupSurface(
          children: [
            NodeLaneRow(
              title: l10n.sources,
              value: sources.$2.isEmpty
                  ? l10n.bookshelf_all_sources
                  : l10n.bookshelf_sources_selected(sources.$2.length),
              onTap: () async {
                final selected = await showNodeLaneCatalogSheet<List<String>>(
                  context,
                  MobileBookshelfSourceFilter(
                    sources: sources.$1,
                    selected: sources.$2,
                  ),
                );
                if (!context.mounted || selected == null) return;
                final current =
                    ref.read(getSettingsStreamProvider).asData?.value ??
                    settings;
                final currentEntries =
                    ref
                        .read(
                          getAllMangaStreamProvider(
                            categoryId: null,
                            itemType: itemType,
                          ),
                        )
                        .asData
                        ?.value ??
                    entries;
                final provider = mangaFilterSourceStateProvider(
                  mangaList: currentEntries,
                  itemType: itemType,
                  settings: current,
                );
                final available = ref.read(provider).$1;
                ref
                    .read(provider.notifier)
                    .set(selected.where(available.contains).toList());
              },
            ),
          ],
        ),
        const SizedBox(height: NodeLaneTokens.space8),
        TextButton(
          onPressed: filters.any((f) => f.$2 != 0) || sources.$2.isNotEmpty
              ? () {
                  for (final filter in filters) {
                    if (filter.$2 != 0) filter.$3(0);
                  }
                  if (sources.$2.isNotEmpty) {
                    ref.read(sourceProvider.notifier).set([]);
                  }
                }
              : null,
          child: Text(l10n.reset),
        ),
      ],
    );
  }
}

class _Sort extends ConsumerWidget {
  const _Sort({required this.settings, required this.itemType});
  final Settings settings;
  final ItemType itemType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = sortLibraryMangaStateProvider(
      itemType: itemType,
      settings: settings,
    );
    final sort = ref.watch(provider);
    final anime = itemType == ItemType.anime;
    final names = [
      l10n.alphabetically,
      anime ? l10n.last_watched : l10n.last_read,
      l10n.last_update_check,
      anime ? l10n.unwatched_count : l10n.unread_count,
      anime ? l10n.total_episodes : l10n.total_chapters,
      anime ? l10n.latest_episode : l10n.latest_chapter,
      l10n.date_added,
    ];
    return ListView(
      key: const PageStorageKey('bookshelf-sort'),
      padding: const EdgeInsets.all(NodeLaneTokens.gutter),
      children: [
        NodeLaneSegments<bool>(
          value: sort.reverse ?? false,
          segments: [
            ButtonSegment(
              value: false,
              label: Text(l10n.bookshelf_sort_ascending),
            ),
            ButtonSegment(
              value: true,
              label: Text(l10n.bookshelf_sort_descending),
            ),
          ],
          onChanged: (value) {
            final current = ref.read(provider);
            if (value != (current.reverse ?? false)) {
              ref.read(provider.notifier).set(current.index ?? 0);
            }
          },
        ),
        const SizedBox(height: NodeLaneTokens.space16),
        NodeLaneGroupSurface(
          children: [
            for (var i = 0; i < names.length; i++)
              NodeLaneRow(
                title: names[i],
                selected: (sort.index ?? 0) == i,
                onTap: () {
                  if ((ref.read(provider).index ?? 0) != i) {
                    ref.read(provider.notifier).set(i);
                  }
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _Display extends ConsumerStatefulWidget {
  const _Display({required this.settings, required this.itemType});
  final Settings settings;
  final ItemType itemType;
  @override
  ConsumerState<_Display> createState() => _DisplayState();
}

class _DisplayState extends ConsumerState<_Display> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final settings = widget.settings, itemType = widget.itemType;
    final l10n = context.l10n, icons = NodeLaneIcons.of(context);
    final displayProvider = libraryDisplayTypeStateProvider(
      itemType: itemType,
      settings: settings,
    );
    final display = ref.watch(displayProvider);
    final downloaded = libraryDownloadedChaptersStateProvider(
      itemType: itemType,
      settings: settings,
    );
    final language = libraryLanguageStateProvider(
      itemType: itemType,
      settings: settings,
    );
    final local = libraryLocalSourceStateProvider(
      itemType: itemType,
      settings: settings,
    );
    final resume = libraryShowContinueReadingButtonStateProvider(
      itemType: itemType,
      settings: settings,
    );
    final categories = libraryShowCategoryTabsStateProvider(
      itemType: itemType,
      settings: settings,
    );
    final counts = libraryShowNumbersOfItemsStateProvider(
      itemType: itemType,
      settings: settings,
    );
    const modes = [
      DisplayType.comfortableGrid,
      DisplayType.compactGrid,
      DisplayType.coverOnlyGrid,
      DisplayType.list,
    ];
    Widget option(DisplayType type) => NodeLaneChoiceCard(
      title: ref
          .read(displayProvider.notifier)
          .getLibraryDisplayTypeName(type, context),
      preview: _LayoutPreview(type: type),
      selected: display == type,
      onTap: () {
        if (display != type) {
          ref.read(displayProvider.notifier).setLibraryDisplayType(type);
        }
      },
    );
    return ListView(
      key: const PageStorageKey('bookshelf-display'),
      padding: const EdgeInsets.all(NodeLaneTokens.gutter),
      children: [
        for (var i = 0; i < modes.length; i += 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: option(modes[i])),
              const SizedBox(width: NodeLaneTokens.space8),
              Expanded(child: option(modes[i + 1])),
            ],
          ),
          const SizedBox(height: NodeLaneTokens.space8),
        ],
        const SizedBox(height: NodeLaneTokens.space8),
        NodeLaneGroupSurface(
          children: [
            NodeLaneSwitchRow(
              title: itemType == ItemType.anime
                  ? l10n.show_continue_watching_buttons
                  : l10n.show_continue_reading_buttons,
              icon: itemType == ItemType.anime ? icons.anime : icons.manga,
              value: ref.watch(resume),
              onChanged: (v) => ref.read(resume.notifier).set(v),
            ),
          ],
        ),
        const SizedBox(height: NodeLaneTokens.space16),
        NodeLaneGroupSurface(
          children: [
            NodeLaneRow(
              title: l10n.bookshelf_more_display,
              subtitle: l10n.bookshelf_more_display_hint,
              trailing: AnimatedRotation(
                turns: _expanded ? .5 : 0,
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  icons.down,
                  size: NodeLaneTokens.smallIconSize,
                  color: NodeLaneTokens.of(context).muted,
                ),
              ),
              onTap: () => setState(() => _expanded = !_expanded),
            ),
          ],
        ),
        if (_expanded) ...[
          NodeLaneCatalogHeading(l10n.badges),
          NodeLaneGroupSurface(
            children: [
              NodeLaneSwitchRow(
                title: l10n.bookshelf_download_count,
                icon: icons.download,
                value: ref.watch(downloaded),
                onChanged: (v) => ref.read(downloaded.notifier).set(v),
              ),
              NodeLaneSwitchRow(
                title: l10n.language,
                icon: icons.translate,
                value: ref.watch(language),
                onChanged: (v) => ref.read(language.notifier).set(v),
              ),
              NodeLaneSwitchRow(
                title: l10n.source,
                icon: icons.web,
                value: ref.watch(librarySourceBadgeProvider),
                onChanged: (v) =>
                    ref.read(librarySourceBadgeProvider.notifier).set(v),
              ),
              NodeLaneSwitchRow(
                title: l10n.local_source,
                icon: icons.folderOutline,
                value: ref.watch(local),
                onChanged: (v) => ref.read(local.notifier).set(v),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: NodeLaneTokens.space8),
            child: Text(
              l10n.bookshelf_source_global_hint,
              style: NodeLaneTokens.of(context).readerSecondary,
            ),
          ),
          NodeLaneCatalogHeading(l10n.bookshelf_layout),
          NodeLaneGroupSurface(
            children: [
              NodeLaneSwitchRow(
                title: l10n.show_category_tabs,
                icon: icons.categories,
                value: ref.watch(categories),
                onChanged: (v) => ref.read(categories.notifier).set(v),
              ),
              NodeLaneSwitchRow(
                title: l10n.show_numbers_of_items,
                icon: icons.count,
                value: ref.watch(counts),
                onChanged: (v) => ref.read(counts.notifier).set(v),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Small illustrations of the four existing modes, not another control renderer.
class _LayoutPreview extends StatelessWidget {
  const _LayoutPreview({required this.type});
  final DisplayType type;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    Widget block() => DecoratedBox(
      decoration: BoxDecoration(
        color: t.muted.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(NodeLaneTokens.space4),
      ),
      child: const SizedBox.expand(),
    );
    if (type == DisplayType.list) {
      return Column(
        children: [
          for (var i = 0; i < 2; i++) ...[
            if (i > 0) const SizedBox(height: NodeLaneTokens.space4),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: 12, child: block()),
                  const SizedBox(width: NodeLaneTokens.space4),
                  Expanded(
                    child: Center(child: SizedBox(height: 4, child: block())),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }
    return Center(
      child: SizedBox(
        width: type == DisplayType.comfortableGrid ? 56 : 76,
        child: Row(
          children: [
            for (
              var i = 0;
              i < (type == DisplayType.comfortableGrid ? 2 : 3);
              i++
            ) ...[
              if (i > 0) const SizedBox(width: NodeLaneTokens.space4),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: block()),
                    if (type != DisplayType.coverOnlyGrid) ...[
                      const SizedBox(height: 4),
                      SizedBox(height: 4, child: block()),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A local draft; hidden search results stay selected until explicit application.
class MobileBookshelfSourceFilter extends StatefulWidget {
  const MobileBookshelfSourceFilter({
    super.key,
    required this.sources,
    required this.selected,
  });
  final List<String> sources, selected;
  @override
  State<MobileBookshelfSourceFilter> createState() =>
      _MobileBookshelfSourceFilterState();
}

class _MobileBookshelfSourceFilterState
    extends State<MobileBookshelfSourceFilter> {
  late final _selected = widget.selected.toSet();
  final _query = TextEditingController();
  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final query = _query.text.trim().toLowerCase();
    final visible = widget.sources
        .where((s) => s.toLowerCase().contains(query))
        .toList();
    return NodeLaneCatalogSheet(
      title: l10n.sources,
      subtitle: l10n.bookshelf_sources_hint,
      heightFactor: .86,
      bottom: Row(
        children: [
          Expanded(
            child: NodeLaneSecondaryButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ),
          const SizedBox(width: NodeLaneTokens.space12),
          Expanded(
            child: FilledButton(
              onPressed: () => Navigator.pop(
                context,
                _selected.where(widget.sources.contains).toList(),
              ),
              child: Text(l10n.filter),
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NodeLaneTokens.gutter,
            ),
            child: Column(
              children: [
                NodeLaneTextField.search(
                  controller: _query,
                  hint: l10n.search,
                  onChanged: (_) => setState(() {}),
                ),
                NodeLaneCatalogHeading(
                  _selected.isEmpty
                      ? l10n.bookshelf_all_sources
                      : l10n.bookshelf_sources_selected(_selected.length),
                  action: l10n.reset,
                  onAction: _selected.isEmpty
                      ? null
                      : () => setState(_selected.clear),
                ),
              ],
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? Center(child: Text(l10n.no_result))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NodeLaneTokens.gutter,
                    ),
                    itemCount: visible.length,
                    itemBuilder: (_, i) {
                      final name = visible[i];
                      return NodeLaneGroupSurface(
                        first: i == 0,
                        last: i == visible.length - 1,
                        child: Column(
                          children: [
                            NodeLaneRow(
                              title: name,
                              checkable: true,
                              selected: _selected.contains(name),
                              onTap: () => setState(() {
                                if (!_selected.add(name)) {
                                  _selected.remove(name);
                                }
                              }),
                            ),
                            if (i < visible.length - 1)
                              const NodeLaneGroupDivider(),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
