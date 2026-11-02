import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/browse/widgets/source_controls.dart';
import 'package:mangayomi/modules/manga/home/providers/saved_searches_provider.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

enum SourceCatalogAction { save, saved, browser, settings }

class MobileSourceActions extends StatelessWidget {
  const MobileSourceActions({
    super.key,
    required this.title,
    required this.display,
    required this.canSave,
    required this.local,
    this.host,
  });
  final String title;
  final String? host;
  final DisplayType display;
  final bool canSave, local;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    void choose(Object value) => Navigator.pop(context, value);
    return NodeLaneCatalogSheet(
      title: title,
      subtitle: host,
      heightFactor: .67,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const NodeLaneCatalogHeading('显示方式'),
          NodeLaneSegments<DisplayType>(
            value: display,
            labelStyle: t.readerSecondary,
            segments: const [
              ButtonSegment(
                value: DisplayType.comfortableGrid,
                label: Text('封面与标题'),
              ),
              ButtonSegment(value: DisplayType.compactGrid, label: Text('仅封面')),
              ButtonSegment(value: DisplayType.list, label: Text('列表')),
            ],
            onChanged: choose,
          ),
          const SizedBox(height: 20),
          SourceGroup(
            children: [
              SourceRow(
                title: '保存当前搜索',
                icon: icons.bookmarkOutline,
                subtitle: canSave ? null : '输入关键词并搜索后可保存',
                onTap: canSave ? () => choose(SourceCatalogAction.save) : null,
              ),
              SourceRow(
                title: '已保存搜索',
                icon: icons.manga,
                onTap: () => choose(SourceCatalogAction.saved),
              ),
            ],
          ),
          if (!local) ...[
            const SizedBox(height: 20),
            SourceGroup(
              children: [
                SourceRow(
                  title: '在浏览器打开',
                  icon: icons.navigation,
                  onTap: () => choose(SourceCatalogAction.browser),
                ),
                SourceRow(
                  title: '来源设置',
                  icon: icons.settings,
                  onTap: () => choose(SourceCatalogAction.settings),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class MobileSavedSearches extends ConsumerStatefulWidget {
  const MobileSavedSearches({
    super.key,
    required this.sourceId,
    required this.title,
  });
  final int sourceId;
  final String title;
  @override
  ConsumerState<MobileSavedSearches> createState() =>
      _MobileSavedSearchesState();
}

class _MobileSavedSearchesState extends ConsumerState<MobileSavedSearches> {
  bool managing = false;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final entries =
        ref.watch(savedSearchesProvider)[widget.sourceId] ??
        const <SavedSearch>[];
    return NodeLaneCatalogSheet(
      title: '已保存搜索',
      subtitle: '${widget.title} · 点击立即搜索',
      heightFactor: entries.isEmpty ? .38 : .58,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          if (entries.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => managing = !managing),
                child: Text(managing ? '完成' : '管理'),
              ),
            ),
          for (var i = 0; i < entries.length; i++)
            NodeLaneCatalogRow(
              title: entries[i].name,
              subtitle: '关键词：${entries[i].query}',
              leading: Icon(icons.bookmarkOutline),
              first: i == 0,
              last: i == entries.length - 1,
              onTap: managing
                  ? null
                  : () => Navigator.pop(context, entries[i].query),
              trailing: managing
                  ? IconButton(
                      tooltip: '移除',
                      icon: Icon(
                        icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () => ref
                          .read(savedSearchesProvider.notifier)
                          .remove(widget.sourceId, entries[i].name),
                    )
                  : null,
            ),
          if (entries.isEmpty)
            SourceGroup(
              children: [
                SourceRow(
                  title: '还没有保存的搜索',
                  subtitle: '输入关键词搜索后，可从网站操作中保存。',
                  icon: icons.bookmarkOutline,
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text('仅保存当前网站的关键词。', style: t.readerSecondary),
          ),
        ],
      ),
    );
  }
}
