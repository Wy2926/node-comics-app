import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/utils/avif.dart';

import 'contracts.dart';
import 'identity.dart';

// Persisted protocol tag: keep existing operations readable and recoverable.
const translationInputProfile = 'mobile-short-edge-1800-png-v1';
const translationEncoderVersion = 'image-4.10.1';

class PreparedTranslationImage {
  const PreparedTranslationImage({
    required this.file,
    required this.sha256,
    required this.sourceSha256,
    required this.width,
    required this.height,
    required this.byteSize,
    required this.mime,
  });
  final File file;
  final String sha256;
  final String sourceSha256;
  final int width, height, byteSize;
  final String mime;
  Map<String, dynamic> get descriptor => {
    'sha256': sha256,
    'byte_size': byteSize,
    'content_type': mime,
    'normalization_version': 1,
  };
}

class ImageHeader {
  const ImageHeader(this.width, this.height, this.mime);
  final int width, height;
  final String mime;
}

/// One encoded image region in a downloaded artifact. Decode regions in order
/// while retaining only the output canvas and one region's pixels.
typedef TranslationImagePatch = ({
  int x,
  int y,
  int width,
  int height,
  int offset,
  int length,
  String sha256,
});

Future<String> imageDigest(File file) async =>
    (await sha256.bind(file.openRead()).first).toString();

String _mime(img.Decoder decoder) =>
    'image/${decoder.format == img.ImageFormat.jpg ? 'jpeg' : decoder.format.name}';

/// Use the installed decoder's capabilities, not a separate format whitelist.
Future<ImageHeader> readImageHeader(File file) async {
  final bytes = await file.readAsBytes();
  final decoder = img.findDecoderForData(bytes);
  final info = decoder?.startDecode(bytes);
  if (info == null || info.width <= 0 || info.height <= 0) {
    throw const TranslationFailure('INVALID_IMAGE');
  }
  return ImageHeader(info.width, info.height, _mime(decoder!));
}

/// Platform codecs cover formats (including device-supported AVIF) absent from
/// the Dart decoder. Animation is explicitly materialized as its first frame.
Future<void> _normalizeNative(File original, String path) async {
  final bytes = await original.readAsBytes();
  Uint8List png;
  try {
    final codec = await ui.instantiateImageCodec(bytes);
    try {
      final frame = await codec.getNextFrame();
      try {
        final data = await frame.image.toByteData(
          format: ui.ImageByteFormat.png,
        );
        if (data == null) throw const TranslationFailure('INVALID_IMAGE');
        png = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      } finally {
        frame.image.dispose();
      }
    } finally {
      codec.dispose();
    }
  } catch (_) {
    if (!isAvifImage(bytes)) rethrow;
    png = await decodeAvifToPng(bytes);
  }
  await File(path).writeAsBytes(png, flush: true);
}

/// One queue for input and composition, shared by all readers and tabs.
class TranslationImageWork {
  TranslationImageWork(this.temporary);
  final Directory temporary;
  final _queue = DbWriteQueue();

  Future<PreparedTranslationImage> prepare(
    File original,
    TranslationCancellation cancel, {
    String? sourceSha,
  }) => _queue.run(() async {
    cancel.check();
    await temporary.create(recursive: true);
    final path = '${temporary.path}/${translationUuid()}.png';
    final sourcePath = original.path;
    late Map<String, Object> result;
    try {
      try {
        result = await _prepareInWorker(sourcePath, path, sourceSha);
      } on TranslationFailure catch (error) {
        if (error.code != 'UNSUPPORTED_IMAGE') rethrow;
        cancel.check();
        await _normalizeNative(original, path);
        cancel.check();
        result = await _prepareInWorker(path, path, null);
        result['sourceSha256'] = sourceSha ?? await imageDigest(original);
      }
    } catch (error) {
      await File(path).delete().catchError((_) => File(path));
      if (error is TranslationFailure || error is FileSystemException) rethrow;
      throw const TranslationFailure('INVALID_IMAGE');
    }
    if (cancel.isCancelled) {
      await File(path).delete().catchError((_) => File(path));
      cancel.check();
    }
    return PreparedTranslationImage(
      file: File(result['path'] as String),
      sha256: result['sha256'] as String,
      sourceSha256: result['sourceSha256'] as String,
      width: result['width'] as int,
      height: result['height'] as int,
      byteSize: result['byteSize'] as int,
      mime: result['mime'] as String,
    );
  });

