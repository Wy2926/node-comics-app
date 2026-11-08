import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;
import 'package:mangayomi/repositories/db_write_queue.dart';

import 'contracts.dart';
import 'identity.dart';

const translationPixelBudget = 64 * 1024 * 1024;
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
  const ImageHeader(this.width, this.height, this.mime, {this.exif = false});
  final int width, height;
  final String mime;
  final bool exif;
}

Future<String> imageDigest(File file) async =>
    (await sha256.bind(file.openRead()).first).toString();

/// A bounded header probe before any decoder sees untrusted pixel dimensions.
/// ICC/animation are deliberately unsupported until native normalization has
/// fixtures; stripping their metadata would change the image's meaning.
Future<ImageHeader> readImageHeader(File file) async {
  final length = await file.length();
  final builder = BytesBuilder(copy: false);
  await for (final chunk in file.openRead(0, min(length, 1024 * 1024))) {
    builder.add(chunk);
  }
  final bytes = builder.takeBytes();
  final data = ByteData.sublistView(bytes);
  int be(int at) => data.getUint32(at);
  int le24(int at) => bytes[at] | (bytes[at + 1] << 8) | (bytes[at + 2] << 16);
  String tag(int at, int count) =>
      String.fromCharCodes(bytes.sublist(at, at + count));
  ImageHeader valid(int w, int h, String mime, {bool exif = false}) {
    if (w < 1 || h < 1 || w > 100000 || h > 100000) {
      throw const TranslationFailure('INVALID_IMAGE');
    }
    return ImageHeader(w, h, mime, exif: exif);
  }

  if (bytes.length >= 33 && tag(1, 3) == 'PNG' && bytes[0] == 137) {
    if (tag(12, 4) != 'IHDR') throw const TranslationFailure('INVALID_IMAGE');
    if (bytes[24] > 8) throw const TranslationFailure('UNSUPPORTED_IMAGE');
    var at = 8;
    var exif = false;
    while (at + 12 <= bytes.length) {
      final size = be(at), type = tag(at + 4, 4);
      if (type == 'iCCP' || type == 'acTL' || type == 'cICP') {
        throw const TranslationFailure('UNSUPPORTED_IMAGE');
      }
      if (type == 'gAMA' &&
          (size != 4 || at + 16 > bytes.length || be(at + 8) != 45455)) {
        throw const TranslationFailure('UNSUPPORTED_IMAGE');
      }
      if (type == 'eXIf') exif = true;
      if (type == 'IDAT') return valid(be(16), be(20), 'image/png', exif: exif);
      at += size + 12;
    }
    throw const TranslationFailure('INVALID_IMAGE');
  }
  if (bytes.length >= 4 && bytes[0] == 255 && bytes[1] == 216) {
    var at = 2, width = 0, height = 0;
    var exif = false;
    while (at + 4 <= bytes.length) {
      if (bytes[at++] != 255) throw const TranslationFailure('INVALID_IMAGE');
      while (at < bytes.length && bytes[at] == 255) {
        at++;
      }
      if (at + 2 >= bytes.length) break;
      final marker = bytes[at++];
      if (marker == 218) return valid(width, height, 'image/jpeg', exif: exif);
      final size = data.getUint16(at);
      if (size < 2 || at + size > bytes.length) break;
      if (marker == 225 && size >= 8 && tag(at + 2, 4) == 'Exif') exif = true;
      if (marker == 226 && size >= 14 && tag(at + 2, 11) == 'ICC_PROFILE') {
        throw const TranslationFailure('UNSUPPORTED_IMAGE');
      }
      if (const {192, 193, 194}.contains(marker) && size >= 8) {
        if (bytes[at + 2] != 8) {
          throw const TranslationFailure('UNSUPPORTED_IMAGE');
        }
        height = data.getUint16(at + 3);
        width = data.getUint16(at + 5);
        if (bytes[at + 7] != 1 && bytes[at + 7] != 3) {
          throw const TranslationFailure('UNSUPPORTED_IMAGE');
        }
      }
      at += size;
    }
    throw const TranslationFailure('INVALID_IMAGE');
  }
  if (bytes.length >= 30 && tag(0, 4) == 'RIFF' && tag(8, 4) == 'WEBP') {
    final type = tag(12, 4);
    if (type == 'VP8X') {
      final flags = bytes[20];
      if ((flags & 0x22) != 0) {
        throw const TranslationFailure('UNSUPPORTED_IMAGE');
      }
      return valid(
        1 + le24(24),
        1 + le24(27),
        'image/webp',
        exif: (flags & 8) != 0,
      );
    }
    if (type == 'VP8 ' &&
        bytes[23] == 157 &&
        bytes[24] == 1 &&
        bytes[25] == 42) {
      return valid(
        data.getUint16(26, Endian.little) & 0x3fff,
        data.getUint16(28, Endian.little) & 0x3fff,
        'image/webp',
      );
    }
    if (type == 'VP8L' && bytes[20] == 47) {
      final bits = data.getUint32(21, Endian.little);
      return valid(
        (bits & 0x3fff) + 1,
        ((bits >> 14) & 0x3fff) + 1,
        'image/webp',
      );
    }
  }
  throw const TranslationFailure('UNSUPPORTED_IMAGE');
}

