import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';
import 'package:url_launcher/url_launcher.dart';

String repositoryName(Repo repo) => repo.name?.isNotEmpty == true
    ? repo.name!
    : Uri.tryParse(repo.jsonUrl ?? '')?.host ?? '第三方仓库';

String repositoryKey(String value) {
  final uri = Uri.tryParse(value.trim());
  if (uri == null) return value.trim();
  return uri
      .replace(
        scheme: uri.scheme.toLowerCase(),
        host: uri.host.toLowerCase(),
        path: uri.path.replaceFirst(RegExp(r'/+$'), ''),
        fragment: '',
      )
      .toString();
}

Future<void> showMobileRepositories(BuildContext context, ItemType type) =>
    showNodeLaneCatalogSheet<void>(
      context,
      MobileRepositoryManager(itemType: type),
    );
Future<void> showMobileAddRepository(BuildContext context, ItemType type) =>
    showNodeLaneCatalogSheet<void>(
      context,
      MobileAddRepository(itemType: type),
    );

class MobileRepositoryManager extends ConsumerStatefulWidget {
  const MobileRepositoryManager({
    super.key,
    required this.itemType,
    this.asPage = false,
  });
  final ItemType itemType;
  final bool asPage;
  @override
  ConsumerState<MobileRepositoryManager> createState() =>
      _MobileRepositoryManagerState();
}

