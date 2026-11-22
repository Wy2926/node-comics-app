import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_pane_layout.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

typedef SettingsCategory = ({
  String title,
  IconData icon,
  String route,
  String keywords,
});

/// More and the tablet directory share the same destinations and media visibility.
Map<String, List<SettingsCategory>> mobileSettingsCategories(
  BuildContext context,
  List<String> hidden,
) {
  final l = context.l10n, i = NodeLaneIcons.of(context);
  SettingsCategory link(
    String title,
    IconData icon,
    String route, [
    String keywords = '',
  ]) => (title: title, icon: icon, route: route, keywords: keywords);
  return {
    l.settings_reading_translation: [
      if (!hidden.contains('/MangaLibrary'))
        link(
          l.settings_manga_reader,
          i.manga,
          '/readerMode',
          l.reader_subtitle,
        ),
      if (!hidden.contains('/NovelLibrary'))
        link(l.settings_novel_reader, i.novel, '/novelReaderMode'),
      if (!hidden.contains('/AnimeLibrary'))
        link(l.player, i.anime, '/playerOverview'),
    ],
    l.settings_app_preferences: [
      link(
        l.settings_appearance_interface,
        i.palette,
        '/appearance',
        l.appearance_subtitle,
      ),
      link(l.settings_security_privacy, i.security, '/security'),
      link(l.general, i.settings, '/general'),
    ],
    l.settings_data_management: [
      link(
        l.settings_storage_backup,
        i.storage,
        '/dataAndStorage',
        '${l.settings_translation_cache} ${l.backup_and_restore}',
      ),
      link(l.settings_downloads, i.download, '/downloads'),
      link(l.syncing, i.cloud, '/sync'),
      link(l.tracking, i.tracking, '/track'),
      link(
        l.settings_source_preferences,
        i.webLink,
        '/browseS',
        l.browse_subtitle,
      ),
    ],
  };
}

bool settingsPanesFit(BuildContext context, double width) =>
    context.isTouchPlatform &&
    sizeWantsNavRail(MediaQuery.sizeOf(context)) &&
    width >= tabletMinShortSide * context.paneTextScale;

/// Only routed settings get a directory. The same form in a reader popup stays compact.
class MobileSettingsLayout extends StatelessWidget {
  const MobileSettingsLayout({
    super.key,
    required this.category,
    required this.child,
  });
  final String category;
  final Widget child;

  @override
  Widget build(BuildContext context) => NodeLanePaneLayout(
    splitWhen: settingsPanesFit,
    pane: (_) => _SettingsDirectory(category: category),
    body: (_, _) => child,
  );
}

class _SettingsDirectory extends ConsumerWidget {
  const _SettingsDirectory({required this.category});
  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = mobileSettingsCategories(
      context,
      ref.watch(hideItemsStateProvider),
    );
    return Material(
      color: NodeLaneTokens.of(context).canvas,
      child: SafeArea(
        child: ListView(
          key: const PageStorageKey('settings-directory'),
          padding: NodeLaneTokens.pagePadding,
          children: [
            NodeLanePageHeading(title: context.l10n.settings),
            const SizedBox(height: NodeLaneTokens.space16),
            for (final group in groups.entries)
              if (group.value.isNotEmpty)
                MobileSettingsGroup(
                  title: group.key,
                  children: [
                    for (final entry in group.value)
                      NodeLaneRow(
                        title: entry.title,
                        icon: entry.icon,
                        selected: category == entry.route,
                        onTap: () {
                          final route = ModalRoute.of(context);
                          if (route == null ||
                              !route.isCurrent ||
                              route.popDisposition ==
                                  RoutePopDisposition.doNotPop ||
                              GoRouterState.of(context).uri.path ==
                                  entry.route) {
                            return;
                          }
                          FocusScope.of(context).unfocus();
                          context.replace(entry.route);
                        },
                      ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
