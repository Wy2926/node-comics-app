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
  String title = '漫画翻译',
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
    this.title = '漫画翻译',
    this.subtitle,
    this.browser = false,
  });
  final TranslationViewController controller;
  final bool mobile, browser;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final channelLabel = ref.watch(translationServiceProvider).channelLabel;
    return NodeLaneCatalogSheet(
      title: title,
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
                        Text('图片显示', style: t.readerLabel),
                        const SizedBox(height: NodeLaneTokens.space12),
                        TranslationDisplaySwitch(
                          translated: controller.showTranslation,
                          onChanged: (value) =>
                              controller.configure(showTranslation: value),
                        ),
                        const SizedBox(height: NodeLaneTokens.space12),
                        Text('译图优先显示已有结果，暂无译图时保留原图。', style: t.readerSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: NodeLaneTokens.space16),
                NodeLaneGroupSurface(
                  children: [
                    if (controller.runtime == null)
                      NodeLaneRow(
                        title: '登录后开启翻译',
                        subtitle: '登录后切换译图，即可自动翻译',
                        icon: icons.account,
                        onTap: () => _openAccount(context),
                      )
                    else
                      NodeLaneSwitchRow(
                        title: '自动翻译',
                        subtitle:
                            controller.enabled && !controller.showTranslation
                            ? '当前显示原图，切到译图后自动翻译'
                            : '仅在显示译图时处理当前及后续图片',
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
                      title: '翻译渠道',
                      value: channelLabel,
                      icon: icons.account,
                    ),
                  ],
                ),
                const SizedBox(height: NodeLaneTokens.space16),
                if (controller.runtime != null && controller.enabled) ...[
                  Text(
                    states.isEmpty
                        ? (browser ? '当前页面暂未发现可翻译图片' : '等待当前图片')
                        : '已完成 $complete / ${states.length} 张${issues > 0 ? ' · $issues 张需要处理' : ''}',
                    style: t.readerSecondary,
                  ),
                  const SizedBox(height: NodeLaneTokens.space8),
                ],
                Text('长按图片打开更多操作，可重新翻译单张图片。', style: t.readerSecondary),
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
