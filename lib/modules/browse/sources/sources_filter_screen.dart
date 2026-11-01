import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_empty.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';

class SourcesFilterScreen extends ConsumerWidget {
  final ItemType itemType;
  const SourcesFilterScreen({required this.itemType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final showNSFW = ref.watch(showNSFWStateProvider);
    final mobile = isMobile && !isTv;
    final body = Padding(
      // Same inset as the other TV list screens; zero off-TV.
      padding: const EdgeInsets.only(top: 10).add(tvPageInsets),
      child: StreamBuilder(
        stream: sourceRepository.watchWithCodeByItemType(itemType),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final entries = snapshot.data!
                .where((e) => showNSFW || !(e.isNsfw ?? false))
                .toList();
            if (mobile && entries.isEmpty) return _emptySources(context, ref);
            return CustomScrollView(
              slivers: [
                CustomSliverGroupedListView<Source, String>(
                  elements: entries,
                  groupBy: (element) => element.lang!,
                  groupSeparatorBuilder: (String groupByValue) {
                    final value = entries
                        .where(
                          (element) =>
                              element.lang!.toLowerCase() == groupByValue &&
                              element.isActive! &&
                              element.itemType == itemType,
                        )
                        .isNotEmpty;
                    void onChanged(bool val) {
                      final now = DateTime.now().millisecondsSinceEpoch;
                      final toUpdate = entries
                          .where(
                            (source) =>
                                source.lang!.toLowerCase() == groupByValue,
                          )
                          .map(
                            (source) => source
                              ..isActive = val
                              ..updatedAt = now,
                          )
                          .toList();
                      sourceRepository.putAll(toUpdate);
                    }

                    final title = Text(
                      completeLanguageName(groupByValue),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    );
                    return mobile
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: SwitchListTile.adaptive(
                              value: value,
                              onChanged: onChanged,
                              title: title,
                            ),
                          )
                        : SwitchListTile(
                            value: value,
                            onChanged: onChanged,
                            title: title,
                          );
                  },
                  itemBuilder: (context, Source element) {
                    if (entries
                        .where(
                          (s) =>
                              s.lang!.toLowerCase() == element.lang &&
                              s.isActive! &&
                              s.itemType == itemType,
                        )
                        .isEmpty) {
                      return Container();
                    }
                    final tile = CheckboxListTile(
                      secondary: Container(
                        height: 37,
                        width: 37,
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: element.iconUrl!.isEmpty
                            ? const Icon(Icons.source_outlined)
                            : cachedNetworkImage(
                                imageUrl: element.iconUrl!,
                                fit: BoxFit.contain,
                                width: 37,
                                height: 37,
                                errorWidget: const SizedBox(
                                  width: 37,
                                  height: 37,
                                  child: Center(
                                    child: Icon(Icons.source_outlined),
                                  ),
                                ),
                              ),
                      ),
                      onChanged: (bool? value) {
                        sourceRepository.save(element..isAdded = value);
                      },
                      value: element.isAdded!,
                      title: Text(element.name!),
                      contentPadding: mobile
                          ? const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            )
                          : null,
                    );
                    return mobile ? MobileBrowseGroup(child: tile) : tile;
                  },
                  groupComparator: (group1, group2) => group1.compareTo(group2),
                  itemComparator: (item1, item2) =>
                      item1.name!.compareTo(item2.name!),
                  order: GroupedListOrder.ASC,
                ),
              ],
            );
          }
          if (mobile) {
            if (snapshot.hasError) {
              return ErrorState(detail: snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return _emptySources(context, ref);
          }
          return Container();
        },
      ),
    );
    return mobile
        ? MobileBrowsePage(title: itemType.localizedSources(l10n), body: body)
        : Scaffold(
            appBar: AppBar(title: Text(l10n.sources)),
            body: body,
          );
  }

  Widget _emptySources(BuildContext context, WidgetRef ref) => ListView(
    children: [
      MobileBrowseEmpty(
        icon: Icons.extension_outlined,
        title: context.l10n.no_sources_installed,
        actionLabel: context.l10n.show_extensions,
        onAction: () {
          ref
              .read(browseInitialTabProvider.notifier)
              .request(BrowseTab(itemType, BrowseTabKind.extensions));
          context.go('/browse');
        },
      ),
    ],
  );
}
