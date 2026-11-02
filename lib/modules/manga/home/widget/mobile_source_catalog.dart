import 'dart:math' as math;

import 'package:mangayomi/modules/browse/widgets/mobile_search_field.dart';
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
    required this.filtering,
    required this.onSelect,
    required this.onOptions,
    required this.results,
    this.onFilter,
    this.onSavedSearches,
  });

  final String title;
  final TextEditingController search;
  final VoidCallback onSubmit, onClear, onOptions;
  final ValueChanged<int> onSelect;
  final VoidCallback? onFilter, onSavedSearches;
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
        NodeLaneIconButton(
          icon: icons.more,
          tooltip: l10n.more,
          style: NodeLaneIconButtonStyle.field,
          onPressed: onOptions,
        ),
        const SizedBox(width: 12),
      ],
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * .5,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  children: [
                    MobileSearchField(
                      controller: search,
                      onSubmit: onSubmit,
                      onClear: onClear,
                      submitLabel: l10n.search,
                      hint: '搜索本站作品',
                      onSavedSearches: onSavedSearches,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: NodeLaneSegments<int>(
                            value: selected,
                            labelStyle: t.readerSecondary,
                            segments: [
                              ButtonSegment(value: 0, label: Text('热门')),
                              if (supportsLatest)
                                ButtonSegment(value: 1, label: Text('最新')),
                            ],
                            onChanged: onSelect,
                          ),
                        ),
                        if (onFilter != null) ...[
                          const SizedBox(width: 12),
                          Stack(
                            children: [
                              NodeLaneIconButton(
                                icon: icons.adjustments,
                                tooltip: l10n.filter,
                                style: NodeLaneIconButtonStyle.field,
                                onPressed: onFilter,
                              ),
                              if (filtering)
                                Positioned(
                                  right: 3,
                                  top: 3,
                                  child: IgnorePointer(
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: t.accent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
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
    required this.status,
    required this.footer,
    this.gridSize,
    this.notes,
  });
  final ScrollController controller;
  final DisplayType display;
  final int count;
  final int? gridSize;
  final String status;
  final String? notes;
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Text(
                status,
                style: TextStyle(color: NodeLaneTokens.of(context).muted),
              ),
            ),
          ),
          if (notes?.isNotEmpty == true)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(context.l10n.extension_notes('')),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(notes!),
                    ),
                  ],
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
      style: TextStyle(
        fontSize: 15,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: colors.ink,
      ),
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
    this.onRetry,
    this.onBrowser,
    this.onLoadMore,
  });
  final bool loading;
  final String? message;
  final VoidCallback? onRetry, onBrowser, onLoadMore;

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
    if (onRetry != null) {
      return NodeLaneGroupSurface(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(icons.webLink, size: 48, color: t.muted),
              const SizedBox(height: 20),
              Text('暂时无法加载', textAlign: TextAlign.center, style: t.readerTitle),
              const SizedBox(height: 12),
              Text(
                onBrowser == null ? '已保留当前内容，请重试。' : '可以重试，或在浏览器中打开网站。',
                textAlign: TextAlign.center,
                style: t.readerSecondary,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
              if (onBrowser != null) ...[
                const SizedBox(height: 12),
                NodeLaneSecondaryButton(
                  onPressed: onBrowser,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icons.navigation, color: t.accent),
                      const SizedBox(width: 8),
                      const Flexible(child: Text('在浏览器打开')),
                    ],
                  ),
                ),
              ],
              if (message?.isNotEmpty == true) _SourceErrorDetails(message!),
              if (onBrowser != null)
                Text(
                  '浏览器内可使用漫画图片翻译。',
                  textAlign: TextAlign.center,
                  style: t.readerSecondary,
                ),
            ],
          ),
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
          FilledButton.tonal(
            onPressed: onLoadMore,
            child: Text(l10n.load_more),
          ),
      ],
    );
  }
}

class _SourceErrorDetails extends StatefulWidget {
  const _SourceErrorDetails(this.message);
  final String message;
  @override
  State<_SourceErrorDetails> createState() => _SourceErrorDetailsState();
}

class _SourceErrorDetailsState extends State<_SourceErrorDetails> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () => setState(() => expanded = !expanded),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '查看错误详情',
                  style: t.readerSecondary.copyWith(color: t.accent),
                ),
              ),
              Icon(
                expanded ? icons.down : icons.forward,
                size: 16,
                color: t.muted,
              ),
            ],
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SelectableText(widget.message, style: t.readerSecondary),
          ),
      ],
    );
  }
}
