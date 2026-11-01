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

/// Builds secondary actions for each mount and releases them when collapsed.
class MobileDetailDisclosure extends StatelessWidget {
  const MobileDetailDisclosure({
    super.key,
    required this.title,
    required this.builder,
  });
  final String title;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return NodeLaneGroupSurface(
      child: ExpansionTile(
        minTileHeight: NodeLaneTokens.detailMoreHeight,
        dense: true,
        visualDensity: VisualDensity.standard,
        iconColor: colors.muted,
        collapsedIconColor: colors.muted,
        tilePadding: const EdgeInsets.symmetric(
          horizontal: NodeLaneTokens.space16,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(title, style: colors.detailSectionTitle),
        // ExpansionTile disposes collapsed children but retains their widgets.
        // Build again on mount so a single-subscription query is never reused.
        children: [Builder(builder: builder)],
      ),
    );
  }
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
        Expanded(child: reading!),
        const SizedBox(width: 10),
      ],
      Expanded(child: library),
    ],
  );
}

class MobileDetailButton extends StatelessWidget {
  const MobileDetailButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.primary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: primary
            ? colors.accent
            : Color.alphaBlend(
                colors.accent.withValues(alpha: .14),
                colors.surface,
              ),
        foregroundColor: primary ? colors.onAccent : colors.accent,
        minimumSize: const Size(0, NodeLaneTokens.detailActionHeight),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 26),
      label: Text(
        label,
        style: colors.label.copyWith(
          fontSize: 16,
          color: primary ? colors.onAccent : colors.accent,
        ),
      ),
    );
  }
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

/// Presentation of the existing expandable description and genre menu slots.
class MobileDetailSynopsis extends StatelessWidget {
  const MobileDetailSynopsis({
    super.key,
    required this.title,
    required this.text,
    required this.expanded,
    required this.onChanged,
    this.genres,
  });
  final String title, text;
  final bool expanded;
  final ValueChanged<bool> onChanged;
  final Widget? genres;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final labels = MaterialLocalizations.of(context);
    return NodeLaneGroupSurface(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (text.trim().isNotEmpty) ...[
              Semantics(
                expanded: expanded,
                button: true,
                child: InkWell(
                  onTap: () => onChanged(!expanded),
                  child: SizedBox(
                    height: NodeLaneTokens.minTapTarget,
                    child: Row(
                      children: [
                        Expanded(
                          child: Semantics(
                            header: true,
                            child: Text(
                              title,
                              style: colors.detailSectionTitle,
                            ),
                          ),
                        ),
                        Text(
                          expanded
                              ? labels.expandedIconTapHint
                              : labels.collapsedIconTapHint,
                          style: colors.secondary.copyWith(
                            color: colors.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => onChanged(!expanded),
                child: Text(
                  text.trim(),
                  maxLines: expanded ? null : 3,
                  overflow: expanded ? null : TextOverflow.ellipsis,
                  style: colors.secondary.copyWith(fontSize: 14, height: 1.7),
                ),
              ),
            ],
            if (genres != null) ...[
              if (text.trim().isNotEmpty) const SizedBox(height: 6),
              genres!,
            ],
          ],
        ),
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
        spacing: 6,
        runSpacing: 8,
        children: [
          for (final child in children)
            SizedBox(width: (constraints.maxWidth - 24) / 5, child: child),
        ],
      ),
    ),
  );
}

/// Small secondary actions; the caller supplies availability and callbacks.
class MobileDetailShortcut extends StatelessWidget {
  const MobileDetailShortcut({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Semantics(
      button: true,
      child: SizedBox(
        width: 62,
        height: 80,
        child: Material(
          color: colors.canvas,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 26, color: colors.ink),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: colors.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A 48 × 36 visual control inside a 48 × 44 tap target, as on the overview.
class MobileDetailFilterButton extends StatelessWidget {
  const MobileDetailFilterButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.active = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool active;
  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return SizedBox(
      width: 48,
      height: 44,
      child: Center(
        child: IconButton(
          tooltip: label,
          onPressed: onPressed,
          style: IconButton.styleFrom(
            minimumSize: const Size(48, 36),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            tapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: active ? colors.accentSoft : colors.surface,
            foregroundColor: active ? colors.accent : colors.ink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: Icon(NodeLaneIcons.of(context).filter, size: 22),
        ),
      ),
    );
  }
}
