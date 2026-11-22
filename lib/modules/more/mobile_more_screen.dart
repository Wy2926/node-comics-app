import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/main_view/main_screen.dart';
import 'package:mangayomi/modules/more/categories/mobile_categories.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/settings_search.dart';
import 'package:mangayomi/modules/more/widgets/mobile_nodelane_account.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/translation/translation_language_picker.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/more/settings/mobile_settings_layout.dart';
import 'package:mangayomi/modules/widgets/nodelane_pane_layout.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Settings search filters local labels and never sends account data.
class MobileMoreScreen extends ConsumerStatefulWidget {
  const MobileMoreScreen({super.key});
  @override
  ConsumerState<MobileMoreScreen> createState() => _MobileMoreScreenState();
}

class _MobileMoreScreenState extends ConsumerState<MobileMoreScreen> {
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Widget _destination(
    String title,
    IconData icon,
    String route, {
    String? subtitle,
    Key? key,
    Object? extra,
  }) => NodeLaneRow(
    key: key,
    title: title,
    subtitle: subtitle,
    icon: icon,
    onTap: () {
      FocusScope.of(context).unfocus();
      context.push(route, extra: extra);
    },
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    final hidden = ref.watch(hideItemsStateProvider);
    final query = _search.text.trim().toLowerCase();
    bool matches(String title, [String keywords = '']) =>
        '$title $keywords'.toLowerCase().contains(query);
    final sections = <Widget>[];
    for (final group in mobileSettingsCategories(context, hidden).entries) {
      final children = [
        if (group.key == l.settings_reading_translation &&
            matches(
              l.settings_translation_language,
              l.settings_translation_scope,
            ))
          const TranslationLanguageRow(),
        for (final item in group.value)
          if (matches(item.title, item.keywords))
            _destination(item.title, item.icon, item.route),
      ];
      if (children.isNotEmpty) {
        sections.add(MobileSettingsGroup(title: group.key, children: children));
      }
    }
    final visibleShelves = visibleItemTypes(hidden);
    final tools = [
      if (hidden.contains('/browser') &&
          matches(l.browser_title, '浏览器 Browser'))
        NodeLaneRow(
          title: l.browser_title,
          icon: icons.browser,
          onTap: () => context.go('/browser'),
        ),
      if (visibleShelves.isNotEmpty && matches(l.categories))
        NodeLaneRow(
          title: l.categories,
          icon: icons.categories,
          onTap: () => showCategoryManager(
            context,
            MainScreen.libraryForTools(context) ?? visibleShelves.first,
          ),
        ),
      if (matches(l.statistics))
        _destination(l.statistics, icons.statistics, '/statistics'),
      if (matches(l.calendar))
        _destination(l.calendar, icons.calendar, '/calendarScreen'),
    ];
    final toolsAndHelp = [
      if (query.isEmpty) ...[
        NodeLaneDisclosure(
          title: l.settings_more_tools,
          icon: icons.folderOutline,
          child: Column(children: tools),
        ),
        const SizedBox(height: NodeLaneTokens.space24),
      ] else if (tools.isNotEmpty)
        MobileSettingsGroup(title: l.settings_more_tools, children: tools),
      if (matches(l.settings_about_help))
        NodeLaneGroupSurface(
          children: [_destination(l.settings_about_help, icons.info, '/about')],
        ),
    ];
    final settingMatches = query.isEmpty
        ? <SettingsSearchEntry>[]
        : settingsSearchEntries(
            context,
            hidden,
          ).where((entry) => entry.matches(query)).toList();
    final empty =
        sections.isEmpty && toolsAndHelp.isEmpty && settingMatches.isEmpty;
    final search = NodeLaneTextField.search(
      key: const ValueKey('more-settings-search'),
      controller: _search,
      hint: l.settings_search_hint,
      onChanged: (_) => setState(() {}),
      clearLabel: l.reset,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
    );

    return NodeLaneSurface(
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: NodeLanePaneLayout(
            splitWhen: settingsPanesFit,
            pane: (context) => ListView(
              key: const PageStorageKey('more-shortcuts'),
              padding: NodeLaneTokens.pagePadding.add(
                pageBottomInsets(context),
              ),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                const MobileNodeLaneAccountSummary(),
                const SizedBox(height: NodeLaneTokens.space16),
                search,
                if (query.isEmpty) ...[
                  const SizedBox(height: NodeLaneTokens.space24),
                  ...toolsAndHelp,
                ],
              ],
            ),
            body: (_, split) => CustomScrollView(
              key: PageStorageKey(
                split && query.isNotEmpty
                    ? 'more-search-results'
                    : 'mobile-more',
              ),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                if (!split)
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                    sliver: SliverToBoxAdapter(
                      child: MobileNodeLaneAccountSummary(),
                    ),
                  ),
                if (!split) NodeLanePinnedHeader(child: search),
                if (empty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: pageBottomInsets(context),
                      child: Center(
                        child: NodeLaneEmptyState(
                          icon: icons.search,
                          title: l.settings_search_empty,
                          action: NodeLaneSecondaryButton(
                            onPressed: () => setState(_search.clear),
                            child: Text(l.search_clear),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: NodeLaneTokens.pagePadding.add(
                      pageBottomInsets(context),
                    ),
                    sliver: SliverList.list(
                      children: [
                        if (settingMatches.isNotEmpty)
                          MobileSettingsGroup(
                            children: [
                              for (final entry in settingMatches)
                                _destination(
                                  entry.title,
                                  entry.icon,
                                  entry.location,
                                  key: ValueKey(
                                    'settings-search:${entry.title}:${entry.location}',
                                  ),
                                  subtitle: entry.breadcrumb,
                                  extra: entry.extra,
                                ),
                            ],
                          ),
                        ...sections,
                        if (!split || query.isNotEmpty) ...toolsAndHelp,
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
