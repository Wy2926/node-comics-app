import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Density belongs to the display mode, never to the retired mobile column setting.
int mobileBookshelfColumns(
  double width, {
  required bool comfortable,
  TextScaler textScaler = TextScaler.noScaling,
}) {
  final preferred = comfortable
      ? ((width + NodeLaneTokens.shelfGap) /
                (NodeLaneTokens.shelfComfortableWidth +
                    NodeLaneTokens.shelfGap))
            .round()
            .clamp(2, 6)
      : 8;
  final minimumWidth =
      NodeLaneTokens.shelfCompactWidth *
      math.max(
        1,
        textScaler.scale(NodeLaneTokens.captionSize) /
            NodeLaneTokens.captionSize,
      );
  final fitting =
      ((width + NodeLaneTokens.shelfGap) /
              (minimumWidth + NodeLaneTokens.shelfGap))
          .floor()
          .clamp(1, 8);
  return math.min(preferred, fitting);
}

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
    this.isLocal = false,
    this.showLocal = true,
    this.source,
    this.language,
    this.unreadLabel,
    this.continueButton,
    this.coverOnly = false,
    this.list = false,
    this.first = true,
    this.last = true,
  });
  final String title;

  /// Already filtered by the existing source/language display preferences.
  final String? source, language, unreadLabel;
  final ImageProvider image;
  final VoidCallback onTap, onLongPress;
  final bool selected,
      selectionMode,
      coverOnly,
      list,
      isLocal,
      showLocal,
      first,
      last;
  final int unreadCount, downloadCount;
  final Widget? continueButton;
  String _count(int count) => count > 999 ? '999+' : '$count';

  /// Reserve two title lines and one metadata band, including download-only
  /// configurations. [_captionStrut] keeps fallback fonts within these line
  /// boxes. Selection never changes the grid's cover positions.
  static double captionHeight(BuildContext context, {required bool metadata}) {
    final t = NodeLaneTokens.of(context);
    final scale = MediaQuery.textScalerOf(context);
    final lineHeight = MediaQuery.maybeLineHeightScaleFactorOverrideOf(context);
    return NodeLaneTokens.space8 +
        (scale.scale(t.label.fontSize!) * (lineHeight ?? t.label.height!))
                .ceilToDouble() *
            2 +
        (metadata
            ? NodeLaneTokens.space4 +
                  math.max(
                    NodeLaneTokens.badgeHeight,
                    (scale.scale(t.caption.fontSize!) *
                            (lineHeight ?? t.caption.height!))
                        .ceilToDouble(),
                  )
            : 0);
  }

  // Mixed-script fallback fonts can otherwise add ascent/descent beyond the
  // token line height. Keep the user's font, with one shared line-box rule.
  static StrutStyle _captionStrut(BuildContext context, TextStyle style) =>
      StrutStyle.fromTextStyle(
        DefaultTextStyle.of(context).style.merge(style),
        leading: 0,
        forceStrutHeight: true,
      );

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final l10n = context.l10n;
    final selecting = selectionMode || selected;
    final stackedList =
        list &&
        MediaQuery.textScalerOf(context).scale(NodeLaneTokens.bookTitleSize) >
            NodeLaneTokens.bookTitleSize * 1.5;
    // Local archive fields may contain an upstream source/language placeholder.
    // Resolve their identity here once for all four display modes.
    final identity = isLocal
        ? (showLocal ? l10n.local : '')
        : [
            source?.trim() ?? '',
            language?.trim().toUpperCase() ?? '',
          ].where((value) => value.isNotEmpty).join(' · ');
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
            tone: coverOnly
                ? NodeLaneBadgeTone.neutral
                : NodeLaneBadgeTone.soft,
            semanticsLabel: '${l10n.downloaded}: $downloadCount',
          )
        : null;
    final localBadge = coverOnly && isLocal && showLocal && !selecting
        ? NodeLaneCoverBadge(
            '',
            icon: icons.folderOutline,
            tone: NodeLaneBadgeTone.neutral,
            semanticsLabel: l10n.local,
          )
        : null;
    final cover = ClipRRect(
      borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
      child: Stack(
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
                borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
                border: Border.all(color: t.accent, width: 2),
              ),
            ),
          if (selecting)
            PositionedDirectional(
              top: NodeLaneTokens.space8,
              end: NodeLaneTokens.space8,
              child: Icon(
                selected ? icons.selected : icons.unselected,
                size: NodeLaneTokens.iconSize,
                color: selected ? t.accent : t.surface,
                shadows: const [Shadow(blurRadius: 2, color: Colors.black54)],
              ),
            ),
          if (!list && !selecting)
            PositionedDirectional(
              top: NodeLaneTokens.space8,
              start: NodeLaneTokens.space8,
              end: NodeLaneTokens.space8,
              child: Wrap(
                alignment:
                    localBadge != null || (coverOnly && downloaded != null)
                    ? WrapAlignment.spaceBetween
                    : WrapAlignment.end,
                spacing: NodeLaneTokens.space4,
                runSpacing: NodeLaneTokens.space8,
                children: [
                  if (localBadge != null || (coverOnly && downloaded != null))
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ?localBadge,
                        if (localBadge != null && downloaded != null)
                          const SizedBox(height: NodeLaneTokens.space8),
                        if (coverOnly && downloaded != null) downloaded,
                      ],
                    ),
                  ?unread,
                ],
              ),
            ),
          if (!list && continueButton != null && !selecting)
            PositionedDirectional(
              bottom: NodeLaneTokens.space8,
              end: NodeLaneTokens.space8,
              child: continueButton!,
            ),
        ],
      ),
    );
    final titleLabel = Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: t.label,
      strutStyle: _captionStrut(context, t.label),
    );
    final description = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (stackedList)
          Wrap(
            spacing: NodeLaneTokens.space4,
            runSpacing: NodeLaneTokens.space4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [titleLabel, ?unread],
          )
        else if (list)
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
        if (identity.isNotEmpty || downloaded != null) ...[
          const SizedBox(height: NodeLaneTokens.space4),
          Row(
            children: [
              if (identity.isNotEmpty)
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        if (isLocal)
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                end: NodeLaneTokens.space4,
                              ),
                              child: Icon(
                                icons.folderOutline,
                                size: NodeLaneTokens.badgeIconSize,
                                color: t.muted,
                              ),
                            ),
                          ),
                        TextSpan(text: identity),
                      ],
                    ),
                    semanticsLabel: identity,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.caption,
                    strutStyle: _captionStrut(context, t.caption),
                  ),
                ),
              if (identity.isNotEmpty && downloaded != null)
                const SizedBox(width: NodeLaneTokens.space4),
              ?downloaded,
            ],
          ),
        ],
      ],
    );
    final thumbnail = SizedBox(
      width: NodeLaneTokens.shelfThumbnailWidth,
      height: NodeLaneTokens.shelfThumbnailHeight,
      child: cover,
    );
    final readAction = continueButton != null && !selecting
        ? continueButton
        : null;
    final content = InkWell(
      borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
      onTap: onTap,
      onLongPress: onLongPress,
      onSecondaryTap: onLongPress,
      child: list
          ? Padding(
              padding: NodeLaneTokens.groupPadding,
              child: stackedList
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [thumbnail, const Spacer(), ?readAction]),
                        const SizedBox(height: NodeLaneTokens.space8),
                        description,
                      ],
                    )
                  : Row(
                      children: [
                        thumbnail,
                        const SizedBox(width: NodeLaneTokens.space16),
                        Expanded(child: description),
                        if (readAction != null) ...[
                          const SizedBox(width: NodeLaneTokens.space8),
                          readAction,
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
