import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Display-only shelf toolbar. Its owner retains search, import and filters.
class MobileBookshelfHeader extends StatelessWidget {
  static double preferredHeight(double textScale) =>
      184 + 96 * (textScale - 1).clamp(0, 3);
  const MobileBookshelfHeader({
    super.key,
    required this.title,
    required this.searchLabel,
    required this.importLabel,
    required this.filterLabel,
    required this.controller,
    required this.onSearchChanged,
    required this.onImport,
    required this.onFilter,
    required this.mediaMenu,
    required this.menu,
    required this.filtered,
    this.updateControl,
  });

  final String title, searchLabel, importLabel, filterLabel;
  final TextEditingController controller;
  final VoidCallback onSearchChanged, onImport, onFilter;
  final Widget mediaMenu, menu;
  final Widget? updateControl;
  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    return Material(
      color: colors.canvas,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: NodeLaneTokens.headerPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NodeLanePageHeading(
                title: title,
                mediaMenu: mediaMenu,
                actions: [
                  ?updateControl,
                  NodeLaneIconButton(
                    tooltip: importLabel,
                    onPressed: onImport,
                    icon: icons.add,
                  ),
                  const SizedBox(width: NodeLaneTokens.space8),
                  menu,
                ],
              ),
              const SizedBox(height: NodeLaneTokens.space16),
              Row(
                children: [
                  Expanded(
                    child: NodeLaneTextField.search(
                      controller: controller,
                      onChanged: (_) => onSearchChanged(),
                      hint: searchLabel,
                    ),
                  ),
                  const SizedBox(width: NodeLaneTokens.space8),
                  NodeLaneIconButton(
                    tooltip: filterLabel,
                    onPressed: onFilter,
                    icon: icons.adjustments,
                    active: filtered,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
