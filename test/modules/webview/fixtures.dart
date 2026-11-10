import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class WebImageTestDirectory {
  late Directory directory;
  late PathProviderPlatform _previous;

  Future<void> setUp() async {
    directory = await Directory.systemTemp.createTemp('web-image-test-');
    _previous = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _Paths(directory.path);
  }

  Future<void> tearDown() async {
    PathProviderPlatform.instance = _previous;
    await directory.delete(recursive: true);
  }
}

class _Paths extends PathProviderPlatform {
  _Paths(this.path);
  final String path;
  @override
  Future<String?> getTemporaryPath() async => path;
}

String archiveFixture(Map<String, List<int>> images) =>
    'MIME-Version: 1.0\r\nContent-Type: multipart/related;\r\n boundary="fixture"\r\n\r\n'
    '--fixture\r\nContent-Type: text/html\r\nContent-Location: https://reader.test/\r\n\r\n'
    '<html>Unrelated private document</html>\r\n'
    '${images.entries.map((e) => '--fixture\r\nContent-Type: image/png\r\n'
        'Content-Location: ${e.key}\r\nContent-Transfer-Encoding: base64\r\n\r\n'
        '${base64Encode(e.value).replaceAllMapped(RegExp(r'.{1,76}'), (m) => '${m[0]}\r\n')}').join()}'
    '--fixture--\r\n';

Future<void> waitDeleted(FileSystemEntity entity) async {
  for (var i = 0; i < 100 && await entity.exists(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  expect(await entity.exists(), isFalse);
}
