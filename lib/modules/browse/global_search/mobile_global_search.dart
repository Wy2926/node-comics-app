import 'package:flutter/material.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/browse/widgets/source_browse_panes.dart';
import 'package:mangayomi/modules/widgets/nodelane_pane_layout.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation only: editing a draft does not submit a source request.
class MobileGlobalSearchPage extends StatelessWidget {
  const MobileGlobalSearchPage({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.onClear,
    required this.scope,
    required this.query,
    required this.results,
    this.onScope,
    this.onDetails,
    this.visit = 0,
    this.website,
    this.book,
    this.lockParents = false,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit, onClear;
  final ValueChanged<BuildContext>? onScope, onDetails;
  final String scope, query;
  final Widget results;
  final int visit;
  final Widget? website, book;
  final bool lockParents;

  @override
  Widget build(BuildContext context) => MobileBrowsePage(
    title: context.l10n.search_titles,
    body: SourceResultsLayout(
      tools: NodeLaneToolbarPair(
        gap: NodeLaneTokens.space8,
        first: NodeLaneTextField.search(
          controller: controller,
          hint: context.l10n.search_title_hint,
          clearLabel: context.l10n.reset,
          enabled: !lockParents,
          onSubmitted: (_) => onSubmit(),
          onClear: onClear,
          autofocus: controller.text.isEmpty,
        ),
        second: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: NodeLaneTokens.space8,
          children: [
            Builder(
              builder: (anchor) => Tooltip(
                message: context.l10n.search_scope,
                child: TextButton(
                  onPressed: lockParents || onScope == null
                      ? null
                      : () => onScope!(anchor),
                  style: TextButton.styleFrom(
                    foregroundColor: NodeLaneTokens.of(context).ink,
                    padding: EdgeInsets.zero,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        NodeLaneIcons.of(context).web,
                        size: NodeLaneTokens.iconSize,
                      ),
                      const SizedBox(width: NodeLaneTokens.space8),
                      Flexible(child: Text(scope)),
                      const SizedBox(width: NodeLaneTokens.space4),
                      Icon(
                        NodeLaneIcons.of(context).down,
                        size: NodeLaneTokens.smallIconSize,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (onDetails != null)
              Builder(
                builder: (anchor) => TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: lockParents ? null : () => onDetails!(anchor),
                  child: Text(context.l10n.search_details),
                ),
              ),
          ],
        ),
      ),
      results: SourceBrowsePanes(
        visit: visit,
        website: website,
        book: book,
        lockParents: lockParents,
        directory: SingleChildScrollView(
          primary: false,
          key: ValueKey(query),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(bottom: NodeLaneTokens.space24),
          child: results,
        ),
      ),
    ),
  );
}
