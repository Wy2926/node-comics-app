import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_glass_surface.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Shared styling only; callers retain navigation, state and persistence.
class NodeLaneModalScope extends StatelessWidget {
  const NodeLaneModalScope({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Theme(data: nodeLaneModalTheme(Theme.of(context)), child: child);
}

class NodeLaneAlertDialog extends StatelessWidget {
  const NodeLaneAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.scrollable = true,
    this.contentPadding = NodeLaneTokens.modalContentPadding,
  });

  final Widget? title, content;
  final List<Widget>? actions;
  final bool scrollable;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) => NodeLaneModalScope(
    child: AlertDialog(
      title: title,
      content: content,
      actions: actions,
      scrollable: scrollable,
      titlePadding: NodeLaneTokens.modalTitlePadding,
      contentPadding: contentPadding,
      actionsOverflowButtonSpacing: 8,
    ),
  );
}

/// For dialogs with their own bounded list and fixed footer.
class NodeLaneDialog extends StatelessWidget {
  const NodeLaneDialog({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      NodeLaneModalScope(child: Dialog(child: child));
}

/// Existing sheets keep their own SafeArea, height and keyboard handling.
class NodeLaneSheetSurface extends StatelessWidget {
  const NodeLaneSheetSurface({
    super.key,
    required this.child,
    this.grouped = false,
    this.radius = NodeLaneTokens.modalRadius,
  });
  final Widget child;
  final bool grouped;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return NodeLaneModalScope(
      child: NodeLaneGlassSurface(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
        grouped: grouped,
        child: child,
      ),
    );
  }
}
