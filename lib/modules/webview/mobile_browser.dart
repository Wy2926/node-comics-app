
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/services/nodelane_private_storage.dart';
import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/services/translation/identity.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'translation_bridge.dart';
import 'browser_url.dart';
import 'browser_navigation.dart';
import 'mobile_browser_widgets.dart';

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
      if (value is! Map || !isBrowserUrl(value['url'])) return null;
      final history = (value['history'] as List)
          .whereType<String>()
          .where(isBrowserUrl)
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
    if (!isBrowserUrl(url) || tabs.length >= 12) return;
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
    final value = await showBrowserAddress(
      context,
      initialUrl: newTab ? '' : current?.url ?? '',
      newTab: newTab,
    );
    if (!mounted || !isBrowserUrl(value)) return;
    if (newTab) {
      _new(value!);
    } else {
      current?.controller?.loadUrl(urlRequest: URLRequest(url: WebUri(value!)));
    }
  }

  Future<void> _showTabs() async {
    final action = await showModalBottomSheet<(String, BrowserTab?)>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: NodeLaneTokens.of(context).canvas,
      builder: (sheetContext) => NodeLaneModalScope(
        child: StatefulBuilder(
          builder: (context, refreshSheet) => SafeArea(
            top: false,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * .8,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 8, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '标签页 · ${tabs.length}',
                            style: NodeLaneTokens.modalTitleStyle,
                          ),
                        ),
                        IconButton(
                          tooltip: MaterialLocalizations.of(context)
                              .closeButtonTooltip,
                          onPressed: () => Navigator.pop(sheetContext),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: tabs.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = tabs[index];
                        return MobileBrowserTabCard(
                          key: ValueKey(item.id),
                          title: item.title,
                          url: item.url,
                          selected: item.id == active,
                          onSelect: () =>
                              Navigator.pop(sheetContext, ('select', item)),
                          onClose: () {
                            if (tabs.length == 1) {
                              Navigator.pop(sheetContext, ('close', item));
                            } else {
                              _close(item);
                              refreshSheet(() {});
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (tabs.length >= 12)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text('最多打开 12 个标签页，请先关闭一个。'),
                          ),
                        FilledButton.icon(
                          onPressed: tabs.length < 12
                              ? () => Navigator.pop(sheetContext, ('new', null))
                              : null,
                          icon: const Icon(Icons.add),
                          label: const Text('新标签页'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (!mounted || action == null) return;
    switch (action.$1) {
      case 'new':
        await _address(newTab: true);
      case 'select':
        _select(action.$2!);
      case 'close':
        _close(action.$2!);
    }
  }

  Widget _menu(BrowserTab? tab) => PopupMenuButton<String>(
    tooltip: '更多',
    onSelected: (action) async {
      if (action == 'reload') await tab?.controller?.reload();
      if (action == 'new') await _address(newTab: true);
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
    itemBuilder: (_) => [
      PopupMenuItem(
        value: 'reload',
        enabled: tab != null,
        child: const Text('刷新'),
      ),
      PopupMenuItem(
        value: 'new',
        enabled: ready && tabs.length < 12,
        child: const Text('新标签页'),
      ),
      const PopupMenuItem(value: 'cookies', child: Text('清除网站登录状态')),
    ],
  );

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
      child: NodeLaneSurface(
        child: Scaffold(
          body: Column(
            children: [
              MobileBrowserHeader(
                title: tab?.title ?? '',
                url: tab?.url ?? '',
                onAddress: _address,
                onClose: () => Navigator.of(context).pop(),
                menu: _menu(tab),
              ),
              Expanded(
                child: !ready
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
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
              if (tab != null)
                ListenableBuilder(
                  listenable: tab.translation,
                  builder: (context, _) => MobileBrowserToolbar(
                    tabCount: tabs.length,
                    translating: tab.translation.enabled,
                    onBack: tab.historyIndex > 0 ? () => _history(-1) : null,
                    onForward: tab.historyIndex + 1 < tab.history.length
                        ? () => _history(1)
                        : null,
                    onTranslate: () =>
                        showTranslationControls(context, tab.translation),
                    onTabs: _showTabs,
                  ),
                ),
            ],
          ),
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
  bool loading = true, loadError = false;
  double progress = 0;
  String? loadingUrl;
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
  Widget build(BuildContext context) => Stack(
    children: [
      InAppWebView(
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
            browserNavigationPolicy(
              action,
              isIos: Platform.isIOS,
              active: mounted && widget.active,
              openTab: widget.newTab,
            ),
        onCreateWindow: (controller, action) async {
          final url = action.request.url?.toString();
          final gesture =
              action.hasGesture == true ||
              action.navigationType == NavigationType.LINK_ACTIVATED;
          if (widget.active && gesture && isBrowserUrl(url)) {
            widget.newTab(url!);
          }
          return false;
        },
        onCloseWindow: (_) {},
        onLoadStart: (controller, url) {
          if (!mounted) return;
          navigation++;
          setState(() {
            loading = true;
            loadError = false;
            progress = 0;
            loadingUrl = url?.toString();
          });
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
          setState(() => loading = false);
          widget.changed();
        },
        onUpdateVisitedHistory: (controller, url, isReload) async {
          if (url == null || loading || url.toString() == widget.tab.url) {
            return;
          }
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
        onProgressChanged: (_, value) {
          if (mounted) setState(() => progress = value / 100);
        },
        onReceivedError: (_, request, error) {
          if (!mounted ||
              request.isForMainFrame != true ||
              error.type == WebResourceErrorType.CANCELLED ||
              request.url.toString() != (loadingUrl ?? widget.tab.url)) {
            return;
          }
          setState(() {
            loading = false;
            loadError = true;
          });
        },
      ),
      if (loading)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: LinearProgressIndicator(
            minHeight: 2,
            value: progress > 0 ? progress : null,
          ),
        ),
      if (loadError)
        Positioned.fill(
          child: MobileBrowserLoadError(
            onRetry: () => widget.tab.controller?.loadUrl(
              urlRequest: URLRequest(url: WebUri(loadingUrl ?? widget.tab.url)),
            ),
          ),
        ),
    ],
  );
}
