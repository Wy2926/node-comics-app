import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extensions_provider.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/mobile_media_menu.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
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
  String? error;
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
    query.dispose();
    super.dispose();
  }

  Future<void> _fetch(
    Source source, {
    bool open = false,
    bool latest = false,
  }) async {
    if (source.id == null || !busy.add(source.id!)) return;
    setState(() => error = null);
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
      if (mounted) setState(() => error = '网站暂时无法加载，请重试或在浏览器打开。');
    } finally {
      if (mounted) setState(() => busy.remove(source.id));
    }
  }

  void _open(Source source, {bool latest = false}) {
    sourceRepository.markLastUsed(source.itemType, source.id);
    context.push('/mangaHome', extra: (source, latest));
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
            NodeLaneCatalogRow(
              title: source.isPinned == true ? '取消常用' : '固定到常用',
              leading: Icon(NodeLaneIcons.of(context).pin),
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
                _pin(source);
              },
            ),
            const SizedBox(height: 12),
            NodeLaneCatalogRow(
              title: '最新内容',
              leading: Icon(NodeLaneIcons.of(context).latest),
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
              const SizedBox(height: 12),
              NodeLaneCatalogRow(
                title: '在浏览器打开',
                leading: Icon(NodeLaneIcons.of(context).browser),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  context.push(
                    '/mangawebview',
                    extra: {'url': source.baseUrl!, 'title': source.name ?? ''},
                  );
                },
              ),
            ],
            if (source.isAdded == true) ...[
              const SizedBox(height: 12),
              NodeLaneCatalogRow(
                title: '来源设置',
                leading: Icon(NodeLaneIcons.of(context).settings),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  context.push('/extension_detail', extra: source);
                },
              ),
            ],
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
    return NodeLaneCatalogRow(
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
          : installed
          ? () => _open(source)
          : () => _fetch(source, open: true),
      onLongPress: () => _sourceActions(source),
      trailing: busy.contains(source.id)
          ? SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2, color: t.accent),
            )
          : managing
          ? IconButton(
              tooltip: source.isPinned == true ? '取消常用' : '固定到常用',
              onPressed: () => _pin(source),
              icon: Icon(
                source.isPinned == true ? icons.pinSelected : icons.pin,
                color: t.accent,
              ),
            )
          : thirdParty && (!installed || update)
          ? TextButton(
              style: TextButton.styleFrom(
                backgroundColor: t.accentSoft,
                minimumSize: const Size(64, 44),
                shape: const StadiumBorder(),
              ),
              onPressed: () => _fetch(source),
              child: Text(
                update ? '更新' : '安装',
                style: t.readerSecondary.copyWith(
                  color: t.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
    final temporary = ref.watch(temporaryCatalogRepositoryProvider(type));
    final loading = ref.watch(temporaryCatalogLoadProvider(type));
    ref.watch(fetchItemSourcesListProvider(reFresh: false, itemType: type));
    final sources = ref.watch(getExtensionsStreamProvider(type));
    final repositories = ref.watch(extensionsRepoStateProvider(type));
    final showNsfw = ref.watch(showNSFWStateProvider);
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final all =
        (sources.value ?? <Source>[])
            .where(
              (s) =>
                  (showNsfw || s.isNsfw != true) &&
                  !repositories.any(
                    (r) => r.jsonUrl == s.repo?.jsonUrl && r.hidden == true,
                  ) &&
                  (thirdParty || s.repo?.jsonUrl == temporary?.jsonUrl) &&
                  (s.name ?? '').toLowerCase().contains(
                    query.text.toLowerCase(),
                  ),
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
                            error = null;
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
                        error = null;
                        query.clear();
                      }),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: NodeLaneSearchField(
                            controller: query,
                            hint: '搜索网站',
                            clearLabel: '清除',
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        PopupMenuButton<String>(
                          tooltip: '来源操作',
                          icon: Icon(icons.more),
                          onSelected: (value) {
                            if (value == 'search') {
                              context.push(
                                '/globalSearch',
                                extra: (null, type),
                              );
                            }
                            if (value == 'filter') {
                              context.push(
                                thirdParty ? '/ExtensionLang' : '/sourceFilter',
                                extra: type,
                              );
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
                            PopupMenuItem(
                              value: 'search',
                              child: Text('搜索漫画或作品'),
                            ),
                            PopupMenuItem(
                              value: 'filter',
                              child: Text('语言与来源筛选'),
                            ),
                            if (thirdParty)
                              const PopupMenuItem(
                                value: 'update',
                                child: Text('更新已安装来源'),
                              ),
                            if (ref.read(developerModeStateProvider))
                              const PopupMenuItem(
                                value: 'create',
                                child: Text('创建扩展'),
                              ),
                            PopupMenuItem(value: 'local', child: Text('本地来源')),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final requestedType = type;
                    setState(() => error = null);
                    try {
                      final refresh = ref.refresh(
                        fetchItemSourcesListProvider(
                          reFresh: true,
                          itemType: requestedType,
                        ).future,
                      );
                      await refresh;
                      if (!mounted) return;
                      ref.invalidate(
                        temporaryCatalogLoadProvider(requestedType),
                      );
                      await ref.read(
                        temporaryCatalogLoadProvider(requestedType).future,
                      );
                    } catch (_) {
                      if (mounted && type == requestedType) {
                        setState(() => error = '目录刷新失败，已保留缓存，可下拉重试。');
                      }
                    }
                  },
                  child: CustomScrollView(
                    key: PageStorageKey('catalog-${type.name}-$thirdParty'),
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverToBoxAdapter(
                          child: thirdParty
                              ? NodeLaneCatalogHeading(
                                  '第三方来源',
                                  action: '管理仓库',
                                  onAction: () =>
                                      showMobileRepositories(context, type),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    temporary == null
                                        ? '暂未配置此类来源'
                                        : '临时目录 · ${temporary.name ?? '第三方'}',
                                    style: t.readerSecondary,
                                  ),
                                ),
                        ),
                      ),
                      if (error != null || sources.hasError || loading.hasError)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              error ?? '目录加载失败，下拉重试。',
                              style: t.readerSecondary.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      if (all.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: loading.isLoading || sources.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Column(
                                    children: [
                                      Text(
                                        query.text.isEmpty
                                            ? '暂无可用网站'
                                            : '没有匹配的网站',
                                        style: t.readerLabel,
                                      ),
                                      const SizedBox(height: 12),
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
                            child: NodeLaneCatalogRow(
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
