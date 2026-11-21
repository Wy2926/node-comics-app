import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'nodelane_bubble.dart';
import 'nodelane_controls.dart';
import 'nodelane_glass_surface.dart';
import 'nodelane_progress.dart';

class NodeLaneSelectionBar<T> extends StatelessWidget {
  const NodeLaneSelectionBar({
    super.key,
    required this.actions,
    required this.moreLabel,
    required this.moreItems,
    required this.onMore,
    this.busy = false,
  });
  final List<Widget> actions;
  final String moreLabel;
  final List<PopupMenuEntry<T>> moreItems;
  final ValueChanged<T> onMore;
  final bool busy;

  Future<void> _showMore(BuildContext button) async {
    final picked = await showNodeLaneBubble<T>(
      button,
      label: moreLabel,
      child: Semantics(
        role: SemanticsRole.menu,
        child: SingleChildScrollView(
          padding: PopupMenuTheme.of(button).menuPadding,
          child: ListBody(children: moreItems),
        ),
      ),
    );
    if (picked != null && button.mounted) onMore(picked);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    maintainBottomViewPadding: true,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NodeLaneTokens.space16,
        vertical: NodeLaneTokens.space8,
      ),
      child: NodeLaneGlassSurface(
        elevated: true,
        borderRadius: BorderRadius.circular(NodeLaneTokens.capsuleRadius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (busy && ModalRoute.of(context)?.isCurrent == true)
              const NodeLaneProgress(),
            Row(
              children: [
                for (final action in actions) Expanded(child: action),
                Expanded(
                  child: Builder(
                    builder: (button) => NodeLaneToolbarAction(
                      label: moreLabel,
                      icon: NodeLaneIcons.of(context).more,
                      enabled: !busy && moreItems.isNotEmpty,
                      onPressed: () => _showMore(button),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
