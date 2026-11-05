import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_glass_surface.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
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
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          Padding(
            padding: NodeLaneTokens.modalTitlePadding,
            child: Semantics(
              namesRoute: true,
              header: true,
              child: DefaultTextStyle(style: t.title, child: title!),
            ),
          ),
        if (content != null)
          Padding(
            padding:
                title == null &&
                    contentPadding == NodeLaneTokens.modalContentPadding
                ? const EdgeInsets.all(NodeLaneTokens.space20)
                : contentPadding,
            child: DefaultTextStyle(style: t.body, child: content!),
          ),
      ],
    );
    return NodeLaneDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: scrollable ? SingleChildScrollView(child: body) : body,
          ),
          if (actions?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: NodeLaneModalActions(actions: actions!),
            ),
        ],
      ),
    );
  }
}

/// For dialogs with their own bounded list and fixed footer.
class NodeLaneDialog extends StatelessWidget {
  const NodeLaneDialog({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => NodeLaneModalScope(
    child: Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: NodeLaneTokens.dialogMaxWidth,
        child: NodeLaneGlassSurface(
          borderRadius: BorderRadius.circular(NodeLaneTokens.modalRadius),
          grouped: true,
          child: child,
        ),
      ),
    ),
  );
}

/// Shared by dialogs and sheet footers. Narrow or enlarged text stacks the
/// same actions rather than squeezing labels or changing their semantics.
class NodeLaneModalActions extends StatelessWidget {
  const NodeLaneModalActions({super.key, required this.actions});
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final stacked =
          actions.length != 2 ||
          constraints.maxWidth < 280 ||
          MediaQuery.textScalerOf(context).scale(15) > 20;
      Widget sized(Widget action) => ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: NodeLaneTokens.modalActionHeight,
        ),
        child: action,
      );
      return stacked
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(height: NodeLaneTokens.space8),
                  sized(actions[i]),
                ],
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: sized(actions[0])),
                const SizedBox(width: NodeLaneTokens.space12),
                Expanded(child: sized(actions[1])),
              ],
            );
    },
  );
}

class NodeLaneDialogAction extends StatelessWidget {
  const NodeLaneDialogAction({
    super.key,
    required this.label,
    this.onPressed,
    this.secondary = false,
    this.destructive = false,
    this.busy = false,
  }) : assert(!secondary || !destructive);
  final String label;
  final VoidCallback? onPressed;
  final bool secondary, destructive, busy;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Text(label, textAlign: TextAlign.center);
    final child = busy
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: NodeLaneTokens.smallIconSize,
                child: CircularProgressIndicator(
                  strokeWidth: NodeLaneTokens.progressTrackHeight,
                  color: NodeLaneTokens.of(context).muted,
                ),
              ),
              const SizedBox(width: NodeLaneTokens.space8),
              Flexible(child: text),
            ],
          )
        : text;
    if (secondary) {
      return NodeLaneSecondaryButton(
        onPressed: busy ? null : onPressed,
        child: child,
      );
    }
    return FilledButton(
      onPressed: busy ? null : onPressed,
      style: destructive
          ? FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
            )
          : null,
      child: child,
    );
  }
}

/// Only returns a decision. Persistence and recovery remain with the caller.
Future<bool> showNodeLaneConfirmation(
  BuildContext context, {
  required String title,
  String? message,
  required String confirmLabel,
  bool destructive = false,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => NodeLaneAlertDialog(
        title: Text(title),
        content: message == null ? null : Text(message),
        actions: [
          NodeLaneDialogAction(
            label: context.l10n.cancel,
            secondary: true,
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          NodeLaneDialogAction(
            label: confirmLabel,
            destructive: destructive,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    ) ??
    false;

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
