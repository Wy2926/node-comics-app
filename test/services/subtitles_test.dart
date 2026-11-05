import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/services/subtitles/imdb_catalog.dart';
import 'package:mangayomi/services/subtitles/subtitle_http.dart';
import 'package:mangayomi/services/subtitles/subtitle_preferences.dart';
import 'package:mangayomi/services/subtitles/subtitle_service.dart';
import 'package:mangayomi/services/subtitles/wyzie_subtitle_source.dart';

Matcher fails(SubtitleFailureCode code) =>
    throwsA(isA<SubtitleFailure>().having((e) => e.code, 'code', code));

Map<String, Object> subtitle(String url, {String format = 'srt'}) => {
  'url': url,
  'language': 'zh',
  'display': '中文',
  'format': format,
  'media': 'Sample',
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('personal key is confined to subtitle search; content uses the returned link once', () async {
    final requests = <http.Request>[];
    final transport = SubtitleHttp(
      client: MockClient((request) async {
        requests.add(request);
        if (request.url.host == 'api.imdbapi.dev') {
          return http.Response(
            jsonEncode({
              'titles': [
                {
                  'id': 'tt123',
                  'primaryTitle': 'A & B',
                  'type': 'TV_SERIES',
                  'rating': {'aggregateRating': 8},
                },
              ],
            }),
            200,
          );
        }
        if (request.url.path == '/search') {
          return http.Response(
            jsonEncode([
              subtitle(
                'https://sub.wyzie.io/c/file?tok=signed-link',
                format: 'ass',
              ),
            ]),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return http.Response(
          '[Script Info]\nTitle: 字幕',
          200,
          headers: {'content-type': 'text/plain; charset=utf-8'},
        );
      }),
    );
    addTearDown(transport.close);
    final catalog = ImdbSubtitleCatalog(transport);
    final titles = await catalog.searchTitles(' A & B ');
    expect(titles.single.isSeries, isTrue);
    expect(requests.single.url.queryParameters, {'query': 'A & B'});
    expect(requests.single.headers, isNot(contains('authorization')));
    final source = WyzieSubtitleSource.personal(transport, 'personal-fixture');
    final matches = await source.search(
      const SubtitleQuery('tt123', season: 2, episode: 4),
    );
    expect(requests[1].url.queryParameters, {
      'id': 'tt123',
      'season': '2',
      'episode': '4',
      'encoding': 'utf-8',
      'key': 'personal-fixture',
    });
    final content = await matches.single.load();
    expect(content.text, contains('字幕'));
    expect(content.format, 'ass');
    expect(requests[2].url.queryParameters, {'tok': 'signed-link'});
    expect(requests[2].headers, isNot(contains('authorization')));
    expect(requests, hasLength(3));
  });

  test('custom path and token stay with that service; public CDN and keyless service work', () async {
    final requests = <http.Request>[];
    final transport = SubtitleHttp(
      client: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/api/subtitles') {
          return http.Response(
            jsonEncode([
              subtitle('/files/local.srt'),
              subtitle('https://cdn.example/subtitle.srt?tok=fixture'),
            ]),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return http.Response('1\n00:00:00,000 --> 00:00:01,000\nHello', 200);
      }),
    );
    addTearDown(transport.close);
    final endpoint = Uri.parse('https://own.example/api/subtitles');
    final source = WyzieSubtitleSource.custom(
      transport,
      endpoint,
      token: 'own-fixture',
    );
    final matches = await source.search(const SubtitleQuery('tt123'));
    await matches.first.load();
    await matches.last.load();
    expect(requests[0].url.path, '/api/subtitles');
    expect(requests[0].url.queryParameters, isNot(contains('key')));
    for (final request in requests.take(2)) {
      expect(request.headers['authorization'], 'Bearer own-fixture');
    }
    expect(requests.last.headers, isNot(contains('authorization')));
    await WyzieSubtitleSource.custom(
      transport,
      endpoint,
    ).search(const SubtitleQuery('tt456'));
    expect(requests.last.headers, isNot(contains('authorization')));
  });

  test('authentication, quota, bad responses and redirects fail without retry or secret text', () async {
    var status = 401, calls = 0;
    var body = 'secret-fixture';
    final transport = SubtitleHttp(
      client: MockClient((request) async {
        calls++;
        expect(request.followRedirects, isFalse);
        return http.Response(
          body,
          status,
          headers: {'location': 'https://other.example'},
        );
      }),
    );
    addTearDown(transport.close);
    final source = WyzieSubtitleSource.personal(transport, 'secret-fixture');
    for (final entry in {
      401: SubtitleFailureCode.authentication,
      403: SubtitleFailureCode.authentication,
      402: SubtitleFailureCode.quota,
      429: SubtitleFailureCode.quota,
      503: SubtitleFailureCode.network,
      302: SubtitleFailureCode.response,
      200: SubtitleFailureCode.response,
    }.entries) {
      status = entry.key;
      final before = calls;
      await expectLater(
        source.search(const SubtitleQuery('tt1')),
        throwsA(
          isA<SubtitleFailure>()
              .having((e) => e.code, 'code', entry.value)
              .having(
                (e) => e.toString(),
                'safe error',
                isNot(contains('secret-fixture')),
              ),
        ),
      );
      expect(calls, before + 1);
    }
    status = 400;
    body = '{"message":"No subtitles found"}';
    expect(await source.search(const SubtitleQuery('tt1')), isEmpty);
    body = '{"message":"Invalid source"}';
    await expectLater(
      source.search(const SubtitleQuery('tt1')),
      fails(SubtitleFailureCode.response),
    );
  });

  test(
    'oversized downloads fail and closing cancels an in-flight request',
    () async {
      final transport = SubtitleHttp(
        client: MockClient((_) async => http.Response('too large', 200)),
      );
      await expectLater(
        transport.get(Uri.parse('https://own.example/file'), maxBytes: 2),
        fails(SubtitleFailureCode.response),
      );
      transport.close();

      final started = Completer<void>();
      final pending = SubtitleHttp(
        client: MockClient.streaming((request, _) async {
          started.complete();
          await (request as http.Abortable).abortTrigger;
          throw http.RequestAbortedException(request.url);
        }),
      );
      final request = pending.get(Uri.parse('https://own.example/slow'));
      final failed = expectLater(request, fails(SubtitleFailureCode.network));
      await started.future;
      pending.close();
      await failed;
    },
  );

  test('configuration restores, replaces credentials and retires the old source only after save', () async {
    final store = _FailingStore();
    final container = ProviderContainer(
      overrides: [subtitlePreferencesStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    final serviceProvider = subtitleSearchServiceProvider(Object());
    final subscription = container.listen(serviceProvider, (_, _) {});
    addTearDown(subscription.close);
    final controller = container.read(subtitlePreferencesProvider.notifier);
    expect(await container.read(serviceProvider.future), isNull);
    await controller.save(SubtitlePreferences.personalKey('personal-fixture'));
    final first = (await container.read(serviceProvider.future))!;
    final otherProvider = subtitleSearchServiceProvider(Object());
    final otherListener = container.listen(otherProvider, (_, _) {});
    final other = (await container.read(otherProvider.future))!;
    expect(other, isNot(same(first)));
    otherListener.close();
    await container.pump();
    await expectLater(
      other.source.search(const SubtitleQuery('tt1')),
      fails(SubtitleFailureCode.network),
    );
    expect(await container.read(serviceProvider.future), same(first));
    expect(
      (await SubtitlePreferencesStore().read()).credential,
      'personal-fixture',
    );
    store.fail = true;
    await expectLater(
      controller.save(
        SubtitlePreferences.customService(
          'https://own.example/api/subtitles',
          token: 'custom-fixture',
        ),
      ),
      throwsStateError,
    );
    expect(await container.read(serviceProvider.future), same(first));
    store.fail = false;
    await controller.save(
      SubtitlePreferences.customService('https://own.example/api/subtitles'),
    );
    final second = (await container.read(serviceProvider.future))!;
    expect(second, isNot(same(first)));
    await expectLater(
      first.source.search(const SubtitleQuery('tt1')),
      fails(SubtitleFailureCode.network),
    );
    final restored = await SubtitlePreferencesStore().read();
    expect(restored.endpoint.toString(), 'https://own.example/api/subtitles');
    expect(restored.credential, isEmpty);
    await controller.save(const SubtitlePreferences.disabled());
    expect(await container.read(serviceProvider.future), isNull);
    expect(
      (await SubtitlePreferencesStore().read()).mode,
      SubtitleConnectionMode.disabled,
    );
    await expectLater(
      second.source.search(const SubtitleQuery('tt1')),
      fails(SubtitleFailureCode.network),
    );
  });
}

class _FailingStore extends SubtitlePreferencesStore {
  bool fail = false;
  @override
  Future<void> write(SubtitlePreferences value) async {
    if (fail) throw StateError('Storage unavailable');
    await super.write(value);
  }
}
