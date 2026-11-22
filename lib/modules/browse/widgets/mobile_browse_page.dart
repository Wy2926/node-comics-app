import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_pane_layout.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

Future<T?> pushBrowsePage<T>(BuildContext context, Widget page) =>
    NodeLaneBubbleFlow.contains(context)
    ? NodeLaneBubbleFlow.push<T>(context, page)
    : Navigator.of(
        context,
        rootNavigator: true,
      ).push<T>(MaterialPageRoute<T>(builder: (_) => page));

/// Compact navigation and a keyboard-safe footer for mobile tools and forms.
class MobileBrowsePage extends StatelessWidget {
  const MobileBrowsePage({
    super.key,
    required this.title,
    required this.body,
    this.leading,
    this.actions,
    this.bottomAction,
  }) : _form = false;

  const MobileBrowsePage.form({
    super.key,
    required this.title,
    required this.body,
    this.leading,
    this.actions,
    this.bottomAction,
  }) : _form = true;

  final String title;
  final bool _form;
  final Widget body;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? bottomAction;

  @override
  Widget build(BuildContext context) {
    if (NodeLaneBubbleFlow.contains(context)) {
      return NodeLaneBubblePanel(
        title: title,
        actions: actions ?? const [],
        closeButton:
            leading ??
            (ModalRoute.of(context) is PageRoute
                ? BackButton(onPressed: () => Navigator.maybePop(context))
                : null),
        footer: bottomAction,
        child: body,
      );
    }
    final colors = NodeLaneTokens.of(context);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(
          context,
          title: title,
          leading: leading,
          actions: actions ?? const [],
        ),
        body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _form ? NodeLaneFormColumn(child: body) : body),
              if (bottomAction != null)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    border: Border(top: BorderSide(color: colors.line)),
                  ),
                  child: NodeLaneFormColumn(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: NodeLaneTokens.gutter,
                        vertical: NodeLaneTokens.space12,
                      ),
                      child: bottomAction,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
