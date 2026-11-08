import 'package:flutter/material.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
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
  });

  final TextEditingController controller;
  final VoidCallback onSubmit, onClear;
  final VoidCallback? onScope, onDetails;
  final String scope, query;
  final Widget results;

  @override
  Widget build(BuildContext context) => MobileBrowsePage(
    title: context.l10n.search_titles,
    actions: [
      NodeLaneMenuButton<String>(
        icon: NodeLaneIcons.of(context).more,
        tooltip: context.l10n.search_actions,
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 'scope',
            enabled: onScope != null,
            child: Text(context.l10n.search_scope),
          ),
          PopupMenuItem(
            value: 'details',
            enabled: onDetails != null,
            child: Text(context.l10n.search_details),
          ),
        ],
        onSelected: (action) =>
            action == 'scope' ? onScope?.call() : onDetails?.call(),
      ),
    ],
    body: LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight * .5),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                NodeLaneTokens.gutter,
                NodeLaneTokens.space8,
                NodeLaneTokens.gutter,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NodeLaneTextField.search(
                    controller: controller,
                    hint: context.l10n.search_title_hint,
                    clearLabel: context.l10n.reset,
                    onSubmitted: (_) => onSubmit(),
                    onClear: onClear,
                    autofocus: controller.text.isEmpty,
                  ),
                  const SizedBox(height: NodeLaneTokens.space8),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: NodeLaneTokens.space8,
                    children: [
                      TextButton(
                        onPressed: onScope,
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
                      if (onDetails != null)
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: onDetails,
                          child: Text(context.l10n.search_details),
                        ),
                    ],
                  ),
                  Divider(height: 1, color: NodeLaneTokens.of(context).line),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              key: ValueKey(query),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(bottom: NodeLaneTokens.space24),
              child: results,
            ),
          ),
        ],
      ),
    ),
  );
}
