import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/repositories/tracker_library_cache_repository.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_section.dart';
import 'package:mangayomi/modules/widgets/tracker_account_avatar.dart';
import 'package:mangayomi/modules/tracker_library/tracker_section_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

enum TrackerProviders {
  myAnimeList(syncId: 1, name: "MAL"),
  anilist(syncId: 2, name: "AL"),
  kitsu(syncId: 3, name: "Kitsu"),
  simkl(syncId: 4, name: "Simkl"),
  trakt(syncId: 5, name: "Trakt");

  const TrackerProviders({required this.syncId, required this.name});

  final int syncId;
  final String name;
}

class TrackerLibraryScreen extends ConsumerStatefulWidget {
  final String? presetInput;
  const TrackerLibraryScreen({required this.presetInput, super.key});

  @override
  ConsumerState<TrackerLibraryScreen> createState() =>
      _TrackerLibraryScreenState();
}

class _TrackerLibraryScreenState extends ConsumerState<TrackerLibraryScreen> {
  late final _textEditingController = TextEditingController(
    text: widget.presetInput,
  );
  late String _query = widget.presetInput?.trim() ?? '';
  late final _preferencesStream = trackRepository.watchAllNotRefreshing();
  int _refreshGeneration = 0;
  List<TrackPreference> _preferences = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final lastLocation = ref.watch(lastTrackerLibraryLocationStateProvider);
    final trackerProvider =
        TrackerProviders.values.firstWhereOrNull(
          (t) => t.syncId == lastLocation.$1,
        ) ??
        TrackerProviders.myAnimeList;
    final itemType = lastLocation.$2 ? ItemType.manga : ItemType.anime;
    final sections = switch (trackerProvider.syncId) {
      1 => _sectionsMAL(trackerProvider.syncId, itemType),
      2 => _sectionsAL(trackerProvider.syncId, itemType),
      3 => _sectionsKitsu(trackerProvider.syncId, itemType),
      4 => _sectionsSimkl(trackerProvider.syncId, itemType),
      5 => _sectionsTrakt(trackerProvider.syncId, itemType),
      _ => [],
    };
    if (_query.isNotEmpty) {
      sections.insert(
        0,
        TrackLibrarySection(
          name: l10n.search,
          syncId: trackerProvider.syncId,
          func: _fetchSearch(trackerProvider.syncId, _query, itemType),
          itemType: itemType,
          isSearch: true,
        ),
      );
    }

