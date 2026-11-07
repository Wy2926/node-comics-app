import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

enum SearchPhase { searching, results, empty, failed }

/// Only presentation metadata is shared; source sections own their requests.
class SourceSearchActivity {
  const SourceSearchActivity(this.phase, {this.count = 0, this.retry});
  final SearchPhase phase;
  final int count;
  final VoidCallback? retry;

  String get label => switch (phase) {
    SearchPhase.searching => '正在搜索',
    SearchPhase.results => '找到 $count 个结果',
    SearchPhase.empty => '没有匹配结果',
    SearchPhase.failed => '搜索失败',
  };
}

class SearchActivitySummary extends StatelessWidget {
  const SearchActivitySummary({
    super.key,
    required this.total,
    required this.activity,
    required this.onDetails,
    required this.onScope,
  });
  final int total;
  final Map<int, SourceSearchActivity> activity;
  final VoidCallback onDetails, onScope;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final completed = activity.values
        .where((a) => a.phase != SearchPhase.searching)
        .length;
    final matched = activity.values.where(
      (a) => a.phase == SearchPhase.results,
    );
    final count = matched.fold(0, (sum, a) => sum + a.count);
    final searching = completed < total;
    final failed = activity.values.any((a) => a.phase == SearchPhase.failed);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NodeLaneTokens.gutter,
        NodeLaneTokens.space12,
        NodeLaneTokens.gutter,
        NodeLaneTokens.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  count > 0
                      ? '已找到 $count 个作品 · ${matched.length} 个网站'
                      : searching
                      ? '正在查找作品'
                      : '搜索完成',
                  style: t.readerSecondary,
                ),
              ),
              if (searching) ...[
                const SizedBox(width: NodeLaneTokens.space8),
                const _SearchSpinner(),
                const SizedBox(width: NodeLaneTokens.space8),
                Text('搜索中', style: t.caption),
              ],
            ],
          ),
          if (count == 0)
            NodeLaneEmptyState(
              icon: NodeLaneIcons.of(context).search,
              title: searching
                  ? '正在寻找相关作品…'
                  : failed
                  ? '暂未取得搜索结果'
                  : '未找到相关作品',
              message: searching
                  ? '找到后会直接显示在这里。'
                  : failed
                  ? '有网站未能完成搜索，可在搜索详情中重试。'
                  : '试试更短的关键词，或扩大搜索范围。',
              action: searching
                  ? null
                  : TextButton(
                      onPressed: failed ? onDetails : onScope,
                      child: Text(failed ? '查看搜索详情' : '调整搜索范围'),
                    ),
            ),
        ],
      ),
    );
  }
}

class _SearchSpinner extends StatelessWidget {
  const _SearchSpinner();
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: NodeLaneTokens.space16,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: NodeLaneTokens.of(context).accent,
    ),
  );
}

/// Opened explicitly, so unavailable websites never occupy the results feed.
class SearchActivitySheet extends StatelessWidget {
  const SearchActivitySheet({
    super.key,
    required this.query,
    required this.sources,
    required this.activity,
    required this.onOpen,
  });
  final String query;
  final List<Source> sources;
  final ValueListenable<Map<int, SourceSearchActivity>> activity;
  final ValueChanged<Source> onOpen;

  @override
  Widget build(BuildContext context) => NodeLaneCatalogSheet(
    title: '搜索详情',
    subtitle: '$query · ${sources.length} 个网站',
    heightFactor: NodeLaneTokens.readerSheetFraction,
    child: ValueListenableBuilder(
      valueListenable: activity,
      builder: (context, values, _) => ListView.builder(
        padding: NodeLaneTokens.pagePadding,
        itemCount: sources.length + 2,
        itemBuilder: (context, index) {
          final t = NodeLaneTokens.of(context);
          if (index == 0) {
            final completed = values.values
                .where((a) => a.phase != SearchPhase.searching)
                .length;
            return Padding(
              padding: const EdgeInsets.only(bottom: NodeLaneTokens.space16),
              child: Text(
                '已完成 $completed / ${sources.length}',
                style: t.readerSecondary,
              ),
            );
          }
          if (index == sources.length + 1) {
            return Padding(
              padding: const EdgeInsets.only(top: NodeLaneTokens.space16),
              child: Text('失败网站可单独重试', style: t.readerSecondary),
            );
          }
          final source = sources[index - 1];
          final state =
              values[source.id] ??
              const SourceSearchActivity(SearchPhase.searching);
          final canOpenWebsite =
              state.phase == SearchPhase.failed && isBrowserUrl(source.baseUrl);
          return NodeLaneRow.card(
            first: index == 1,
            last: index == sources.length,
            minHeight: NodeLaneTokens.rowHeight,
            title: source.name ?? '',
            icon: NodeLaneIcons.of(context).web,
            subtitle: state.label,
            trailing: switch (state.phase) {
              SearchPhase.failed => TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: state.retry,
                child: const Text('重试'),
              ),
              SearchPhase.searching => const _SearchSpinner(),
              SearchPhase.results => Icon(
                NodeLaneIcons.of(context).forward,
                color: t.accent,
                size: NodeLaneTokens.smallIconSize,
              ),
              SearchPhase.empty => null,
            },
            onTap: state.phase == SearchPhase.results
                ? () => onOpen(source)
                : canOpenWebsite
                ? () => context.push(
                    '/mangawebview',
                    extra: {'url': source.baseUrl!, 'title': source.name ?? ''},
                  )
                : null,
          );
        },
      ),
    ),
  );
}
