import 'dart:convert';
import 'dart:io';

import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/javascript/source_runtime.dart';
import 'package:mangayomi/services/http/m_client.dart';

void main() {
  tearDownAll(() => MClient.defaultClient.close());

  for (final method in ['head', 'get', 'post', 'put', 'delete', 'patch']) {
    test('$method preserves its HTTP method, headers and body', () async {
      final runtime = SourceJavascriptRuntime();
      addTearDown(runtime.dispose);
      JsHttpClient(runtime).init();
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      final received = <Map<String, String?>>[];
      var status = HttpStatus.ok;
      server.listen((request) async {
        received.add({
          'method': request.method,
          'uri': request.uri.toString(),
          'header': request.headers.value('x-client-method'),
          'body': await utf8.decoder.bind(request).join(),
        });
        request.response
          ..statusCode = status
          ..headers.set('x-server-method', request.method)
          ..write('response:$method');
        await request.response.close();
      });

      final bodies = method == 'head' || method == 'get'
          ? <Object?>[null]
          : <Object?>[
              'payload:$method',
              {'operation': method},
            ];
      for (var i = 0; i < bodies.length; i++) {
        final body = bodies[i];
        final isJson = body is Map;
        final headers = {
          'x-client-method': method,
          if (body != null)
            'content-type': isJson ? 'application/json' : 'text/plain',
        };
        // An error response must retain the same method without a POST retry.
        status = isJson ? HttpStatus.unprocessableEntity : HttpStatus.ok;
        final url = 'http://127.0.0.1:${server.port}/items?case=$i';
        final evaluated = await runtime.evaluateAsync('''
          (async () => JSON.stringify(await new Client({useDartHttpClient: true})
            .$method(${jsonEncode(url)}, ${jsonEncode(headers)}, ${jsonEncode(body)})))()
        ''');
        final result = await runtime.run(
          () => runtime.handlePromise(
            evaluated,
            timeout: const Duration(seconds: 5),
          ),
        );
        expect(result.isError, isFalse, reason: result.stringResult);
        final response = jsonDecode(result.stringResult) as Map;

        expect(received, hasLength(i + 1));
        expect(received.last, {
          'method': method.toUpperCase(),
          'uri': '/items?case=$i',
          'header': method,
          'body': body == null
              ? ''
              : isJson
              ? jsonEncode(body)
              : body,
        });
        expect(response['statusCode'], status);
        expect(response['headers']['x-server-method'], method.toUpperCase());
        expect(response['body'], method == 'head' ? '' : 'response:$method');
      }
    });
  }
}
