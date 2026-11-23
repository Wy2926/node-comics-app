import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/widgets/mobile_nodelane_account.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'translation_language_picker.dart';
import 'translation_model_picker.dart';
import 'translation_settings.dart';
import 'translation_view_controller.dart';

Future<void> showTranslationControls(
  BuildContext context,
  TranslationViewController controller, {
  String? title,
  String? subtitle,
  bool browser = false,
}) {
  final content = TranslationControlsContent(
    controller: controller,
    mobile: isMobile && !isTv,
    title: title,
    subtitle: subtitle,
    browser: browser,
  );
  return NodeLaneBubbleFlow.open<void>(
    context,
    title: title ?? context.l10n.translation_title,
    child: content,
  );
}

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
    final heading = title ?? context.l10n.translation_title;
    final body = ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final targets = controller.targets;
        return SingleChildScrollView(
          padding: NodeLaneTokens.bubbleContentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NodeLaneGroupSurface(
                outlined: true,
                child: controller.runtime == null
                    ? NodeLaneRow(
                        title: context.l10n.translation_sign_in_required,
                        icon: icons.account,
                        onTap: () => _openAccount(context),
                      )
                    : NodeLaneSwitchRow(
                        title: context.l10n.translation_automatic,
                        icon: icons.translate,
                        value: controller.enabled,
                        onChanged: (value) =>
                            controller.configure(enabled: value),
                      ),
              ),
              const SizedBox(height: NodeLaneTokens.space12),
              NodeLaneGroupSurface(
                outlined: true,
                children: [
                  const TranslationLanguageRow(),
                  const TranslationModelRow(),
                  NodeLaneRow(
                    title: context.l10n.translation_channel,
                    value: channelLabel,
                    icon: icons.account,
                  ),
                ],
              ),
              if (browser && controller.runtime != null) ...[
                const SizedBox(height: NodeLaneTokens.space12),
                Text(
                  targets.isEmpty
                      ? context.l10n.translation_no_images
                      : context.l10n.translation_progress(
                          targets.where(controller.isComplete).length,
                          targets.length,
                          targets
                              .where((t) => controller.state(t).hasIssue)
                              .length,
                        ),
                  style: t.readerSecondary,
                ),
              ],
            ],
          ),
        );
      },
    );
    return NodeLaneBubblePanel(title: heading, subtitle: subtitle, child: body);
  }

  void _openAccount(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    Navigator.of(context).pop();
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => mobile
            ? const MobileNodeLaneAccountPage()
            : const TranslationSettings(),
      ),
    );
  }
}
