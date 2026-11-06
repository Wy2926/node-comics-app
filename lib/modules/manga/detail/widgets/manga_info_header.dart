import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/library/library_screen.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_cover_viewer.dart';
import 'package:mangayomi/modules/manga/detail/widgets/readmore.dart';
import 'package:mangayomi/modules/manga/detail/widgets/split_chapters_dialog.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracking_menu.dart';
import 'package:mangayomi/modules/more/providers/algorithm_weights_state_provider.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_screen.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_widgets.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_loading.dart';

/// The detail page's info block: cover, title, favourite/webview/tracker
/// actions, description (collapsible), genre chips and the
/// recommendations/related/watch-order strip. A separate widget so it owns
/// its own "description expanded" state instead of that living on the whole
/// page's State.
class MangaInfoHeader extends ConsumerStatefulWidget {
  final Manga manga;
  final bool isLocalArchive;
  final bool loading;
  final Widget titleDescription;
  final Widget action;
  final int chapterLength;
  final Widget? readingAction;
  final VoidCallback? onShowFilterMenu;

  const MangaInfoHeader({
    super.key,
    required this.manga,
    required this.isLocalArchive,
    required this.titleDescription,
    required this.action,
    required this.chapterLength,
    this.readingAction,
    this.onShowFilterMenu,
    this.loading = false,
  });

  @override
  ConsumerState<MangaInfoHeader> createState() => _MangaInfoHeaderState();
}

