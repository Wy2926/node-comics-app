import 'dart:async';

import 'package:mangayomi/modules/browse/global_search/source_search_scope.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';

import 'package:mangayomi/utils/source_fetch_gate.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/modules/manga/detail/widgets/migrate_screen.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/browse_screen.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'mobile_global_search.dart';

export 'package:mangayomi/utils/source_fetch_gate.dart' show FetchGate;

class GlobalSearchScreen extends ConsumerStatefulWidget {
  final String? search;
  final ItemType itemType;
  const GlobalSearchScreen({this.search, required this.itemType, super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  late String _query;
  int _searchVersion = 0;
  final _textEditingController = TextEditingController();
  final _fetchGate = FetchGate(3);

  /// Every installed source for this item type, before the pinned-only and
  /// NSFW settings are applied.
  ///
  /// Kept so an empty result can say which of the three reasons it is: none
  /// installed, none pinned, or all of them hidden as NSFW. They need
  /// different things done about them.
  late List<Source> _installedSources;
  late List<Source> sourceList;
  Set<int>? _scopeIds;

  void _readSources() {
    _installedSources = sourceRepository.getAddedByItemType(widget.itemType);
    final sources = _installedSources
        .where(
          (s) =>
              (_scopeIds == null || _scopeIds!.contains(s.id)) &&
              (!ref.read(onlyIncludePinnedSourceStateProvider) ||
                  s.isPinned == true),
        )
        .toList();
    sourceList = ref.read(showNSFWStateProvider)
        ? sources
        : sources.where((e) => !(e.isNsfw ?? false)).toList();
  }

  Future<void> _editScope() async {
    final candidates = sourceRepository
        .getAddedByItemType(widget.itemType)
        .where((s) => ref.read(showNSFWStateProvider) || s.isNsfw != true)
        .toList();
    final result = await Navigator.of(context).push<SourceSearchScope>(
      MaterialPageRoute(
        builder: (_) => SourceSearchScopePage(
          sources: candidates,
          media: widget.itemType.localized(context.l10n),
          current: SourceSearchScope(
            _scopeIds ?? candidates.map((s) => s.id).whereType<int>().toSet(),
            ref.read(onlyIncludePinnedSourceStateProvider),
          ),
        ),
      ),
    );
    if (!mounted || result == null) return;
    ref
        .read(onlyIncludePinnedSourceStateProvider.notifier)
        .set(result.pinnedOnly);
    setState(() {
      _scopeIds = result.ids;
      _readSources();
      _searchVersion++;
      _nothingToShow.clear();
    });
  }

  /// Sources that finished with nothing to show, id to the reason.
  ///
  /// Desktop gathers empty sources into one group; mobile keeps inline status.
  final Map<int, String> _nothingToShow = {};

  @override
  void initState() {
    super.initState();
    _query = widget.search?.trim() ?? '';
    _textEditingController.text = _query;
    _readSources();
  }

  void _submit(String value) {
    FocusScope.of(context).unfocus();
    final query = value.trim();
    _textEditingController.text = query;
    if (_query == query) return;
    setState(() {
      _query = query;
      _searchVersion++;
      _nothingToShow.clear();
    });
  }

  void _clear() {
    _textEditingController.clear();
    _submit('');
  }

  void _reportNothingToShow(Source source, String reason, int version) {
    final id = source.id;
    if (id == null ||
        version != _searchVersion ||
        _nothingToShow[id] == reason) {
      return;
    }
    // Reported from the child's build, so defer the parent rebuild a frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && version == _searchVersion) {
        setState(() => _nothingToShow[id] = reason);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _query;
    final version = _searchVersion;
    final mobile = isMobile && !isTv;
    final results = sourceList.isEmpty
        ? _noSources(context)
        : query.isEmpty
        ? const GlobalSearchPrompt()
        : Column(
            children: [
              for (final source in sourceList)
                SourceSearchScreen(
                  key: ValueKey((version, source.id)),
                  query: query,
                  source: source,
                  fetchGate: _fetchGate,
                  onNothingToShow: (reason) =>
                      _reportNothingToShow(source, reason, version),
                ),
              _nothingToShowGroup(context),
            ],
          );

    if (mobile) {
      return MobileGlobalSearchPage(
        controller: _textEditingController,
        onSubmit: () => _submit(_textEditingController.text),
        onClear: _clear,
        scope: '${sourceList.length} 个来源',
        onScope: _editScope,
        query: query,
        results: results,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          SeachFormTextField(
            onChanged: (value) {},
            onPressed: () {
              Navigator.pop(context);
            },
            onFieldSubmitted: _submit,
            onSuffixPressed: _clear,
            controller: _textEditingController,
          ),
        ],
      ),
      // Keep each source mounted so completed results and scroll position
      // survive opening a title or viewing all matches from one source.
      body: SingleChildScrollView(
        padding: pageBottomInsets(context),
        child: results,
      ),
    );
  }

  /// Why a search over no sources found nothing.
  ///
  /// Three different situations reach here and only one of them is "install
  /// something": the other two are settings that filtered every source out,
  /// and saying "no sources installed" to someone who has ten of them is
  /// worse than saying nothing.
  Widget _noSources(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final pinnedOnly = ref.read(onlyIncludePinnedSourceStateProvider);

    if (isMobile &&
        !isTv &&
        (_scopeIds != null || pinnedOnly) &&
        _installedSources.any(
          (s) => ref.read(showNSFWStateProvider) || s.isNsfw != true,
        )) {
      return MobileGlobalSearchEmpty(
        message: '当前范围没有可搜索的来源',
        hint: '选择参与搜索的来源，或调整仅常用选项。',
        actionLabel: '搜索范围',
        onAction: _editScope,
      );
    }
    final reason = noSourcesReason(
      installed: _installedSources.length,
      pinnedOnly: pinnedOnly,
    );
    final (String message, String hint) = switch (reason) {
      NoSourcesReason.noneInstalled => (
        l10n.global_search_no_sources(widget.itemType.localized(l10n)),
        l10n.global_search_no_sources_hint,
      ),
      NoSourcesReason.nonePinned => (
        l10n.global_search_only_pinned(_installedSources.length),
        l10n.global_search_only_pinned_hint,
      ),
      NoSourcesReason.allNsfw => (
        l10n.global_search_all_nsfw,
        l10n.global_search_all_nsfw_hint,
      ),
    };

    if (isMobile && !isTv) {
      return MobileGlobalSearchEmpty(
        message: message,
        hint: hint,
        actionLabel: reason == NoSourcesReason.noneInstalled
            ? l10n.show_extensions
            : l10n.settings,
        onAction: () => _openEmptyTarget(reason),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.extension_off_outlined,
              size: 44,
              color: context.textColor.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: context.textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEmptyTarget(NoSourcesReason reason) async {
    FocusScope.of(context).unfocus();
    if (reason == NoSourcesReason.noneInstalled) {
      ref
          .read(browseInitialTabProvider.notifier)
          .request(BrowseTab(widget.itemType, BrowseTabKind.extensions));
      context.go('/browse');
      return;
    }
    await Navigator.push(context, createRoute(page: const BrowseSScreen()));
    if (!mounted) return;
    setState(() {
      _readSources();
      _searchVersion++;
      _nothingToShow.clear();
    });
  }

  /// Collapsed group of every source that failed or found nothing.
  ///
  /// Collapsed by default: it is the part of the screen nobody came for. The
  /// reason is kept on each row, since it is the only clue about which
  /// extension is broken.
  Widget _nothingToShowGroup(BuildContext context) {
    if (_nothingToShow.isEmpty) return const SizedBox.shrink();
    final byId = {for (final s in sourceList) s.id: s};
    final theme = Theme.of(context);
    return Theme(
      // Drop the divider lines ExpansionTile draws by default.
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        dense: true,
        shape: const Border(),
        collapsedShape: const Border(),
        leading: Icon(
          Icons.error_outline,
          size: 18,
          color: context.textColor.withValues(alpha: 0.7),
        ),
        title: Text(
          l10nLocalizations(context)!
              .sources_with_no_results(_nothingToShow.length),
          style: TextStyle(
            fontSize: 13,
            color: context.textColor.withValues(alpha: 0.7),
          ),
        ),
        children: [
          for (final entry in _nothingToShow.entries)
            if (byId[entry.key] != null)
              ListTile(
                dense: true,
                onTap: () =>
                    _openSearchSource(context, byId[entry.key]!, _query),
                title: Text(
                  byId[entry.key]!.name!,
                  style: const TextStyle(fontSize: 13),
                ),
                subtitle: Text(
                  entry.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: context.textColor.withValues(alpha: 0.7),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_sharp, size: 18),
              ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

class SourceSearchScreen extends ConsumerStatefulWidget {
  final String query;

  final Source source;

  final FetchGate fetchGate;

  /// Called when this source finishes with nothing to show, with the reason.
  /// The parent gathers these into one collapsed group at the bottom.
  final void Function(String reason)? onNothingToShow;

  const SourceSearchScreen({
    super.key,
    required this.query,
    required this.source,
    required this.fetchGate,
    this.onNothingToShow,
  });

  @override
  ConsumerState<SourceSearchScreen> createState() => _SourceSearchScreenState();
}

class _SourceSearchScreenState extends ConsumerState<SourceSearchScreen> {
  late final _request = searchProvider(
    source: widget.source,
    page: 1,
    query: widget.query,
    filterList: const [],
  );
  ProviderSubscription<AsyncValue<MPages?>>? _subscription;
  AsyncValue<MPages?> _result = const AsyncLoading();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init({bool refresh = false}) async {
    // Share the page's bounded request queue across sources and retries.
    await widget.fetchGate.acquire();
    try {
      // A queued row can be disposed by a newer query before it gets a slot.
      if (!mounted) return;
      if (refresh) ref.invalidate(_request);
      // Retain the existing provider only while this section is mounted.
      // "View all" watches the same request, including its loaded first page.
      _subscription ??= ref.listenManual(
        _request,
        (_, result) => setState(() => _result = result),
        fireImmediately: true,
      );
      await ref.read(_request.future);
    } catch (_) {
      // The provider subscription delivers both results and errors to the UI.
    } finally {
      widget.fetchGate.release();
    }
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final pages = _result.value;
    final isLoading = _result.isLoading;
    final errorMessage = _result.error?.toString() ?? '';

    final hasResults =
        errorMessage.isEmpty && (pages?.list.isNotEmpty ?? false);
    final collapsed = !isLoading && !hasResults;

    // Preserve the desktop summary; mobile shows retry on each source.
    if (collapsed && !(isMobile && !isTv)) {
      widget.onNothingToShow?.call(
        errorMessage.isNotEmpty
            ? "${l10n.failed} ${errorMessage.replaceAll(RegExp(r'\s+'), ' ').trim()}"
            : l10n.no_result,
      );
      return const SizedBox.shrink();
    }

    if (isMobile && !isTv) {
      return MobileGlobalSourceSection(
        title: widget.source.name ?? '',
        language:
            '${completeLanguageName(widget.source.lang ?? '')}${hasResults ? ' · ${pages!.list.length} 个结果' : ''}',
        onOpen: () => _openSearchSource(context, widget.source, widget.query),
        loading: isLoading,
        status: collapsed
            ? Row(
                children: [
                  Expanded(
                    child: Text(
                      errorMessage.isEmpty ? l10n.no_result : '暂时无法连接',
                      style: NodeLaneTokens.of(context).readerSecondary,
                    ),
                  ),
                  if (isBrowserUrl(widget.source.baseUrl))
                    TextButton.icon(
                      label: const Text('网站'),
                      icon: Icon(NodeLaneIcons.of(context).browser, size: 20),
                      onPressed: () => context.push(
                        '/mangawebview',
                        extra: {
                          'url': widget.source.baseUrl!,
                          'title': widget.source.name ?? '',
                        },
                      ),
                    ),
                  if (errorMessage.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        if (_result.isLoading) return;
                        setState(() => _result = const AsyncLoading());
                        _init(refresh: true);
                      },
                      child: Text(l10n.retry),
                    ),
                ],
              )
            : null,
        count: pages?.list.length ?? 0,
        itemBuilder: (context, index) => MangaGlobalImageCard(
          key: ValueKey((pages!.list[index].link, index)),
          manga: pages.list[index],
          source: widget.source,
        ),
      );
    }

    final header = ListTile(
      dense: true,
      onTap: () => _openSearchSource(context, widget.source, widget.query),
      title: Text(widget.source.name!),
      subtitle: Text(
        completeLanguageName(widget.source.lang!),
        style: const TextStyle(fontSize: 10),
      ),
      trailing: const Icon(Icons.arrow_forward_sharp),
    );

    return SizedBox(
      height: 340,
      child: ClipRect(
        child: Column(
          children: [
            header,
            // Desktop failures and empty results are grouped by the parent.
            Flexible(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SuperListView.builder(
                      extentPrecalculationPolicy: SuperPrecalculationPolicy(),
                      scrollDirection: Axis.horizontal,
                      padding: isTv
                          ? const EdgeInsets.symmetric(horizontal: 8)
                          : null,
                      itemCount: pages!.list.length,
                      itemBuilder: (context, index) {
                        return MangaGlobalImageCard(
                          manga: pages.list[index],
                          source: widget.source,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class MangaGlobalImageCard extends ConsumerStatefulWidget {
  final MManga manga;
  final Source source;

  const MangaGlobalImageCard({
    super.key,
    required this.manga,
    required this.source,
  });

  @override
  ConsumerState<MangaGlobalImageCard> createState() =>
      _MangaGlobalImageCardState();
}

const _cardWidth = 150.0;
const _cardHeight = 220.0;

class _MangaGlobalImageCardState extends ConsumerState<MangaGlobalImageCard>
    with AutomaticKeepAliveClientMixin<MangaGlobalImageCard> {
  bool _focused = false;
  late Stream<List<Manga>> _favorites = _watchFavorites();

  Stream<List<Manga>> _watchFavorites() =>
      mangaRepository.watchFavoritesByItemTypeAndName(
        widget.source.itemType,
        widget.manga.name,
      );

  @override
  void didUpdateWidget(covariant MangaGlobalImageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source.itemType != widget.source.itemType ||
        oldWidget.manga.name != widget.manga.name) {
      _favorites = _watchFavorites();
    }
  }

  Manga? _matchedFavorite(List<Manga> favorites) {
    final sameSource = favorites.where(
      (m) => m.lang == widget.source.lang && m.source == widget.source.name,
    );
    return sameSource.isNotEmpty
        ? sameSource.first
        : (favorites.isNotEmpty ? favorites.first : null);
  }

  Widget _mobileCover(Manga? matched, double width) {
    final colors = NodeLaneTokens.of(context);
    final placeholder = Icon(
      Icons.auto_stories_outlined,
      size: 36,
      color: colors.muted,
    );
    final bytes = matched?.customCoverImage;
    final rawUrl = matched == null
        ? widget.manga.imageUrl ?? ''
        : matched.customCoverFromTracker ?? matched.imageUrl ?? '';
    if (bytes == null && rawUrl.trim().isEmpty) return placeholder;
    final ImageProvider image;
    try {
      image = bytes != null
          ? ResizeImage.resizeIfNeeded(
              (width * MediaQuery.devicePixelRatioOf(context)).round(),
              null,
              MemoryImage(bytes as Uint8List),
            )
          : coverProvider(
              toImgUrl(rawUrl),
              headers: ref.watch(
                headersProvider(
                  source: widget.source.name!,
                  lang: widget.source.lang!,
                  sourceId: widget.source.id,
                ),
              ),
            );
    } catch (_) {
      // A source's header parser can fail before image loading even starts.
      // Keep the candidate's title and actions available with a placeholder.
      return placeholder;
    }
    return Image(
      image: image,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
    );
  }

  void _open() {
    pushToMangaReaderDetail(
      ref: ref,
      context: context,
      getManga: widget.manga,
      lang: widget.source.lang!,
      itemType: widget.source.itemType,
      useMaterialRoute: true,
      source: widget.source.name!,
      sourceId: widget.source.id,
    );
  }

  // Matches the long-press-to-favorite convention already used by
  // MangaImageCardListTileWidget: a direct add, no duplicate-across-sources
  // check. That check belongs to the deliberate "Add to library" button on
  // the detail page; a long-press here is a quick action and should stay one.
  void _quickAddToLibrary() {
    pushToMangaReaderDetail(
      ref: ref,
      context: context,
      getManga: widget.manga,
      lang: widget.source.lang!,
      itemType: widget.source.itemType,
      source: widget.source.name!,
      sourceId: widget.source.id,
      addToFavourite: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final getMangaDetail = widget.manga;
    if (isMobile && !isTv) {
      return LayoutBuilder(
        builder: (context, constraints) => StreamBuilder(
          stream: _favorites,
          builder: (context, snapshot) {
            final matched = _matchedFavorite(snapshot.data ?? const <Manga>[]);
            return MobileGlobalResultCard(
              title: widget.manga.name ?? '',
              cover: _mobileCover(matched, constraints.maxWidth),
              inLibrary: matched?.favorite == true,
              onOpen: _open,
              onQuickAdd: _quickAddToLibrary,
            );
          },
        ),
      );
    }
    // A bare GestureDetector never takes focus, so on a remote these covers
    // were unreachable: the only focusable things on the screen were the source
    // headers, and the d-pad could never get down into the results. Focus also
    // scrolls the card into view, and ensureVisible walks every enclosing
    // scrollable, so it moves the horizontal strip and the source list both.
    return Focus(
      onFocusChange: (f) {
        setState(() => _focused = f);
        if (f && context.mounted && Scrollable.maybeOf(context) != null) {
          Scrollable.ensureVisible(
            context,
            alignment: 0.5,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && tvIsSelectKey(event.logicalKey)) {
          _open();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      // The padding sits outside the scale deliberately: it is the room the
      // focused cover grows into. Inside, it would scale along with the card
      // and buy nothing, which is why the block had to be stretched before.
      child: Padding(
        padding: isTv
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 8)
            : const EdgeInsets.only(left: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOut,
          // Matches the library cover: accent ring plus a slight lift.
          transform: Matrix4.identity()
            ..scaleByDouble(
              _focused ? 1.06 : 1.0,
              _focused ? 1.06 : 1.0,
              _focused ? 1.06 : 1.0,
              1,
            ),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _focused ? context.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: GestureDetector(
            onTap: _open,
            onLongPress: _quickAddToLibrary,
            child: StreamBuilder(
              stream: _favorites,
              builder: (context, snapshot) {
                final favorites = snapshot.data ?? const <Manga>[];
                final matched = _matchedFavorite(favorites);
                final hasData = matched != null;
                return Stack(
                  children: [
                    SizedBox(
                      width: _cardWidth,
                      child: Column(
                        children: [
                          Builder(
                            builder: (context) {
                              if (hasData && matched.customCoverImage != null) {
                                return Image.memory(
                                  matched.customCoverImage as Uint8List,
                                );
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: cachedNetworkImage(
                                  headers: ref.watch(
                                    headersProvider(
                                      source: widget.source.name!,
                                      lang: widget.source.lang!,
                                      sourceId: widget.source.id,
                                    ),
                                  ),
                                  imageUrl: toImgUrl(
                                    hasData
                                        ? matched.customCoverFromTracker ??
                                              matched.imageUrl ??
                                              ""
                                        : getMangaDetail.imageUrl ?? "",
                                  ),
                                  width: _cardWidth,
                                  height: _cardHeight,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                          BottomTextWidget(
                            fontSize: 12.0,
                            text: widget.manga.name!,
                            isLoading: true,
                            textColor: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color,
                            isComfortableGrid: true,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _cardWidth,
                      height: _cardHeight,
                      color: hasData && matched.favorite!
                          ? Colors.black.withValues(alpha: 0.7)
                          : null,
                    ),
                    if (hasData && matched.favorite!)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.collections_bookmark,
                            color: context.primaryColor,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => !(isMobile && !isTv);
}

void _openSearchSource(BuildContext context, Source source, String query) {
  Navigator.push(
    context,
    createRoute(
      page: MangaHomeScreen(query: query, source: source),
    ),
  );
}

/// Why a global search has nothing to search.
///
/// Only one of these means "install something". The other two are settings
/// that filtered every source out, and telling someone with ten sources that
/// they have none is worse than saying nothing at all.
enum NoSourcesReason {
  /// Nothing installed for this item type. The novel library on a device that
  /// only ever installed manga extensions, for instance.
  noneInstalled,

  /// Sources exist, but "Only include pinned sources" is on and none of them
  /// are pinned.
  nonePinned,

  /// Sources exist and are not excluded by the pinned setting, so the NSFW
  /// filter is what removed them.
  allNsfw,
}

/// Decides which of the three it is.
///
/// Called only once the searchable list is already known to be empty, so
/// something removed every source and this works out what.
NoSourcesReason noSourcesReason({
  required int installed,
  required bool pinnedOnly,
}) {
  if (installed == 0) return NoSourcesReason.noneInstalled;
  if (pinnedOnly) return NoSourcesReason.nonePinned;
  return NoSourcesReason.allNsfw;
}