  Future<File> composite({
    required File input,
    required File patch,
    required int width,
    required int height,
    required String patchMime,
    required List<TranslationImagePatch> patches,
    required TranslationCancellation cancellation,
  }) => _queue.run(() async {
    cancellation.check();
    await temporary.create(recursive: true);
    final output = '${temporary.path}/${translationUuid()}.png';
    final args = <String, Object>{
      'input': input.path,
      'patch': patch.path,
      'output': output,
      'width': width,
      'height': height,
      'patchMime': patchMime,
      'patches': patches,
    };
    try {
      await _compositeInWorker(args);
      cancellation.check();
      return File(output);
    } catch (error) {
      await File(output).delete().catchError((_) => File(output));
      if (error is TranslationFailure ||
          error is TranslationCancelled ||
          error is FileSystemException) {
        rethrow;
      }
      throw const TranslationFailure('INVALID_RESULT');
    }
  });

  /// Complete-image deliveries need no frozen input. Keep the shared reader /
  /// WebView output contract as a validated, single-frame PNG.
  Future<File> decodeResult(
    File artifact, {
    required int width,
    required int height,
    required String mime,
    required TranslationCancellation cancellation,
  }) => _queue.run(() async {
    cancellation.check();
    await temporary.create(recursive: true);
    final output = File('${temporary.path}/${translationUuid()}.png');
    try {
      await _decodeResultInWorker(
        artifact.path,
        output.path,
        width,
        height,
        mime,
      );
      cancellation.check();
      return output;
    } catch (error) {
      await output.delete().catchError((_) => output);
      if (error is TranslationFailure ||
          error is TranslationCancelled ||
          error is FileSystemException) {
        rethrow;
      }
      throw const TranslationFailure('INVALID_RESULT');
    }
  });
}

// These top-level wrappers ensure the isolate closure cannot capture the
// scheduler's Future tail or the caller's cancellation listeners.
Future<Map<String, Object>> _prepareInWorker(
  String input,
  String output,
  String? sourceSha,
) => Isolate.run(() => _prepare(input, output, sourceSha));
Future<void> _compositeInWorker(Map<String, Object> args) =>
    Isolate.run(() => _composite(args));

Future<void> _decodeResultInWorker(
  String path,
  String output,
  int width,
  int height,
  String mime,
) => Isolate.run(() async {
  final bytes = await File(path).readAsBytes();
  final decoder = img.findDecoderForData(bytes);
  final info = decoder?.startDecode(bytes);
  if (info == null || _mime(decoder!) != mime || info.numFrames > 1) {
    throw const TranslationFailure('INVALID_RESULT');
  }
  final image = decoder.decodeFrame(0);
  if (image == null ||
      image.numFrames != 1 ||
      image.width != width ||
      image.height != height) {
    throw const TranslationFailure('INVALID_RESULT');
  }
  await File(output).writeAsBytes(img.encodePng(image), flush: true);
});

