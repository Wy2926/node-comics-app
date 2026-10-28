import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/services/nodelane_private_storage.dart';
import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/services/translation/identity.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/services/http/m_client.dart';

import 'translation_bridge.dart';

class BrowserTab {
  BrowserTab(
    this.url, {
    String? id,
    this.title = '',
    this.x = 0,
    this.y = 0,
    List<String>? history,
    this.historyIndex = 0,
  }) : id = id ?? translationUuid(),
       history = history ?? [url];
  final String id;
  String url, title;
  int x, y, historyIndex;
  final List<String> history;
  final translation = TranslationViewController();
  InAppWebViewController? controller;
  Future<Map<String, dynamic>?> Function()? captureAnchor;
  Map<String, dynamic>? anchor;
  void visited(String value) {
    url = value;
    if (history[historyIndex] == value) return;
    history.removeRange(historyIndex + 1, history.length);
    history.add(value);
    if (history.length > 20) history.removeAt(0);
    historyIndex = history.length - 1;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'title': title,
    'x': x,
    'y': y,
    'history': history,
    'historyIndex': historyIndex,
    'translated': translation.showTranslation,
    'anchor': anchor,
  };
  static BrowserTab? fromJson(dynamic value) {
    try {
      if (value is! Map || !_webUrl(value['url'])) return null;
      final history = (value['history'] as List)
          .whereType<String>()
          .where(_webUrl)
          .take(20)
          .toList();
      if (history.isEmpty) history.add(value['url'] as String);
      final tab = BrowserTab(
        value['url'] as String,
        id: value['id'] as String,
        title: value['title'] as String,
        x: (value['x'] as int).clamp(0, 1000000),
        y: (value['y'] as int).clamp(0, 10000000),
        history: history,
        historyIndex: (value['historyIndex'] as int).clamp(
          0,
          history.length - 1,
        ),
      );
      tab.translation.showTranslation = value['translated'] != false;
      if (value['anchor'] is Map) {
        tab.anchor = Map<String, dynamic>.from(value['anchor'] as Map);
      }
      return tab;
    } catch (_) {
      return null;
    }
  }
}

bool _webUrl(dynamic value) {
  if (value is! String || value.length > 8192) return false;
  final uri = Uri.tryParse(value);
  return uri != null &&
      {'http', 'https'}.contains(uri.scheme) &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty;
}

/// Logical tabs outlive controllers. One active and one 30-second warm view.
class MobileComicBrowser extends ConsumerStatefulWidget {
  const MobileComicBrowser({super.key, required this.url, required this.title});
  final String url, title;
  @override
  ConsumerState<MobileComicBrowser> createState() => _MobileComicBrowserState();
}

