import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
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
    final checkUpdates = ref.watch(checkForExtensionsUpdateStateProvider);
    final autoUpdate = ref.watch(autoUpdateExtensionsStateProvider);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(context, title: l10n.browse),
        body: SafeArea(
          top: false,
          child: MobileSettingsList(
            key: const PageStorageKey('mobile-browse-settings'),
            padding: NodeLaneTokens.pagePadding,
            children: [
              MobileSettingsGroup(
                title: l10n.extensions,
                children: [
                  NodeLaneRow(
                    title: l10n.manga_extensions_repo,
                    subtitle: l10n.manage_manga_repo_urls,
                    icon: NodeLaneIcons.of(context).manga,
                    onTap: () => onRepositories(ItemType.manga),
                  ),
                  NodeLaneRow(
                    title: l10n.anime_extensions_repo,
                    subtitle: l10n.manage_anime_repo_urls,
                    icon: NodeLaneIcons.of(context).anime,
                    onTap: () => onRepositories(ItemType.anime),
                  ),
                  NodeLaneRow(
                    title: l10n.novel_extensions_repo,
                    subtitle: l10n.manage_novel_repo_urls,
                    icon: NodeLaneIcons.of(context).novel,
                    onTap: () => onRepositories(ItemType.novel),
                  ),
                  if (showProxyServer)
                    NodeLaneRow(
                      title: l10n.extension_service,
                      subtitle: l10n.extension_service_description,
                      icon: NodeLaneIcons.of(context).repository,
                      onTap: onProxyServer,
                    ),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.updates,
                children: [
                  NodeLaneSwitchRow(
                    title: l10n.check_for_extension_updates,
                    icon: NodeLaneIcons.of(context).refresh,
                    value: checkUpdates,
                    onChanged: ref
                        .read(checkForExtensionsUpdateStateProvider.notifier)
                        .set,
                  ),
                  if (checkUpdates)
                    NodeLaneSwitchRow(
                      title: l10n.auto_extensions_updates,
                      subtitle: l10n.auto_extensions_updates_subtitle,
                      icon: NodeLaneIcons.of(context).refresh,
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
                  NodeLaneSwitchRow(
                    title: l10n.only_include_pinned_sources,
                    icon: NodeLaneIcons.of(context).pin,
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
                  NodeLaneSwitchRow(
                    title: l10n.nsfw_sources_show,
                    subtitle: l10n.nsfw_sources_info,
                    icon: NodeLaneIcons.of(context).visible,
                    value: ref.watch(showNSFWStateProvider),
                    onChanged: ref.read(showNSFWStateProvider.notifier).set,
                  ),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.advanced,
                children: [
                  NodeLaneSwitchRow(
                    title: l10n.developer_mode,
                    subtitle: l10n.developer_mode_subtitle,
                    icon: NodeLaneIcons.of(context).code,
                    value: ref.watch(developerModeStateProvider),
                    onChanged: ref
                        .read(developerModeStateProvider.notifier)
                        .set,
                  ),
                  NodeLaneDisclosure(
                    key: const PageStorageKey('browse-maintenance'),
                    title: l10n.data_and_storage,
                    icon: NodeLaneIcons.of(context).storage,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        NodeLaneRow(
                          title: l10n.clean_database,
                          subtitle: l10n.clean_database_desc,
                          icon: NodeLaneIcons.of(context).delete,
                          onTap: onCleanDatabase,
                        ),
                        NodeLaneRow(
                          title: l10n.clear_all_sources,
                          icon: NodeLaneIcons.of(context).delete,
                          onTap: onClearSources,
                        ),
                        NodeLaneRow(
                          title: l10n.clear_library,
                          subtitle: l10n.clear_library_desc,
                          icon: NodeLaneIcons.of(context).delete,
                          onTap: onClearLibrary,
                        ),
                        NodeLaneRow(
                          title: l10n.clear_local_library,
                          subtitle: l10n.clear_local_library_desc,
                          icon: NodeLaneIcons.of(context).delete,
                          onTap: onClearLocalLibrary,
                        ),
                      ],
                    ),
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
