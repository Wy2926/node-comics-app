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
        appBar: AppBar(
          title: Text(
            l10n.reorder_navigation,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            buildDefaultDragHandles: false,
            header: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                l10n.mobile_navigation_description,
                style: TextStyle(fontSize: 14, color: colors.muted),
              ),
            ),
            footer: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: MobileSettingsGroup(
                children: [
                  ExpansionTile(
                    title: Text(l10n.advanced),
                    shape: const Border(),
                    collapsedShape: const Border(),
                    children: [
                      SwitchListTile.adaptive(
                        title: Text(l10n.anime_only_tv_layout),
                        value: ref.watch(animeOnlyTvModeProvider),
                        onChanged: ref
                            .read(animeOnlyTvModeProvider.notifier)
                            .set,
                      ),
                    ],
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
                child: Material(
                  color: colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: colors.line),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      ReorderableDragStartListener(
                        index: index,
                        child: SizedBox(
                          width: 48,
                          height: 64,
                          child: Icon(
                            Icons.drag_handle_rounded,
                            color: colors.muted,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SwitchListTile.adaptive(
                          contentPadding: const EdgeInsets.fromLTRB(
                            0,
                            12,
                            12,
                            12,
                          ),
                          title: Text(
                            label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: colors.ink,
                            ),
                          ),
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