class _MobileRepositoryManagerState
    extends ConsumerState<MobileRepositoryManager> {
  bool refreshing = false;
  String? refreshError;
  Future<void> _refresh() async {
    if (refreshing) return;
    setState(() {
      refreshing = true;
      refreshError = null;
    });
    try {
      final refreshed = ref.refresh(
        fetchItemSourcesListProvider(
          reFresh: true,
          itemType: widget.itemType,
        ).future,
      );
      await refreshed;
    } catch (_) {
      if (mounted) {
        setState(() => refreshError = '目录刷新失败，已保留缓存，可重试。');
      }
    } finally {
      if (mounted) setState(() => refreshing = false);
    }
  }

  void _details(
    Repo repo, {
    bool builtIn = false,
  }) => showNodeLaneCatalogSheet<void>(
    context,
    Consumer(
      builder: (sheetContext, sheetRef, _) {
        final current =
            sheetRef
                .watch(extensionsRepoStateProvider(widget.itemType))
                .where((r) => r.jsonUrl == repo.jsonUrl)
                .firstOrNull ??
            repo;
        final icons = NodeLaneIcons.of(sheetContext);
        return NodeLaneCatalogSheet(
          title: repositoryName(current),
          subtitle: current.jsonUrl,
          heightFactor: .58,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              if (!builtIn)
                NodeLaneGroupSurface(
                  child: SwitchListTile.adaptive(
                    title: const Text('显示此仓库的来源'),
                    value: current.hidden != true,
                    onChanged: (value) => sheetRef
                        .read(
                          extensionsRepoStateProvider(widget.itemType).notifier,
                        )
                        .setVisibility(current, !value),
                  ),
                ),
              const SizedBox(height: 12),
              NodeLaneRow.card(
                title: '复制目录链接',
                leading: Icon(icons.webLink),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: current.jsonUrl ?? ''));
                  Navigator.pop(sheetContext);
                },
              ),
              if (isBrowserUrl(current.website)) ...[
                const SizedBox(height: 12),
                NodeLaneRow.card(
                  title: '仓库网站',
                  leading: Icon(icons.web),
                  onTap: () => launchUrl(
                    Uri.parse(current.website!),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (!builtIn)
                NodeLaneRow.card(
                  title: '移除仓库',
                  leading: Icon(icons.delete),
                  onTap: () async {
                    final yes = await showDialog<bool>(
                      context: sheetContext,
                      builder: (dialogContext) => NodeLaneAlertDialog(
                        title: const Text('移除仓库'),
                        content: const Text('保留已安装的来源，移除尚未安装的目录条目。'),
                        actions: [
                          NodeLaneDialogAction(
                            label: '取消',
                            secondary: true,
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                          ),
                          NodeLaneDialogAction(
                            label: '移除',
                            destructive: true,
                            onPressed: () => Navigator.pop(dialogContext, true),
                          ),
                        ],
                      ),
                    );
                    if (yes != true || !mounted || !sheetContext.mounted) {
                      return;
                    }
                    final notifier = ref.read(
                      extensionsRepoStateProvider(widget.itemType).notifier,
                    );
                    final repos = ref.read(
                      extensionsRepoStateProvider(widget.itemType),
                    );
                    await notifier.set(
                      repos.where((r) => r.jsonUrl != current.jsonUrl).toList(),
                    );
                    final ids = sourceRepository
                        .getByItemType(widget.itemType)
                        .where(
                          (s) =>
                              s.repo?.jsonUrl == current.jsonUrl &&
                              (s.sourceCode?.isEmpty ?? true),
                        )
                        .map((s) => s.id!)
                        .toList();
                    if (ids.isNotEmpty) await sourceRepository.deleteAll(ids);
                    if (sheetContext.mounted) Navigator.pop(sheetContext);
                  },
                ),
            ],
          ),
        );
      },
    ),
  );
  @override
  Widget build(BuildContext context) {
    final configured = ref.watch(extensionsRepoStateProvider(widget.itemType));
    final official = ref.watch(
      nodeLaneCatalogRepositoryProvider(widget.itemType),
    );
    final builtIn =
        official != null &&
        !configured.any((r) => r.jsonUrl == official.jsonUrl);
    final repos = [if (builtIn) official, ...configured];
    final icons = NodeLaneIcons.of(context), t = NodeLaneTokens.of(context);
    final list = ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        if (repos.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text('还没有添加第三方仓库', style: t.readerSecondary),
          ),
        for (var i = 0; i < repos.length; i++)
          NodeLaneRow.card(
            title: repositoryName(repos[i]),
            subtitle: [
              if (builtIn && i == 0) '内置官方目录',
              Uri.tryParse(repos[i].jsonUrl ?? '')?.host ?? '',
              if (repos[i].hidden == true) '已隐藏',
            ].join(' · '),
            first: i == 0,
            last: i == repos.length - 1,
            leading: Icon(icons.repository),
            onTap: () => _details(repos[i], builtIn: builtIn && i == 0),
          ),
        const SizedBox(height: 20),
        NodeLaneRow.card(
          title: '添加仓库',
          leading: Icon(icons.add),
          onTap: () => showMobileAddRepository(context, widget.itemType),
        ),
        const SizedBox(height: 20),
        NodeLaneRow.card(
          title: refreshing ? '正在刷新…' : '刷新目录',
          leading: refreshing
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(icons.refresh),
          onTap: refreshing ? null : _refresh,
        ),
        if (refreshError != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(refreshError!, style: t.readerSecondary),
          ),
      ],
    );
    return widget.asPage
        ? NodeLaneSurface(
            child: Scaffold(
              appBar: AppBar(title: Text('第三方仓库', style: t.readerTitle)),
              body: list,
            ),
          )
        : NodeLaneCatalogSheet(
            title: '第三方仓库',
            subtitle: '管理第三方来源的获取地址',
            heightFactor: .58,
            child: list,
          );
  }
}

class MobileAddRepository extends ConsumerStatefulWidget {
  const MobileAddRepository({super.key, required this.itemType});
  final ItemType itemType;
  @override
  ConsumerState<MobileAddRepository> createState() =>
      _MobileAddRepositoryState();
}

