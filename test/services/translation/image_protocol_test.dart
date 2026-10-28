import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/image_work.dart';
import 'package:mangayomi/services/translation/channels/nodelane/http.dart';
import 'package:mangayomi/services/translation/source_file.dart';

void main() {
  test(
    'EXIF orientation is baked into frozen PNG bytes and descriptor',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'nodelane-orientation-',
      );
      try {
        final image = img.Image(width: 12, height: 8, numChannels: 3);
        image.exif.imageIfd.orientation = 6;
        final file = await File('${directory.path}/rotated.jpg')
            .writeAsBytes(img.encodeJpg(image));
        final prepared = await TranslationImageWork(directory)
            .prepare(file, TranslationCancellation());
        expect(prepared.mime, 'image/png');
        expect((prepared.width, prepared.height), (8, 12));
        expect(prepared.sha256, await imageDigest(prepared.file));
        expect((await readImageHeader(prepared.file)).mime, 'image/png');
      } finally {
        await directory.delete(recursive: true);
      }
    },
  );
  test(
    'SSE fragmented multiline data and keepalive comments retain event framing',
    () async {
      final values = await decodeTranslationEvents(
        Stream.fromIterable([
          'event: sna',
          'pshot\r\n: heartbeat\r\ndata: {"items":\r\n',
          'data: []}\r\n\r\nevent: end\ndata: {}\n\n',
        ]),
      ).toList();
      expect(values, [
        {'items': []},
      ]);
      await expectLater(
        decodeTranslationEvents(Stream.value('x' * (1024 * 1024 + 1))).toList(),
        throwsA(isA<TranslationFailure>()),
      );
    },
  );
  test('source-atop preserves original alpha and validates dimensions before decode', () async {
    final directory = await Directory.systemTemp.createTemp(
      'nodelane-composite-',
    );
    try {
      final base = img.Image(width: 2, height: 1, numChannels: 4)
        ..setPixelRgba(0, 0, 100, 100, 100, 128)
        ..setPixelRgba(1, 0, 20, 40, 60, 0);
      final overlay = img.Image(width: 2, height: 1, numChannels: 4)
        ..setPixelRgba(0, 0, 200, 0, 0, 128)
        ..setPixelRgba(1, 0, 255, 255, 255, 255);
      final input = await File('${directory.path}/input')
          .writeAsBytes(img.encodePng(base));
      final patch = await File('${directory.path}/patch')
          .writeAsBytes(img.encodePng(overlay));
      final work = TranslationImageWork(directory);
      final output = await work.composite(
        input: input,
        patch: patch,
        x: 0,
        y: 0,
        width: 2,
        height: 1,
        patchWidth: 2,
        patchHeight: 1,
        cancellation: TranslationCancellation(),
      );
      final decoded = img.decodePng(await output.readAsBytes())!;
      expect(decoded.getPixel(0, 0).a, 128);
      expect(decoded.getPixel(0, 0).r, closeTo(150, 1));
      expect(decoded.getPixel(1, 0).a, 0);
      await expectLater(
        work.composite(
          input: input,
          patch: patch,
          x: 0,
          y: 0,
          width: 1,
          height: 1,
          patchWidth: 1,
          patchHeight: 1,
          cancellation: TranslationCancellation(),
        ),
        throwsA(isA<TranslationFailure>()),
      );
    } finally {
      await directory.delete(recursive: true);
    }
  });
  test(
    'page-controlled source URLs cannot resolve to private or mapped addresses',
    () {
      for (final value in [
        '127.0.0.1',
        '10.1.2.3',
        '172.16.0.1',
        '192.168.2.1',
        '169.254.169.254',
        '100.64.0.1',
        '::1',
        '::ffff:127.0.0.1',
        'fe80::1',
        'fd00::1',
      ]) {
        expect(
          isPublicImageAddress(InternetAddress(value)),
          false,
          reason: value,
        );
      }
      expect(isPublicImageAddress(InternetAddress('8.8.8.8')), true);
    },
  );
}
