import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// One chapter viewport across phone, split view and the full detail workspace.
class MobileDetailLayout extends StatefulWidget {
  const MobileDetailLayout({
    super.key,
    required this.overview,
    required this.information,
    required this.chapterHeading,
    this.chapterCount = 0,
    this.chapterBuilder,
    this.empty,
    this.controller,
  }) : assert(chapterCount == 0 || chapterBuilder != null);

  final Widget overview, information, chapterHeading;
  final int chapterCount;
  final IndexedWidgetBuilder? chapterBuilder;
  final Widget? empty;
  final ScrollController? controller;

  @override
  State<MobileDetailLayout> createState() => _MobileDetailLayoutState();
}

class _MobileDetailLayoutState extends State<MobileDetailLayout> {
  final _chapters = ListController();
  final _overview = GlobalKey();
  final _information = GlobalKey();
  ScrollController? _localScroll;
  int? _columns;

  void _retainChapter(int columns, ScrollController scroll) {
    final changed = _columns != null && _columns != columns;
    _columns = columns;
    if (!changed ||
        !_chapters.isAttached ||
        !scroll.hasClients ||
        scroll.offset <= 0) {
      return;
    }
    final first = _chapters.unobstructedVisibleRange?.$1;
    if (first == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          _columns != columns ||
          !_chapters.isAttached ||
          first >= widget.chapterCount ||
          !scroll.hasClients) {
        return;
      }
      _chapters.jumpToItem(
        index: first,
        scrollController: scroll,
        alignment: 0,
      );
    });
  }

  @override
  void dispose() {
    _localScroll?.dispose();
    _chapters.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overview = KeyedSubtree(key: _overview, child: widget.overview);
    final information = KeyedSubtree(
      key: _information,
      child: widget.information,
    );
    final scroll = widget.controller ?? (_localScroll ??= ScrollController());
    return LayoutBuilder(
      builder: (context, box) {
        final width = box.maxWidth, scale = context.paneTextScale;
        final split = context.hasPaneWidth(width);
        final triple = context.hasPaneWidth(
          width - NodeLaneTokens.tabletSupportingWidth * scale,
        );
        _retainChapter(
          triple
              ? 3
              : split
              ? 2
              : 1,
          scroll,
        );
        Widget side(String key, double size, List<Widget> children) => SizedBox(
          key: ValueKey(key),
          width: size,
          child: SingleChildScrollView(
            primary: false,
            key: PageStorageKey(key),
            padding: NodeLaneTokens.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: NodeLaneTokens.space12,
              children: children,
            ),
          ),
        );
        final chapters = CustomScrollView(
          controller: scroll,
          primary: false,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (!split)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    NodeLaneTokens.gutter,
                    NodeLaneTokens.space8,
                    NodeLaneTokens.gutter,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: NodeLaneTokens.space12,
                    children: [overview, information],
                  ),
                ),
              ),
            PinnedHeaderSliver(
              child: ColoredBox(
                color: NodeLaneTokens.of(context).canvas,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NodeLaneTokens.gutter,
                    vertical: NodeLaneTokens.space4,
                  ),
                  child: widget.chapterHeading,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: NodeLaneTokens.gutter,
              ),
              sliver: widget.chapterCount == 0
                  ? SliverToBoxAdapter(child: widget.empty)
                  : SuperSliverList.builder(
                      listController: _chapters,
                      itemCount: widget.chapterCount,
                      itemBuilder: widget.chapterBuilder!,
                    ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: NodeLaneTokens.space16),
            ),
          ],
        );
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (split)
                side(
                  'book-overview',
                  triple
                      ? width * NodeLaneTokens.detailSideFraction
                      : math.min(
                          NodeLaneTokens.tabletOverviewWidth * scale,
                          width * NodeLaneTokens.paneMaxFraction,
                        ),
                  [overview, if (!triple) information],
                ),
              Expanded(key: const ValueKey('book-chapters'), child: chapters),
              if (triple)
                side(
                  'book-information',
                  width * NodeLaneTokens.detailSideFraction,
                  [information],
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Shared geometry for the overview. Slots retain their existing state and actions.
class MobileDetailOverview extends StatelessWidget {
  const MobileDetailOverview({
    super.key,
    required this.heading,
    required this.actions,
  });
  final Widget heading, actions;
  @override
  Widget build(BuildContext context) => NodeLaneGroupSurface(
    outlined: true,
    child: Padding(
      padding: const EdgeInsets.all(NodeLaneTokens.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: NodeLaneTokens.space16,
        children: [heading, actions],
      ),
    ),
  );
}

/// Layout only: the detail page supplies its existing cover and title actions.
class MobileDetailHeading extends StatelessWidget {
  const MobileDetailHeading({
    super.key,
    required this.cover,
    required this.title,
    required this.metadata,
  });

  final Widget cover, title, metadata;

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: NodeLaneTokens.space8,
      children: [title, metadata],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = context.paneTextScale;
        if (constraints.maxWidth -
                    NodeLaneTokens.detailCoverWidth -
                    NodeLaneTokens.space16 <
                NodeLaneTokens.detailHeadingTextWidth * scale ||
            scale > 1.5) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: NodeLaneTokens.space12,
            children: [
              Center(child: cover),
              text,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cover,
            const SizedBox(width: NodeLaneTokens.space16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: NodeLaneTokens.space8),
                child: text,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// The read and library actions share the full content width. A hidden read
/// action leaves one full-width library action, not an empty half-column.
class MobileDetailPrimaryActions extends StatelessWidget {
  const MobileDetailPrimaryActions({
    super.key,
    this.reading,
    required this.library,
  });

  final Widget? reading;
  final Widget library;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      const gap = NodeLaneTokens.space8;
      final two =
          reading != null &&
          box.maxWidth >=
              MediaQuery.textScalerOf(context)
                  .scale(NodeLaneTokens.actionPairWidth);
      final width = two ? (box.maxWidth - gap) / 2 : box.maxWidth;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final action in [?reading, library])
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: width,
                maxWidth: width,
                minHeight: NodeLaneTokens.rowHeight,
              ),
              child: action,
            ),
        ],
      );
    },
  );
}

