import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Density belongs to the display mode, never to the retired mobile column setting.
int mobileBookshelfColumns(double width, {required bool comfortable}) =>
    comfortable
    ? ((width + NodeLaneTokens.shelfGap) /
              (NodeLaneTokens.shelfComfortableWidth + NodeLaneTokens.shelfGap))
          .round()
          .clamp(2, 6)
    : ((width + NodeLaneTokens.shelfGap) /
              (NodeLaneTokens.shelfCompactWidth + NodeLaneTokens.shelfGap))
          .floor()
          .clamp(2, 8);

/// Display-only card: no database, history subscription or navigation.
class MobileBookshelfCard extends StatelessWidget {
  const MobileBookshelfCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
    required this.onLongPress,
    required this.selected,
    this.selectionMode = false,
    this.unreadCount = 0,
    this.downloadCount = 0,
    this.local = false,
    this.unreadLabel,
    this.continueButton,
    this.subtitle,
    this.coverOnly = false,
    this.list = false,
    this.first = true,
    this.last = true,
  });
  final String title;
  final String? subtitle, unreadLabel;
  final ImageProvider image;
  final VoidCallback onTap, onLongPress;
  final bool selected, selectionMode, coverOnly, list, local, first, last;
  final int unreadCount, downloadCount;
  final Widget? continueButton;
  String _count(int count) => count > 999 ? '999+' : '$count';

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final l10n = context.l10n;
    final selecting = selectionMode || selected;
    final unread = unreadCount > 0 && !selecting
        ? NodeLaneCoverBadge(
            _count(unreadCount),
            tone: NodeLaneBadgeTone.accent,
            semanticsLabel: '${unreadLabel ?? l10n.unread}: $unreadCount',
          )
        : null;
    final downloaded = downloadCount > 0 && !selecting
        ? NodeLaneCoverBadge(
            _count(downloadCount),
            icon: icons.download,
            tone: NodeLaneBadgeTone.neutral,
            semanticsLabel: '${l10n.downloaded}: $downloadCount',
          )
        : null;
    final localBadge = local && !selecting
        ? NodeLaneCoverBadge(
            list ? l10n.local : '',
            icon: icons.folderOutline,
            tone: NodeLaneBadgeTone.neutral,
            semanticsLabel: l10n.local,
          )
        : null;
    final cover = ClipRRect(
      borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dense =
              constraints.maxWidth < NodeLaneTokens.shelfComfortableWidth;
          return Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(
                color: t.soft,
                child: Image(
                  image: image,
                  fit: BoxFit.cover,
                  excludeFromSemantics: true,
                  errorBuilder: (_, _, _) => Icon(
                    icons.manga,
                    size: NodeLaneTokens.choicePreviewHeight,
                    color: t.muted,
                  ),
                ),
              ),
              if (selected) ColoredBox(color: t.accent.withValues(alpha: .11)),
              if (selected)
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      NodeLaneTokens.coverRadius,
                    ),
                    border: Border.all(color: t.accent, width: 2),
                  ),
                ),
              if (selecting)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    selected ? icons.selected : icons.unselected,
                    size: NodeLaneTokens.iconSize,
                    color: selected ? t.accent : t.surface,
                    shadows: const [
                      Shadow(blurRadius: 2, color: Colors.black54),
                    ],
                  ),
                ),
              if (!list && unread != null)
                Positioned(top: 8, right: 8, child: unread),
              if (!list && localBadge != null)
                Positioned(top: 8, left: 8, child: localBadge),
              if (!list && downloaded != null)
                Positioned(
                  left: 8,
                  top: dense
                      ? NodeLaneTokens.badgeHeight + NodeLaneTokens.space16
                      : null,
                  bottom: dense ? null : NodeLaneTokens.space8,
                  child: downloaded,
                ),
              if (!list && continueButton != null && !selecting)
                Positioned(bottom: 8, right: 8, child: continueButton!),
            ],
          );
        },
      ),
    );
    final titleLabel = Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: t.label,
    );
    final description = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (list)
          Row(
            children: [
              Flexible(child: titleLabel),
              if (unread != null) ...[
                const SizedBox(width: NodeLaneTokens.space4),
                unread,
              ],
            ],
          )
        else
          titleLabel,
        if (subtitle?.isNotEmpty == true) ...[
          const SizedBox(height: NodeLaneTokens.space4),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.caption,
          ),
        ],
        if (list && (downloaded != null || localBadge != null)) ...[
          const SizedBox(height: NodeLaneTokens.space8),
          Wrap(
            spacing: NodeLaneTokens.space4,
            runSpacing: NodeLaneTokens.space4,
            children: [?downloaded, ?localBadge],
          ),
        ],
      ],
    );
    final content = InkWell(
      borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
      onTap: onTap,
      onLongPress: onLongPress,
      onSecondaryTap: onLongPress,
      child: list
          ? Padding(
              padding: NodeLaneTokens.groupPadding,
              child: Row(
                children: [
                  SizedBox(
                    width: NodeLaneTokens.shelfThumbnailWidth,
                    height: NodeLaneTokens.shelfThumbnailHeight,
                    child: cover,
                  ),
                  const SizedBox(width: NodeLaneTokens.space16),
                  Expanded(child: description),
                  if (continueButton != null && !selecting) ...[
                    const SizedBox(width: NodeLaneTokens.space8),
                    continueButton!,
                  ],
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (coverOnly)
                  Expanded(child: cover)
                else
                  AspectRatio(
                    aspectRatio: 1 / NodeLaneTokens.coverAspectRatio,
                    child: cover,
                  ),
                if (!coverOnly)
                  Padding(
                    padding: const EdgeInsets.only(top: NodeLaneTokens.space8),
                    child: description,
                  ),
              ],
            ),
    );
    return Semantics(
      label: coverOnly ? title : null,
      selected: selected,
      button: true,
      child: list
          ? NodeLaneGroupSurface(
              first: first,
              last: last,
              child: Column(
                children: [content, if (!last) const NodeLaneGroupDivider()],
              ),
            )
          : Material(color: Colors.transparent, child: content),
    );
  }
}
