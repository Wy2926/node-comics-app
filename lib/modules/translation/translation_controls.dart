import 'package:flutter/material.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'translation_settings.dart';
import 'translation_view_controller.dart';

void showTranslationControls(
  BuildContext context,
  TranslationViewController controller,
) {
  final mobile = isMobile && !isTv;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: mobile,
    useSafeArea: mobile,
    showDragHandle: mobile,
    backgroundColor: mobile ? NodeLaneTokens.of(context).surface : null,
    builder: (context) {
      final content = TranslationControlsContent(
        controller: controller,
        mobile: mobile,
      );
      return mobile
          ? NodeLaneSurface(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * .8,
                ),
                child: content,
              ),
            )
          : content;
    },
  );
}

/// Both reader and browser use the same controller and recovery actions.
/// The mobile variant only changes their presentation.
class TranslationControlsContent extends StatelessWidget {
  const TranslationControlsContent({
    super.key,
    required this.controller,
    this.mobile = false,
  });
  final TranslationViewController controller;
  final bool mobile;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: ListenableBuilder(
      listenable: controller,
      builder: (context, _) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (mobile)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 8, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '漫画翻译',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .closeButtonTooltip,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
            if (controller.runtime == null)
              ListTile(
                title: const Text('登录后开启翻译'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _settings(context),
              ),
            SwitchListTile.adaptive(
              title: const Text('翻译当前阅读范围'),
              subtitle: const Text('按当前页和随后两页处理'),
              value: controller.enabled,
              onChanged: controller.runtime == null
                  ? null
                  : (value) => controller.configure(enabled: value),
            ),
            if (mobile)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<bool>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: false, label: Text('原图')),
                      ButtonSegment(value: true, label: Text('译图')),
                    ],
                    selected: {controller.showTranslation},
                    onSelectionChanged: (values) =>
                        controller.configure(showTranslation: values.single),
                  ),
                ),
              )
            else
              SwitchListTile(
                title: const Text('显示译图'),
                value: controller.showTranslation,
                onChanged: (value) =>
                    controller.configure(showTranslation: value),
              ),
            for (final target in controller.targets)
              if (!mobile ||
                  controller.state(target).message.isNotEmpty ||
                  controller.state(target).noText ||
                  controller.state(target).actions.isNotEmpty)
                ListTile(
                  title: Text(
                    '第 ${controller.targets.indexOf(target) + 1} 张 · ${controller.state(target).noText ? '无可译文字' : controller.state(target).message}',
                  ),
                  trailing: controller.state(target).actions.isEmpty
                      ? null
                      : PopupMenuButton<TranslationAction>(
                          onSelected: (action) =>
                              controller.perform(target, action),
                          itemBuilder: (_) => controller
                              .state(target)
                              .actions
                              .map(
                                (action) => PopupMenuItem(
                                  value: action,
                                  child: Text(switch (action) {
                                    TranslationAction.verify => '核实状态',
                                    TranslationAction.readResult => '重新读取译图',
                                    TranslationAction.retry => '重试本页翻译',
                                    TranslationAction.regenerate => '重新翻译本页',
                                  }),
                                ),
                              )
                              .toList(),
                        ),
                ),
            if (controller.error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(controller.error!),
              ),
            if (!mobile || controller.runtime != null)
              ListTile(
                title: const Text('翻译设置'),
                trailing: const Icon(Icons.settings_outlined),
                onTap: () => _settings(context),
              ),
          ],
        ),
      ),
    ),
  );

  void _settings(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(
      MaterialPageRoute(builder: (_) => const TranslationSettings()),
    );
  }
}
