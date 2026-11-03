import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/library_screen.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/library_dialogs.dart';
import 'package:mangayomi/modules/library/widgets/library_settings_sheet.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
import 'package:mangayomi/modules/widgets/mobile_media_menu.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/modules/widgets/tv_menu.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
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
  final List<Manga> entries;
  final List<Manga>? selectionEntries;
  final bool isCategory;
  final int? categoryId;
  final Settings settings;
  final bool isSearch;
  final bool ignoreFiltersOnSearch;
  final TextEditingController textEditingController;
  final VoidCallback onSearchToggle;
  final VoidCallback onSearchClear;
  final ValueChanged<bool> onIgnoreFiltersChanged;
  final TickerProvider vsync;
  final double textScale;
  final bool selectionMode;

  const LibraryAppBar({
    super.key,
    required this.itemType,
    required this.isNotFiltering,
    required this.showNumbersOfItems,
    required this.numberOfItems,
    required this.entries,
    this.selectionEntries,
    required this.isCategory,
    required this.categoryId,
    required this.settings,
    required this.isSearch,
    required this.ignoreFiltersOnSearch,
    required this.textEditingController,
    required this.onSearchToggle,
    required this.onSearchClear,
    required this.onIgnoreFiltersChanged,
    required this.vsync,
    this.textScale = 1,
    this.selectionMode = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    isMobile && !isTv && !selectionMode
        ? MobileBookshelfHeader.preferredHeight(textScale)
        : AppBar().preferredSize.height,
  );

  /// The library menu actions, shared by the popup off-TV and the centred TV
  /// menu.
  void _onLibraryMenu(
    BuildContext context,
    WidgetRef ref,
    int value,
    AsyncValue<List<Manga>> manga,
  ) {
    if (value == 0) {
      manga.whenData((value) {
        updateLibrary(
          ref: ref,
          context: context,
          mangaList: value,
          itemType: itemType,
        );
      });
    } else if (value == 1) {
      manga.whenData((value) {
        if (value.isEmpty) return;
        final randomManga = value[Random().nextInt(value.length)];
        pushToMangaReaderDetail(
          ref: ref,
          archiveId: randomManga.isLocalArchive ?? false
              ? randomManga.id
              : null,
          context: context,
          lang: randomManga.lang ?? '',
          mangaM: randomManga,
          source: randomManga.source ?? '',
          sourceId: randomManga.sourceId,
        );
      });
    } else if (value == 2) {
      showImportLocalDialog(context, itemType);
    } else if (value == 3 && itemType == ItemType.anime) {
      addTorrent(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    final mangaIdsList = ref.watch(mangasListStateProvider);
    final allMangaStream = ref.watch(
      getAllMangaStreamProvider(categoryId: null, itemType: itemType),
    );
    final manga = allMangaStream.whenData((allMangas) {
      if (categoryId == null && !isCategory) {
        return allMangas;
      }
      if (categoryId == null) {
        return allMangas
            .where((m) => m.categories == null || m.categories!.isEmpty)
            .toList();
      }
      return allMangas
          .where((m) => m.categories?.contains(categoryId) ?? false)
          .toList();
    });
    final l10n = l10nLocalizations(context)!;

    if (isLongPressed) {
      return manga.when(
        data: (data) => _SelectionAppBar(
          itemType: itemType,
          mangaIdsList: mangaIdsList,
          data: selectionEntries ?? data,
        ),
        error: (error, _) => ErrorText(error),
        loading: () => const ProgressCenter(),
      );
    }

    if (isMobile && !isTv) {
      final hidden = ref.watch(hideItemsStateProvider);
      const routes = {
        ItemType.manga: '/MangaLibrary',
        ItemType.anime: '/AnimeLibrary',
        ItemType.novel: '/NovelLibrary',
      };
      return MobileBookshelfHeader(
        title: l10n.library,
        searchLabel: l10n.search,
        importLabel: l10n.import,
        filterLabel: l10n.filter,
        controller: textEditingController,
        onSearchChanged: onSearchClear,
        count: showNumbersOfItems ? numberOfItems : null,
        filtered: !isNotFiltering,
        onImport: () => showImportLocalDialog(context, itemType),
        onFilter: () => showLibrarySettingsSheet(
          context: context,
          vsync: vsync,
          settings: settings,
          itemType: itemType,
          entries: entries,
        ),
        mediaMenu: MobileMediaMenu(
          value: itemType,
          availableTypes: ItemType.values.where(
            (type) => !hidden.contains(routes[type]),
          ),
          onChanged: (type) => context.go(routes[type]!),
        ),
        updateControl: ref.watch(libraryUpdateProvider).running
            ? NodeLaneIconButton(
                tooltip: l10n.cancel,
                icon: NodeLaneIcons.of(context).stop,
                onPressed: () =>
                    ref.read(libraryUpdateProvider.notifier).requestCancel(),
              )
            : null,
        menu: NodeLaneIconButton(
          tooltip: l10n.bookshelf_actions,
          icon: NodeLaneIcons.of(context).more,
          onPressed: () async {
            final action = await showNodeLaneCatalogSheet<int>(
              context,
              Builder(
                builder: (sheetContext) => Consumer(
                  builder: (_, sheetRef, _) => MobileBookshelfMenu(
                    hasEntries: manga.asData?.value.isNotEmpty == true,
                    updating: sheetRef.watch(libraryUpdateProvider).running,
                    ignoreFilters: ignoreFiltersOnSearch,
                    anime: itemType == ItemType.anime,
                    onSelected: (value) => Navigator.pop(sheetContext, value),
                  ),
                ),
              ),
            );
            if (!context.mounted || action == null) return;
            if (action == 4) {
              onIgnoreFiltersChanged(!ignoreFiltersOnSearch);
            } else if (action == 5) {
              ref.read(libraryUpdateProvider.notifier).requestCancel();
            } else if (action == 6) {
              ref.read(mangasListStateProvider.notifier).clear();
              ref.read(isLongPressedStateProvider.notifier).update(true);
            } else if (action == 7) {
              context.push('/categories', extra: (false, itemType.index));
            } else {
              _onLibraryMenu(context, ref, action, manga);
            }
          },
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
              vsync: vsync,
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
                    _onLibraryMenu(context, ref, entries[picked].$2, manga);
                  }
                },
              );
            },
          )
        else
          PopupMenuButton(
            popUpAnimationStyle: popupAnimationStyle,
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
                if (itemType == ItemType.anime)
                  PopupMenuItem<int>(
                    value: 3,
                    child: Text(l10n.torrent_stream),
                  ),
              ];
            },
            onSelected: (value) => _onLibraryMenu(context, ref, value, manga),
          ),
      ],
    );
  }
}

