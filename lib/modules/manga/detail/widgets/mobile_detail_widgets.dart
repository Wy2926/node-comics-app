import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

/// Shared geometry for the overview. Slots retain their existing state and actions.
class MobileDetailOverview extends StatelessWidget {
  const MobileDetailOverview({
    super.key,
    required this.heading,
    required this.actions,
    this.synopsis,
    required this.more,
    required this.chapters,
  });
  final Widget heading, actions, more, chapters;
  final Widget? synopsis;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: NodeLaneTokens.detailGutter,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        heading,
        const SizedBox(height: 16),
        actions,
        if (synopsis != null) ...[const SizedBox(height: 16), synopsis!],
        const SizedBox(height: 12),
        more,
        const SizedBox(height: 8),
        chapters,
      ],
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
      children: [title, const SizedBox(height: 8), metadata],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
        if (constraints.maxWidth < 280 || scale > 1.5) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [cover, const SizedBox(height: 16), text],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cover,
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
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
  Widget build(BuildContext context) => Row(
    children: [
      if (reading != null) ...[
        Expanded(child: _action(reading!)),
        const SizedBox(width: NodeLaneTokens.space12),
      ],
      Expanded(child: _action(library)),
    ],
  );

  Widget _action(Widget child) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: NodeLaneTokens.rowHeight),
    child: child,
  );
}

/// Keeps the existing filter controls inside one bounded, scrollable sheet.
class MobileChapterFilterSheet extends StatelessWidget {
  const MobileChapterFilterSheet({
    super.key,
    required this.labels,
    required this.children,
    required this.closeLabel,
    required this.onClose,
  }) : assert(labels.length == children.length);

  final List<String> labels;
  final List<Widget> children;
  final String closeLabel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final tabHeight = (MediaQuery.textScalerOf(context).scale(14) + 24).clamp(
      48.0,
      double.infinity,
    );
    return NodeLaneSurface(
      child: DefaultTabController(
        length: labels.length,
        child: Builder(
          builder: (context) {
            final controller = DefaultTabController.of(context);
            return ListenableBuilder(
              listenable: controller,
              builder: (context, _) => SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            labelStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelColor: colors.muted,
                            dividerColor: Colors.transparent,
                            tabs: [
                              for (final label in labels)
                                Tab(text: label, height: tabHeight),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: closeLabel,
                          onPressed: onClose,
                          icon: const Icon(Icons.close),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                    Divider(height: 1, color: colors.line),
                    Flexible(
                      child: SingleChildScrollView(
                        key: PageStorageKey(controller.index),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: children[controller.index],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
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
      child: Material(
        color: selected ? colors.accentSoft : colors.surface,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          onSecondaryTap: onLongPress,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: NodeLaneTokens.chapterRowHeight - 1,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        child: ExcludeSemantics(
                          child: Icon(
                            selecting
                                ? selected
                                      ? icons.selected
                                      : icons.unselected
                                : icons.unread,
                            size: selecting ? 20 : 10,
                            color: read && !selected
                                ? colors.muted.withValues(alpha: .55)
                                : colors.accent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (thumbnail != null) ...[
                        thumbnail!,
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: colors.label.copyWith(
                                fontSize: 16,
                                fontWeight: read
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                                color: read ? colors.muted : colors.ink,
                              ),
                            ),
                            if (description?.isNotEmpty ?? false) ...[
                              const SizedBox(height: 4),
                              Text(
                                description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: colors.secondary,
                              ),
                            ],
                            if (metadata.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                metadata,
                                style: colors.secondary.copyWith(fontSize: 14),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (bookmarked && !selecting)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            icons.bookmark,
                            size: 22,
                            color: colors.accent,
                          ),
                        ),
                      if (trailing != null) ...[
                        const SizedBox(width: 4),
                        trailing!,
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 40, end: 16),
                child: Divider(height: 1, thickness: .5, color: colors.line),
              ),
            ],
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
          AnimatedSize(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : NodeLaneTokens.disclosureDuration,
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Padding(
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

/// Keep conditional shortcuts on the same five-column grid, anchored left.
class MobileDetailShortcuts extends StatelessWidget {
  const MobileDetailShortcuts({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SizedBox(
      width: constraints.maxWidth,
      child: Wrap(
        spacing: NodeLaneTokens.space8,
        runSpacing: NodeLaneTokens.space8,
        children: [
          for (final child in children)
            SizedBox(
              width: (constraints.maxWidth - NodeLaneTokens.space8 * 4) / 5,
              child: child,
            ),
        ],
      ),
    ),
  );
}
