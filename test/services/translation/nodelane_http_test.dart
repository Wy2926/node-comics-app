import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/translation/channels/nodelane/http.dart';
import 'package:mangayomi/services/translation/contracts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final previousHttpOverrides = HttpOverrides.current;
  HttpOverrides.global = null;
  tearDownAll(() => HttpOverrides.global = previousHttpOverrides);
  late Directory directory;
  late HttpServer apiServer, assetServer;
  late NodeLaneHttp api;
  late File output;
  final requests = <(String, String?)>[];
  final bytes = [1, 2, 3, 4];
  var assetStatus = 200, loop = false, returnToApi = false;
  var received = Completer<void>(), held = Completer<void>();
  var hold = false;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('nodelane-http-');
    output = File('${directory.path}/artifact');
    requests.clear();
    assetStatus = 200;
    loop = returnToApi = hold = false;
    received = Completer<void>();
    held = Completer<void>();
    apiServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    assetServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    api = NodeLaneHttp(
      Uri.parse('http://127.0.0.1:${apiServer.port}'),
      token: () async => 'fixture-only',
      allowLocalTestServer: true,
    );
    apiServer.listen((request) async {
      request.response.headers.removeAll(HttpHeaders.contentTypeHeader);
      requests.add((request.uri.path, request.headers.value('authorization')));
      expect(request.headers.value('cookie'), isNull);
      if (request.uri.path == '/v1/capabilities') {
        request.response.statusCode = 429;
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode({
            'error': {'code': 'IMAGE_RATE_LIMITED', 'retry_after_seconds': 3.5},
          }),
        );
      } else if (request.uri.path == '/returned') {
        request.response.add(bytes);
      } else {
        expect(request.headers.value('X-Translation-Protocol'), 'overlay-v1');
        request.response.statusCode = 307;
        request.response.headers.set(
          'location',
          request.uri.path.endsWith('/result')
              ? '/authorized-asset'
              : loop
              ? '/authorized-asset'
              : 'http://127.0.0.1:${assetServer.port}/asset',
        );
      }
      await request.response.close();
    });
    assetServer.listen((request) async {
      request.response.headers.removeAll(HttpHeaders.contentTypeHeader);
      requests.add((request.uri.path, request.headers.value('authorization')));
      expect(request.headers.value('cookie'), isNull);
      if (!received.isCompleted) received.complete();
      if (hold) await held.future;
      request.response.statusCode = returnToApi ? 302 : assetStatus;
      if (returnToApi) {
        request.response.headers.set(
          'location',
          'http://127.0.0.1:${apiServer.port}/returned',
        );
      } else {
        // The extension accepts a missing Content-Type and uses the descriptor.
        request.response.add(bytes);
      }
      await request.response.close();
    });
  });
  tearDown(() async {
    if (!held.isCompleted) held.complete();
    api.close();
    await apiServer.close(force: true);
    await assetServer.close(force: true);
    await directory.delete(recursive: true);
  });

  Future<void> download([TranslationCancellation? cancel]) => api.download(
    'page',
    output,
    expectedSize: bytes.length,
    mime: 'image/webp',
    cancellation: cancel ?? TranslationCancellation(),
  );

  test('result redirects keep same-origin auth and strip it across ports and on return', () async {
    returnToApi = true;
    await download();
    expect(await output.readAsBytes(), bytes);
    expect(requests, [
      ('/v1/translations/page/result', 'Bearer fixture-only'),
      ('/authorized-asset', 'Bearer fixture-only'),
      ('/asset', null),
      ('/returned', null),
    ]);
  });

  test(
    'asset authorization errors remain result failures and allow another read',
    () async {
      assetStatus = 401;
      await expectLater(
        download(),
        throwsA(
          isA<TranslationFailure>().having(
            (e) => e.code,
            'code',
            'RESULT_UNAVAILABLE',
          ),
        ),
      );
      expect(await output.exists(), isFalse);
      assetStatus = 200;
      await download();
      expect(await output.readAsBytes(), bytes);
      expect(
        requests.where((r) => r.$1 == '/asset').every((r) => r.$2 == null),
        isTrue,
      );
    },
  );

  test('redirect loops terminate without publishing a result', () async {
    loop = true;
    await expectLater(
      download(),
      throwsA(
        isA<TranslationFailure>().having(
          (e) => e.code,
          'code',
          'INVALID_RESULT',
        ),
      ),
    );
    expect(await output.exists(), isFalse);
    expect(requests, hasLength(2));
  });

  test('cancellation aborts a redirected download', () async {
    hold = true;
    final cancel = TranslationCancellation();
    final result = expectLater(
      download(cancel),
      throwsA(isA<TranslationCancelled>()),
    );
    await received.future;
    cancel.cancel();
    await result;
    expect(await output.exists(), isFalse);
  });

  test('rate-limit delay can be supplied in the protocol error body', () async {
    await expectLater(
      api.json('GET', '/v1/capabilities'),
      throwsA(
        isA<TranslationFailure>()
            .having((e) => e.code, 'code', 'RATE_LIMITED')
            .having(
              (e) => e.retryAfter,
              'retryAfter',
              const Duration(seconds: 4),
            ),
      ),
    );
  });
}
