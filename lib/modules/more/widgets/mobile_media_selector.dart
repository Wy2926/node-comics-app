import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

/// Wrap instead of compressing the three media labels into one fixed row.
class MobileMediaSelector extends StatelessWidget {
  const MobileMediaSelector({
    super.key,
    required this.types,
    required this.selected,
    required this.onChanged,
  });
  final List<ItemType> types;
  final ItemType? selected;
  final ValueChanged<ItemType>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (types.length < 2) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final type in types)
            ChoiceChip(
              label: Text(type.localized(context.l10n)),
              selected: selected == type,
              showCheckmark: false,
              onSelected: onChanged == null
                  ? null
                  : (_) {
                      if (type != selected) onChanged!(type);
                    },
            ),
        ],
      ),
    );
  }
}
