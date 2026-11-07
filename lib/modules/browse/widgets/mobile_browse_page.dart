import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Shared presentation for the source, language and repository settings pages.
class MobileBrowsePage extends StatelessWidget {
  const MobileBrowsePage({
    super.key,
    required this.title,
    required this.body,
    this.leading,
    this.actions,
    this.bottomAction,
  });

  final String title;
  final Widget body;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? bottomAction;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(
          context,
          title: title,
          leading: leading,
          actions: actions ?? const [],
        ),
        body: SafeArea(top: false, child: body),
        bottomNavigationBar: bottomAction == null
            ? null
            : DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(top: BorderSide(color: colors.line)),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NodeLaneTokens.gutter,
                      vertical: NodeLaneTokens.space12,
                    ),
                    child: bottomAction,
                  ),
                ),
              ),
      ),
    );
  }
}
