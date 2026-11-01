import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/widgets/mobile_media_menu.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/modules/browse/extension/extension_screen.dart';
import 'package:mangayomi/modules/browse/sources/sources_screen.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/browse/widgets/tv_browse_tab_strip.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_header.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/webview/mobile_browser_widgets.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

enum BrowseTabKind { sources, extensions }

class BrowseTab {
  final ItemType type;
  final BrowseTabKind kind;

  const BrowseTab(this.type, this.kind);
}

class _BrowseScreenState extends ConsumerState<BrowseScreen>
    with TickerProviderStateMixin {
  final _textEditingController = TextEditingController();

  /// Which TV list row currently holds focus, so the rest of the list can
  /// fade back while one is active. Lives here so both the sources and the
  /// extensions tab share it.
  final _tvActiveRow = ValueNotifier<Object?>(null);
  late TabController _tabBarController;
  late List<BrowseTab> _tabList;
  final _retiredTabControllers = <TabController>[];
  int _selectedIndex = 0;

  // Hide manga & novel from Browse (sources + extensions) on the anime-only TV
  // layout so only anime shows. Recomputed live so toggling "Anime only" updates
  // the tabs without a restart. Defaults to isTv, user-overridable. See #729.
  List<BrowseTab> _computeTabList(bool animeOnly, List<String> hideItems) => [
    if (!animeOnly && !hideItems.contains("/MangaLibrary"))
      BrowseTab(ItemType.manga, BrowseTabKind.sources),
    if (!hideItems.contains("/AnimeLibrary"))
      BrowseTab(ItemType.anime, BrowseTabKind.sources),
    if (!animeOnly && !hideItems.contains("/NovelLibrary"))
      BrowseTab(ItemType.novel, BrowseTabKind.sources),
    if (!animeOnly && !hideItems.contains("/MangaLibrary"))
      BrowseTab(ItemType.manga, BrowseTabKind.extensions),
    if (!hideItems.contains("/AnimeLibrary"))
      BrowseTab(ItemType.anime, BrowseTabKind.extensions),
    if (!animeOnly && !hideItems.contains("/NovelLibrary"))
      BrowseTab(ItemType.novel, BrowseTabKind.extensions),
  ];

  @override
  void initState() {
    super.initState();
    _tabList = _computeTabList(
      ref.read(animeOnlyTvModeProvider),
      ref.read(hideItemsStateProvider),
    );
    _tabBarController = TabController(
      length: _tabList.length,
      initialIndex: _takeRequestedTabIndex(),
      vsync: this,
    );
    _selectedIndex = _tabBarController.index;
    _tabBarController.addListener(_onTabChanged);
  }

  /// The index of the tab somebody asked us to open on, or zero.
  ///
  /// The request is cleared after this frame rather than as it is read.
  /// Riverpod counts initState as part of the build and throws on a write
  /// there, which took the whole Browse screen down.
  int _takeRequestedTabIndex() {
    final requested = ref.read(browseInitialTabProvider);
    if (requested == null) return 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && identical(ref.read(browseInitialTabProvider), requested)) {
        ref.read(browseInitialTabProvider.notifier).clear();
      }
    });
    final index = _tabList.indexWhere(
      (tab) => tab.kind == requested.kind && tab.type == requested.type,
    );
    return index < 0 ? 0 : index;
  }

  void _onTabChanged() {
    if (_selectedIndex == _tabBarController.index) return;
    _selectedIndex = _tabBarController.index;
    _chekPermission();
    setState(() {
      _textEditingController.clear();
      _isSearch = false;
    });
  }

  Future<void> _chekPermission() async {
    await StorageProvider().requestPermission();
  }

  @override
  void dispose() {
    _tvActiveRow.dispose();
    _tabBarController.dispose();
    for (final controller in _retiredTabControllers) {
      controller.dispose();
    }
    _retiredTabControllers.clear();
    _textEditingController.dispose();
    super.dispose();
  }

  bool _isSearch = false;

  Future<void> _openWebPage() async {
    final url = await showBrowserAddress(context);
    if (!mounted || url == null) return;
    context.push('/mangawebview', extra: {'url': url, 'title': ''});
  }

  /// The top-bar action icons, which differ per tab (see #729): Sources =
  /// global-search + filter; Extensions = add + search + language filter.
  List<Widget> _actions(
    BuildContext context,
    bool isExtensionTab,
    ItemType tabType,
  ) {
    return [
      _isSearch
          ? SeachFormTextField(
              onChanged: (value) {
                setState(() {});
              },
              onSuffixPressed: () {
                _textEditingController.clear();
                setState(() {});
              },
              onPressed: () {
                setState(() {
                  _isSearch = false;
                });
                _textEditingController.clear();
              },
              controller: _textEditingController,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isExtensionTab && ref.watch(developerModeStateProvider))
                  IconButton(
                    focusColor: Theme.of(context).colorScheme.primary
                        .withValues(alpha: 0.4),
                    onPressed: () {
                      context.push('/createExtension');
                    },
                    icon: Icon(
                      Icons.add_outlined,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                IconButton(
                  splashRadius: 20,
                  focusColor: Theme.of(context).colorScheme.primary
                      .withValues(alpha: 0.4),
                  onPressed: () {
                    if (isExtensionTab) {
                      setState(() {
                        _isSearch = true;
                      });
                    } else {
                      context.push('/globalSearch', extra: (null, tabType));
                    }
                  },
                  icon: Icon(
                    !isExtensionTab
                        ? Icons.travel_explore_rounded
                        : Icons.search_rounded,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
      IconButton(
        splashRadius: 20,
        focusColor: Theme.of(context).colorScheme.primary
            .withValues(alpha: 0.4),
        onPressed: () {
          context.push(
            isExtensionTab ? '/ExtensionLang' : '/sourceFilter',
            extra: tabType,
          );
        },
        icon: Icon(
          !isExtensionTab ? Icons.filter_list_sharp : Icons.translate_rounded,
          color: Theme.of(context).hintColor,
        ),
      ),
    ];
  }

  void _selectTab(int index) {
    FocusScope.of(context).unfocus();
    if (isMobile && !isTv) {
      _tabBarController.index = index;
    } else {
      _tabBarController.animateTo(index);
    }
  }

  List<Widget> _tabViews() => _tabList.map((tab) {
    if (tab.kind == BrowseTabKind.sources) {
      return SourcesScreen(
        key: PageStorageKey('browse-sources-${tab.type.name}'),
        itemType: tab.type,
        tabs: _tabList,
        tabIndex: _selectTab,
      );
    }
    return ExtensionScreen(
      key: PageStorageKey('browse-extensions-${tab.type.name}'),
      query: _textEditingController.text,
      itemType: tab.type,
      onClearQuery: () => setState(_textEditingController.clear),
    );
  }).toList();

  // Android TV Browse: pill tabs (matching the home) + a top-bar focus ladder
  // (icons -> pills -> list) so nothing steals focus on Up. See #729.
  Widget _buildTvLayout(
    BuildContext context,
    BrowseTab currentTab,
    bool isExtensionTab,
    AppLocalizations l10n,
  ) {
    final horizontalInsets = tvOverscanHorizontalInsets(context);
    final tabLabels = [
      for (final tab in _tabList)
        tab.kind == BrowseTabKind.extensions
            ? tab.type.localizedExtensions(l10n)
            : tab.type.localizedSources(l10n),
    ];
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: _tabList.length,
      child: Scaffold(
        // bottom: false so the inset reaches the tab views instead of being
        // consumed here. Each applies it to its own scroll padding, which lets
        // content pass under the translucent bar rather than stopping short of
        // it, and keeps the last row reachable either way.
        body: SafeArea(
          bottom: !FloatingNavigationScope.enabledOf(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: horizontalInsets.add(
                  const EdgeInsets.only(top: 6, bottom: 2),
                ),
                child: Row(
                  children: [
                    Text(
                      l10n.browse,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    ..._actions(context, isExtensionTab, currentTab.type),
                  ],
                ),
              ),
              // Centred when they fit, horizontally scrollable when long
              // translations or a compact TV viewport need more room.
              Padding(
                padding: horizontalInsets.add(
                  const EdgeInsets.symmetric(vertical: 6),
                ),
                child: TvBrowseTabStrip(
                  labels: tabLabels,
                  selectedIndex: _tabBarController.index,
                  onSelected: (index) {
                    _tabBarController.animateTo(index);
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: TvRowFocusScope(
                  notifier: _tvActiveRow,
                  child: TabBarView(
                    controller: _tabBarController,
                    children: _tabViews(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _syncTabs(List<BrowseTab> newTabs) {
    final unchanged =
        newTabs.length == _tabList.length &&
        List.generate(newTabs.length, (i) => i).every(
          (i) =>
              newTabs[i].type == _tabList[i].type &&
              newTabs[i].kind == _tabList[i].kind,
        );
    if (unchanged) return;
    final previous = _tabList.isEmpty
        ? null
        : _tabList[_tabBarController.index];
    var index = newTabs.indexWhere(
      (tab) => tab.type == previous?.type && tab.kind == previous?.kind,
    );
    if (index < 0) {
      index = newTabs.indexWhere((tab) => tab.kind == previous?.kind);
    }
    _tabList = newTabs;
    final retired = _tabBarController..removeListener(_onTabChanged);
    _retiredTabControllers.add(retired);
    // Old TabBarViews still read the controller until this frame is painted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_retiredTabControllers.remove(retired)) retired.dispose();
    });
    _selectedIndex = index < 0 ? 0 : index;
    _tabBarController = TabController(
      length: newTabs.length,
      initialIndex: _selectedIndex,
      vsync: this,
    )..addListener(_onTabChanged);
    _textEditingController.clear();
    _isSearch = false;
  }

  Widget _buildMobileLayout(BuildContext context, BrowseTab currentTab) {
    final l10n = context.l10n;
    final extensions = currentTab.kind == BrowseTabKind.extensions;
    final mediaTypes = _tabList.map((tab) => tab.type).toSet();
    void select(ItemType type, BrowseTabKind kind) {
      final index = _tabList.indexWhere(
        (tab) => tab.type == type && tab.kind == kind,
      );
      if (index >= 0) _selectTab(index);
    }

    final repoLabel = switch (currentTab.type) {
      ItemType.manga => l10n.manga_extensions_repo,
      ItemType.anime => l10n.anime_extensions_repo,
      ItemType.novel => l10n.novel_extensions_repo,
    };
    return NodeLaneSurface(
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * .65,
                  ),
                  child: SingleChildScrollView(
                    child: MobileBrowseHeader(
                      title: l10n.browse,
                      mediaMenu: MobileMediaMenu(
                        value: currentTab.type,
                        availableTypes: mediaTypes,
                        onChanged: (type) => select(type, currentTab.kind),
                      ),
                      sourcesLabel: l10n.sources,
                      extensionsLabel: l10n.extensions,
                      extensionsSelected: extensions,
                      onSectionChanged: (value) => select(
                        currentTab.type,
                        value
                            ? BrowseTabKind.extensions
                            : BrowseTabKind.sources,
                      ),
                      updateCount:
                          ref
                              .watch(
                                extensionUpdateCountProvider(currentTab.type),
                              )
                              .value ??
                          0,
                      searchHint: extensions ? l10n.search : l10n.global_search,
                      searchController: _textEditingController,
                      onQueryChanged: (_) => setState(() {}),
                      clearLabel: l10n.reset,
                      onGlobalSearch: () => context.push(
                        '/globalSearch',
                        extra: (null, currentTab.type),
                      ),
                      filterLabel: extensions ? l10n.language : l10n.filter,
                      onFilter: () => context.push(
                        extensions ? '/ExtensionLang' : '/sourceFilter',
                        extra: currentTab.type,
                      ),
                      actions: [
                        NodeLaneIconButton(
                          style: NodeLaneIconButtonStyle.plain,
                          tooltip: '打开网页',
                          onPressed: _openWebPage,
                          icon: NodeLaneIcons.of(context).web,
                        ),
                        if (extensions) ...[
                          if (ref.watch(developerModeStateProvider))
                            NodeLaneIconButton(
                              style: NodeLaneIconButtonStyle.plain,
                              tooltip: l10n.add,
                              onPressed: () => context.push('/createExtension'),
                              icon: NodeLaneIcons.of(context).add,
                            ),
                          NodeLaneIconButton(
                            style: NodeLaneIconButtonStyle.plain,
                            tooltip: repoLabel,
                            onPressed: () => context.push(
                              '/SourceRepositories',
                              extra: currentTab.type,
                            ),
                            icon: NodeLaneIcons.of(context).folder,
                          ),
                        ] else
                          NodeLaneIconButton(
                            style: NodeLaneIconButtonStyle.plain,
                            tooltip: l10n.show_extensions,
                            onPressed: () => select(
                              currentTab.type,
                              BrowseTabKind.extensions,
                            ),
                            icon: NodeLaneIcons.of(context).extensions,
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabBarController,
                    // Media and section changes are explicit; swiping across the
                    // legacy six-tab sequence would jump to unrelated media.
                    physics: const NeverScrollableScrollPhysics(),
                    children: _tabViews(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _syncTabs(
      _computeTabList(
        ref.watch(animeOnlyTvModeProvider),
        ref.watch(hideItemsStateProvider),
      ),
    );
    ref.listen(browseInitialTabProvider, (_, requested) {
      if (requested == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted ||
            !identical(ref.read(browseInitialTabProvider), requested)) {
          return;
        }
        final index = _tabList.indexWhere(
          (tab) => tab.type == requested.type && tab.kind == requested.kind,
        );
        if (index >= 0) _selectTab(index);
        ref.read(browseInitialTabProvider.notifier).clear();
      });
    });
    if (_tabList.isEmpty) {
      return SizedBox.shrink();
    }
    final currentTab = _tabList[_tabBarController.index];
    final isExtensionTab = currentTab.kind == BrowseTabKind.extensions;

    final l10n = l10nLocalizations(context)!;
    if (isTv) {
      return _buildTvLayout(context, currentTab, isExtensionTab, l10n);
    }
    if (isMobile) return _buildMobileLayout(context, currentTab);
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: _tabList.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            l10n.browse,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          actions: _actions(context, isExtensionTab, currentTab.type),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            controller: _tabBarController,
            tabs: _tabList.map((tab) {
              final type = tab.type;
              final isExt = tab.kind == BrowseTabKind.extensions;

              return Tab(
                child: Row(
                  children: [
                    Text(
                      isExt
                          ? type.localizedExtensions(l10n)
                          : type.localizedSources(l10n),
                    ),
                    if (isExt) ...[
                      const SizedBox(width: 8),
                      ExtensionUpdateNumbersBadge(itemType: type),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(controller: _tabBarController, children: _tabViews()),
      ),
    );
  }
}

final extensionUpdateCountProvider = StreamProvider.family<int, ItemType>((
  ref,
  itemType,
) {
  return sourceRepository
      .watchActiveByItemType(itemType)
      .map(
        (list) => list
            .where(
              (element) =>
                  (element.isAdded ?? false) &&
                  !(element.isObsolete ?? false) &&
                  compareVersions(
                        element.version ?? '',
                        element.versionLast ?? '',
                      ) <
                      0,
            )
            .length,
      );
});

class ExtensionUpdateNumbersBadge extends ConsumerWidget {
  final ItemType itemType;
  const ExtensionUpdateNumbersBadge({required this.itemType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(extensionUpdateCountProvider(itemType));
    return countAsync.when(
      data: (count) {
        if (count == 0) return const SizedBox.shrink();
        return Badge(
          backgroundColor: Theme.of(context).focusColor,
          label: Text(
            count.toString(),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
