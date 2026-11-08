import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/services/translation/languages.dart';
import 'package:mangayomi/services/translation/translation_service.dart';

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
      appBar: AppBar(title: Text(context.l10n.translation_title)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: Text(
              service.loggedIn
                  ? service.accountName
                  : context.l10n.nodelane_sign_in,
            ),
            subtitle: Text(context.l10n.translation_system_sign_in),
            trailing: TextButton(
              onPressed: service.busy
                  ? null
                  : service.loggedIn
                  ? service.logout
                  : service.login,
              child: Text(
                service.loggedIn ? context.l10n.log_out : context.l10n.login,
              ),
            ),
          ),
          ListTile(
            title: Text(context.l10n.translation_target_language),
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
            title: Text(context.l10n.translation_clear_cache),
            subtitle: Text(context.l10n.translation_cache_hint),
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
