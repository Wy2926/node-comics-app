import 'dart:async';
import 'dart:math' as math;

import 'package:mangayomi/modules/browse/widgets/source_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/manga/home/widget/mobile_source_actions.dart';
import 'package:mangayomi/modules/manga/home/widget/mobile_source_catalog.dart';
import 'package:mangayomi/modules/manga/home/widget/mobile_source_filters.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_text_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/manga/home/providers/state_provider.dart';
import 'package:mangayomi/modules/manga/home/widget/filter_widget.dart';
import 'package:mangayomi/modules/widgets/listview_widget.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_filter_list.dart';
import 'package:mangayomi/services/get_latest_updates.dart';
import 'package:mangayomi/services/get_popular.dart';
import 'package:mangayomi/services/get_source_baseurl.dart';
import 'package:mangayomi/modules/manga/home/providers/saved_searches_provider.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/services/supports_latest.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/home/widget/mangas_card_selector.dart';
import 'package:mangayomi/modules/widgets/cover_grid_skeleton.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:marquee/marquee.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/modules/widgets/tv_menu.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class MangaHomeScreen extends ConsumerStatefulWidget {
  final Source source;
  final bool isSearch;
  final bool isLatest;
  final String query;
  const MangaHomeScreen({
    required this.source,
    this.query = "",
    this.isSearch = false,
    this.isLatest = false,
    super.key,
  });

  @override
  ConsumerState<MangaHomeScreen> createState() => _MangaHomeScreenState();
}

class TypeMangaSelector {
  final IconData icon;
  final String title;
  TypeMangaSelector(this.icon, this.title);
}

class _MangaHomeScreenState extends ConsumerState<MangaHomeScreen> {
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  int _fullDataLength = 50;
  int _page = 1;
  bool _hasNextPage = true;
  int _requestVersion = 0;
  MPages? _firstPage;
  bool _receivedFirstPage = false;
  Object? _pageError;
  bool get _usesSearch => _query.isNotEmpty || _isFiltering;
  bool get _hasMore => source.isFullData == true
      ? _fullDataLength < _mangaList.length
      : _hasNextPage;
  int get _visibleCount => source.isFullData == true
      ? math.min(_fullDataLength, _mangaList.length)
      : _mangaList.length;
  late int _selectedIndex = widget.isLatest
      ? 1
      : widget.isSearch
      ? 2
      : 0;
  late Source source = widget.source;
  late bool isLocal = source.name == "local" && source.lang == "";
  late List<dynamic> filters = isLocal ? [] : getFilterList(source: source);
  final List<MManga> _mangaList = [];
  late StreamSubscription<List<Manga>> _mangaStreamSub;
  Map<String, Manga> _libraryIndex = {};
  List<TypeMangaSelector> _types(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return [
      TypeMangaSelector(Icons.favorite, l10n.popular),
      TypeMangaSelector(Icons.new_releases_outlined, l10n.latest),
      TypeMangaSelector(Icons.filter_list_outlined, l10n.filter),
    ];
  }

