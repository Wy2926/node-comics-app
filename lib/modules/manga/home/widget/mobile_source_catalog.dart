import 'dart:math' as math;

import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Source requests, saved queries and navigation belong to the owning screen.
class MobileSourceCatalog extends StatelessWidget {
  const MobileSourceCatalog({
    super.key,
    required this.title,
    required this.search,
    required this.onSubmit,
    required this.onClear,
    required this.selected,
    required this.supportsLatest,
    this.filtering = false,
    required this.onSelect,
    required this.onOptions,
    required this.results,
    this.onBrowser,
  });

  final String title;
  final TextEditingController search;
  final VoidCallback onSubmit, onClear, onOptions;
  final ValueChanged<int> onSelect;
  final VoidCallback? onBrowser;
  final int selected;
  final bool supportsLatest, filtering;
  final Widget results;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context),
        icons = NodeLaneIcons.of(context),
        l10n = context.l10n;
    return MobileBrowsePage(
      title: title,
      actions: [
        if (onBrowser != null) ...[
          NodeLaneIconButton(
            icon: icons.browser,
            tooltip: '在浏览器打开',
            onPressed: onBrowser,
          ),
          const SizedBox(width: NodeLaneTokens.space4),
        ],
        NodeLaneIconButton(
          icon: icons.more,
          tooltip: l10n.more,
          onPressed: onOptions,
          active: filtering,
        ),
        const SizedBox(width: NodeLaneTokens.space12),
      ],
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * .5,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  NodeLaneTokens.gutter,
                  NodeLaneTokens.space8,
                  NodeLaneTokens.gutter,
                  NodeLaneTokens.space16,
                ),
                child: Column(
                  children: [
                    NodeLaneTextField.search(
                      controller: search,
                      onSubmitted: (_) => onSubmit(),
                      onClear: onClear,
                      hint: '搜索本站作品',
                      clearLabel: l10n.reset,
                    ),
                    const SizedBox(height: NodeLaneTokens.space16),
                    if (selected == 2)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              filtering ? '筛选结果' : '搜索结果',
                              style: t.readerLabel,
                            ),
                          ),
                          TextButton(
                            onPressed: () => onSelect(0),
                            child: const Text('返回热门'),
                          ),
                        ],
                      )
                    else if (supportsLatest)
                      NodeLaneSegments<int>(
                        value: selected,
                        labelStyle: t.readerLabel,
                        segments: const [
                          ButtonSegment(value: 0, label: Text('热门')),
                          ButtonSegment(value: 1, label: Text('最新')),
                        ],
                        onChanged: onSelect,
                      )
                    else
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: NodeLaneTokens.minTapTarget,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('热门作品', style: t.readerLabel),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(child: results),
          ],
        ),
      ),
    );
  }
}

class MobileSourceResults extends StatelessWidget {
  const MobileSourceResults({
    super.key,
    required this.controller,
    required this.display,
    required this.count,
    required this.itemBuilder,
    required this.footer,
    this.gridSize,
  });
  final ScrollController controller;
  final DisplayType display;
  final int count;
  final int? gridSize;
  final IndexedWidgetBuilder itemBuilder;
  final Widget footer;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final available = math.max(1.0, constraints.maxWidth - 40);
      // Honor density within a usable minimum touch/cover width on phones.
      final maxColumns = math.max(1, ((available + 12) / 112).floor());
      final columns =
          (gridSize == null || gridSize == 0
                  ? (available / 200).ceil()
                  : gridSize!)
              .clamp(1, maxColumns);
      final width = (available - 12 * (columns - 1)) / columns;
      final compact = display == DisplayType.compactGrid;
      return CustomScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              NodeLaneTokens.gutter,
              NodeLaneTokens.space4,
              NodeLaneTokens.gutter,
              0,
            ),
            sliver: display == DisplayType.list
                ? SliverList.builder(
                    itemCount: count,
                    itemBuilder: itemBuilder,
                    addAutomaticKeepAlives: false,
                  )
                : SliverGrid.builder(
                    itemCount: count,
                    itemBuilder: itemBuilder,
                    addAutomaticKeepAlives: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 20,
                      mainAxisExtent:
                          width * NodeLaneTokens.coverAspectRatio +
                          (compact
                              ? 0
                              : 10 +
                                    MediaQuery.textScalerOf(context).scale(15) *
                                        1.3 *
                                        2),
                    ),
                  ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: footer,
            ),
          ),
        ],
      );
    },
  );
}

class MobileSourceMangaCard extends StatelessWidget {
  const MobileSourceMangaCard({
    super.key,
    required this.title,
    required this.cover,
    required this.onOpen,
    required this.onQuickAdd,
    required this.inLibrary,
    this.author,
    this.list = false,
    this.compact = false,
  });
  final String title;
  final String? author;
  final Widget cover;
  final VoidCallback onOpen, onQuickAdd;
  final bool inLibrary, list, compact;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final hasAuthor = author?.trim().isNotEmpty == true;
    final titleWidget = Text(
      title,
      maxLines: hasAuthor ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      style: colors.label.copyWith(height: 1.3),
    );
    final caption = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleWidget,
        if (hasAuthor) ...[
          const SizedBox(height: 4),
          Text(
            author!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: colors.readerSecondary,
          ),
        ],
      ],
    );
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
      child: ColoredBox(
        color: colors.soft,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ExcludeSemantics(child: cover),
            if (inLibrary)
              Positioned(
                top: 8,
                left: 8,
                child: NodeLaneCoverBadge(context.l10n.in_library),
              ),
          ],
        ),
      ),
    );
    return Semantics(
      label: title,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
          onTap: onOpen,
          onLongPress: onQuickAdd,
          child: list
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(width: 78, height: 110, child: image),
                      const SizedBox(width: 16),
                      Expanded(child: ExcludeSemantics(child: caption)),
                      const SizedBox(width: 8),
                      Icon(
                        NodeLaneIcons.of(context).forward,
                        color: colors.muted,
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: image),
                    if (!compact)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ExcludeSemantics(child: caption),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class MobileSourceStatus extends StatelessWidget {
  const MobileSourceStatus({
    super.key,
    this.loading = false,
    this.message,
    this.onLoadMore,
    this.searchEmpty = false,
  });
  final bool loading, searchEmpty;
  final String? message;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context),
        icons = NodeLaneIcons.of(context),
        l10n = context.l10n;
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (searchEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: NodeLaneTokens.space24),
        child: Column(
          children: [
            Icon(
              icons.search,
              size: NodeLaneTokens.websiteIconSize,
              color: t.muted,
            ),
            const SizedBox(height: NodeLaneTokens.space16),
            Text('没有找到相关作品', style: t.title),
            const SizedBox(height: NodeLaneTokens.space8),
            Text(
              '调整关键词或筛选条件，也可返回热门浏览。',
              style: t.readerSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              message!,
              textAlign: TextAlign.center,
              style: t.readerSecondary,
            ),
          ),
        if (onLoadMore != null)
          NodeLaneSecondaryButton(
            onPressed: onLoadMore,
            child: Text(l10n.load_more),
          ),
      ],
    );
  }
}
