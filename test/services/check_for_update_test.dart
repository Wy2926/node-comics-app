import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/services/app_update_feed.dart';
import 'package:mangayomi/services/app_update_manifest.dart';
import 'package:mangayomi/utils/nodelane_brand.dart';

void main() {
  final fixture = File('test/fixtures/app_update_manifest.json')
      .readAsStringSync();
  final uri = Uri.parse(NodeLaneBrand.updateManifestUrl);

  test('generated manifest selects the highest compatible version and ABI', () {
    final updates = parseAppUpdateManifest(fixture);
    for (final (platform, tv, abis, version, arch) in [
      ('android', false, ['arm64-v8a', 'armeabi-v7a'], '0.2.0', 'arm64-v8a'),
      ('android', false, ['armeabi-v7a'], '0.2.0', 'armeabi-v7a'),
      ('android', false, ['x86_64', 'x86'], '0.3.0', 'x86_64'),
      ('android', false, ['x86'], '0.1.0', 'universal'),
      ('android', true, ['arm64-v8a'], '0.3.0', 'arm64-v8a'),
      ('android', true, ['x86_64'], null, null),
      ('ios', false, <String>[], '0.2.0', 'any'),
      ('macos', false, <String>[], '0.3.0', 'any'),
      ('windows', false, <String>[], '0.1.0', 'any'),
      ('linux', false, <String>[], '0.1.0', 'any'),
    ]) {
      final selected = selectAppUpdate(
        updates,
        platform: platform,
        androidTv: tv,
        androidAbis: abis,
        currentVersion: '0.0.0',
        currentBuild: 0,
      );
      expect(selected?.version, version, reason: '$platform / $abis / TV=$tv');
      expect(selected?.arch, arch);
    }
    for (final (version, build) in [('0.2.0', 1), ('0.1.0', 2)]) {
      expect(
        selectAppUpdate(
          updates,
          platform: 'android',
          androidAbis: ['arm64-v8a'],
          currentVersion: version,
          currentBuild: build,
        ),
        isNull,
      );
    }
  });

  test('invalid manifests fail instead of becoming a no-update result', () {
    expect(parseAppUpdateManifest('{"schema":1,"updates":[]}'), isEmpty);
    for (final body in [
      'not json',
      '{}',
      '{"schema":2,"updates":[]}',
      '{"schema":1,"updates":[{}]}',
    ]) {
      expect(() => parseAppUpdateManifest(body), throwsFormatException);
    }
    for (final (field, value) in [
      ('version', '0.2.0-beta'),
      ('build', 0),
      ('sha256', 'not-a-digest'),
      ('platform', 'unknown'),
      ('arch', 'unknown'),
      ('notes', null),
      ('url', 'https://other.invalid/app.apk'),
      (
        'page_url',
        'http://github.com/Wy2926/node-comics-app/releases/tag/v0.2.0',
      ),
    ]) {
      final root = jsonDecode(fixture) as Map<String, dynamic>;
      (root['updates'] as List).first[field] = value;
      expect(
        () => parseAppUpdateManifest(jsonEncode(root)),
        throwsFormatException,
        reason: field,
      );
    }
  });

  late Directory directory;
  late File cache;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('nodelane-update-test-');
    cache = File('${directory.path}/cache.json');
  });
  tearDown(() => directory.delete(recursive: true));

  test('automatic cache persists, manual checks use ETag, and URL changes isolate state', () async {
    var now = DateTime.utc(2026, 11, 8);
    var requests = 0;
    final client = MockClient((request) async {
      requests++;
      if (requests == 1 || request.url.host == 'another.example') {
        expect(request.headers['If-None-Match'], isNull);
        return http.Response(
          fixture,
          200,
          headers: {
            'etag': 'v1',
            'content-type': 'application/json; charset=utf-8',
          },
        );
      }
      expect(request.headers['If-None-Match'], 'v1');
      return http.Response('', 304);
    });
    AppUpdateFeed open(Uri url) => AppUpdateFeed(
      uri: url,
      cacheFile: () async => cache,
      client: client,
      now: () => now,
    );
    final first = open(uri);
    expect(await first.load(), isNotEmpty);
    final restarted = open(uri);
    now = now.add(const Duration(hours: 3));
    expect(await restarted.load(), isNotEmpty);
    expect(requests, 1);
    await restarted.load(force: true);
    expect(requests, 2);
    now = now.add(const Duration(hours: 6));
    await restarted.load();
    expect(requests, 3);
    await open(Uri.parse('https://another.example/stable/index.json')).load();
    expect(requests, 4);
    client.close();
  });

  test('failed or malformed refresh preserves cache and can recover without stale success', () async {
    Object response = http.Response(
      fixture,
      200,
      headers: {
        'etag': 'v1',
        'content-type': 'application/json; charset=utf-8',
      },
    );
    final feed = AppUpdateFeed(
      uri: uri,
      cacheFile: () async => cache,
      client: MockClient((_) async {
        if (response is Exception) throw response;
        return response as http.Response;
      }),
    );
    addTearDown(feed.close);
    await feed.load();
    final original = await cache.readAsString();
    for (final failure in [
      http.Response('', 404),
      http.Response('', 503),
      http.Response('{}', 200),
      http.ClientException('offline'),
    ]) {
      response = failure;
      await expectLater(feed.load(force: true), throwsA(isA<Exception>()));
      expect(await cache.readAsString(), original);
    }
    response = http.Response('{"schema":1,"updates":[]}', 200);
    expect(await feed.load(force: true), isEmpty);
    await cache.writeAsString('corrupt');
    response = http.Response('', 304);
    await expectLater(
      feed.load(force: true),
      throwsA(isA<http.ClientException>()),
    );
  });

  test(
    'overlapping checks share one request and release it after failure',
    () async {
      final requested = Completer<void>();
      final response = Completer<http.Response>();
      var requests = 0;
      final feed = AppUpdateFeed(
        uri: uri,
        cacheFile: () async => cache,
        client: MockClient((_) {
          requests++;
          if (!requested.isCompleted) requested.complete();
          return response.future;
        }),
      );
      addTearDown(feed.close);
      final first = feed.load();
      await requested.future;
      final second = feed.load(force: true);
      final expected = expectLater(
        Future.wait([first, second]),
        throwsA(isA<http.ClientException>()),
      );
      response.complete(http.Response('', 503));
      await expected;
      expect(requests, 1);
      await expectLater(
        feed.load(force: true),
        throwsA(isA<http.ClientException>()),
      );
      expect(requests, 2);
    },
  );
}
