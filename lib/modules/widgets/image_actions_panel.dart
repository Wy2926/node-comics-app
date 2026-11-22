import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

/// Each action gets a mounted context for confirmation or a native share popover.
class ImageActionsPanel extends StatelessWidget {
  const ImageActionsPanel({
    super.key,
    required this.onSetCover,
    required this.onShare,
    required this.onSave,
    this.footer,
  });
  final ValueChanged<BuildContext> onSetCover, onShare, onSave;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    return NodeLaneBubblePanel(
      title: l.reader_image_actions,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          for (final (label, icon, action) in [
            (l.set_as_cover, icons.image, onSetCover),
            (l.share, icons.share, onShare),
            (l.save, icons.saveImage, onSave),
          ])
            Builder(
              builder: (row) => NodeLaneRow(
                title: label,
                icon: icon,
                onTap: () => action(row),
              ),
            ),
          ?footer,
        ],
      ),
    );
  }
}
