import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/download_quick_menu.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_actions.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/widgets/tv_menu.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

enum DetailHeaderPosition { top, scrolled, pastCover }

class DetailAppBar extends ConsumerWidget {
  final Manga manga;

  /// Every chapter currently shown, needed for "select all" - not
  /// derivable from a provider, it's whatever _buildWidget's own sort/filter
  /// pass produced for this build.
  final List<Chapter> chapters;

  final DetailHeaderPosition position;
  final Future<void> Function(List<Chapter>) onDownload;
  final VoidCallback onShowFilterMenu;
  final Future<void> Function(BuildContext origin, int value) onOverflowAction;

  const DetailAppBar({
    super.key,
    required this.manga,
    required this.chapters,
    required this.position,
    required this.onDownload,
    required this.onShowFilterMenu,
    required this.onOverflowAction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecting = ref.watch(isLongPressedStateProvider);
    return NodeLaneContentMotion(
      value: selecting,
      reverse: !selecting,
      child: _bar(context, ref, selecting),
    );
  }

  Widget _bar(BuildContext context, WidgetRef ref, bool isLongPressed) {
    final l10n = l10nLocalizations(context)!;
    final mobile = isMobile && !isTv;
    final itemType = manga.itemType;
    final isLocalArchive = manga.isLocalArchive ?? false;
    final chapterList = ref.watch(chaptersListStateProvider);
    final mobileManga = mobile && itemType == ItemType.manga;

    void cancelSelection() {
      ref.read(chaptersListStateProvider.notifier).clear();
      ref.read(isLongPressedStateProvider.notifier).update(false);
    }

    void selectAll() {
      ref.read(chaptersListStateProvider.notifier).selectAll(chapters);
    }

    void invertSelection() {
      ref.read(chaptersListStateProvider.notifier).invert(chapters);
      if (!mobileManga && ref.read(chaptersListStateProvider).isEmpty) {
        ref.read(isLongPressedStateProvider.notifier).update(false);
      }
    }

    final checkCategoryList =
        !mobileManga &&
        (ref
                .watch(getMangaCategorieStreamProvider(itemType: itemType))
                .asData
                ?.value
                .isNotEmpty ??
            false);
    if (mobile) {
      return isLongPressed
          ? nodeLaneSelectionAppBar(
              context,
              title: itemType == ItemType.anime
                  ? l10n.bookshelf_selected_count(chapterList.length)
                  : l10n.chapter_selected_count(chapterList.length),
              cancelLabel: l10n.cancel,
              selectAllLabel: l10n.bookshelf_select_all,
              invertLabel: l10n.bookshelf_invert_selection,
              onCancel: cancelSelection,
              onSelectAll: chapters.isEmpty ? null : selectAll,
              onInvert: chapters.isEmpty ? null : invertSelection,
            )
          : nodeLaneAppBar(
              context,
              title: position == DetailHeaderPosition.pastCover
                  ? manga.name ?? ''
                  : '',
              titleStyle: NodeLaneTokens.of(context).readerLabel,
              actions: [
                MobileMangaDetailActionsButton(
                  key: ValueKey(manga.id),
                  title: mobileManga ? null : l10n.more,
                  bookTitle: manga.name ?? '',
                  localArchive: isLocalArchive,
                  favorite:
                      manga.favorite == true &&
                      (mobileManga || checkCategoryList),
                  onSelected: onOverflowAction,
                ),
              ],
            );
    }

    final isNotFiltering = ref.watch(
      chapterFilterResultStateProvider(manga: manga),
    );
    final entries = <(int, String)>[
      if (!isLocalArchive) (0, l10n.refresh),
      if (manga.favorite == true && checkCategoryList) (1, l10n.set_categories),
      if (!isLocalArchive) (2, l10n.share),
      (3, l10n.migrate),
      (6, l10n.mass_migration_title),
      if (!isLocalArchive) (4, l10n.extension_settings),
      (5, l10n.export_metadata),
    ];

    return isLongPressed
        ? Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: AppBar(
              title: Text(chapterList.length.toString()),
              backgroundColor: context.primaryColor.withValues(alpha: 0.2),
              leading: IconButton(
                tooltip: l10n.cancel,
                onPressed: cancelSelection,
                icon: const Icon(Icons.clear),
              ),
              actions: [
                IconButton(
                  tooltip: MaterialLocalizations.of(context)
                      .selectAllButtonLabel,
                  onPressed: selectAll,
                  icon: const Icon(Icons.select_all),
                ),
                IconButton(
                  tooltip: l10n.bookshelf_invert_selection,
                  onPressed: invertSelection,
                  icon: const Icon(Icons.flip_to_back_rounded),
                ),
              ],
            ),
          )
        : AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            title: position == DetailHeaderPosition.pastCover
                ? Text(
                    manga.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17),
                  )
                : null,
            backgroundColor: position == DetailHeaderPosition.top
                ? Colors.transparent
                : Theme.of(context).scaffoldBackgroundColor,
            actions: [
              // Downloads are hidden on TV.
              if (!isLocalArchive && !isTv)
                DownloadQuickMenu(
                  manga: manga,
                  hasChapters: chapters.isNotEmpty,
                  onDownload: onDownload,
                ),
              IconButton(
                tooltip: l10n.filter,
                splashRadius: 20,
                onPressed: onShowFilterMenu,
                icon: Icon(
                  Icons.filter_list_sharp,
                  color: isNotFiltering ? null : Colors.yellow,
                ),
              ),
              if (isTv)
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () async {
                    final picked = await showTvMenu(
                      context,
                      title: manga.name ?? '',
                      options: [
                        for (final (_, label) in entries) TvMenuOption(label),
                      ],
                    );
                    if (picked != null && context.mounted) {
                      await onOverflowAction(context, entries[picked].$1);
                    }
                  },
                )
              else
                PopupMenuButton(
                  tooltip: l10n.more,
                  icon: const Icon(Icons.more_vert),
                  popUpAnimationStyle: NodeLaneMotion.style(context),
                  itemBuilder: (_) => [
                    for (final (id, label) in entries)
                      PopupMenuItem<int>(value: id, child: Text(label)),
                  ],
                  onSelected: (value) => onOverflowAction(context, value),
                ),
            ],
          );
  }
}
