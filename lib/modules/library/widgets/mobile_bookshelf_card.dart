import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// No database or navigation dependencies; all existing entry actions are slots.
class MobileBookshelfCard extends StatelessWidget {
  const MobileBookshelfCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
    required this.onLongPress,
    required this.selected,
    this.badges,
    this.continueButton,
    this.subtitle,
    this.coverOnly = false,
    this.list = false,
  });

  final String title;
  final String? subtitle;
  final ImageProvider image;
  final VoidCallback onTap, onLongPress;
  final bool selected, coverOnly, list;
  final Widget? badges, continueButton;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final cover = ClipRRect(
      borderRadius: BorderRadius.circular(
        list ? 10 : NodeLaneTokens.coverRadius,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: colors.soft,
            child: Image(
              image: image,
              fit: BoxFit.cover,
              excludeFromSemantics: true,
              errorBuilder: (_, _, _) => Icon(
                NodeLaneIcons.of(context).manga,
                size: 36,
                color: colors.muted,
              ),
            ),
          ),
          if (selected) ColoredBox(color: colors.accent.withValues(alpha: .24)),
          if (badges != null)
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: selected ? Alignment.topLeft : Alignment.topRight,
                child: badges,
              ),
            ),
          if (selected)
            Positioned(
              top: 8,
              right: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    NodeLaneIcons.of(context).check,
                    size: 18,
                    color: colors.onAccent,
                  ),
                ),
              ),
            ),
          if (continueButton != null && !selected)
            Positioned(bottom: 8, right: 8, child: continueButton!),
        ],
      ),
    );
    final description = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: colors.label,
        ),
        if (subtitle?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: colors.caption,
          ),
        ],
      ],
    );
    return Semantics(
      label: coverOnly ? title : null,
      selected: selected,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
          onTap: onTap,
          onLongPress: onLongPress,
          onSecondaryTap: onLongPress,
          child: list
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(width: 78, height: 110, child: cover),
                      const SizedBox(width: 16),
                      Expanded(child: description),
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
                    Expanded(child: cover),
                    if (!coverOnly)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: NodeLaneTokens.space8,
                        ),
                        child: description,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
