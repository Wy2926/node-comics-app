import 'dart:typed_data';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source_image_processing.dart';
import 'package:mangayomi/services/source_images/tile_shuffle.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';

void main() {
  final spec = SourceImageProcessing.fromJson({
    'type': 'tile-shuffle-v1',
    'algorithm': 3,
    'seedMasks': {'03632': 58414, '02900': 117532},
  });
  final headers = {
    'X-Scramble-Algo': '3',
    'X-Scramble-Grid': '3x2',
    'X-Scramble-Seed': '42',
  };
  Uint8List fixture() {
    final image = img.Image(width: 7, height: 5, numChannels: 4);
    for (var y = 0; y < 5; y++) {
      for (var x = 0; x < 7; x++) {
        image.setPixelRgba(
          x,
          y,
          x == 6 || y == 4 ? 99 : (y ~/ 2 * 3 + x ~/ 2) * 30,
          y,
          x,
          255,
        );
      }
    }
    return Uint8List.fromList(img.encodePng(image));
  }

  test(
    'known permutation vectors and pixel output preserve edge pixels and alpha',
    () {
      expect(sourceTileOrder(42, 6), [0, 1, 4, 2, 5, 3]);
      expect(sourceTileOrder(42 ^ 58414, 6), [5, 2, 4, 0, 3, 1]);
      expect(sourceTileOrder(42 ^ 117532, 6), [1, 0, 3, 5, 4, 2]);
      final restored = img.decodePng(
        restoreSourceImage(fixture(), headers, spec),
      )!;
      // Destination tiles contain source [0, 1, 3, 5, 2, 4].
      for (var to = 0; to < 6; to++) {
        final pixel = restored.getPixel(to % 3 * 2, to ~/ 3 * 2);
        expect(pixel.r, [0, 30, 90, 150, 60, 120][to]);
        expect(pixel.a, 255);
      }
      expect(restored.getPixel(6, 0).r, 99);
      expect(restored.getPixel(0, 4).r, 99);
      expect(restored.getPixel(6, 4).r, 99);
    },
  );
  test('unknown protocols, invalid grids, oversized responses and invalid images fail', () async {
    for (final extra in [
      {'X-Scramble-Algo': '9'},
      {'X-Scramble-Grid': '30x30'},
      {'X-Scramble-Seed': '4294967296'},
      {'X-Scramble-Seed': '-1'},
    ]) {
      expect(
        () => restoreSourceImage(fixture(), {...headers, ...extra}, spec),
        throwsStateError,
      );
    }
    expect(
      () => restoreSourceImage(Uint8List.fromList([1, 2, 3]), headers, spec),
      throwsStateError,
    );
    await expectLater(
      readBoundedSourceImage(
        http.StreamedResponse(
          Stream.value([1]),
          200,
          contentLength: sourceImageMaxBytes + 1,
        ),
      ),
      throwsStateError,
    );
    expect(
      () => SourceImageProcessing.fromJson({'type': 'arbitrary-js'}),
      throwsStateError,
    );
  });
  test(
    'page serialization and cache identity keep restored and plain bytes apart',
    () {
      final page = PageUrl(
        'https://image.test/page',
        imageProcessing: spec,
        headers: {'Referer': ''},
      );
      final restored = PageUrl.fromJson(page.toJson());
      expect(restored.imageProcessing!.toJson(), spec.toJson());
      final a = CustomExtendedNetworkImageProvider(
        page.url,
        imageProcessing: spec,
      );
      final b = CustomExtendedNetworkImageProvider(page.url);
      expect(a.cacheKey, spec.cacheKey(page.url));
      expect(a == b, isFalse);
    },
  );
  test(
    'background failure or cancellation releases the queue for retry',
    () async {
      await expectLater(
        restoreSourceImageInBackground(
          fixture(),
          headers,
          spec,
          checkCancelled: () => throw StateError('cancelled'),
        ),
        throwsStateError,
      );
      await expectLater(
        restoreSourceImageInBackground(Uint8List(0), headers, spec),
        throwsStateError,
      );
      final restored = await restoreSourceImageInBackground(
        fixture(),
        headers,
        spec,
      );
      expect(img.decodePng(restored)?.width, 7);
    },
  );
  test('reader HTTP image path returns restored pixels and can retry a bad response', () async {
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() async {
      await server.close(force: true);
      HttpOverrides.global = overrides;
    });
    var valid = false;
    server.listen((request) async {
      for (final entry in headers.entries) {
        request.response.headers.set(entry.key, entry.value);
      }
      request.response.headers.contentType = ContentType('image', 'png');
      request.response.add(valid ? fixture() : [1, 2, 3]);
      await request.response.close();
    });
    final provider = CustomExtendedNetworkImageProvider(
      'http://127.0.0.1:${server.port}/fixture.png',
      cache: false,
      retries: 1,
      imageProcessing: spec,
    );
    await expectLater(provider.getNetworkImageData(), throwsStateError);
    valid = true;
    final restored = img.decodePng((await provider.getNetworkImageData())!)!;
    expect(restored.width, 7);
    expect(restored.getPixel(0, 2).r, 150);
    expect(restored.getPixel(6, 4).r, 99);
  });
}