class _MobileComicBrowserState extends ConsumerState<MobileComicBrowser>
    with WidgetsBindingObserver {
  static const _vault = nodeLanePrivateVault,
      _storageKey = 'nodelane.browser.tabs.v1';
  final tabs = <BrowserTab>[];
  String? active, warm;
  Timer? _warmTimer, _saveTimer;
  bool foreground = true, ready = false;
  late final service = ref.read(translationServiceProvider);
  BrowserTab? get current => tabs.where((tab) => tab.id == active).firstOrNull;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    service.addListener(_attach);
    service
        .initialize()
        .then((_) {
          if (mounted) _attach();
        })
        .catchError((_) {});
    _restore();
  }

  Future<void> _restore() async {
    try {
      final raw = await _vault.read(key: _storageKey);
      if (raw != null && raw.length <= 256 * 1024) {
        final values = jsonDecode(raw) as List;
        for (final value in values.take(12)) {
          final tab = BrowserTab.fromJson(value);
          if (tab != null && !tabs.any((other) => other.id == tab.id)) {
            tabs.add(tab);
          }
        }
      }
    } catch (_) {}
    if (!mounted) {
      for (final tab in tabs) {
        tab.translation.dispose();
      }
      return;
    }
    final existing = tabs.where((tab) => tab.url == widget.url).firstOrNull;
    final tab = existing ?? BrowserTab(widget.url, title: widget.title);
    if (existing == null) {
      if (tabs.length >= 12) tabs.removeAt(0).translation.dispose();
      tabs.add(tab);
    }
    active = tab.id;
    ready = true;
    _attach();
    setState(() {});
  }

  void _attach() {
    for (final tab in tabs) {
      tab.translation.attach(service.runtime);
      tab.translation.configure(foreground: foreground && tab.id == active);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    foreground = state == AppLifecycleState.resumed;
    if (!foreground) {
      _warmTimer?.cancel();
      warm = null;
      _save();
    }
    _attach();
    if (mounted) setState(() {});
  }

  void _save() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 400), () async {
      final tab = current;
      if (tab != null && foreground) {
        tab.anchor = await tab.captureAnchor?.call() ?? tab.anchor;
      }
      if (!mounted) return;
      final text = jsonEncode(tabs.map((tab) => tab.toJson()).toList());
      if (text.length <= 256 * 1024) {
        _vault.write(key: _storageKey, value: text).catchError((_) {});
      }
    });
  }

  void _select(BrowserTab tab) {
    if (active == tab.id) return;
    final previous = current;
    if (previous != null) {
      previous.captureAnchor?.call().then((value) {
        if (value != null) previous.anchor = value;
      });
    }
    _warmTimer?.cancel();
    warm = active;
    active = tab.id;
    _attach();
    setState(() {});
    _save();
    _warmTimer = Timer(const Duration(seconds: 30), () {
      if (mounted) setState(() => warm = null);
    });
  }

  void _new(String url) {
    if (!_webUrl(url) || tabs.length >= 12) return;
    final tab = BrowserTab(url);
    tabs.add(tab);
    _select(tab);
  }

  void _close(BrowserTab tab) {
    tabs.remove(tab);
    tab.translation.dispose();
    if (warm == tab.id) warm = null;
    if (active == tab.id) active = tabs.lastOrNull?.id;
    if (tabs.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    _attach();
    setState(() {});
    _save();
  }

  Future<void> _address({bool newTab = false}) async {
    final input = TextEditingController(
      text: newTab ? 'https://' : current?.url,
    );
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(newTab ? '新标签页' : '打开网址'),
        content: TextField(
          controller: input,
          autofocus: true,
          keyboardType: TextInputType.url,
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, input.text.trim()),
            child: const Text('打开'),
          ),
        ],
      ),
    );
    input.dispose();
    if (!mounted || !_webUrl(value)) return;
    if (newTab) {
      _new(value!);
    } else {
      current?.controller?.loadUrl(urlRequest: URLRequest(url: WebUri(value!)));
    }
  }

  Future<void> _history(int delta) async {
    final tab = current;
    if (tab == null) return;
    final next = tab.historyIndex + delta;
    if (next < 0 || next >= tab.history.length) return;
    tab.historyIndex = next;
    tab.url = tab.history[next];
    tab.x = 0;
    tab.y = 0;
    await tab.controller?.loadUrl(urlRequest: URLRequest(url: WebUri(tab.url)));
    if (mounted) setState(() {});
    _save();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    service.removeListener(_attach);
    _warmTimer?.cancel();
    _saveTimer?.cancel();
    if (ready) {
      _vault
          .write(
            key: _storageKey,
            value: jsonEncode(tabs.map((tab) => tab.toJson()).toList()),
          )
          .catchError((_) {});
    }
    for (final tab in tabs) {
      tab.translation.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tab = current;
    return PopScope(
      canPop: tab == null || tab.historyIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _history(-1);
      },
      child: Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: _address,
            child: Text(
              tab?.title.isNotEmpty == true ? tab!.title : tab?.url ?? '浏览器',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          actions: [
            if (tab != null)
              IconButton(
                tooltip: '漫画翻译',
                icon: const Icon(Icons.translate),
                onPressed: () =>
                    showTranslationControls(context, tab.translation),
              ),
            IconButton(
              tooltip: '新标签页',
              onPressed: tabs.length < 12 ? () => _address(newTab: true) : null,
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<String>(
              onSelected: (action) async {
                if (action == 'reload') await tab?.controller?.reload();
                if (action == 'cookies') {
                  for (final item in tabs) {
                    item.translation.configure(enabled: false);
                  }
                  await CookieManager.instance().deleteAllCookies();
                  for (final item in tabs) {
                    await MClient.deleteAllCookies(item.url);
                  }
                  await tab?.controller?.reload();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'reload', child: Text('刷新')),
                PopupMenuItem(value: 'cookies', child: Text('清除网站登录状态')),
              ],
            ),
          ],
        ),
        body: !ready
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(
                    height: 46,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final item in tabs)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: InputChip(
                              selected: item.id == active,
                              label: SizedBox(
                                width: 120,
                                child: Text(
                                  item.title.isEmpty
                                      ? Uri.tryParse(item.url)?.host ?? ''
                                      : item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              onPressed: () => _select(item),
                              onDeleted: () => _close(item),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        for (final item in tabs.where(
                          (item) => item.id == active || item.id == warm,
                        ))
                          Offstage(
                            key: ValueKey(item.id),
                            offstage: item.id != active,
                            child: _BrowserTabView(
                              tab: item,
                              active: foreground && item.id == active,
                              changed: () {
                                if (mounted) setState(() {});
                                _save();
                              },
                              save: _save,
                              newTab: _new,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: tab != null && tab.historyIndex > 0
                              ? () => _history(-1)
                              : null,
                          icon: const Icon(Icons.arrow_back),
                        ),
                        IconButton(
                          onPressed:
                              tab != null &&
                                  tab.historyIndex + 1 < tab.history.length
                              ? () => _history(1)
                              : null,
                          icon: const Icon(Icons.arrow_forward),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('返回阅读器'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _BrowserTabView extends StatefulWidget {
  const _BrowserTabView({
    required this.tab,
    required this.active,
    required this.changed,
    required this.save,
    required this.newTab,
  });
  final BrowserTab tab;
  final bool active;
  final VoidCallback changed;
  final VoidCallback save;
  final void Function(String) newTab;
  @override
  State<_BrowserTabView> createState() => _BrowserTabViewState();
}

class _BrowserTabViewState extends State<_BrowserTabView> {
  WebTranslationBridge? bridge;
  late int restoreX = widget.tab.x, restoreY = widget.tab.y;
  bool loading = true;
  int navigation = 0;
  Future<void> _visibility() async {
    final controller = widget.tab.controller;
    if (controller == null) return;
    try {
      if (Platform.isAndroid) {
        if (widget.active) {
          await controller.resume();
        } else {
          await controller.pause();
        }
      }
      if (Platform.isIOS && !widget.active) {
        await controller.pauseAllMediaPlayback();
      }
    } catch (_) {}
  }

  @override
  void didUpdateWidget(_BrowserTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) _visibility();
  }

  @override
  void dispose() {
    bridge?.dispose();
    widget.tab.controller = null;
    widget.tab.captureAnchor = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InAppWebView(
    initialUrlRequest: URLRequest(url: WebUri(widget.tab.url)),
    initialSettings: InAppWebViewSettings(
      javaScriptEnabled: true,
      javaScriptBridgeForMainFrameOnly: true,
      javaScriptHandlersForMainFrameOnly: true,
      useShouldOverrideUrlLoading: true,
      supportMultipleWindows: true,
      javaScriptCanOpenWindowsAutomatically: false,
      allowFileAccess: false,
      allowContentAccess: false,
      allowFileAccessFromFileURLs: false,
      allowUniversalAccessFromFileURLs: false,
      sharedCookiesEnabled: true,
    ),
    onWebViewCreated: (controller) {
      widget.tab.controller = controller;
      bridge = WebTranslationBridge(
        controller,
        widget.tab.translation,
        widget.tab.id,
      );
      widget.tab.captureAnchor = bridge!.captureAnchor;
      _visibility();
    },
    shouldOverrideUrlLoading: (controller, action) async =>
        _webUrl(action.request.url?.toString())
        ? NavigationActionPolicy.ALLOW
        : NavigationActionPolicy.CANCEL,
    onCreateWindow: (controller, action) async {
      final url = action.request.url?.toString();
      final gesture =
          action.hasGesture == true ||
          action.navigationType == NavigationType.LINK_ACTIVATED;
      if (widget.active && gesture && _webUrl(url)) widget.newTab(url!);
      return false;
    },
    onCloseWindow: (_) {},
    onLoadStart: (controller, url) {
      navigation++;
      loading = true;
      bridge?.navigate();
      if (url?.toString() != widget.tab.url) {
        if (Uri.tryParse(url?.toString() ?? '')?.origin !=
            Uri.tryParse(widget.tab.url)?.origin) {
          widget.tab.translation.configure(enabled: false);
        }
        restoreX = 0;
        restoreY = 0;
        widget.tab.anchor = null;
      }
    },
    onLoadStop: (controller, url) async {
      if (url == null || !mounted) return;
      final epoch = navigation;
      widget.tab.visited(url.toString());
      widget.tab.title = await controller.getTitle() ?? '';
      if (!mounted || epoch != navigation) return;
      try {
        await bridge?.install(Uri.parse(url.toString()));
        final ua = await controller.evaluateJavascript(
          source: 'navigator.userAgent',
        );
        await MClient.setCookie(url.toString(), ua ?? '', controller);
        if (restoreX != 0 || restoreY != 0) {
          await controller.scrollTo(x: restoreX, y: restoreY);
        }
        await bridge?.restoreAnchor(widget.tab.anchor);
      } catch (_) {}
      if (!mounted || epoch != navigation) return;
      loading = false;
      widget.changed();
    },
    onUpdateVisitedHistory: (controller, url, isReload) async {
      if (url == null || loading || url.toString() == widget.tab.url) return;
      navigation++;
      bridge?.navigate();
      widget.tab.visited(url.toString());
      try {
        await bridge?.install(Uri.parse(url.toString()));
      } catch (_) {}
      if (mounted) widget.changed();
    },
    onScrollChanged: (controller, x, y) {
      if (!loading) {
        widget.tab.anchor = null;
        widget.tab.x = restoreX = x;
        widget.tab.y = restoreY = y;
        widget.save();
      }
    },
    onTitleChanged: (controller, title) {
      if (mounted && title != null) {
        widget.tab.title = title;
        widget.changed();
      }
    },
  );
}
