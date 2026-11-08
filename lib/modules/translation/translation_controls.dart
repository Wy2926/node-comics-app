import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/widgets/mobile_nodelane_account.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'translation_display_switch.dart';
import 'translation_language_picker.dart';
import 'translation_settings.dart';
import 'translation_view_controller.dart';

Future<void> showTranslationControls(
  BuildContext context,
  TranslationViewController controller, {
  String? title,
  String? subtitle,
  bool browser = false,
}) => showNodeLaneCatalogSheet<void>(
  context,
  TranslationControlsContent(
    controller: controller,
    mobile: isMobile && !isTv,
    title: title,
    subtitle: subtitle,
    browser: browser,
  ),
);

/// Reader and browser share the same controls; recovery lives on each image.
class TranslationControlsContent extends ConsumerWidget {
  const TranslationControlsContent({
    super.key,
    required this.controller,
    this.mobile = false,
    this.title,
    this.subtitle,
    this.browser = false,
  });
  final TranslationViewController controller;
  final bool mobile, browser;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final channelLabel = ref.watch(translationServiceProvider).channelLabel;
    return NodeLaneCatalogSheet(
      title: title ?? context.l10n.translation_title,
      subtitle: subtitle,
      fitContent: true,
      heightFactor: .8,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final states = controller.targets.map(controller.state).toList();
          final complete = states
              .where((s) => s.phase == TranslationPhase.succeeded)
              .length;
          final issues = states
              .where(
                (s) =>
                    s.phase == TranslationPhase.failed ||
                    s.phase == TranslationPhase.uncertain,
              )
              .length;
          return SingleChildScrollView(
            padding: NodeLaneTokens.modalContentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NodeLaneGroupSurface(
                  child: Padding(
                    padding: const EdgeInsets.all(NodeLaneTokens.space16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          context.l10n.translation_image_display,
                          style: t.readerLabel,
                        ),
                        const SizedBox(height: NodeLaneTokens.space12),
                        TranslationDisplaySwitch(
                          translated: controller.showTranslation,
                          onChanged: (value) =>
                              controller.configure(showTranslation: value),
                        ),
                        const SizedBox(height: NodeLaneTokens.space12),
                        Text(
                          context.l10n.translation_display_hint,
                          style: t.readerSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: NodeLaneTokens.space16),
                NodeLaneGroupSurface(
                  children: [
                    if (controller.runtime == null)
                      NodeLaneRow(
                        title: context.l10n.translation_sign_in_required,
                        subtitle: context.l10n.translation_sign_in_hint,
                        icon: icons.account,
                        onTap: () => _openAccount(context),
                      )
                    else
                      NodeLaneSwitchRow(
                        title: context.l10n.translation_automatic,
                        subtitle:
                            controller.enabled && !controller.showTranslation
                            ? context.l10n.translation_original_hint
                            : context.l10n.translation_window_hint,
                        value: controller.enabled,
                        onChanged: (value) =>
                            controller.configure(enabled: value),
                      ),
                  ],
                ),
                const SizedBox(height: NodeLaneTokens.space16),
                NodeLaneGroupSurface(
                  children: [
                    const TranslationLanguageRow(),
                    NodeLaneRow(
                      title: context.l10n.translation_channel,
                      value: channelLabel,
                      icon: icons.account,
                    ),
                  ],
                ),
                const SizedBox(height: NodeLaneTokens.space16),
                if (controller.runtime != null && controller.enabled) ...[
                  Text(
                    states.isEmpty
                        ? (browser
                              ? context.l10n.translation_no_images
                              : context.l10n.translation_waiting_image)
                        : context.l10n.translation_progress(
                            complete,
                            states.length,
                            issues,
                          ),
                    style: t.readerSecondary,
                  ),
                  const SizedBox(height: NodeLaneTokens.space8),
                ],
                Text(
                  context.l10n.translation_image_actions_hint,
                  style: t.readerSecondary,
                ),
                if (controller.error != null) ...[
                  const SizedBox(height: NodeLaneTokens.space12),
                  Text(
                    controller.error!,
                    style: t.readerSecondary.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _openAccount(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => mobile
            ? const MobileNodeLaneAccountPage()
            : const TranslationSettings(),
      ),
    );
  }
}
