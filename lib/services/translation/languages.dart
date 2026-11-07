import 'dart:ui';

/// NodeLane's product target languages, shared by every language picker.
const translationLanguageNames = {
  'zh-Hans': '简体中文',
  'zh-Hant': '繁體中文',
  'en': 'English',
  'ja': '日本語',
  'ko': '한국어',
  'fr': 'Français',
  'es': 'Español',
  'pt-BR': 'Português (Brasil)',
  'de': 'Deutsch',
  'it': 'Italiano',
  'ru': 'Русский',
  'pl': 'Polski',
  'uk': 'Українська',
  'tr': 'Türkçe',
  'vi': 'Tiếng Việt',
  'id': 'Bahasa Indonesia',
  'ar': 'العربية',
};

String translationLanguageForLocales(Iterable<Locale> locales) {
  for (final locale in locales) {
    final language = locale.languageCode;
    if (language == 'zh') {
      final traditional =
          locale.scriptCode == 'Hant' ||
          (locale.scriptCode != 'Hans' &&
              const {'TW', 'HK', 'MO'}.contains(locale.countryCode));
      return traditional ? 'zh-Hant' : 'zh-Hans';
    }
    if (language == 'pt') return 'pt-BR';
    if (translationLanguageNames.containsKey(language)) return language;
  }
  return 'en';
}
