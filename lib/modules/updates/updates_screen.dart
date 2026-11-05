import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/base_library_tab_screen.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/updates/widgets/update_chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/updates/update_errors_screen.dart';
import 'package:mangayomi/services/update_errors_provider.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/widgets/mobile_activity_widgets.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  const UpdatesScreen({super.key});

  @override
  ConsumerState<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends BaseLibraryTabScreenState<UpdatesScreen> {
  @override
  String get title => l10nLocalizations(context)!.updates;

  @override
  Widget buildTab(ItemType type) {
    final state = ref.watch(libraryUpdateProvider);
    final errors = ref.watch(updateErrorsProvider);
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(top: isMobile && !isTv ? 0 : 10),
      child: Column(
        children: [
          if (state.running || errors.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                NodeLaneTokens.gutter,
                0,
                NodeLaneTokens.gutter,
                NodeLaneTokens.space16,
              ),
              child: NodeLaneNotice(
                message: state.running
                    ? l10n.notice_library_updating
                    : l10n.notice_library_failed,
                description: state.running
                    ? l10n.notice_library_progress(state.done, state.total)
                    : null,
                kind: state.running
                    ? NodeLaneNoticeKind.progress
                    : NodeLaneNoticeKind.error,
                progress: state.running && state.total > 0
                    ? state.done / state.total
                    : null,
                actionLabel: state.running ? null : l10n.update_errors,
                onAction: state.running
                    ? null
                    : () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const UpdateErrorsScreen(),
                        ),
                      ),
              ),
            ),
          Expanded(
            child: UpdateTab(
              key: PageStorageKey('updates-${type.name}'),
              onResetQuery: () => setState(textEditingController.clear),
              itemType: type,
              query: textEditingController.text,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildMobileMediaBadge(ItemType type) => _updateNumbers(ref, type);

  @override
  Widget buildTabLabel(ItemType type, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(text: label),
        const SizedBox(width: 8),
        _updateNumbers(ref, type),
      ],
    );
  }

  @override
  List<Widget> buildExtraActions(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return [
      // While an update is running this is the way to stop it, the same as on
      // the library screen. Watching the provider rather than this screen's own
      // flag means the button is also correct for an update started elsewhere.
      if (ref.watch(libraryUpdateProvider.select((s) => s.running)))
        IconButton(
          splashRadius: 20,
          tooltip: l10n.cancel,
          icon: Icon(
            Icons.stop_circle_outlined,
            color: Theme.of(context).hintColor,
          ),
          onPressed: () =>
              ref.read(libraryUpdateProvider.notifier).requestCancel(),
        )
      else
        IconButton(
          splashRadius: 20,
          tooltip: l10n.refresh,
          icon: Icon(
            Icons.refresh_outlined,
            color: Theme.of(context).hintColor,
          ),
          onPressed: _updateLibrary,
        ),
      IconButton(
        splashRadius: 20,
        tooltip: l10n.remove_everything,
        icon: Icon(
          Icons.delete_sweep_outlined,
          color: Theme.of(context).hintColor,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (dialogContext) => NodeLaneAlertDialog(
              title: Text(l10n.remove_everything),
              content: Text(l10n.remove_all_update_msg),
              actions: [
                NodeLaneDialogAction(
                  label: l10n.cancel,
                  secondary: true,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                NodeLaneDialogAction(
                  label: l10n.ok,
                  destructive: true,
                  onPressed: () async {
                    Navigator.of(dialogContext).pop();
                    await _clearUpdates();
                  },
                ),
              ],
            ),
          );
        },
      ),
    ];
  }

  Future<void> _updateLibrary() async {
    final itemType = getCurrentItemType();
    final mangaList = await mangaRepository
        .getFavoritesNonLocalArchiveByItemType(itemType);
    if (!mounted) return;
    await updateLibrary(
      ref: ref,
      context: context,
      mangaList: mangaList,
      itemType: itemType,
      showProgressNotice: false,
    );
  }

  Future<void> _clearUpdates() async {
    final idsToDelete = await updateRepository.getIdsByItemType(
      getCurrentItemType(),
    );
    if (idsToDelete.isEmpty) return;
    await updateRepository.deleteAll(ref, idsToDelete);
  }
}

class UpdateTab extends ConsumerStatefulWidget {
  final String query;
  final ItemType itemType;
  final VoidCallback? onResetQuery;
  const UpdateTab({
    required this.itemType,
    required this.query,
    this.onResetQuery,
    super.key,
  });

  @override
  ConsumerState<UpdateTab> createState() => _UpdateTabState();
}

