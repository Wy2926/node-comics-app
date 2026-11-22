import 'dart:io';
import 'dart:ui';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/services/translation/channels/nodelane/channel.dart';
import 'package:mangayomi/services/translation/channels/nodelane/session.dart';
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

  Future<void> setUpStore() async {
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
  }

  test('first target is persisted and neither restart nor unsupported choice replaces it', () async {
    await setUpStore();
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

  test('model preference survives restart and language changes, scoped to service and account', () async {
    await setUpStore();
    Future<TranslationService> start(
      String? user, {
      String host = 'api.example',
    }) async {
      await Isar.getInstance('nodelaneTranslation')?.close();
      final service = TranslationService(
        session: _Session(Uri.https(host), user),
      );
      await service.initialize();
      return service;
    }

    const free = (id: 'free', name: 'Free'),
        premium = (id: 'plus', name: 'Plus');
    final guest = await start(null);
    expect(guest.model, isNull);
    await guest.setModel(free);
    guest.dispose();
    final first = await start('a');
    expect(first.model, free);
    await first.setModel(premium);
    await first.setLanguage('ar');
    expect((first.runtime as OfficialRuntime).options.modelId, 'plus');
    first.dispose();

    final other = await start('b');
    expect(other.language, 'ar');
    expect(other.model, free);
    other.dispose();
    final otherServer = await start('a', host: 'other.example');
    expect(otherServer.model, isNull);
    otherServer.dispose();
    final restored = await start('a');
    expect(restored.model, premium);
    await restored.setModel(null);
    restored.dispose();
    final reset = await start('a');
    expect(reset.model, isNull);
    expect((reset.runtime as OfficialRuntime).options.language, 'ar');
    reset.dispose();
  });
}

class _Session extends NodeLaneSession {
  _Session(super.base, this.userId);
  @override
  final String? userId;
}

class _Paths extends PathProviderPlatform {
  _Paths(this.root);
  final String root;
  @override
  Future<String?> getApplicationSupportPath() async => '$root/support';
  @override
  Future<String?> getTemporaryPath() async => root;
}
