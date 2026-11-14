import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/translation/translation_image_status.dart';
import 'package:mangayomi/modules/translation/translation_image_actions.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';

import 'browser_session_store.dart';
import 'browser_webview_cache.dart';
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
import 'browser_library_store.dart';
import 'mobile_browser_library_sheet.dart';
import 'mobile_browser_menu.dart';

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
  String? iconUrl;
  int x, y, historyIndex;
  int viewGeneration = 0;
  final List<String> history;
  bool get isBlank => url.isEmpty;
  bool pageReady = false;
  bool loading = true, findOpen = false;
  final translation = TranslationViewController();
  InAppWebViewController? controller;
  Future<Map<String, dynamic>?> Function()? captureAnchor;
  Map<String, dynamic>? anchor;
  void visited(String value) {
    if (!isBrowserUrl(value)) return;
    if (url.isNotEmpty && Uri.parse(value).origin != Uri.parse(url).origin) {
      translation.configure(showTranslation: false);
      iconUrl = null;
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

/// Logical tabs outlive routes; a bounded native cache retains recent documents.
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
  final _mountedTabs = <String>[];
  final _previewing = <String>{};
  final _addressFocus = FocusNode();
  String? active;
  Timer? _saveTimer;
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
    browserLibraryStore.addListener(_libraryChanged);
    browserLibraryStore.load().catchError((_) {
      if (mounted) {
        showNodeLaneNotice(
          context.l10n.browser_data_failed,
          kind: NodeLaneNoticeKind.error,
        );
      }
    });
    service
        .initialize()
        .then((_) {
          if (mounted) _attach();
        })
        .catchError((_) {});
    _restore();
  }

  void _libraryChanged() {
    if (mounted) setState(() {});
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
    _retainView(tab);
    ready = true;
    _attach();
    if (tab.isBlank) {
      await _leave(toStart: true);
      return;
    }
    setState(() {});
    _save();
  }

  void _attach() {
    for (final tab in tabs) {
      tab.translation.attach(service.runtime);
      tab.translation.configure(
        foreground: foreground && !_leaving && tab.id == active && !tab.isBlank,
      );
    }
  }

  void _retainView(BrowserTab tab) {
    if (tab.isBlank) return;
    _mountedTabs.remove(tab.id);
    _mountedTabs.add(tab.id);
    browserWebViewCache.touch(tab.id);
    while (_mountedTabs.length > BrowserWebViewCache.capacity) {
      _mountedTabs.removeAt(0);
    }
  }

  @override
  void didHaveMemoryPressure() {
    for (final id in _mountedTabs.where((id) => id != active).toList()) {
      browserWebViewCache.remove(id);
    }
    setState(() => _mountedTabs.removeWhere((id) => id != active));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    foreground = state == AppLifecycleState.resumed;
    if (!foreground) {
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
    if (tab.isBlank || !tab.pageReady || !_previewing.add(tab.id)) return;
    final controller = tab.controller, url = tab.url, x = tab.x, y = tab.y;
    try {
      final bytes = await controller
          ?.takeScreenshot(
            screenshotConfiguration: ScreenshotConfiguration(
              snapshotWidth: 340,
              compressFormat: CompressFormat.JPEG,
              quality: 55,
            ),
          )
          .timeout(const Duration(seconds: 2));
      if (mounted &&
          tabs.contains(tab) &&
          identical(tab.controller, controller) &&
          tab.url == url &&
          tab.x == x &&
          tab.y == y &&
          bytes != null) {
        browserSessionStore.setPreview(tab.id, bytes);
      }
    } catch (_) {
    } finally {
      _previewing.remove(tab.id);
    }
  }

  Future<void> _leave({bool toStart = false, BrowserTab? previous}) async {
    if (!mounted || _leaving) return;
    setState(() => _leaving = true);
    _saveTimer?.cancel();
    final tab = previous ?? current;
    if (tab != null) {
      await Future.wait([_captureAnchor(tab), _capturePreview(tab)]);
    }
    if (!mounted) return;
    await browserSessionStore.save(_entries).catchError((_) {});
    _savedOnExit = true;
    _attach();
    if (toStart) {
      if (mounted) context.go('/browser');
    } else {
      await WidgetsBinding.instance.endOfFrame;
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _select(BrowserTab tab) async {
    if (!mounted || !tabs.contains(tab) || active == tab.id) return;
    _addressFocus.unfocus();
    final previous = current;
    if (tab.isBlank) {
      active = tab.id;
      _attach();
      await _leave(toStart: true, previous: previous);
      return;
    }
    if (previous != null) {
      unawaited(_captureAnchor(previous));
    }
    active = tab.id;
    _retainView(tab);
    _attach();
    setState(() {});
    _save();
  }

  Future<void> _new(String url) async {
    if (url.isNotEmpty && !isBrowserUrl(url)) return;
    if (tabs.length >= BrowserSessionStore.maxTabs) {
      _tabLimit();
      return;
    }
    final tab = BrowserTab(url);
    tabs.add(tab);
    await _select(tab);
  }

  void _close(BrowserTab tab) {
    tabs.remove(tab);
    _mountedTabs.remove(tab.id);
    browserWebViewCache.remove(tab.id);
    tab.translation.configure(foreground: false);
    tab.translation.dispose();
    if (tabs.isEmpty) tabs.add(BrowserTab(''));
    if (active == tab.id) active = tabs.last.id;
    _retainView(current!);
    _attach();
    setState(() {});
    _save();
  }

  void _tabLimit() {
    showNodeLaneNotice(context.l10n.browser_tab_limit);
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
      if (selected != null) {
        unawaited(_capturePreview(selected));
        unawaited(_captureAnchor(selected));
      }
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
        await _new('');
      } else if (action != null) {
        final tab = tabs.where((e) => e.id == action).firstOrNull;
        if (tab != null) await _select(tab);
      }
      if (current?.isBlank == true) await _leave(toStart: true);
    } finally {
      _showingTabs = false;
    }
  }

  Future<void> _translationControls(BrowserTab tab) async {
    await showTranslationControls(
      context,
      tab.translation,
      title: context.l10n.browser_translation,
      subtitle: [
        tab.title,
        Uri.tryParse(tab.url)?.host ?? '',
      ].where((v) => v.isNotEmpty).join(' · '),
      browser: true,
    );
    if (mounted) _save();
  }

  Widget _menu(BrowserTab tab) => Builder(
    builder: (anchor) => NodeLaneIconButton(
      tooltip: context.l10n.more,
      icon: NodeLaneIcons.of(context).more,
      style: NodeLaneIconButtonStyle.plain,
      onPressed: () => _showMenu(anchor, tab),
    ),
  );

  Future<void> _showMenu(BuildContext anchor, BrowserTab tab) async {
    final l = context.l10n;
    final pageUrl = tab.url;
    final bookmarked = browserLibraryStore.isBookmarked(tab.url);
    final action = await showBrowserPageMenu(
      anchor,
      canForward: tab.historyIndex + 1 < tab.history.length,
      bookmarked: bookmarked,
      pageReady: tab.pageReady,
      clearingLogins: _clearingLogins,
    );
    if (!mounted || action == null || current != tab || tab.url != pageUrl) {
      return;
    }
    try {
      switch (action) {
        case 'forward':
          await _history(1);
        case 'home':
          await _leave(toStart: true);
        case 'bookmark':
          await browserLibraryStore.setBookmarked(
            tab.url,
            tab.title,
            !bookmarked,
            iconUrl: tab.iconUrl,
          );
        case 'bookmarks':
        case 'history':
          final url = await showNodeLaneCatalogSheet<String>(
            context,
            MobileBrowserLibrarySheet(
              store: browserLibraryStore,
              bookmarks: action == 'bookmarks',
            ),
          );
          if (mounted && url != null) _openAddress(url);
        case 'find':
          setState(() => tab.findOpen = true);
        case 'copy':
          await Clipboard.setData(ClipboardData(text: tab.url));
          if (mounted) showNodeLaneNotice(l.error_reports_copied);
        case 'share':
          final box = context.findRenderObject() as RenderBox?;
          await shareOrCopy(
            ShareParams(
              text: tab.url,
              sharePositionOrigin: box == null
                  ? null
                  : box.localToGlobal(Offset.zero) & box.size,
            ),
          );
        case 'external':
          if (!await launchUrl(
            Uri.parse(tab.url),
            mode: LaunchMode.externalApplication,
          )) {
            throw StateError('Browser unavailable');
          }
        case 'cookies':
          await _clearLogins();
      }
    } catch (_) {
      if (mounted) {
        showNodeLaneNotice(
          l.browser_action_failed,
          kind: NodeLaneNoticeKind.error,
        );
      }
    }
  }

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
        showNodeLaneNotice(
          context.l10n.browser_clear_failed,
          kind: NodeLaneNoticeKind.error,
        );
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
    browserLibraryStore.removeListener(_libraryChanged);
    _saveTimer?.cancel();
    _addressFocus.dispose();
    if (ready && !_savedOnExit) {
      browserSessionStore.save(_entries).catchError((_) {});
    }
    for (final tab in tabs) {
      tab.translation.configure(foreground: false);
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
                  onReload: () async {
                    try {
                      if (tab.loading) {
                        await tab.controller?.stopLoading();
                        if (mounted) setState(() => tab.loading = false);
                      } else {
                        await tab.controller?.reload();
                      }
                    } catch (_) {
                      if (context.mounted) {
                        showNodeLaneNotice(
                          context.l10n.browser_action_failed,
                          kind: NodeLaneNoticeKind.error,
                        );
                      }
                    }
                  },
                  loading: tab.loading,
                  engine: browserLibraryStore.engine,
                  onEngine: browserLibraryStore.setEngine,
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
                            (item) => _mountedTabs.contains(item.id),
                          ))
                            Offstage(
                              key: ValueKey(
                                '${item.id}:${item.viewGeneration}',
                              ),
                              offstage: item.id != active,
                              child: TickerMode(
                                enabled:
                                    foreground &&
                                    !_leaving &&
                                    item.id == active,
                                child: ExcludeFocus(
                                  excluding: item.id != active,
                                  child: _BrowserTabView(
                                    tab: item,
                                    active:
                                        foreground &&
                                        !_leaving &&
                                        item.id == active,
                                    changed: () {
                                      if (mounted && item.id == active) {
                                        setState(() {});
                                      }
                                      _save();
                                    },
                                    save: _save,
                                    newTab: _new,
                                    editAddress: _addressFocus.requestFocus,
                                    recreate: () {
                                      browserWebViewCache.remove(item.id);
                                      setState(() {
                                        item.viewGeneration++;
                                        item.loading = true;
                                        item.pageReady = false;
                                      });
                                    },
                                  ),
                                ),
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
    required this.recreate,
  });
  final BrowserTab tab;
  final bool active;
  final VoidCallback changed;
  final VoidCallback save;
  final void Function(String) newTab;
  final VoidCallback editAddress;
  final VoidCallback recreate;
  @override
  State<_BrowserTabView> createState() => _BrowserTabViewState();
}

