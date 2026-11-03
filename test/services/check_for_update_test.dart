import 'package:flutter_test/flutter_test.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/utils/nodelane_brand.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';

void main() {
  test('release requests use the product repository and preserve release content', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), NodeLaneBrand.releasesApi);
      return http.Response(
        jsonEncode({
          'tag_name': 'v1.2.3',
          'body': 'Release notes',
          'html_url': '${NodeLaneBrand.repositoryUrl}/releases/tag/v1.2.3',
          'assets': [
            {
              'browser_download_url':
                  '${NodeLaneBrand.repositoryUrl}/releases/download/v1.2.3/app.ipa',
            },
          ],
        }),
        200,
      );
    });
    final release = await fetchLatestAppRelease(client: client);
    expect(release?.$1, '1.2.3');
    expect(release?.$2, 'Release notes');
    expect(release?.$3, startsWith(NodeLaneBrand.repositoryUrl));
    expect(release?.$4.single, endsWith('/app.ipa'));
  });

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
        client: MockClient(
          (_) async => throw http.ClientException('offline'),
        ),
      ),
      throwsA(isA<http.ClientException>()),
    );
  });

  group('compareVersions Tests', () {
    test('standard semver comparisons', () {
      expect(compareVersions('0.9.1', '0.9.1'), equals(0));
      expect(compareVersions('0.9.1', '0.9.2'), equals(-1));
      expect(compareVersions('0.9.2', '0.9.1'), equals(1));
      expect(compareVersions('0.9.1', '1.0.0'), equals(-1));
      expect(compareVersions('1.0.0', '0.9.1'), equals(1));
    });

    test('multi-digit segment comparison (0.9.1 vs 0.10.0)', () {
      // Critical regression test: 9 must be less than 10
      expect(compareVersions('0.9.1', '0.10.0'), equals(-1));
      expect(compareVersions('0.10.0', '0.9.1'), equals(1));
      expect(compareVersions('0.2', '0.11'), equals(-1));
      expect(compareVersions('0.11', '0.2'), equals(1));
      expect(compareVersions('0.100.0', '0.99.9'), equals(1));
    });

    test('different segment lengths', () {
      expect(compareVersions('0.9', '0.9.0'), equals(0));
      expect(compareVersions('0.9.0', '0.9'), equals(0));
      expect(compareVersions('0.9.1', '0.9.1.1'), equals(-1));
      expect(compareVersions('0.9.1.1', '0.9.1'), equals(1));
      expect(compareVersions('1', '1.0.0.0'), equals(0));
    });

    test('handles leading v or V prefix', () {
      expect(compareVersions('v0.9.1', '0.9.1'), equals(0));
      expect(compareVersions('V0.9.1', 'v0.9.1'), equals(0));
      expect(compareVersions('v0.9.1', 'v0.10.0'), equals(-1));
      expect(compareVersions('v0.10.0', 'v0.9.1'), equals(1));
    });

    test('handles build metadata and pre-release suffixes', () {
      expect(compareVersions('0.9.1+119', '0.9.1'), equals(0));
      expect(compareVersions('0.9.1-beta', '0.9.1'), equals(0));
      expect(compareVersions('0.9.1+119', '0.10.0'), equals(-1));
      expect(compareVersions('v0.9.1-alpha.1', '0.9.2'), equals(-1));
    });

    test('handles whitespace gracefully', () {
      expect(compareVersions(' 0.9.1 ', '0.9.1'), equals(0));
      expect(compareVersions(' v0.9.1 ', ' 0.10.0 '), equals(-1));
    });
  });
}
