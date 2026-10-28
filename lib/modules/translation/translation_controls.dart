import 'package:flutter/material.dart';
import 'package:mangayomi/services/translation/contracts.dart';

import 'translation_settings.dart';
import 'translation_view_controller.dart';

void showTranslationControls(
  BuildContext context,
  TranslationViewController controller,
) {
  showModalBottomSheet<void>(
    context: context,
    builder: (context) => SafeArea(
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.runtime == null)
                ListTile(
                  title: const Text('登录后开启翻译'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TranslationSettings(),
                      ),
                    );
                  },
                ),
              SwitchListTile(
                title: const Text('翻译当前阅读范围'),
                subtitle: const Text('按当前页和随后两页处理'),
                value: controller.enabled,
                onChanged: controller.runtime == null
                    ? null
                    : (value) => controller.configure(enabled: value),
              ),
              SwitchListTile(
                title: const Text('显示译图'),
                value: controller.showTranslation,
                onChanged: (value) =>
                    controller.configure(showTranslation: value),
              ),
              for (final target in controller.targets)
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
              ListTile(
                title: const Text('翻译设置'),
                trailing: const Icon(Icons.settings_outlined),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TranslationSettings(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