  void _resetResults() {
    _requestVersion++;
    _page = 1;
    _hasNextPage = true;
    _fullDataLength = 50;
    _isLoading = false;
    _pageError = null;
    _firstPage = null;
    _receivedFirstPage = false;
    _mangaList.clear();
    final version = _requestVersion;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          version == _requestVersion &&
          _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _submit(String value) {
    final query = value.trim();
    FocusScope.of(context).unfocus();
    if (query == _query && (_usesSearch || _selectedIndex == 0)) return;
    setState(() {
      _query = query;
      _isSearch = true;
      _selectedIndex = _usesSearch ? 2 : 0;
      _resetResults();
    });
  }

  void _clearSearch() {
    _textEditingController.clear();
    _submit('');
  }

  void _select(int index) {
    FocusScope.of(context).unfocus();
    _textEditingController.clear();
    if (_selectedIndex == index && !_usesSearch) return;
    setState(() {
      _selectedIndex = index;
      _isSearch = false;
      _isFiltering = false;
      _query = '';
      filters = copySourceFilters(filterList);
      _resetResults();
    });
  }

  void _invalidatePage(int page) {
    if (_usesSearch) {
      ref.invalidate(
        searchProvider(
          source: source,
          query: _query,
          page: page,
          filterList: filters,
        ),
      );
    } else if (_selectedIndex == 1) {
      ref.invalidate(getLatestUpdatesProvider(source: source, page: page));
    } else {
      ref.invalidate(getPopularProvider(source: source, page: page));
    }
  }

  void _refresh() {
    setState(_resetResults);
    _invalidatePage(1);
  }

  Future<void> _loadMore() async {
    if (!_receivedFirstPage ||
        !_hasMore ||
        _isLoading ||
        (_getManga?.isLoading ?? true)) {
      return;
    }
    if (source.isFullData == true) {
      setState(
        () =>
            _fullDataLength = math.min(_fullDataLength + 50, _mangaList.length),
      );
      return;
    }
    final version = _requestVersion;
    final nextPage = _page + 1;
    if (_pageError != null) _invalidatePage(nextPage);
    setState(() {
      _isLoading = true;
      _pageError = null;
    });
    try {
      final MPages? result;
      if (_usesSearch) {
        result = await ref.read(
          searchProvider(
            source: source,
            query: _query,
            page: nextPage,
            filterList: filters,
          ).future,
        );
      } else if (_selectedIndex == 1) {
        result = await ref.read(
          getLatestUpdatesProvider(source: source, page: nextPage).future,
        );
      } else {
        result = await ref.read(
          getPopularProvider(source: source, page: nextPage).future,
        );
      }
      if (!mounted || version != _requestVersion) return;
      setState(() {
        _mangaList.addAll(result?.list ?? []);
        _page = nextPage;
        _hasNextPage = result?.hasNextPage ?? false;
      });
    } catch (error) {
      if (mounted && version == _requestVersion) {
        setState(() => _pageError = error);
      }
    } finally {
      if (mounted && version == _requestVersion) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _mangaStreamSub = mangaRepository
        .watchBySourceAndLang(source.name, source.lang)
        .listen((mangas) {
          if (mounted) {
            setState(() {
              _libraryIndex = {};
              for (final m in mangas.where(
                (e) => e.sourceId == null || e.sourceId == source.id,
              )) {
                if (m.name == null) continue;
                final existing = _libraryIndex[m.name!];
                // Prefer the record with the lower id (first inserted = real entry).
                // Guards against pre-existing duplicate records in the DB.
                if (existing == null || m.id! < existing.id!) {
                  _libraryIndex[m.name!] = m;
                }
              }
            });
          }
        });
  }

  @override
  void dispose() {
    _mangaStreamSub.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _textEditingController.dispose();
    _searchFieldFocus.dispose();
    _postSearchFocus.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 240 &&
        _mangaList.isNotEmpty &&
        _pageError == null) {
      _loadMore();
    }
  }

  Future<void> _promptSaveSearch() async {
    final query = _query.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.enter_search_to_save_first)),
      );
      return;
    }
    final name = isMobile && !isTv
        ? await showSourceTextEditor(
            context,
            title: context.l10n.save_search,
            subtitle: source.name,
            initialValue: query,
            allowEmpty: false,
          )
        : await showDialog<String>(
            context: context,
            builder: (_) => MobileSettingsTextDialog(
              title: context.l10n.save_search,
              initialValue: query,
              hint: context.l10n.name,
              isValid: (value) => value.trim().isNotEmpty,
            ),
          );
    if (name != null && mounted) {
      ref.read(savedSearchesProvider.notifier).add(source.id!, name, query);
    }
  }

  Future<void> _showSavedSearches() async {
    if (isMobile && !isTv) {
      final query = await showNodeLaneCatalogSheet<String>(
        context,
        MobileSavedSearches(sourceId: source.id!, title: source.name ?? ''),
      );
      if (query != null && mounted) _runSavedSearch(query);
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) {
          final saved =
              ref.watch(savedSearchesProvider)[source.id] ??
              const <SavedSearch>[];
          if (saved.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                context.l10n.no_saved_searches,
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView(
            shrinkWrap: true,
            children: [
              for (final s in saved)
                ListTile(
                  leading: const Icon(Icons.bookmark_outline),
                  title: Text(s.name),
                  subtitle: Text(
                    s.query,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ref
                        .read(savedSearchesProvider.notifier)
                        .remove(source.id!, s.name),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _runSavedSearch(s.query);
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  void _runSavedSearch(String query) {
    _textEditingController.text = query;
    _submit(query);
  }

  late final _textEditingController = TextEditingController(text: widget.query);
  // TV search focus flow: opening search puts focus on the field; submitting
  // hands focus to the next button in the row, so it never reverts to Popular /
  // Latest (which, on revert, would re-select and close the search field).
  final _searchFieldFocus = FocusNode();
  final _postSearchFocus = FocusNode();
  late String _query = widget.query;
  late bool _isSearch = widget.isSearch;
  AsyncValue<MPages?>? _getManga;
  int _length = 0;
  bool _isFiltering = false;
  late final supportsLatest = isLocal
      ? true
      : ref.watch(supportsLatestProvider(source: source));
  late final filterList = isLocal ? [] : getFilterList(source: source);
  Future<void> _onSourceOverflow(int value) async {
    if (value == 0) {
      final baseUrl = ref.read(sourceBaseUrlProvider(source: source));
      final data = {
        'url': baseUrl,
        'sourceId': source.id.toString(),
        'title': '',
        'hasCloudFlare': source.hasCloudflare ?? false,
      };
      if (mounted) context.push("/mangawebview", extra: data);
    } else {
      final res = await context.push('/extension_detail', extra: source);
      if (res != null && mounted) setState(() => source = res as Source);
    }
  }

  Future<void> _mobileOptions(DisplayType display) async {
    final choice = await showNodeLaneCatalogSheet<Object>(
      context,
      MobileSourceActions(
        title: source.name ?? '',
        host: isLocal ? null : Uri.tryParse(source.baseUrl ?? '')?.host,
        display: display,
        canSave: _query.trim().isNotEmpty,
        local: isLocal,
      ),
    );
    if (choice == null || !mounted) return;
    if (choice is DisplayType) {
      if (choice != display) {
        ref
            .read(mangaHomeDisplayTypeStateProvider.notifier)
            .setMangaHomeDisplayType(choice);
      }
      return;
    }
    switch (choice) {
      case SourceCatalogAction.save:
        await _promptSaveSearch();
      case SourceCatalogAction.saved:
        await _showSavedSearches();
      case SourceCatalogAction.browser:
        await _onSourceOverflow(0);
      case SourceCatalogAction.settings:
        await _onSourceOverflow(1);
    }
  }

  Future<void> _mobileFilters() async {
    FocusScope.of(context).unfocus();
    final selected = await showNodeLaneCatalogSheet<List<dynamic>>(
      context,
      MobileSourceFilterSheet(
        filters: filters,
        defaults: () => getFilterList(source: source),
        sourceName: source.name,
      ),
    );
    if (selected == null || !mounted) return;
    setState(() {
      filters = selected;
      _selectedIndex = 2;
      _isFiltering = true;
      _resetResults();
    });
    _invalidatePage(1);
  }

  Widget _buildMobile(DisplayType display) {
    final l10n = context.l10n;
    final loading = _getManga!.isLoading;
    final error = loading ? null : _getManga!.error;
    final count = loading || error != null ? 0 : _visibleCount;
    return MobileSourceCatalog(
      title: isLocal
          ? '${l10n.local_source} ${source.itemType.localized(l10n)}'
          : source.name ?? '',
      search: _textEditingController,
      onSubmit: () => _submit(_textEditingController.text),
      onClear: _clearSearch,
      selected: _usesSearch ? 2 : _selectedIndex,
      supportsLatest: supportsLatest,
      filtering: _isFiltering,
      onSelect: _select,
      onFilter: filterList.isEmpty ? null : _mobileFilters,
      onOptions: () => _mobileOptions(display),
      onSavedSearches: _showSavedSearches,
      results: MobileSourceResults(
        controller: _scrollController,
        display: display,
        gridSize: ref.watch(
          libraryGridSizeStateProvider(itemType: source.itemType),
        ),
        count: count,
        status: _query.isNotEmpty
            ? l10n.global_search_results_for(_query)
            : _isFiltering
            ? l10n.filter
            : _selectedIndex == 1
            ? '最新作品'
            : '热门作品',
        notes: source.notes,
        itemBuilder: (context, index) => display == DisplayType.list
            ? MangaHomeImageCardListTile(
                itemType: source.itemType,
                manga: _mangaList[index],
                source: source,
                libraryManga: _libraryIndex[_mangaList[index].name],
              )
            : MangaHomeImageCard(
                itemType: source.itemType,
                manga: _mangaList[index],
                source: source,
                isComfortableGrid: display == DisplayType.comfortableGrid,
                libraryManga: _libraryIndex[_mangaList[index].name],
              ),
        footer: MobileSourceStatus(
          loading: loading || _isLoading,
          message:
              error?.toString() ??
              _pageError?.toString() ??
              (!loading && count == 0 ? l10n.no_result : null),
          onRetry: error != null
              ? _refresh
              : _pageError != null
              ? _loadMore
              : null,
          onBrowser: error != null && !isLocal
              ? () => _onSourceOverflow(0)
              : null,
          onLoadMore:
              !loading && error == null && _pageError == null && _hasMore
              ? _loadMore
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_usesSearch) {
      _getManga = ref.watch(
        searchProvider(
          source: source,
          query: _query,
          page: 1,
          filterList: filters,
        ),
      );
    } else if (_selectedIndex == 1) {
      _getManga = ref.watch(getLatestUpdatesProvider(source: source, page: 1));
    } else {
      _getManga = ref.watch(getPopularProvider(source: source, page: 1));
    }
    if (!_getManga!.isLoading &&
        _getManga!.hasValue &&
        !_getManga!.hasError &&
        (!_receivedFirstPage || !identical(_firstPage, _getManga!.value))) {
      if (_receivedFirstPage) _requestVersion++;
      _fullDataLength = 50;
      _firstPage = _getManga!.value;
      _receivedFirstPage = true;
      _mangaList
        ..clear()
        ..addAll(_firstPage?.list ?? []);
      _page = 1;
      _hasNextPage = _firstPage?.hasNextPage ?? false;
      _isLoading = false;
      _pageError = null;
    }
    final l10n = context.l10n;
    final displayType = ref.watch(mangaHomeDisplayTypeStateProvider);
    if (isMobile && !isTv) return _buildMobile(displayType);
    final displayTypeIcon = switch (displayType) {
      DisplayType.comfortableGrid ||
      DisplayType.compactGrid => Icons.view_module,
      _ => Icons.view_list,
    };
    return Scaffold(
      appBar: AppBar(
        title: _isSearch
            ? null
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    !isLocal
                        ? "${source.name}"
                        : "${context.l10n.local_source} ${source.itemType.localized(context.l10n)}",
                  ),
                  source.notes != null && source.notes!.isNotEmpty
                      ? SizedBox(
                          height: 20,
                          child: Marquee(
                            text: l10n.extension_notes(source.notes!),
                            style: const TextStyle(fontSize: 12),
                            blankSpace: 40.0,
                            velocity: 30.0,
                            pauseAfterRound: const Duration(seconds: 1),
                            startPadding: 10.0,
                          ),
                        )
                      : Container(),
                ],
              ),
        leading: !_isSearch ? null : Container(),
        actions: [
          _isSearch
              ? SeachFormTextField(
                  onFieldSubmitted: (submit) {
                    _submit(submit);
                    // Hand focus to the next button in the row so it never
                    // reverts to Popular / Latest.
                    if (isTv) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) _postSearchFocus.requestFocus();
                      });
                    }
                  },
                  onChanged: (value) {},
                  onSuffixPressed: _clearSearch,
                  onPressed: () {
                    if (_textEditingController.text.isEmpty) {
                      _select(0);
                      setState(() => _isSearch = false);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  controller: _textEditingController,
                  focusNode: _searchFieldFocus,
                )
              : IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    setState(() {
                      _isSearch = true;
                    });
                    // Force focus onto the field so it doesn't revert to the
                    // previously focused pill while the search button unmounts.
                    if (isTv) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) _searchFieldFocus.requestFocus();
                      });
                    }
                  },
                  focusColor: isTv
                      ? context.primaryColor.withValues(alpha: 0.4)
                      : null,
                  icon: Icon(Icons.search, color: Theme.of(context).hintColor),
                ),
          if (isTv)
            IconButton(
              focusNode: _postSearchFocus,
              focusColor: context.primaryColor.withValues(alpha: 0.4),
              icon: Icon(displayTypeIcon),
              onPressed: () async {
                const order = [
                  DisplayType.comfortableGrid,
                  DisplayType.compactGrid,
                  DisplayType.list,
                ];
                final current = ref.read(mangaHomeDisplayTypeStateProvider);
                final picked = await showTvMenu(
                  context,
                  title: context.l10n.display_mode,
                  options: [
                    TvMenuOption(
                      context.l10n.comfortable_grid,
                      selected: current == DisplayType.comfortableGrid,
                    ),
                    TvMenuOption(
                      context.l10n.compact_grid,
                      selected: current == DisplayType.compactGrid,
                    ),
                    TvMenuOption(
                      context.l10n.list,
                      selected: current == DisplayType.list,
                    ),
                  ],
                );
                if (picked != null) {
                  ref
                      .read(mangaHomeDisplayTypeStateProvider.notifier)
                      .setMangaHomeDisplayType(order[picked]);
                }
              },
            )
          else
            PopupMenuButton(
              popUpAnimationStyle: popupAnimationStyle,
              icon: Icon(displayTypeIcon),
              itemBuilder: (context) {
                final displayType = ref.watch(
                  mangaHomeDisplayTypeStateProvider,
                );
                final displayTypeNotifier = ref.read(
                  mangaHomeDisplayTypeStateProvider.notifier,
                );
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: RadioGroup(
                      groupValue: displayType,
                      onChanged: (a) {
                        context.pop();
                        displayTypeNotifier.setMangaHomeDisplayType(a!);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile(
                            title: Text(context.l10n.comfortable_grid),
                            value: DisplayType.comfortableGrid,
                          ),
                          RadioListTile(
                            title: Text(context.l10n.compact_grid),
                            value: DisplayType.compactGrid,
                          ),
                          RadioListTile(
                            title: Text(context.l10n.list),
                            value: DisplayType.list,
                          ),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text(context.l10n.save_search),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Text(context.l10n.saved_searches),
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 0) {
                  final baseUrl = ref.watch(
                    sourceBaseUrlProvider(source: source),
                  );
                  Map<String, dynamic> data = {
                    'url': baseUrl,
                    'sourceId': source.id.toString(),
                    'title': '',
                  };
                  context.push("/mangawebview", extra: data);
                } else if (value == 1) {
                  final res = await context.push(
                    '/extension_detail',
                    extra: source,
                  );
                  if (res != null && mounted) {
                    setState(() {
                      source = res as Source;
                    });
                  }
                } else if (value == 2) {
                  _promptSaveSearch();
                } else if (value == 3) {
                  _showSavedSearches();
                }
              },
            ),
          if (!isLocal)
            if (isTv)
              IconButton(
                focusColor: context.primaryColor.withValues(alpha: 0.4),
                icon: const Icon(Icons.more_vert),
                onPressed: () async {
                  final picked = await showTvMenu(
                    context,
                    title: source.name ?? '',
                    options: [
                      TvMenuOption(context.l10n.open_in_browser),
                      TvMenuOption(context.l10n.settings),
                    ],
                  );
                  if (picked != null && mounted) _onSourceOverflow(picked);
                },
              )
            else
              PopupMenuButton(
                popUpAnimationStyle: popupAnimationStyle,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text(context.l10n.open_in_browser),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text(context.l10n.settings),
                    ),
                  ];
                },
                onSelected: _onSourceOverflow,
              ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height * 0.8),
          child: Column(
            children: [
              SizedBox(
                width: context.width(1),
                height: 45,
                child: SuperListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    if (filterList.isEmpty && index == 2) {
                      return const SizedBox.shrink();
                    }
                    if (!supportsLatest && index == 1) {
                      return const SizedBox.shrink();
                    }
                    return MangasCardSelector(
                      icon: _types(context)[index].icon,
                      selected: _selectedIndex == index,
                      text: _types(context)[index].title,
                      onPressed: () async {
                        if (filters.isEmpty) {
                          filters = filterList;
                        }
                        if (index == 2) {
                          var draft = copySourceFilters(filters);
                          final result = await showModalBottomSheet(
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                draft = getFilterList(
                                                  source: source,
                                                );
                                              });
                                            },
                                            child: Text(l10n.reset),
                                          ),
                                          const Spacer(),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  context.primaryColor,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context, 'filter');
                                            },
                                            child: Text(
                                              l10n.filter,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    Expanded(
                                      child: FilterWidget(
                                        filterList: draft,
                                        onChanged: (values) {
                                          setState(() {
                                            draft = values;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                          if (result == 'filter') {
                            filters = draft;
                            if (mounted) {
                              setState(() {
                                _selectedIndex = 2;
                                _isFiltering = true;
                                _resetResults();
                              });
                              _invalidatePage(1);
                            }
                          }
                        } else {
                          _select(index);
                        }
                      },
                    );
                  },
                ),
              ),
              Container(
                color: context.primaryColor,
                height: 0.3,
                width: context.width(1),
              ),
            ],
          ),
        ),
      ),
      body: _getManga!.isLoading
          // Fetching a source page is the app's longest routine wait. Lay out
          // the grid the covers will land in rather than a centred spinner;
          // the list mode has no fixed cell shape to stand in for, so it keeps
          // the spinner.
          ? (displayType == DisplayType.list
                ? const ProgressCenter()
                : Consumer(
                    builder: (context, ref, child) => CoverGridSkeleton(
                      gridSize: ref.watch(
                        libraryGridSizeStateProvider(itemType: source.itemType),
                      ),
                      childAspectRatio:
                          displayType == DisplayType.comfortableGrid
                          ? 0.642
                          : 0.69,
                    ),
                  ))
          : _getManga!.when(
              data: (data) {
                Widget buildProgressIndicator() => MobileSourceStatus(
                  loading: _isLoading,
                  message: _pageError?.toString(),
                  onRetry: _pageError == null ? null : _loadMore,
                  onLoadMore: _hasMore && _pageError == null ? _loadMore : null,
                );
                if (_mangaList.isEmpty) {
                  return Center(child: Text(l10n.no_result));
                }
                _length = _visibleCount;
                final isComfortableGrid =
                    displayType == DisplayType.comfortableGrid;
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Flexible(
                        child: displayType == DisplayType.list
                            ? SuperListViewWidget(
                                controller: _scrollController,
                                itemCount: _length + 1,
                                itemBuilder: (context, index) {
                                  if (index == _length) {
                                    return buildProgressIndicator();
                                  }
                                  return MangaHomeImageCardListTile(
                                    itemType: source.itemType,
                                    manga: _mangaList[index],
                                    source: source,
                                    libraryManga:
                                        _libraryIndex[_mangaList[index].name],
                                  );
                                },
                              )
                            : Consumer(
                                builder: (context, ref, child) {
                                  final gridSize = ref.watch(
                                    libraryGridSizeStateProvider(
                                      itemType: source.itemType,
                                    ),
                                  );

                                  return GridViewWidget(
                                    gridSize: gridSize,
                                    controller: _scrollController,
                                    itemCount: _length + 1,
                                    childAspectRatio: isComfortableGrid
                                        ? 0.642
                                        : 0.69,
                                    itemBuilder: (context, index) {
                                      if (index == _length) {
                                        return buildProgressIndicator();
                                      }
                                      return MangaHomeImageCard(
                                        autofocus:
                                            isTv && index == 0 && !_isSearch,
                                        itemType: source.itemType,
                                        manga: _mangaList[index],
                                        source: source,
                                        isComfortableGrid: isComfortableGrid,
                                        libraryManga:
                                            _libraryIndex[_mangaList[index]
                                                .name],
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: _refresh,
                              icon: const Icon(Icons.refresh),
                            ),
                            Text(l10n.refresh),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                final baseUrl = ref.watch(
                                  sourceBaseUrlProvider(source: source),
                                );
                                Map<String, dynamic> data = {
                                  'url': baseUrl,
                                  'sourceId': source.id.toString(),
                                  'title': '',
                                  "hasCloudFlare":
                                      source.hasCloudflare ?? false,
                                };
                                context.push("/mangawebview", extra: data);
                              },
                              icon: Icon(
                                Icons.public,
                                size: 22,
                                color: context.secondaryColor,
                              ),
                            ),
                            Text(context.l10n.webview),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // This screen keeps its own recovery actions above (refresh
                  // with the right provider, and a webview for Cloudflare), so
                  // only the cause is demoted here to match ErrorState.
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.textColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
    );
  }
}

class MangaHomeImageCard extends ConsumerStatefulWidget {
  final MManga manga;
  final ItemType itemType;
  final Source source;
  final bool isComfortableGrid;
  final Manga? libraryManga;
  final bool autofocus;
  const MangaHomeImageCard({
    super.key,
    required this.manga,
    required this.source,
    required this.itemType,
    required this.isComfortableGrid,
    this.libraryManga,
    this.autofocus = false,
  });

  @override
  ConsumerState<MangaHomeImageCard> createState() => _MangaHomeImageCardState();
}

class _MangaHomeImageCardState extends ConsumerState<MangaHomeImageCard> {
  @override
  Widget build(BuildContext context) {
    return MangaImageCardWidget(
      getMangaDetail: widget.manga,
      source: widget.source,
      itemType: widget.itemType,
      isComfortableGrid: widget.isComfortableGrid,
      libraryManga: widget.libraryManga,
      autofocus: widget.autofocus,
    );
  }
}

class MangaHomeImageCardListTile extends ConsumerStatefulWidget {
  final MManga manga;
  final ItemType itemType;
  final Source source;
  final Manga? libraryManga;
  const MangaHomeImageCardListTile({
    super.key,
    required this.manga,
    required this.source,
    required this.itemType,
    this.libraryManga,
  });

  @override
  ConsumerState<MangaHomeImageCardListTile> createState() =>
      _MangaHomeImageCardListTileState();
}

class _MangaHomeImageCardListTileState
    extends ConsumerState<MangaHomeImageCardListTile> {
  @override
  Widget build(BuildContext context) {
    return MangaImageCardListTileWidget(
      getMangaDetail: widget.manga,
      source: widget.source,
      itemType: widget.itemType,
      libraryManga: widget.libraryManga,
    );
  }
}
