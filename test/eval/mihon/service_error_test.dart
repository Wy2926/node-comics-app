import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/mihon/service.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';

void main() {
  for (final (itemType, chapter, type) in [
    (ItemType.manga, false, 'Manga'),
    (ItemType.manga, true, 'Chapter'),
    (ItemType.anime, false, 'Anime'),
    (ItemType.anime, true, 'Episode'),
  ]) {
    test(
      '$type web URL uses the extension resolver and shared request metadata',
      () async {
        const originalId = '5724751873601868259';
        const target = 'https://reader.example.test/actual/page.html';
        final preferences = [
          {'id': 1, 'sourceId': 123, 'key': '阅读镜像'},
        ];
        final client = InterceptedClient.build(
          interceptors: [],
          client: MockClient((req) async {
            final body = jsonDecode(req.body) as Map;
            expect(body['method'], 'get${type}Url');
            expect(body['${type.toLowerCase()}Data'], {
              'url': '/internal?id=1',
            });
            expect(body['sourceId'], originalId);
            expect(body['sourceBaseUrl'], 'https://catalog.example.test');
            expect(body['lang'], 'zh');
            expect(body['data'], 'fixture.apk');
            expect(body['preferences'], preferences);
            expect(
              req.headers['content-type'],
              'application/json; charset=utf-8',
            );
            return http.Response(jsonEncode(target), 200);
          }),
        );
        addTearDown(client.close);
        final source = Source(
          baseUrl: 'https://catalog.example.test',
          itemType: itemType,
          lang: 'zh',
          sourceCode: 'fixture.apk',
          preferenceList: jsonEncode(preferences),
          additionalParams: jsonEncode({'mihonSourceId': originalId}),
        );
        final service = _MihonService(source, client);
        expect(
          await service.getWebUrl('/internal?id=1', chapter: chapter),
          target,
        );
      },
    );
  }

  test('a generic bridge 403 keeps its actual error', () {
    final response = http.Response(
      '{"error":"HTTP error 403","code":403}',
      403,
    );

    expect(
      () => hasError(response),
      throwsA(
        allOf(
          contains('HTTP error 403'),
          contains('statusCode: 403'),
          isNot(contains('Cloudflare')),
        ),
      ),
    );
  });
}

class _MihonService extends MihonExtensionService {
  _MihonService(Source source, this._transport)
    : super(source, 'http://127.0.0.1:1234');

  final InterceptedClient _transport;
  @override
  InterceptedClient get client => _transport;

  @override
  Map<String, String> getCookie() => {};
}
