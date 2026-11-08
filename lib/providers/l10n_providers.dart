import 'package:flutter/material.dart';
import 'package:mangayomi/l10n/languages.dart';
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
      final locale = Locale.fromSubtags(
        languageCode: language,
        countryCode: saved?.countryCode,
        scriptCode: saved?.scriptCode,
      );
      return nodeLaneSupportedLocales.contains(locale)
          ? locale
          : const Locale('en');
    }
    return nodeLaneLocaleForLocales(
      WidgetsBinding.instance.platformDispatcher.locales,
    );
  }

  void setLocale(Locale locale) {
    if (!nodeLaneSupportedLocales.contains(locale)) {
      throw ArgumentError.value(locale, 'locale', 'Unsupported app language');
    }
    settingsRepository.update(
      (s) => s.locale = L10nLocale(
        languageCode: locale.languageCode,
        countryCode: locale.countryCode,
        scriptCode: locale.scriptCode,
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