Future<Map<String, Object>> _prepare(
  String sourcePath,
  String output,
  String? knownSha,
) async {
  final file = File(sourcePath);
  final bytes = await file.readAsBytes();
  final decoder = img.findDecoderForData(bytes);
  if (decoder == null) throw const TranslationFailure('UNSUPPORTED_IMAGE');
  final info = decoder.startDecode(bytes);
  final decoded = info == null ? null : decoder.decodeFrame(0);
  if (decoded == null || decoded.width <= 0 || decoded.height <= 0) {
    throw const TranslationFailure('INVALID_IMAGE');
  }
  final sourceSha = knownSha ?? await imageDigest(file);
  var actual = file, mime = _mime(decoder);
  var width = decoded.width, height = decoded.height;
  // JPEG decoding already bakes orientation and clears its EXIF orientation.
  // Freeze those normalized pixels, rather than uploading the old byte layout.
  final hasExif = decoder.format == img.ImageFormat.jpg
      ? img.decodeJpgExif(bytes) != null
      : !decoded.exif.isEmpty;
  if (hasExif ||
      info!.numFrames > 1 ||
      !const {'image/png', 'image/jpeg', 'image/webp'}.contains(mime)) {
    final normalized = img
        .bakeOrientation(decoded)
        .convert(format: img.Format.uint8);
    width = normalized.width;
    height = normalized.height;
    actual = await File(output)
        .writeAsBytes(img.encodePng(normalized), flush: true);
    mime = 'image/png';
  }
  return {
    'path': actual.path,
    'sha256': actual == file ? sourceSha : await imageDigest(actual),
    'sourceSha256': sourceSha,
    'width': width,
    'height': height,
    'byteSize': await actual.length(),
    'mime': mime,
  };
}

Future<void> _composite(Map<String, Object> args) async {
  final input = File(args['input'] as String),
      patch = File(args['patch'] as String);
  final width = args['width'] as int, height = args['height'] as int;
  final inputHeader = await readImageHeader(input);
  if (inputHeader.width != width || inputHeader.height != height) {
    throw const TranslationFailure('INVALID_RESULT');
  }
  final base = img
      .decodeImage(await input.readAsBytes())
      ?.convert(numChannels: 4, format: img.Format.uint8);
  if (base == null ||
      base.width != width ||
      base.height != height ||
      base.numFrames != 1) {
    throw const TranslationFailure('INVALID_RESULT');
  }
  final handle = await patch.open();
  try {
    final length = await handle.length();
    for (final region in args['patches'] as List<TranslationImagePatch>) {
      if (region.x < 0 ||
          region.y < 0 ||
          region.width < 1 ||
          region.height < 1 ||
          region.x + region.width > width ||
          region.y + region.height > height ||
          region.offset < 0 ||
          region.length < 1 ||
          region.offset + region.length > length) {
        throw const TranslationFailure('INVALID_RESULT');
      }
      await handle.setPosition(region.offset);
      final bytes = await handle.read(region.length);
      if (bytes.length != region.length ||
          sha256.convert(bytes).toString() != region.sha256) {
        throw const TranslationFailure('INVALID_RESULT');
      }
      final decoder = img.findDecoderForData(bytes);
      final info = decoder?.startDecode(bytes);
      if (info == null ||
          _mime(decoder!) != args['patchMime'] ||
          // The image decoder reports zero animation frames for static WebP.
          info.numFrames > 1 ||
          info.width != region.width ||
          info.height != region.height) {
        throw const TranslationFailure('INVALID_RESULT');
      }
      final overlay = decoder.decodeFrame(0);
      if (overlay == null ||
          overlay.numFrames != 1 ||
          overlay.width != region.width ||
          overlay.height != region.height) {
        throw const TranslationFailure('INVALID_RESULT');
      }
      _applyPatch(base, overlay, region.x, region.y);
    }
  } finally {
    await handle.close();
  }
  await File(args['output'] as String)
      .writeAsBytes(img.encodePng(base), flush: true);
}

void _applyPatch(img.Image base, img.Image overlay, int x, int y) {
  // source-atop in straight-alpha storage: output alpha is the original's.
  // A transparent destination must stay transparent, including its RGB.
  for (var row = 0; row < overlay.height; row++) {
    for (var col = 0; col < overlay.width; col++) {
      final a = overlay.getPixel(col, row), b = base.getPixel(x + col, y + row);
      final alpha = a.aNormalized;
      if (b.aNormalized == 0) {
        b.setRgba(0, 0, 0, 0);
        continue;
      }
      b.setRgba(
        (a.rNormalized * alpha + b.rNormalized * (1 - alpha)) *
            b.maxChannelValue,
        (a.gNormalized * alpha + b.gNormalized * (1 - alpha)) *
            b.maxChannelValue,
        (a.bNormalized * alpha + b.bNormalized * (1 - alpha)) *
            b.maxChannelValue,
        b.a,
      );
    }
  }
}
