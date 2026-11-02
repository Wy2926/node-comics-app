import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
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
        appBar: AppBar(
          leading:
              leading ??
              IconButton(
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Navigator.maybePop(context),
                icon: Icon(NodeLaneIcons.of(context).back),
              ),
          // AppBar caps title scaling; reserve two lines without applying
          // the much larger accessibility body-text scale to the whole bar.
          toolbarHeight:
              56 +
              (MediaQuery.textScalerOf(context).scale(20) - 20).clamp(0, 16),
          centerTitle: false,
          title: Text(
            title,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: colors.readerTitle,
          ),
          actions: actions,
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
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    child: bottomAction,
                  ),
                ),
              ),
      ),
    );
  }
}

class MobileBrowseGroup extends StatelessWidget {
  const MobileBrowseGroup({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: NodeLaneGroupSurface(child: child),
    );
  }
}
