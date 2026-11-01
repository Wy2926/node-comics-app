import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

/// Shared by library, browse, history and updates; no navigation state is owned here.
class MobileMediaMenu extends StatelessWidget {
  const MobileMediaMenu({
    super.key,
    required this.value,
    required this.availableTypes,
    required this.onChanged,
    this.badgeBuilder,
  });

  final ItemType value;
  final Iterable<ItemType> availableTypes;
  final ValueChanged<ItemType> onChanged;
  final Widget? Function(ItemType)? badgeBuilder;

  static IconData _icon(
    BuildContext context,
    ItemType type, {
    bool filled = false,
  }) {
    final icons = NodeLaneIcons.of(context);
    return switch (type) {
      ItemType.manga => filled ? icons.mangaSelected : icons.manga,
      ItemType.anime => icons.anime,
      ItemType.novel => icons.novel,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final types = availableTypes.toSet().toList();
    final l10n = context.l10n;
    if (types.isEmpty) return const SizedBox.shrink();
    return Theme(
      data: nodeLaneModalTheme(Theme.of(context)),
      child: PopupMenuButton<ItemType>(
        enabled: types.length > 1,
        useRootNavigator: true,
        position: PopupMenuPosition.under,
        offset: const Offset(0, 6),
        constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
        borderRadius: BorderRadius.circular(NodeLaneTokens.capsuleRadius),
        onSelected: (type) {
          if (type != value) onChanged(type);
        },
        itemBuilder: (_) => [
          for (final type in types)
            PopupMenuItem<ItemType>(
              value: type,
              height: NodeLaneTokens.menuItemHeight,
              padding: EdgeInsets.zero,
              child: Semantics(
                selected: type == value,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: NodeLaneTokens.menuItemHeight,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: type == types.last
                        ? null
                        : Border(bottom: BorderSide(color: colors.line)),
                    borderRadius: BorderRadius.circular(
                      NodeLaneTokens.controlRadius,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _icon(context, type),
                        size: 22,
                        color: type == value ? colors.accent : colors.muted,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          type.localized(l10n),
                          style: TextStyle(
                            color: colors.ink,
                            fontSize: 15,
                            fontWeight: type == value
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      ?badgeBuilder?.call(type),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 20,
                        child: type == value
                            ? Icon(
                                NodeLaneIcons.of(context).check,
                                color: colors.accent,
                                size: 20,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
        child: Semantics(
          button: types.length > 1,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: NodeLaneTokens.minTapTarget,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: BorderRadius.circular(NodeLaneTokens.capsuleRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _icon(context, value, filled: true),
                  color: colors.accent,
                  size: NodeLaneTokens.smallIconSize,
                ),
                const SizedBox(width: NodeLaneTokens.space8),
                Flexible(
                  child: Text(
                    value.localized(l10n),
                    style: TextStyle(
                      color: colors.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (badgeBuilder != null) ...[
                  const SizedBox(width: 8),
                  ?badgeBuilder?.call(value),
                ],
                if (types.length > 1) ...[
                  const SizedBox(width: 8),
                  Icon(
                    NodeLaneIcons.of(context).down,
                    color: colors.muted,
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
