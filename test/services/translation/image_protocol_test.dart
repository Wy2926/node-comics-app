import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/image_work.dart';
import 'package:mangayomi/services/translation/channels/nodelane/http.dart';
import 'package:mangayomi/services/translation/source_file.dart';
// Use path_provider's existing platform seam, as in the other storage fixtures.
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _TemporaryPath extends PathProviderPlatform {
  _TemporaryPath(this.path);
  final String path;
  @override
  Future<String?> getTemporaryPath() async => path;
}

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
    'large and long originals retain their size without admission caps',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'nodelane-image-size-',
      );
      try {
        final work = TranslationImageWork(directory);
        for (final (width, height) in [(1801, 2400), (8, 20000)]) {
          final source = await File('${directory.path}/$width.png')
              .writeAsBytes(
                img.encodePng(
                  img.Image(width: width, height: height, numChannels: 3),
                ),
              );
          final prepared = await work.prepare(
            source,
            TranslationCancellation(),
          );
          expect((prepared.width, prepared.height), (width, height));
          expect(prepared.file.path, source.path);
          expect(prepared.sha256, await imageDigest(source));
          final patch = await File('${directory.path}/patch').writeAsBytes(
            img.encodePng(img.Image(width: 1, height: 1, numChannels: 4)),
          );
          final result = await work.composite(
            input: prepared.file,
            patch: patch,
            x: 0,
            y: 0,
            width: width,
            height: height,
            patchWidth: 1,
            patchHeight: 1,
            cancellation: TranslationCancellation(),
          );
          final header = await readImageHeader(result);
          expect((header.width, header.height), (width, height));
        }
      } finally {
        await directory.delete(recursive: true);
      }
    },
  );

  test(
    '16-bit PNG and animated GIF use decoder capability, not format bans',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'nodelane-image-formats-',
      );
      try {
        final highDepth = img.Image(
          width: 8,
          height: 6,
          format: img.Format.uint16,
          numChannels: 3,
        );
        final png = await File('${directory.path}/16.png')
            .writeAsBytes(img.encodePng(highDepth));
        final prepared = await TranslationImageWork(directory)
            .prepare(png, TranslationCancellation());
        expect((prepared.width, prepared.height), (8, 6));
        expect(prepared.sha256, await imageDigest(png));
        final animation = img.Image(width: 8, height: 6)
          ..setPixelRgb(0, 0, 255, 0, 0);
        animation.addFrame(
          img.Image(width: 8, height: 6)..setPixelRgb(0, 0, 0, 255, 0),
        );
        final gif = await File('${directory.path}/animation.gif')
            .writeAsBytes(img.encodeGif(animation));
        final frame = await TranslationImageWork(directory)
            .prepare(gif, TranslationCancellation());
        expect(frame.mime, 'image/png');
        expect(frame.sourceSha256, await imageDigest(gif));
        final decoded = img.decodePng(await frame.file.readAsBytes())!;
        expect(decoded.numFrames, 1);
        expect(decoded.getPixel(0, 0).r, 255);
        final invalid = await File('${directory.path}/invalid')
            .writeAsBytes([0, 1, 2]);
        await expectLater(
          TranslationImageWork(directory)
              .prepare(invalid, TranslationCancellation()),
          throwsA(
            isA<TranslationFailure>().having(
              (error) => error.code,
              'code',
              'INVALID_IMAGE',
            ),
          ),
        );
      } finally {
        await directory.delete(recursive: true);
      }
    },
  );

  test('local source transport streams over 32 MiB and follows more than five redirects', () async {
    final directory = await Directory.systemTemp.createTemp(
      'nodelane-source-http-',
    );
    final previousPaths = PathProviderPlatform.instance;
    final previousHttp = HttpOverrides.current;
    PathProviderPlatform.instance = _TemporaryPath(directory.path);
    HttpOverrides.global = null;
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    const length = 33 * 1024 * 1024;
    server.listen((request) async {
      final step = int.tryParse(request.uri.path.substring(1));
      if (request.uri.path == '/loop') {
        request.response.statusCode = 302;
        request.response.headers.set('location', '/loop');
      } else if (step != null && step < 7) {
        request.response.statusCode = 302;
        request.response.headers.set('location', '/${step + 1}');
      } else {
        request.response.contentLength = length;
        final chunk = Uint8List(64 * 1024);
        for (var at = 0; at < length; at += chunk.length) {
          request.response.add(chunk);
          await request.response.flush();
        }
      }
      await request.response.close();
    });
    final destinations = <String>[];
    HttpSourceImageReader source(String path) => HttpSourceImageReader(
      Uri.parse('http://127.0.0.1:${server.port}$path'),
      headers: (uri) async {
        destinations.add(uri.path);
        return {};
      },
    );
    try {
      final lease = await source(
        '/0',
      ).acquire(const TranslationPage('http', 'v1'), TranslationCancellation());
      expect(await lease.file.length(), length);
      expect(destinations, List.generate(8, (i) => '/$i'));
      lease.release();
      await expectLater(
        source('/loop').acquire(
          const TranslationPage('loop', 'v1'),
          TranslationCancellation(),
        ),
        throwsA(isA<TranslationFailure>()),
      );
    } finally {
      await server.close(force: true);
      PathProviderPlatform.instance = previousPaths;
      HttpOverrides.global = previousHttp;
      await directory.delete(recursive: true);
    }
  });
}
