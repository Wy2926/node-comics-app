import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/widgets/source_controls.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/mobile_media_menu.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
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
  final busy = <int>{};
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
    setState(() => busy.add(source.id!));
    try {
      await fetchSourcesList(
        id: source.id,
        refresh: true,
        androidProxyServer: ref.read(androidProxyServerStateProvider),
        autoUpdateExtensions: false,
        itemType: source.itemType,
        repo: source.repo,
      );
      final loaded = await sourceRepository.findByIdAsync(source.id!);
      if (loaded == null || loaded.sourceCode?.isNotEmpty != true) {
        throw StateError('加载失败');
      }
      if (mounted &&
          open &&
          type == source.itemType &&
          GoRouter.of(context).routeInformationProvider.value.uri.path ==
              '/browse') {
        _open(loaded, latest: latest);
      }
    } catch (_) {
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
    if (_refreshing) return;
    _refreshing = true;
    final requestedType = type, requestedThirdParty = thirdParty;
    _notice?.dismiss();
    try {
      final refresh = ref.refresh(
        fetchItemSourcesListProvider(
          reFresh: true,
          itemType: requestedType,
        ).future,
      );
      await refresh;
      if (!mounted) return;
      if (requestedType == ItemType.manga) {
        await ref.read(nodeLaneCatalogRefreshProvider).refresh(force: true);
      }
      ref.invalidate(nodeLaneCatalogLoadProvider(requestedType));
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

  Future<void> _pin(Source source) =>
      sourceRepository.save(source..isPinned = !(source.isPinned ?? false));
  void _sourceActions(Source source) {
    showNodeLaneCatalogSheet<void>(
      context,
      NodeLaneCatalogSheet(
        title: source.name ?? '',
        heightFactor: .5,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            NodeLaneGroupSurface(
              children: [
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
                    if (source.isAdded == true) {
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

  Widget _row(Source source, int index, int length) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final installed =
        source.isAdded == true && source.sourceCode?.isNotEmpty == true;
    final update =
        installed &&
        source.isObsolete != true &&
        compareVersions(source.version ?? '', source.versionLast ?? '') < 0;
    return NodeLaneRow.card(
      key: ValueKey('source-${source.id}'),
      title: source.name ?? '',
      subtitle: [
        if (thirdParty && source.repo?.name?.isNotEmpty == true)
          source.repo!.name!,
        completeLanguageName((source.lang ?? '').toLowerCase()),
        if (!thirdParty) source.itemType.localized(context.l10n),
        if (source.isNsfw == true) 'NSFW',
      ].join(' · '),
      leading: NodeLaneWebsiteIcon(url: source.iconUrl),
      first: index == 0,
      last: index == length - 1,
      onTap: busy.contains(source.id)
          ? null
          : managing
          ? () => _pin(source)
          : installed && (thirdParty || !update)
          ? () => _open(source)
          : () => _fetch(source, open: true),
      onLongPress: () => _sourceActions(source),
      trailing: busy.contains(source.id)
          ? SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2, color: t.accent),
            )
          : managing
          ? NodeLaneIconButton(
              tooltip: source.isPinned == true ? '取消常用' : '固定到常用',
              onPressed: () => _pin(source),
              style: NodeLaneIconButtonStyle.plain,
              icon: source.isPinned == true ? icons.pinSelected : icons.pin,
            )
          : thirdParty && (!installed || update)
          ? NodeLaneSecondaryButton(
              onPressed: () => _fetch(source),
              child: Text(update ? '更新' : '安装'),
            )
          : null,
    );
  }

  Future<void> _updateInstalled() async {
    final updates = sourceRepository
        .getInstalledByItemType(type)
        .where(
          (source) =>
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
        setState(() {
          type = next.type;
          thirdParty = next.kind == BrowseTabKind.extensions;
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
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
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
      if (!thirdParty) ('常用', all.where((s) => s.isPinned == true).toList()),
      if (!thirdParty) ('全部网站', all.where((s) => s.isPinned != true).toList()),
      if (thirdParty) ('已安装', all.where((s) => s.isAdded == true).toList()),
      if (thirdParty) ('可安装', all.where((s) => s.isAdded != true).toList()),
    ];
    return NodeLaneSurface(
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('来源', style: t.pageTitle)),
                        MobileMediaMenu(
                          value: type,
                          availableTypes: types,
                          onChanged: (value) => setState(() {
                            type = value;
                            query.clear();
                            _notice?.dismiss();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NodeLaneSegments<bool>(
                      value: thirdParty,
                      segments: const [
                        ButtonSegment(value: false, label: Text('NodeLane')),
                        ButtonSegment(value: true, label: Text('第三方')),
                      ],
                      onChanged: (value) => setState(() {
                        thirdParty = value;
                        managing = false;
                        _notice?.dismiss();
                        query.clear();
                      }),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: NodeLaneTextField.search(
                            controller: query,
                            hint: '网站名或作品名',
                            clearLabel: '清除',
                            onSubmitted: (_) => _searchContents(),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: NodeLaneTokens.space8),
                        NodeLaneMenuButton<String>(
                          tooltip: '来源操作',
                          icon: icons.more,
                          onSelected: (value) {
                            if (value == 'search') _searchContents();
                            if (value == 'filter') {
                              _languageFilter(catalog);
                            }
                            if (value == 'update') _updateInstalled();
                            if (value == 'create') {
                              context.push('/createExtension');
                            }
                            if (value == 'local') {
                              _open(
                                Source(name: 'local', lang: '', itemType: type),
                              );
                            }
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              height: NodeLaneTokens.menuItemHeight,
                              value: 'search',
                              child: Text('搜作品'),
                            ),
                            PopupMenuItem(
                              height: NodeLaneTokens.menuItemHeight,
                              value: 'filter',
                              child: Text('语言筛选'),
                            ),
                            if (thirdParty)
                              const PopupMenuItem(
                                height: NodeLaneTokens.menuItemHeight,
                                value: 'update',
                                child: Text('更新已安装来源'),
                              ),
                            if (ref.read(developerModeStateProvider))
                              const PopupMenuItem(
                                height: NodeLaneTokens.menuItemHeight,
                                value: 'create',
                                child: Text('创建扩展'),
                              ),
                            PopupMenuItem(
                              height: NodeLaneTokens.menuItemHeight,
                              value: 'local',
                              child: Text('本地来源'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshCatalog,
                  child: CustomScrollView(
                    key: PageStorageKey('catalog-${type.name}-$thirdParty'),
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (thirdParty)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          sliver: SliverToBoxAdapter(
                            child: NodeLaneCatalogHeading(
                              '第三方来源',
                              action: '管理仓库',
                              onAction: () =>
                                  showMobileRepositories(context, type),
                            ),
                          ),
                        ),
                      if (all.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child:
                                (!thirdParty && loading.isLoading) ||
                                    sources.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Column(
                                    children: [
                                      Text(
                                        keyword.isEmpty ? '暂无可用网站' : '没有匹配的网站',
                                        style: t.readerLabel,
                                      ),
                                      const SizedBox(height: 12),
                                      if (keyword.isNotEmpty) ...[
                                        Text(
                                          '在已安装来源中搜索作品',
                                          textAlign: TextAlign.center,
                                          style: t.readerSecondary,
                                        ),
                                        const SizedBox(
                                          height: NodeLaneTokens.space16,
                                        ),
                                        FilledButton.icon(
                                          onPressed: _searchContents,
                                          icon: Icon(
                                            icons.search,
                                            size: NodeLaneTokens.smallIconSize,
                                          ),
                                          label: const Text('跨来源搜索'),
                                        ),
                                      ] else
                                        TextButton(
                                          onPressed: () =>
                                              showMobileAddRepository(
                                                context,
                                                type,
                                              ),
                                          child: const Text('添加第三方仓库'),
                                        ),
                                    ],
                                  ),
                          ),
                        ),
                      for (final group in groups) ...[
                        if (group.$2.isNotEmpty ||
                            group.$1 == '常用' && all.isNotEmpty)
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: SliverToBoxAdapter(
                              child: NodeLaneCatalogHeading(
                                group.$1,
                                action: group.$1 == '常用'
                                    ? managing
                                          ? '完成'
                                          : '管理'
                                    : null,
                                onAction: () =>
                                    setState(() => managing = !managing),
                              ),
                            ),
                          ),
                        if (group.$1 == '常用' &&
                            group.$2.isEmpty &&
                            all.isNotEmpty)
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: SliverToBoxAdapter(
                              child: Text(
                                '长按网站可固定到常用',
                                style: t.readerSecondary,
                              ),
                            ),
                          ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          sliver: SliverList.builder(
                            itemCount: group.$2.length,
                            itemBuilder: (_, i) =>
                                _row(group.$2[i], i, group.$2.length),
                          ),
                        ),
                      ],
                      if (thirdParty)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          sliver: SliverToBoxAdapter(
                            child: NodeLaneRow.card(
                              title: '添加仓库',
                              leading: Icon(icons.add, color: t.accent),
                              onTap: () =>
                                  showMobileAddRepository(context, type),
                            ),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: pageBottomInsets(context).bottom + 24,
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
    );
  }
}
