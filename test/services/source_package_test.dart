import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/services/source_package.dart';
import 'package:mangayomi/services/source_catalog_config.dart';

void main() {
  const code = 'class DefaultExtension {}';
  Source fixture({Map<String, dynamic> changes = const {}}) => Source.fromJson({
    'id': 86001001,
    'name': 'Comix',
    'baseUrl': 'https://comix.to',
    'sourceCodeUrl': 'http://127.0.0.1:8787/packages/comix/0.2.0.js',
    'nodelane': {
      'schema': 1,
      'repositoryId': nodeLaneRepositoryId,
      'slug': 'comix',
      'sha256': sha256.convert(utf8.encode(code)).toString(),
      'size': utf8.encode(code).length,
      'requestHosts': ['comix.to'],
      'requires': [],
      ...changes,
    },
  });
  test('packages validate before execution; redirects, corruption and truncation fail', () async {
    final source = fixture();
    validatePackageLocation(source, nodeLaneCatalogUrl);
    for (final response in [
      http.Response('bad', 200),
      http.Response('', 503),
      http.Response(
        '',
        302,
        headers: {'location': 'https://elsewhere.test/code.js'},
      ),
    ]) {
      final client = MockClient((request) async {
        expect(request.followRedirects, isFalse);
        return response;
      });
      await expectLater(
        downloadSourcePackage(client, source),
        throwsStateError,
      );
      client.close();
    }
    final client = MockClient((_) async => http.Response(code, 200));
    expect(utf8.decode(await downloadSourcePackage(client, source)), code);
    client.close();
    expect(
      () => SourcePackage.of(fixture(changes: {'size': 2 * 1024 * 1024})),
      throwsStateError,
    );
    expect(
      SourcePackage.of(
        fixture(
          changes: {
            'requires': ['future-capability'],
          },
        ),
      )!.compatible,
      isFalse,
    );
  });
  test('host permissions reject lookalikes, credentials and insecure URLs', () {
    final p = SourcePackage.of(fixture())!;
    p.checkRequest(Uri.parse('https://comix.to/browse'));
    for (final url in [
      'https://comix.to.evil.test/browse',
      'https://sub.comix.to/',
      'http://comix.to/',
      'https://user@comix.to/',
      'https://comix.to:444/',
    ]) {
      expect(() => p.checkRequest(Uri.parse(url)), throwsStateError);
    }
  });
  test('development HTTP is limited to numeric private or loopback hosts', () {
    for (final host in [
      '127.0.0.1',
      'localhost',
      '10.2.3.4',
      '172.16.0.1',
      '172.31.9.1',
      '192.168.1.2',
    ]) {
      final source = fixture()..sourceCodeUrl = 'http://$host:8787/comix.js';
      validatePackageLocation(source, 'http://$host:8787/index.json');
    }
    for (final host in [
      '10.evil.test',
      '192.168.evil.test',
      '172.15.0.1',
      '172.32.0.1',
      '8.8.8.8',
    ]) {
      final source = fixture()..sourceCodeUrl = 'http://$host:8787/comix.js';
      expect(
        () => validatePackageLocation(source, 'http://$host:8787/index.json'),
        throwsStateError,
      );
    }
  });
  test('catalog collisions cannot overwrite another repository, even if its name matches', () {
    final incoming = fixture();
    final foreign = Source(
      id: incoming.id,
      baseUrl: incoming.baseUrl,
      repo: Repo(
        name: 'NodeLane 官方',
        jsonUrl: 'https://foreign.test/index.json',
      ),
    );
    expect(canReplaceSource(foreign, incoming, nodeLaneCatalogUrl), isFalse);
    final legacy = Source(
      id: 86001001,
      baseUrl: 'https://comix.to',
      repo: Repo(jsonUrl: nodeLaneCatalogUrl),
    );
    expect(canReplaceSource(legacy, incoming, nodeLaneCatalogUrl), isTrue);
    final installed = fixture()
      ..repo = Repo(jsonUrl: 'http://192.168.1.2:8787/index.json');
    expect(canReplaceSource(installed, incoming, nodeLaneCatalogUrl), isTrue);
    expect(
      canReplaceSource(installed, incoming, 'https://foreign.test/index.json'),
      isFalse,
    );
    final unsigned = Source(id: 86001001)
      ..repo = Repo(jsonUrl: nodeLaneCatalogUrl);
    expect(
      canReplaceSource(
        incoming..repo = unsigned.repo,
        unsigned,
        nodeLaneCatalogUrl,
      ),
      isFalse,
    );
    expect(
      () => validatePackageLocation(unsigned, nodeLaneCatalogUrl),
      throwsStateError,
    );
  });
}