class _MangaInfoHeaderState extends ConsumerState<MangaInfoHeader> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (isMobile && !isTv) return _mobileHeader(l10n);
    return Stack(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor
                    .withValues(alpha: 0.05),
                Theme.of(context).scaffoldBackgroundColor,
              ],
              stops: const [0, .3],
            ),
          ),
        ),
        Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: context.width(1),
                  child: Row(
                    children: [
                      _coverCard(),
                      Expanded(child: _titles()),
                    ],
                  ),
                ),
                if (widget.isLocalArchive)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        _editLocalArchiveInfos();
                      },
                      icon: const CircleAvatar(
                        child: Icon(Icons.edit_outlined),
                      ),
                    ),
                  ),
              ],
            ),
            _actionFavouriteAndWebview(),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.manga.description != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReadMoreWidget(
                        text: widget.manga.description!,
                        onChanged: (value) {
                          setState(() {
                            _expanded = value;
                          });
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: widget.manga.genre!.isEmpty
                        ? const SizedBox(height: 30)
                        : _expanded || context.isTablet
                        ? Wrap(
                            children: [
                              for (
                                var i = 0;
                                i < widget.manga.genre!.length;
                                i++
                              )
                                _genreChip(i, l10n),
                            ],
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (
                                  var i = 0;
                                  i < widget.manga.genre!.length;
                                  i++
                                )
                                  _genreChip(i, l10n),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 15),
                  _DetailActions(manga: widget.manga),
                  const SizedBox(height: 15),
                  if (!context.isTablet)
                    Column(
                      children: [
                        //Description
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: widget.isLocalArchive
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.manga.itemType != ItemType.anime
                                          ? l10n.n_chapters(
                                              widget.chapterLength,
                                            )
                                          : l10n.n_episodes(
                                              widget.chapterLength,
                                            ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        final missing = widget.manga
                                            .missingChapterCount();
                                        if (missing <= 0) {
                                          return const SizedBox.shrink();
                                        }
                                        return Text(
                                          widget.manga.itemType !=
                                                  ItemType.anime
                                              ? l10n.missing_chapters(missing)
                                              : l10n.missing_episodes(missing),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.red[400],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.isLocalArchive)
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.add,
                                    color: context.secondaryColor,
                                  ),
                                  label: Text(
                                    widget.manga.itemType != ItemType.anime
                                        ? l10n.add_chapters
                                        : l10n.add_episodes,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: context.secondaryColor,
                                    ),
                                  ),
                                  onPressed: _addChapters,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (widget.chapterLength == 0)
              Container(
                width: context.width(1),
                height: context.height(1),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
          ],
        ),
      ],
    );
  }

  Widget _mobileHeader(AppLocalizations l10n) {
    final colors = NodeLaneTokens.of(context);
    final missing = widget.manga.missingChapterCount();
    final filtering = !ref.watch(
      chapterFilterResultStateProvider(manga: widget.manga),
    );
    final genres = widget.manga.genre ?? const <String>[];
    return MobileDetailOverview(
      heading: MobileDetailHeading(
        cover: _coverCard(),
        title: _titles(includeMetadata: false),
        metadata: DefaultTextStyle.merge(
          style: colors.detailMetadata,
          child: widget.titleDescription,
        ),
      ),
      actions: MobileDetailPrimaryActions(
        reading: widget.loading && widget.chapterLength == 0
            ? FilledButton.icon(
                onPressed: null,
                icon: Icon(
                  NodeLaneIcons.of(context).manga,
                  size: NodeLaneTokens.iconSize,
                ),
                label: Text(l10n.detail_loading_chapters),
              )
            : !ref.watch(isLongPressedStateProvider) && widget.chapterLength > 0
            ? widget.readingAction
            : null,
        library: widget.action,
      ),
      synopsis:
          (widget.manga.description?.trim().isNotEmpty ?? false) ||
              genres.isNotEmpty
          ? MobileDetailSynopsis(
              title: l10n.manga_synopsis,
              text: widget.manga.description ?? '',
              expanded: _expanded,
              onChanged: (value) => setState(() => _expanded = value),
              genres: [
                for (var i = 0; i < genres.length; i++) _genreChip(i, l10n),
              ],
            )
          : widget.loading
          ? const MobileDetailSynopsisLoading()
          : null,
      more: NodeLaneDisclosure(
        title: l10n.more,
        compact: true,
        child: Builder(
          builder: (context) => StreamBuilder(
            stream: trackRepository.watchAllWithSyncId(),
            builder: (context, snapshot) {
              final entries = snapshot.data ?? <TrackPreference>[];
              return _DetailActions(
                manga: widget.manga,
                leading: [
                  if (widget.isLocalArchive)
                    _headerButton(
                      icon: NodeLaneIcons.of(context).edit,
                      label: l10n.edit,
                      onPressed: _editLocalArchiveInfos,
                    ),
                  if (!widget.isLocalArchive) _webviewButton(),
                  if (entries.isNotEmpty) _trackingAction(entries),
                  if (!widget.isLocalArchive) _smartUpdateDays(),
                ],
              );
            },
          ),
        ),
      ),
      chapters: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.loading && widget.chapterLength == 0
                      ? widget.manga.itemType == ItemType.anime
                            ? l10n.episodes
                            : l10n.chapters
                      : widget.manga.itemType != ItemType.anime
                      ? '${l10n.chapters} · ${widget.chapterLength}'
                      : '${l10n.episodes} · ${widget.chapterLength}',
                  style: colors.detailSectionTitle,
                ),
              ),
              if (widget.isLocalArchive)
                NodeLaneIconButton(
                  style: NodeLaneIconButtonStyle.plain,
                  tooltip: widget.manga.itemType != ItemType.anime
                      ? l10n.add_chapters
                      : l10n.add_episodes,
                  onPressed: _addChapters,
                  icon: NodeLaneIcons.of(context).add,
                ),
              NodeLaneIconButton(
                busy: widget.loading,
                icon: NodeLaneIcons.of(context).filter,
                tooltip: widget.loading
                    ? l10n.detail_loading_chapters
                    : l10n.filter,
                onPressed: widget.onShowFilterMenu,
                active: filtering,
              ),
            ],
          ),
          if (missing > 0)
            Text(
              widget.manga.itemType != ItemType.anime
                  ? l10n.missing_chapters(missing)
                  : l10n.missing_episodes(missing),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }

  Widget _genreChip(int index, AppLocalizations l10n) {
    return DetailGenreChip(
      label: widget.manga.genre![index],
      mobile: isMobile && !isTv,
      libraryLabel: l10n.genre_search_library,
      sourceLabel: l10n.genre_search_source,
      onSelected: (value) => _selectGenre(index, value, l10n),
    );
  }

  void _selectGenre(int index, int value, AppLocalizations l10n) {
    if (value == 0) {
      final genre = widget.manga.genre![index];
      switch (widget.manga.itemType) {
        case ItemType.manga:
          context.pushReplacement('/MangaLibrary', extra: genre);
          break;
        case ItemType.anime:
          context.pushReplacement('/AnimeLibrary', extra: genre);
          break;
        case ItemType.novel:
          context.pushReplacement('/NovelLibrary', extra: genre);
          break;
      }
      return;
    }

    final source = getSource(
      widget.manga.lang!,
      widget.manga.source!,
      widget.manga.sourceId,
    );
    if (source == null) {
      showNodeLaneNotice(l10n.source_not_added);
      return;
    }
    context.pushReplacement('/mangaHome', extra: (source, false));
  }

  Widget _coverCard() {
    final imageProvider = widget.manga.customCoverImage != null
        ? MemoryImage(widget.manga.customCoverImage as Uint8List)
              as ImageProvider
        : CustomExtendedNetworkImageProvider(
            toImgUrl(
              widget.manga.customCoverFromTracker ??
                  widget.manga.imageUrl ??
                  "",
            ),
            headers: widget.manga.isLocalArchive!
                ? null
                : ref.watch(
                    headersProvider(
                      source: widget.manga.source!,
                      lang: widget.manga.lang!,
                      sourceId: widget.manga.sourceId,
                    ),
                  ),
          );
    if (isMobile && !isTv) {
      final colors = NodeLaneTokens.of(context);
      return Semantics(
        button: true,
        image: true,
        label: widget.manga.name,
        child: GestureDetector(
          onTap: () => _openImage(imageProvider),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
            child: Image(
              image: ResizeImage.resizeIfNeeded(
                (NodeLaneTokens.detailCoverWidth *
                        MediaQuery.devicePixelRatioOf(context))
                    .ceil(),
                null,
                imageProvider,
              ),
              width: NodeLaneTokens.detailCoverWidth,
              height: NodeLaneTokens.detailCoverHeight,
              fit: BoxFit.cover,
              frameBuilder: (_, child, frame, synchronous) =>
                  synchronous || frame != null
                  ? child
                  : const NodeLaneSkeleton(
                      width: NodeLaneTokens.detailCoverWidth,
                      height: NodeLaneTokens.detailCoverHeight,
                      radius: NodeLaneTokens.coverRadius,
                    ),
              errorBuilder: (_, _, _) => Container(
                width: NodeLaneTokens.detailCoverWidth,
                height: NodeLaneTokens.detailCoverHeight,
                color: colors.soft,
                child: Icon(
                  NodeLaneIcons.of(context).manga,
                  color: colors.muted,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
      child: GestureDetector(
        onTap: () {
          _openImage(imageProvider);
        },
        child: SizedBox(
          width: 65 * 1.5,
          height: 65 * 2.3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titles({bool includeMetadata = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            final name = widget.manga.name;
            if (name != null && name.trim().isNotEmpty) {
              context.push(
                '/globalSearch',
                extra: (name, widget.manga.itemType),
              );
            }
          },
          onLongPress: () async {
            final name = widget.manga.name;
            if (name != null && name.isNotEmpty) {
              await Clipboard.setData(ClipboardData(text: name));
              if (mounted) {
                showNodeLaneNotice(
                  context.l10n.error_reports_copied,
                  seconds: 2,
                  kind: NodeLaneNoticeKind.success,
                );
              }
            }
          },
          child: Text(
            widget.manga.name!,
            style: isMobile && !isTv
                ? NodeLaneTokens.of(context).detailTitle
                : const TextStyle(fontSize: 20),
          ),
        ),
        if (includeMetadata) widget.titleDescription,
      ],
    );
  }

  Widget _actionFavouriteAndWebview() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: widget.action),
          if (!widget.isLocalArchive) Expanded(child: _smartUpdateDays()),
          _action(),
          if (!widget.isLocalArchive) Expanded(child: _webviewButton()),
        ],
      ),
    );
  }

  Widget _headerButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    if (isMobile && !isTv) {
      return NodeLaneToolbarAction(
        icon: icon,
        label: label,
        onPressed: onPressed,
      );
    }
    color ??= context.secondaryColor;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: color),
          ),
        ],
      ),
    );
  }

  Widget _webviewButton() => _headerButton(
    icon: isMobile && !isTv ? NodeLaneIcons.of(context).webLink : Icons.public,
    label: context.l10n.webview,
    onPressed: _openWebview,
  );

  void _openWebview() {
    final manga = widget.manga;

    final source = getSource(
      widget.manga.lang!,
      widget.manga.source!,
      widget.manga.sourceId,
    );
    if (source == null) return;
    String url = "";
    final baseUrl = source.baseUrl;
    final link = widget.manga.link!.getUrlWithoutDomain;
    if (baseUrl == null) return;
    if (baseUrl.endsWith("/") && link.startsWith("/")) {
      url = baseUrl + link.substring(1);
    } else if (!baseUrl.endsWith("/") && !link.startsWith("/")) {
      url = "$baseUrl/$link";
    } else {
      url = "$baseUrl$link";
    }

    Map<String, dynamic> data = {
      'url': url,
      'sourceId': source.id.toString(),
      'title': manga.name!,
    };
    context.push("/mangawebview", extra: data);
  }

  Future<void> _addChapters() async {
    final manga = widget.manga;
    if (manga.source == "torrent") {
      addTorrent(context, manga: manga);
    } else {
      final splitChapters = manga.itemType == ItemType.novel
          ? await showSplitChaptersDialog(context)
          : true;
      if (!context.mounted) return;
      await ref.watch(
        importArchivesFromFileProvider(
          itemType: manga.itemType,
          manga,
          init: false,
          splitChapters: splitChapters,
        ).future,
      );
    }
  }

  Widget _smartUpdateDays() => _headerButton(
    icon: isMobile && !isTv
        ? NodeLaneIcons.of(context).calendar
        : Icons.hourglass_empty,
    label: widget.manga.smartUpdateDays != null
        ? context.l10n.n_days(widget.manga.smartUpdateDays!)
        : isMobile && !isTv
        ? context.l10n.calendar
        : 'N/A',
    onPressed: () =>
        context.push('/calendarScreen', extra: widget.manga.itemType),
  );

  Widget _action() => StreamBuilder(
    stream: trackRepository.watchAllWithSyncId(),
    builder: (context, snapshot) {
      final entries = snapshot.data ?? <TrackPreference>[];
      if (entries.isEmpty) return const SizedBox.shrink();
      return _trackingAction(entries);
    },
  );

  Widget _trackingAction(List<TrackPreference> entries) {
    final button = StreamBuilder(
      stream: trackRepository.watchByMangaId(widget.manga.id!),
      builder: (context, snapshot) {
        final l10n = l10nLocalizations(context)!;
        final tracks = snapshot.data ?? <Track>[];
        return _headerButton(
          icon: isMobile && !isTv
              ? (tracks.isNotEmpty
                    ? NodeLaneIcons.of(context).check
                    : NodeLaneIcons.of(context).tracking)
              : (tracks.isNotEmpty ? Icons.done_rounded : Icons.sync_outlined),
          label: tracks.isNotEmpty
              ? tracks.length == 1
                    ? l10n.one_tracker
                    : l10n.n_tracker(tracks.length)
              : l10n.tracking,
          color: tracks.isNotEmpty
              ? context.primaryColor
              : context.secondaryColor,
          onPressed: () => _trackingDraggableMenu(entries),
        );
      },
    );
    return isMobile && !isTv ? button : Expanded(child: button);
  }

  void _openImage(ImageProvider imageProvider) {
    showMangaCoverViewer(
      context,
      manga: widget.manga,
      imageProvider: imageProvider,
    );
  }

  Future<void> _editLocalArchiveInfos() async {
    final l10n = l10nLocalizations(context)!;
    final name = TextEditingController(text: widget.manga.name ?? '');
    final description = TextEditingController(
      text: widget.manga.description ?? '',
    );
    final route = ModalBottomSheetRoute<void>(
      builder: (sheetContext) => NodeLaneCatalogSheet(
        title: l10n.edit,
        fitContent: true,
        heightFactor: .9,
        bottom: NodeLaneModalActions(
          actions: [
            NodeLaneDialogAction(
              label: l10n.save,
              onPressed: () {
                final manga = widget.manga;
                manga.description = description.text;
                manga.name = name.text;
                mangaRepository.save(manga);
                Navigator.pop(sheetContext);
              },
            ),
          ],
        ),
        child: ListView(
          shrinkWrap: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(
            horizontal: NodeLaneTokens.gutter,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: NodeLaneTokens.space16,
              children: [
                NodeLaneTextField(
                  controller: name,
                  label: l10n.name,
                  textInputAction: TextInputAction.next,
                ),
                NodeLaneTextField(
                  controller: description,
                  label: l10n.description,
                  minLines: 2,
                  maxLines: 5,
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      shape: NodeLaneTokens.readerSheetShape,
    );
    await Navigator.of(context).push(route);
    await route.completed;
    name.dispose();
    description.dispose();
  }

  void _trackingDraggableMenu(List<TrackPreference>? entries) {
    openTrackingMenu(
      context: context,
      manga: widget.manga,
      entries: entries ?? const [],
    );
  }
}

/// A genre chip that exposes the same search menu in every detail layout.
class DetailGenreChip extends StatelessWidget {
  const DetailGenreChip({
    super.key,
    required this.label,
    required this.libraryLabel,
    required this.sourceLabel,
    required this.onSelected,
    this.mobile = false,
  });

  final bool mobile;
  final String label;
  final String libraryLabel;
  final String sourceLabel;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    if (mobile) {
      return NodeLaneMenuButton<int>.label(
        label: label,
        tooltip: label,
        onSelected: onSelected,
        itemBuilder: (context) => [
          PopupMenuItem(value: 0, child: Text(libraryLabel)),
          PopupMenuItem(value: 1, child: Text(sourceLabel)),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2, bottom: 5),
      child: SizedBox(
        height: 30,
        child: PopupMenuButton<int>(
          popUpAnimationStyle: popupAnimationStyle,
          itemBuilder: (context) => [
            // These are the only two menu rows in the app that set their own
            // height, and 40 is under the minimum target on Material and Apple.
            PopupMenuItem<int>(height: 48, value: 0, child: Text(libraryLabel)),
            PopupMenuItem<int>(height: 48, value: 1, child: Text(sourceLabel)),
          ],
          onSelected: onSelected,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                widthFactor: 1,
                child: Text(
                  label,
                  style: TextStyle(
                    // 11 is the chip step. 11.5 is not on the scale and
                    // renders inconsistently across platforms.
                    fontSize: 11,
                    // The theme already answers this; picking black or white
                    // by hand ignores the palette.
                    color: context.textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One action on the detail page.
class _DetailAction {
  const _DetailAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
}

/// The things you can do with a title from its detail page, as one control.
///
/// These used to be up to three full-width buttons stacked down the page, each
/// carrying the same right-arrow icon, so the column said nothing about what
/// any of them did and grew a row every time an action was added.
///
/// One bordered strip of equal segments rather than loose buttons. Loose ones
/// size to their labels, so they sat ragged and adrift in the middle of a
/// desktop window and left an orphan on the second line of a phone. Segments
/// divide the width they are given, which means the strip looks deliberate at
/// any width and with two, three or four actions in it.
class _DetailActions extends ConsumerWidget {
  const _DetailActions({required this.manga, this.leading = const []});

  final List<Widget> leading;

  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;

    // Everything this title is related to, including the one thing that
    // cannot be reached any other way from in here: its adaptation in the
    // other medium.
    final related = _DetailAction(
      icon: isMobile && !isTv
          ? NodeLaneIcons.of(context).related
          : Icons.account_tree_outlined,
      label: l10n.related_titles,
      onPressed: () =>
          context.push("/related", extra: (manga.name!, manga.itemType)),
    );

    if (manga.itemType != ItemType.anime) {
      final media = MediaLookupContext.fromManga(manga);
      final recommendations = _recommendationsAction(context, ref, media);
      return _strip(context, [recommendations, related]);
    }

    // Sequels needs a MyAnimeList or AniList track to look anything up, so it
    // only appears once there is one.
    return StreamBuilder(
      stream: trackRepository.watchByMangaId(manga.id!),
      builder: (context, snapshot) {
        final tracks = snapshot.data ?? const <Track>[];
        Track? sequelTrack;
        for (final track in tracks) {
          final mediaId = track.mediaId;
          if (mediaId != null &&
              mediaId > 0 &&
              (track.syncId == TrackerProviders.myAnimeList.syncId ||
                  track.syncId == TrackerProviders.anilist.syncId)) {
            sequelTrack ??= track;
          }
        }
        final media = MediaLookupContext.fromManga(manga, tracks: tracks);
        final recommendations = _recommendationsAction(context, ref, media);
        final watchOrder = _DetailAction(
          icon: Icons.format_list_numbered_outlined,
          label: l10n.watch_order,
          onPressed: () =>
              context.push("/watchOrder", extra: (media, null as Track?)),
        );

        return _strip(context, [
          recommendations,
          related,
          watchOrder,
          if (sequelTrack != null)
            _DetailAction(
              icon: Icons.playlist_play_outlined,
              label: l10n.sequels,
              onPressed: () =>
                  context.push("/watchOrder", extra: (media, sequelTrack)),
            ),
        ]);
      },
    );
  }

  _DetailAction _recommendationsAction(
    BuildContext context,
    WidgetRef ref,
    MediaLookupContext media,
  ) {
    return _DetailAction(
      icon: isMobile && !isTv
          ? NodeLaneIcons.of(context).recommend
          : Icons.auto_awesome_outlined,
      label: context.l10n.recommendations,
      onPressed: () => context.push(
        "/recommendations",
        extra: (media, ref.read(algorithmWeightsStateProvider)),
      ),
    );
  }

  Widget _strip(BuildContext context, List<_DetailAction> actions) {
    if (isMobile && !isTv) {
      return MobileDetailShortcuts(
        children: [
          ...leading,
          for (final action in actions)
            NodeLaneToolbarAction(
              icon: action.icon,
              label: action.label,
              onPressed: action.onPressed,
            ),
        ],
      );
    }
    // Tinted rather than the neutral outline, so the border belongs to the
    // accent the segments are drawn in. Kept faint: it frames the strip, it
    // is not another thing to look at.
    final outline = context.primaryColor.withValues(alpha: 0.35);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: outline),
          borderRadius: BorderRadius.circular(16),
        ),
        // So a segment's ink and its focus highlight stay inside the border.
        clipBehavior: Clip.antiAlias,
        // Every segment as tall as the tallest, which is what keeps the
        // dividers full height when one label wraps to two lines.
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < actions.length; i++) ...[
                if (i > 0)
                  VerticalDivider(width: 1, thickness: 1, color: outline),
                Expanded(child: _segment(context, actions[i])),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Icon above label rather than beside it. These labels are localised and
  /// some translations are long; stacked, a long one takes a second line
  /// instead of pushing the icon out or clipping.
  Widget _segment(BuildContext context, _DetailAction action) {
    // The accent, so the strip reads as something to press and follows
    // whichever colour the user picked rather than sitting in body-text grey.
    final accent = context.primaryColor;

    return InkWell(
      onTap: action.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action.icon, size: 20, color: accent),
            const SizedBox(height: 5),
            Text(
              action.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