class _BrowserTabViewState extends State<_BrowserTabView> {
  late final lease = browserWebViewCache.acquire(widget.tab.id);
  late final retained = lease.created;
  late final webview = _createWebView();
  late final preview = browserSessionStore.preview(widget.tab.id);
  bool _revealed = false;
  InAppWebViewController? controller;
  WebTranslationBridge? bridge;
  late int restoreX = widget.tab.x, restoreY = widget.tab.y;
  bool loadError = false;
  bool rendererGone = false;
  bool get loading => widget.tab.loading;
  bool _imageMenuOpen = false;
  double progress = 0;
  String? loadingUrl;
  int navigation = 0;
  int activeMatch = 0, matches = 0;
  late final finder = FindInteractionController(
    onFindResultReceived: (_, ordinal, count, done) {
      if (mounted && widget.active && widget.tab.findOpen && done) {
        setState(() {
          activeMatch = count == 0 ? 0 : ordinal + 1;
          matches = count;
        });
      }
    },
  );

  Future<void> _find(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      if (mounted && widget.active) {
        showNodeLaneNotice(
          context.l10n.browser_action_failed,
          kind: NodeLaneNoticeKind.error,
        );
      }
    }
  }

  Future<void> _recordVisit() async {
    final tab = widget.tab, epoch = navigation, url = widget.tab.url;
    try {
      // shortcut: SVG-only sites use /favicon.ico, add SVG decoding if needed.
      final icon = await tab.controller?.evaluateJavascript(
        source: r'''
(() => {
  const links = [...document.querySelectorAll('link[rel~="icon"], link[rel^="apple-touch-icon"]')];
  const icons = links.filter(link => /^https?:/.test(link.href) &&
    link.type !== 'image/svg+xml' && !/\.svg(?:[?#]|$)/i.test(link.href));
  return (icons.find(link => link.rel.startsWith('apple-touch-icon')) ||
    icons.find(link => link.type === 'image/png' || /\.png(?:[?#]|$)/i.test(link.href)) ||
    icons[0])?.href || null;
})()
''',
      );
      if (!mounted || epoch != navigation || tab.url != url) return;
      tab.iconUrl = isBrowserUrl(icon) ? icon as String : null;
    } catch (_) {}
    if (!mounted || epoch != navigation || tab.url != url) return;
    try {
      await browserLibraryStore.visit(url, tab.title, iconUrl: tab.iconUrl);
    } catch (_) {
      if (mounted && widget.active) {
        showNodeLaneNotice(
          context.l10n.browser_data_failed,
          kind: NodeLaneNoticeKind.error,
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bridge?.updatePresentation(translationImageTheme(context), context.l10n);
  }

  Future<void> _visibility({bool? active}) async {
    final controller = this.controller;
    if (controller == null) return;
    final visible = active ?? widget.active;
    try {
      await Future.wait([
        if (Platform.isAndroid)
          visible ? controller.resume() : controller.pause(),
        if (Platform.isIOS && !visible) controller.pauseAllMediaPlayback(),
        if (!visible)
          controller.evaluateJavascript(
            source: "document.querySelectorAll('video,audio').forEach(media => media.pause())",
          ),
      ]);
    } catch (_) {}
  }

  @override
  void didUpdateWidget(_BrowserTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) {
      _visibility();
      if (!widget.active && widget.tab.findOpen) {
        widget.tab.findOpen = false;
        _find(finder.clearMatches);
      }
    }
  }

  @override
  void deactivate() {
    // Pause before the child disposes its channel; the plugin owns its controllers.
    unawaited(_visibility(active: false));
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    unawaited(_visibility());
  }

  @override
  void dispose() {
    bridge?.dispose();
    if (identical(widget.tab.controller, controller)) {
      widget.tab.controller = null;
      widget.tab.captureAnchor = null;
      widget.tab.pageReady = false;
    }
    browserWebViewCache.release(lease);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (widget.tab.findOpen && widget.active)
        MobileBrowserFindBar(
          current: activeMatch,
          total: matches,
          onFind: (text) {
            setState(() {
              activeMatch = 0;
              matches = 0;
            });
            _find(
              () => text.isEmpty
                  ? finder.clearMatches()
                  : finder.findAll(find: text),
            );
          },
          onNext: (forward) => _find(() => finder.findNext(forward: forward)),
          onClose: () {
            setState(() => widget.tab.findOpen = false);
            _find(finder.clearMatches);
          },
        ),
      Expanded(child: _buildPage(context)),
    ],
  );

  Widget _buildPage(BuildContext context) => Stack(
    children: [
      webview,
      if (preview != null)
        Positioned.fill(
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: AnimatedSwitcher(
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 120),
                child: _revealed
                    ? const SizedBox.expand()
                    : SizedBox.expand(
                        key: const ValueKey('browser-page-preview'),
                        child: Image.memory(
                          preview!,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        ),
                      ),
              ),
            ),
          ),
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
            onRetry: rendererGone
                ? widget.recreate
                : () => widget.tab.controller?.loadUrl(
                    urlRequest: URLRequest(
                      url: WebUri(loadingUrl ?? widget.tab.url),
                    ),
                  ),
          ),
        ),
    ],
  );

  InAppWebView _createWebView() => InAppWebView(
    keepAlive: lease.keepAlive,
    findInteractionController: finder,
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
      useOnRenderProcessGone: true,
    ),
    onWebViewCreated: (controller) {
      if (!mounted) return;
      final reused = retained;
      lease.created = true;
      this.controller = controller;
      widget.tab.controller = controller;
      bridge = WebTranslationBridge(
        controller,
        widget.tab.translation,
        widget.tab.id,
        l10n: context.l10n,
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
      if (reused) unawaited(_resumeDocument(controller));
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
      if (mounted && widget.active && gesture && isBrowserUrl(url)) {
        widget.newTab(url!);
      }
      return false;
    },
    onRenderProcessGone: (_, _) => _rendererGone(),
    onWebContentProcessDidTerminate: (_) => _rendererGone(),
    onLoadStart: (controller, url) {
      if (!mounted) return;
      navigation++;
      setState(() {
        widget.tab.loading = true;
        widget.tab.findOpen = false;
        loadError = false;
        lease.loadFailed = false;
        progress = 0;
        loadingUrl = url?.toString();
      });
      bridge?.navigate();
      if (url?.toString() != widget.tab.url) {
        browserSessionStore.clearPreview(widget.tab.id);
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
    onPageCommitVisible: (_, _) {
      if (!retained) _revealPage();
    },
    onLoadStop: (controller, url) async {
      if (url == null || !mounted || loadError) return;
      final epoch = navigation;
      widget.tab.visited(url.toString());
      final title = await controller.getTitle() ?? '';
      if (!mounted || epoch != navigation) return;
      widget.tab.title = title;
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
      setState(() => widget.tab.loading = false);
      widget.tab.pageReady = true;
      _revealPage();
      widget.changed();
      unawaited(_recordVisit());
    },
    onUpdateVisitedHistory: (controller, url, isReload) async {
      if (!mounted ||
          url == null ||
          loading ||
          url.toString() == widget.tab.url) {
        return;
      }
      navigation++;
      bridge?.navigate();
      widget.tab.visited(url.toString());
      try {
        await bridge?.install(Uri.parse(url.toString()));
      } catch (_) {}
      if (mounted && widget.tab.url == url.toString()) {
        widget.changed();
        unawaited(_recordVisit());
      }
    },
    onScrollChanged: (controller, x, y) {
      if (mounted && widget.active && !loading) {
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
      if (!mounted || progress == value / 100) return;
      progress = value / 100;
      if (widget.active && loading) setState(() {});
    },
    onReceivedError: (_, request, error) {
      if (!mounted ||
          request.isForMainFrame != true ||
          error.type == WebResourceErrorType.CANCELLED ||
          request.url.toString() != (loadingUrl ?? widget.tab.url)) {
        return;
      }
      setState(() {
        widget.tab.loading = false;
        loadError = true;
        lease.loadFailed = true;
      });
      widget.tab.pageReady = false;
      widget.changed();
      _revealPage();
    },
  );

  Future<void> _resumeDocument(InAppWebViewController controller) async {
    final epoch = navigation;
    try {
      final url = await controller.getUrl();
      final title = await controller.getTitle();
      final isLoading = await controller.isLoading();
      if (!mounted || epoch != navigation) return;
      if (lease.loadFailed) {
        setState(() {
          widget.tab.loading = false;
          loadError = true;
        });
        widget.changed();
        return;
      }
      if (url == null || !isBrowserUrl(url.toString())) {
        throw StateError('Retained page unavailable');
      }
      widget.tab.visited(url.toString());
      widget.tab.title = title ?? widget.tab.title;
      if (!isLoading) {
        await bridge?.install(Uri.parse(url.toString()));
        if (!mounted || epoch != navigation) return;
        // Native DOM, forms, JS state and scroll already belong to this document.
        widget.tab.pageReady = true;
      }
      setState(() => widget.tab.loading = isLoading);
      widget.tab.translation.configure(foreground: widget.active);
      _revealPage();
      widget.changed();
    } catch (_) {
      if (mounted && epoch == navigation) {
        setState(() {
          widget.tab.loading = false;
          loadError = true;
          rendererGone = true;
        });
      }
    }
  }

  void _revealPage() {
    if (!mounted || _revealed) return;
    // Fade only the lightweight preview after the native surface joins a frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_revealed) setState(() => _revealed = true);
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _rendererGone() {
    if (!mounted) return;
    navigation++;
    bridge?.navigate();
    browserWebViewCache.remove(widget.tab.id);
    setState(() {
      rendererGone = true;
      loadError = true;
      widget.tab.loading = false;
      widget.tab.pageReady = false;
    });
    widget.changed();
  }
}
