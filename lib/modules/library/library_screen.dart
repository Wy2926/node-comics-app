// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:mangayomi/modules/library/widgets/mobile_bookshelf_actions.dart';
import 'package:mangayomi/modules/library/widgets/mobile_bookshelf_torrent_sheet.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/tv_home/tv_anime_home_view.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/library/providers/add_torrent.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/library_app_bar.dart';
import 'package:mangayomi/modules/library/widgets/mobile_bookshelf_header.dart';
import 'package:mangayomi/modules/library/widgets/library_body.dart';
import 'package:mangayomi/modules/library/widgets/library_dialogs.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/providers/downloaded_only_state_provider.dart';
import 'package:mangayomi/modules/widgets/bottom_select_bar.dart';
import 'package:mangayomi/modules/widgets/category_selection_dialog.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/library/widgets/library_settings_sheet.dart';

typedef _ShelfTab = ({String label, int? categoryId, bool uncategorized});

bool _inShelfTab(Manga entry, _ShelfTab tab) => tab.uncategorized
    ? entry.categories?.isEmpty ?? true
    : tab.categoryId == null ||
          (entry.categories?.contains(tab.categoryId) ?? false);

/// Coordinates the existing library state, category tabs and media-specific actions.
class LibraryScreen extends ConsumerStatefulWidget {
  final ItemType itemType;
  final String? presetInput;
  const LibraryScreen({
    required this.itemType,
    required this.presetInput,
    super.key,
  });

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with TickerProviderStateMixin {
  bool _isSearch = false;
  bool _ignoreFiltersOnSearch = false;
  final _textEditingController = TextEditingController();
  TabController? tabBarController;
  int _tabIndex = 0;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    if (widget.presetInput != null) {
      _isSearch = true;
      _textEditingController.text = widget.presetInput!;
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    tabBarController?.dispose();
    // Anything waiting for the end of a frame that will now never come.
    for (final controller in _retiredTabControllers) {
      controller.dispose();
    }
    _retiredTabControllers.clear();
    _searchDebounce?.cancel();
    super.dispose();
  }

  /// Controllers replaced this frame, disposed once nothing can still paint
  /// from them.
  final List<TabController> _retiredTabControllers = [];

  /// Schedules [controller] for disposal after the current frame.
  ///
  /// Held in a list rather than disposed inline because the widgets built in
  /// the previous frame still reference it until this frame is painted.
  void _retireTabController(TabController? controller) {
    if (controller == null) return;
    _retiredTabControllers.add(controller);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_retiredTabControllers.remove(controller)) return;
      controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsStream = ref.watch(getSettingsStreamProvider);
    return settingsStream.when(
      data: (settings) => _buildWithSettings(settings),
      error: (error, _) => ErrorText(error),
      loading: () => const NodeLaneEmptyState.loading(),
    );
  }

