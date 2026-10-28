import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'providers/browse_state_provider.dart';

class MobileBrowseSettings extends ConsumerWidget {
  const MobileBrowseSettings({
    super.key,
    required this.showProxyServer,
    required this.onRepositories,
    required this.onProxyServer,
    required this.onClearSources,
    required this.onCleanDatabase,
    required this.onClearLibrary,
    required this.onClearLocalLibrary,
  });

  final bool showProxyServer;
  final ValueChanged<ItemType> onRepositories;
  final VoidCallback onProxyServer, onClearSources, onCleanDatabase;
  final VoidCallback onClearLibrary, onClearLocalLibrary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final checkUpdates = ref.watch(checkForExtensionsUpdateStateProvider);
    final autoUpdate = ref.watch(autoUpdateExtensionsStateProvider);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.browse,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            key: const PageStorageKey('mobile-browse-settings'),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              MobileSettingsGroup(
                title: l10n.extensions,
                children: [
                  MobileSettingsLink(
                    title: l10n.manga_extensions_repo,
                    subtitle: l10n.manage_manga_repo_urls,
                    icon: Icons.auto_stories_outlined,
                    onTap: () => onRepositories(ItemType.manga),
                  ),
                  MobileSettingsLink(
                    title: l10n.anime_extensions_repo,
                    subtitle: l10n.manage_anime_repo_urls,
                    icon: Icons.movie_outlined,
                    onTap: () => onRepositories(ItemType.anime),
                  ),
                  MobileSettingsLink(
                    title: l10n.novel_extensions_repo,
                    subtitle: l10n.manage_novel_repo_urls,
                    icon: Icons.menu_book_outlined,
                    onTap: () => onRepositories(ItemType.novel),
                  ),
                  if (showProxyServer)
                    MobileSettingsLink(
                      title: l10n.extension_service,
                      subtitle: l10n.extension_service_description,
                      icon: Icons.dns_outlined,
                      onTap: onProxyServer,
                    ),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.updates,
                children: [
                  MobileSettingsSwitch(
                    title: l10n.check_for_extension_updates,
                    icon: Icons.update_rounded,
                    value: checkUpdates,
                    onChanged: ref
                        .read(checkForExtensionsUpdateStateProvider.notifier)
                        .set,
                  ),
                  if (checkUpdates)
                    MobileSettingsSwitch(
                      title: l10n.auto_extensions_updates,
                      subtitle: l10n.auto_extensions_updates_subtitle,
                      icon: Icons.system_update_alt_rounded,
                      value: autoUpdate,
                      onChanged: ref
                          .read(autoUpdateExtensionsStateProvider.notifier)
                          .set,
                    ),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.global_search,
                children: [
                  MobileSettingsSwitch(
                    title: l10n.only_include_pinned_sources,
                    icon: Icons.push_pin_outlined,
                    value: ref.watch(onlyIncludePinnedSourceStateProvider),
                    onChanged: ref
                        .read(onlyIncludePinnedSourceStateProvider.notifier)
                        .set,
                  ),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.nsfw_sources,
                children: [
                  MobileSettingsSwitch(
                    title: l10n.nsfw_sources_show,
                    subtitle: l10n.nsfw_sources_info,
                    icon: Icons.visibility_outlined,
                    value: ref.watch(showNSFWStateProvider),
                    onChanged: ref.read(showNSFWStateProvider.notifier).set,
                  ),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.advanced,
                children: [
                  MobileSettingsSwitch(
                    title: l10n.developer_mode,
                    subtitle: l10n.developer_mode_subtitle,
                    icon: Icons.code_rounded,
                    value: ref.watch(developerModeStateProvider),
                    onChanged: ref
                        .read(developerModeStateProvider.notifier)
                        .set,
                  ),
                  ExpansionTile(
                    key: const PageStorageKey('browse-maintenance'),
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: const Border(),
                    collapsedShape: const Border(),
                    leading: Icon(Icons.storage_rounded, color: colors.accent),
                    title: Text(
                      l10n.data_and_storage,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colors.ink,
                      ),
                    ),
                    children: [
                      MobileSettingsLink(
                        title: l10n.clean_database,
                        subtitle: l10n.clean_database_desc,
                        icon: Icons.cleaning_services_outlined,
                        onTap: onCleanDatabase,
                      ),
                      MobileSettingsLink(
                        title: l10n.clear_all_sources,
                        icon: Icons.extension_off_outlined,
                        onTap: onClearSources,
                      ),
                      MobileSettingsLink(
                        title: l10n.clear_library,
                        subtitle: l10n.clear_library_desc,
                        icon: Icons.delete_outline_rounded,
                        onTap: onClearLibrary,
                      ),
                      MobileSettingsLink(
                        title: l10n.clear_local_library,
                        subtitle: l10n.clear_local_library_desc,
                        icon: Icons.folder_delete_outlined,
                        onTap: onClearLocalLibrary,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
