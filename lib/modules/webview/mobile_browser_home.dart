import 'package:mangayomi/providers/l10n_providers.dart';

import 'dart:async';

import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'browser_pinned_sources_provider.dart';
import 'browser_session_store.dart';
import 'browser_webview_cache.dart';
import 'mobile_browser_start_page.dart';
import 'mobile_browser_tabs_sheet.dart';
import 'browser_library_store.dart';
import 'mobile_browser_library_sheet.dart';

class MobileBrowserHome extends ConsumerStatefulWidget {
  const MobileBrowserHome({super.key});
  @override
  ConsumerState<MobileBrowserHome> createState() => _MobileBrowserHomeState();
}

class _MobileBrowserHomeState extends ConsumerState<MobileBrowserHome> {
  bool ready = false, opening = false, showingTabs = false;

  Map<String, dynamic>? get _blank => browserSessionStore.entries
      .where((entry) => entry['active'] == true && entry['url'] == '')
      .firstOrNull;

  @override
  void initState() {
    super.initState();
    browserSessionStore.load().then((_) {
      if (mounted) setState(() => ready = true);
    });
    browserLibraryStore.load().catchError((_) {
      if (mounted) {
        showNodeLaneNotice(
          context.l10n.browser_data_failed,
          kind: NodeLaneNoticeKind.error,
        );
      }
    });
  }

  Future<void> _library({bool bookmarks = false}) async {
    final url = await showNodeLaneCatalogSheet<String>(
      context,
      MobileBrowserLibrarySheet(
        store: browserLibraryStore,
        bookmarks: bookmarks,
      ),
    );
    if (mounted && url != null) await _open(url, '');
  }

  Future<void> _open(String url, String title, {String? tabId}) async {
    if (opening || !ready) return;
    opening = true;
    FocusScope.of(context).unfocus();
    try {
      unawaited(
        context.push(
          '/mangawebview',
          extra: {'url': url, 'title': title, 'tabId': ?tabId ?? _blank?['id']},
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
      showNodeLaneNotice(context.l10n.browser_tab_limit);
    }
  }

  Future<void> _tabs() async {
    if (!ready || opening || showingTabs) return;
    showingTabs = true;
    FocusScope.of(context).unfocus();
    try {
      final action = await showNodeLaneCatalogSheet<String>(
        context,
        MobileBrowserTabsSheet(
          entries: browserSessionStore.entries,
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
      body: ListenableBuilder(
        listenable: Listenable.merge([
          browserSessionStore,
          browserLibraryStore,
        ]),
        builder: (context, _) => MobileBrowserStartPage(
          key: ValueKey(_blank?['id']),
          sources: ref.watch(browserPinnedSourcesProvider),
          tabCount: browserSessionStore.entries.length,
          onOpen: _open,
          onTabs: ready ? _tabs : null,
          onManage: () => context.go('/browse'),
          bottomInset: pageBottomInsets(context).bottom,
          engine: browserLibraryStore.engine,
          recent: browserLibraryStore.history.take(3).toList(),
          onEngine: browserLibraryStore.setEngine,
          onHistory: _library,
          onBookmarks: () => _library(bookmarks: true),
        ),
      ),
    ),
  );
}
