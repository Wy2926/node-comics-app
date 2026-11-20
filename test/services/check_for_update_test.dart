import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/services/app_update_feed.dart';
import 'package:mangayomi/services/app_update_manifest.dart';
import 'package:mangayomi/services/nodelane_requests.dart';
import 'package:mangayomi/utils/nodelane_brand.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
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
      ('macos', false, <String>[], '0.3.0', 'any'),
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
  });

  test(
    'custom hosts, ports and URL parameters work without optional metadata',
    () {
      for (final url in [
        'https://cdn.example:8443/download?id=42&token=example#package',
        'http://192.0.2.1:8080/app.apk',
      ]) {
        final update = parseAppUpdateManifest(
          jsonEncode({
            'schema': 1,
            'updates': [
              {'platform': 'android', 'version': 'v1.2-beta+7', 'url': url},
              {
                'platform': 'future-platform',
                'arch': 'new-arch',
                'version': '2',
                'url': url,
              },
            ],
          }),
        ).first;
        expect(update.url, url);
        expect(update.externalUrl, url);
        expect(update.arch, 'universal');
        expect(update.build, 0);
        expect(update.notes, isEmpty);
      }
    },
  );

  test('Android excludes known downgrades before ranking, but supports legacy feeds', () {
    const low = UpdateInfo(
      version: '1.0',
      build: 3,
      url: 'https://cdn.example/a',
    );
    const high = UpdateInfo(
      version: '1.0',
      build: 4,
      url: 'https://cdn.example/b',
    );
    for (final (updates, version, build, expected) in [
      ([low, high], '1.0', 2, high),
      ([high, low], '1.0', 2, high),
      ([low, high], '0.9', 100, null),
      ([low, high], '1.0', 4, null),
      ([low, high], '1.1', 1, null),
    ]) {
      expect(
        selectAppUpdate(
          updates,
          platform: 'android',
          currentVersion: version,
          currentBuild: build,
        ),
        expected,
      );
    }
    const split = UpdateInfo(
      version: '0.2.1',
      build: 6008,
      arch: 'x86_64',
      url: 'https://cdn.example/split.apk',
    );
    const lowerUniversal = UpdateInfo(
      version: '0.2.2',
      build: 2009,
      url: 'https://cdn.example/universal.apk',
    );
    const legacy = UpdateInfo(
      version: '0.2.1',
      url: 'https://cdn.example/legacy.apk',
    );
    UpdateInfo? select(List<UpdateInfo> updates) => selectAppUpdate(
      updates,
      platform: 'android',
      currentVersion: '0.2.0',
      currentBuild: 6007,
      androidAbis: ['x86_64'],
    );
    expect(select([lowerUniversal]), isNull);
    expect(select([lowerUniversal, split]), same(split));
    expect(select([legacy]), same(legacy));
    const armUniversal = UpdateInfo(
      version: '0.3.0',
      build: 9000,
      abis: ['arm64-v8a', 'armeabi-v7a'],
      url: 'https://cdn.example/arm.apk',
    );
    expect(select([armUniversal, split]), same(split));
    const desktop = UpdateInfo(
      platform: 'macos',
      version: '1.0',
      build: 4,
      url: 'https://cdn.example/app.dmg',
    );
    expect(
      selectAppUpdate(
        [desktop],
        platform: 'macos',
        currentVersion: '0.9',
        currentBuild: 100,
      ),
      same(desktop),
    );
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
      ('version', 'latest'),
      ('build', '2'),
      ('url', 'file:///app.apk'),
      ('page_url', 'javascript:alert(1)'),
    ]) {
      final root = jsonDecode(fixture) as Map<String, dynamic>;
      final entries = root['updates'] as List;
      entries.first[field] = value;
      expect(
        parseAppUpdateManifest(jsonEncode(root)),
        hasLength(entries.length - 1),
      );
      expect(
        () => parseAppUpdateManifest(
          jsonEncode({
            ...root,
            'updates': [entries.first],
          }),
        ),
        throwsFormatException,
        reason: field,
      );
    }
  });

  test('invalid fields cannot disable a declared digest or poison another platform', () {
    const android = {
      'platform': 'android',
      'version': '0.2.1',
      'url': 'https://cdn.example/a.apk',
    };
    const ios = {
      'platform': 'ios',
      'version': '0.2.1',
      'url': 'https://cdn.example/i.ipa',
    };
    List<UpdateInfo> parse(List<Object?> entries) =>
        parseAppUpdateManifest(jsonEncode({'schema': 1, 'updates': entries}));
    for (final invalid in [null, '', 'broken', 17]) {
      expect(
        parse([
          {...android, 'sha256': invalid},
          ios,
        ]).single.platform,
        'ios',
      );
      expect(
        () => parse([
          {...android, 'sha256': invalid},
        ]),
        throwsFormatException,
      );
    }
    final old = parse([
      {...ios, 'url': ''},
      android,
    ]).single;
    expect(old.platform, 'android');
    expect(old.sha256, isNull);
    expect(old.build, 0);
  });

  late Directory directory;
  test('only an eligible installed Android build gets a direct patch; full always remains usable', () {
    final hash = 'a' * 64;
    final patch = <String, dynamic>{
      'format': 'nld1',
      'from_version': '0.2.0',
      'from_build': 4007,
      'from_sha256': hash,
      'sha256': hash,
      'url': 'https://cdn.example/change',
      'size': 800,
    };
    UpdateInfo parse(Map<String, dynamic> extra) => parseAppUpdateManifest(
      jsonEncode({
        'schema': 1,
        'updates': [
          {
            'platform': 'android',
            'arch': 'arm64-v8a',
            'version': '0.2.1',
            'build': 4008,
            'url': 'https://cdn.example/full.apk',
            'sha256': hash,
            'size': 1000,
            'delta': patch,
            ...extra,
          },
        ],
      }),
    ).single;
    final update = parse({});
    expect(update.deltaFrom('0.2.0', 4007)?.url, patch['url']);
    for (final (v, b) in [
      ('0.1.4', 4005),
      ('0.2.0', 4006),
      ('0.2.0', 6007),
      ('0.2.1', 4008),
    ]) {
      expect(update.deltaFrom(v, b), isNull);
    }
    for (final extra in <Map<String, dynamic>>[
      {'full_only': true},
      {'full_only': null},
      {'full_only': 'false'},
      {'delta': null},
      {'delta': []},
      {'size': 0},
      {'platform': 'ios'},
      for (final override in [
        {'from_version': '0.1.4'},
        {'from_build': 4008},
        {'from_sha256': null},
        {'url': 'file:///patch'},
        {'format': 'future'},
        {'size': 1000},
        {'size': 0},
      ])
        {
          'delta': {...patch, ...override},
        },
    ]) {
      expect(parse(extra).delta, isNull, reason: '$extra');
      expect(parse(extra).url, update.url);
    }
    expect(
      parse({
        'delta': {...patch, 'size': 810},
      }).delta?.size,
      810,
    );
    expect(parse({'version': '0.2.0'}).deltaFrom('0.2.0', 4007), isNotNull);
  });
  late File cache;
  setUp(() async {
    PackageInfo.setMockInitialValues(
      appName: 'NodeLane Comics',
      packageName: 'com.nodelane.comics',
      version: '9.8.7',
      buildNumber: '654',
      buildSignature: '',
    );
    directory = await Directory.systemTemp.createTemp('nodelane-update-test-');
    cache = File('${directory.path}/cache.json');
  });
  tearDown(() => directory.delete(recursive: true));

  test('automatic cache persists, manual checks use ETag, and URL changes isolate state', () async {
    var now = DateTime.utc(2026, 11, 8);
    var requests = 0;
    final client = MockClient((request) async {
      requests++;
      expect(request.headers['User-Agent'], await NodeLaneRequests.userAgent);
      expect(request.headers['Accept'], 'application/json');
      expect(request.headers['Authorization'], isNull);
      expect(request.followRedirects, isTrue);
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
