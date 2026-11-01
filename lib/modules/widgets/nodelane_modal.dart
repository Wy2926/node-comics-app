import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Shared styling only; callers retain navigation, state and persistence.
class NodeLaneModalScope extends StatelessWidget {
  const NodeLaneModalScope({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = nodeLaneModalTheme(Theme.of(context));
    final colors = NodeLaneTokens.fromTheme(base);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
    );
    final buttonStyle = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size(44, NodeLaneTokens.minTapTarget),
      ),
      shape: WidgetStatePropertyAll(shape),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16),
      ),
    );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
      borderSide: BorderSide(color: colors.line),
    );
    return Theme(
      data: base.copyWith(
        textButtonTheme: TextButtonThemeData(
          style: base.textButtonTheme.style?.merge(buttonStyle) ?? buttonStyle,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style:
              base.filledButtonTheme.style?.merge(buttonStyle) ?? buttonStyle,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style:
              base.outlinedButtonTheme.style?.merge(buttonStyle) ?? buttonStyle,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style:
              base.elevatedButtonTheme.style?.merge(buttonStyle) ?? buttonStyle,
        ),
        inputDecorationTheme: base.inputDecorationTheme.copyWith(
          filled: true,
          fillColor: colors.soft,
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(color: colors.accent, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
      child: child,
    );
  }
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
    final colors = NodeLaneTokens.of(context);
    return NodeLaneModalScope(
      child: Material(
        color: grouped ? colors.canvas : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
          side: BorderSide(color: colors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

class NodeLaneSheetHeading extends StatelessWidget {
  const NodeLaneSheetHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.onClose,
    this.detail = false,
    this.centerTitle = false,
    this.description,
  });
  final String title;
  final String? subtitle;
  final VoidCallback? onClose;
  final bool detail, centerTitle;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    if (detail) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 52,
                height: 6,
                decoration: BoxDecoration(
                  color: colors.muted.withValues(alpha: .35),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: centerTitle ? 44 : 0,
                      right: 44,
                    ),
                    child: Align(
                      alignment: centerTitle
                          ? Alignment.center
                          : AlignmentDirectional.centerStart,
                      child: Semantics(
                        header: true,
                        child: Text(
                          title,
                          style: colors.detailTitle.copyWith(
                            fontSize: centerTitle ? 22 : 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .closeButtonTooltip,
                      onPressed: onClose ?? () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: colors.soft,
                        foregroundColor: colors.ink,
                        minimumSize: const Size(36, 36),
                        tapTargetSize: MaterialTapTargetSize.padded,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(8),
                      ),
                      icon: Icon(NodeLaneIcons.of(context).close, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                style: centerTitle
                    ? colors.secondary.copyWith(fontSize: 14)
                    : colors.body.copyWith(fontSize: 18),
              ),
            ],
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: colors.secondary.copyWith(fontSize: 14),
              ),
            ],
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NodeLaneTokens.gutter,
        NodeLaneTokens.space8,
        NodeLaneTokens.gutter,
        NodeLaneTokens.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colors.muted.withValues(alpha: .45),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: NodeLaneTokens.space8),
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(title, style: colors.title),
                ),
              ),
              NodeLaneIconButton(
                icon: NodeLaneIcons.of(context).close,
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                style: NodeLaneIconButtonStyle.field,
                onPressed: onClose ?? () => Navigator.pop(context),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: NodeLaneTokens.space4),
            Text(subtitle!, style: colors.secondary),
          ],
        ],
      ),
    );
  }
}
