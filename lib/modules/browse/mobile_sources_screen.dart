import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/widgets/source_controls.dart';
import 'package:mangayomi/modules/browse/widgets/source_website_card.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/mobile_media_menu.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

import 'mobile_repository_sheets.dart';

class MobileSourcesScreen extends ConsumerStatefulWidget {
  const MobileSourcesScreen({super.key});
  @override
  ConsumerState<MobileSourcesScreen> createState() =>
      _MobileSourcesScreenState();
}

class _MobileSourcesScreenState extends ConsumerState<MobileSourcesScreen> {
  final query = TextEditingController();
  ItemType type = ItemType.manga;
  bool thirdParty = false, managing = false;
  final selected = <int>{};
  bool _bulkBusy = false;
  bool get selecting => thirdParty && ref.read(isLongPressedStateProvider);
  final busy = <int>{};
  final failedActions = <int, ({bool open, bool latest})>{};
  final languages = <(ItemType, bool), Set<String>>{};
  bool _refreshing = false;
  NodeLaneNoticeHandle? _notice;
  @override
  void initState() {
    super.initState();
    final requested = ref.read(browseInitialTabProvider);
    if (requested != null) {
      type = requested.type;
      thirdParty = requested.kind == BrowseTabKind.extensions;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            identical(ref.read(browseInitialTabProvider), requested)) {
          ref.read(browseInitialTabProvider.notifier).clear();
        }
      });
    }
  }

  @override
  void dispose() {
    _notice?.dismiss();
    query.dispose();
    super.dispose();
  }

  Future<void> _languageFilter(List<Source> catalog) async {
    final key = (type, thirdParty);
    final available = catalog.map((s) => s.lang ?? '').toSet().toList()..sort();
    final initial =
        languages[key] ??
        catalog
            .where((s) => s.isActive == true)
            .map((s) => s.lang ?? '')
            .toSet();
    final result = await showSourceMultiChoice<String>(
      context,
      title: '语言筛选',
      subtitle: '仅筛选当前目录，不影响已安装来源',
      current: initial,
      options: [
        for (final language in available)
          SourceOption(
            language,
            language.toLowerCase() == 'all'
                ? '多语言'
                : completeLanguageName(language.toLowerCase()),
          ),
      ],
      allLabel: '全部语言',
      saveLabel: '应用',
      reset: true,
    );
    if (mounted && result != null) setState(() => languages[key] = result);
  }

  Future<void> _fetch(
    Source source, {
    bool open = false,
    bool latest = false,
  }) async {
    if (source.id == null || busy.contains(source.id)) return;
    final requestedThirdParty = thirdParty;
    setState(() {
      busy.add(source.id!);
      failedActions.remove(source.id);
    });
    try {
      final proxy = ref.read(androidProxyServerStateProvider);
      if (source.isAdded == true && source.sourceCode?.isNotEmpty == true) {
        await fetchSourcesList(
          id: source.id,
          androidProxyServer: proxy,
          autoUpdateExtensions: false,
          itemType: source.itemType,
          repo: source.repo,
        );
      } else {
        await installSource(
          source,
          proxy,
          source.repo!,
          source.itemType,
          priority: true,
        );
      }
      final loaded = await sourceRepository.findByIdAsync(source.id!);
      if (loaded == null || loaded.sourceCode?.isNotEmpty != true) {
        throw StateError('加载失败');
      }
      if (mounted &&
          open &&
          type == source.itemType &&
          thirdParty == requestedThirdParty &&
          GoRouter.of(context).routeInformationProvider.value.uri.path ==
              '/browse') {
        _open(loaded, latest: latest);
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => failedActions[source.id!] = (open: open, latest: latest),
        );
      }
      if (mounted &&
          type == source.itemType &&
          thirdParty == requestedThirdParty) {
        _showFailure('网站暂时无法加载，请重试。');
      }
    } finally {
      if (mounted) setState(() => busy.remove(source.id));
    }
  }

  void _showFailure(String message) {
    if (!mounted || ModalRoute.of(context)?.isCurrent == false) return;
    final router = GoRouter.maybeOf(context);
    if (router != null &&
        router.routeInformationProvider.value.uri.path != '/browse') {
      return;
    }
    _notice?.dismiss();
    _notice = showNodeLaneNotice(message, kind: NodeLaneNoticeKind.error);
  }

  Future<void> _refreshCatalog() async {
    if (_refreshing || _bulkBusy) return;
    _refreshing = true;
    final requestedType = type, requestedThirdParty = thirdParty;
    _notice?.dismiss();
    try {
      if (requestedThirdParty) {
        final refresh = ref.refresh(
          fetchItemSourcesListProvider(
            reFresh: true,
            itemType: requestedType,
          ).future,
        );
        await refresh;
      } else if (requestedType == ItemType.manga) {
        await ref.read(nodeLaneCatalogRefreshProvider).refresh(force: true);
        if (mounted) ref.invalidate(nodeLaneCatalogLoadProvider(requestedType));
      }
    } catch (_) {
      if (mounted &&
          type == requestedType &&
          thirdParty == requestedThirdParty) {
        _showFailure('目录刷新失败，已保留当前内容，可下拉重试。');
      }
    } finally {
      _refreshing = false;
    }
  }

  void _open(Source source, {bool latest = false}) {
    sourceRepository.markLastUsed(source.itemType, source.id);
    context.push('/mangaHome', extra: (source, latest));
  }

  void _searchContents() {
    FocusScope.of(context).unfocus();
    context.push('/globalSearch', extra: (query.text.trim(), type));
  }

  Future<void> _pin(Source source, {bool? pinned}) =>
      sourceRepository.writeTransaction(() {
        final current = sourceRepository.getById(source.id!);
        if (current == null) return;
        current.isPinned = pinned ?? !(current.isPinned ?? false);
        current.updatedAt = DateTime.now().millisecondsSinceEpoch;
        sourceRepository.putAllSync([current]);
      });

  void _finishSelection() {
    selected.clear();
    ref.read(isLongPressedStateProvider.notifier).update(false);
  }

  void _startSelection() {
    if (_bulkBusy) return;
    FocusScope.of(context).unfocus();
    selected.clear();
    ref.read(isLongPressedStateProvider.notifier).update(true);
  }

  void _toggleSelection(Source source) {
    if (_bulkBusy || source.id == null || busy.contains(source.id)) return;
    setState(() {
      if (!selected.remove(source.id)) selected.add(source.id!);
    });
    if (selected.isEmpty) _finishSelection();
  }

  Future<void> _applySelection(List<Source> targets, {bool? pinned}) async {
    if (_bulkBusy || targets.isEmpty) return;
    final requestedType = type;
    final official = ref.read(nodeLaneCatalogRepositoryProvider(requestedType));
    if (pinned == null &&
        !await showNodeLaneConfirmation(
          context,
          title: '卸载 ${targets.length} 个来源？',
          message: '将卸载所选的已安装来源并清除其来源设置，保留书架作品和下载。',
          confirmLabel: '卸载',
          destructive: true,
        )) {
      return;
    }
    if (!mounted || !selecting || type != requestedType) {
      return;
    }
    _notice?.dismiss();
    setState(() => _bulkBusy = true);
    var failed = 0;
    try {
      for (final target in targets) {
        if (!mounted) return;
        try {
          final current = sourceRepository.getById(target.id!);
          if (current != null &&
              current.itemType == requestedType &&
              !isNodeLaneCatalogSource(current, official)) {
            if (pinned != null) {
              await _pin(current, pinned: pinned);
            } else if (current.isAdded == true) {
              await sourceRepository.uninstall(ref, current);
            }
          }
          selected.remove(target.id);
          failedActions.remove(target.id);
        } catch (_) {
          failed++;
        }
      }
      if (failed > 0) {
        _showFailure('$failed 个来源操作失败，已保留选择，请重试。');
      } else if (mounted) {
        _finishSelection();
      }
    } finally {
      if (mounted) setState(() => _bulkBusy = false);
    }
  }

  Widget _selectionBar(List<Source> sources) {
    final targets = sources.where((s) => selected.contains(s.id)).toList();
    final installed = targets.where((s) => s.isAdded == true).toList();
    final icons = NodeLaneIcons.of(context);
    return NodeLaneSelectionBar<bool>(
      busy: _bulkBusy,
      moreLabel: context.l10n.more,
      onMore: (pinned) => _applySelection(targets, pinned: pinned),
      actions: [
        NodeLaneToolbarAction(
          label: '设为常用',
          icon: icons.pin,
          enabled: !_bulkBusy && targets.any((s) => s.isPinned != true),
          onPressed: () => _applySelection(targets, pinned: true),
        ),
        NodeLaneToolbarAction(
          label: '卸载',
          icon: icons.delete,
          destructive: true,
          enabled: !_bulkBusy && installed.isNotEmpty,
          onPressed: () => _applySelection(installed),
        ),
      ],
      moreItems: [
        nodeLaneSelectionMenuItem(
          context,
          value: false,
          label: '取消常用',
          icon: icons.pinSelected,
          enabled: targets.any((s) => s.isPinned == true),
        ),
      ],
    );
  }

  void _sourceActions(Source source) {
    showNodeLaneCatalogSheet<void>(
      context,
      NodeLaneCatalogSheet(
        title: source.name ?? '',
        heightFactor: .9,
        fitContent: true,
        child: ListView(
          shrinkWrap: true,
          padding: NodeLaneTokens.pagePadding,
          children: [
            NodeLaneGroupSurface(
              children: [
                NodeLaneRow(
                  title: '来源资料',
                  icon: NodeLaneIcons.of(context).info,
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    showSourceWebsiteInfo(context, source);
                  },
                ),
                NodeLaneRow(
                  title: source.isPinned == true ? '取消常用' : '固定到常用',
                  icon: NodeLaneIcons.of(context).pin,
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    _pin(source);
                  },
                ),
                NodeLaneRow(
                  title: '最新内容',
                  icon: NodeLaneIcons.of(context).latest,
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    if (source.isAdded == true &&
                        source.sourceCode?.isNotEmpty == true) {
                      _open(source, latest: true);
                    } else {
                      _fetch(source, open: true, latest: true);
                    }
                  },
                ),
                if ((source.baseUrl ?? '').isNotEmpty) ...[
                  NodeLaneRow(
                    title: '在浏览器打开',
                    icon: NodeLaneIcons.of(context).navigation,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      context.push(
                        '/mangawebview',
                        extra: {
                          'url': source.baseUrl!,
                          'title': source.name ?? '',
                        },
                      );
                    },
                  ),
                ],
                if (source.isAdded == true) ...[
                  NodeLaneRow(
                    title: '来源设置',
                    icon: NodeLaneIcons.of(context).settings,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      context.push('/extension_detail', extra: source);
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(Source source) {
    final installed =
        source.isAdded == true && source.sourceCode?.isNotEmpty == true;
    final update =
        installed &&
        source.isObsolete != true &&
        compareVersions(source.version ?? '', source.versionLast ?? '') < 0;
    final loading = busy.contains(source.id);
    final failed = failedActions[source.id];
    final action = loading
        ? SourceCardAction.loading
        : managing
        ? source.isPinned == true
              ? SourceCardAction.unpin
              : SourceCardAction.pin
        : failed != null
        ? SourceCardAction.retry
        : thirdParty && !installed
        ? SourceCardAction.install
        : thirdParty && update
        ? SourceCardAction.update
        : SourceCardAction.open;
    void open() {
      if (managing) {
        _pin(source);
      } else if (installed) {
        _open(source);
      } else if (!loading) {
        _fetch(source, open: true);
      }
    }

    final onOpen = selecting
        ? _bulkBusy || loading
              ? null
              : () => _toggleSelection(source)
        : loading && !installed
        ? null
        : open;
    return SourceWebsiteCard(
      key: ValueKey('source-${source.id}'),
      source: source,
      action: action,
      selected: selecting ? selected.contains(source.id) : null,
      onOpen: onOpen,
      onAction: loading
          ? null
          : () {
              switch (action) {
                case SourceCardAction.retry:
                  _fetch(source, open: failed!.open, latest: failed.latest);
                case SourceCardAction.install || SourceCardAction.update:
                  _fetch(source);
                case SourceCardAction.pin || SourceCardAction.unpin:
                  _pin(source);
                default:
                  open();
              }
            },
      onDetails: selecting
          ? null
          : () => showSourceWebsiteInfo(context, source),
      onLongPress: selecting ? onOpen : () => _sourceActions(source),
    );
  }

  Widget _menu(List<Source> catalog) {
    final icons = NodeLaneIcons.of(context);
    return NodeLaneMenuButton<String>(
      tooltip: '来源操作',
      icon: icons.more,
      onSelected: (value) {
        if (value == 'search') _searchContents();
        if (value == 'filter') _languageFilter(catalog);
        if (value == 'update') _updateInstalled();
        if (value == 'manage') {
          _startSelection();
        }
        if (value == 'create') context.push('/createExtension');
        if (value == 'local') {
          _open(Source(name: 'local', lang: '', itemType: type));
        }
      },
      itemBuilder: (_) => [
        for (final (value, title, icon) in [
          ('search', '搜作品', icons.search),
          ('filter', '语言筛选', icons.filter),
          if (thirdParty && catalog.isNotEmpty)
            ('manage', '批量管理', icons.selected),
          if (thirdParty) ('update', '更新已安装来源', icons.refresh),
          if (ref.read(developerModeStateProvider))
            ('create', context.l10n.create_extension, icons.code),
          ('local', context.l10n.local_source, icons.folderOutline),
        ])
          PopupMenuItem(
            value: value,
            padding: EdgeInsets.zero,
            height: NodeLaneTokens.menuItemHeight,
            child: NodeLaneRow(title: title, icon: icon),
          ),
      ],
    );
  }

  Widget _emptyState({required bool loading, required bool searching}) {
    if (loading) return const NodeLaneEmptyState.loading();
    final icons = NodeLaneIcons.of(context);
    return Center(
      child: NodeLaneEmptyState(
        icon: searching ? icons.search : icons.web,
        title: searching ? '没有匹配的网站' : '暂无可用网站',
        message: searching ? '在已安装来源中搜索作品' : null,
        action: NodeLaneSecondaryButton(
          onPressed: searching
              ? _searchContents
              : thirdParty
              ? () => showMobileRepositories(context, type)
              : () => setState(() {
                  thirdParty = true;
                  managing = false;
                  _notice?.dismiss();
                }),
          child: Text(
            searching
                ? '跨来源搜索'
                : thirdParty
                ? '管理仓库'
                : '查看第三方',
          ),
        ),
      ),
    );
  }

  Future<void> _updateInstalled() async {
    final official = ref.read(nodeLaneCatalogRepositoryProvider(type));
    final updates = sourceRepository
        .getInstalledByItemType(type)
        .where(
          (source) =>
              !isNodeLaneCatalogSource(source, official) &&
              source.isObsolete != true &&
              compareVersions(source.version ?? '', source.versionLast ?? '') <
                  0,
        )
        .toList();
    for (final source in updates) {
      if (!mounted) return;
      await _fetch(source);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(isLongPressedStateProvider);
    final hidden = ref.watch(hideItemsStateProvider);
    final types = ItemType.values
        .where(
          (e) => !hidden.contains(switch (e) {
            ItemType.manga => '/MangaLibrary',
            ItemType.anime => '/AnimeLibrary',
            ItemType.novel => '/NovelLibrary',
          }),
        )
        .toList();
    if (types.isEmpty) return const SizedBox.shrink();
    if (!types.contains(type)) type = types.first;
    ref.listen(browseInitialTabProvider, (_, next) {
      if (next == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (selecting) _finishSelection();
        setState(() {
          type = next.type;
          thirdParty = next.kind == BrowseTabKind.extensions;
          managing = false;
        });
        ref.read(browseInitialTabProvider.notifier).clear();
      });
    });
    final official = ref.watch(nodeLaneCatalogRepositoryProvider(type));
    final loading = ref.watch(nodeLaneCatalogLoadProvider(type));
    ref.watch(fetchItemSourcesListProvider(reFresh: false, itemType: type));
    final sources = ref.watch(mobileCatalogEntriesProvider(type));
    ref.listen(nodeLaneCatalogLoadProvider(type), (previous, next) {
      if (!_refreshing &&
          !thirdParty &&
          next.hasError &&
          !identical(previous?.error, next.error)) {
        _showFailure('目录加载失败，可下拉重试。');
      }
    });
    ref.listen(mobileCatalogEntriesProvider(type), (previous, next) {
      if (!_refreshing &&
          next.hasError &&
          !identical(previous?.error, next.error)) {
        _showFailure('目录加载失败，可下拉重试。');
      }
    });
    final repositories = ref.watch(extensionsRepoStateProvider(type));
    final showNsfw = ref.watch(showNSFWStateProvider);
    final catalog = (sources.value ?? <Source>[])
        .where(
          (s) =>
              (showNsfw || s.isNsfw != true) &&
              !repositories.any(
                (r) => r.jsonUrl == s.repo?.jsonUrl && r.hidden == true,
              ) &&
              (thirdParty
                  ? !isNodeLaneCatalogSource(s, official)
                  : isNodeLaneCatalogSource(s, official)),
        )
        .toList();
    final selectedLanguages = languages[(type, thirdParty)];
    final keyword = query.text.trim();
    final all =
        catalog
            .where(
              (s) =>
                  (selectedLanguages == null
                      ? s.isActive == true
                      : selectedLanguages.contains(s.lang ?? '')) &&
                  (s.name ?? '').toLowerCase().contains(keyword.toLowerCase()),
            )
            .toList()
          ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    final groups = <(String, List<Source>)>[
      ('常用', all.where((s) => s.isPinned == true).toList()),
      if (!thirdParty) ('全部网站', all.where((s) => s.isPinned != true).toList()),
      if (thirdParty)
        (
          '已安装',
          all.where((s) => s.isAdded == true && s.isPinned != true).toList(),
        ),
      if (thirdParty)
        (
          '可安装',
          all.where((s) => s.isAdded != true && s.isPinned != true).toList(),
        ),
    ]..removeWhere((group) => group.$2.isEmpty);
    final selectable = all
        .where((s) => s.id != null && !busy.contains(s.id))
        .map((s) => s.id!)
        .toSet();
    selected.retainAll(selectable);
    final page = NodeLaneSurface(
      child: Scaffold(
        bottomNavigationBar: selecting
            ? NodeLaneNoticeAvoidance(child: _selectionBar(all))
            : null,
        appBar: selecting
            ? nodeLaneSelectionAppBar(
                context,
                title: '已选择 ${selected.length} 项',
                cancelLabel: context.l10n.cancel,
                selectAllLabel: context.l10n.bookshelf_select_all,
                invertLabel: context.l10n.bookshelf_invert_selection,
                onCancel: _finishSelection,
                onSelectAll: _bulkBusy || selectable.isEmpty
                    ? null
                    : () => setState(() {
                        selected.addAll(selectable);
                      }),
                onInvert: _bulkBusy || selectable.isEmpty
                    ? null
                    : () => setState(() {
                        final inverted = selectable.difference(selected);
                        selected
                          ..clear()
                          ..addAll(inverted);
                      }),
              )
            : null,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                if (!selecting)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight * .65,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: NodeLaneTokens.headerPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NodeLanePageHeading.toolbar(
                              mediaMenu: MobileMediaMenu(
                                value: type,
                                availableTypes: types,
                                onChanged: (value) {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    type = value;
                                    managing = false;
                                    query.clear();
                                    _notice?.dismiss();
                                  });
                                },
                              ),
                              actions: [_menu(catalog)],
                            ),
                            const SizedBox(height: NodeLaneTokens.space16),
                            SizedBox(
                              width:
                                  NodeLaneTokens.catalogTabsWidth *
                                  (MediaQuery.textScalerOf(context).scale(15) /
                                          15)
                                      .clamp(1, 2),
                              child: NodeLaneSegments<bool>(
                                value: thirdParty,
                                pill: true,
                                segments: const [
                                  ButtonSegment(
                                    value: false,
                                    label: Text('NodeLane'),
                                  ),
                                  ButtonSegment(
                                    value: true,
                                    label: Text('第三方'),
                                  ),
                                ],
                                onChanged: (value) {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    thirdParty = value;
                                    managing = false;
                                    _notice?.dismiss();
                                    query.clear();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: NodeLaneTokens.space16),
                            NodeLaneTextField.search(
                              controller: query,
                              hint: '网站名或作品名',
                              clearLabel: context.l10n.search_clear,
                              onSubmitted: (_) => _searchContents(),
                              onChanged: (_) => setState(() {}),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshCatalog,
                    child: CustomScrollView(
                      key: PageStorageKey('catalog-${type.name}-$thirdParty'),
                      physics: const AlwaysScrollableScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: [
                        if (all.isEmpty)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: pageBottomInsets(context).bottom,
                              ),
                              child: _emptyState(
                                loading:
                                    (!thirdParty && loading.isLoading) ||
                                    sources.isLoading,
                                searching: keyword.isNotEmpty,
                              ),
                            ),
                          ),
                        for (
                          var groupIndex = 0;
                          groupIndex < groups.length;
                          groupIndex++
                        ) ...[
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: NodeLaneTokens.gutter,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: NodeLaneCatalogHeading(
                                groups[groupIndex].$1,
                                action: groupIndex == 0 && !selecting
                                    ? thirdParty
                                          ? '管理仓库'
                                          : managing
                                          ? '完成'
                                          : '管理'
                                    : null,
                                onAction: groupIndex == 0 && !selecting
                                    ? thirdParty
                                          ? () => showMobileRepositories(
                                              context,
                                              type,
                                            )
                                          : () => setState(
                                              () => managing = !managing,
                                            )
                                    : null,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: NodeLaneTokens.gutter,
                            ),
                            sliver: SliverList.builder(
                              itemCount: groups[groupIndex].$2.length,
                              itemBuilder: (_, i) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: i == groups[groupIndex].$2.length - 1
                                      ? 0
                                      : NodeLaneTokens.space12,
                                ),
                                child: _card(groups[groupIndex].$2[i]),
                              ),
                            ),
                          ),
                        ],
                        if (all.isNotEmpty)
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height:
                                  (selecting
                                      ? 0
                                      : pageBottomInsets(context).bottom) +
                                  NodeLaneTokens.space24,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return PopScope(
      canPop: !selecting && !_bulkBusy,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && selecting && !_bulkBusy) _finishSelection();
      },
      child: IgnorePointer(ignoring: _bulkBusy, child: page),
    );
  }
}
