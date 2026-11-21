import 'package:mangayomi/providers/l10n_providers.dart';

import 'dart:async';

import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/feedback/support_request_page.dart';
import 'package:mangayomi/services/support_requests.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'browser_pinned_sources_provider.dart';
import 'browser_session_store.dart';
import 'browser_webview_cache.dart';
import 'mobile_browser_start_page.dart';
import 'browser_tabs_panel.dart';
import 'browser_library_store.dart';
import 'browser_library_panel.dart';

class MobileBrowserHome extends ConsumerStatefulWidget {
  const MobileBrowserHome({super.key});
  @override
  ConsumerState<MobileBrowserHome> createState() => _MobileBrowserHomeState();
}

class _MobileBrowserHomeState extends ConsumerState<MobileBrowserHome> {
  bool ready = false, failed = false, opening = false, showingTabs = false;

  Map<String, dynamic>? get _blank => browserSessionStore.entries
      .where((entry) => entry['active'] == true && entry['url'] == '')
      .firstOrNull;

  @override
  void initState() {
    super.initState();
    _loadTabs();
    browserLibraryStore.load().catchError((_) {
      if (mounted) {
        showNodeLaneNotice(
          context.l10n.browser_data_failed,
          kind: NodeLaneNoticeKind.error,
        );
      }
    });
  }

  Future<void> _loadTabs() async {
    setState(() => failed = false);
    try {
      await browserSessionStore.load();
      if (mounted) setState(() => ready = true);
    } catch (_) {
      if (mounted) setState(() => failed = true);
    }
  }

  Future<void> _library(
    BuildContext anchor, [
    BrowserCollection collection = BrowserCollection.history,
  ]) async {
    final entry = await BrowserLibraryPanel.show(
      anchor,
      store: browserLibraryStore,
      collection: collection,
    );
    if (mounted && entry != null) {
      await _open(entry.url, entry.title, clip: entry);
    }
  }

  Future<void> _open(
    String url,
    String title, {
    String? tabId,
    BrowserPageEntry? clip,
  }) async {
    if (opening || !ready) return;
    opening = true;
    FocusScope.of(context).unfocus();
    try {
      unawaited(
        context.push(
          '/mangawebview',
          extra: {
            'url': url,
            'title': title,
            'tabId': ?tabId ?? _blank?['id'],
            'clipAnchor': ?clip?.anchor,
          },
        ),
      );
      // Guard the transition, not the lifetime of a route that can return via go().
      await WidgetsBinding.instance.endOfFrame;
    } finally {
      opening = false;
    }
  }

  Future<void> _new() async {
    if (!await browserSessionStore.createBlank() && mounted) {
      showNodeLaneNotice(
        context.l10n.browser_tab_limit(BrowserSessionStore.maxTabs),
      );
    }
  }

  Future<void> _tabs(BuildContext anchor) async {
    if (!ready || opening || showingTabs) return;
    showingTabs = true;
    FocusScope.of(context).unfocus();
    try {
      final action = await showNodeLaneBubble<String>(
        anchor,
        label: context.l10n.tabs,
        width: NodeLaneTokens.bubbleTabsWidth,
        child: BrowserTabsPanel(
          entries: browserSessionStore.entries,
          onUndo: () async {
            await browserSessionStore.undoClose();
            return browserSessionStore.entries;
          },
          onClose: (id) async {
            await browserSessionStore.close(id);
            browserWebViewCache.remove(id);
            return browserSessionStore.entries;
          },
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
        if (entry['url'] == '') {
          await browserSessionStore.select(action);
          return;
        }
        await _open(
          entry['url'] as String,
          entry['title'] as String? ?? '',
          tabId: entry['id'] as String,
        );
      }
    } catch (_) {
      if (mounted) {
        showNodeLaneNotice(
          context.l10n.browser_save_failed,
          kind: NodeLaneNoticeKind.error,
        );
      }
    } finally {
      showingTabs = false;
    }
  }

  @override
  Widget build(BuildContext context) => NodeLaneSurface(
    child: Scaffold(
      body: failed
          ? NodeLaneEmptyState.error(
              title: context.l10n.browser_data_failed,
              onRetry: _loadTabs,
            )
          : ListenableBuilder(
              listenable: Listenable.merge([
                browserSessionStore,
                browserLibraryStore,
              ]),
              builder: (context, _) {
                return MobileBrowserStartPage(
                  key: ValueKey(_blank?['id']),
                  sources: ref.watch(browserPinnedSourcesProvider),
                  tabCount: browserSessionStore.entries.length,
                  onOpen: _open,
                  onMatch: (m) =>
                      _open(m.url, m.title, tabId: m.tabId, clip: m.bookmark),
                  reading: browserLibraryStore.reading,
                  onAllReading: (anchor) =>
                      _library(anchor, BrowserCollection.reading),
                  onResume: (entry) =>
                      _open(entry.url, entry.title, clip: entry),
                  onRequestSource: () =>
                      showSupportRequest(context, SupportRequestKind.website),
                  onTabs: ready ? _tabs : null,
                  onManage: () => context.go('/browse'),
                  bottomInset: pageBottomInsets(context).bottom,
                  engine: browserLibraryStore.engine,
                  history: browserLibraryStore.history,
                  onEngine: browserLibraryStore.setEngine,
                  onHistory: _library,
                  onBookmarks: (anchor) =>
                      _library(anchor, BrowserCollection.bookmarks),
                );
              },
            ),
    ),
  );
}
