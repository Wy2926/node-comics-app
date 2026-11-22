import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

/// Single-media picker; its caller owns the selection and available types.
class LibraryMediaButton extends StatelessWidget {
  const LibraryMediaButton({
    super.key,
    required this.value,
    required this.availableTypes,
    required this.onChanged,
    this.badgeBuilder,
  });

  final ItemType value;
  final Iterable<ItemType> availableTypes;
  final ValueChanged<ItemType>? onChanged;

  /// Optional menu-row counts; the toolbar trigger stays identical on all pages.
  final Widget? Function(ItemType)? badgeBuilder;

  static IconData iconFor(BuildContext context, ItemType type) {
    final icons = NodeLaneIcons.of(context);
    return switch (type) {
      ItemType.manga => icons.manga,
      ItemType.anime => icons.anime,
      ItemType.novel => icons.novel,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final types = availableTypes.toSet();
    final l10n = context.l10n;
    if (types.isEmpty) return const SizedBox.shrink();
    return NodeLaneBubbleButton<ItemType>(
      enabled: types.length > 1 && onChanged != null,
      tooltip: value.localized(l10n),
      onSelected: (type) {
        if (type != value) onChanged?.call(type);
      },
      itemBuilder: (_) => [
        for (final type in types)
          PopupMenuItem<ItemType>(
            value: type,
            height: NodeLaneTokens.menuItemHeight,
            padding: EdgeInsets.zero,
            child: NodeLaneRow(
              title: type.localized(l10n),
              icon: iconFor(context, type),
              selected: type == value,
              accented: type == value,
              valueLeading: badgeBuilder?.call(type),
            ),
          ),
      ],
      child: Container(
        constraints: const BoxConstraints(
          minHeight: NodeLaneTokens.minTapTarget,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: NodeLaneTokens.space12,
          vertical: NodeLaneTokens.space8,
        ),
        decoration: BoxDecoration(
          color: colors.soft,
          borderRadius: BorderRadius.circular(NodeLaneTokens.capsuleRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconFor(context, value),
              color: colors.accent,
              size: NodeLaneTokens.smallIconSize,
            ),
            const SizedBox(width: NodeLaneTokens.space8),
            Flexible(
              child: Text(
                value.localized(l10n),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: colors.label,
              ),
            ),
            if (types.length > 1) ...[
              const SizedBox(width: NodeLaneTokens.space8),
              Icon(
                NodeLaneIcons.of(context).down,
                color: colors.ink,
                size: NodeLaneTokens.smallIconSize,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