/// One queue for input and composition, shared by all readers and tabs.
class TranslationImageWork {
  TranslationImageWork(this.temporary);
  final Directory temporary;
  final _queue = DbWriteQueue();

  Future<PreparedTranslationImage> prepare(
    File original,
    TranslationCancellation cancel,
  ) => _queue.run(() async {
    cancel.check();
    await temporary.create(recursive: true);
    final path = '${temporary.path}/${translationUuid()}.png';
    final sourcePath = original.path;
    final result = await _prepareInWorker(sourcePath, path);
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
    required int x,
    required int y,
    required int width,
    required int height,
    required int patchWidth,
    required int patchHeight,
    required TranslationCancellation cancellation,
  }) => _queue.run(() async {
    cancellation.check();
    await temporary.create(recursive: true);
    final output = '${temporary.path}/${translationUuid()}.png';
    final args = <String, Object>{
      'input': input.path,
      'patch': patch.path,
      'output': output,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'patchWidth': patchWidth,
      'patchHeight': patchHeight,
    };
    try {
      await _compositeInWorker(args);
      cancellation.check();
      return File(output);
    } catch (_) {
      await File(output).delete().catchError((_) => File(output));
      rethrow;
    }
  });
}

// These top-level wrappers ensure the isolate closure cannot capture the
// scheduler's Future tail or the caller's cancellation listeners.
Future<Map<String, Object>> _prepareInWorker(String input, String output) =>
    Isolate.run(() => _prepare(input, output));
Future<void> _compositeInWorker(Map<String, Object> args) =>
    Isolate.run(() => _composite(args));

Future<Map<String, Object>> _prepare(String sourcePath, String output) async {
  final file = File(sourcePath);
  final header = await readImageHeader(file);
  final size = await file.length();
  // Includes encoded input and three possible pixel buffers. The existing
  // reader's decode cache is separate and must be measured on devices too.
  if (size * 4 + header.width * header.height * 24 > translationPixelBudget) {
    throw const TranslationFailure('RESOURCE_LIMIT');
  }
  if (max(header.width, header.height) > 16383) {
    throw const TranslationFailure('UNSUPPORTED_IMAGE');
  }
  final sourceSha = await imageDigest(file);
  var decoded = img.decodeImage(await file.readAsBytes());
  if (decoded == null ||
      decoded.numFrames != 1 ||
      !((decoded.width == header.width && decoded.height == header.height) ||
          (header.exif &&
              decoded.width == header.height &&
              decoded.height == header.width))) {
    throw const TranslationFailure('INVALID_IMAGE');
  }
  var actual = file,
      mime = header.mime,
      width = header.width,
      height = header.height;
  if (header.exif || min(width, height) > 1800) {
    decoded = img.bakeOrientation(decoded);
    if (min(decoded.width, decoded.height) > 1800) {
      final scale = 1800 / min(decoded.width, decoded.height);
      decoded = img.copyResize(
        decoded,
        width: (decoded.width * scale).round(),
        height: (decoded.height * scale).round(),
        interpolation: img.Interpolation.average,
      );
    }
    width = decoded.width;
    height = decoded.height;
    actual = await File(output)
        .writeAsBytes(img.encodePng(decoded), flush: true);
    mime = 'image/png';
  }
  return {
    'path': actual.path,
    'sha256': await imageDigest(actual),
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
  final pw = args['patchWidth'] as int, ph = args['patchHeight'] as int;
  final x = args['x'] as int, y = args['y'] as int;
  final inputHeader = await readImageHeader(input),
      patchHeader = await readImageHeader(patch);
  if (inputHeader.width != width ||
      inputHeader.height != height ||
      patchHeader.width != pw ||
      patchHeader.height != ph) {
    throw const TranslationFailure('INVALID_RESULT');
  }
  if (width * height * 12 +
          pw * ph * 8 +
          (await input.length()) * 2 +
          (await patch.length()) * 2 >
      translationPixelBudget) {
    throw const TranslationFailure('RESOURCE_LIMIT');
  }
  final base = img
      .decodeImage(await input.readAsBytes())
      ?.convert(numChannels: 4, format: img.Format.uint8);
  final overlay = img.decodeImage(await patch.readAsBytes());
  if (base == null ||
      overlay == null ||
      base.width != width ||
      base.height != height ||
      overlay.width != pw ||
      overlay.height != ph ||
      base.numFrames != 1 ||
      overlay.numFrames != 1 ||
      x < 0 ||
      y < 0 ||
      x + pw > width ||
      y + ph > height) {
    throw const TranslationFailure('INVALID_RESULT');
  }
  // source-atop in straight-alpha storage: output alpha is the original's.
  // A transparent destination must stay transparent, including its RGB.
  for (var row = 0; row < ph; row++) {
    for (var col = 0; col < pw; col++) {
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
  await File(args['output'] as String)
      .writeAsBytes(img.encodePng(base), flush: true);
}
