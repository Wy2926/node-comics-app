import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_settings_labels.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/library_filter_controls.dart';

List<String> _groups(Iterable<Chapter> chapters) => chapters
    .map((chapter) => chapter.scanlator)
    .whereType<String>()
    .where((name) => name.isNotEmpty)
    .toSet()
    .toList();

class MobileChapterSettingsPanel extends StatelessWidget {
  const MobileChapterSettingsPanel({
    super.key,
    required this.manga,
    required this.localArchive,
  });
  final Manga manga;
  final bool localArchive;
  String _title(BuildContext context) => manga.itemType == ItemType.anime
      ? context.l10n.filter
      : context.l10n.chapter_settings;
  Future<void> show(BuildContext anchor) => showNodeLaneBubble<void>(
    anchor,
    label: _title(anchor),
    width: NodeLaneTokens.bubbleSettingsWidth,
    child: NodeLaneBubbleFlow(home: this),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n, t = NodeLaneTokens.of(context);
    final comic = manga.itemType == ItemType.manga;
    final tabs = [l10n.filter, l10n.sort, if (comic) l10n.settings];
    return DefaultTabController(
      animationDuration: NodeLaneMotion.time(context),
      length: tabs.length,
      child: Builder(
        builder: (context) {
          final controller = DefaultTabController.of(context);
          return ListenableBuilder(
            listenable: controller,
            builder: (context, _) => CustomScrollView(
              shrinkWrap: true,
              key: PageStorageKey('chapter-settings-${controller.index}'),
              slivers: [
                SliverToBoxAdapter(
                  child: NodeLaneBubbleHeading(
                    _title(context),
                    subtitle: manga.name,
                  ),
                ),
                PinnedHeaderSliver(child: LibrarySettingsTabs(tabs)),
                SliverToBoxAdapter(
                  child: NodeLaneMotion.tabBody(
                    context,
                    controller,
                    Padding(
                      padding: NodeLaneTokens.bubbleContentPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: NodeLaneTokens.space12,
                        children: [
                          switch (controller.index) {
                            0 => _ChapterFilters(
                              manga: manga,
                              localArchive: localArchive,
                            ),
                            1 => _ChapterSort(manga: manga),
                            _ => const _ChapterHabits(),
                          },
                          Text(
                            controller.index == 2
                                ? l10n.comic_chapter_habits_hint
                                : l10n.chapter_settings_live,
                            style: t.readerSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChapterFilters extends ConsumerWidget {
  const _ChapterFilters({required this.manga, required this.localArchive});
  final Manga manga;
  final bool localArchive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final downloaded = chapterFilterDownloadedStateProvider(mangaId: manga.id!);
    final unread = chapterFilterUnreadStateProvider(mangaId: manga.id!);
    final bookmarked = chapterFilterBookmarkedStateProvider(mangaId: manga.id!);
    final chapterStream = getChaptersStreamProvider(mangaId: manga.id!);
    final chapters =
        ref.watch(chapterStream).asData?.value ?? manga.chapters.toList();
    final names = _groups(chapters);
    final scanlatorProvider = scanlatorsFilterStateProvider(manga);
    final excluded = ref.watch(scanlatorProvider).$2;
    final filters = <(String, int, ValueChanged<int>)>[
      if (!localArchive)
        (
          l10n.downloaded,
          ref.watch(downloaded),
          (value) => ref.read(downloaded.notifier).setType(value),
        ),
      (
        manga.itemType == ItemType.anime ? l10n.unwatched : l10n.unread,
        ref.watch(unread),
        (value) => ref.read(unread.notifier).setType(value),
      ),
      (
        l10n.bookmarked,
        ref.watch(bookmarked),
        (value) => ref.read(bookmarked.notifier).setType(value),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: NodeLaneTokens.space12,
      children: [
        LibraryFilterGroup(filters),
        if (names.isNotEmpty || excluded.isNotEmpty)
          NodeLaneRow.card(
            title: l10n.filter_scanlator_groups,
            icon: NodeLaneIcons.of(context).groups,
            onTap: () async {
              final chosen = await pushBrowsePage<List<String>>(
                context,
                _ScanlatorDraft(names: names, excluded: excluded),
              );
              if (!context.mounted || chosen == null) return;
              // A covered route's stream may be paused. Recheck the
              // existing repository once at confirmation, not its cache.
              final available = _groups(
                chapterRepository.getAllByMangaIdIndex(manga.id),
              );
              final next = chosen.where(available.contains).toSet().toList();
              final current = ref.read(scanlatorProvider).$2;
              if (next.length == current.length &&
                  next.every(current.contains)) {
                return;
              }
              ref.read(scanlatorProvider.notifier).set(next);
            },
            value: excluded.isEmpty
                ? l10n.chapter_scanlators_all
                : l10n.chapter_scanlators_hidden(excluded.length),
          ),
      ],
    );
  }
}

class _ChapterSort extends ConsumerWidget {
  const _ChapterSort({required this.manga});
  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = sortChapterStateProvider(mangaId: manga.id!);
    final sort = ref.watch(provider);
    final chapters =
        ref
            .watch(getChaptersStreamProvider(mangaId: manga.id!))
            .asData
            ?.value ??
        manga.chapters.toList();
    final choices = [
      if (_groups(chapters).isNotEmpty || sort.index == 0)
        (0, l10n.by_scanlator),
      (
        1,
        manga.itemType == ItemType.anime
            ? l10n.by_episode_number
            : l10n.by_chapter_number,
      ),
      (2, l10n.by_upload_date),
      (3, l10n.by_name),
    ];
    // The existing chapter comparator uses reverse=true for ascending order.
    return NodeLaneGroupSurface(
      outlined: true,
      children: [
        NodeLaneOptionSwitch<int>(
          value: sort.index ?? 1,
          options: choices,
          onChanged: (index) {
            if (index != ref.read(provider).index) {
              ref.read(provider.notifier).set(index);
            }
          },
        ),
        NodeLaneOptionSwitch<bool>(
          options: [
            (true, l10n.bookshelf_sort_ascending),
            (false, l10n.bookshelf_sort_descending),
          ],
          value: sort.reverse ?? false,
          onChanged: (value) {
            final current = ref.read(provider);
            if (value != (current.reverse ?? false)) {
              ref.read(provider.notifier).set(current.index ?? 1);
            }
          },
        ),
      ],
    );
  }
}

/// A checked group is hidden. Only confirmation returns the draft to the filter.
class _ScanlatorDraft extends StatefulWidget {
  const _ScanlatorDraft({required this.names, required this.excluded});
  final List<String> names, excluded;

  @override
  State<_ScanlatorDraft> createState() => _ScanlatorDraftState();
}

class _ScanlatorDraftState extends State<_ScanlatorDraft> {
  late final _excluded = widget.excluded.toSet();
  final _search = TextEditingController();
  bool _leaving = false;

  void _close({bool save = false}) {
    if (_leaving || ModalRoute.of(context)?.isCurrent != true) return;
    _leaving = true;
    Navigator.pop(
      context,
      save ? widget.names.where(_excluded.contains).toList() : null,
    );
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final query = _search.text.trim().toLowerCase();
    final visible = widget.names
        .where((name) => name.toLowerCase().contains(query))
        .toList();
    return MobileBrowsePage.form(
      title: l10n.filter_scanlator_groups,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              NodeLaneTokens.gutter,
              NodeLaneTokens.space8,
              NodeLaneTokens.gutter,
              NodeLaneTokens.space12,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NodeLaneTextField.search(
                    controller: _search,
                    hint: l10n.search,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: NodeLaneTokens.space16),
                  Text(l10n.chapter_scanlators_hint),
                  const SizedBox(height: NodeLaneTokens.space8),
                  Text(
                    _excluded.isEmpty
                        ? l10n.chapter_scanlators_all
                        : l10n.chapter_scanlators_hidden(_excluded.length),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: _excluded.isEmpty
                          ? null
                          : () => setState(_excluded.clear),
                      child: Text(l10n.reset),
                    ),
                  ),
                  if (visible.isEmpty) Text(l10n.no_result),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: NodeLaneTokens.gutter,
            ),
            sliver: SliverList.builder(
              itemCount: visible.length,
              itemBuilder: (_, index) => NodeLaneRow.card(
                title: visible[index],
                checkable: true,
                selected: _excluded.contains(visible[index]),
                first: index == 0,
                last: index == visible.length - 1,
                onTap: () => setState(() {
                  if (!_excluded.add(visible[index])) {
                    _excluded.remove(visible[index]);
                  }
                }),
              ),
            ),
          ),
        ],
      ),
      bottomAction: NodeLaneModalActions(
        actions: [
          NodeLaneDialogAction(
            label: l10n.cancel,
            secondary: true,
            onPressed: _close,
          ),
          NodeLaneDialogAction(
            label: l10n.filter,
            onPressed: () => _close(save: true),
          ),
        ],
      ),
    );
  }
}

class _ChapterHabits extends ConsumerWidget {
  const _ChapterHabits();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    Widget choices(
      String title,
      ChapterSwipeAction value,
      ValueChanged<ChapterSwipeAction> onChanged,
    ) => NodeLaneOptionSwitch<ChapterSwipeAction>(
      title: title,
      value: value,
      options: [
        for (final action in ChapterSwipeAction.values)
          (action, getChapterSwipeActionName(action, context)),
      ],
      onChanged: onChanged,
    );
    return NodeLaneGroupSurface(
      outlined: true,
      children: [
        choices(
          l.chapter_swipe_start,
          ref.watch(chapterSwipeStartActionStateProvider),
          ref.read(chapterSwipeStartActionStateProvider.notifier).set,
        ),
        choices(
          l.chapter_swipe_end,
          ref.watch(chapterSwipeEndActionStateProvider),
          ref.read(chapterSwipeEndActionStateProvider.notifier).set,
        ),
        NodeLaneSwitchRow(
          title: l.mark_duplicate_chapters_read,
          value: ref.watch(autoReadDuplicateChaptersStateProvider),
          onChanged: ref
              .read(autoReadDuplicateChaptersStateProvider.notifier)
              .set,
        ),
      ],
    );
  }
}
