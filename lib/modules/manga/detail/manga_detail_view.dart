import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/manga/detail/widgets/download_quick_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';
import 'package:mangayomi/modules/manga/detail/chapter_bulk_actions.dart';
import 'package:mangayomi/modules/manga/detail/detail_overflow_actions.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/tv/tv_anime_detail_view.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/detail_app_bar.dart';
import 'package:mangayomi/modules/manga/detail/widgets/detail_banner.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_info_header.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_chapter_settings.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_chapter_actions.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/modules/widgets/bottom_select_bar.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_widgets.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_loading.dart';

class MangaDetailView extends ConsumerStatefulWidget {
  final Widget titleDescription, action;
  final Widget Function(List<Chapter>) readingAction;
  final Manga manga;
  final bool sourceExist;
  final bool loading;
  final bool refreshFailed;
  final Future<void> Function() onRefresh;

  const MangaDetailView({
    super.key,
    required this.titleDescription,
    required this.action,
    required this.readingAction,
    required this.sourceExist,
    required this.manga,
    required this.onRefresh,
    this.loading = false,
    this.refreshFailed = false,
  });

  @override
  ConsumerState<MangaDetailView> createState() => _MangaDetailViewState();
}

class _MangaDetailViewState extends ConsumerState<MangaDetailView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        final offset = _scrollController.offset;
        _headerPosition.value = offset > 200
            ? DetailHeaderPosition.pastCover
            : offset == 0
            ? DetailHeaderPosition.top
            : DetailHeaderPosition.scrolled;
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerPosition.dispose();
    super.dispose();
  }

  /// One-time notice (per screen open) when some chapters have no
  /// detectable number — sort/dedup can't place them reliably.
  void _notifyUnrecognizedChapterNumbers() {
    if (_shownUnrecognizedNotice) return;
    final count = widget.manga.unrecognizedChapterNumberCount();
    if (count == 0) return;
    _shownUnrecognizedNotice = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l10n = l10nLocalizations(context)!;
      showNodeLaneNotice(l10n.unrecognized_chapter_numbers(count), seconds: 5);
    });
  }

  final _headerPosition = ValueNotifier(DetailHeaderPosition.top);
  bool _shownUnrecognizedNotice = false;
  bool _chapterActionBusy = false;
  late final ScrollController _scrollController;
  bool get isLocalArchive => widget.manga.isLocalArchive ?? false;

  /// The detail overflow actions, shared by the popup menu off-TV and the
  /// centred TV menu.
  Future<void> _onDetailOverflow(BuildContext origin, int value) =>
      handleDetailOverflowAction(
        value: value,
        context: origin,
        ref: ref,
        manga: widget.manga,
        isLocalArchive: isLocalArchive,
        onRefresh: widget.onRefresh,
      );

  @override
  Widget build(BuildContext context) {
    // On Android TV, anime gets a dedicated d-pad split detail (info left,
    // episodes right). Manga/novel and phones/desktop keep the classic detail.
    if (isTv && widget.manga.itemType == ItemType.anime) {
      return TvAnimeDetailView(manga: widget.manga);
    }
    // Watch all sort/filter providers so the list rebuilds whenever
    // the user changes the chapter settings.
    ref.watch(scanlatorsFilterStateProvider(widget.manga));
    ref.watch(sortChapterStateProvider(mangaId: widget.manga.id!));
    ref.watch(chapterFilterUnreadStateProvider(mangaId: widget.manga.id!));
    ref.watch(chapterFilterBookmarkedStateProvider(mangaId: widget.manga.id!));
    ref.watch(chapterFilterDownloadedStateProvider(mangaId: widget.manga.id!));
    final chapters = ref.watch(
      getChaptersStreamProvider(mangaId: widget.manga.id!),
    );
    final selecting = ref.watch(isLongPressedStateProvider);
    return PopScope(
      canPop: !(isMobile && !isTv && selecting) && !_chapterActionBusy,
      onPopInvokedWithResult: (didPop, result) {
        if (_chapterActionBusy || (!didPop && !selecting)) return;
        // Reset chapter selection so the top/bottom bars don't bleed into the library screen
        ref.read(isLongPressedStateProvider.notifier).update(false);
        ref.read(chaptersListStateProvider.notifier).clear();
      },
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if ((!isMobile || isTv) &&
              notification.direction != ScrollDirection.idle) {
            ref
                .read(isExtendedStateProvider.notifier)
                .update(notification.direction == ScrollDirection.forward);
          }
          return true;
        },
        child: chapters.when(
          data: (_) {
            List<Chapter> chapters = widget.manga.getSortedFilteredChapters();
            _notifyUnrecognizedChapterNumbers();
            return _buildWidget(chapters: chapters);
          },
          error: (Object error, StackTrace stackTrace) {
            if (isMobile && !isTv) {
              return _buildWidget(
                chapters: const [],
                retry: () => ref.invalidate(
                  getChaptersStreamProvider(mangaId: widget.manga.id!),
                ),
              );
            }
            return ErrorText(error);
          },
          loading: () {
            return _buildWidget(
              chapters: widget.manga.chapters.toList(),
              catalogLoading: true,
            );
          },
        ),
      ),
    );
  }

  Future<void> _downloadChapters(List<Chapter> chapters) async {
    final chaptersToDownload = chapters.where((chapter) {
      final entry = downloadRepository.getByChapterId(chapter.id);
      return entry == null || !entry.isDownload!;
    }).toList();
    if (chaptersToDownload.isEmpty) return;

    for (final chapter in chaptersToDownload) {
      await downloadRepository.enqueue(chapter);
    }
    if (!mounted) return;
    ref.invalidate(processDownloadsProvider());
    ref.read(processDownloadsProvider());
  }

  Widget _buildWidget({
    required List<Chapter> chapters,
    bool catalogLoading = false,
    VoidCallback? retry,
  }) {
    final loading = widget.loading || catalogLoading;
    final chapterList = ref.watch(chaptersListStateProvider);
    final mobile = isMobile && !isTv;
    final appBar = PreferredSize(
      preferredSize: Size.fromHeight(
        mobile ? nodeLaneAppBarHeight(context) : kToolbarHeight,
      ),
      child: ValueListenableBuilder(
        valueListenable: _headerPosition,
        builder: (_, position, _) => DetailAppBar(
          manga: widget.manga,
          chapters: chapters,
          position: position,
          onDownload: _downloadChapters,
          onShowFilterMenu: _showChapterSettings,
          onOverflowAction: _onDetailOverflow,
        ),
      ),
    );
    Widget chapterTile(BuildContext context, int index) =>
        ChapterListTileWidget(
          key: ValueKey(chapters[index].id),
          chapter: chapters[index],
          manga: widget.manga,
          chapterList: chapterList,
          allChapters: chapters,
          sourceExist: widget.sourceExist,
        );
    if (mobile) {
      return AbsorbPointer(
        absorbing: _chapterActionBusy,
        child: Scaffold(
          appBar: appBar,
          body: SafeArea(
            top: false,
            bottom: true,
            child: MangaInfoHeader(
              loading: loading,
              manga: widget.manga,
              isLocalArchive: isLocalArchive,
              titleDescription: widget.titleDescription,
              action: widget.action,
              readingAction: widget.readingAction(chapters),
              chapterLength: chapters.length,
              mobileLayout: (overview, information) => MobileDetailLayout(
                controller: _scrollController,
                overview: overview,
                information: information,
                chapterHeading: MobileChapterHeading(
                  manga: widget.manga,
                  count: chapters.length,
                  loading: loading,
                  onFilter: (anchor) => MobileChapterSettingsPanel(
                    manga: widget.manga,
                    localArchive: isLocalArchive,
                  ).show(anchor),
                  download: isLocalArchive
                      ? null
                      : DownloadQuickMenu(
                          manga: widget.manga,
                          hasChapters: chapters.isNotEmpty,
                          onDownload: _downloadChapters,
                        ),
                ),
                chapterCount: chapters.length,
                chapterBuilder: chapterTile,
                empty: retry != null || widget.refreshFailed
                    ? NodeLaneEmptyState.error(
                        compact: true,
                        title: context.l10n.reader_loading_failed,
                        onRetry: retry ?? widget.onRefresh,
                      )
                    : loading
                    ? const MobileChapterListLoading()
                    : Padding(
                        padding: NodeLaneTokens.groupPadding,
                        child: Text(
                          context.l10n.no_result,
                          textAlign: TextAlign.center,
                          style: NodeLaneTokens.of(context).readerSecondary,
                        ),
                      ),
              ),
            ),
          ),
          bottomNavigationBar: _selectionBar(chapters),
        ),
      );
    }
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: _headerPosition,
          child: DetailBanner(manga: widget.manga),
          builder: (_, position, banner) => position == DetailHeaderPosition.top
              ? banner!
              : const SizedBox.shrink(),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          floatingActionButton: widget.readingAction(chapters),
          appBar: appBar,
          body: SafeArea(
            child: Row(
              children: [
                if (context.isTablet)
                  SizedBox(
                    width: context.width(0.5),
                    height: context.height(1),
                    child: SingleChildScrollView(
                      child: MangaInfoHeader(
                        manga: widget.manga,
                        isLocalArchive: isLocalArchive,
                        titleDescription: widget.titleDescription,
                        action: widget.action,
                        chapterLength: chapters.length,
                      ),
                    ),
                  ),
                Expanded(
                  child: Scrollbar(
                    interactive: true,
                    thickness: 12,
                    radius: const Radius.circular(10),
                    controller: _scrollController,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 0, bottom: 60),
                          sliver: SuperSliverList.builder(
                            itemCount: chapters.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return context.isTablet
                                    ? DetailChapterHeading(
                                        manga: widget.manga,
                                        count: chapters.length,
                                      )
                                    : MangaInfoHeader(
                                        manga: widget.manga,
                                        isLocalArchive: isLocalArchive,
                                        titleDescription:
                                            widget.titleDescription,
                                        action: widget.action,
                                        chapterLength: chapters.length,
                                      );
                              }
                              return chapterTile(context, index - 1);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _selectionBar(chapters),
        ),
      ],
    );
  }

  Future<void> _toggleChapterBookmarks(List<Chapter> chapters) async {
    final List<Chapter> updatedChapters = [];
    final now = DateTime.now().millisecondsSinceEpoch;
    for (var chapter in chapters) {
      chapter.isBookmarked = !chapter.isBookmarked!;
      chapter.updatedAt = now;
      chapter.manga.value = widget.manga;
      updatedChapters.add(chapter);
    }
    await chapterRepository.putAll(updatedChapters);
  }

  Future<void> _markSelectedChapters(List<Chapter> chapters) async {
    final markAsRead = bulkChapterTargetReadState(chapters);
    final List<Chapter> updatedChapters = [];
    final now = DateTime.now().millisecondsSinceEpoch;
    Chapter? highestChapter;
    int highestNum = -1;
    final recognition = ChapterRecognition();
    final mangaTitle = widget.manga.name ?? '';
    for (var chapter in chapters) {
      chapter.isRead = markAsRead;
      if (!chapter.isRead!) chapter.lastPageRead = "1";
      chapter.updatedAt = now;
      chapter.manga.value = widget.manga;
      updatedChapters.add(chapter);
      if (chapter.isRead!) {
        final num = recognition.parseEpisodeNumber(
          mangaTitle,
          chapter.name ?? '',
        );
        if (num > highestNum) {
          highestNum = num;
          highestChapter = chapter;
        }
      }
    }
    highestChapter?.updateTrackChapterRead(ref);
    await chapterRepository.putAllWithManga(updatedChapters, widget.manga);
  }

  Future<void> _markFollowingChapters(
    List<Chapter> chapters,
    int selectedId,
  ) async {
    final index = chapters.indexWhere((chapter) => chapter.id == selectedId);
    if (index < 0 || index >= chapters.length - 1) return;
    final List<Chapter> updatedChapters = [];
    final now = DateTime.now().millisecondsSinceEpoch;
    chapters[index + 1].updateTrackChapterRead(ref);
    for (var i = index + 1; i < chapters.length; i++) {
      final chapter = chapters[i];
      if (!chapter.isRead!) {
        chapter.isRead = true;
        chapter.lastPageRead = "1";
        chapter.updatedAt = now;
        chapter.manga.value = widget.manga;
        updatedChapters.add(chapter);
      }
    }
    await chapterRepository.putAllWithManga(updatedChapters, widget.manga);
  }

  Future<void> _runMobileChapterAction(
    MobileChapterAction action,
    List<Chapter> displayed,
  ) async {
    if (_chapterActionBusy ||
        !mounted ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    if (!ref.read(isLongPressedStateProvider)) return;
    setState(() => _chapterActionBusy = true);
    try {
      final ids = ref
          .read(chaptersListStateProvider)
          .map((c) => c.id)
          .whereType<int>()
          .toList();
      final selected = chapterRepository
          .getAllByIds(ids)
          .whereType<Chapter>()
          .where((c) => c.mangaId == widget.manga.id)
          .toList();
      if (selected.isEmpty) return;
      switch (action) {
        case MobileChapterAction.bookmark:
          await _toggleChapterBookmarks(selected);
        case MobileChapterAction.read:
          await _markSelectedChapters(selected);
        case MobileChapterAction.readFollowing:
          if (selected.length != 1) return;
          await _markFollowingChapters(displayed, selected.single.id!);
        case MobileChapterAction.download:
          await _downloadChapters(selected);
        case MobileChapterAction.delete:
          final downloadedIds =
              ref.read(downloadedChapterIdsProvider).asData?.value ??
              const <int>{};
          final targets = selected
              .where(
                (chapter) =>
                    isLocalArchive || downloadedIds.contains(chapter.id),
              )
              .toList(growable: false);
          if (targets.isEmpty) return;
          final allChapters = isLocalArchive
              ? chapterRepository.getAllByMangaIdIndex(widget.manga.id)
              : const <Chapter>[];
          final targetIds = targets.map((chapter) => chapter.id).toSet();
          final container = ProviderScope.containerOf(context);
          await showMobileChapterDeleteConfirmation(
            context: context,
            bookTitle: widget.manga.name ?? '',
            titles: targets
                .map((chapter) => chapter.name ?? '')
                .toList(growable: false),
            localArchive: isLocalArchive,
            lastChapters: allChapters.every(
              (chapter) => targetIds.contains(chapter.id),
            ),
            onDelete: () => deleteMangaChapterSelection(
              manga: widget.manga,
              selected: targets,
              downloadedIds: downloadedIds,
            ),
            onDeleted: () {
              container.read(isLongPressedStateProvider.notifier).update(false);
              container.read(chaptersListStateProvider.notifier).clear();
            },
          );
          return;
      }
    } catch (_) {
      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (context) => NodeLaneAlertDialog(
            content: Text(context.l10n.chapter_action_incomplete),
            actions: [
              NodeLaneDialogAction(
                label: context.l10n.close,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
      return;
    } finally {
      if (mounted) setState(() => _chapterActionBusy = false);
    }
    if (!mounted) return;
    ref.read(isLongPressedStateProvider.notifier).update(false);
    ref.read(chaptersListStateProvider.notifier).clear();
  }

  Widget _selectionBar(List<Chapter> chapters) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    final mobile = isMobile && !isTv;
    return Builder(
      builder: (context) {
        final chap = ref.watch(chaptersListStateProvider);
        bool getLength1 = chap.length == 1;
        bool checkFirstBookmarked =
            chap.isNotEmpty && chap.first.isBookmarked! && getLength1;
        bool checkReadBookmarked =
            chap.isNotEmpty && chap.first.isRead! && getLength1;
        final l10n = l10nLocalizations(context)!;
        final color = Theme.of(context).textTheme.bodyLarge!.color!;
        final downloadedIds =
            ref.watch(downloadedChapterIdsProvider).asData?.value ??
            const <int>{};
        final isDownloaded = chap
            .where((c) => downloadedIds.contains(c.id))
            .toSet();
        final index = chap.length == 1
            ? chapters.indexWhere((chapter) => chapter.id == chap.first.id)
            : -1;
        final hasFollowing = index >= 0 && index < chapters.length - 1;
        if (mobile && widget.manga.itemType == ItemType.manga) {
          return MobileChapterSelectionBar(
            selected: chap,
            visible: isLongPressed,
            busy: _chapterActionBusy,
            hasFollowing: hasFollowing,
            canDownload: !isLocalArchive && isDownloaded.isEmpty,
            canDelete: isLocalArchive || isDownloaded.isNotEmpty,
            onAction: (action) => _runMobileChapterAction(action, chapters),
          );
        }
        return BottomSelectBar(
          isVisible: isLongPressed,
          respectSafeArea: mobile,
          backgroundColor: mobile ? NodeLaneTokens.of(context).surface : null,
          actions: [
            BottomSelectButton(
              tooltip: l10n.chapter_swipe_toggle_bookmark,
              icon: Icon(
                checkFirstBookmarked
                    ? Icons.bookmark_remove_outlined
                    : Icons.bookmark_add_outlined,
                color: color,
              ),
              onPressed: () {
                _toggleChapterBookmarks(ref.read(chaptersListStateProvider));
                ref.read(isLongPressedStateProvider.notifier).update(false);
                ref.read(chaptersListStateProvider.notifier).clear();
              },
            ),
            BottomSelectButton(
              tooltip: l10n.chapter_swipe_toggle_read,
              icon: Icon(
                checkReadBookmarked
                    ? Icons.remove_done_sharp
                    : Icons.done_all_sharp,
                color: color,
              ),
              onPressed: () {
                _markSelectedChapters(ref.read(chaptersListStateProvider));
                ref.read(isLongPressedStateProvider.notifier).update(false);
                ref.read(chaptersListStateProvider.notifier).clear();
              },
            ),
            if (hasFollowing)
              BottomSelectButton(
                icon: Stack(
                  children: [
                    Icon(Icons.done_outlined, color: color),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.arrow_downward_outlined,
                        size: 11,
                        color: color,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  _markFollowingChapters(chapters, chap.first.id!);
                  ref.read(isLongPressedStateProvider.notifier).update(false);
                  ref.read(chaptersListStateProvider.notifier).clear();
                },
              ),
            // If not local archive and not downloaded, show download button
            if (!isLocalArchive && isDownloaded.isEmpty && !isTv)
              BottomSelectButton(
                tooltip: l10n.download,
                icon: Icon(Icons.download_outlined, color: color),
                onPressed: () async {
                  await _downloadChapters(ref.read(chaptersListStateProvider));
                  if (!mounted) return;
                  ref.read(isLongPressedStateProvider.notifier).update(false);
                  ref.read(chaptersListStateProvider.notifier).clear();
                },
              ),
            // show delete button if local archive or downloaded
            if (isLocalArchive || isDownloaded.isNotEmpty)
              BottomSelectButton(
                tooltip: l10n.delete,
                icon: Icon(Icons.delete_outline_outlined, color: color),
                onPressed: () {
                  final selectedChapters = ref.watch(chaptersListStateProvider);
                  final totalChapters = widget.manga.chapters.length;
                  final isLastChapters =
                      selectedChapters.length == totalChapters;
                  final isAnime = widget.manga.itemType == ItemType.anime;
                  final entryType = isAnime ? l10n.episode : l10n.chapter;
                  final pluralEntryType = isAnime
                      ? l10n.episodes
                      : l10n.chapters;
                  final mediaType = isAnime ? l10n.anime : l10n.manga;
                  final warningMessage = l10n.last_entry_delete_warning(
                    totalChapters,
                    entryType,
                    pluralEntryType,
                    mediaType,
                  );
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(l10n.delete_chapters),
                        scrollable: true,
                        content: isLocalArchive && isLastChapters
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      warningMessage,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              )
                            : null,
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              if (isLocalArchive) {
                                final idsToDelete = selectedChapters
                                    .map((c) => c.id!)
                                    .toList();
                                await chapterRepository.deleteAll(idsToDelete);
                              }
                              for (final chapter in isDownloaded) {
                                await chapter.deleteDownloadedFiles();
                              }
                              if (!mounted) return;
                              ref
                                  .read(isLongPressedStateProvider.notifier)
                                  .update(false);
                              ref
                                  .read(chaptersListStateProvider.notifier)
                                  .clear();
                              navigator.pop();
                              if (isLocalArchive && isLastChapters) {
                                navigator.pop();
                                Future.delayed(
                                  const Duration(milliseconds: 350),
                                  () {
                                    mangaRepository.delete(widget.manga.id!);
                                  },
                                );
                              }
                            },
                            child: Text(l10n.delete),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }

  void _showChapterSettings() {
    final scanlators = ref.read(scanlatorsFilterStateProvider(widget.manga));
    final l10n = l10nLocalizations(context)!;
    final labels = [l10n.filter, l10n.sort, l10n.display];
    final children = <Widget>[
      Consumer(
        builder: (context, ref, child) {
          return Column(
            children: [
              if (!isLocalArchive)
                ListTileChapterFilter(
                  label: l10n.downloaded,
                  type: ref.watch(
                    chapterFilterDownloadedStateProvider(
                      mangaId: widget.manga.id!,
                    ),
                  ),
                  onTap: () {
                    ref
                        .read(
                          chapterFilterDownloadedStateProvider(
                            mangaId: widget.manga.id!,
                          ).notifier,
                        )
                        .update();
                  },
                ),
              ListTileChapterFilter(
                label: widget.manga.itemType != ItemType.anime
                    ? l10n.unread
                    : l10n.unwatched,
                type: ref.watch(
                  chapterFilterUnreadStateProvider(mangaId: widget.manga.id!),
                ),
                onTap: () {
                  ref
                      .read(
                        chapterFilterUnreadStateProvider(
                          mangaId: widget.manga.id!,
                        ).notifier,
                      )
                      .update();
                },
              ),
              ListTileChapterFilter(
                label: l10n.bookmarked,
                type: ref.watch(
                  chapterFilterBookmarkedStateProvider(
                    mangaId: widget.manga.id!,
                  ),
                ),
                onTap: () {
                  ref
                      .read(
                        chapterFilterBookmarkedStateProvider(
                          mangaId: widget.manga.id!,
                        ).notifier,
                      )
                      .update();
                },
              ),
              if (scanlators.$1.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Consumer(
                                  builder: (context, ref, child) {
                                    final scanlators = ref.watch(
                                      scanlatorsFilterStateProvider(
                                        widget.manga,
                                      ),
                                    );
                                    return AlertDialog(
                                      title: Text(l10n.filter_scanlator_groups),
                                      content: SizedBox(
                                        width: context.width(0.8),
                                        child: SuperListView.builder(
                                          shrinkWrap: true,
                                          itemCount: scanlators.$1.length,
                                          itemBuilder: (context, index) {
                                            return ListTileChapterFilter(
                                              label: scanlators.$1[index],
                                              type:
                                                  scanlators.$3.contains(
                                                    scanlators.$1[index],
                                                  )
                                                  ? 2
                                                  : 0,
                                              onTap: () {
                                                ref
                                                    .read(
                                                      scanlatorsFilterStateProvider(
                                                        widget.manga,
                                                      ).notifier,
                                                    )
                                                    .setFilteredList(
                                                      scanlators.$1[index],
                                                    );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          ref
                                                              .read(
                                                                scanlatorsFilterStateProvider(
                                                                  widget.manga,
                                                                ).notifier,
                                                              )
                                                              .set([]);
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Text(
                                                          l10n.reset,
                                                          style: TextStyle(
                                                            color: context
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        l10n.cancel,
                                                        style: TextStyle(
                                                          color: context
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        ref
                                                            .read(
                                                              scanlatorsFilterStateProvider(
                                                                widget.manga,
                                                              ).notifier,
                                                            )
                                                            .set(scanlators.$3);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        l10n.filter,
                                                        style: TextStyle(
                                                          color: context
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Text(l10n.filter_scanlator_groups),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
      Consumer(
        builder: (context, ref, chil) {
          final reverse = ref
              .read(
                sortChapterStateProvider(mangaId: widget.manga.id!).notifier,
              )
              .isReverse();
          final scanlators = ref.watch(
            scanlatorsFilterStateProvider(widget.manga),
          );
          final reverseChapter = ref.watch(
            sortChapterStateProvider(mangaId: widget.manga.id!),
          );
          return Column(
            children: [
              if (scanlators.$1.isNotEmpty)
                ListTileChapterSort(
                  label: _getSortNameByIndex(0, context),
                  reverse: reverse,
                  onTap: () {
                    ref
                        .read(
                          sortChapterStateProvider(mangaId: widget.manga.id!)
                              .notifier,
                        )
                        .set(0);
                  },
                  showLeading: reverseChapter.index == 0,
                ),
              for (var i = 1; i < 4; i++)
                ListTileChapterSort(
                  label: _getSortNameByIndex(i, context),
                  reverse: reverse,
                  onTap: () {
                    ref
                        .read(
                          sortChapterStateProvider(mangaId: widget.manga.id!)
                              .notifier,
                        )
                        .set(i);
                  },
                  showLeading: reverseChapter.index == i,
                ),
            ],
          );
        },
      ),
      RadioGroup(
        groupValue: "e",
        onChanged: (value) {},
        child: Column(
          children: [
            RadioListTile(
              dense: true,
              title: Text(l10n.source_title),
              value: "e",
              selected: true,
            ),
            RadioListTile(
              dense: true,
              title: Text(
                widget.manga.itemType != ItemType.anime
                    ? l10n.chapter_number
                    : l10n.episode_number,
              ),
              value: "ej",
              selected: false,
            ),
          ],
        ),
      ),
    ];
    customDraggableTabBar(
      tabs: [for (final label in labels) Tab(text: label)],
      children: children,
      context: context,
      vsync: this,
    );
  }

  String _getSortNameByIndex(int index, BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (index == 0) {
      return l10n.by_scanlator;
    } else if (index == 1) {
      return widget.manga.itemType != ItemType.anime
          ? l10n.by_chapter_number
          : l10n.by_episode_number;
    } else if (index == 2) {
      return l10n.by_upload_date;
    }
    return l10n.by_name;
  }
}
