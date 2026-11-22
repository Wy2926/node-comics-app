import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/nodelane_confirm_panel.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

class MobileBrowseCleanupPanel extends StatefulWidget {
  const MobileBrowseCleanupPanel({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.chooseTypes = false,
  });
  final String title, message;
  final bool chooseTypes;
  final Future<void> Function(List<ItemType>) onConfirm;
  @override
  State<MobileBrowseCleanupPanel> createState() => _CleanupState();
}

class _CleanupState extends State<MobileBrowseCleanupPanel> {
  final selected = <ItemType>{};
  @override
  Widget build(BuildContext context) => NodeLaneConfirmPanel(
    title: widget.title,
    message: widget.message,
    confirmLabel: context.l10n.dialog_confirm,
    destructive: true,
    enabled: !widget.chooseTypes || selected.isNotEmpty,
    onConfirm: () =>
        widget.onConfirm(ItemType.values.where(selected.contains).toList()),
    options: !widget.chooseTypes
        ? null
        : (enabled) => NodeLaneGroupSurface(
            children: [
              for (final type in ItemType.values)
                NodeLaneRow(
                  title: type.localized(context.l10n),
                  checkable: true,
                  selected: selected.contains(type),
                  enabled: enabled,
                  onTap: !enabled
                      ? null
                      : () => setState(() {
                          if (!selected.remove(type)) selected.add(type);
                        }),
                ),
            ],
          ),
  );
}
