import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

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
      padding: const EdgeInsets.only(bottom: NodeLaneTokens.space20),
      child: NodeLaneSegments<ItemType?>(
        value: selected,
        segments: [
          for (final type in types)
            ButtonSegment(
              value: type,
              label: Text(type.localized(context.l10n)),
            ),
        ],
        onChanged: onChanged == null
            ? null
            : (type) {
                if (type != null) onChanged!(type);
              },
      ),
    );
  }
}
