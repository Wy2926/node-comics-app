import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

List<String> _groups(Iterable<Chapter> chapters) => chapters
    .map((chapter) => chapter.scanlator)
    .whereType<String>()
    .where((name) => name.isNotEmpty)
    .toSet()
    .toList();

/// Manga-only presentation of the existing per-book preferences.
class MobileMangaChapterSettings extends StatelessWidget {
  const MobileMangaChapterSettings({
    super.key,
    required this.manga,
    required this.localArchive,
  });
  final Manga manga;
  final bool localArchive;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NodeLaneSurface(
      child: NodeLaneSheetSurface(
        grouped: true,
        radius: NodeLaneTokens.detailSheetRadius,
        child: DefaultTabController(
          length: 2,
          child: Builder(
            builder: (context) {
              final controller = DefaultTabController.of(context);
              return AnimatedBuilder(
                animation: controller,
                builder: (context, _) => SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NodeLaneSheetHeading(
                        title: l10n.chapter_settings,
                        detail: true,
                        subtitle: manga.name ?? '',
                        description: l10n.chapter_settings_live,
                        onClose: () {
                          if (ModalRoute.of(context)?.isCurrent == true) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: NodeLaneTokens.detailGutter,
                        ),
                        child: NodeLaneTabSegments(
                          prominent: true,
                          labels: [l10n.filter, l10n.sort],
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          key: PageStorageKey(
                            'chapter-settings-${controller.index}',
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: NodeLaneTokens.space16,
                          ),
                          child: controller.index == 0
                              ? _ChapterFilters(
                                  manga: manga,
                                  localArchive: localArchive,
                                )
                              : _ChapterSort(manga: manga),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
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
        l10n.unread,
        ref.watch(unread),
        (value) => ref.read(unread.notifier).setType(value),
      ),
      (
        l10n.bookmarked,
        ref.watch(bookmarked),
        (value) => ref.read(bookmarked.notifier).setType(value),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NodeLaneTokens.detailGutter,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MobileSettingsGroup(
            spacing: 12,
            children: [
              for (final filter in filters)
                NodeLaneChoiceRow<int>(
                  compact: true,
                  key: ValueKey('chapter-filter-${filter.$1}'),
                  title: filter.$1,
                  value: filter.$2,
                  segments: [
                    for (final option in [
                      (0, l10n.bookshelf_filter_any),
                      (1, l10n.bookshelf_filter_include),
                      (2, l10n.bookshelf_filter_exclude),
                    ])
                      ButtonSegment(
                        value: option.$1,
                        label: Text(
                          option.$2,
                          semanticsLabel: '${filter.$1}, ${option.$2}',
                        ),
                      ),
                  ],
                  onChanged: filter.$3,
                ),
            ],
          ),
          if (names.isNotEmpty || excluded.isNotEmpty)
            MobileSettingsGroup(
              spacing: 0,
              children: [
                MobileSettingsLink(
                  inlineSubtitle: true,
                  title: l10n.filter_scanlator_groups,
                  subtitle: excluded.isEmpty
                      ? l10n.chapter_scanlators_all
                      : l10n.chapter_scanlators_hidden(excluded.length),
                  icon: NodeLaneIcons.of(context).groups,
                  onTap: () async {
                    final chosen =
                        await Navigator.of(
                          context,
                          rootNavigator: true,
                        ).push<List<String>>(
                          MaterialPageRoute(
                            builder: (_) => MobileScanlatorFilterPage(
                              names: names,
                              excluded: excluded,
                            ),
                          ),
                        );
                    if (!context.mounted || chosen == null) return;
                    // A covered route's stream may be paused. Recheck the
                    // existing repository once at confirmation, not its cache.
                    final available = _groups(
                      chapterRepository.getAllByMangaIdIndex(manga.id),
                    );
                    final next = chosen
                        .where(available.contains)
                        .toSet()
                        .toList();
                    final current = ref.read(scanlatorProvider).$2;
                    if (next.length == current.length &&
                        next.every(current.contains)) {
                      return;
                    }
                    ref.read(scanlatorProvider.notifier).set(next);
                  },
                ),
              ],
            ),
        ],
      ),
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
      (1, l10n.by_chapter_number),
      (2, l10n.by_upload_date),
      (3, l10n.by_name),
    ];
    // The existing chapter comparator uses reverse=true for ascending order.
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NodeLaneTokens.detailGutter,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NodeLaneSegments<bool>(
            segments: [
              ButtonSegment(
                value: true,
                label: Text(l10n.bookshelf_sort_ascending),
                icon: Icon(NodeLaneIcons.of(context).ascending),
              ),
              ButtonSegment(
                value: false,
                label: Text(l10n.bookshelf_sort_descending),
                icon: Icon(NodeLaneIcons.of(context).descending),
              ),
            ],
            value: sort.reverse ?? false,
            onChanged: (value) {
              final current = ref.read(provider);
              if (value != current.reverse) {
                ref.read(provider.notifier).set(current.index!);
              }
            },
          ),
          const SizedBox(height: 16),
          MobileSettingsGroup(
            children: [
              RadioGroup<int>(
                groupValue: sort.index,
                onChanged: (value) {
                  if (value != null && value != ref.read(provider).index) {
                    ref.read(provider.notifier).set(value);
                  }
                },
                child: Column(
                  children: [
                    for (final choice in choices)
                      RadioListTile<int>(
                        value: choice.$1,
                        title: Text(choice.$2),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Checkbox means hidden. This page never touches the persisted filter or the
/// legacy provider draft, so both back and Cancel discard changes.
class MobileScanlatorFilterPage extends StatefulWidget {
  const MobileScanlatorFilterPage({
    super.key,
    required this.names,
    required this.excluded,
  });
  final List<String> names, excluded;

  @override
  State<MobileScanlatorFilterPage> createState() =>
      _MobileScanlatorFilterPageState();
}

class _MobileScanlatorFilterPageState extends State<MobileScanlatorFilterPage> {
  late final _excluded = widget.excluded.toSet();
  final _search = TextEditingController();
  String _query = '';
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
    final visible = widget.names
        .where(
          (name) => name.toLowerCase().contains(_query.trim().toLowerCase()),
        )
        .toList();
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.filter_scanlator_groups)),
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
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            NodeLaneTextField.search(
                              controller: _search,
                              hint: l10n.search,
                              onChanged: (value) =>
                                  setState(() => _query = value),
                            ),
                            const SizedBox(height: 16),
                            Text(l10n.chapter_scanlators_hint),
                            const SizedBox(height: 8),
                            Text(
                              _excluded.isEmpty
                                  ? l10n.chapter_scanlators_all
                                  : l10n.chapter_scanlators_hidden(
                                      _excluded.length,
                                    ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
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
                    SliverList.builder(
                      itemCount: visible.length,
                      itemBuilder: (_, index) => CheckboxListTile.adaptive(
                        title: Text(visible[index]),
                        value: _excluded.contains(visible[index]),
                        onChanged: (value) => setState(() {
                          value!
                              ? _excluded.add(visible[index])
                              : _excluded.remove(visible[index]);
                        }),
                      ),
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
                        onPressed: _close,
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _close(save: true),
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
