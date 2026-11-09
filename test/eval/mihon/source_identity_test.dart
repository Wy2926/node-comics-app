import 'dart:convert';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/mihon/source_identity.dart';
import 'package:mangayomi/models/proto/mihon_extension_store.pb.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/extension_store_service.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';

void main() {
  const rawId = '5724751873601868259';
  const baseUrl = 'https://example.test';
  final extension = {
    'name': 'Fixture',
    'packageName': 'eu.kanade.tachiyomi.extension.zh.fixture',
    'versionName': '1.6.33',
    'resources': {'apkUrl': 'fixture.apk'},
    'sources': [
      {'id': rawId, 'name': 'Fixture', 'language': 'zh', 'homeUrl': baseUrl},
    ],
  };

  test(
    'legacy installations retain their database identity and URL fallback',
    () {
      for (final metadata in [null, '', 'legacy text', '{}', '[]']) {
        final source = Source(id: 123, baseUrl: baseUrl, lang: 'zh')
          ..additionalParams = metadata;
        expect(source.mihonSourceIdentity, {
          'sourceId': '123',
          'sourceBaseUrl': baseUrl,
          'lang': 'zh',
        });
      }
    },
  );

  test('all Mihon catalog formats preserve the original 64-bit ID', () async {
    final store = NetworkExtensionStore(
      name: 'Fixture',
      extensionList: ExtensionStoreExtensionList(
        extensions: [
          ExtensionStoreItem(
            name: 'Fixture',
            packageName: extension['packageName'] as String,
            versionName: '1.6.33',
            resources: ExtensionStoreResources(apkUrl: 'fixture.apk'),
            sources: [
              ExtensionStoreSource(
                id: Int64.parseInt(rawId),
                name: 'Fixture',
                language: 'zh',
                homeUrl: baseUrl,
              ),
            ],
          ),
        ],
      ),
    );
    final client = InterceptedClient.build(
      interceptors: [],
      client: MockClient((req) async {
        switch (req.url.path) {
          case '/repo.json':
            return http.Response('{}', 200);
          case '/index.pb':
            return http.Response.bytes(gzip.encode(store.writeToBuffer()), 200);
          case '/external.pb':
            return http.Response.bytes(
              NetworkExtensionStore(
                name: 'Fixture',
                extensionListUrl: 'list.json',
              ).writeToBuffer(),
              200,
            );
          case '/list.json':
            return http.Response(
              jsonEncode({
                'extensions': [extension],
              }),
              200,
            );
          case '/index.json':
            return http.Response(
              jsonEncode({
                'name': 'Fixture',
                'extensionList': {
                  'extensions': [extension],
                },
              }),
              200,
            );
          default:
            return http.Response(
              jsonEncode([
                {
                  'name': 'Fixture',
                  'pkg': extension['packageName'],
                  'version': '1.6.33',
                  'code': 33,
                  'lang': 'zh',
                  'nsfw': 0,
                  'apk': 'fixture.apk',
                  'sources': [
                    {
                      'id': int.parse(rawId),
                      'name': 'Fixture',
                      'lang': 'zh',
                      'baseUrl': baseUrl,
                    },
                  ],
                },
              ]),
              200,
            );
        }
      }),
    );
    addTearDown(client.close);
    for (final path in [
      'index.pb',
      'index.json',
      'external.pb',
      'legacy.json',
    ]) {
      final result = await ExtensionStoreService.fetchStore(
        'https://repo.test/$path',
        client,
      );
      final source = result!.sources.single;
      expect(source.id, 'mihon-$rawId'.hashCode, reason: path);
      expect(source.mihonSourceIdentity, {
        'sourceId': rawId,
        'sourceBaseUrl': baseUrl,
        'lang': 'zh',
      }, reason: path);
      expect(
        Source.fromJson(source.toJson()).mihonSourceIdentity,
        source.mihonSourceIdentity,
      );
    }
  });

  test(
    'installation metadata requests select the same source as browsing',
    () async {
      final seen = <String>[];
      final client = InterceptedClient.build(
        interceptors: [],
        client: MockClient((req) async {
          final body = jsonDecode(req.body) as Map;
          expect(body['sourceId'], rawId);
          expect(body['sourceBaseUrl'], baseUrl);
          expect(body['lang'], 'zh');
          expect(body['data'], 'fixture.apk');
          expect(
            req.headers['content-type'],
            'application/json; charset=utf-8',
          );
          seen.add(body['method'] as String);
          return http.Response(
            body['method'] == 'supportLatestManga' ? 'true' : '[]',
            200,
          );
        }),
      );
      addTearDown(client.close);
      final source = Source(
        id: 123,
        baseUrl: baseUrl,
        lang: 'zh',
        sourceCode: 'fixture.apk',
        additionalParams: jsonEncode({'mihonSourceId': rawId}),
      );
      await fetchHeadersDalvik(client, source, 'http://127.0.0.1:1234');
      expect(
        await fetchSupportLatestDalvik(client, source, 'http://127.0.0.1:1234'),
        isTrue,
      );
      await fetchFilterListDalvik(client, source, 'http://127.0.0.1:1234');
      await fetchPreferencesDalvik(client, source, 'http://127.0.0.1:1234');
      expect(seen, [
        'headersManga',
        'supportLatestManga',
        'filtersManga',
        'preferencesManga',
      ]);
    },
  );
}
