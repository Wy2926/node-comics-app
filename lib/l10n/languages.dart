import 'dart:ui';

/// Language names and order from https://comics.nodelane.net/.
/// Shared by interface and translation pickers; their saved choices are separate.
const nodeLaneLanguageNames = {
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

Locale _localeForTag(String tag) => switch (tag) {
  'zh-Hans' => const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  'zh-Hant' => const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  'pt-BR' => const Locale('pt', 'BR'),
  _ => Locale(tag),
};

final nodeLaneSupportedLocales = List<Locale>.unmodifiable(
  nodeLaneLanguageNames.keys.map(_localeForTag),
);

String nodeLaneLanguageForLocales(Iterable<Locale> locales) {
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
    if (nodeLaneLanguageNames.containsKey(language)) return language;
  }
  return 'en';
}

Locale nodeLaneLocaleForLocales(Iterable<Locale> locales) =>
    _localeForTag(nodeLaneLanguageForLocales(locales));

String nodeLaneLanguageName(Locale locale) =>
    nodeLaneLanguageNames[locale.toLanguageTag()]!;