class _UpdateTabState extends ConsumerState<UpdateTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = l10nLocalizations(context)!;
    final mobile = isMobile && !isTv;
    final update = ref.watch(
      getAllUpdateStreamProvider(
        itemType: widget.itemType,
        search: widget.query,
      ),
    );
    return update.when(
      data: (entries) {
        // Resolve chapter/manga once here instead of per row in itemBuilder.
        final chapterByUpdateId = <int, Chapter>{};
        for (final e in entries) {
          if (!e.chapter.isLoaded) e.chapter.loadSync();
          final c = e.chapter.value;
          if (c != null) chapterByUpdateId[e.id!] = c;
        }
        final mangaIds = chapterByUpdateId.values
            .map((c) => c.mangaId)
            .whereType<int>()
            .toSet()
            .toList();
        final mangaById = {
          for (final m in mangaRepository.getAllByIds(mangaIds)) m?.id!: m!,
        };

        // Both maps above skip an entry that no longer resolves, and the
        // itemBuilder below then asserted it was there. An update whose
        // chapter has been deleted (a refresh cleaning up duplicates) or
        // whose manga has left the library therefore threw mid-build, and
        // in a release build a throwing child is replaced by a plain grey
        // box, leaving the list ending in scrollable grey. Drop those
        // updates instead: the row has nothing left to show anyway.
        final resolved = entries.where((e) {
          final chapter = chapterByUpdateId[e.id];
          return chapter != null && mangaById.containsKey(chapter.mangaId);
        }).toList();

        int? lastUpdated;
        for (final c in chapterByUpdateId.values) {
          final value = mangaById[c.mangaId]?.lastUpdate;
          if (value != null && (lastUpdated == null || value > lastUpdated)) {
            lastUpdated = value;
          }
        }
        if (resolved.isNotEmpty) {
          return CustomScrollView(
            key: PageStorageKey('updates-list-${widget.itemType.name}'),
            slivers: [
              if (lastUpdated != null)
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: mobile ? 24 : 10,
                    right: mobile ? 24 : 10,
                    top: 10,
                    bottom: 20,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      Text(
                        l10n.library_last_updated(
                          dateFormat(
                            lastUpdated.toString(),
                            ref: ref,
                            context: context,
                            showHOURorMINUTE: true,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: mobile ? 13 : null,
                          fontStyle: mobile
                              ? FontStyle.normal
                              : FontStyle.italic,
                          color: mobile
                              ? NodeLaneTokens.of(context).muted
                              : context.secondaryColor,
                        ),
                      ),
                    ]),
                  ),
                ),
              CustomSliverGroupedListView<Update, String>(
                elements: resolved,
                groupBy: (element) => dateFormat(
                  element.date!,
                  context: context,
                  ref: ref,
                  forHistoryValue: true,
                  useRelativeTimesTamps: false,
                ),
                groupSeparatorBuilder: (String groupByValue) => Padding(
                  padding: mobile
                      ? const EdgeInsets.fromLTRB(24, 12, 24, 10)
                      : const EdgeInsets.only(bottom: 8, left: 12),
                  child: Text(
                    dateFormat(
                      null,
                      context: context,
                      stringDate: groupByValue,
                      ref: ref,
                    ),
                    style: mobile
                        ? TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: NodeLaneTokens.of(context).muted,
                          )
                        : null,
                  ),
                ),
                itemBuilder: (context, element) {
                  final chapter = chapterByUpdateId[element.id]!;
                  final manga = mangaById[chapter.mangaId]!;
                  return UpdateChapterListTileWidget(
                    chapter: chapter,
                    manga: manga,
                    sourceExist: true,
                  );
                },
                itemComparator: (item1, item2) =>
                    item1.date!.compareTo(item2.date!),
                order: GroupedListOrder.DESC,
              ),
              if (mobile)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: pageBottomInsets(context).bottom + 16,
                  ),
                ),
            ],
          );
        }
        if (mobile) {
          return MobileActivityEmpty(
            icon: Icons.update_rounded,
            message: widget.query.isEmpty
                ? l10n.no_recent_updates
                : l10n.no_result,
            resetLabel: l10n.reset,
            onReset: widget.query.isEmpty ? null : widget.onResetQuery,
          );
        }
        return Center(child: Text(l10n.no_recent_updates));
      },
      error: (Object error, StackTrace stackTrace) {
        return ErrorText(error);
      },
      loading: () {
        return const ProgressCenter();
      },
    );
  }
}

Widget _updateNumbers(WidgetRef ref, ItemType itemType) {
  return StreamBuilder(
    stream: updateRepository.watchByItemType(itemType),
    builder: (context, snapshot) {
      final count = snapshot.data?.length ?? 0;
      if (count == 0) return const SizedBox.shrink();
      return Badge(
        backgroundColor: Theme.of(context).focusColor,
        label: Text(
          count.toString(),
          style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
        ),
      );
    },
  );
}
