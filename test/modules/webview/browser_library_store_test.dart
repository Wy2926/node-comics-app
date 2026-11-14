import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
// The plugin's platform interface lets the test exercise real vault failures.
// ignore: depend_on_referenced_packages
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/webview/browser_library_store.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';
import 'package:mangayomi/services/nodelane_private_storage.dart';
import 'package:image/image.dart' as image;

class _FailingStorage extends TestFlutterSecureStoragePlatform {
  _FailingStorage() : super({});
  bool fail = true;
  @override
  Future<void> write({
    required String key,
    required String value,
    required Map<String, String> options,
  }) async {
    if (fail) throw PlatformException(code: 'unavailable');
    await super.write(key: key, value: value, options: options);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test(
    'six packaged logos and website ICO files decode without a network service',
    () async {
      expect(BrowserSearchEngine.values.length, greaterThanOrEqualTo(6));
      for (final engine in BrowserSearchEngine.values) {
        final data = await rootBundle.load(engine.logoAsset);
        final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
        final frame = await codec.getNextFrame();
        expect(frame.image.width, greaterThan(0));
        frame.image.dispose();
        codec.dispose();
      }
      final ico = image.encodeIco(image.Image(width: 32, height: 32));
      final codec = await ui.instantiateImageCodec(ico);
      final frame = await codec.getNextFrame();
      expect(frame.image.width, 32);
      frame.image.dispose();
      codec.dispose();
    },
  );

  test(
    'favicon metadata persists and old or unsafe values use the site origin',
    () async {
      final store = BrowserLibraryStore();
      await store.visit(
        'https://example.org/read',
        'Read',
        iconUrl: 'https://cdn.example.org/icon.png',
      );
      await store.setBookmarked(
        'https://example.org/read',
        'Read',
        true,
        iconUrl: store.history.single.iconUrl,
      );
      final restored = BrowserLibraryStore();
      await restored.load();
      expect(
        restored.history.single.faviconUrl,
        'https://cdn.example.org/icon.png',
      );
      expect(
        restored.bookmarks.single.iconUrl,
        restored.history.single.iconUrl,
      );
      for (final icon in [
        null,
        'file:///private/icon',
        'https://user:secret@example.org/icon',
      ]) {
        final entry = BrowserPageEntry.fromJson({
          'url': 'https://example.org:8443/read?q=chapter',
          'title': 'Old',
          'time': '2026-11-14',
          'iconUrl': icon,
        })!;
        expect(entry.faviconUrl, 'https://example.org:8443/favicon.ico');
        expect(entry.toJson().containsKey('iconUrl'), isFalse);
      }
      store.dispose();
      restored.dispose();
    },
  );

  test('omnibox distinguishes addresses, queries and unsafe inputs', () {
    for (final input in [
      ' example.org/read ',
      'localhost:8080/a',
      '[::1]:8080/a',
    ]) {
      expect(resolveBrowserInput(input), 'https://${input.trim()}');
    }
    expect(
      resolveBrowserInput('https://example.org/read'),
      'https://example.org/read',
    );
    expect(
      resolveBrowserInput('http://127.0.0.1:8080/a'),
      'http://127.0.0.1:8080/a',
    );
    for (final engine in BrowserSearchEngine.values) {
      final uri = Uri.parse(
        resolveBrowserInput(' 漫画 & a+b #1 ', engine: engine)!,
      );
      expect(uri.host, engine.host);
      expect(uri.queryParameters, {engine.parameter: '漫画 & a+b #1'});
    }
    expect(Uri.parse(resolveBrowserInput('猫')!).host, 'www.google.com');
    expect(
      Uri.parse(resolveBrowserInput('site:example.org cats')!)
          .queryParameters['q'],
      'site:example.org cats',
    );
    for (final input in [
      '',
      ' ',
      'javascript:alert(1)',
      'data:text/html,test',
      'file:///private',
      'ftp://example.org',
      'https://user:secret@example.org',
      'user:secret@example.org',
      'https://exa mple.org',
      'https://example.org/\u0000',
    ]) {
      expect(resolveBrowserInput(input), isNull, reason: input);
    }
  });

  test('history survives tabs, deduplicates per day, and restores preferences and bookmarks', () async {
    final store = BrowserLibraryStore();
    final day = DateTime(2026, 11, 14, 10);
    await store.visit('https://example.org/a', 'A', time: day);
    await store.visit('https://example.org/b', 'B', time: day);
    await store.visit(
      'https://example.org/a',
      'A revised',
      time: day.add(const Duration(hours: 1)),
    );
    await store.visit(
      'https://example.org/a',
      'Tomorrow',
      time: day.add(const Duration(days: 1)),
    );
    await store.setBookmarked('https://example.org/b', 'B', true);
    await store.setEngine(BrowserSearchEngine.bing);
    final restored = BrowserLibraryStore();
    await restored.load();
    expect(restored.history.map((e) => e.title), [
      'Tomorrow',
      'A revised',
      'B',
    ]);
    expect(restored.engine, BrowserSearchEngine.bing);
    expect(restored.isBookmarked('https://example.org/b'), isTrue);
    await restored.removeHistory(restored.history[1]);
    expect(restored.history.map((e) => e.title), ['Tomorrow', 'B']);
    await restored.clearHistory();
    expect(restored.bookmarks.single.title, 'B');
    expect(restored.engine, BrowserSearchEngine.bing);
    store.dispose();
    restored.dispose();
  });

  test(
    'serialized mutations cannot resurrect cleared history or lose bookmarks',
    () async {
      final store = BrowserLibraryStore();
      await Future.wait([
        store.visit('https://example.org/a', 'A'),
        store.clearHistory(),
        store.setBookmarked('https://example.org/b', 'B', true),
        store.setEngine(BrowserSearchEngine.bing),
        store.setEngine(BrowserSearchEngine.google),
      ]);
      final restored = BrowserLibraryStore();
      await restored.load();
      expect(restored.history, isEmpty);
      expect(restored.bookmarks.single.url, 'https://example.org/b');
      expect(restored.engine, BrowserSearchEngine.google);
      store.dispose();
      restored.dispose();
    },
  );

  test('invalid entries are filtered and history remains bounded', () async {
    FlutterSecureStorage.setMockInitialValues({
      BrowserLibraryStore.storageKey: jsonEncode({
        'engine': 'unknown',
        'history': [
          {'url': 'file:///private', 'time': '2026-11-14'},
          {'url': 'https://example.org', 'time': 'invalid'},
          for (var i = 0; i < BrowserLibraryStore.maxHistory + 1; i++)
            {
              'url': 'https://example.org/$i',
              'time': '2026-11-14T00:00:00',
              'title': '$i',
            },
        ],
        'bookmarks': [],
      }),
    });
    final store = BrowserLibraryStore();
    await store.load();
    expect(store.history.length, BrowserLibraryStore.maxHistory);
    expect(store.engine, BrowserSearchEngine.google);
    await store.visit('javascript:alert(1)', 'bad');
    expect(store.history.first.title, '0');
    await store.visit('https://example.org/new', 'new');
    expect(store.history.length, BrowserLibraryStore.maxHistory);
    expect(store.history.last.title, '${BrowserLibraryStore.maxHistory - 2}');
    store.dispose();
  });

  test(
    'failed writes preserve published data and allow an explicit retry',
    () async {
      final store = BrowserLibraryStore();
      await store.visit('https://example.org/a', 'A');
      final storage = _FailingStorage();
      FlutterSecureStoragePlatform.instance = storage;
      addTearDown(() => FlutterSecureStorage.setMockInitialValues({}));
      await expectLater(
        store.clearHistory(),
        throwsA(isA<PlatformException>()),
      );
      expect(store.history.single.title, 'A');
      storage.fail = false;
      await store.clearHistory();
      expect(store.history, isEmpty);
      expect(
        jsonDecode(
          (await nodeLanePrivateVault.read(
            key: BrowserLibraryStore.storageKey,
          ))!,
        )['history'],
        isEmpty,
      );
      store.dispose();
    },
  );

  test('unreadable saved data is never overwritten by a mutation', () async {
    FlutterSecureStorage.setMockInitialValues({
      BrowserLibraryStore.storageKey: '{broken',
    });
    final store = BrowserLibraryStore();
    await expectLater(
      store.visit('https://example.org', 'A'),
      throwsFormatException,
    );
    expect(
      await nodeLanePrivateVault.read(key: BrowserLibraryStore.storageKey),
      '{broken',
    );
    FlutterSecureStorage.setMockInitialValues({});
    await store.visit('https://example.org', 'A');
    expect(store.history.single.title, 'A');
    store.dispose();
  });
}
