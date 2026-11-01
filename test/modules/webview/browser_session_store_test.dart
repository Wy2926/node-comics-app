import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mangayomi/modules/webview/browser_session_store.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));
  Map<String, dynamic> entry(String id) => {
    'id': id,
    'url': 'https://example.org/$id',
    'title': id,
  };
  test(
    'closing the last tab persists an empty session and releases its preview',
    () async {
      final store = BrowserSessionStore();
      await store.load();
      await store.save([entry('a')]);
      store.setPreview('a', Uint8List(32));
      await store.close('a');
      expect(store.preview('a'), isNull);
      final restored = BrowserSessionStore();
      await restored.load();
      expect(restored.entries, isEmpty);
      store.dispose();
      restored.dispose();
    },
  );
  test(
    'queued saves keep the final close and preserve position/display metadata',
    () async {
      final store = BrowserSessionStore();
      await store.load();
      final first = store.save([
        entry('a'),
        {...entry('b'), 'y': 820, 'translated': false},
      ]);
      final last = store.close('a');
      await Future.wait([first, last]);
      final restored = BrowserSessionStore();
      await restored.load();
      expect(restored.entries.single['id'], 'b');
      expect(restored.entries.single['y'], 820);
      expect(restored.entries.single['translated'], false);
      store.dispose();
      restored.dispose();
    },
  );
  test('restoration rejects unsafe URLs and previews stay bounded', () async {
    FlutterSecureStorage.setMockInitialValues({
      BrowserSessionStore.storageKey: jsonEncode([
        entry('a'),
        entry('a'),
        {'id': 'unsafe', 'url': 'file:///private/data'},
        {'id': '', 'url': 'https://example.org'},
      ]),
    });
    final store = BrowserSessionStore();
    await store.load();
    expect(store.entries.length, 1);
    for (var i = 0; i < 13; i++) {
      store.setPreview('$i', Uint8List(20));
    }
    expect(store.preview('0'), isNull);
    store.setPreview('large', Uint8List(384 * 1024 + 1));
    expect(store.preview('large'), isNull);
    store.dispose();
  });
  test(
    'address input supports domains but excludes credentials and other schemes',
    () {
      expect(
        normalizeBrowserAddress(' example.org/read '),
        'https://example.org/read',
      );
      expect(
        normalizeBrowserAddress('https://example.org/read'),
        'https://example.org/read',
      );
      expect(normalizeBrowserAddress('javascript:alert(1)'), isNull);
      expect(
        normalizeBrowserAddress('https://user:secret@example.org'),
        isNull,
      );
      expect(normalizeBrowserAddress('file:///private'), isNull);
    },
  );
}
