import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/mobile_media_menu.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

abstract class BaseLibraryTabScreenState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T>
    with TickerProviderStateMixin {
  final textEditingController = TextEditingController();
  late TabController tabController;
  late List<ItemType> visibleTabTypes;
  final _retiredControllers = <TabController>[];
  int _selectedIndex = 0;
  bool isSearch = false;

  /// Screen-specific title
  String get title;
  String get searchLabel => context.l10n.search;

  /// Build the content of each tab
  Widget buildTab(ItemType type);

  /// Optional extra actions (refresh, delete, etc.)
  List<Widget> buildExtraActions(BuildContext context) => [];

  Widget? buildMobileMediaBadge(ItemType type) => null;

  /// Optional custom Tab widget (Updates needs this)
  Widget buildTabLabel(ItemType type, String label) {
    return Tab(text: label);
  }

  @override
  void initState() {
    super.initState();
    visibleTabTypes = _visibleTypes(
      ref.read(hideItemsStateProvider),
      ref.read(animeOnlyTvModeProvider),
    );
    tabController = TabController(length: visibleTabTypes.length, vsync: this)
      ..addListener(_onTabChanged);
  }

  List<ItemType> _visibleTypes(List<String> hidden, bool animeOnly) =>
      hiddenItemTypes(hidden)
          .where((type) => !animeOnly || type == ItemType.anime)
          .toList();

  void _onTabChanged() {
    if (_selectedIndex == tabController.index || visibleTabTypes.isEmpty) {
      return;
    }
    _selectedIndex = tabController.index;
    onTabChanged(getCurrentItemType());
    setState(() {
      textEditingController.clear();
      isSearch = false;
    });
  }

  void _syncVisibleTypes(List<ItemType> types) {
    if (types.length == visibleTabTypes.length &&
        types.asMap().entries.every((e) => visibleTabTypes[e.key] == e.value)) {
      return;
    }
    final previousType = getCurrentItemType();
    final previous = tabController..removeListener(_onTabChanged);
    _retiredControllers.add(previous);
    visibleTabTypes = types;
    final index = types.indexOf(previousType);
    _selectedIndex = index < 0 ? 0 : index;
    tabController = TabController(
      length: types.length,
      initialIndex: _selectedIndex,
      vsync: this,
    )..addListener(_onTabChanged);
    if (getCurrentItemType() != previousType) {
      textEditingController.clear();
      isSearch = false;
    }
    // Let the previous TabBarView finish this frame before releasing its controller.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_retiredControllers.remove(previous)) previous.dispose();
      if (mounted && visibleTabTypes.isNotEmpty) {
        onTabChanged(getCurrentItemType());
      }
    });
  }

  /// Called whenever the active tab type changes.
  void onTabChanged(ItemType type) {}

  @override
  void dispose() {
    tabController.dispose();
    for (final controller in _retiredControllers) {
      controller.dispose();
    }
    _retiredControllers.clear();
    textEditingController.dispose();
    super.dispose();
  }

  ItemType getCurrentItemType() => visibleTabTypes.isEmpty
      ? ItemType.manga
      : visibleTabTypes[tabController.index];

  /// Accent focus tint for a top-bar action icon on Android TV so the focused
  /// icon is clearly visible on a remote; `null` (default) off-TV. Subclasses
  /// use this for the icons they add in [buildExtraActions].
  Color? tvIconFocusColor(BuildContext context) => isTv
      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)
      : null;

  /// The tab switcher below the title: TV-home style pills on Android TV, the
  /// classic underline [TabBar] elsewhere. On TV a single visible tab (e.g.
  /// anime-only mode) needs no switcher at all.
  PreferredSizeWidget? _buildTabSwitcher(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (isTv) {
      if (visibleTabTypes.length < 2) return null;
      return PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: AnimatedBuilder(
          animation: tabController,
          builder: (context, _) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < visibleTabTypes.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    TvPill(
                      label: visibleTabTypes[i].localized(l10n),
                      selected: tabController.index == i,
                      onTap: () {
                        tabController.animateTo(i);
                        onTabChanged(visibleTabTypes[i]);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }
    return TabBar(
      controller: tabController,
      indicatorSize: TabBarIndicatorSize.tab,
      onTap: (i) => onTabChanged(visibleTabTypes[i]),
      tabs: visibleTabTypes.map((type) {
        return buildTabLabel(type, type.localized(l10n));
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _syncVisibleTypes(
      _visibleTypes(
        ref.watch(hideItemsStateProvider),
        ref.watch(animeOnlyTvModeProvider),
      ),
    );
    if (isMobile && !isTv) return _mobileView(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: isSearch
            ? null
            : Text(title, style: TextStyle(color: Theme.of(context).hintColor)),
        actions: [
          isSearch
              ? SeachFormTextField(
                  controller: textEditingController,
                  onChanged: (_) => setState(() {}),
                  onSuffixPressed: () {
                    textEditingController.clear();
                    setState(() {});
                  },
                  onPressed: () {
                    setState(() => isSearch = false);
                    textEditingController.clear();
                  },
                )
              : IconButton(
                  splashRadius: 20,
                  focusColor: tvIconFocusColor(context),
                  onPressed: () => setState(() => isSearch = true),
                  icon: Icon(Icons.search, color: Theme.of(context).hintColor),
                ),
          if (visibleTabTypes.isNotEmpty) ...buildExtraActions(context),
        ],
        bottom: _buildTabSwitcher(context),
      ),
      body: TabBarView(
        controller: tabController,
        children: visibleTabTypes.map(buildTab).toList(),
      ),
    );
  }

  Widget _mobileView(BuildContext context) {
    final l10n = context.l10n;
    final selectedType = getCurrentItemType();
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
                    child: Padding(
                      padding: NodeLaneTokens.headerPadding,
                      child: Column(
                        children: [
                          NodeLanePageHeading.toolbar(
                            mediaMenu: MobileMediaMenu(
                              value: selectedType,
                              availableTypes: visibleTabTypes,
                              badgeBuilder: buildMobileMediaBadge,
                              onChanged: (type) {
                                FocusScope.of(context).unfocus();
                                tabController.index = visibleTabTypes.indexOf(
                                  type,
                                );
                              },
                            ),
                            actions: visibleTabTypes.isEmpty
                                ? const []
                                : buildExtraActions(context),
                          ),
                          const SizedBox(height: NodeLaneTokens.space16),
                          NodeLaneTextField.search(
                            controller: textEditingController,
                            hint: searchLabel,
                            clearLabel: l10n.reset,
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final type in visibleTabTypes)
                        KeyedSubtree(
                          key: ValueKey(type),
                          child: buildTab(type),
                        ),
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