  Widget _buildWithSettings(Settings settings) {
    // On Android TV the anime library shows the dedicated rows-based home
    // instead of the flat grid - a d-pad-first, cover-forward shelf. Toggleable
    // via tvHomeStyleProvider; every other surface keeps the grid.
    if (isTv &&
        widget.itemType == ItemType.anime &&
        ref.watch(tvHomeStyleProvider)) {
      return TvAnimeHomeView(settings: settings);
    }
    final categories = ref.watch(
      getMangaCategorieStreamProvider(itemType: widget.itemType),
    );
    final downloadedOnly = ref.watch(downloadedOnlyStateProvider);
    final mangaAll = ref.watch(
      getAllMangaStreamProvider(categoryId: null, itemType: widget.itemType),
    );

    // Read filter/sort settings once for the whole build
    T watchWithSettings<T>(
      ProviderListenable<T> Function({
        required ItemType itemType,
        required Settings settings,
      })
      providerFn,
    ) {
      return ref.watch(
        providerFn(itemType: widget.itemType, settings: settings),
      );
    }

    T watchWithSettingsAndManga<T>(
      ProviderListenable<T> Function({
        required ItemType itemType,
        required List<Manga> mangaList,
        required Settings settings,
      })
      providerFn,
    ) {
      return ref.watch(
        providerFn(
          itemType: widget.itemType,
          mangaList: const <Manga>[],
          settings: settings,
        ),
      );
    }

    final showCategoryTabs = watchWithSettings(
      libraryShowCategoryTabsStateProvider.call,
    );
    final reverse =
        watchWithSettings(sortLibraryMangaStateProvider.call).reverse ?? false;
    final continueReaderBtn = watchWithSettings(
      libraryShowContinueReadingButtonStateProvider.call,
    );
    final showNumbersOfItems = watchWithSettings(
      libraryShowNumbersOfItemsStateProvider.call,
    );
    final localSource = watchWithSettings(libraryLocalSourceStateProvider.call);
    final downloadedChapter = watchWithSettings(
      libraryDownloadedChaptersStateProvider.call,
    );
    final language = watchWithSettings(libraryLanguageStateProvider.call);
    final displayType = watchWithSettings(libraryDisplayTypeStateProvider.call);
    final downloadFilterType = watchWithSettingsAndManga(
      mangaFilterDownloadedStateProvider.call,
    );
    final unreadFilterType = watchWithSettingsAndManga(
      mangaFilterUnreadStateProvider.call,
    );
    final startedFilterType = watchWithSettingsAndManga(
      mangaFilterStartedStateProvider.call,
    );
    final bookmarkedFilterType = watchWithSettingsAndManga(
      mangaFilterBookmarkedStateProvider.call,
    );
    final completedFilterType = watchWithSettingsAndManga(
      mangaFilterCompletedStateProvider.call,
    );
    final trackingFilterType = watchWithSettingsAndManga(
      mangaFilterTrackingStateProvider.call,
    );
    final sortType =
        watchWithSettings(sortLibraryMangaStateProvider.call).index ?? 0;

    final searchQuery = _textEditingController.text;

    List<Manga> selectionEntries = const [];
    final content = Scaffold(
      body: mangaAll.when(
        data: (man) {
          return categories.when(
            data: (data) {
              final isNotFiltering = ref.watch(
                mangasFilterResultStateProvider(
                  itemType: widget.itemType,
                  mangaList: man,
                  settings: settings,
                ),
              );
              final sourceFilterIds = ref
                  .watch(
                    mangaFilterSourceStateProvider(
                      mangaList: man,
                      itemType: widget.itemType,
                      settings: settings,
                    ),
                  )
                  .$2;

              // Common body params
              Widget bodyForCategory({
                int? categoryId,
                bool withoutCategories = false,
              }) {
                return LibraryBody(
                  itemType: widget.itemType,
                  categoryId: categoryId,
                  withoutCategories: withoutCategories,
                  downloadFilterType: downloadFilterType,
                  unreadFilterType: unreadFilterType,
                  startedFilterType: startedFilterType,
                  bookmarkedFilterType: bookmarkedFilterType,
                  completedFilterType: completedFilterType,
                  trackingFilterType: trackingFilterType,
                  reverse: reverse,
                  downloadedChapter: downloadedChapter,
                  continueReaderBtn: continueReaderBtn,
                  localSource: localSource,
                  language: language,
                  displayType: displayType,
                  settings: settings,
                  downloadedOnly: downloadedOnly,
                  searchQuery: searchQuery,
                  ignoreFiltersOnSearch: _ignoreFiltersOnSearch,
                  sourceIds: sourceFilterIds,
                  onClearSearch: () {
                    _searchDebounce?.cancel();
                    setState(_textEditingController.clear);
                  },
                  onAdjustFilters: () => showLibrarySettingsSheet(
                    context: context,
                    vsync: this,
                    settings: settings,
                    itemType: widget.itemType,
                    entries: man,
                  ),
                );
              }

              final withoutCategory = man
                  .where((m) => m.categories == null || m.categories!.isEmpty)
                  .toList();
              // Get the number of items for the app bar
              final numberOfItemsList = ref.watch(
                filteredLibraryMangaProvider(
                  data: man,
                  downloadFilterType: downloadFilterType,
                  unreadFilterType: unreadFilterType,
                  startedFilterType: startedFilterType,
                  bookmarkedFilterType: bookmarkedFilterType,
                  completedFilterType: completedFilterType,
                  trackingFilterType: trackingFilterType,
                  sortType: sortType,
                  downloadedOnly: downloadedOnly,
                  searchQuery: searchQuery,
                  ignoreFiltersOnSearch: _ignoreFiltersOnSearch,
                  sourceIds: sourceFilterIds,
                  settings: settings,
                ),
              );

              final mobile = isMobile && !isTv;
              final visibleCategories = [...data]
                ..sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));
              visibleCategories.removeWhere(
                (category) => category.hide ?? false,
              );
              final tabs = <_ShelfTab>[
                if (mobile)
                  (
                    label: context.l10n.bookshelf_all,
                    categoryId: null,
                    uncategorized: false,
                  ),
                if (showCategoryTabs && data.isNotEmpty) ...[
                  if (withoutCategory.isNotEmpty)
                    (
                      label: context.l10n.default0,
                      categoryId: null,
                      uncategorized: true,
                    ),
                  for (final category in visibleCategories)
                    (
                      label: category.name ?? '',
                      categoryId: category.id,
                      uncategorized: false,
                    ),
                ],
              ];
              final currentTab = showCategoryTabs && tabs.isNotEmpty
                  ? tabs[_tabIndex.clamp(0, tabs.length - 1)]
                  : null;
              selectionEntries = currentTab == null
                  ? numberOfItemsList
                  : numberOfItemsList
                        .where((entry) => _inShelfTab(entry, currentTab))
                        .toList();
              final appBar = LibraryAppBar(
                mobileHeaderHeight: MobileBookshelfHeader.preferredHeight(
                  context,
                ),
                selectionMode: ref.watch(isLongPressedStateProvider),
                itemType: widget.itemType,
                isNotFiltering: isNotFiltering,
                showNumbersOfItems: showNumbersOfItems,
                numberOfItems: numberOfItemsList.length,
                entries: man,
                selectionEntries: selectionEntries,
                isCategory:
                    currentTab != null &&
                    (currentTab.uncategorized || currentTab.categoryId != null),
                categoryId: currentTab?.categoryId,
                settings: settings,
                isSearch: _isSearch,
                ignoreFiltersOnSearch: _ignoreFiltersOnSearch,
                textEditingController: _textEditingController,
                onSearchToggle: () => setState(() => _isSearch = !_isSearch),
                onSearchClear: () {
                  _searchDebounce?.cancel();
                  _searchDebounce = Timer(
                    const Duration(milliseconds: 300),
                    () {
                      if (mounted) setState(() {});
                    },
                  );
                },
                onIgnoreFiltersChanged: (val) =>
                    setState(() => _ignoreFiltersOnSearch = val),
                vsync: this,
              );
              if (showCategoryTabs && tabs.isNotEmpty) {
                return _buildWithCategories(
                  tabs: tabs,
                  appBar: appBar,
                  bodyForCategory: bodyForCategory,
                  counts: showNumbersOfItems
                      ? [
                          for (final tab in tabs)
                            numberOfItemsList
                                .where((entry) => _inShelfTab(entry, tab))
                                .length,
                        ]
                      : null,
                );
              }
              return Scaffold(appBar: appBar, body: bodyForCategory());
            },
            error: (error, _) => ErrorText(error),
            loading: () => const NodeLaneEmptyState.loading(),
          );
        },
        error: (error, _) => ErrorText(error),
        loading: () => const NodeLaneEmptyState.loading(),
      ),
      // Even a zero-height bottom bar makes Scaffold strip the shell's bottom
      // padding. Omit it when inactive so the final row clears the native bar.
      bottomNavigationBar:
          isMobile && !isTv && !ref.watch(isLongPressedStateProvider)
          ? null
          : _buildBottomBar(selectionEntries),
    );
    return isMobile && !isTv ? NodeLaneSurface(child: content) : content;
  }

  Widget _buildWithCategories({
    required List<_ShelfTab> tabs,
    required PreferredSizeWidget appBar,
    required Widget Function({int? categoryId, bool withoutCategories})
    bodyForCategory,
    required List<int>? counts,
  }) {
    final tabCount = tabs.length;
    if (tabBarController == null || tabBarController!.length != tabCount) {
      final index = _tabIndex.clamp(0, tabCount - 1);
      // Old TabBar/TabBarView may still paint this frame; release afterwards.
      _retireTabController(tabBarController);
      tabBarController = TabController(
        length: tabCount,
        vsync: this,
        initialIndex: index,
      );
      _tabIndex = index;
      tabBarController!.addListener(() {
        if (_tabIndex != tabBarController!.index) {
          setState(() => _tabIndex = tabBarController!.index);
        }
      });
    }
    final mobile = isMobile && !isTv;
    Widget body(_ShelfTab tab) => bodyForCategory(
      categoryId: tab.categoryId,
      withoutCategories: tab.uncategorized,
    );
    return Scaffold(
      appBar: appBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mobile)
            NodeLaneTabSegments(
              controller: tabBarController,
              scrollable: true,
              labels: [
                for (var i = 0; i < tabs.length; i++)
                  counts == null
                      ? tabs[i].label
                      : '${tabs[i].label} ${counts[i]}',
              ],
            )
          else if (tabCount > 1)
            TabBar(
              controller: tabBarController,
              isScrollable: true,
              tabs: [
                for (var i = 0; i < tabs.length; i++)
                  Row(
                    children: [
                      Tab(text: tabs[i].label),
                      if (counts != null) ...[
                        const SizedBox(width: NodeLaneTokens.space4),
                        CategoryBadge(count: counts[i]),
                      ],
                    ],
                  ),
              ],
            ),
          Expanded(
            // A single tab stays a direct grid for TV directional focus.
            child: tabCount == 1
                ? body(tabs.single)
                : TabBarView(
                    controller: tabBarController,
                    children: [for (final tab in tabs) body(tab)],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(List<Manga> selectionEntries) {
    return Builder(
      builder: (context) {
        final mangaIds = ref.watch(mangasListStateProvider);
        if (isMobile && !isTv) {
          List<Manga> targets() => mangaIds
              .map(mangaRepository.findById)
              .whereType<Manga>()
              .where((entry) => entry.itemType == widget.itemType)
              .toList();
          void mark(bool read) {
            ref
                .read(
                  mangasSetIsReadStateProvider(
                    mangaIds: mangaIds,
                    markAsRead: read,
                  ).notifier,
                )
                .set();
            _invalidateStreams();
          }

          return MobileBookshelfSelectionBar(
            anime: widget.itemType == ItemType.anime,
            hasSelection: mangaIds.isNotEmpty,
            onCategories: () => showCategorySelectionDialog(
              context: context,
              ref: ref,
              itemType: widget.itemType,
              bulkMangas: targets(),
            ),
            onRead: () => mark(true),
            onMore: (action) {
              switch (action) {
                case 0:
                  mark(false);
                case 1:
                  for (final entry in selectionEntries) {
                    ref
                        .read(mangasListStateProvider.notifier)
                        .selectSome(entry);
                  }
                case 2:
                  final selected = targets();
                  ref.read(isLongPressedStateProvider.notifier).update(false);
                  ref.read(mangasListStateProvider.notifier).clear();
                  context.push(
                    '/massMigration',
                    extra: (widget.itemType, null, selected),
                  );
                case 3:
                  showDeleteMangaDialog(
                    context: context,
                    ref: ref,
                    itemType: widget.itemType,
                  );
              }
            },
          );
        }
        final color = Theme.of(context).textTheme.bodyLarge!.color!;
        return BottomSelectBar(
          isVisible: ref.watch(isLongPressedStateProvider),
          actions: [
            BottomSelectButton(
              tooltip: context.l10n.categories,
              icon: Icon(Icons.label_outline_rounded, color: color),
              onPressed: () {
                final List<Manga> bulkMangas = mangaIds
                    .map((id) => mangaRepository.getById(id))
                    .toList();
                showCategorySelectionDialog(
                  context: context,
                  ref: ref,
                  itemType: widget.itemType,
                  bulkMangas: bulkMangas,
                );
              },
            ),
            BottomSelectButton(
              icon: Icon(Icons.done_all_sharp, color: color),
              onPressed: () {
                ref
                    .read(
                      mangasSetIsReadStateProvider(
                        mangaIds: mangaIds,
                        markAsRead: true,
                      ).notifier,
                    )
                    .set();
                _invalidateStreams();
              },
            ),
            BottomSelectButton(
              icon: Icon(Icons.remove_done_sharp, color: color),
              onPressed: () {
                ref
                    .read(
                      mangasSetIsReadStateProvider(
                        mangaIds: mangaIds,
                        markAsRead: false,
                      ).notifier,
                    )
                    .set();
                _invalidateStreams();
              },
            ),
            BottomSelectButton(
              tooltip: context.l10n.migrate,
              icon: Icon(Icons.swap_horiz_rounded, color: color),
              onPressed: () {
                final List<Manga> bulkMangas = mangaIds
                    .map((id) => mangaRepository.getById(id))
                    .whereType<Manga>()
                    .toList();
                ref.read(isLongPressedStateProvider.notifier).update(false);
                ref.read(mangasListStateProvider.notifier).clear();
                context.push(
                  '/massMigration',
                  extra: (widget.itemType, null, bulkMangas),
                );
              },
            ),
            BottomSelectButton(
              tooltip: context.l10n.remove,
              icon: Icon(Icons.delete_outline_outlined, color: color),
              onPressed: () => showDeleteMangaDialog(
                context: context,
                ref: ref,
                itemType: widget.itemType,
              ),
            ),
          ],
        );
      },
    );
  }

  void _invalidateStreams() {
    ref.invalidate(
      getAllMangaStreamProvider(categoryId: null, itemType: widget.itemType),
    );
  }
}

/// Top-level utility — shows a dialog to add a torrent by URL or .torrent file.
void addTorrent(BuildContext context, {Manga? manga}) {
  if (isMobile && !isTv) {
    final container = ProviderScope.containerOf(context, listen: false);
    showNodeLaneCatalogSheet<void>(
      context,
      MobileBookshelfTorrentSheet(
        onAdd: (url) async {
          await container.refresh(
            addTorrentFromUrlOrFromFileProvider(
              manga,
              init: true,
              url: url,
            ).future,
          );
        },
      ),
      dismissible: false,
    );
    return;
  }
  final l10n = l10nLocalizations(context)!;
  String torrentUrl = "";
  bool isLoading = false;
  showDialog(
    context: context,
    barrierDismissible: !isLoading,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.add_torrent),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Consumer(
              builder: (context, ref, _) {
                return SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  torrentUrl = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: l10n.enter_torrent_hint_text,
                                labelText: l10n.torrent_url,
                                isDense: true,
                                filled: true,
                                fillColor: Colors.transparent,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: context.secondaryColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: context.secondaryColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: context.secondaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      await ref.watch(
                                        addTorrentFromUrlOrFromFileProvider(
                                          manga,
                                          init: true,
                                          url: torrentUrl,
                                        ).future,
                                      );
                                    } catch (_) {}

                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.pop(context);
                                  },
                            child: Text(l10n.add),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(l10n.or),
                      ),
                      Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            try {
                                              await ref.watch(
                                                addTorrentFromUrlOrFromFileProvider(
                                                  manga,
                                                  init: true,
                                                ).future,
                                              );
                                            } catch (_) {}

                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(Icons.archive_outlined),
                                        Text(
                                          "import .torrent file",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .color,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isLoading)
                            Positioned.fill(
                              child: Container(
                                width: 300,
                                height: 150,
                                color: Colors.transparent,
                                child: UnconstrainedBox(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    height: 50,
                                    width: 50,
                                    child: const Center(
                                      child: NodeLaneEmptyState.loading(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      );
    },
  );
}
