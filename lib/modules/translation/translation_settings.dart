import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/services/translation/translation_service.dart';

import 'translation_language_picker.dart';

class TranslationSettings extends ConsumerStatefulWidget {
  const TranslationSettings({super.key});
  @override
  ConsumerState<TranslationSettings> createState() =>
      TranslationSettingsState();
}

class TranslationSettingsState extends ConsumerState<TranslationSettings> {
  late final service = ref.read(translationServiceProvider);
  @override
  void initState() {
    super.initState();
    service.initialize().catchError((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: service,
    builder: (context, _) => Scaffold(
      appBar: AppBar(title: const Text('漫画翻译')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: Text(service.loggedIn ? service.accountName : '登录 NodeLane'),
            subtitle: const Text('通过系统浏览器登录'),
            trailing: TextButton(
              onPressed: service.busy
                  ? null
                  : service.loggedIn
                  ? service.logout
                  : service.login,
              child: Text(service.loggedIn ? '退出' : '登录'),
            ),
          ),
          ListTile(
            title: const Text('目标语言'),
            trailing: DropdownButton<String>(
              value: service.language,
              items: [
                for (final language in translationLanguageNames.entries)
                  DropdownMenuItem(
                    value: language.key,
                    child: Text(language.value),
                  ),
              ],
              onChanged: service.busy
                  ? null
                  : (value) {
                      if (value != null) service.setLanguage(value);
                    },
            ),
          ),
          ListTile(
            title: const Text('清理译图缓存'),
            subtitle: const Text('保留翻译记录，需要时重新读取结果'),
            leading: const Icon(Icons.cleaning_services_outlined),
            onTap: service.busy ? null : service.clearResults,
          ),
          if (service.busy) const LinearProgressIndicator(),
          if (service.error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(service.error!),
            ),
        ],
      ),
    ),
  );
}
