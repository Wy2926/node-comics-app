import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_source_badge_provider.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Manga presentation only. The existing providers still own preferences and
/// filtering; the shared streams keep the open sheet on current settings.
class MobileBookshelfSettings extends ConsumerWidget {
  const MobileBookshelfSettings({
    super.key,
    required this.settings,
    required this.entries,
  });
  final Settings settings;
  final List<Manga> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current =
        ref.watch(getSettingsStreamProvider).asData?.value ?? settings;
    final currentEntries =
        ref
            .watch(
              getAllMangaStreamProvider(
                categoryId: null,
                itemType: ItemType.manga,
              ),
            )
            .asData
            ?.value ??
        entries;
    final l10n = context.l10n;
    return NodeLaneSurface(
      child: NodeLaneSheetSurface(
        grouped: true,
        child: SafeArea(
          top: false,
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                NodeLaneSheetHeading(
                  title: l10n.bookshelf_settings,
                  subtitle: l10n.bookshelf_settings_live,
                ),
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
                      _Filters(settings: current, entries: currentEntries),
                      _Sort(settings: current),
                      _Display(settings: current),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Filters extends ConsumerWidget {
  const _Filters({required this.settings, required this.entries});
  final Settings settings;
  final List<Manga> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final downloaded = mangaFilterDownloadedStateProvider(
      mangaList: const [],
      itemType: ItemType.manga,
      settings: settings,
    );
    final unread = mangaFilterUnreadStateProvider(
      mangaList: const [],
      itemType: ItemType.manga,
      settings: settings,
    );
    final started = mangaFilterStartedStateProvider(
      mangaList: const [],
      itemType: ItemType.manga,
      settings: settings,
    );
    final bookmarked = mangaFilterBookmarkedStateProvider(
      mangaList: const [],
      itemType: ItemType.manga,
      settings: settings,
    );
    final completed = mangaFilterCompletedStateProvider(
      mangaList: const [],
      itemType: ItemType.manga,
      settings: settings,
    );
    final tracked = mangaFilterTrackingStateProvider(
      mangaList: const [],
      itemType: ItemType.manga,
      settings: settings,
    );
    final sources = ref.watch(
      mangaFilterSourceStateProvider(
        mangaList: entries,
        itemType: ItemType.manga,
        settings: settings,
      ),
    );
    final filters = <(String, int, ValueChanged<int>)>[
      (
        l10n.downloaded,
        ref.watch(downloaded),
        (value) => ref.read(downloaded.notifier).setType(value),
      ),
      (
        l10n.unread,
        ref.watch(unread),
        (value) => ref.read(unread.notifier).setType(value),
      ),
      (
        l10n.started,
        ref.watch(started),
        (value) => ref.read(started.notifier).setType(value),
      ),
      (
        l10n.bookmarked,
        ref.watch(bookmarked),
        (value) => ref.read(bookmarked.notifier).setType(value),
      ),
      (
        l10n.completed,
        ref.watch(completed),
        (value) => ref.read(completed.notifier).setType(value),
      ),
      (
        l10n.tracked,
        ref.watch(tracked),
        (value) => ref.read(tracked.notifier).setType(value),
      ),
    ];
    return ListView(
      key: const PageStorageKey('bookshelf-filters'),
      padding: const EdgeInsets.all(NodeLaneTokens.gutter),
      children: [
        MobileSettingsGroup(
          children: [
            for (var index = 0; index < filters.length; index++)
              NodeLaneChoiceRow<int>(
                key: ValueKey('bookshelf-filter-$index'),
                title: filters[index].$1,
                value: filters[index].$2,
                segments: [
                  ButtonSegment(
                    value: 0,
                    label: Text(
                      l10n.bookshelf_filter_any,
                      semanticsLabel:
                          '${filters[index].$1}, ${l10n.bookshelf_filter_any}',
                    ),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text(
                      l10n.bookshelf_filter_include,
                      semanticsLabel:
                          '${filters[index].$1}, ${l10n.bookshelf_filter_include}',
                    ),
                  ),
                  ButtonSegment(
                    value: 2,
                    label: Text(
                      l10n.bookshelf_filter_exclude,
                      semanticsLabel:
                          '${filters[index].$1}, ${l10n.bookshelf_filter_exclude}',
                    ),
                  ),
                ],
                onChanged: filters[index].$3,
              ),
          ],
        ),
        if (sources.$1.length > 1 || sources.$2.isNotEmpty)
          MobileSettingsGroup(
            children: [
              MobileSettingsLink(
                title: l10n.sources,
                subtitle: sources.$2.isEmpty
                    ? l10n.bookshelf_all_sources
                    : l10n.bookshelf_sources_selected(sources.$2.length),
                icon: NodeLaneIcons.of(context).web,
                onTap: () async {
                  final selected = await Navigator.of(context)
                      .push<List<String>>(
                        MaterialPageRoute(
                          builder: (_) => MobileBookshelfSourceFilter(
                            sources: sources.$1,
                            selected: sources.$2,
                          ),
                        ),
                      );
                  if (!context.mounted || selected == null) return;
                  // The source list may change while the choice page is open.
                  final current =
                      ref.read(getSettingsStreamProvider).asData?.value ??
                      settings;
                  final currentEntries =
                      ref
                          .read(
                            getAllMangaStreamProvider(
                              categoryId: null,
                              itemType: ItemType.manga,
                            ),
                          )
                          .asData
                          ?.value ??
                      entries;
                  final provider = mangaFilterSourceStateProvider(
                    mangaList: currentEntries,
                    itemType: ItemType.manga,
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
      ],
    );
  }
}

class _Sort extends ConsumerWidget {
  const _Sort({required this.settings});
  final Settings settings;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = sortLibraryMangaStateProvider(
      itemType: ItemType.manga,
      settings: settings,
    );
    final sort = ref.watch(provider);
    final index = sort.index ?? 0;
    final reverse = sort.reverse ?? false;
    final names = [
      l10n.alphabetically,
      l10n.last_read,
      l10n.last_update_check,
      l10n.unread_count,
      l10n.total_chapters,
      l10n.latest_chapter,
      l10n.date_added,
    ];
    return ListView(
      key: const PageStorageKey('bookshelf-sort'),
      padding: const EdgeInsets.all(NodeLaneTokens.gutter),
      children: [
        NodeLaneSegments<bool>(
          segments: [
            ButtonSegment(
              value: false,
              icon: Icon(NodeLaneIcons.of(context).ascending),
              label: Text(l10n.bookshelf_sort_ascending),
            ),
            ButtonSegment(
              value: true,
              icon: Icon(NodeLaneIcons.of(context).descending),
              label: Text(l10n.bookshelf_sort_descending),
            ),
          ],
          value: reverse,
          onChanged: (value) {
            final current = ref.read(provider);
            if (value != (current.reverse ?? false)) {
              ref.read(provider.notifier).set(current.index ?? 0);
            }
          },
        ),
        const SizedBox(height: 20),
        MobileSettingsGroup(
          children: [
            for (var i = 0; i < names.length; i++)
              ListTile(
                selected: index == i,
                title: Text(names[i]),
                minTileHeight: 56,
                trailing: index == i
                    ? Icon(
                        NodeLaneIcons.of(context).check,
                        color: NodeLaneTokens.of(context).accent,
                      )
                    : null,
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

class _Display extends ConsumerWidget {
  const _Display({required this.settings});
  final Settings settings;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final displayProvider = libraryDisplayTypeStateProvider(
      itemType: ItemType.manga,
      settings: settings,
    );
    final display = ref.watch(displayProvider);
    final gridProvider = libraryGridSizeStateProvider(itemType: ItemType.manga);
    final grid = (ref.watch(gridProvider) ?? 0).clamp(0, 7);
    final downloaded = libraryDownloadedChaptersStateProvider(
      itemType: ItemType.manga,
      settings: settings,
    );
    final language = libraryLanguageStateProvider(
      itemType: ItemType.manga,
      settings: settings,
    );
    final local = libraryLocalSourceStateProvider(
      itemType: ItemType.manga,
      settings: settings,
    );
    final continueReading = libraryShowContinueReadingButtonStateProvider(
      itemType: ItemType.manga,
      settings: settings,
    );
    final categoryTabs = libraryShowCategoryTabsStateProvider(
      itemType: ItemType.manga,
      settings: settings,
    );
    final counts = libraryShowNumbersOfItemsStateProvider(
      itemType: ItemType.manga,
      settings: settings,
    );
    return ListView(
      key: const PageStorageKey('bookshelf-display'),
      padding: const EdgeInsets.all(NodeLaneTokens.gutter),
      children: [
        MobileSettingsGroup(
          title: l10n.display_mode,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final type in DisplayType.values)
                    ChoiceChip(
                      label: Text(
                        ref
                            .read(displayProvider.notifier)
                            .getLibraryDisplayTypeName(type, context),
                      ),
                      selected: display == type,
                      onSelected: (selected) {
                        if (selected && type != display) {
                          ref
                              .read(displayProvider.notifier)
                              .setLibraryDisplayType(type);
                        }
                      },
                    ),
                ],
              ),
            ),
            if (display != DisplayType.list)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${l10n.grid_size} · ${grid == 0 ? l10n.default0 : l10n.n_per_row('$grid')}',
                    ),
                    Slider(
                      value: grid.toDouble(),
                      min: 0,
                      max: 7,
                      divisions: 7,
                      label: grid == 0
                          ? l10n.default0
                          : l10n.n_per_row('$grid'),
                      onChanged: (value) =>
                          ref.read(gridProvider.notifier).set(value.round()),
                      onChangeEnd: (value) => ref
                          .read(gridProvider.notifier)
                          .set(value.round(), end: true),
                    ),
                    Text(
                      l10n.bookshelf_grid_hint,
                      style: TextStyle(
                        fontSize: 13,
                        color: NodeLaneTokens.of(context).muted,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        MobileSettingsGroup(
          title: l10n.badges,
          children: [
            MobileSettingsSwitch(
              title: l10n.downloaded_chapters,
              icon: NodeLaneIcons.of(context).download,
              value: ref.watch(downloaded),
              onChanged: (value) => ref.read(downloaded.notifier).set(value),
            ),
            MobileSettingsSwitch(
              title: l10n.language,
              icon: NodeLaneIcons.of(context).web,
              value: ref.watch(language),
              onChanged: (value) => ref.read(language.notifier).set(value),
            ),
            MobileSettingsSwitch(
              title: l10n.source,
              icon: NodeLaneIcons.of(context).web,
              value: ref.watch(librarySourceBadgeProvider),
              onChanged: (value) =>
                  ref.read(librarySourceBadgeProvider.notifier).set(value),
            ),
            MobileSettingsSwitch(
              title: l10n.local_source,
              icon: NodeLaneIcons.of(context).folder,
              value: ref.watch(local),
              onChanged: (value) => ref.read(local.notifier).set(value),
            ),
          ],
        ),
        MobileSettingsGroup(
          title: l10n.bookshelf_layout,
          children: [
            MobileSettingsSwitch(
              title: l10n.show_continue_reading_buttons,
              icon: NodeLaneIcons.of(context).anime,
              value: ref.watch(continueReading),
              onChanged: (value) =>
                  ref.read(continueReading.notifier).set(value),
            ),
            MobileSettingsSwitch(
              title: l10n.show_category_tabs,
              icon: NodeLaneIcons.of(context).categories,
              value: ref.watch(categoryTabs),
              onChanged: (value) => ref.read(categoryTabs.notifier).set(value),
            ),
            MobileSettingsSwitch(
              title: l10n.show_numbers_of_items,
              icon: NodeLaneIcons.of(context).count,
              value: ref.watch(counts),
              onChanged: (value) => ref.read(counts.notifier).set(value),
            ),
          ],
        ),
      ],
    );
  }
}

/// A local draft only. Empty selection retains the existing "all sources"
/// meaning; cancelling never changes the provider's pending or applied values.
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
  late final Set<String> _selected = widget.selected.toSet();
  final _search = TextEditingController();
  String _query = '';
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final visible = widget.sources
        .where(
          (name) => name.toLowerCase().contains(_query.trim().toLowerCase()),
        )
        .toList();
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.sources)),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            NodeLaneSearchField(
                              controller: _search,
                              hint: l10n.search,
                              onChanged: (value) =>
                                  setState(() => _query = value),
                            ),
                            const SizedBox(height: 16),
                            Text(l10n.bookshelf_sources_hint),
                            const SizedBox(height: 8),
                            Text(
                              _selected.isEmpty
                                  ? l10n.bookshelf_all_sources
                                  : l10n.bookshelf_sources_selected(
                                      _selected.length,
                                    ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: _selected.isEmpty
                                    ? null
                                    : () => setState(_selected.clear),
                                child: Text(l10n.reset),
                              ),
                            ),
                            if (visible.isEmpty) Text(l10n.no_result),
                          ],
                        ),
                      ),
                    ),
                    SliverList.builder(
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        final name = visible[index];
                        return CheckboxListTile.adaptive(
                          title: Text(name),
                          value: _selected.contains(name),
                          onChanged: (value) => setState(() {
                            value!
                                ? _selected.add(name)
                                : _selected.remove(name);
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(
                          context,
                          widget.sources.where(_selected.contains).toList(),
                        ),
                        child: Text(l10n.filter),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
