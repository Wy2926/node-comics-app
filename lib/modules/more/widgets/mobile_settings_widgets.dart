import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';

/// Small presentation pieces shared by the mobile More and Settings menus.
/// Routes, preferences, and side effects stay with their existing owners.
class MobileSettingsGroup extends StatelessWidget {
  const MobileSettingsGroup({
    super.key,
    this.title,
    required this.children,
    this.spacing,
  });

  final String? title;
  final List<Widget> children;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final reader = NodeLaneReaderScope.activeOf(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: spacing ?? (reader ? 16 : NodeLaneTokens.space24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(
                left: NodeLaneTokens.space4,
                bottom: NodeLaneTokens.space8,
              ),
              child: NodeLaneSectionHeading(title!),
            ),
          NodeLaneGroupSurface(outlined: reader, children: children),
        ],
      ),
    );
  }
}
