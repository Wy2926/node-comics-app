import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/utils/nodelane_brand.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';

Map<String, dynamic> release(String version, String filename) => {
  'tag_name': 'v$version',
  'draft': false,
  'prerelease': false,
  'body': 'Release notes $version',
  'html_url': '${NodeLaneBrand.repositoryUrl}/releases/tag/v$version',
  'assets': [
    {
      'state': 'uploaded',
      'browser_download_url':
          '${NodeLaneBrand.repositoryUrl}/releases/download/v$version/$filename',
    },
  ],
};

void main() {
  test('each platform finds its highest stable uploaded release', () async {
    final pending = release('9.0.0', 'app.ipa');
    (pending['assets'] as List).single['state'] = 'starter';
    final releases = [
      // A newer publication can be an older backport.
      release('0.1.0', 'app.ipa'),
      release('0.4.0', 'app.dmg'),
      release('0.3.0', 'app.ipa')..['draft'] = true,
      release('0.3.0', 'app.ipa')..['prerelease'] = true,
      release('0.3.0-beta', 'app.ipa'),
      pending,
      release('0.2.0', 'app.ipa'),
      release('0.5.0', 'app-windows.zip'),
      release('0.6.0', 'app-linux.zip'),
      release('0.7.0', 'app-android-arm64.apk'),
      release('0.8.0', 'app-android-tv-arm64.apk'),
    ];
    final client = MockClient(
      (_) async => http.Response(jsonEncode(releases), 200),
    );
    for (final (platform, tv, version) in [
      ('ios', false, '0.2.0'),
      ('macos', false, '0.4.0'),
      ('windows', false, '0.5.0'),
      ('linux', false, '0.6.0'),
      ('android', false, '0.7.0'),
      ('android', true, '0.8.0'),
    ]) {
      final result = await fetchLatestAppRelease(
        client: client,
        platform: platform,
        androidTv: tv,
      );
      expect(result?.$1, version, reason: '$platform / TV=$tv');
      expect(result?.$2, 'Release notes $version');
      expect(
        result?.$3,
        '${NodeLaneBrand.repositoryUrl}/releases/tag/v$version',
      );
      expect(result?.$4.single, contains('/releases/download/v$version/'));
    }
    final desktopOnly = MockClient(
      (_) async =>
          http.Response(jsonEncode([release('0.4.0', 'app.dmg')]), 200),
    );
    expect(
      await fetchLatestAppRelease(client: desktopOnly, platform: 'ios'),
      isNull,
    );
  });

  test(
    'pagination failure returns no partial result and a new check can recover',
    () async {
      final pages = <String>[];
      var fail = true;
      final client = MockClient((request) async {
        final page = request.url.queryParameters['page']!;
        pages.add(page);
        if (page == '1') {
          return http.Response(
            jsonEncode(List.generate(100, (_) => release('0.2.0', 'app.ipa'))),
            200,
          );
        }
        if (fail) return http.Response('', 503);
        return http.Response(jsonEncode([release('0.3.0', 'app.ipa')]), 200);
      });
      await expectLater(
        fetchLatestAppRelease(client: client, platform: 'ios'),
        throwsFormatException,
      );
      fail = false;
      expect(
        (await fetchLatestAppRelease(client: client, platform: 'ios'))?.$1,
        '0.3.0',
      );
      expect(pages, ['1', '2', '1', '2']);
    },
  );

  test('missing release differs from failed or malformed checks', () async {
    expect(
      await fetchLatestAppRelease(
        client: MockClient((_) async => http.Response('', 404)),
      ),
      isNull,
    );
    for (final response in [
      http.Response('', 503),
      http.Response('not json', 200),
      http.Response('{}', 200),
    ]) {
      await expectLater(
        fetchLatestAppRelease(client: MockClient((_) async => response)),
        throwsFormatException,
      );
    }
    await expectLater(
      fetchLatestAppRelease(
        client: MockClient((_) async => throw http.ClientException('offline')),
      ),
      throwsA(isA<http.ClientException>()),
    );
  });

  test('version ordering normalizes tags and compares numeric components', () {
    for (final (left, right, expected) in [
      ('0.1.0', '0.1.0', 0),
      ('0.1.0', '0.1.1', -1),
      ('0.9.9', '1.0.0', -1),
      ('0.9.1', '0.10.0', -1),
      ('0.9', '0.9.0', 0),
      ('0.9.1', '0.9.1.1', -1),
      (' v0.9.1 ', 'V0.9.1', 0),
      ('0.9.1+119', '0.9.1-beta', 0),
      ('v0.9.1-alpha.1', '0.9.2', -1),
    ]) {
      expect(compareVersions(left, right), expected, reason: '$left / $right');
      if (expected != 0) {
        expect(compareVersions(right, left), -expected);
      }
    }
  });
}
