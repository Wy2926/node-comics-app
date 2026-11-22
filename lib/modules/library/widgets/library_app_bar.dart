import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/library_screen.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/library_dialogs.dart';
import 'package:mangayomi/modules/library/widgets/library_settings_sheet.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
import 'package:mangayomi/modules/widgets/mobile_media_menu.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/tv_menu.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/more/categories/mobile_categories.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'mobile_bookshelf_actions.dart';
import 'mobile_bookshelf_header.dart';

/// AppBar for the library screen.
///
/// Handles search mode, long-press selection mode, and the popup menu.
class LibraryAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final ItemType itemType;
  final bool isNotFiltering;
  final bool showNumbersOfItems;
  final int numberOfItems;
  final List<Manga> entries, categoryEntries, selectionEntries;
  final Settings settings;
  final bool isSearch;
  final bool ignoreFiltersOnSearch;
  final TextEditingController textEditingController;
  final VoidCallback onSearchToggle;
  final VoidCallback onSearchClear;
  final ValueChanged<bool> onIgnoreFiltersChanged;
  final double mobileHeaderHeight;

  const LibraryAppBar({
    super.key,
    required this.itemType,
    required this.isNotFiltering,
    required this.showNumbersOfItems,
    required this.numberOfItems,
    required this.entries,
    required this.selectionEntries,
    required this.categoryEntries,
    required this.settings,
    required this.isSearch,
    required this.ignoreFiltersOnSearch,
    required this.textEditingController,
    required this.onSearchToggle,
    required this.onSearchClear,
    required this.onIgnoreFiltersChanged,
    required this.mobileHeaderHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    isMobile && !isTv ? mobileHeaderHeight : AppBar().preferredSize.height,
  );

  /// The library menu actions, shared by the popup off-TV and the centred TV
  /// menu.
  void _onLibraryMenu(BuildContext context, WidgetRef ref, int value) {
    if (value == 0) {
      updateLibrary(
        ref: ref,
        context: context,
        mangaList: categoryEntries,
        itemType: itemType,
      );
    } else if (value == 1) {
      final books = isMobile && !isTv ? selectionEntries : categoryEntries;
      if (books.isEmpty) return;
      final randomManga = books[Random().nextInt(books.length)];
      pushToMangaReaderDetail(
        ref: ref,
        archiveId: randomManga.isLocalArchive ?? false ? randomManga.id : null,
        context: context,
        lang: randomManga.lang ?? '',
        mangaM: randomManga,
        source: randomManga.source ?? '',
        sourceId: randomManga.sourceId,
      );
    } else if (value == 2) {
      showImportLocalDialog(context, itemType);
    } else if (value == 3 && itemType == ItemType.anime) {
      addTorrent(context);
    } else if (value == 7) {
      showCategoryManager(context, itemType);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    return NodeLaneContentMotion(
      value: (isLongPressed, isSearch),
      reverse: !isLongPressed && !isSearch,
      child: _bar(context, ref, isLongPressed),
    );
  }

  Widget _bar(BuildContext context, WidgetRef ref, bool isLongPressed) {
    final l10n = l10nLocalizations(context)!;

    if (isLongPressed) {
      return _SelectionAppBar(
        mangaIdsList: ref.watch(mangasListStateProvider),
        data: selectionEntries,
      );
    }

    if (isMobile && !isTv) {
      final hidden = ref.watch(hideItemsStateProvider);
      final updating = ref.watch(libraryUpdateProvider).running;
      return MobileBookshelfHeader(
        searchLabel: l10n.bookshelf_search,
        importLabel: l10n.import,
        filterLabel: l10n.filter,
        controller: textEditingController,
        onSearchChanged: onSearchClear,
        filtered: !isNotFiltering,
        onImport: (anchor) => showImportLocalDialog(anchor, itemType),
        onFilter: (anchor) => showLibrarySettingsSheet(
          context: anchor,
          settings: settings,
          itemType: itemType,
          entries: entries,
        ),
        mediaMenu: MobileMediaMenu(
          value: itemType,
          availableTypes: visibleItemTypes(hidden),
          onChanged: (type) => context.go(libraryRoutes[type]!),
        ),
        updateControl: updating || categoryEntries.isNotEmpty
            ? NodeLaneIconButton(
                tooltip: updating
                    ? l10n.bookshelf_stop_update
                    : l10n.update_library,
                icon: updating
                    ? NodeLaneIcons.of(context).stop
                    : NodeLaneIcons.of(context).refresh,
                onPressed: updating
                    ? () => ref
                          .read(libraryUpdateProvider.notifier)
                          .requestCancel()
                    : () => _onLibraryMenu(context, ref, 0),
              )
            : null,
        menu: Builder(
          builder: (anchor) => NodeLaneIconButton(
            tooltip: l10n.bookshelf_actions,
            icon: NodeLaneIcons.of(context).more,
            onPressed: () async {
              final action = await showNodeLaneBubble<int>(
                anchor,
                label: l10n.bookshelf_actions,
                width: NodeLaneTokens.bubbleFormWidth,
                child: NodeLaneBubbleFlow(
                  home: Builder(
                    builder: (panel) => MobileBookshelfMenu(
                      hasEntries: selectionEntries.isNotEmpty,
                      ignoreFilters: ignoreFiltersOnSearch,
                      itemType: itemType,
                      onSelected: (value) => Navigator.pop(panel, value),
                    ),
                  ),
                ),
              );
              if (!context.mounted || action == null) return;
              if (action == 4) {
                onIgnoreFiltersChanged(!ignoreFiltersOnSearch);
              } else if (action == 6) {
                ref.read(mangasListStateProvider.notifier).clear();
                ref.read(isLongPressedStateProvider.notifier).update(true);
              } else {
                _onLibraryMenu(context, ref, action);
              }
            },
          ),
        ),
      );
    }

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: isSearch
          ? null
          : Row(
              children: [
                Text(
                  itemType.localized(l10n),
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
                const SizedBox(width: 10),
                if (showNumbersOfItems)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Badge(
                      backgroundColor: Theme.of(context).focusColor,
                      label: Text(
                        numberOfItems.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall!.color,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      actions: [
        // Stop a running library update. Only shown while one is in progress.
        if (ref.watch(libraryUpdateProvider).running)
          IconButton(
            splashRadius: 20,
            tooltip: l10n.cancel,
            focusColor: Theme.of(context).colorScheme.primary
                .withValues(alpha: 0.4),
            onPressed: () =>
                ref.read(libraryUpdateProvider.notifier).requestCancel(),
            icon: const Icon(Icons.stop_circle_outlined),
          ),
        isSearch
            ? SeachFormTextField(
                onChanged: (_) => onSearchClear(),
                onPressed: onSearchToggle,
                controller: textEditingController,
                onSuffixPressed: () {
                  textEditingController.clear();
                  onSearchClear();
                },
              )
            : IconButton(
                splashRadius: 20,
                onPressed: () {
                  textEditingController.clear();
                  onSearchToggle();
                },
                icon: const Icon(Icons.search),
              ),
        // Checkbox when searching library to ignore filters
        if (isSearch)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isMobile
                    ? l10n.ignore_filters.replaceFirst(' ', '\n')
                    : l10n.ignore_filters.replaceAll('\n', ''),
                textAlign: TextAlign.center,
              ),
              Checkbox(
                value: ignoreFiltersOnSearch,
                onChanged: (val) {
                  onIgnoreFiltersChanged(val ?? false);
                },
              ),
            ],
          ),
        IconButton(
          splashRadius: 20,
          onPressed: () {
            showLibrarySettingsSheet(
              context: context,
              settings: settings,
              itemType: itemType,
              entries: entries,
            );
          },
          icon: Icon(
            Icons.filter_list_sharp,
            color: isNotFiltering ? null : Colors.yellow,
          ),
        ),
        // Torrent stream is anime-only, so the menu's values are not its
        // indices: keep label and value paired.
        if (isTv)
          Builder(
            builder: (context) {
              final entries = <(String, int)>[
                (context.l10n.update_library, 0),
                (l10n.open_random_entry, 1),
                (l10n.import, 2),
                (l10n.bookshelf_manage_categories, 7),
                if (itemType == ItemType.anime) (l10n.torrent_stream, 3),
              ];
              return IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () async {
                  final picked = await showTvMenu(
                    context,
                    title: l10n.library,
                    options: [for (final e in entries) TvMenuOption(e.$1)],
                  );
                  if (picked != null && context.mounted) {
                    _onLibraryMenu(context, ref, entries[picked].$2);
                  }
                },
              );
            },
          )
        else
          PopupMenuButton(
            popUpAnimationStyle: NodeLaneMotion.style(context),
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(context.l10n.update_library),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text(l10n.open_random_entry),
                ),
                PopupMenuItem<int>(value: 2, child: Text(l10n.import)),
                PopupMenuItem<int>(
                  value: 7,
                  child: Text(l10n.bookshelf_manage_categories),
                ),
                if (itemType == ItemType.anime)
                  PopupMenuItem<int>(
                    value: 3,
                    child: Text(l10n.torrent_stream),
                  ),
              ];
            },
            onSelected: (value) => _onLibraryMenu(context, ref, value),
          ),
      ],
    );
  }
}