/// Chapter text and controls have separate hit targets; no repository work or
/// progress calculation belongs in this view.
class MobileChapterTile extends StatelessWidget {
  const MobileChapterTile({
    super.key,
    required this.title,
    required this.metadata,
    required this.read,
    required this.bookmarked,
    required this.selecting,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    this.description,
    this.thumbnail,
    this.trailing,
  });

  final String title, metadata;
  final String? description;
  final bool read, bookmarked, selecting, selected;
  final VoidCallback onTap, onLongPress;
  final Widget? thumbnail, trailing;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    return Semantics(
      selected: selecting ? selected : null,
      child: NodeLaneGroupSurface(
        outlined: true,
        selected: selected,
        margin: const EdgeInsets.only(bottom: NodeLaneTokens.space8),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          onSecondaryTap: onLongPress,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: NodeLaneTokens.chapterRowHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NodeLaneTokens.space12,
                vertical: NodeLaneTokens.space8,
              ),
              child: Row(
                children: [
                  if (selecting)
                    Icon(
                      selected ? icons.selected : icons.unselected,
                      color: selected ? colors.accent : colors.muted,
                      size: NodeLaneTokens.smallIconSize,
                    )
                  else
                    SizedBox(
                      width: NodeLaneTokens.progressTrackHeight,
                      height: NodeLaneTokens.space24,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: read ? colors.line : colors.accent,
                          borderRadius: BorderRadius.circular(
                            NodeLaneTokens.progressTrackHeight,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: NodeLaneTokens.space12),
                  if (thumbnail != null) ...[
                    thumbnail!,
                    const SizedBox(width: NodeLaneTokens.space8),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: colors.body.copyWith(
                            fontWeight: read
                                ? FontWeight.w400
                                : FontWeight.w600,
                            color: read ? colors.muted : colors.ink,
                          ),
                        ),
                        if (description?.isNotEmpty ?? false) ...[
                          const SizedBox(height: NodeLaneTokens.space4),
                          Text(
                            description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: colors.secondary,
                          ),
                        ],
                        if (metadata.isNotEmpty) ...[
                          const SizedBox(height: NodeLaneTokens.space4),
                          Text(metadata, style: colors.readerSecondary),
                        ],
                      ],
                    ),
                  ),
                  if (bookmarked && !selecting)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: NodeLaneTokens.space8,
                      ),
                      child: Icon(
                        icons.bookmark,
                        size: NodeLaneTokens.smallIconSize,
                        color: colors.accent,
                      ),
                    ),
                  if (trailing != null) ...[
                    const SizedBox(width: NodeLaneTokens.space4),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The synopsis owns presentation; description and genre actions stay separate.
class MobileDetailSynopsis extends StatelessWidget {
  const MobileDetailSynopsis({
    super.key,
    required this.title,
    required this.text,
    required this.expanded,
    required this.onChanged,
    this.genres = const [],
  });
  final String title, text;
  final bool expanded;
  final ValueChanged<bool> onChanged;
  final List<Widget> genres;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final labels = MaterialLocalizations.of(context);
    final hasText = text.trim().isNotEmpty;
    return NodeLaneGroupSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasText)
            Semantics(
              expanded: expanded,
              child: NodeLaneRow(
                title: title,
                compact: true,
                onTap: () => onChanged(!expanded),
                trailing: Text(
                  expanded
                      ? labels.expandedIconTapHint
                      : labels.collapsedIconTapHint,
                  style: colors.readerSecondary.copyWith(color: colors.accent),
                ),
              ),
            ),
          NodeLaneMotion.resize(
            context,
            Padding(
              padding: const EdgeInsets.fromLTRB(
                NodeLaneTokens.space16,
                0,
                NodeLaneTokens.space16,
                NodeLaneTokens.space8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (hasText)
                    InkWell(
                      onTap: () => onChanged(!expanded),
                      child: Text(
                        text.trim(),
                        maxLines: expanded ? null : 3,
                        overflow: expanded ? null : TextOverflow.ellipsis,
                        style: colors.readerSecondary,
                      ),
                    ),
                  if (genres.isNotEmpty) ...[
                    if (hasText) const SizedBox(height: NodeLaneTokens.space8),
                    if (expanded || !hasText)
                      Wrap(spacing: NodeLaneTokens.space8, children: genres)
                    else
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: NodeLaneTokens.space8,
                          children: genres,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The scope action belongs to the count. Settings stays at the opposite edge.
class MobileChapterTools extends StatelessWidget {
  const MobileChapterTools({
    super.key,
    required this.title,
    this.primary,
    required this.settings,
  });
  final String title;
  final Widget? primary;
  final Widget settings;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Row(
          children: [
            Flexible(
              child: Text(
                title,
                style: NodeLaneTokens.of(context).detailSectionTitle,
              ),
            ),
            if (primary != null) ...[
              const SizedBox(width: NodeLaneTokens.space8),
              primary!,
            ],
          ],
        ),
      ),
      const SizedBox(width: NodeLaneTokens.space24),
      settings,
    ],
  );
}

/// Pack the available tools without reserving slots for absent services.
class MobileDetailShortcuts extends StatelessWidget {
  const MobileDetailShortcuts({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => NodeLaneGroupSurface(
    outlined: true,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final min = MediaQuery.textScalerOf(context)
            .scale(NodeLaneTokens.detailToolMinWidth);
        final columns = (constraints.maxWidth / min).floor().clamp(
          1,
          math.max(1, children.length),
        );
        return Wrap(
          children: [
            for (final child in children)
              SizedBox(width: constraints.maxWidth / columns, child: child),
          ],
        );
      },
    ),
  );
}
