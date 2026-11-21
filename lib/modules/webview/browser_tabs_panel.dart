import 'dart:math' as math;

import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'browser_session_store.dart';
import 'mobile_browser_widgets.dart';

/// A snapshot of logical tabs; previews never create a WebView.
class BrowserTabsPanel extends StatefulWidget {
  const BrowserTabsPanel({
    super.key,
    required this.entries,
    required this.onClose,
    required this.onUndo,
  });
  final List<Map<String, dynamic>> entries;
  final Future<List<Map<String, dynamic>>> Function(String) onClose;
  final Future<List<Map<String, dynamic>>> Function() onUndo;
  @override
  State<BrowserTabsPanel> createState() => _BrowserTabsPanelState();
}

class _BrowserTabsPanelState extends State<BrowserTabsPanel> {
  late final entries = widget.entries.toList();
  ScrollController? scroll;
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
    scroll?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    final colors = NodeLaneTokens.of(context),
        scaler = MediaQuery.textScalerOf(context);
    final lineHeight = MediaQuery.maybeLineHeightScaleFactorOverrideOf(context);
    double line(TextStyle style) =>
        (scaler.scale(style.fontSize!) * (lineHeight ?? style.height!))
            .ceilToDouble();
    final extent = math.max(
      76.0,
      line(colors.readerLabel) + line(colors.readerSecondary) + 20,
    );
    final heading = NodeLaneBubbleHeading(
      l.browser_tab_count(entries.length),
      actions: [
        if (browserSessionStore.canUndo)
          NodeLaneIconButton(
            style: NodeLaneIconButtonStyle.plain,
            icon: icons.reset,
            tooltip: l.browser_undo_close,
            onPressed: busy ? null : () => _edit(widget.onUndo),
          ),
      ],
    );
    final newTab = NodeLaneRow(
      icon: icons.add,
      accented: true,
      title: entries.length < BrowserSessionStore.maxTabs
          ? l.browser_new_tab_action
          : l.browser_tabs_full(BrowserSessionStore.maxTabs),
      enabled: !busy && entries.length < BrowserSessionStore.maxTabs,
      trailing: const SizedBox.shrink(),
      onTap: () => Navigator.pop(context, ''),
    );
    return LayoutBuilder(
      builder: (context, bounds) {
        final short = bounds.maxHeight < extent * 2;
        final index = entries.indexWhere((e) => e['active'] == true);
        final maxOffset =
            (entries.length * extent + 2 * extent - bounds.maxHeight).clamp(
              0.0,
              double.infinity,
            );
        scroll ??= ScrollController(
          keepScrollOffset: false,
          initialScrollOffset: (index * extent).clamp(0.0, maxOffset),
        );
        final list = CustomScrollView(
          shrinkWrap: true,
          controller: scroll,
          slivers: [
            if (short) SliverToBoxAdapter(child: heading),
            if (error != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: NodeLaneTokens.rowPadding,
                  child: Text(error!),
                ),
              ),
            if (entries.isEmpty)
              SliverToBoxAdapter(
                child: NodeLaneEmptyState(
                  icon: NodeLaneIcons.of(context).browserStart,
                  title: context.l10n.browser_no_tabs,
                ),
              )
            else
              ListenableBuilder(
                listenable: browserSessionStore,
                builder: (context, _) => SliverFixedExtentList.builder(
                  itemExtent: extent,
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
                      onClose: busy
                          ? null
                          : () => _edit(() => widget.onClose(id)),
                    );
                  },
                ),
              ),
            if (short) SliverToBoxAdapter(child: newTab),
          ],
        );
        return short
            ? list
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  heading,
                  Flexible(child: list),
                  const NodeLaneGroupDivider(),
                  newTab,
                ],
              );
      },
    );
  }
}