/// AppBar shown when items are long-pressed for bulk selection.
class _SelectionAppBar extends ConsumerWidget {
  final Set<int> mangaIdsList;
  final List<Manga> data;

  const _SelectionAppBar({required this.mangaIdsList, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mobile = isMobile && !isTv;
    void cancel() {
      ref.read(mangasListStateProvider.notifier).clear();
      ref.read(isLongPressedStateProvider.notifier).update(false);
    }

    void selectAll() =>
        ref.read(mangasListStateProvider.notifier).selectAll(data);

    void invert() {
      ref.read(mangasListStateProvider.notifier).invert(data);
      if (!mobile && ref.read(mangasListStateProvider).isEmpty) {
        ref.read(isLongPressedStateProvider.notifier).update(false);
      }
    }

    if (mobile) {
      final l10n = context.l10n;
      return nodeLaneSelectionAppBar(
        context,
        title: l10n.bookshelf_selected_count(mangaIdsList.length),
        cancelLabel: l10n.cancel,
        selectAllLabel: l10n.bookshelf_select_all,
        invertLabel: l10n.bookshelf_invert_selection,
        onCancel: cancel,
        onSelectAll: data.isEmpty ? null : selectAll,
        onInvert: data.isEmpty ? null : invert,
      );
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: AppBar(
        title: Text(mangaIdsList.length.toString()),
        backgroundColor: context.primaryColor.withValues(alpha: 0.2),
        leading: IconButton(
          tooltip: context.l10n.cancel,
          onPressed: cancel,
          icon: const Icon(Icons.clear),
        ),
        actions: [
          IconButton(
            tooltip: context.l10n.bookshelf_select_all,
            onPressed: selectAll,
            icon: const Icon(Icons.select_all),
          ),
          IconButton(
            tooltip: context.l10n.bookshelf_invert_selection,
            onPressed: invert,
            icon: const Icon(Icons.flip_to_back_rounded),
          ),
        ],
      ),
    );
  }
}
