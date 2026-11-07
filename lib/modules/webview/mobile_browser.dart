import 'package:mangayomi/modules/widgets/nodelane_notice.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/translation/translation_image_status.dart';
import 'package:mangayomi/modules/translation/translation_image_actions.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';

import 'browser_session_store.dart';
import 'mobile_browser_tabs_sheet.dart';

import 'package:mangayomi/theme/nodelane_icons.dart';
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
       history = history ?? (url.isEmpty ? [] : [url]);
  final String id;
  String url, title;
  int x, y, historyIndex;
  final List<String> history;
  bool get isBlank => url.isEmpty;
  bool pageReady = false;
  final translation = TranslationViewController();
  InAppWebViewController? controller;
  Future<Map<String, dynamic>?> Function()? captureAnchor;
  Map<String, dynamic>? anchor;
  void visited(String value) {
    if (!isBrowserUrl(value)) return;
    if (url.isNotEmpty && Uri.parse(value).origin != Uri.parse(url).origin) {
      translation.configure(showTranslation: false);
    }
    url = value;
    if (history.isNotEmpty && history[historyIndex] == value) return;
    if (history.isNotEmpty) {
      history.removeRange(historyIndex + 1, history.length);
    }
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
    'autoTranslate': translation.enabled,
    'anchor': anchor,
  };
  static BrowserTab? fromJson(dynamic value) {
    try {
      if (value is! Map ||
          (value['url'] != '' && !isBrowserUrl(value['url']))) {
        return null;
      }
      if (value['id'] is! String || (value['id'] as String).isEmpty) {
        return null;
      }
      if (value['url'] == '') return BrowserTab('', id: value['id'] as String);
      final history = (value['history'] as List? ?? [])
          .whereType<String>()
          .where(isBrowserUrl)
          .take(20)
          .toList();
      if (history.isEmpty) history.add(value['url'] as String);
      final tab = BrowserTab(
        value['url'] as String,
        id: value['id'] as String,
        title: value['title'] as String? ?? '',
        x: (value['x'] as int? ?? 0).clamp(0, 1000000),
        y: (value['y'] as int? ?? 0).clamp(0, 10000000),
        history: history,
        historyIndex: (value['historyIndex'] as int? ?? 0).clamp(
          0,
          history.length - 1,
        ),
      );
      tab.translation.showTranslation = value['translated'] == true;
      tab.translation.enabled = value['autoTranslate'] != false;
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
  const MobileComicBrowser({
    super.key,
    required this.url,
    required this.title,
    this.tabId,
  });
  final String url, title;
  final String? tabId;
  @override
  ConsumerState<MobileComicBrowser> createState() => _MobileComicBrowserState();
}

class _MobileComicBrowserState extends ConsumerState<MobileComicBrowser>
    with WidgetsBindingObserver {
  final tabs = <BrowserTab>[];
  final _addressFocus = FocusNode();
  String? active, warm;
  Timer? _warmTimer, _saveTimer;
  bool foreground = true, ready = false;
  bool _leaving = false, _showingTabs = false, _clearingLogins = false;
  bool _savedOnExit = false;
  late final service = ref.read(translationServiceProvider);
  BrowserTab? get current => tabs.where((tab) => tab.id == active).firstOrNull;
  List<Map<String, dynamic>> get _entries => [
    for (final tab in tabs) {...tab.toJson(), 'active': tab.id == active},
  ];
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
      await browserSessionStore.load();
      for (final value in browserSessionStore.entries) {
        final tab = BrowserTab.fromJson(value);
        if (tab != null && !tabs.any((other) => other.id == tab.id)) {
          tabs.add(tab);
        }
      }
    } catch (_) {}
    if (!mounted) {
      for (final tab in tabs) {
        tab.translation.dispose();
      }
      return;
    }
    final existing = tabs
        .where(
          (tab) => widget.tabId == null
              ? tab.url == widget.url
              : tab.id == widget.tabId,
        )
        .firstOrNull;
    var tab = existing;
    // A URL from the start page or a source can fill a blank tab in place.
    if (tab == null && isBrowserUrl(widget.url)) {
      tab = tabs.where((item) => item.isBlank).firstOrNull;
    }
    if (tab?.isBlank == true && isBrowserUrl(widget.url)) {
      tab!.visited(widget.url);
      tab.title = widget.title;
    }
    if (tab == null && tabs.length < BrowserSessionStore.maxTabs) {
      tab = BrowserTab(
        isBrowserUrl(widget.url) ? widget.url : '',
        title: widget.title,
      );
      tabs.add(tab);
    }
    final atLimit = tab == null;
    tab ??= tabs.last;
    if (atLimit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _tabLimit();
      });
    }
    active = tab.id;
    ready = true;
    _attach();
    if (tab.isBlank) {
      await _returnToStart();
      return;
    }
    setState(() {});
    _save();
  }

  void _attach() {
    for (final tab in tabs) {
      tab.translation.attach(service.runtime);
      tab.translation.configure(
        foreground: foreground && tab.id == active && !tab.isBlank,
      );
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
      if (tab != null && foreground) await _captureAnchor(tab);
      if (!mounted) return;
      await browserSessionStore.save(_entries).catchError((_) {});
    });
  }

  Future<void> _captureAnchor(BrowserTab tab) async {
    final x = tab.x, y = tab.y, url = tab.url;
    try {
      final anchor = await tab.captureAnchor?.call().timeout(
        const Duration(seconds: 2),
      );
      // Hiding a page can resize its viewport. A late capture must not replace
      // the reading position with the hidden view's clamped scroll offset.
      if (anchor != null &&
          tabs.contains(tab) &&
          tab.url == url &&
          tab.x == x &&
          tab.y == y &&
          anchor['x'] is num &&
          anchor['y'] is num &&
          ((anchor['x'] as num) - x).abs() < 2 &&
          ((anchor['y'] as num) - y).abs() < 2) {
        tab.anchor = anchor;
      }
    } catch (_) {}
  }

  Future<void> _capturePreview(BrowserTab tab) async {
    if (tab.isBlank || !tab.pageReady) return;
    try {
      final bytes = await tab.controller
          ?.takeScreenshot(
            screenshotConfiguration: ScreenshotConfiguration(
              snapshotWidth: 340,
              compressFormat: CompressFormat.JPEG,
              quality: 55,
            ),
          )
          .timeout(const Duration(seconds: 2));
      if (mounted && tabs.contains(tab) && bytes != null) {
        browserSessionStore.setPreview(tab.id, bytes);
      }
    } catch (_) {}
  }

  Future<void> _leave() async {
    if (_leaving) return;
    setState(() => _leaving = true);
    final tab = current;
    if (tab != null) {
      await _captureAnchor(tab);
      await _capturePreview(tab);
    }
    _saveTimer?.cancel();
    await browserSessionStore.save(_entries).catchError((_) {});
    _savedOnExit = true;
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) Navigator.of(context).pop();
  }

  void _select(BrowserTab tab) {
    if (active == tab.id) return;
    _addressFocus.unfocus();
    final previous = current;
    if (tab.isBlank) {
      active = tab.id;
      warm = previous?.isBlank == false ? previous!.id : null;
      _attach();
      unawaited(_returnToStart(previous));
      return;
    }
    if (previous != null) {
      unawaited(_capturePreview(previous));
      unawaited(_captureAnchor(previous));
    }
    _warmTimer?.cancel();
    warm = previous?.isBlank == false ? active : null;
    active = tab.id;
    _attach();
    setState(() {});
    _save();
    _warmTimer = Timer(const Duration(seconds: 30), () {
      if (mounted) setState(() => warm = null);
    });
  }

  /// Blank tabs belong to the root start page, with the app's native navigation.
  /// Keep metadata and position; no second start-page route or WebView survives.
  Future<void> _returnToStart([BrowserTab? previous]) async {
    if (_leaving) return;
    setState(() => _leaving = true);
    _saveTimer?.cancel();
    _warmTimer?.cancel();
    if (previous != null) {
      await Future.wait([_captureAnchor(previous), _capturePreview(previous)]);
    }
    if (!mounted) return;
    await browserSessionStore.save(_entries).catchError((_) {});
    _savedOnExit = true;
    if (mounted) context.go('/browser');
  }

  void _new(String url) {
    if (url.isNotEmpty && !isBrowserUrl(url)) return;
    if (tabs.length >= BrowserSessionStore.maxTabs) {
      _tabLimit();
      return;
    }
    final tab = BrowserTab(url);
    tabs.add(tab);
    _select(tab);
  }

  void _close(BrowserTab tab) {
    tabs.remove(tab);
    tab.translation.dispose();
    if (warm == tab.id) warm = null;
    if (tabs.isEmpty) tabs.add(BrowserTab(''));
    if (active == tab.id) active = tabs.last.id;
    _attach();
    setState(() {});
    _save();
  }

  void _tabLimit() {
    showNodeLaneNotice('最多保留 12 个标签页，请先关闭一个。');
    _showTabs();
  }

  void _openAddress(String url) {
    final tab = current;
    if (tab == null || !isBrowserUrl(url)) return;
    tab.controller?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
  }

  Future<void> _showTabs() async {
    if (_showingTabs) return;
    _showingTabs = true;
    try {
      final selected = current;
      if (selected != null) await _capturePreview(selected);
      if (!mounted) return;
      final action = await showNodeLaneCatalogSheet<String>(
        context,
        MobileBrowserTabsSheet(
          entries: _entries,
          onClose: (id) async {
            final tab = tabs.where((e) => e.id == id).firstOrNull;
            if (tab != null) _close(tab);
            await browserSessionStore.save(_entries);
            return _entries;
          },
        ),
      );
      if (!mounted) return;
      if (action == '') {
        _new('');
      } else if (action != null) {
        final tab = tabs.where((e) => e.id == action).firstOrNull;
        if (tab != null) _select(tab);
      }
      if (current?.isBlank == true) await _returnToStart();
    } finally {
      _showingTabs = false;
    }
  }

  Future<void> _translationControls(BrowserTab tab) async {
    await showTranslationControls(
      context,
      tab.translation,
      title: '网页翻译',
      subtitle: [
        tab.title,
        Uri.tryParse(tab.url)?.host ?? '',
      ].where((v) => v.isNotEmpty).join(' · '),
      browser: true,
    );
    if (mounted) _save();
  }

  Widget _menu(BrowserTab? tab) => PopupMenuButton<String>(
    tooltip: '更多',
    icon: Icon(
      NodeLaneIcons.of(context).more,
      size: NodeLaneTokens.iconSize,
      color: NodeLaneTokens.of(context).accent,
    ),
    onSelected: (action) async {
      if (action == 'forward') await _history(1);
      if (action == 'cookies') await _clearLogins();
    },
    itemBuilder: (_) => [
      PopupMenuItem(
        value: 'forward',
        enabled: tab != null && tab.historyIndex + 1 < tab.history.length,
        child: const Text('前进'),
      ),
      PopupMenuItem(
        value: 'cookies',
        enabled: !_clearingLogins,
        child: const Text('清除所有网站登录状态'),
      ),
    ],
  );

  Future<void> _clearLogins() async {
    if (_clearingLogins) return;
    _clearingLogins = true;
    try {
      final confirmed = await confirmClearBrowserLogins(context);
      if (!mounted || confirmed != true) return;
      for (final item in tabs) {
        item.translation.configure(showTranslation: false);
      }
      await CookieManager.instance().deleteAllCookies();
      await MClient.deleteAllCookies();
      if (mounted) await current?.controller?.reload();
    } catch (_) {
      if (mounted) {
        showNodeLaneNotice('清除失败，请重试。', kind: NodeLaneNoticeKind.error);
      }
    } finally {
      if (mounted) setState(() => _clearingLogins = false);
    }
  }

  Future<void> _history(int delta) async {
    final tab = current;
    if (tab == null) return;
    final next = tab.historyIndex + delta;
    if (next < 0 || next >= tab.history.length) return;
    tab.historyIndex = next;
    tab.visited(tab.history[next]);
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
    _addressFocus.dispose();
    if (ready && !_savedOnExit) {
      browserSessionStore.save(_entries).catchError((_) {});
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
      canPop: _leaving || tab == null || tab.historyIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _history(-1);
      },
      child: NodeLaneSurface(
        child: Scaffold(
          body: Column(
            children: [
              if (tab != null && !tab.isBlank)
                MobileBrowserHeader(
                  key: ValueKey(tab.id),
                  url: tab.url,
                  addressFocus: _addressFocus,
                  onSubmitted: _openAddress,
                  onClose: _leave,
                  onReload: () => tab.controller?.reload(),
                  menu: _menu(tab),
                ),
              Expanded(
                key: const ValueKey('browser-content'),
                child: !ready || tab?.isBlank == true
                    ? const NodeLaneEmptyState.loading()
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          for (final item in tabs.where(
                            (item) =>
                                !item.isBlank &&
                                (item.id == active || item.id == warm),
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
                                editAddress: _addressFocus.requestFocus,
                              ),
                            ),
                        ],
                      ),
              ),
              if (tab != null &&
                  !tab.isBlank &&
                  MediaQuery.viewInsetsOf(context).bottom == 0)
                ListenableBuilder(
                  listenable: tab.translation,
                  builder: (context, _) => MobileBrowserToolbar(
                    tabCount: tabs.length,
                    onBack: tab.historyIndex > 0 ? () => _history(-1) : null,
                    onNew: () => _new(''),
                    showTranslation: tab.translation.showTranslation,
                    onDisplayChanged: tab.pageReady
                        ? (value) {
                            tab.translation.configure(showTranslation: value);
                            _save();
                          }
                        : null,
                    onControls: !tab.pageReady
                        ? null
                        : () => _translationControls(tab),
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
    required this.editAddress,
  });
  final BrowserTab tab;
  final bool active;
  final VoidCallback changed;
  final VoidCallback save;
  final void Function(String) newTab;
  final VoidCallback editAddress;
  @override
  State<_BrowserTabView> createState() => _BrowserTabViewState();
}

class _BrowserTabViewState extends State<_BrowserTabView> {
  WebTranslationBridge? bridge;
  late int restoreX = widget.tab.x, restoreY = widget.tab.y;
  bool loading = true, loadError = false;
  bool restoringPosition = false;
  bool _imageMenuOpen = false;
  double progress = 0;
  String? loadingUrl;
  int navigation = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bridge?.updateTheme(translationImageTheme(context));
  }

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
    if (oldWidget.active != widget.active) {
      _visibility();
      if (widget.active && !loading) {
        restoringPosition = true;
        final x = widget.tab.x, y = widget.tab.y;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            if (!mounted || !widget.active) return;
            await widget.tab.controller?.scrollTo(x: x, y: y);
            await bridge?.restoreAnchor(widget.tab.anchor);
          } catch (_) {
          } finally {
            restoringPosition = false;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    bridge?.dispose();
    widget.tab.controller = null;
    widget.tab.captureAnchor = null;
    widget.tab.pageReady = false;
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
            theme: translationImageTheme(context),
            onImageMenu: (target) async {
              if (!mounted || !widget.active || _imageMenuOpen) return;
              _imageMenuOpen = true;
              try {
                await showTranslationImageMenu(
                  context,
                  widget.tab.translation,
                  target,
                );
              } finally {
                _imageMenuOpen = false;
              }
            },
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
            restoreX = 0;
            restoreY = 0;
            widget.tab.anchor = null;
            widget.tab.x = widget.tab.y = 0;
            widget.tab.title = '';
          }
          widget.tab.pageReady = false;
          if (url != null) widget.tab.visited(url.toString());
          widget.changed();
        },
        onLoadStop: (controller, url) async {
          if (url == null || !mounted || loadError) return;
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
          widget.tab.pageReady = true;
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
          if (widget.active && !loading && !restoringPosition) {
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
          widget.tab.pageReady = false;
          widget.changed();
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
            onEditAddress: widget.editAddress,
            onRetry: () => widget.tab.controller?.loadUrl(
              urlRequest: URLRequest(url: WebUri(loadingUrl ?? widget.tab.url)),
            ),
          ),
        ),
    ],
  );
}
