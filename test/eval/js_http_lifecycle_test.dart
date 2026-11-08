import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/http/m_client.dart';

void main() {
  test(
    'disposing a chapter runtime preserves a reused HTTPS connection',
    () async {
      final context = SecurityContext()
        ..useCertificateChain('test/fixtures/source_https/certificate.pem')
        ..usePrivateKey('test/fixtures/source_https/private_key.pem');
      final server = await HttpServer.bindSecure(
        InternetAddress.loopbackIPv4,
        0,
        context,
      );
      final previous = HttpOverrides.current;
      HttpOverrides.global = _LocalTls(server.port);
      addTearDown(() => HttpOverrides.global = previous);
      addTearDown(() => server.close(force: true));
      addTearDown(() => MClient.defaultClient.close());
      var requests = 0;
      final connections = <int>{};
      server.listen((request) async {
        requests++;
        connections.add(request.connectionInfo!.remotePort);
        if (request.uri.path == '/3') request.response.statusCode = 503;
        request.response.write('chapter');
        await request.response.close();
      });
      final source = Source(
        id: 991,
        name: 'HTTP lifecycle fixture',
        baseUrl: 'https://127.0.0.1:${server.port}',
        sourceCode: '''
class DefaultExtension extends MProvider {
  async getPageList(url) {
    const response = await new Client({useDartHttpClient: true}).get(url);
    if (response.statusCode !== 200) throw new Error('temporary source failure');
    return [url + '/' + response.body];
  }
}
''',
      )..sourceCodeLanguage = SourceCodeLanguage.javascript;
      for (var chapter = 1; chapter <= 4; chapter++) {
        final request = withExtensionService(
          source,
          '',
          (service) => service.getPageList('${source.baseUrl}/$chapter'),
        ).timeout(const Duration(seconds: 3));
        if (chapter == 3) {
          await expectLater(
            request,
            throwsA(
              predicate<Object>(
                (error) =>
                    error.toString().contains('temporary source failure'),
              ),
            ),
          );
          continue;
        }
        final pages = await request;
        expect(pages.single.url, '${source.baseUrl}/$chapter/chapter');
      }
      expect(requests, 4);
      expect(connections, hasLength(1));
    },
  );
}

// Self-signed, generated test-only certificate; never used by production.
// Permit only this loopback server, without changing OS trust or real clients.
class _LocalTls extends HttpOverrides {
  _LocalTls(this.port);
  final int port;
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)
        ..badCertificateCallback = (_, host, targetPort) =>
            host == '127.0.0.1' && targetPort == port;
}
