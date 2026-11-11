import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:mangayomi/services/translation/channels/nodelane/overlay_tiles.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/image_work.dart';

import 'overlay_tiles_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  late File input, artifact;
  late String inputSha;
  const width = 8, height = 47974;
  final invalid = throwsA(
    isA<TranslationFailure>().having(
      (error) => error.code,
      'code',
      'INVALID_RESULT',
    ),
  );
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('nodelane-tiles-');
    final base = img.Image(width: width, height: height, numChannels: 4);
    img.fill(base, color: img.ColorRgba8(100, 100, 100, 128));
    base.setPixelRgba(1, 0, 20, 40, 60, 0);
    input = await File('${directory.path}/input.png')
        .writeAsBytes(img.encodePng(base));
    inputSha = await imageDigest(input);
    artifact = File('${directory.path}/tiles');
  });
  tearDown(() => directory.delete(recursive: true));

  Future<File> composite() async {
    final patches = await readOverlayTiles(
      artifact,
      inputSha: inputSha,
      width: width,
      height: height,
    );
    return TranslationImageWork(Directory('${directory.path}/work')).composite(
      input: input,
      patch: artifact,
      width: width,
      height: height,
      patchMime: 'image/webp',
      patches: patches,
      cancellation: TranslationCancellation(),
    );
  }

  test('lossless WebP tiles compose across a long canvas and preserve source alpha', () async {
    await artifact.writeAsBytes(
      tileContainer(tileManifest(inputSha, width, height)),
    );
    final output = img.decodePng(await (await composite()).readAsBytes())!;
    expect((output.width, output.height), (width, height));
    expect(output.getPixel(0, 0).r, closeTo(150, 1));
    expect(output.getPixel(0, 0).g, closeTo(50, 1));
    expect(output.getPixel(0, 0).a, 128);
    expect(output.getPixel(1, 0).a, 0);
    expect(output.getPixel(0, 1).g, 200);
    expect(output.getPixel(1, height - 1).b, 200);
    expect(output.getPixel(1, height - 1).a, 128);
    expect(output.getPixel(0, height ~/ 2).r, 100);
  });

  test(
    'tile parser rejects malformed identities, bounds, overlaps and framing',
    () async {
      final mutations = <void Function(Map<String, dynamic>)>[
        (m) => m['input_sha256'] = '0' * 64,
        (m) => m['format'] = 'overlay-v1',
        (m) => m['width'] = width.toDouble(),
        (m) => m['height'] = height + 1,
        (m) => m['tiles'] = [],
        (m) => m['tiles'] = List.filled(4097, m['tiles'][0]),
        (m) => m['tiles'][0]['x'] = -1,
        (m) => m['tiles'][0]['x'] = 0.0,
        (m) => m['tiles'][0]['width'] = 2049,
        (m) => m['tiles'][0]['height'] = 4097,
        (m) => m['tiles'][1]['y'] = height,
        (m) => m['tiles'][1]['y'] = 1,
        (m) => m['tiles'][0]['byte_size'] = 0,
        (m) => m['tiles'][0]['sha256'] = 'invalid',
      ];
      for (final mutate in mutations) {
        final manifest = tileManifest(inputSha, width, height);
        mutate(manifest);
        await artifact.writeAsBytes(tileContainer(manifest));
        await expectLater(
          readOverlayTiles(
            artifact,
            inputSha: inputSha,
            width: width,
            height: height,
          ),
          invalid,
        );
      }
      final valid = tileContainer(tileManifest(inputSha, width, height));
      for (final bytes in [
        valid.sublist(0, 8),
        valid.sublist(0, valid.length - 1),
        [...valid, 0],
        [0, ...valid.skip(1)],
        [...valid.take(8), 255, 255, 255, 127, ...valid.skip(12)],
      ]) {
        await artifact.writeAsBytes(bytes);
        await expectLater(
          readOverlayTiles(
            artifact,
            inputSha: inputSha,
            width: width,
            height: height,
          ),
          invalid,
        );
      }
    },
  );

  test('corrupt tile pixels never publish a partial canvas', () async {
    final png = img.encodePng(img.Image(width: 2, height: 2));
    for (final corruption in ['hash', 'dimensions', 'mime', 'decode']) {
      final manifest = tileManifest(inputSha, width, height);
      var bytes = tileWebp.toList();
      if (corruption == 'hash') manifest['tiles'][1]['sha256'] = '0' * 64;
      if (corruption == 'dimensions') manifest['tiles'][1]['width'] = 3;
      if (corruption == 'mime') bytes = png;
      if (corruption == 'decode') bytes = [0, 1, 2, 3];
      if (corruption == 'mime' || corruption == 'decode') {
        manifest['tiles'][1]['byte_size'] = bytes.length;
        manifest['tiles'][1]['sha256'] = sha256.convert(bytes).toString();
      }
      await artifact.writeAsBytes(
        tileContainer(manifest, body: [...tileWebp, ...bytes]),
      );
      await expectLater(composite(), invalid);
      expect(
        await Directory('${directory.path}/work').list().toList(),
        isEmpty,
      );
    }
  });
}
