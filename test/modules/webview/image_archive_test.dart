import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/webview/image_archive.dart';
import 'package:mangayomi/services/translation/contracts.dart';

import 'fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final storage = WebImageTestDirectory();
  late Directory directory;
  setUp(() async {
    await storage.setUp();
    directory = storage.directory;
  });
  tearDown(storage.tearDown);

  test(
    'MHTML streams exact image bytes, not HTML or unrelated resources',
    () async {
      final bytes = Uint8List.fromList(List.generate(400000, (i) => i % 256));
      final archive = File('${directory.path}/page.mht');
      final image = File('${directory.path}/image');
      final missing = File('${directory.path}/missing');
      await archive.writeAsString(
        archiveFixture({
          'https://cdn.test/image?a=1&b=2': bytes,
          'https://cdn.test/other': [9, 9, 9],
        }),
      );
      await extractWebImages(
        archive,
        {
          'https://cdn.test/image?a=1&b=2': image,
          'https://cdn.test/not-loaded': missing,
        },
        false,
        TranslationCancellation(),
      );
      expect(await image.readAsBytes(), bytes);
      expect(await missing.exists(), isFalse);
      expect(await directory.list().length, 2);
    },
  );

  test(
    'truncated archive does not publish partial bytes and can retry',
    () async {
      var count = 0;
      final cache = WebImageArchive(
        apple: false,
        save: (path) async {
          var content = archiveFixture({
            'https://cdn.test/a': List.filled(90000, 7),
          });
          if (++count == 1) content = content.substring(0, content.length - 20);
          await File(path).writeAsString(content);
          return path;
        },
      );
      cache.retain({'a': 'https://cdn.test/a'});
      expect(await cache.acquire('a', TranslationCancellation()), isNull);
      final lease = (await cache.acquire('a', TranslationCancellation()))!;
      expect(await lease.file.length(), 90000);
      cache.clear();
      lease.release();
      await waitDeleted(lease.file.parent);
      expect(await directory.list().length, 0);
    },
  );

  test(
    'Apple extraction passes paths and rejects late cancelled results',
    () async {
      const channel = MethodChannel('nodelane/web_image_archive');
      final archive = File('${directory.path}/page.webarchive');
      final image = File('${directory.path}/image');
      final cancellation = TranslationCancellation();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            expect(call.method, 'extract');
            expect(call.arguments, {
              'archive': archive.path,
              'destinations': {'https://cdn.test/a': image.path},
            });
            await image.writeAsBytes([1, 2, 3]);
            cancellation.cancel();
            return null;
          });
      try {
        await expectLater(
          extractWebImages(
            archive,
            {'https://cdn.test/a': image},
            true,
            cancellation,
          ),
          throwsA(isA<TranslationCancelled>()),
        );
      } finally {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null);
      }
    },
  );

  test('shared capture isolates consumer cancellation; leases survive leaving the window', () async {
    var captures = 0;
    final ready = Completer<void>();
    final cache = WebImageArchive(
      apple: false,
      save: (path) async {
        captures++;
        await ready.future;
        await File(path).writeAsString(
          archiveFixture({
            'https://cdn.test/a': [1, 2, 3],
          }),
        );
        return path;
      },
    );
    cache.retain({'a:1': 'https://cdn.test/a', 'b:1': 'https://cdn.test/a'});
    final cancel = TranslationCancellation();
    final cancelled = cache.acquire('a:1', cancel);
    final failure = expectLater(
      cancelled,
      throwsA(isA<TranslationCancelled>()),
    );
    final first = cache.acquire('a:1', TranslationCancellation());
    final second = cache.acquire('b:1', TranslationCancellation());
    cancel.cancel();
    ready.complete();
    await failure;
    final a = (await first)!;
    final b = (await second)!;
    expect(captures, 1);
    expect(a.file.path, b.file.path);
    final again = (await cache.acquire('a:1', TranslationCancellation()))!;
    expect(captures, 1);
    expect(
      await a.file.parent.list().length,
      1,
      reason: 'Full archive must be removed',
    );
    cache.retain({});
    a.release();
    b.release();
    expect(await again.file.readAsBytes(), [1, 2, 3]);
    again.release();
    await waitDeleted(a.file.parent);
    cache.clear();
  });

  test(
    'navigation discards late capture, and a new document can capture again',
    () async {
      final saved = Completer<void>();
      final ready = Completer<void>();
      var count = 0;
      final cache = WebImageArchive(
        apple: false,
        save: (path) async {
          count++;
          if (count == 1) {
            saved.complete();
            await ready.future;
          }
          await File(path).writeAsString(
            archiveFixture({
              'https://cdn.test/a': [count],
            }),
          );
          return path;
        },
      );
      cache.retain({'a:1': 'https://cdn.test/a'});
      final old = cache.acquire('a:1', TranslationCancellation());
      final oldFailure = expectLater(old, throwsA(isA<TranslationCancelled>()));
      await saved.future;
      cache.clear();
      cache.retain({'a:2': 'https://cdn.test/a'});
      final current = cache.acquire('a:2', TranslationCancellation());
      ready.complete();
      await oldFailure;
      final lease = (await current)!;
      expect(await lease.file.readAsBytes(), [2]);
      expect(count, 2);
      cache.clear();
      lease.release();
      await waitDeleted(lease.file.parent);
      expect(await directory.list().length, 0);
    },
  );

  test('missing or unavailable archives are retryable cache misses', () async {
    var count = 0;
    final cache = WebImageArchive(
      apple: false,
      save: (path) async {
        count++;
        if (count == 1) throw PlatformException(code: 'not_available');
        await File(path).writeAsString(
          archiveFixture(
            count == 2
                ? {}
                : {
                    'https://cdn.test/a': [7],
                  },
          ),
        );
        return path;
      },
    );
    cache.retain({'a': 'https://cdn.test/a'});
    expect(await cache.acquire('a', TranslationCancellation()), isNull);
    expect(await cache.acquire('a', TranslationCancellation()), isNull);
    final lease = (await cache.acquire('a', TranslationCancellation()))!;
    expect(await lease.file.readAsBytes(), [7]);
    cache.clear();
    lease.release();
    await waitDeleted(lease.file.parent);
    expect(await directory.list().length, 0);
  });
}
