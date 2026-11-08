// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'dart:ui';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/services/translation/languages.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'locale matching preserves Chinese scripts and picks supported preferences',
    () {
      for (final (locales, expected) in <(List<Locale>, String)>[
        ([const Locale('zh', 'CN')], 'zh-Hans'),
        ([const Locale('zh', 'HK')], 'zh-Hant'),
        (
          [const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')],
          'zh-Hant',
        ),
        (
          [
            const Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hans',
              countryCode: 'HK',
            ),
          ],
          'zh-Hans',
        ),
        ([const Locale('pt', 'PT')], 'pt-BR'),
        ([const Locale('ar', 'SA')], 'ar'),
        ([const Locale('sv'), const Locale('ko', 'KR')], 'ko'),
        ([const Locale('ja'), const Locale('en', 'US')], 'ja'),
        ([const Locale('sv')], 'en'),
      ]) {
        expect(
          translationLanguageForLocales(locales),
          expected,
          reason: '$locales',
        );
      }
    },
  );

  test('first target is persisted and neither restart nor unsupported choice replaces it', () async {
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = overrides;
    }
    final root = await Directory.systemTemp.createTemp('nodelane-language-');
    final paths = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _Paths(root.path);
    FlutterSecureStorage.setMockInitialValues({});
    addTearDown(() async {
      await Isar.getInstance('nodelaneTranslation')?.close();
      PathProviderPlatform.instance = paths;
      await root.delete(recursive: true);
    });

    Future<TranslationService> start(Locale locale) async {
      final service = TranslationService(preferredLocales: [locale]);
      await service.initialize();
      expect(service.runtime, isNull);
      return service;
    }

    final first = await start(const Locale('zh', 'HK'));
    expect(first.language, 'zh-Hant');
    first.dispose();
    await Isar.getInstance('nodelaneTranslation')!.close();

    final restored = await start(const Locale('ja'));
    expect(restored.language, 'zh-Hant');
    await restored.setLanguage('ar');
    expect(restored.language, 'ar');
    await restored.setLanguage('unsupported');
    expect(restored.error, isNotNull);
    expect(restored.language, 'ar');
    restored.dispose();
    await Isar.getInstance('nodelaneTranslation')!.close();

    final chosen = await start(const Locale('en'));
    expect(chosen.language, 'ar');
    chosen.dispose();
  });
}

class _Paths extends PathProviderPlatform {
  _Paths(this.root);
  final String root;
  @override
  Future<String?> getApplicationSupportPath() async => '$root/support';
  @override
  Future<String?> getTemporaryPath() async => root;
}