class _MobileAddRepositoryState extends ConsumerState<MobileAddRepository> {
  final input = TextEditingController();
  Timer? _debounce;
  int _revision = 0;
  Repo? preview;
  bool checking = false, saving = false;
  String? error;
  bool _exists(String value) => ref
      .read(extensionsRepoStateProvider(widget.itemType))
      .any((repo) => repositoryKey(repo.jsonUrl ?? '') == repositoryKey(value));
  void _changed(String value) {
    _debounce?.cancel();
    _revision++;
    setState(() {
      preview = null;
      checking = false;
      error = null;
    });
    if (value.trim().isEmpty) return;
    if (!isBrowserUrl(value.trim())) {
      setState(() => error = '请输入有效的 http 或 https 网址');
      return;
    }
    if (_exists(value)) {
      setState(() => error = '此仓库已添加');
      return;
    }
    _debounce = Timer(
      const Duration(milliseconds: 650),
      () => _check(value.trim(), _revision),
    );
  }

  Future<void> _check(String value, int revision) async {
    if (!mounted) return;
    setState(() => checking = true);
    try {
      final repo = await ref.read(getRepoInfosProvider(jsonUrl: value).future);
      if (!mounted || revision != _revision) return;
      setState(() {
        checking = false;
        if (repo == null || !isBrowserUrl(repo.jsonUrl)) {
          error = '未识别到可用目录，请检查链接后重试。';
        } else if (_exists(repo.jsonUrl!)) {
          error = '此仓库已添加';
        } else {
          preview = repo;
        }
      });
    } catch (_) {
      if (mounted && revision == _revision) {
        setState(() {
          checking = false;
          error = '目录读取失败，请重试。';
        });
      }
    }
  }

  Future<void> _save() async {
    final repo = preview;
    if (saving || repo == null) return;
    if (_exists(repo.jsonUrl ?? '') || _exists(input.text)) {
      setState(() => error = '此仓库已添加');
      return;
    }
    setState(() => saving = true);
    try {
      await ref.read(extensionsRepoStateProvider(widget.itemType).notifier).set(
        [...ref.read(extensionsRepoStateProvider(widget.itemType)), repo],
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() {
          saving = false;
          error = '保存未完成，请核对仓库列表。';
        });
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    return PopScope(
      canPop: !saving,
      child: NodeLaneCatalogSheet(
        title: '添加仓库',
        subtitle: '粘贴第三方仓库的目录链接',
        heightFactor: .9,
        fitContent: true,
        canClose: !saving,
        bottom: NodeLaneModalActions(
          actions: [
            NodeLaneDialogAction(
              label: '添加仓库',
              busy: saving,
              onPressed: preview == null || saving ? null : _save,
            ),
          ],
        ),
        child: ListView(
          shrinkWrap: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            NodeLaneTextField(
              controller: input,
              label: '仓库地址',
              hint: 'https://…',
              enabled: !saving,
              keyboardType: TextInputType.url,
              autocorrect: false,
              enableSuggestions: false,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              onChanged: _changed,
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: saving
                  ? null
                  : () async {
                      final value = await Clipboard.getData(
                        Clipboard.kTextPlain,
                      );
                      if (!mounted || value?.text == null) return;
                      input.text = value!.text!.trim();
                      _changed(input.text);
                    },
              icon: Icon(icons.clipboard),
              label: const Text('粘贴链接'),
            ),
            const SizedBox(height: 16),
            if (checking)
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            if (preview != null)
              NodeLaneRow.card(
                title: repositoryName(preview!),
                subtitle: '${widget.itemType.localized(context.l10n)} · 目录已识别',
                leading: Icon(icons.repository),
                trailing: Icon(icons.check, color: t.accent),
              ),
            if (error != null) ...[
              Text(
                error!,
                style: t.readerSecondary.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              if (isBrowserUrl(input.text.trim()) && !_exists(input.text))
                TextButton(
                  onPressed: checking
                      ? null
                      : () => _check(input.text.trim(), ++_revision),
                  child: const Text('重试'),
                ),
            ],
            const SizedBox(height: 12),
            Text(
              '添加后可选择需要的来源。',
              textAlign: TextAlign.center,
              style: t.readerSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