    final icons = NodeLaneIcons.of(context);
    return NodeLaneSurface(
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: StreamBuilder(
            stream: _preferencesStream,
            builder: (context, snapshot) {
              _preferences = snapshot.data ?? [];
              final connected = _preferences.any(
                (p) => p.syncId == trackerProvider.syncId,
              );
              return RefreshIndicator(
                onRefresh: () => _resetData(trackerProvider, itemType),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: NodeLaneTokens.headerPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NodeLanePageHeading(
                              title: l10n.tracking,
                              actions: [
                                NodeLaneIconButton(
                                  icon: icons.tracking,
                                  tooltip: l10n.track_library_switch,
                                  onPressed: () => _switchTracker(l10n),
                                ),
                              ],
                            ),
                            const SizedBox(height: NodeLaneTokens.space12),
                            _TrackerLibraryTitle(
                              text:
                                  (trackerProvider.syncId ==
                                          TrackerProviders.simkl.syncId ||
                                      trackerProvider.syncId ==
                                          TrackerProviders.trakt.syncId)
                                  ? trackerProvider.name
                                  : '${trackerProvider.name} · ${itemType.localized(l10n)}',
                              syncId: trackerProvider.syncId,
                            ),
                          ],
                        ),
                      ),
                    ),
                    NodeLanePinnedHeader(
                      child: NodeLaneTextField.search(
                        controller: _textEditingController,
                        hint: l10n.search,
                        onSubmitted: (value) =>
                            setState(() => _query = value.trim()),
                        onChanged: (value) {
                          if (value.isEmpty && _query.isNotEmpty) {
                            setState(() => _query = '');
                          }
                        },
                        onClear: () {
                          _textEditingController.clear();
                          setState(() => _query = '');
                        },
                      ),
                    ),
                    if (connected)
                      SliverPadding(
                        padding: NodeLaneTokens.pagePadding,
                        sliver: SliverList.builder(
                          itemCount: sections.length,
                          itemBuilder: (context, index) {
                            final section = sections[index];
                            return TrackerSectionScreen(
                              key: ValueKey((
                                trackerProvider.syncId,
                                section.itemType,
                                section.name,
                                section.isSearch ? _query : '',
                                _refreshGeneration,
                              )),
                              section: section,
                            );
                          },
                        ),
                      )
                    else
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: NodeLaneEmptyState(
                            icon: icons.tracking,
                            title: l10n.track_library_not_logged,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _resetData(
    TrackerProviders trackerProvider,
    ItemType itemType,
  ) async {
    final temp = Track(
      syncId: trackerProvider.syncId,
      status: TrackStatus.completed,
    );
    await ref
        .read(
          trackStateProvider(
            track: temp,
            itemType: null,
            widgetRef: ref,
          ).notifier,
        )
        .checkRefresh();
    await trackerLibraryCacheRepository.deleteByPrefix(
      "${trackerProvider.syncId}-${itemType.name}-",
    );
    if (mounted) setState(() => _refreshGeneration++);
  }

  List<TrackLibrarySection> _sectionsTrakt(int syncId, ItemType itemType) {
    return [
      // Prioritize Series (anime) sections
      TrackLibrarySection(
        name: context.l10n.tracker_continue_series,
        cacheKey: 'Continue watching series',
        syncId: syncId,
        func: _fetchUserData(syncId, ItemType.anime),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_watchlist_series,
        cacheKey: 'Watchlist series',
        syncId: syncId,
        func: _fetchWatchlistData(syncId, ItemType.anime),
        itemType: ItemType.anime,
      ),
      // Movies sections
      TrackLibrarySection(
        name: context.l10n.tracker_continue_movies,
        cacheKey: 'Continue watching movies',
        syncId: syncId,
        func: _fetchUserData(syncId, ItemType.manga),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_watchlist_movies,
        cacheKey: 'Watchlist movies',
        syncId: syncId,
        func: _fetchWatchlistData(syncId, ItemType.manga),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_trending_series,
        cacheKey: 'Trending Series',
        syncId: syncId,
        func: _fetchGeneralData(syncId, ItemType.anime),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_trending_movies,
        cacheKey: 'Trending Movies',
        syncId: syncId,
        func: _fetchGeneralData(syncId, ItemType.manga),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_popular_series,
        cacheKey: 'Popular Series',
        syncId: syncId,
        func: _fetchGeneralData(syncId, ItemType.anime, rankingType: "popular"),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_popular_movies,
        cacheKey: 'Popular Movies',
        syncId: syncId,
        func: _fetchGeneralData(syncId, ItemType.manga, rankingType: "popular"),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_top_series,
        cacheKey: 'Top Series (All Time)',
        syncId: syncId,
        func: _fetchGeneralData(
          syncId,
          ItemType.anime,
          rankingType: "favorited/all",
        ),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_top_movies,
        cacheKey: 'Top Movies (All Time)',
        syncId: syncId,
        func: _fetchGeneralData(
          syncId,
          ItemType.manga,
          rankingType: "favorited/all",
        ),
        itemType: ItemType.anime,
      ),
    ];
  }

  List<TrackLibrarySection> _sectionsSimkl(int syncId, ItemType itemType) {
    return [
      TrackLibrarySection(
        name: context.l10n.tracker_continue_movies,
        cacheKey: 'Continue watching movies',
        syncId: syncId,
        func: _fetchUserData(syncId, ItemType.manga),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_continue_series,
        cacheKey: 'Continue watching series',
        syncId: syncId,
        func: _fetchUserData(syncId, ItemType.anime),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_trending_movies,
        cacheKey: 'Trending Movies',
        syncId: syncId,
        func: _fetchGeneralData(syncId, ItemType.manga),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_trending_series,
        cacheKey: 'Trending Series',
        syncId: syncId,
        func: _fetchGeneralData(syncId, ItemType.anime),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_airing_series,
        cacheKey: 'Airing Series',
        syncId: syncId,
        func: _fetchGeneralData(syncId, ItemType.anime, rankingType: "airing"),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: context.l10n.tracker_top_series,
        cacheKey: 'Top Series (All Time)',
        syncId: syncId,
        func: _fetchGeneralData(syncId, ItemType.anime, rankingType: "best"),
        itemType: ItemType.anime,
      ),
    ];
  }

  List<TrackLibrarySection> _sectionsMAL(int syncId, ItemType itemType) {
    return itemType == ItemType.anime
        ? [
            TrackLibrarySection(
              name: context.l10n.continue_watching,
              cacheKey: 'Continue watching',
              syncId: syncId,
              func: _fetchUserData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_airing_anime,
              cacheKey: 'Airing Anime',
              syncId: syncId,
              func: _fetchGeneralData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_popular_anime,
              cacheKey: 'Popular Anime',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "bypopularity",
              ),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_upcoming_anime,
              cacheKey: 'Upcoming Anime',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "upcoming",
              ),
              itemType: ItemType.anime,
            ),
          ]
        : [
            TrackLibrarySection(
              name: context.l10n.manga_continue_reading,
              cacheKey: 'Continue reading',
              syncId: syncId,
              func: _fetchUserData(syncId, ItemType.manga),
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_popular_manga,
              cacheKey: 'Popular Manga',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "bypopularity",
              ),
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_top_manga,
              cacheKey: 'Top Manga',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "manga",
              ),
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_top_manhwa,
              cacheKey: 'Top Manhwa',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "manhwa",
              ),
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_top_manhua,
              cacheKey: 'Top Manhua',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "manhua",
              ),
            ),
          ];
  }

  List<TrackLibrarySection> _sectionsKitsu(int syncId, ItemType itemType) {
    return itemType == ItemType.anime
        ? [
            TrackLibrarySection(
              name: context.l10n.continue_watching,
              cacheKey: 'Continue watching',
              syncId: syncId,
              func: _fetchUserData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_popular_anime,
              cacheKey: 'Popular Anime',
              syncId: syncId,
              func: _fetchGeneralData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_latest_anime,
              cacheKey: 'Latest Anime',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "-updatedAt",
              ),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_best_anime,
              cacheKey: 'Best Rated Anime',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "-averageRating",
              ),
              itemType: ItemType.anime,
            ),
          ]
        : [
            TrackLibrarySection(
              name: context.l10n.manga_continue_reading,
              cacheKey: 'Continue reading',
              syncId: syncId,
              func: _fetchUserData(syncId, ItemType.manga),
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_popular_manga,
              cacheKey: 'Popular Manga',
              syncId: syncId,
              func: _fetchGeneralData(syncId, ItemType.manga),
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_latest_manga,
              cacheKey: 'Latest Manga',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "-updatedAt",
              ),
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_best_manga,
              cacheKey: 'Best Rated Manga',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "-averageRating",
              ),
            ),
          ];
  }

  List<TrackLibrarySection> _sectionsAL(int syncId, ItemType itemType) {
    return itemType == ItemType.anime
        ? [
            TrackLibrarySection(
              name: context.l10n.continue_watching,
              cacheKey: 'Continue watching',
              syncId: syncId,
              func: _fetchUserData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            // Backlog: Plan to watch
            TrackLibrarySection(
              name: context.l10n.plan_to_watch,
              cacheKey: 'Plan to watch',
              syncId: syncId,
              func: _fetchPlanningData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_upcoming_anime,
              cacheKey: 'Upcoming Anime',
              syncId: syncId,
              func: _fetchGeneralData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_popular_anime,
              cacheKey: 'Popular Anime',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "sort: POPULARITY_DESC",
              ),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_trending_anime,
              cacheKey: 'Trending Anime',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "sort: TRENDING_DESC",
              ),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_latest_anime,
              cacheKey: 'Latest Anime',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "sort: [UPDATED_AT_DESC, POPULARITY_DESC], status: RELEASING",
              ),
              itemType: ItemType.anime,
            ),
          ]
        : [
            TrackLibrarySection(
              name: context.l10n.manga_continue_reading,
              cacheKey: 'Continue reading',
              syncId: syncId,
              func: _fetchUserData(syncId, ItemType.manga),
            ),
            // Backlog: Plan to read
            TrackLibrarySection(
              name: context.l10n.plan_to_read,
              cacheKey: 'Plan to read',
              syncId: syncId,
              func: _fetchPlanningData(syncId, ItemType.manga),
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_upcoming_manga,
              cacheKey: 'Upcoming Manga',
              syncId: syncId,
              func: _fetchGeneralData(syncId, ItemType.manga),
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_popular_manga,
              cacheKey: 'Popular Manga',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "sort: POPULARITY_DESC",
              ),
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_trending_manga,
              cacheKey: 'Trending Manga',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "sort: TRENDING_DESC",
              ),
            ),
            TrackLibrarySection(
              name: context.l10n.tracker_latest_manga,
              cacheKey: 'Latest Manga',
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "sort: [UPDATED_AT_DESC, POPULARITY_DESC], status: RELEASING",
              ),
            ),
          ];
  }

  Future<List<TrackSearch>?> Function() _fetchSearch(
    int syncId,
    String query,
    ItemType itemType,
  ) {
    return () async => await ref
        .read(
          trackStateProvider(
            track: Track(syncId: syncId, status: TrackStatus.completed),
            itemType: itemType,
            widgetRef: ref,
          ).notifier,
        )
        .search(query);
  }

  Future<List<TrackSearch>?> Function() _fetchGeneralData(
    int syncId,
    ItemType itemType, {
    String? rankingType,
  }) {
    return () async => await ref
        .read(
          trackStateProvider(
            track: Track(syncId: syncId, status: TrackStatus.completed),
            itemType: itemType,
            widgetRef: ref,
          ).notifier,
        )
        .fetchGeneralData(rankingType: rankingType);
  }

  Future<List<TrackSearch>?> Function() _fetchUserData(
    int syncId,
    ItemType itemType,
  ) {
    return () async => await ref
        .read(
          trackStateProvider(
            track: Track(syncId: syncId, status: TrackStatus.completed),
            itemType: itemType,
            widgetRef: ref,
          ).notifier,
        )
        .fetchUserData();
  }

  Future<List<TrackSearch>?> Function() _fetchPlanningData(
    int syncId,
    ItemType itemType,
  ) {
    return () async => await ref
        .read(
          trackStateProvider(
            track: Track(syncId: syncId, status: TrackStatus.completed),
            itemType: itemType,
            widgetRef: ref,
          ).notifier,
        )
        .fetchPlanningData();
  }

  Future<List<TrackSearch>?> Function() _fetchWatchlistData(
    int syncId,
    ItemType itemType,
  ) {
    return () async => await ref
        .read(
          trackStateProvider(
            track: Track(syncId: syncId, status: TrackStatus.completed),
            itemType: itemType,
            widgetRef: ref,
          ).notifier,
        )
        .fetchWatchlistData();
  }

  Future<void> _switchTracker(AppLocalizations l10n, {int? syncId}) async {
    final choice = await showNodeLaneCatalogSheet<(int, bool?)>(
      context,
      NodeLaneCatalogSheet(
        title: l10n.track_library_switch,
        fitContent: true,
        child: Builder(
          builder: (sheetContext) => ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: [
              NodeLaneGroupSurface(
                children: [
                  if (syncId == null)
                    for (final provider in TrackerProviders.values)
                      NodeLaneRow(
                        title: trackInfos(provider.syncId).$2,
                        icon: NodeLaneIcons.of(sheetContext).tracking,
                        enabled: _preferences.any(
                          (p) => p.syncId == provider.syncId,
                        ),
                        onTap: () => Navigator.pop(sheetContext, (
                          provider.syncId,
                          null,
                        )),
                      )
                  else
                    for (final manga in [true, false])
                      NodeLaneRow(
                        title: manga ? l10n.manga : l10n.anime,
                        icon: manga
                            ? NodeLaneIcons.of(sheetContext).manga
                            : NodeLaneIcons.of(sheetContext).anime,
                        onTap: () =>
                            Navigator.pop(sheetContext, (syncId, manga)),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (!mounted || choice == null) return;
    final (provider, manga) = choice;
    if (manga == null &&
        provider != TrackerProviders.simkl.syncId &&
        provider != TrackerProviders.trakt.syncId) {
      await _switchTracker(l10n, syncId: provider);
    } else {
      ref.read(lastTrackerLibraryLocationStateProvider.notifier).set((
        provider,
        manga ?? false,
      ));
    }
  }
}

/// The app bar title for a tracker's library: the service and item type, with
/// the account underneath it.
///
/// Watches the preference rather than reading it once, so signing out drops
/// the account from the title instead of leaving a stale name above an empty
/// list.
class _TrackerLibraryTitle extends ConsumerWidget {
  const _TrackerLibraryTitle({required this.text, required this.syncId});

  final String text;
  final int syncId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preference = ref.watch(tracksProvider(syncId: syncId));
    final label = preference?.accountLabel;

    final t = NodeLaneTokens.of(context);
    if (preference == null || label == null) {
      return Text(text, style: t.readerLabel);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TrackerAccountAvatar(
          preference: preference,
          radius: NodeLaneTokens.space16,
        ),
        const SizedBox(width: NodeLaneTokens.space12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, style: t.readerLabel, overflow: TextOverflow.ellipsis),
              Text(label, overflow: TextOverflow.ellipsis, style: t.secondary),
            ],
          ),
        ),
      ],
    );
  }
}
