import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';

import 'dart:async';

import 'package:mangayomi/modules/feedback/support_request_page.dart';
import 'package:mangayomi/services/support_requests.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show CustomSemanticsAction;
import 'package:flutter/gestures.dart'
    show kLongPressTimeout, kPrimaryButton, kTouchSlop;
import 'package:mangayomi/theme/nodelane_motion.dart';
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
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';

import 'browser_session_store.dart';
import 'browser_focus_tools.dart';
import 'browser_webview_cache.dart';
import 'browser_page_controller.dart';
import 'browser_protection_panel.dart';
import 'gecko_browser_page.dart';
import 'reader_transport.dart';
import 'browser_tabs_panel.dart';

import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:mangayomi/modules/translation/translation_upgrade.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/services/translation/identity.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/repositories/browser_reader_repository.dart';

import 'translation_bridge.dart';
import 'browser_url.dart';
import 'browser_navigation.dart';
import 'mobile_browser_widgets.dart';
import 'browser_library_store.dart';
import 'browser_library_panel.dart';
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
  List<String> _savedBack = const [], _savedForward = const [];
  bool _reattached = false;
  bool get isBlank => url.isEmpty;
  bool pageReady = false;
  bool chapter = false;
  bool focusToolsOpen = false;
  String? nextChapter, focusOnChapter;
  bool get focused => pageReady && chapter && focusOnChapter == url;
  int document = 0;
  void resetReading() {
    document++;
    focusToolsOpen = chapter = pageReady = false;
    nextChapter = null;
  }

  bool readable = false,
      nativeBack = false,
      nativeForward = false,
      needsRecreate = false;
  bool canMove(int delta) => delta < 0
      ? nativeBack || historyIndex > 0
      : nativeForward || historyIndex + 1 < history.length;
  bool loading = true, findOpen = false;
  final translation = TranslationViewController();
  BrowserPageController? controller;
  Future<Map<String, dynamic>?> Function()? captureAnchor;
  Future<void> Function(Map<String, dynamic>?)? restoreAnchor;
  ({String url, Map<String, dynamic> anchor})? pendingClip;
  Map<String, dynamic>? anchor;
  void visited(String value) {
    if (!isBrowserUrl(value)) return;
    if (value != url && focusOnChapter != value) focusOnChapter = null;
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

  void bindHistory(bool retained) {
    _savedBack = history.take(historyIndex).toList();
    _savedForward = history.skip(historyIndex + 1).toList();
    _reattached = retained;
  }

  void nativeHistory(List<String> urls, int index) {
    if (index < 0 || index >= urls.length || urls[index] != url) return;
    final before = urls.take(index).where(isBrowserUrl).toList();
    final after = urls.skip(index + 1).where(isBrowserUrl).toList();
    nativeBack = before.isNotEmpty;
    nativeForward = after.isNotEmpty;
    if (_reattached) {
      final overlap = _savedBack.indexOf(before.firstOrNull ?? url);
      if (overlap >= 0) _savedBack = _savedBack.take(overlap).toList();
      _reattached = false;
    }
    if (nativeBack || nativeForward) _savedForward = const [];
    final merged = [..._savedBack, ...before, url, ...after, ..._savedForward];
    final cursor = _savedBack.length + before.length;
    final start = (merged.length - 20).clamp(0, cursor);
    historyIndex = cursor - start;
    history
      ..clear()
      ..addAll(merged.skip(start).take(20));
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'title': title,
    'x': x,
    'y': y,
    'history': [...history],
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
    this.clipAnchor,
  });
  final String url, title;
  final String? tabId;
  final Map<String, dynamic>? clipAnchor;
  @override
  ConsumerState<MobileComicBrowser> createState() => _MobileComicBrowserState();
}

