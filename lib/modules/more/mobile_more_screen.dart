import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/downloaded_only_widget.dart';
import 'package:mangayomi/modules/more/widgets/incognito_mode_widget.dart';
import 'package:mangayomi/modules/more/widgets/mobile_nodelane_account.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/translation/translation_language_picker.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

final morePendingDownloadsProvider = StreamProvider.autoDispose<int>(
  (ref) => downloadRepository.watchPending().map((entries) => entries.length),
);

/// One root for account, shortcuts and preferences. Search filters local labels;
/// it does not search account data or call a remote service.
class MobileMoreScreen extends ConsumerStatefulWidget {
  const MobileMoreScreen({super.key});
  @override
  ConsumerState<MobileMoreScreen> createState() => _MobileMoreScreenState();
}

class _MobileMoreScreenState extends ConsumerState<MobileMoreScreen> {
  final _search = TextEditingController();
  String _query = '';
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clear() {
    _search.clear();
    setState(() => _query = '');
  }

  void _open(String route, {Object? extra}) {
    FocusScope.of(context).unfocus();
    context.push(route, extra: extra);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n,
        t = NodeLaneTokens.of(context),
        icons = NodeLaneIcons.of(context);
    final hidden = ref.watch(hideItemsStateProvider);
    final query = _query.trim().toLowerCase();
    final toolbarHeight =
        (MediaQuery.textScalerOf(context).scale(22) * 1.3 + 16).clamp(
          kToolbarHeight,
          double.infinity,
        );
    ({String terms, Widget child}) entry(
      String title,
      Widget child, [
      String extra = '',
    ]) => (terms: '$title $extra'.toLowerCase(), child: child);
    ({String terms, Widget child}) link(
      String title,
      IconData icon,
      String route, {
      String? value,
      String keywords = '',
    }) => entry(
      title,
      NodeLaneRow(
        title: title,
        value: value,
        icon: icon,
        onTap: () => _open(route),
      ),
      keywords,
    );
    final followSystem = ref.watch(followSystemThemeStateProvider);
    final dark = ref.watch(themeModeStateProvider);
    final sections = [
      (
        title: l.settings_frequent,
        entries: [
          entry(l.download_queue, const _DownloadQueueLink()),
          entry(l.downloaded_only, const DownloadedOnlyWidget(mobile: true)),
          entry(l.incognito_mode, const IncognitoModeWidget(mobile: true)),
          if (hidden.contains('/browser'))
            entry(
              '浏览器 Browser',
              NodeLaneRow(
                title: '浏览器',
                icon: icons.browser,
                onTap: () => context.go('/browser'),
              ),
            ),
        ],
      ),
      (
        title: l.settings_reading_translation,
        entries: [
          entry(
            l.settings_translation_language,
            const TranslationLanguageRow(),
            l.settings_translation_scope,
          ),
          if (!hidden.contains('/MangaLibrary'))
            link(
              l.settings_manga_reader,
              icons.manga,
              '/readerMode',
              keywords: l.reader_subtitle,
            ),
          if (!hidden.contains('/NovelLibrary'))
            link(l.settings_novel_reader, icons.novel, '/novelReaderMode'),
          if (!hidden.contains('/AnimeLibrary'))
            link(l.player, icons.anime, '/playerOverview'),
        ],
      ),
      (
        title: l.settings_app_preferences,
        entries: [
          link(
            l.settings_appearance_interface,
            icons.palette,
            '/appearance',
            value: followSystem
                ? l.follow_system_theme
                : dark
                ? l.theme_dark
                : l.theme_light,
            keywords: l.appearance_subtitle,
          ),
          link(l.settings_security_privacy, icons.security, '/security'),
          link(l.general, icons.settings, '/general'),
        ],
      ),
      (
        title: l.settings_data_management,
        entries: [
          link(
            l.settings_storage_backup,
            icons.storage,
            '/dataAndStorage',
            keywords: '${l.settings_translation_cache} ${l.backup_and_restore}',
          ),
          link(l.settings_downloads, icons.download, '/downloads'),
          link(l.syncing, icons.cloud, '/sync'),
          link(l.tracking, icons.tracking, '/track'),
          link(
            l.settings_source_preferences,
            icons.webLink,
            '/browseS',
            keywords: l.browse_subtitle,
          ),
        ],
      ),
    ];
    final tools = [
      entry(
        l.categories,
        NodeLaneRow(
          title: l.categories,
          icon: icons.categories,
          onTap: () => _open('/categories', extra: (false, 0)),
        ),
      ),
      link(l.statistics, icons.statistics, '/statistics'),
      link(l.calendar, icons.calendar, '/calendarScreen'),
    ];
    final filtered = sections
        .map(
          (section) => (
            title: section.title,
            children: section.entries
                .where((e) => e.terms.contains(query))
                .map((e) => e.child)
                .toList(),
          ),
        )
        .where((section) => section.children.isNotEmpty)
        .toList();
    final matchingTools = tools
        .where((e) => e.terms.contains(query))
        .map((e) => e.child)
        .toList();
    final showAbout = l.settings_about_help.toLowerCase().contains(query);
    final empty = filtered.isEmpty && matchingTools.isEmpty && !showAbout;

    return NodeLaneSurface(
      child: Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: CustomScrollView(
            key: const PageStorageKey('mobile-more'),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                toolbarHeight: toolbarHeight,
                expandedHeight: toolbarHeight + 32,
                backgroundColor: t.canvas,
                scrolledUnderElevation: 0,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final collapsed =
                        constraints.maxHeight <=
                        toolbarHeight + MediaQuery.paddingOf(context).top + 1;
                    return FlexibleSpaceBar(
                      centerTitle: collapsed,
                      titlePadding: EdgeInsetsDirectional.only(
                        start: collapsed ? 0 : NodeLaneTokens.space20,
                        bottom: NodeLaneTokens.space16,
                      ),
                      expandedTitleScale:
                          t.pageTitle.fontSize! / t.readerTitle.fontSize!,
                      title: Text(l.more, style: t.readerTitle),
                    );
                  },
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: MobileNodeLaneAccountSummary(),
                ),
              ),
              NodeLanePinnedHeader(
                child: NodeLaneTextField.search(
                  key: const ValueKey('more-settings-search'),
                  controller: _search,
                  hint: l.settings_search_hint,
                  onChanged: (v) => setState(() => _query = v),
                  onClear: _clear,
                  clearLabel: l.reset,
                  onSubmitted: (_) => FocusScope.of(context).unfocus(),
                ),
              ),
              if (empty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: pageBottomInsets(context),
                    child: Center(
                      child: NodeLaneEmptyState(
                        icon: icons.search,
                        title: l.settings_search_empty,
                        message: l.search_empty_hint,
                        action: FilledButton.tonal(
                          onPressed: _clear,
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
                      for (final section in filtered)
                        MobileSettingsGroup(
                          title: section.title,
                          children: section.children,
                        ),
                      if (query.isEmpty) ...[
                        NodeLaneDisclosure(
                          title: l.settings_more_tools,
                          subtitle: l.settings_more_tools_hint,
                          icon: icons.folderOutline,
                          child: Column(children: matchingTools),
                        ),
                        const SizedBox(height: NodeLaneTokens.space24),
                      ] else if (matchingTools.isNotEmpty)
                        MobileSettingsGroup(
                          title: l.settings_more_tools,
                          children: matchingTools,
                        ),
                      if (showAbout)
                        NodeLaneGroupSurface(
                          children: [
                            NodeLaneRow(
                              title: l.settings_about_help,
                              icon: icons.info,
                              onTap: () => _open('/about'),
                            ),
                          ],
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

class _DownloadQueueLink extends ConsumerWidget {
  const _DownloadQueueLink();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(morePendingDownloadsProvider).asData?.value;
    return NodeLaneRow(
      title: context.l10n.download_queue,
      value: count != null && count > 0
          ? context.l10n.settings_pending_downloads(count)
          : null,
      icon: NodeLaneIcons.of(context).download,
      onTap: () => context.push('/downloadQueue'),
    );
  }
}
