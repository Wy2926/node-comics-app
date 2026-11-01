import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
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
    this.activeId,
  });
  final List<Map<String, dynamic>> entries;
  final Future<void> Function(String) onClose;
  final String? activeId;
  @override
  State<MobileBrowserTabsSheet> createState() => _MobileBrowserTabsSheetState();
}

class _MobileBrowserTabsSheetState extends State<MobileBrowserTabsSheet> {
  late final entries = widget.entries.toList();
  final closing = <String>{};
  String? error;
  @override
  Widget build(BuildContext context) => NodeLaneCatalogSheet(
    title: '标签页 · ${entries.length}',
    heightFactor: .8,
    bottom: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              error!,
              style: NodeLaneTokens.of(context).readerSecondary,
            ),
          ),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size(44, 48)),
          onPressed: entries.length < 12
              ? () => Navigator.pop(context, '')
              : null,
          icon: Icon(NodeLaneIcons.of(context).add),
          label: Text(entries.length < 12 ? '新建标签页' : '已打开 12 个标签页'),
        ),
      ],
    ),
    child: entries.isEmpty
        ? const Center(child: Text('还没有打开的标签页'))
        : GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                selected: id == widget.activeId,
                preview: browserSessionStore.preview(id),
                onSelect: () {
                  if (!closing.contains(id)) Navigator.pop(context, id);
                },
                onClose: () async {
                  if (!closing.add(id)) return;
                  try {
                    await widget.onClose(id);
                    if (mounted) {
                      setState(() {
                        entries.removeWhere((e) => e['id'] == id);
                        error = null;
                      });
                    }
                  } catch (_) {
                    if (mounted) {
                      setState(() => error = '标签状态保存失败，请再次点击关闭重试。');
                    }
                  } finally {
                    closing.remove(id);
                  }
                },
              );
            },
          ),
  );
}
