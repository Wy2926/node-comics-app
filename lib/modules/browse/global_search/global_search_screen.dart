import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/modules/more/settings/browse/browse_screen.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/global_search_result_card.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/modules/widgets/source_result_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/list_extent_precalculation.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/source_fetch_gate.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import 'mobile_global_search.dart';
import 'search_activity.dart';
import 'source_search_scope.dart';

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

  late List<Source> _installedSources;
  late List<Source> sourceList;
  late SourceSearchScope _scope;
  final _activity = ValueNotifier<Map<int, SourceSearchActivity>>({});

  bool _isVisible(Source source) =>
      ref.read(showNSFWStateProvider) || source.isNsfw != true;

  void _readSources() {
    _installedSources = sourceRepository.getAddedByItemType(widget.itemType);
    sourceList = _installedSources
        .where(_isVisible)
        .where(_scope.includes)
        .toList();
  }

  Future<void> _editScope() async {
    FocusScope.of(context).unfocus();
    final candidates = sourceRepository
        .getAddedByItemType(widget.itemType)
        .where(_isVisible)
        .toList();
    final result = await showNodeLaneCatalogSheet<SourceSearchScope>(
      context,
      SourceSearchScopeSheet(sources: candidates, current: _scope),
    );
    if (!mounted || result == null) return;
    setState(() {
      _scope = result;
      _readSources();
      final ids = sourceList.map((s) => s.id).toSet();
      _activity.value = {
        for (final entry in _activity.value.entries)
          if (ids.contains(entry.key)) entry.key: entry.value,
      };
      // Unchanged source keys retain their request and horizontal position.
    });
  }

  void _showActivity() {
    FocusScope.of(context).unfocus();
    showNodeLaneCatalogSheet<void>(
      context,
      SearchActivitySheet(
        query: _query,
        sources: sourceList,
        activity: _activity,
        onOpen: (source) {
          Navigator.of(context, rootNavigator: true).pop();
          _openSearchSource(context, source, _query);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _query = widget.search?.trim() ?? '';
    _textEditingController.text = _query;
    _scope = SourceSearchScope(
      mode: ref.read(onlyIncludePinnedSourceStateProvider)
          ? SourceSearchScopeMode.pinned
          : SourceSearchScopeMode.all,
    );
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
      _activity.value = {};
    });
  }

  void _reportActivity(
    Source source,
    SourceSearchActivity activity,
    int version,
  ) {
    final id = source.id;
    if (!mounted ||
        id == null ||
        version != _searchVersion ||
        !sourceList.any((s) => s.id == id)) {
      return;
    }
    _activity.value = {..._activity.value, id: activity};
  }

  @override
  Widget build(BuildContext context) {
    final query = _query;
    final version = _searchVersion;
    final results = sourceList.isEmpty
        ? _noSources(context)
        : query.isEmpty
        ? NodeLaneEmptyState(
            icon: NodeLaneIcons.of(context).search,
            title: context.l10n.search_start_title,
            message: context.l10n.search_start_hint,
          )
        : Column(
            children: [
              ValueListenableBuilder(
                valueListenable: _activity,
                builder: (context, activity, _) => SearchActivitySummary(
                  total: sourceList.length,
                  activity: activity,
                  onDetails: _showActivity,
                  onScope: _editScope,
                ),
              ),
              for (final source in sourceList)
                SourceSearchScreen(
                  key: ValueKey((version, source.id)),
                  query: query,
                  source: source,
                  fetchGate: _fetchGate,
                  onActivity: (activity) =>
                      _reportActivity(source, activity, version),
                ),
            ],
          );
    return MobileGlobalSearchPage(
      controller: _textEditingController,
      onSubmit: () => _submit(_textEditingController.text),
      onClear: () => _submit(''),
      scope: '${_scope.mode.label(context.l10n)} · ${sourceList.length}',
      onScope: _editScope,
      onDetails: query.isNotEmpty && sourceList.isNotEmpty
          ? _showActivity
          : null,
      query: query,
      results: results,
    );
  }

  /// Distinguish missing installations from a scope or preference exclusion.
  Widget _noSources(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (_installedSources.any(_isVisible)) {
      return NodeLaneEmptyState(
        icon: NodeLaneIcons.of(context).web,
        title: context.l10n.search_empty_scope,
        message: context.l10n.search_empty_scope_hint,
        action: FilledButton(
          onPressed: _editScope,
          child: Text(context.l10n.search_scope),
        ),
      );
    }
    final noneInstalled = _installedSources.isEmpty;
    return NodeLaneEmptyState(
      icon: NodeLaneIcons.of(context).extensions,
      title: noneInstalled
          ? l10n.global_search_no_sources(widget.itemType.localized(l10n))
          : l10n.global_search_all_nsfw,
      message: noneInstalled
          ? l10n.global_search_no_sources_hint
          : l10n.global_search_all_nsfw_hint,
      action: FilledButton(
        onPressed: () => _openEmptyTarget(install: noneInstalled),
        child: Text(noneInstalled ? l10n.show_extensions : l10n.settings),
      ),
    );
  }

  Future<void> _openEmptyTarget({required bool install}) async {
    FocusScope.of(context).unfocus();
    if (install) {
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
      _activity.value = {};
    });
  }

  @override
  void dispose() {
    _activity.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}