class _MobileComicBrowserState extends ConsumerState<MobileComicBrowser>
    with WidgetsBindingObserver {
  final tabs = <BrowserTab>[];
  final _mountedTabs = <String>[];
  final _previewing = <String>{};
  final _addressFocus = FocusNode();
  final _tabsButton = GlobalKey();
  final _translationButton = GlobalKey();
  String? active;
  Timer? _saveTimer;
  int _saveEpoch = 0;
  bool _editingTabs = false, _saveFailed = false;
  bool _readingSaveFailed = false;
  bool foreground = true, ready = false, _inReader = false, _clipping = false;
  bool get _visible => foreground && !_leaving && !_inReader;
  bool _useGecko = false, _restoreFailed = false;
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
      if (Platform.isAndroid) {
        _useGecko = await GeckoBrowserPage.supported();
        if (!mounted) return;
      }
      await browserSessionStore.load();
      if (!mounted) return;
      tabs.addAll(
        browserSessionStore.entries.map(BrowserTab.fromJson).nonNulls,
      );
    } catch (_) {
      if (mounted) setState(() => _restoreFailed = true);
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
    final anchor = BrowserPageEntry.readingPosition(widget.clipAnchor);
    if (!atLimit && tab.url == widget.url && anchor != null) {
      tab.pendingClip = (url: tab.url, anchor: anchor);
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
        foreground: _visible && tab.id == active && !tab.isBlank,
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
    if (_editingTabs || _leaving || _inReader || !ready) return;
    final epoch = ++_saveEpoch;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 400), () async {
      final tab = current;
      try {
        if (tab != null && foreground) await _captureAnchor(tab);
        if (!mounted || epoch != _saveEpoch || _inReader) return;
        unawaited(_rememberReading(tab));
        await browserSessionStore.save(_entries);
        _saveFailed = false;
      } catch (_) {
        if (mounted && !_saveFailed) {
          _saveFailed = true;
          showNodeLaneNotice(
            context.l10n.browser_save_failed,
            kind: NodeLaneNoticeKind.error,
            actionLabel: context.l10n.retry,
            onAction: () {
              _saveFailed = false;
              if (mounted) _save();
            },
          );
        }
      }
    });
  }

  Future<void> _rememberReading(
    BrowserTab? tab, {
    Future<Uint8List?>? frame,
  }) async {
    if (!mounted ||
        tab == null ||
        !tab.chapter ||
        !tab.pageReady ||
        tab.pendingClip != null ||
        _clipping) {
      return;
    }
    final position =
        tab.anchor ??
        (tab.x == 0 && tab.y == 0 ? null : {'x': tab.x, 'y': tab.y});
    if (position == null) return;
    final doc = tab.document, x = tab.x, y = tab.y;
    try {
      await browserLibraryStore.saveReading(
        tab.url,
        tab.title,
        anchor: position,
        iconUrl: tab.iconUrl,
        firstPreview: () async =>
            frame ??
            (mounted &&
                    _visible &&
                    current == tab &&
                    doc == tab.document &&
                    x == tab.x &&
                    y == tab.y
                ? _capturePreview(tab)
                : null),
      );
      _readingSaveFailed = false;
    } catch (_) {
      if (mounted && !_readingSaveFailed) {
        _readingSaveFailed = true;
        showNodeLaneNotice(
          context.l10n.browser_data_failed,
          kind: NodeLaneNoticeKind.error,
          actionLabel: context.l10n.retry,
          onAction: () {
            if (mounted && current == tab && doc == tab.document) _save();
          },
        );
      }
    }
  }

  Future<void> _captureAnchor(BrowserTab tab) async {
    final x = tab.x, y = tab.y, url = tab.url, doc = tab.document;
    try {
      final anchor = await tab.captureAnchor?.call().timeout(
        const Duration(seconds: 2),
      );
      // Hiding a page can resize its viewport. A late capture must not replace
      // the reading position with the hidden view's clamped scroll offset.
      if (anchor != null &&
          tabs.contains(tab) &&
          tab.url == url &&
          tab.document == doc &&
          tab.x == x &&
          tab.y == y &&
          anchor['x'] is num &&
          anchor['y'] is num &&
          ((_visible && current == tab) ||
              (((anchor['x'] as num) - x).abs() < 2 &&
                  ((anchor['y'] as num) - y).abs() < 2))) {
        tab.anchor = anchor;
      }
    } catch (_) {}
  }

  Future<Uint8List?> _capturePreview(BrowserTab tab) async {
    if (tab.isBlank || !tab.pageReady || !_previewing.add(tab.id)) return null;
    final controller = tab.controller, url = tab.url, x = tab.x, y = tab.y;
    final document = tab.document;
    try {
      final bytes = await controller?.preview().timeout(
        const Duration(seconds: 2),
      );
      if (mounted &&
          tabs.contains(tab) &&
          identical(tab.controller, controller) &&
          tab.url == url &&
          tab.document == document &&
          tab.x == x &&
          tab.y == y &&
          bytes != null) {
        browserSessionStore.setPreview(tab.id, bytes);
        return bytes;
      }
    } catch (_) {
    } finally {
      _previewing.remove(tab.id);
    }
    return null;
  }

  Future<void> _leave({bool toStart = false, BrowserTab? previous}) async {
    if (!mounted || _leaving || _editingTabs) return;
    setState(() => _leaving = true);
    ++_saveEpoch;
    _saveTimer?.cancel();
    final tab = previous ?? current;
    if (tab != null) {
      final frame = _capturePreview(tab);
      await _captureAnchor(tab);
      unawaited(_rememberReading(tab, frame: frame));
    }
    if (!mounted) return;
    try {
      await browserSessionStore.save(_entries);
    } catch (_) {
      if (mounted) {
        setState(() {
          _leaving = false;
          _saveFailed = true;
          if (previous != null && tabs.contains(previous)) active = previous.id;
        });
        _attach();
        showNodeLaneNotice(
          context.l10n.browser_save_failed,
          kind: NodeLaneNoticeKind.error,
        );
      }
      return;
    }
    if (!mounted) return;
    setState(() => _savedOnExit = true);
    _attach();
    if (toStart) {
      if (mounted) context.go('/browser');
    } else {
      await WidgetsBinding.instance.endOfFrame;
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _select(BrowserTab tab) async {
    if (!mounted || _editingTabs || !tabs.contains(tab) || active == tab.id) {
      return;
    }
    _addressFocus.unfocus();
    final previous = current;
    if (tab.isBlank) {
      active = tab.id;
      _attach();
      await _leave(toStart: true, previous: previous);
      return;
    }
    if (previous != null) {
      unawaited(_rememberReading(previous));
      unawaited(_captureAnchor(previous));
    }
    active = tab.id;
    _retainView(tab);
    _attach();
    setState(() {});
    _save();
  }

  Future<void> _new(String url, {bool background = false}) async {
    if (_editingTabs || _leaving) return;
    if (url.isNotEmpty && !isBrowserUrl(url)) return;
    if (tabs.length >= BrowserSessionStore.maxTabs) {
      _tabLimit();
      return;
    }
    final tab = BrowserTab(url);
    tabs.add(tab);
    if (background) {
      tab.translation.configure(foreground: false);
      setState(() {});
      _save();
    } else {
      await _select(tab);
    }
  }

  Future<List<Map<String, dynamic>>> _editTabs([String? closeId]) async {
    _editingTabs = true;
    ++_saveEpoch;
    _saveTimer?.cancel();
    try {
      if (closeId == null) {
        await browserSessionStore.undoClose(snapshot: _entries);
      } else {
        final target = current;
        if (target?.id == closeId) {
          await _captureAnchor(target!);
          unawaited(_rememberReading(target));
        }
        await browserSessionStore.close(closeId, snapshot: _entries);
      }
      final entries = browserSessionStore.entries;
      if (!mounted) return entries;
      final previous = {for (final t in tabs) t.id: t};
      tabs.clear();
      for (final e in entries) {
        final t = previous.remove(e['id']) ?? BrowserTab.fromJson(e)!;
        tabs.add(t);
        if (e['active'] == true) active = t.id;
      }
      for (final t in previous.values) {
        _mountedTabs.remove(t.id);
        browserWebViewCache.remove(t.id);
        t.translation.dispose();
      }
      _retainView(current!);
      _attach();
      setState(() {});
      return entries;
    } finally {
      _editingTabs = false;
      if (mounted && !_showingTabs && current?.isBlank == true) {
        _leave(toStart: true);
      }
    }
  }

  void _tabLimit() {
    showNodeLaneNotice(
      context.l10n.browser_tab_limit(BrowserSessionStore.maxTabs),
    );
    _showTabs(_tabsButton.currentContext ?? context);
  }

  void _openAddress(String url, {Map<String, dynamic>? clipAnchor}) {
    final tab = current;
    if (tab == null || !isBrowserUrl(url)) return;
    tab.pendingClip = clipAnchor == null
        ? null
        : (url: url, anchor: clipAnchor);
    if (clipAnchor != null &&
        tab.url == url &&
        tab.pageReady &&
        tab.restoreAnchor != null) {
      tab.pendingClip = null;
      tab.restoreAnchor!(clipAnchor).catchError((_) {
        if (mounted && current == tab && tab.url == url) {
          showNodeLaneNotice(
            context.l10n.browser_action_failed,
            kind: NodeLaneNoticeKind.error,
          );
        }
      });
      return;
    }
    if (tab.needsRecreate || tab.controller == null) {
      tab.visited(url);
      tab.anchor = null;
      tab.x = tab.y = 0;
      _recreate(tab);
    } else {
      tab.controller!.load(url).catchError((_) {
        if (mounted && current == tab) {
          showNodeLaneNotice(
            context.l10n.browser_action_failed,
            kind: NodeLaneNoticeKind.error,
          );
        }
      });
    }
  }

  void _recreate(BrowserTab tab) {
    browserWebViewCache.remove(tab.id);
    setState(() {
      tab.viewGeneration++;
      tab.resetReading();
      tab.loading = true;
      tab.nativeBack = tab.nativeForward = tab.readable = tab.needsRecreate =
          false;
    });
    _save();
  }

  Future<void> _clip(
    BrowserTab tab, {
    Map<String, dynamic>? position,
    Future<Uint8List?>? thumbnail,
  }) async {
    if (_clipping || !tab.pageReady || current != tab) return;
    final url = tab.url, document = tab.document, l = context.l10n;
    bool samePage() =>
        mounted &&
        _visible &&
        current == tab &&
        tab.url == url &&
        tab.document == document &&
        tab.pageReady;
    setState(() => _clipping = true);
    try {
      if (position == null) {
        // Capture both against the tap's viewport; a retry keeps this original pair.
        final x = tab.x, y = tab.y;
        thumbnail = _capturePreview(tab);
        position = BrowserPageEntry.readingPosition(
          await tab.captureAnchor?.call(),
        );
        if (tab.x != x || tab.y != y) thumbnail = null;
      }
      if (!samePage()) return;
      if (position == null) throw StateError('Reading position unavailable');
      await browserLibraryStore.saveReading(
        url,
        tab.title,
        iconUrl: tab.iconUrl,
        anchor: position,
        thumbnail: thumbnail ?? Future<Uint8List?>.value(),
      );
      if (samePage()) showNodeLaneNotice(l.browser_clip_saved);
    } catch (_) {
      if (samePage()) {
        showNodeLaneNotice(
          l.browser_data_failed,
          kind: NodeLaneNoticeKind.error,
          actionLabel: l.retry,
          onAction: () {
            if (samePage()) {
              _clip(tab, position: position, thumbnail: thumbnail);
            }
          },
        );
      }
    } finally {
      if (mounted) setState(() => _clipping = false);
    }
  }

  Future<void> _toggleFocus(BrowserTab tab) async {
    final old = tab.focused, document = tab.document;
    bool currentPage() =>
        mounted &&
        _visible &&
        current == tab &&
        tab.document == document &&
        tab.chapter &&
        tab.pageReady;
    if (!currentPage()) return;
    final anchor = await tab.captureAnchor?.call();
    if (!currentPage() || tab.focused != old) return;
    setState(() => tab.focusOnChapter = old ? null : tab.url);
    // A site may size its panels in vh. Resizing native chrome changes their height.
    await WidgetsBinding.instance.endOfFrame;
    if (currentPage() && tab.focused != old && anchor != null) {
      await tab.restoreAnchor?.call(anchor).catchError((_) {});
    }
  }

  void _nextChapter(BrowserTab tab) {
    final next = tab.nextChapter;
    if (next == null || !tab.pageReady || !tab.chapter) return;
    tab.focusOnChapter = tab.focused ? next : null;
    _openAddress(next);
  }

  Widget _focusTools(BrowserTab tab, VoidCallback dismiss) => ListenableBuilder(
    listenable: tab.translation,
    builder: (context, _) => BrowserFocusTools(
      onClose: dismiss,
      translated: tab.translation.showTranslation,
      onExit: () => _toggleFocus(tab),
      onClip: _clipping ? null : () => _clip(tab),
      onDisplay: (value) {
        tab.translation.configure(showTranslation: value);
        _save();
      },
      onNext: tab.nextChapter == null ? null : () => _nextChapter(tab),
    ),
  );

  Future<void> _showTabs(BuildContext anchor) async {
    if (_showingTabs) return;
    _showingTabs = true;
    try {
      final selected = current;
      if (selected != null) {
        unawaited(_capturePreview(selected));
        unawaited(_captureAnchor(selected));
      }
      if (!mounted) return;
      final action = await showNodeLaneBubble<String>(
        anchor,
        label: context.l10n.tabs,
        width: NodeLaneTokens.bubblePanelWidth,
        child: BrowserTabsPanel(
          entries: _entries,
          onClose: _editTabs,
          onUndo: _editTabs,
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

  Future<void> _translationControls(BuildContext anchor, BrowserTab tab) async {
    await showTranslationControls(
      anchor,
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

  Future<void> _openReader(BrowserTab tab, BrowserReaderTarget target) async {
    final document = tab.document;
    await _captureAnchor(tab);
    if (!mounted || current != tab || document != tab.document) return;
    unawaited(_rememberReading(tab));
    ++_saveEpoch;
    _saveTimer?.cancel();
    final snapshot = _entries;
    await browserSessionStore.save(snapshot);
    if (!mounted || current != tab || document != tab.document) return;
    // The native reader can open its own browser route. Release these views first.
    setState(() {
      _inReader = true;
      _mountedTabs.clear();
    });
    _attach();
    try {
      await WidgetsBinding.instance.endOfFrame;
      if (mounted) {
        await context.push(
          target.chapter ? '/mangaReaderView' : '/manga-reader/detail',
          extra: target.id,
        );
      }
    } finally {
      if (mounted) {
        final latest = browserSessionStore.entries;
        if (!identical(latest, snapshot)) {
          for (final t in tabs) {
            t.translation.dispose();
          }
          tabs
            ..clear()
            ..addAll(latest.map(BrowserTab.fromJson).nonNulls);
          active =
              latest
                      .where((entry) => entry['active'] == true)
                      .firstOrNull?['id']
                  as String? ??
              tabs.firstOrNull?.id;
        }
        if (current case final resumed?) _retainView(resumed);
        setState(() => _inReader = false);
        _attach();
        if (current?.isBlank != false) await _leave(toStart: true);
      }
    }
  }

  Future<void> _showMenu(BuildContext anchor, BrowserTab tab) async {
    final l = context.l10n;
    final pageUrl = tab.url, document = tab.document;
    bool samePage() =>
        mounted &&
        current == tab &&
        tab.url == pageUrl &&
        tab.document == document;
    BrowserReaderTarget? target;
    try {
      target = await findBrowserReaderTarget(pageUrl);
    } catch (_) {}
    if (!samePage() ||
        !anchor.mounted ||
        ModalRoute.of(anchor)?.isCurrent != true) {
      return;
    }
    final bookmarked = browserLibraryStore.isBookmarked(tab.url);
    final chapter = tab.pageReady && tab.chapter && !tab.findOpen;
    final next = tab.nextChapter;
    final action = await showBrowserPageMenu(
      anchor,
      canForward: tab.canMove(1),
      bookmarked: bookmarked,
      pageReady: tab.readable,
      clearingLogins: _clearingLogins,
      hasReader: target != null,
      canClip: tab.pageReady,
      canFocus: chapter,
      hasNextChapter: chapter && next != null,
    );
    if (!mounted || !samePage() || action == null) {
      return;
    }
    try {
      switch (action) {
        case 'focus':
          await _toggleFocus(tab);
        case 'next':
          if (tab.nextChapter == next) _nextChapter(tab);
        case 'clip':
          await _clip(tab);
        case 'reader':
          if (target == null) return;
          final checked = await findBrowserReaderTarget(pageUrl);
          if (!mounted || !samePage()) return;
          if (checked != target || checked == null) {
            throw StateError('Reader target changed');
          }
          await _openReader(tab, checked);
        case 'requestSource':
          await showSupportRequest(
            context,
            SupportRequestKind.website,
            website: pageUrl,
          );
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
          final bookmarks = action == 'bookmarks';
          if (!anchor.mounted) return;
          final entry = await BrowserLibraryPanel.show(
            anchor,
            store: browserLibraryStore,
            collection: bookmarks
                ? BrowserCollection.bookmarks
                : BrowserCollection.history,
          );
          if (samePage() && entry != null) {
            _openAddress(
              entry.url,
              clipAnchor: bookmarks ? entry.anchor : null,
            );
          }
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
        case 'siteCookies':
          await _clearLogins(tab);
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

  Future<void> _clearLogins([BrowserTab? site]) async {
    if (_clearingLogins) return;
    _clearingLogins = true;
    try {
      final url = site?.url;
      final host = url == null ? null : Uri.parse(url).host;
      final confirmed = await confirmClearBrowserLogins(context, host: host);
      if (!mounted ||
          !confirmed ||
          (site != null && (site != current || site.url != url))) {
        return;
      }
      for (final item in tabs) {
        if (host == null || Uri.tryParse(item.url)?.host == host) {
          item.translation.configure(showTranslation: false);
        }
      }
      if (url == null) {
        if (_useGecko) await GeckoBrowserPage.clearCookies();
        await CookieManager.instance().deleteAllCookies();
        await MClient.deleteAllCookies();
      } else if (_useGecko) {
        final protection = site?.controller?.protection;
        if (protection == null) throw StateError('Site unavailable');
        await protection.perform(url, SiteProtectionAction.clearSite);
      } else {
        await CookieManager.instance().deleteCookies(
          url: WebUri(url),
          domain: host,
        );
        await MClient.deleteAllCookies(url);
      }
      if (mounted && (site == null || (current == site && site.url == url))) {
        await current?.controller?.reload();
      }
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

  Future<void> _protectionAction(
    BrowserTab tab,
    BrowserProtection protection,
    SiteProtectionAction action,
  ) async {
    if (!mounted ||
        current != tab ||
        tab.controller?.protection != protection) {
      return;
    }
    final url = tab.url;
    try {
      if (action == SiteProtectionAction.clearSite) {
        await _clearLogins(tab);
      } else {
        await protection.perform(url, action);
      }
    } catch (_) {
      if (mounted) {
        showNodeLaneNotice(
          context.l10n.browser_action_failed,
          kind: NodeLaneNoticeKind.error,
        );
      }
    }
  }

  Future<void> _history(int delta) async {
    final tab = current;
    if (tab == null || !tab.canMove(delta)) return;
    final next = tab.historyIndex + delta;
    final target = next >= 0 && next < tab.history.length
        ? tab.history[next]
        : null;
    final old = tab.historyIndex;
    if (target != null) tab.historyIndex = next;
    try {
      if (await tab.controller?.traverse(delta) == true) return;
      if (!mounted || current != tab || target == null) return;
      tab.visited(target);
      tab.x = tab.y = 0;
      tab.anchor = null;
      _recreate(tab);
    } catch (_) {
      if (mounted && current == tab) {
        tab.historyIndex = old.clamp(0, tab.history.length - 1);
        showNodeLaneNotice(
          context.l10n.browser_action_failed,
          kind: NodeLaneNoticeKind.error,
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    service.removeListener(_attach);
    browserLibraryStore.removeListener(_libraryChanged);
    _saveTimer?.cancel();
    _addressFocus.dispose();
    if (ready && !_savedOnExit && !_inReader) {
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
    final focused = tab?.focused == true;
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom != 0;
    final width =
        MediaQuery.sizeOf(context).width -
        MediaQuery.paddingOf(context).horizontal;
    final inline = context.hasPaneWidth(width);
    final toolbar = tab == null || tab.isBlank || focused || keyboardOpen
        ? null
        : ListenableBuilder(
            listenable: tab.translation,
            builder: (context, _) => MobileBrowserToolbar(
              inline: inline,
              tabCount: tabs.length,
              onBack: tab.canMove(-1) ? () => _history(-1) : null,
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
                  : (anchor) => _translationControls(anchor, tab),
              onTabs: _showTabs,
              tabsKey: _tabsButton,
              controlsKey: _translationButton,
            ),
          );
    return PopScope(
      canPop: _savedOnExit || tab == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_leaving) {
          if (tab?.focusToolsOpen == true) {
            setState(() => tab!.focusToolsOpen = false);
          } else if (tab?.focused == true) {
            _toggleFocus(tab!);
          } else if (tab?.canMove(-1) == true) {
            _history(-1);
          } else {
            _leave();
          }
        }
      },
      child: NodeLaneSurface(
        child: Scaffold(
          body: SafeArea(
            top: focused,
            left: focused,
            right: focused,
            bottom: inline && toolbar != null,
            child: Column(
              children: [
                if (tab != null && !tab.isBlank && !focused)
                  MobileBrowserHeader(
                    key: ValueKey(tab.id),
                    url: tab.url,
                    addressFocus: _addressFocus,
                    onSubmitted: _openAddress,
                    openTabs: tabs.map(
                      (t) => {'id': t.id, 'url': t.url, 'title': t.title},
                    ),
                    onMatch: (m) {
                      final existing = tabs
                          .where((t) => t.id == m.tabId)
                          .firstOrNull;
                      if (existing == null) {
                        _openAddress(m.url, clipAnchor: m.bookmark?.anchor);
                      } else {
                        _select(existing);
                      }
                    },
                    onClose: _leave,
                    onReload: () async {
                      try {
                        if (tab.needsRecreate) {
                          _recreate(tab);
                        } else if (tab.loading) {
                          await tab.controller?.stop();
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
                    toolbar: inline ? toolbar : null,
                    protection: switch (tab.controller?.protection) {
                      null => null,
                      final protection => BrowserProtectionButton(
                        key: ValueKey((tab.id, tab.document)),
                        protection: protection,
                        ready: tab.readable && !tab.loading,
                        url: tab.url,
                        onAction: (action) =>
                            _protectionAction(tab, protection, action),
                      ),
                    },
                  ),
                Expanded(
                  key: const ValueKey('browser-content'),
                  child: _restoreFailed || (tab?.isBlank == true && _saveFailed)
                      ? NodeLaneEmptyState.error(
                          title: context.l10n.browser_data_failed,
                          message: context.l10n.operation_retry,
                          onRetry: () {
                            if (!ready) {
                              setState(() => _restoreFailed = false);
                              _restore();
                            } else {
                              _leave(toStart: true);
                            }
                          },
                        )
                      : !ready || tab?.isBlank == true
                      ? const NodeLaneEmptyState.loading()
                      : NodeLaneContentMotion(
                          value: active,
                          child: Stack(
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
                                    enabled: _visible && item.id == active,
                                    child: ExcludeFocus(
                                      excluding: item.id != active,
                                      child: _BrowserTabView(
                                        tab: item,
                                        useGecko: _useGecko,
                                        active: _visible && item.id == active,
                                        changed: () {
                                          if (mounted && item.id == active) {
                                            setState(() {});
                                          }
                                          _save();
                                        },
                                        save: _save,
                                        leavingDocument: () =>
                                            _rememberReading(item),
                                        newTab: _new,
                                        editAddress: _addressFocus.requestFocus,
                                        recreate: () => _recreate(item),
                                        focusTools:
                                            _visible &&
                                                item == tab &&
                                                focused &&
                                                !keyboardOpen
                                            ? (dismiss) =>
                                                  _focusTools(item, dismiss)
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
                if (!inline && toolbar != null) toolbar,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrowserTabView extends StatefulWidget {
  const _BrowserTabView({
    required this.tab,
    required this.useGecko,
    required this.active,
    required this.changed,
    required this.save,
    required this.leavingDocument,
    required this.newTab,
    required this.editAddress,
    required this.recreate,
    this.focusTools,
  });
  final BrowserTab tab;
  final bool useGecko;
  final bool active;
  final VoidCallback changed;
  final VoidCallback save;
  final VoidCallback leavingDocument;
  final void Function(String, {bool background}) newTab;
  final VoidCallback editAddress;
  final VoidCallback recreate;
  final Widget Function(VoidCallback dismiss)? focusTools;
  @override
  State<_BrowserTabView> createState() => _BrowserTabViewState();
}

class _BrowserTabViewState extends State<_BrowserTabView> {
  late final lease = browserWebViewCache.acquire(widget.tab.id);
  late final retained = lease.created;
  late final webview = widget.useGecko ? _createGeckoView() : _createWebView();
  late final preview = browserSessionStore.preview(widget.tab.id);
  bool _revealed = false;
  InAppWebViewController? controller;
  BrowserPageController? page;
  GeckoBrowserPage? gecko;
  WebTranslationBridge? bridge;
  late int restoreX = widget.tab.x, restoreY = widget.tab.y;
  bool loadError = false;
  bool get rendererGone => widget.tab.needsRecreate;
  bool extensionsFailed = false;
  bool get loading => widget.tab.loading;
  bool _imageMenuOpen = false;
  Offset? _pressPoint;
  PointerDownEvent? _focusTap;
  final _pointers = <int>{};
  double progress = 0;
  String? loadingUrl;
  int navigation = 0;
  int activeMatch = 0, matches = 0;
  late final finder = FindInteractionController(
    onFindResultReceived: (_, ordinal, count, done) {
      if (mounted &&
          widget.active &&
          widget.tab.findOpen &&
          _hasQuery &&
          done) {
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

  Future<String?> _icon(String url) async {
    try {
      // shortcut: SVG-only sites use /favicon.ico, add SVG decoding if needed.
      final icon = gecko != null
          ? (await gecko!.call(url, '', 'icon', const {}))['value']
          : await controller?.evaluateJavascript(
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
      return isBrowserUrl(icon) ? icon as String : null;
    } catch (_) {}
    return null;
  }

  Future<void> _recordVisit() async {
    final tab = widget.tab, url = tab.url;
    final icon = _icon(url)
        .timeout(const Duration(milliseconds: 400), onTimeout: () => null);
    try {
      // Queue the visit now, so a later Clear cannot be undone by a slow favicon.
      await browserLibraryStore.visit(url, tab.title, iconUrl: icon);
      final value = await icon;
      if (mounted && tab.url == url) tab.iconUrl = value;
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
    final visible = active ?? widget.active;
    if (gecko case final engine?) {
      try {
        await engine.visible(visible);
      } catch (_) {}
      return;
    }
    final controller = this.controller;
    if (controller == null) return;
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
    if (oldWidget.focusTools != null && widget.focusTools == null) {
      _focusTap = null;
      _pointers.clear();
      widget.tab.focusToolsOpen = false;
    }
    if (oldWidget.active != widget.active) {
      _visibility();
      if (!widget.active && widget.tab.findOpen) {
        widget.tab.findOpen = false;
        _find(_clearFind);
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
    gecko?.detach();
    if (identical(widget.tab.controller, page)) {
      widget.tab.controller = null;
      widget.tab.captureAnchor = null;
      widget.tab.restoreAnchor = null;
      widget.tab.resetReading();
      widget.tab.readable = false;
    }
    browserWebViewCache.release(lease);
    super.dispose();
  }

  int _findGeneration = 0;
  bool _hasQuery = false;
  Future<void> _clearFind() async {
    _findGeneration++;
    _hasQuery = false;
    activeMatch = matches = 0;
    await (gecko?.clearFind() ?? finder.clearMatches());
  }

  Future<void> _linkMenu(String url, {bool image = false}) async {
    if (!mounted || !widget.active || !isBrowserUrl(url) || _imageMenuOpen) {
      return;
    }
    final doc = widget.tab.document;
    if (image && await bridge?.imageMenuClaimed() == true) return;
    if (!mounted ||
        !widget.active ||
        widget.tab.document != doc ||
        _imageMenuOpen) {
      return;
    }
    _imageMenuOpen = true;
    final bool? confirmed;
    try {
      confirmed = await showNodeLaneBubble<bool>(
        context,
        label: Uri.parse(url).host,
        localPoint: _pressPoint,
        child: NodeLaneBubblePanel(
          title: Uri.parse(url).host,
          child: SingleChildScrollView(
            child: Builder(
              builder: (panel) => NodeLaneRow(
                title: context.l10n.browser_background_tab,
                icon: NodeLaneIcons.of(context).add,
                onTap: () => Navigator.pop(panel, true),
              ),
            ),
          ),
        ),
      );
    } finally {
      _imageMenuOpen = false;
    }
    if (confirmed == true &&
        mounted &&
        widget.active &&
        widget.tab.document == doc) {
      widget.newTab(url, background: true);
    }
  }

  Future<void> _searchText(String? text, bool forward) async {
    if (text != null) _hasQuery = text.isNotEmpty;
    final engine = gecko;
    if (engine == null) {
      await (text == null
          ? finder.findNext(forward: forward)
          : finder.findAll(find: text));
      return;
    }
    final epoch = ++_findGeneration;
    final counts = await engine.find(text, forward);
    if (mounted &&
        widget.active &&
        widget.tab.findOpen &&
        epoch == _findGeneration) {
      setState(() {
        activeMatch = counts.first;
        matches = counts.last;
      });
    }
  }

  void _hideTools() {
    if (widget.tab.focusToolsOpen) {
      setState(() => widget.tab.focusToolsOpen = false);
    }
  }

  void _showTools() {
    if (mounted &&
        !widget.tab.focusToolsOpen &&
        widget.focusTools != null &&
        !_imageMenuOpen &&
        ModalRoute.isCurrentOf(context) == true) {
      setState(() => widget.tab.focusToolsOpen = true);
    }
  }

  // Observe raw taps without entering the native page's gesture arena.
  void _pointerDown(PointerDownEvent event) {
    _pressPoint = (context.findRenderObject()! as RenderBox).globalToLocal(
      event.position,
    );
    if (widget.focusTools == null) return;
    _pointers.add(event.pointer);
    _focusTap = null;
    if (widget.tab.focusToolsOpen) {
      _hideTools();
      return;
    }
    final size = context.size!;
    if (_pointers.length == 1 &&
        event.buttons == kPrimaryButton &&
        Rect.fromCenter(
          center: size.center(Offset.zero),
          width: size.width / 2,
          height: size.height / 2,
        ).contains(event.localPosition)) {
      _focusTap = event;
    }
  }

  void _pointerUp(PointerUpEvent event) {
    final down = _focusTap;
    _focusTap = null;
    _pointers.remove(event.pointer);
    if (down != null &&
        down.pointer == event.pointer &&
        event.timeStamp - down.timeStamp < kLongPressTimeout &&
        (event.position - down.position).distance <= kTouchSlop) {
      _showTools();
    }
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
            _find(() => text.isEmpty ? _clearFind() : _searchText(text, true));
          },
          onNext: (forward) => _find(() => _searchText(null, forward)),
          onClose: () {
            setState(() => widget.tab.findOpen = false);
            _find(_clearFind);
          },
        ),
      Expanded(child: _buildPage(context)),
    ],
  );

  Widget _buildPage(BuildContext context) => Stack(
    children: [
      Semantics(
        container: widget.focusTools != null,
        explicitChildNodes: widget.focusTools != null,
        label: widget.focusTools == null ? null : context.l10n.browser_focus,
        customSemanticsActions: widget.focusTools == null
            ? null
            : {
                CustomSemanticsAction(label: context.l10n.settings_more_tools):
                    _showTools,
              },
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: _pointerDown,
          onPointerMove: widget.focusTools == null
              ? null
              : (event) {
                  final down = _focusTap;
                  if (down != null &&
                      (event.position - down.position).distance > kTouchSlop) {
                    _focusTap = null;
                  }
                },
          onPointerUp: widget.focusTools == null ? null : _pointerUp,
          onPointerCancel: widget.focusTools == null
              ? null
              : (event) {
                  _pointers.remove(event.pointer);
                  _focusTap = null;
                },
          onPointerSignal: widget.tab.focusToolsOpen
              ? (_) => _hideTools()
              : null,
          child: webview,
        ),
      ),
      if (preview != null)
        Positioned.fill(
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: AnimatedSwitcher(
                duration: NodeLaneMotion.time(context),
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
            extensionFailure: extensionsFailed,
            onEditAddress: widget.editAddress,
            onRetry: rendererGone
                ? widget.recreate
                : () =>
                      widget.tab.controller?.load(loadingUrl ?? widget.tab.url),
          ),
        ),
      if (widget.focusTools case final tools?)
        Positioned.fill(
          child: BrowserFocusOverlay(
            visible: widget.tab.focusToolsOpen,
            onReveal: _showTools,
            child: tools(_hideTools),
          ),
        ),
    ],
  );

  void _bindPage(BrowserPageController engine, ReaderTransport transport) {
    widget.tab.bindHistory(retained);
    widget.tab.controller = page = engine;
    bridge = WebTranslationBridge(
      transport,
      widget.tab.translation,
      widget.tab.id,
      l10n: context.l10n,
      theme: translationImageTheme(context),
      onUpgrade: (target) =>
          openTranslationUpgrade(context, widget.tab.translation, target),
      onReading: (chapter, next) {
        if (!mounted ||
            widget.tab.chapter == chapter && widget.tab.nextChapter == next) {
          return;
        }
        widget.tab.chapter = chapter;
        widget.tab.nextChapter = next;
        widget.changed();
      },
      onImageMenu: (target) async {
        if (!mounted || !widget.active || _imageMenuOpen) return;
        _imageMenuOpen = true;
        try {
          await showTranslationImageMenu(
            context,
            widget.tab.translation,
            target,
            localPoint: _pressPoint,
          );
        } finally {
          _imageMenuOpen = false;
        }
      },
    );
    widget.tab.captureAnchor = bridge!.captureAnchor;
    widget.tab.restoreAnchor = bridge!.restoreAnchor;
  }

  Widget _createGeckoView() {
    final key = lease.geckoId;
    lease.releaseNative = () => GeckoBrowserPage.release(key);
    return GeckoBrowserPage.view(key, (id) async {
      if (!mounted) return;
      final engine = GeckoBrowserPage(id, _geckoEvent);
      gecko = engine;
      _bindPage(engine, engine);
      try {
        _restoreGeckoPosition = !await engine.attach(
          widget.tab.url,
          widget.active,
        );
        if (mounted) {
          lease.created = true;
          await _visibility();
          widget.changed();
        }
      } on PlatformException catch (error) {
        if (mounted) {
          extensionsFailed = error.code == 'extensions';
          _rendererGone();
        }
      } catch (_) {
        if (mounted) _rendererGone();
      }
    });
  }

  bool _restoreGeckoPosition = false;
  Future<void> _geckoEvent(MethodCall event) async {
    if (!mounted) return;
    final tab = widget.tab;
    final value = event.arguments;
    switch (event.method) {
      case 'blockerPanel':
        final ticket = value as int;
        if (widget.active) {
          await GeckoBrowserPage.showTools(context, ticket);
        } else {
          await GeckoBrowserPage.releaseTools(ticket);
        }
      case 'start':
        _loadStart(value as String);
      case 'location':
        if (isBrowserUrl(value) && tab.url != value) {
          navigation++;
          bridge?.navigate();
          _changeDocument(value as String);
          tab.visited(value);
          if (tab.findOpen) _find(_clearFind);
          tab.findOpen = false;
          if (tab.readable) _recordVisit();
          widget.changed();
        }
      case 'history':
        final values = value as List;
        tab.nativeHistory((values[1] as List).cast<String>(), values[0] as int);
        widget.changed();
      case 'linkMenu':
        final link = value as List;
        if (tab.url == link[0]) {
          await _linkMenu(link[1] as String, image: link[2] == true);
        }
      case 'cancelled':
        setState(() => tab.loading = false);
        _revealPage();
        widget.changed();
      case 'retained':
      case 'stop':
        _loaded(visit: event.method == 'stop');
      case 'document':
        if (tab.url != value || loadError) return;
        if (await _installReader(
          value as String,
          restore: _restoreGeckoPosition,
        )) {
          _restoreGeckoPosition = false;
        }
      case 'error':
        _failed();
      case 'gone':
        _rendererGone();
      case 'extensionsFailed':
        extensionsFailed = true;
        _rendererGone();
      case 'newTab':
        if (widget.active && isBrowserUrl(value)) {
          widget.newTab(value as String);
        }
      case 'title':
        tab.title = value as String;
        widget.changed();
      case 'progress':
        if (widget.active && loading) {
          setState(() => progress = (value as int) / 100);
        }
      case 'scroll':
        if (widget.active &&
            !loading &&
            !_restoreGeckoPosition &&
            value is List) {
          _scrolled(value[0] as int, value[1] as int);
        }
    }
  }

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
      _bindPage(
        SystemBrowserPage(controller),
        SystemReaderTransport(controller),
      );
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
    onLongPressHitTestResult: !Platform.isAndroid
        ? null
        : (web, hit) async {
            if (hit.type == InAppWebViewHitTestResultType.SRC_ANCHOR_TYPE &&
                isBrowserUrl(hit.extra)) {
              _linkMenu(hit.extra!);
            } else if (hit.type ==
                InAppWebViewHitTestResultType.SRC_IMAGE_ANCHOR_TYPE) {
              final epoch = navigation;
              final target = (await web.requestFocusNodeHref().catchError(
                (_) => null,
              ))?.url?.toString();
              if (mounted && navigation == epoch && isBrowserUrl(target)) {
                await _linkMenu(target!, image: true);
              }
            }
          },
    onRenderProcessGone: (_, _) => _rendererGone(),
    onWebContentProcessDidTerminate: (_) => _rendererGone(),
    onLoadStart: (_, url) => _loadStart(url?.toString()),
    onPageCommitVisible: (_, _) {
      if (!retained) _revealPage();
    },
    onLoadStop: (controller, url) async {
      if (url == null || !mounted || loadError) return;
      final epoch = navigation;
      if (widget.tab.url != url.toString()) _changeDocument(url.toString());
      widget.tab.visited(url.toString());
      final title = await controller.getTitle() ?? '';
      if (!mounted || epoch != navigation) return;
      widget.tab.title = title;
      _loaded();
      _syncSystemHistory(controller);
      if (!await _installReader(url.toString(), restore: true)) return;
      try {
        final ua = await controller.evaluateJavascript(
          source: 'navigator.userAgent',
        );
        if (mounted && widget.tab.url == url.toString()) {
          await MClient.setCookie(url.toString(), ua ?? '', controller);
        }
      } catch (_) {}
    },
    onUpdateVisitedHistory: (controller, url, isReload) async {
      if (!mounted ||
          url == null ||
          loading ||
          url.toString() == widget.tab.url) {
        return;
      }
      _changeDocument(url.toString());
      widget.tab.visited(url.toString());
      if (widget.tab.findOpen) _find(_clearFind);
      widget.tab.findOpen = false;
      _loaded();
      _syncSystemHistory(controller);
      await _installReader(url.toString());
    },
    onScrollChanged: (controller, x, y) {
      if (mounted && widget.active && !loading) {
        _scrolled(x, y);
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
      _failed();
    },
  );

  void _scrolled(int x, int y) {
    widget.tab.anchor = null;
    widget.tab.x = restoreX = x;
    widget.tab.y = restoreY = y;
    widget.save();
  }

  void _loaded({bool visit = true}) {
    widget.tab.readable = true;
    setState(() => widget.tab.loading = false);
    _revealPage();
    widget.changed();
    if (visit) _recordVisit();
  }

  Future<void> _syncSystemHistory(InAppWebViewController web) async {
    try {
      final history = await web.getCopyBackForwardList();
      if (!mounted || history?.list == null) return;
      widget.tab.nativeHistory([
        for (final e in history!.list!) e.url?.toString() ?? '',
      ], history.currentIndex ?? -1);
      widget.changed();
    } catch (_) {}
  }

  // A bridge failure must leave the original page and browser tools usable.
  Future<bool> _installReader(String url, {bool restore = false}) async {
    final tab = widget.tab, epoch = ++navigation;
    tab.pageReady = false;
    try {
      await bridge!.install(Uri.parse(url));
      if (!mounted || epoch != navigation) return false;
      final clip = tab.pendingClip;
      if (clip != null && clip.url == url) {
        await bridge!.restoreAnchor(clip.anchor);
        if (!mounted || epoch != navigation) return false;
        tab.pendingClip = null;
      } else if (restore &&
          (tab.anchor != null || restoreX != 0 || restoreY != 0)) {
        final anchor =
            tab.anchor ??
            (gecko == null ? null : {'x': restoreX, 'y': restoreY});
        if (controller != null) {
          await controller!.scrollTo(x: restoreX, y: restoreY);
        }
        if (!mounted || epoch != navigation) return false;
        await bridge!.restoreAnchor(anchor);
      }
      if (!mounted || epoch != navigation) return false;
      tab.pageReady = true;
    } catch (_) {
      if (!mounted || epoch != navigation) return false;
      if (widget.active && tab.pendingClip?.url == url) {
        showNodeLaneNotice(
          context.l10n.browser_action_failed,
          kind: NodeLaneNoticeKind.error,
          actionLabel: context.l10n.retry,
          onAction: () {
            if (mounted &&
                widget.active &&
                tab.url == url &&
                epoch == navigation) {
              _installReader(url);
            }
          },
        );
      }
    }
    widget.changed();
    return true;
  }

  void _loadStart(String? url) {
    if (!mounted) return;
    if (widget.tab.findOpen) _find(_clearFind);
    navigation++;
    setState(() {
      widget.tab.loading = true;
      widget.tab.findOpen = false;
      loadError = lease.loadFailed = false;
      progress = 0;
      loadingUrl = url;
    });
    bridge?.navigate();
    _changeDocument(url);
    widget.tab.readable = false;
    if (url != null) widget.tab.visited(url);
    widget.changed();
  }

  void _changeDocument(String? url) {
    if (widget.active) widget.leavingDocument();
    _pressPoint = null;
    _focusTap = null;
    _pointers.clear();
    widget.tab.resetReading();
    if (widget.tab.pendingClip?.url != url) widget.tab.pendingClip = null;
    if (url != widget.tab.url) {
      browserSessionStore.clearPreview(widget.tab.id);
      restoreX = restoreY = 0;
      widget.tab.anchor = null;
      widget.tab.x = widget.tab.y = 0;
      widget.tab.title = '';
    }
  }

  Future<void> _resumeDocument(InAppWebViewController controller) async {
    final epoch = navigation;
    try {
      final url = await controller.getUrl();
      final title = await controller.getTitle();
      final isLoading = await controller.isLoading();
      if (!mounted || epoch != navigation) return;
      if (lease.loadFailed) {
        _failed();
        return;
      }
      if (url == null || !isBrowserUrl(url.toString())) {
        throw StateError('Retained page unavailable');
      }
      if (widget.tab.url != url.toString()) _changeDocument(url.toString());
      widget.tab.visited(url.toString());
      widget.tab.title = title ?? widget.tab.title;
      if (!isLoading) {
        _loaded(visit: false);
        _syncSystemHistory(controller);
        await _installReader(url.toString());
      } else {
        setState(() => widget.tab.loading = true);
        widget.changed();
      }
    } catch (_) {
      if (mounted && epoch == navigation) _rendererGone();
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
    _failed(recreate: true);
  }

  void _failed({bool recreate = false}) {
    if (!mounted) return;
    navigation++;
    bridge?.navigate();
    if (recreate) browserWebViewCache.remove(widget.tab.id);
    widget.tab.resetReading();
    setState(() {
      if (recreate) widget.tab.needsRecreate = true;
      loadError = lease.loadFailed = true;
      widget.tab.loading = false;
      widget.tab.readable = false;
    });
    _revealPage();
    widget.changed();
  }
}
