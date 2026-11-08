import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/l10n/languages.dart';
import 'package:mangayomi/services/translation/languages.dart';

void main() {
  const expectedTags = [
    'zh-Hans',
    'zh-Hant',
    'en',
    'ja',
    'ko',
    'fr',
    'es',
    'pt-BR',
    'de',
    'it',
    'ru',
    'pl',
    'uk',
    'tr',
    'vi',
    'id',
    'ar',
  ];
  const expectedNames = [
    '简体中文',
    '繁體中文',
    'English',
    '日本語',
    '한국어',
    'Français',
    'Español',
    'Português (Brasil)',
    'Deutsch',
    'Italiano',
    'Русский',
    'Polski',
    'Українська',
    'Türkçe',
    'Tiếng Việt',
    'Bahasa Indonesia',
    'العربية',
  ];

  test(
    'interface and translation choices match the comic website in order',
    () {
      expect(
        nodeLaneSupportedLocales.map((l) => l.toLanguageTag()),
        expectedTags,
      );
      expect(nodeLaneSupportedLocales.map(nodeLaneLanguageName), expectedNames);
      expect(translationLanguageNames.keys, expectedTags);
      expect(translationLanguageNames.values, expectedNames);
    },
  );

  test(
    'each language has complete resources without obsolete locale files',
    () {
      final template = jsonDecode(
        File('lib/l10n/app_en.arb').readAsStringSync(),
      ) as Map<String, dynamic>;
      final keys = template.keys.where((k) => !k.startsWith('@')).toSet();
      final files = Directory('lib/l10n')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.arb'))
          .toList();
      expect(files, hasLength(17));
      expect(AppLocalizations.supportedLocales, hasLength(17));
      for (final file in files) {
        final data =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        expect(
          data.keys.where((k) => !k.startsWith('@')).toSet(),
          keys,
          reason: file.path,
        );
        for (final key in keys) {
          expect(data[key], isNotEmpty, reason: '${file.path}: $key');
          expect(
            data[key],
            isNot(contains('__PH')),
            reason: '${file.path}: $key',
          );
        }
      }
    },
  );

  test('all languages retain destructive-action counts and reader labels', () {
    for (final locale in nodeLaneSupportedLocales) {
      final l10n = lookupAppLocalizations(locale);
      final deletion = l10n.delete_source_confirm_message(
        'MANGA',
        'CHAPTER',
        'HISTORY',
        'UPDATE',
      );
      for (final marker in ['MANGA', 'CHAPTER', 'HISTORY', 'UPDATE']) {
        expect(deletion, contains(marker), reason: locale.toLanguageTag());
      }
      final merge = l10n.merge_manga_preview_message(
        'TOTAL',
        'DUPLICATE',
        'KEPT',
        'TRACKS',
      );
      for (final marker in ['TOTAL', 'DUPLICATE', 'KEPT', 'TRACKS']) {
        expect(merge, contains(marker), reason: locale.toLanguageTag());
      }
      expect(l10n.average_chapters_per_title('MEDIA'), contains('MEDIA'));
      expect(l10n.page('PAGE'), contains('PAGE'));
      expect(l10n.next('NEXT'), contains('NEXT'));
      expect(l10n.previous('PREVIOUS'), contains('PREVIOUS'));
    }
  });

  test('Slavic and Arabic counts use their own plural categories', () {
    final pl = lookupAppLocalizations(const Locale('pl'));
    final uk = lookupAppLocalizations(const Locale('uk'));
    final ru = lookupAppLocalizations(const Locale('ru'));
    final ar = lookupAppLocalizations(const Locale('ar'));
    expect(pl.source_selected_count(2), 'Wybrano 2 elementy');
    expect(pl.source_selected_count(5), 'Wybrano 5 elementów');
    expect(pl.source_selected_count(21), 'Wybrano 21 elementów');
    expect(uk.source_selected_count(21), 'Вибрано 21 елемент');
    expect(uk.source_selected_count(5), 'Вибрано 5 елементів');
    expect(ru.source_selected_count(21), 'Выбран 21 элемент');
    expect(ar.source_selected_count(2), 'تم تحديد عنصرين');
  });

  testWidgets('all choices load, format dates and set the correct direction', (
    tester,
  ) async {
    // Distinct new translations ensure these choices cannot silently load English.
    const libraryLabels = {
      'zh-Hans': '书架',
      'zh-Hant': '書架',
      'pl': 'Biblioteka',
      'uk': 'Бібліотека',
      'vi': 'Thư viện',
    };
    for (final locale in nodeLaneSupportedLocales) {
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(locale),
          locale: locale,
          supportedLocales: nodeLaneSupportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              expect(Localizations.localeOf(context), locale);
              expect(
                Directionality.of(context),
                locale.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
              );
              final label = libraryLabels[locale.toLanguageTag()];
              if (label != null) expect(l10n.library, label);
              expect(
                DateFormat.yMMMMd(locale.toLanguageTag())
                    .format(DateTime(2026, 11, 8)),
                isNotEmpty,
              );
              for (final count in [0, 1, 2, 5, 21]) {
                expect(l10n.source_selected_count(count), isNot(contains('{')));
                expect(
                  l10n.translation_progress(1, 5, count),
                  isNot(contains('{')),
                );
              }
              return Scaffold(body: Text(l10n.library));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: locale.toLanguageTag());
    }
  });
}
