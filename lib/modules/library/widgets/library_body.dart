import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';
import 'package:mangayomi/modules/library/providers/library_source_badge_provider.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/library_gridview_widget.dart';
import 'package:mangayomi/modules/library/widgets/library_listview_widget.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'library_dialogs.dart';
import 'mobile_bookshelf_empty.dart';

/// Displays the library body content for a given category (or uncategorized).
///
/// Uses [filteredLibraryMangaProvider] for cached, optimized filtering
/// instead of calling _filterAndSortManga inline (which was O(N*M) due to
/// per-chapter Isar queries).
class LibraryBody extends ConsumerWidget {
  final ItemType itemType;
  final int? categoryId;
  final bool withoutCategories;
  final int downloadFilterType;
  final int unreadFilterType;
  final int startedFilterType;
  final int bookmarkedFilterType;
  final int completedFilterType;
  final int trackingFilterType;
  final bool reverse;
  final bool downloadedChapter;
  final bool continueReaderBtn;
  final bool localSource;
  final bool language;
  final DisplayType displayType;
  final Settings settings;
  final bool downloadedOnly;
  final String searchQuery;
  final bool ignoreFiltersOnSearch;
  final List<String> sourceIds;
  final VoidCallback? onAdjustFilters, onClearSearch;

  const LibraryBody({
    super.key,
    required this.itemType,
    this.categoryId,
    this.withoutCategories = false,
    required this.downloadFilterType,
    required this.unreadFilterType,
    required this.startedFilterType,
    required this.bookmarkedFilterType,
    required this.completedFilterType,
    required this.trackingFilterType,
    required this.reverse,
    required this.downloadedChapter,
    required this.continueReaderBtn,
    required this.localSource,
    required this.language,
    required this.displayType,
    required this.settings,
    required this.downloadedOnly,
    required this.searchQuery,
    required this.ignoreFiltersOnSearch,
    required this.sourceIds,
    this.onAdjustFilters,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final sortType = ref
        .watch(
          sortLibraryMangaStateProvider(itemType: itemType, settings: settings),
        )
        .index;
    final mangaIdsList = ref.watch(mangasListStateProvider);
    final sourceBadge = ref.watch(librarySourceBadgeProvider);

    // Watch the global manga stream and filter by category in-memory,
    // avoiding N+1 active Isar database stream connections.
    final allMangaStream = ref.watch(
      getAllMangaStreamProvider(categoryId: null, itemType: itemType),
    );
    final mangaStream = allMangaStream.whenData((allMangas) {
      if (withoutCategories) {
        return allMangas
            .where((m) => m.categories == null || m.categories!.isEmpty)
            .toList();
      }
      if (categoryId != null) {
        return allMangas
            .where((m) => m.categories?.contains(categoryId) ?? false)
            .toList();
      }
      return allMangas;
    });

    return mangaStream.when(
      data: (data) {
        // Use the cached filtering provider instead of inline filtering
        final entries = ref.watch(
          filteredLibraryMangaProvider(
            data: data,
            downloadFilterType: downloadFilterType,
            unreadFilterType: unreadFilterType,
            startedFilterType: startedFilterType,
            bookmarkedFilterType: bookmarkedFilterType,
            completedFilterType: completedFilterType,
            trackingFilterType: trackingFilterType,
            sortType: sortType ?? 0,
            downloadedOnly: downloadedOnly,
            searchQuery: searchQuery,
            ignoreFiltersOnSearch: ignoreFiltersOnSearch,
            sourceIds: sourceIds,
            settings: settings,
          ),
        );

        if (entries.isEmpty) {
          if (isMobile && !isTv) {
            final filtered =
                (allMangaStream.asData?.value.isNotEmpty ?? false) ||
                searchQuery.isNotEmpty;
            final searching = searchQuery.isNotEmpty;
            return MobileBookshelfEmpty(
              title: filtered
                  ? l10n.bookshelf_no_match_title
                  : l10n.bookshelf_empty_title,
              subtitle: filtered
                  ? l10n.bookshelf_no_match_hint
                  : l10n.bookshelf_empty_hint,
              filtered: filtered,
              primaryLabel: filtered
                  ? (searching ? l10n.bookshelf_clear_query : l10n.filter)
                  : l10n.bookshelf_browse_sources,
              onPrimary: filtered
                  ? (searching
                        ? onClearSearch ?? () {}
                        : onAdjustFilters ?? () {})
                  : () {
                      ref
                          .read(browseInitialTabProvider.notifier)
                          .request(BrowseTab(itemType, BrowseTabKind.sources));
                      context.go('/browse');
                    },
              secondaryLabel: filtered
                  ? (searching ? l10n.filter : null)
                  : l10n.import_local_file,
              onSecondary: filtered
                  ? onAdjustFilters
                  : () => showImportLocalDialog(context, itemType),
            );
          }
          return Center(child: Text(l10n.empty_library));
        }

        final entriesManga = reverse
            ? sortType == 3
                  ? sortByUnreadCount(
                      entries,
                      unreadCountOf: (manga) =>
                          manga.unreadChaptersCount(settings),
                      descending: true,
                    )
                  : entries.reversed.toList()
            : entries;
        return RefreshIndicator(
          onRefresh: () async {
            await updateLibrary(
              ref: ref,
              context: context,
              mangaList: data,
              itemType: itemType,
            );
          },
          child: displayType == DisplayType.list
              ? LibraryListViewWidget(
                  entriesManga: entriesManga,
                  sourceBadge: sourceBadge,
                  continueReaderBtn: continueReaderBtn,
                  downloadedChapter: downloadedChapter,
                  language: language,
                  mangaIdsList: mangaIdsList,
                  localSource: localSource,
                  settings: settings,
                )
              : LibraryGridViewWidget(
                  entriesManga: entriesManga,
                  isCoverOnlyGrid: !(displayType == DisplayType.compactGrid),
                  isComfortableGrid: displayType == DisplayType.comfortableGrid,
                  continueReaderBtn: continueReaderBtn,
                  downloadedChapter: downloadedChapter,
                  language: language,
                  sourceBadge: sourceBadge,
                  mangaIdsList: mangaIdsList,
                  localSource: localSource,
                  itemType: itemType,
                  settings: settings,
                ),
        );
      },
      error: (error, _) => ErrorText(error),
      loading: () => const ProgressCenter(),
    );
  }
}

/// Presentation only; every category count uses the parent's filtered snapshot.
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    if (isMobile && !isTv) {
      return Text(
        '$count',
        style: const TextStyle(
          fontSize: NodeLaneTokens.captionSize,
          height: 1.3,
        ),
      );
    }
    return CircleAvatar(
      backgroundColor: Theme.of(context).focusColor,
      radius: 8,
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).textTheme.bodySmall!.color,
        ),
      ),
    );
  }
}
