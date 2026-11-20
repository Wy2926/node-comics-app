import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'browser_session_store.dart';
import 'mobile_browser_widgets.dart';

/// A snapshot of logical tabs; opening this sheet never creates a WebView.
class MobileBrowserTabsSheet extends StatefulWidget {
  const MobileBrowserTabsSheet({
    super.key,
    required this.entries,
    required this.onClose,
    required this.onUndo,
  });
  final List<Map<String, dynamic>> entries;
  final Future<List<Map<String, dynamic>>> Function(String) onClose;
  final Future<List<Map<String, dynamic>>> Function() onUndo;
  @override
  State<MobileBrowserTabsSheet> createState() => _MobileBrowserTabsSheetState();
}

class _MobileBrowserTabsSheetState extends State<MobileBrowserTabsSheet> {
  late final entries = widget.entries.toList();
  late final scroll = ScrollController(
    initialScrollOffset:
        (entries
                .indexWhere((e) => e['active'] == true)
                .clamp(0, entries.length) ~/
            2) *
        (NodeLaneTokens.browserTabHeight + NodeLaneTokens.browserTabGap),
  );
  bool busy = false;
  String? error;

  Future<void> _edit(Future<List<Map<String, dynamic>>> Function() edit) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      final next = await edit();
      if (mounted) {
        setState(() {
          entries
            ..clear()
            ..addAll(next);
          error = null;
        });
      }
    } catch (_) {
      if (mounted) setState(() => error = context.l10n.browser_save_failed);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NodeLaneCatalogSheet(
    title: context.l10n.browser_tab_count(entries.length),
    heightFactor: .8,
    fitContent: true,
    bottom: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: NodeLaneTokens.space12),
            child: Text(
              error!,
              style: NodeLaneTokens.of(context).readerSecondary,
            ),
          ),
        if (browserSessionStore.canUndo)
          TextButton.icon(
            onPressed: busy ? null : () => _edit(widget.onUndo),
            icon: Icon(NodeLaneIcons.of(context).reset),
            label: Text(context.l10n.browser_undo_close),
          ),
        FilledButton.icon(
          onPressed: entries.length < BrowserSessionStore.maxTabs && !busy
              ? () => Navigator.pop(context, '')
              : null,
          icon: Icon(NodeLaneIcons.of(context).add),
          label: Text(
            entries.length < BrowserSessionStore.maxTabs
                ? context.l10n.browser_new_tab_action
                : context.l10n.browser_tabs_full(BrowserSessionStore.maxTabs),
          ),
        ),
      ],
    ),
    child: entries.isEmpty
        ? NodeLaneEmptyState(
            icon: NodeLaneIcons.of(context).browserStart,
            title: context.l10n.browser_no_tabs,
          )
        : ListenableBuilder(
            listenable: browserSessionStore,
            builder: (context, _) => GridView.builder(
              shrinkWrap: true,
              controller: scroll,
              padding: const EdgeInsets.symmetric(
                horizontal: NodeLaneTokens.gutter,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: NodeLaneTokens.browserTabGap,
                mainAxisSpacing: NodeLaneTokens.browserTabGap,
                mainAxisExtent: NodeLaneTokens.browserTabHeight,
              ),
              itemCount: entries.length,
              itemBuilder: (context, i) {
                final entry = entries[i], id = entries[i]['id'] as String;
                return MobileBrowserTabCard(
                  key: ValueKey(id),
                  title: entry['title'] as String? ?? '',
                  url: entry['url'] as String,
                  selected: entry['active'] == true,
                  preview: browserSessionStore.preview(id),
                  onSelect: () {
                    if (!busy) Navigator.pop(context, id);
                  },
                  onClose: () => _edit(() => widget.onClose(id)),
                );
              },
            ),
          ),
  );
}
