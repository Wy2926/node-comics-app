import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
part 'l10n_providers.g.dart';

@riverpod
class L10nLocaleState extends _$L10nLocaleState {
  @override
  Locale build() {
    final saved = settingsRepository.current.locale;
    if (saved?.languageCode case final language?) {
      return Locale(language, saved?.countryCode);
    }
    final supported = AppLocalizations.supportedLocales;
    // Match system preferences, then English. Never fall back to the first
    // alphabetically generated locale or an unrelated country's language.
    return basicLocaleListResolution([
      ...WidgetsBinding.instance.platformDispatcher.locales.where(
        (locale) => supported.any((s) => s.languageCode == locale.languageCode),
      ),
      const Locale('en'),
    ], supported);
  }

  void setLocale(Locale locale) async {
    settingsRepository.update(
      (s) => s.locale = L10nLocale(
        languageCode: locale.languageCode,
        countryCode: locale.countryCode,
      ),
    );
    state = locale;
  }
}

AppLocalizations? l10nLocalizations(BuildContext context) =>
    AppLocalizations.of(context);
Locale currentLocale(BuildContext context) {
  return Localizations.localeOf(context);
}

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