class SourceSearchScreen extends ConsumerStatefulWidget {
  final String query;

  final Source source;

  final FetchGate fetchGate;

  final ValueChanged<SourceSearchActivity>? onActivity;

  const SourceSearchScreen({
    super.key,
    required this.query,
    required this.source,
    required this.fetchGate,
    this.onActivity,
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
        (_, result) => _receive(result),
        fireImmediately: true,
      );
      await ref.read(_request.future);
    } catch (_) {
      // The provider subscription delivers both results and errors to the UI.
    } finally {
      widget.fetchGate.release();
    }
  }

  void _receive(AsyncValue<MPages?> result) {
    if (!mounted) return;
    setState(() => _result = result);
    // A provider can deliver synchronously while the section is mounting.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !identical(_result, result)) return;
      final count = result.value?.list.length ?? 0;
      widget.onActivity?.call(
        SourceSearchActivity(
          result.isLoading
              ? SearchPhase.searching
              : result.hasError
              ? SearchPhase.failed
              : count > 0
              ? SearchPhase.results
              : SearchPhase.empty,
          count: result.isLoading || result.hasError ? 0 : count,
          retry: result.hasError ? _retry : null,
        ),
      );
    });
  }

  void _retry() {
    if (!mounted || _result.isLoading) return;
    _receive(const AsyncLoading());
    unawaited(_init(refresh: true));
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }

  Widget _resultCard(MManga manga, int index) => GlobalSearchResultCard(
    key: ValueKey((manga.link, index)),
    manga: manga,
    source: widget.source,
    matchAnySource: true,
    carousel: !isTv,
    coverSize: const Size(150, 220),
    padding: const EdgeInsets.all(NodeLaneTokens.space8),
    onActivate: () => _openResult(manga),
    onQuickAdd: () => _openResult(manga, quickAdd: true),
  );

  void _openResult(MManga manga, {bool quickAdd = false}) =>
      pushToMangaReaderDetail(
        ref: ref,
        context: context,
        getManga: manga,
        lang: widget.source.lang!,
        itemType: widget.source.itemType,
        useMaterialRoute: !quickAdd,
        source: widget.source.name!,
        sourceId: widget.source.id,
        addToFavourite: quickAdd,
      );

  @override
  Widget build(BuildContext context) {
    final pages = _result.value;
    if (_result.isLoading ||
        _result.hasError ||
        pages == null ||
        pages.list.isEmpty) {
      return const SizedBox.shrink();
    }

    if (!isTv) {
      return SourceResultSection(
        title: widget.source.name ?? '',
        metadata: context.l10n.search_result_count(pages.list.length),
        onOpen: () => _openSearchSource(context, widget.source, widget.query),
        count: pages.list.length,
        itemBuilder: (context, index) => _resultCard(pages.list[index], index),
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
            Flexible(
              child: SuperListView.builder(
                extentPrecalculationPolicy: SmallListPrecalculationPolicy(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: NodeLaneTokens.space8,
                ),
                itemCount: pages.list.length,
                itemBuilder: (context, index) {
                  return _resultCard(pages.list[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _openSearchSource(BuildContext context, Source source, String query) {
  Navigator.push(
    context,
    createRoute(
      page: MangaHomeScreen(query: query, source: source),
    ),
  );
}
