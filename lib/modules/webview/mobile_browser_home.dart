import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extensions_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'browser_session_store.dart';
import 'browser_url.dart';
import 'mobile_browser_widgets.dart';
import 'mobile_browser_tabs_sheet.dart';

class MobileBrowserHome extends ConsumerStatefulWidget {
  const MobileBrowserHome({super.key});
  @override
  ConsumerState<MobileBrowserHome> createState() => _MobileBrowserHomeState();
}

class _MobileBrowserHomeState extends ConsumerState<MobileBrowserHome> {
  final address = TextEditingController();
  bool ready = false;
  String? error;
  @override
  void initState() {
    super.initState();
    browserSessionStore.load().then((_) {
      if (mounted) setState(() => ready = true);
    });
  }

  @override
  void dispose() {
    address.dispose();
    super.dispose();
  }

  void _open(String value, [String title = '', String? tabId]) {
    final url = normalizeBrowserAddress(value);
    if (url == null) {
      setState(() => error = '请输入有效的网址');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      error = null;
      address.clear();
    });
    context.push(
      '/mangawebview',
      extra: {'url': url, 'title': title, 'tabId': ?tabId},
    );
  }

  Future<void> _new() async {
    final value = await showBrowserAddress(context, newTab: true);
    if (mounted && value != null) _open(value);
  }

  Future<void> _tabs() async {
    final action = await showNodeLaneCatalogSheet<String>(
      context,
      MobileBrowserTabsSheet(
        entries: browserSessionStore.entries,
        onClose: browserSessionStore.close,
      ),
    );
    if (!mounted || action == null) return;
    if (action.isEmpty) {
      await _new();
      return;
    }
    final entry = browserSessionStore.entries
        .where((e) => e['id'] == action)
        .firstOrNull;
    if (entry != null) {
      _open(
        entry['url'] as String,
        entry['title'] as String? ?? '',
        entry['id'] as String,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final showNsfw = ref.watch(showNSFWStateProvider);
    final hiddenRepositories = {
      for (final type in ItemType.values)
        for (final repo in ref.watch(extensionsRepoStateProvider(type)))
          if (repo.hidden == true) repo.jsonUrl,
    };
    final pinned =
        <Source>[
              for (final type in ItemType.values)
                ...ref.watch(getExtensionsStreamProvider(type)).value ??
                    <Source>[],
            ]
            .where(
              (source) =>
                  source.isPinned == true &&
                  (showNsfw || source.isNsfw != true) &&
                  !hiddenRepositories.contains(source.repo?.jsonUrl) &&
                  isBrowserUrl(source.baseUrl),
            )
            .take(8)
            .toList();
    return NodeLaneSurface(
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: ListenableBuilder(
            listenable: browserSessionStore,
            builder: (context, _) {
              final entries = browserSessionStore.entries;
              final shown = entries.take(3).toList();
              return ListView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  pageBottomInsets(context).bottom + 24,
                ),
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('浏览器', style: t.pageTitle)),
                      NodeLaneIconButton(
                        tooltip: '新建标签页',
                        icon: icons.add,
                        onPressed: ready && entries.length < 12 ? _new : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: address,
                    style: t.readerLabel,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.go,
                    autocorrect: false,
                    enableSuggestions: false,
                    onSubmitted: _open,
                    onChanged: (_) => setState(() => error = null),
                    decoration: t
                        .searchDecoration(
                          '输入或粘贴网址',
                          prefixIcon: Icon(icons.search),
                          suffixIcon: IconButton(
                            tooltip: address.text.trim().isEmpty
                                ? '粘贴网址'
                                : '打开网址',
                            icon: Icon(
                              address.text.trim().isEmpty
                                  ? icons.clipboard
                                  : icons.forward,
                            ),
                            onPressed: () async {
                              if (address.text.trim().isNotEmpty) {
                                _open(address.text);
                                return;
                              }
                              final data = await Clipboard.getData(
                                Clipboard.kTextPlain,
                              );
                              if (!mounted || data?.text == null) return;
                              setState(() {
                                address.text = data!.text!.trim();
                                error = null;
                              });
                            },
                          ),
                        )
                        .copyWith(errorText: error),
                  ),
                  NodeLaneCatalogHeading(
                    '已打开 · ${entries.length}',
                    action: '查看全部',
                    onAction: ready ? _tabs : null,
                  ),
                  if (!ready) const Center(child: CircularProgressIndicator()),
                  if (ready && shown.isEmpty)
                    NodeLaneCatalogRow(
                      title: '打开第一个网页',
                      subtitle: '输入网址，或从来源打开网站',
                      leading: Icon(icons.browser, color: t.accent),
                      onTap: _new,
                    ),
                  for (var i = 0; i < shown.length; i++)
                    NodeLaneCatalogRow(
                      title: (shown[i]['title'] as String?)?.isNotEmpty == true
                          ? shown[i]['title'] as String
                          : '网页',
                      subtitle: Uri.tryParse(shown[i]['url'] as String)?.host,
                      first: i == 0,
                      last: i == shown.length - 1,
                      leading:
                          browserSessionStore.preview(
                                shown[i]['id'] as String,
                              ) ==
                              null
                          ? NodeLaneWebsiteIcon(icon: icons.web)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                browserSessionStore.preview(
                                  shown[i]['id'] as String,
                                )!,
                                fit: BoxFit.cover,
                                cacheWidth: 80,
                              ),
                            ),
                      onTap: () => _open(
                        shown[i]['url'] as String,
                        shown[i]['title'] as String? ?? '',
                        shown[i]['id'] as String,
                      ),
                    ),
                  const NodeLaneCatalogHeading('常用网站'),
                  if (pinned.isEmpty)
                    NodeLaneCatalogRow(
                      title: '从来源添加常用网站',
                      subtitle: '在来源中固定后，会显示在这里',
                      leading: Icon(icons.pin, color: t.accent),
                      onTap: () => context.go('/browse'),
                    ),
                  for (var i = 0; i < pinned.length; i++)
                    NodeLaneCatalogRow(
                      title: pinned[i].name ?? '',
                      subtitle: Uri.tryParse(pinned[i].baseUrl!)?.host,
                      leading: NodeLaneWebsiteIcon(url: pinned[i].iconUrl),
                      first: i == 0,
                      last: i == pinned.length - 1,
                      onTap: () =>
                          _open(pinned[i].baseUrl!, pinned[i].name ?? ''),
                    ),
                  const SizedBox(height: 16),
                  Text('打开网页后，可翻译漫画图片。', style: t.readerSecondary),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
