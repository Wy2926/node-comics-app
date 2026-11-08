import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Use path_provider's existing platform seam in the test fixture.
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/storage_usage.dart';
import 'package:mangayomi/utils/cached_network.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory root;
  late PathProviderPlatform paths;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('nodelane-image-cache-');
    paths = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _Paths(root.path);
  });
  tearDown(() async {
    PathProviderPlatform.instance = paths;
    await root.delete(recursive: true);
  });

  test('cover cleanup is repeatable and leaves icons, chapters, translation and downloads alone', () async {
    for (final directory in [
      'cacheimagecover',
      'cacheimage',
      'cacheimagemanga',
      'chapter_disk_cache',
      'downloads',
      'nodelaneTranslation',
    ]) {
      final file = File('${root.path}/$directory/keep');
      await file.create(recursive: true);
      await file.writeAsString('fixture');
    }
    await clearCoverImageCache();
    await clearCoverImageCache();
    expect(Directory('${root.path}/cacheimagecover').existsSync(), isFalse);
    for (final directory in [
      'cacheimage',
      'cacheimagemanga',
      'chapter_disk_cache',
      'downloads',
      'nodelaneTranslation',
    ]) {
      expect(
        File('${root.path}/$directory/keep').readAsStringSync(),
        'fixture',
      );
    }
  });

  group('website icon disk cache', () {
    final png = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aX1cAAAAASUVORK5CYII=',
    );
    late HttpServer server;
    late HttpOverrides? overrides;
    late Map<String, int> requests;
    late Set<String> failing;

    String url(String path) => 'http://127.0.0.1:${server.port}/$path.png';
    ExtendedNetworkImageProvider icon(String path) =>
        (cachedNetworkImage(
              imageUrl: url(path),
              width: 40,
              height: 40,
              fit: BoxFit.contain,
              useCustomNetworkImage: false,
            ) as ExtendedImage).image
            as ExtendedNetworkImageProvider;

    setUp(() async {
      overrides = HttpOverrides.current;
      HttpOverrides.global = null;
      requests = {};
      failing = {};
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        final path = request.uri.path;
        requests.update(path, (count) => count + 1, ifAbsent: () => 1);
        if (failing.contains(path)) {
          request.response.statusCode = HttpStatus.serviceUnavailable;
        } else {
          request.response.headers.contentType = ContentType('image', 'png');
          request.response.add(png);
        }
        await request.response.close();
      });
    });
    tearDown(() async {
      await server.close(force: true);
      HttpOverrides.global = overrides;
    });

    test('reuses disk across provider instances, expires after 30 days and isolates URLs', () async {
      expect(await icon('first').getNetworkImageData(), png);
      expect(requests['/first.png'], 1);
      final file = (await getCachedImageFile(url('first')))!;
      expect(await file.readAsBytes(), png);

      Future<void> readAtAge(int days) async {
        final parentZone = Zone.current;
        await IOOverrides.runZoned(
          () async => expect(await icon('first').getNetworkImageData(), png),
          statSync: (path) => path == file.path
              ? _CacheAge(Duration(days: days))
              : parentZone.run(() => FileStat.statSync(path)),
        );
      }

      failing.add('/first.png');
      await readAtAge(29);
      expect(requests['/first.png'], 1);
      failing.clear();

      expect(await icon('second').getNetworkImageData(), png);
      final second = (await getCachedImageFile(url('second')))!;
      expect(second.path, isNot(file.path));

      await readAtAge(31);
      expect(requests['/first.png'], 2);
      expect(await icon('second').getNetworkImageData(), png);
      expect(requests['/second.png'], 1);
      expect(await icon('first').getNetworkImageData(), png);
      expect(requests['/first.png'], 2);
    });

    test('HTTP failure does not persist a failure and can recover', () async {
      failing.add('/missing.png');
      expect(await icon('missing').getNetworkImageData(), isNull);
      expect(await getCachedImageFile(url('missing')), isNull);
      final failedRequests = requests['/missing.png']!;
      failing.clear();
      expect(await icon('missing').getNetworkImageData(), png);
      expect(requests['/missing.png'], failedRequests + 1);
      expect(await icon('missing').getNetworkImageData(), png);
      expect(requests['/missing.png'], failedRequests + 1);
    });
  });
}

class _Paths extends PathProviderPlatform {
  _Paths(this.path);
  final String path;
  @override
  Future<String?> getApplicationCachePath() async => path;
  @override
  Future<String?> getTemporaryPath() async => path;
}

// Only age is simulated; HTTP and disk reads/writes use the real implementation.
class _CacheAge extends Fake implements FileStat {
  _CacheAge(Duration age) : changed = DateTime.now().subtract(age);
  @override
  final DateTime changed;
}
