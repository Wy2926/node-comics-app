import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';

import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

Future<void> showSourceToolMenu<T>(
  BuildContext anchor, {
  required String title,
  required List<(T, String, IconData)> Function() items,
  required Future<void> Function(BuildContext menu, T action) onSelected,
  Offset? localPoint,
}) => NodeLaneBubbleFlow.open<void>(
  anchor,
  title: title,
  localPoint: localPoint,
  child: StatefulBuilder(
    builder: (menu, refresh) => Semantics(
      role: SemanticsRole.menu,
      container: true,
      explicitChildNodes: true,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: NodeLaneTokens.space4),
        children: [
          for (final (action, label, icon) in items())
            NodeLaneRow(
              compact: true,
              title: label,
              icon: icon,
              onOpen: (anchor) async {
                if (ModalRoute.isCurrentOf(menu) != true) return;
                await onSelected(anchor, action);
                if (menu.mounted && ModalRoute.isCurrentOf(menu) == true) {
                  refresh(() {});
                }
              },
            ),
        ],
      ),
    ),
  ),
);
