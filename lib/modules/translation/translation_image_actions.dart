import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'translation_view_controller.dart';

List<TranslationAction> translationImageMenuActions(
  TranslationViewController controller,
  TranslationTarget target,
) {
  if (!controller.foreground ||
      controller.runtime == null ||
      controller.targetFor(target.page) == null) {
    return const [];
  }
  return const [
    TranslationAction.regenerate,
    TranslationAction.readResult,
  ].where(controller.state(target).actions.contains).toList();
}

/// The same per-image actions in the reader's existing menu and a web image menu.
class TranslationImageActions extends StatelessWidget {
  const TranslationImageActions({
    super.key,
    required this.controller,
    required this.target,
  });
  final TranslationViewController controller;
  final TranslationTarget target;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final actions = translationImageMenuActions(controller, target);
      if (actions.isEmpty) return const SizedBox.shrink();
      final icons = NodeLaneIcons.of(context);
      return NodeLaneGroupSurface(
        children: [
          for (final action in actions)
            NodeLaneRow(
              title: action == TranslationAction.regenerate
                  ? context.l10n.translation_regenerate_image
                  : context.l10n.translation_read_image,
              icon: action == TranslationAction.regenerate
                  ? icons.translate
                  : icons.refresh,
              enabled: !controller.isPerforming(target),
              onTap: () {
                Navigator.pop(context);
                controller.perform(target, action);
              },
            ),
        ],
      );
    },
  );
}

Future<void> showTranslationImageMenu(
  BuildContext context,
  TranslationViewController controller,
  TranslationTarget target,
) => showNodeLaneCatalogSheet<void>(
  context,
  NodeLaneCatalogSheet(
    title: context.l10n.translation_image_actions,
    fitContent: true,
    child: SingleChildScrollView(
      padding: NodeLaneTokens.modalContentPadding,
      child: TranslationImageActions(controller: controller, target: target),
    ),
  ),
);
