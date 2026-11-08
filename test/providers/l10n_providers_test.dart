import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/l10n/languages.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;

  setUpAll(() async {
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = overrides;
    }
  });

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('nodelane-locale-');
    app.isar = await Isar.open(
      [SettingsSchema, SourceSchema],
      directory: directory.path,
      name: 'locale_${directory.path.hashCode}',
    );
    await app.isar.writeTxn(() => app.isar.settings.put(Settings()));
  });

  tearDown(() async {
    binding.platformDispatcher.clearLocalesTestValue();
    await app.isar.close(deleteFromDisk: true);
    directory.deleteSync(recursive: true);
  });

  Locale readAtStartup() {
    final container = ProviderContainer();
    try {
      return container.read(l10nLocaleStateProvider);
    } finally {
      container.dispose();
    }
  }

  test(
    'fresh settings match system languages and fall back only to English',
    () {
      for (final (preferred, expected) in <(List<Locale>, Locale)>[
        (
          [const Locale('zh', 'CN')],
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
        ),
        (
          [
            const Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hant',
              countryCode: 'TW',
            ),
          ],
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        ),
        ([const Locale('pt', 'BR')], const Locale('pt', 'BR')),
        ([const Locale('sv', 'BR')], const Locale('en')),
        ([const Locale('sv'), const Locale('de', 'DE')], const Locale('de')),
        ([], const Locale('en')),
      ]) {
        binding.platformDispatcher.localesTestValue = preferred;
        expect(readAtStartup(), expected, reason: '$preferred');
        expect(app.isar.settings.getSync(227)!.locale, isNull);
      }
    },
  );

  test('each of the 17 choices survives storage, backup and restart', () async {
    binding.platformDispatcher.localesTestValue = [const Locale('en')];
    for (final locale in nodeLaneSupportedLocales) {
      final container = ProviderContainer();
      container.read(l10nLocaleStateProvider.notifier).setLocale(locale);
      expect(container.read(l10nLocaleStateProvider), locale);
      await dbWriteQueue.run(() {});
      container.dispose();
      final stored = app.isar.settings.getSync(227)!.locale!;
      final restored = L10nLocale.fromJson(stored.toJson());
      expect(restored.languageCode, locale.languageCode);
      expect(restored.countryCode, locale.countryCode);
      expect(restored.scriptCode, locale.scriptCode);
      expect(readAtStartup(), locale);
      final fresh = ProviderContainer();
      expect(
        fresh.read(translationServiceProvider).language,
        locale.toLanguageTag(),
      );
      fresh.dispose();
    }
  });

  test('unsupported saved values are not converted or migrated', () async {
    for (final saved in [
      L10nLocale(languageCode: 'as'),
      L10nLocale(languageCode: 'hi'),
      L10nLocale(languageCode: 'th'),
      L10nLocale(languageCode: 'es', countryCode: '419'),
      L10nLocale(languageCode: 'pt'),
      L10nLocale(languageCode: 'zh', countryCode: 'TW'),
    ]) {
      final settings = app.isar.settings.getSync(227)!..locale = saved;
      await app.isar.writeTxn(() => app.isar.settings.put(settings));
      expect(readAtStartup(), const Locale('en'));
      expect(app.isar.settings.getSync(227)!.locale!.toJson(), saved.toJson());
    }
  });

  test(
    'a saved language takes priority over system language on later starts',
    () async {
      final settings = app.isar.settings.getSync(227)!
        ..locale = L10nLocale(languageCode: 'ja');
      await app.isar.writeTxn(() => app.isar.settings.put(settings));
      for (final system in [const Locale('zh', 'CN'), const Locale('sv')]) {
        binding.platformDispatcher.localesTestValue = [system];
        expect(readAtStartup(), const Locale('ja'));
        expect(app.isar.settings.getSync(227)!.locale!.languageCode, 'ja');
      }
    },
  );
}