/// AppBar shown when items are long-pressed for bulk selection.
class _SelectionAppBar extends ConsumerWidget {
  final ItemType itemType;
  final Set<int> mangaIdsList;
  final List<Manga> data;

  const _SelectionAppBar({
    required this.itemType,
    required this.mangaIdsList,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    if (isMobile && !isTv) {
      final t = NodeLaneTokens.of(context), l10n = context.l10n;
      return AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: NodeLaneTokens.gutter,
        backgroundColor: t.canvas,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            TextButton(
              onPressed: () {
                ref.read(mangasListStateProvider.notifier).clear();
                ref.read(isLongPressedStateProvider.notifier).update(false);
              },
              child: Text(l10n.cancel),
            ),
            Expanded(
              child: Text(
                l10n.bookshelf_selected_count(mangaIdsList.length),
                textAlign: TextAlign.center,
                style: t.readerLabel,
              ),
            ),
            TextButton(
              onPressed: data.isEmpty
                  ? null
                  : () {
                      for (final entry in data) {
                        ref
                            .read(mangasListStateProvider.notifier)
                            .selectAll(entry);
                      }
                    },
              child: Text(l10n.bookshelf_select_all),
            ),
          ],
        ),
      );
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: AppBar(
        title: Text(mangaIdsList.length.toString()),
        backgroundColor: context.primaryColor.withValues(alpha: 0.2),
        leading: IconButton(
          tooltip: context.l10n.cancel,
          onPressed: () {
            ref.read(mangasListStateProvider.notifier).clear();
            ref
                .read(isLongPressedStateProvider.notifier)
                .update(!isLongPressed);
          },
          icon: const Icon(Icons.clear),
        ),
        actions: [
          IconButton(
            tooltip: context.l10n.bookshelf_select_all,
            onPressed: () {
              for (var manga in data) {
                ref.read(mangasListStateProvider.notifier).selectAll(manga);
              }
            },
            icon: const Icon(Icons.select_all),
          ),
          IconButton(
            tooltip: context.l10n.bookshelf_invert_selection,
            onPressed: () {
              if (data.length == mangaIdsList.length) {
                for (var manga in data) {
                  ref.read(mangasListStateProvider.notifier).selectSome(manga);
                }
                ref.read(isLongPressedStateProvider.notifier).update(false);
              } else {
                for (var manga in data) {
                  ref.read(mangasListStateProvider.notifier).selectSome(manga);
                }
              }
            },
            icon: const Icon(Icons.flip_to_back_rounded),
          ),
        ],
      ),
    );
  }
}
