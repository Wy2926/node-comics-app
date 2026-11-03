import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MobileNavigationSettings extends ConsumerWidget {
  const MobileNavigationSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final order = ref.watch(navigationOrderStateProvider);
    final hidden = ref.watch(hideItemsStateProvider);
    final labels = {
      '/MangaLibrary': l10n.manga,
      '/AnimeLibrary': l10n.anime,
      '/NovelLibrary': l10n.novel,
      '/updates': l10n.updates,
      '/browser': '浏览器',
      '/browse': '来源',
      '/more': l10n.more,
      '/trackerLibrary': l10n.tracking,
    };
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(context, title: l10n.reorder_navigation),
        body: SafeArea(
          top: false,
          child: ReorderableListView.builder(
            padding: NodeLaneTokens.pagePadding,
            buildDefaultDragHandles: false,
            header: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                l10n.mobile_navigation_description,
                style: colors.readerSecondary,
              ),
            ),
            footer: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: MobileSettingsGroup(
                children: [
                  NodeLaneDisclosure(
                    title: l10n.advanced,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        NodeLaneSwitchRow(
                          title: l10n.anime_only_tv_layout,
                          value: ref.watch(animeOnlyTvModeProvider),
                          onChanged: ref
                              .read(animeOnlyTvModeProvider.notifier)
                              .set,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            itemCount: order.length,
            itemBuilder: (context, index) {
              final route = order[index];
              final required = route == '/browse' || route == '/more';
              final label = labels[route] ?? route;
              return Padding(
                key: ValueKey(route),
                padding: const EdgeInsets.only(bottom: 8),
                child: NodeLaneGroupSurface(
                  child: Row(
                    children: [
                      ReorderableDragStartListener(
                        index: index,
                        child: SizedBox(
                          width: NodeLaneTokens.minTapTarget,
                          height: NodeLaneTokens.rowHeight,
                          child: Icon(
                            NodeLaneIcons.of(context).reorder,
                            color: colors.muted,
                          ),
                        ),
                      ),
                      Expanded(
                        child: NodeLaneSwitchRow(
                          title: label,
                          value: !hidden.contains(route),
                          onChanged: required
                              ? null
                              : (value) {
                                  final next = hidden.toList();
                                  if (value) {
                                    next.remove(route);
                                  } else if (!next.contains(route)) {
                                    next.add(route);
                                  }
                                  ref
                                      .read(hideItemsStateProvider.notifier)
                                      .set(next);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onReorderItem: (oldIndex, newIndex) {
              if (oldIndex == newIndex) return;
              // Flutter supplies the index after removal for onReorderItem.
              // Copy first: other consumers retain the previous preference.
              final next = order.toList();
              next.insert(newIndex, next.removeAt(oldIndex));
              ref.read(navigationOrderStateProvider.notifier).set(next);
            },
          ),
        ),
      ),
    );
  }
}
