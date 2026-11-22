import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show MethodChannel;
import 'package:image/image.dart' as img;
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/utils/avif.dart';

import 'contracts.dart';
import 'identity.dart';

const legacyTranslationInputProfile = 'mobile-short-edge-1800-png-v1';
const translationInputProfile = 'mobile-short-edge-1800-webp90-jpeg30-v2';
const translationEncoderVersion = 'image-4.10.1';
const _shortEdge = 1800, _reencodeBytes = 1024 * 1024, _jpegMaxEdge = 65500;
const webpMaxEdge = 16383;

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

/// Drawing applies the embedded profile; encoding the decoded frame directly
/// can preserve both the original channel values and its ICC profile.
Future<Uint8List> _srgbPng(ui.Image frame, int width, int height) async {
  if (frame.width != width || frame.height != height) {
    throw const TranslationFailure('INVALID_IMAGE');
  }
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder).drawImage(frame, ui.Offset.zero, ui.Paint());
  final picture = recorder.endRecording();
  try {
    final image = await picture.toImage(frame.width, frame.height);
    try {
      if (image.width != width || image.height != height) {
        throw const TranslationFailure('INVALID_IMAGE');
      }
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) throw const TranslationFailure('INVALID_IMAGE');
      return Uint8List.sublistView(data);
    } finally {
      image.dispose();
    }
  } finally {
    picture.dispose();
  }
}

Future<int> _normalizeNative(
  File original,
  String path,
  _NeedsNativePixels input,
) async {
  if (input.orientation != null && (Platform.isAndroid || Platform.isIOS)) {
    // Software bitmaps do not silently resize long manga pages to a GPU texture.
    final converted = await const MethodChannel(
      'nodelane/translation_image',
    ).invokeMethod<bool>('srgbPng', {'source': original.path, 'output': path});
    if (converted == true) return input.orientation!;
  }
  var bytes = await original.readAsBytes();
  // Platform codecs disagree on PNG/WebP EXIF. Remove that chunk
  // from this private decode buffer and apply its orientation exactly once.
  final chunk = input.exifChunk;
  if (chunk != null) {
    final length = bytes.length - (chunk.end - chunk.start);
    bytes.setRange(chunk.start, length, bytes, chunk.end);
    bytes = Uint8List.sublistView(bytes, 0, length);
    final header = ByteData.sublistView(bytes);
    if (header.getUint32(0) == 0x52494646) {
      // RIFF
      header.setUint32(4, length - 8, Endian.little);
      if (header.getUint32(12) == 0x56503858) {
        bytes[20] &= ~0x08; // VP8X EXIF flag
      }
    }
  }
  Uint8List png;
  try {
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    late int width, height;
    final codec = await ui.instantiateImageCodecWithSize(
      buffer,
      getTargetSize: (w, h) {
        width = w;
        height = h;
        return const ui.TargetImageSize();
      },
    );
    try {
      final frame = (await codec.getNextFrame()).image;
      try {
        if (input.orientation == null) {
          // Keep already normalized platform PNGs byte-identical for frozen receipts.
          final data = await frame.toByteData(format: ui.ImageByteFormat.png);
          if (data == null) throw const TranslationFailure('INVALID_IMAGE');
          png = Uint8List.sublistView(data);
          final info = img.PngDecoder().startDecode(png);
          if (info is img.PngInfo && info.iccpData != null) {
            png = await _srgbPng(frame, width, height);
          }
        } else {
          png = await _srgbPng(frame, width, height);
        }
      } finally {
        frame.dispose();
      }
    } finally {
      codec.dispose();
    }
  } catch (_) {
    if (!isAvifImage(bytes)) rethrow;
    png = await decodeAvifToPng(bytes);
  }
  await File(path).writeAsBytes(png, flush: true);
  return chunk?.orientation ?? 1;
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
    String inputProfile = translationInputProfile,
  }) => _queue.run(() async {
    cancel.check();
    final compress = switch (inputProfile) {
      translationInputProfile => true,
      legacyTranslationInputProfile => false,
      _ => throw const TranslationFailure('CLIENT_UPGRADE_REQUIRED'),
    };
    await temporary.create(recursive: true);
    final path = '${temporary.path}/${translationUuid()}.input';
    final sourcePath = original.path;
    late Map<String, Object> result;
    try {
      try {
        result = await _prepareInWorker(sourcePath, path, sourceSha, compress);
      } on _NeedsNativePixels catch (input) {
        cancel.check();
        final orientation = await _normalizeNative(original, path, input);
        cancel.check();
        result = await _prepareInWorker(
          path,
          path,
          null,
          compress,
          orientation: orientation,
          avif: input.avif,
        );
        result['sourceSha256'] = sourceSha ?? await imageDigest(original);
      }
    } catch (error) {
      await File(path).delete().catchError((_) => File(path));
      if (error is TranslationFailure ||
          error is TranslationCancelled ||
          error is FileSystemException) {
        rethrow;
      }
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
  bool compress, {
  int? orientation,
  bool avif = false,
}) => Isolate.run(
  () => _prepare(input, output, sourceSha, compress, orientation, avif),
);
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

class _NeedsNativePixels implements Exception {
  const _NeedsNativePixels({
    this.orientation,
    this.exifChunk,
    this.avif = false,
  });
  final int? orientation;
  final _ExifChunk? exifChunk;
  final bool avif;
}

typedef _ExifChunk = ({int start, int end, int orientation});

// package:image ignores PNG eXIf and some WebP encoders prefix their TIFF with "Exif\0\0".
_ExifChunk? _exifChunk(Uint8List bytes, {required bool webp}) {
  final data = ByteData.sublistView(bytes);
  for (var at = webp ? 12 : 8; at + 8 <= bytes.length;) {
    final size = webp
        ? data.getUint32(at + 4, Endian.little)
        : data.getUint32(at);
    final end = at + 8 + size + (webp ? size & 1 : 4);
    if (end > bytes.length) throw const TranslationFailure('INVALID_IMAGE');
    if (webp
        ? data.getUint32(at) == 0x45584946
        : data.getUint32(at + 4) == 0x65584966) {
      return (
        start: at,
        end: end,
        orientation: _exifOrientation(
          ByteData.sublistView(bytes, at + 8, at + 8 + size),
        ),
      ); // EXIF / eXIf
    }
    at = end;
  }
  return null;
}

int _exifOrientation(ByteData data) {
  const invalid = TranslationFailure('INVALID_IMAGE');
  final start =
      data.lengthInBytes >= 6 &&
          data.getUint32(0) == 0x45786966 &&
          data.getUint16(4) == 0
      ? 6
      : 0;
  if (data.lengthInBytes < start + 8) throw invalid;
  final endian = switch (data.getUint16(start)) {
    0x4949 => Endian.little,
    0x4d4d => Endian.big,
    _ => throw invalid,
  };
  final dir = start + data.getUint32(start + 4, endian);
  if (data.getUint16(start + 2, endian) != 42 ||
      dir < start + 8 ||
      dir + 2 > data.lengthInBytes) {
    throw invalid;
  }
  final end = dir + 2 + data.getUint16(dir, endian) * 12;
  if (end + 4 > data.lengthInBytes) throw invalid;
  for (var at = dir + 2; at < end; at += 12) {
    if (data.getUint16(at, endian) != 274) continue;
    final orientation = data.getUint16(at + 8, endian);
    if (data.getUint16(at + 2, endian) != 3 ||
        data.getUint32(at + 4, endian) != 1 ||
        orientation < 1 ||
        orientation > 8) {
      throw invalid;
    }
    return orientation;
  }
  return 1;
}

({Uint8List bytes, String mime}) _lossyInput(img.Image pixels) {
  pixels.exif = img.ExifData();
  pixels.iccProfile = null;
  if (math.max(pixels.width, pixels.height) <= webpMaxEdge) {
    return (
      bytes: img.encodeWebP(
        pixels,
        lossless: false,
        quality: 90,
        singleFrame: true,
      ),
      mime: 'image/webp',
    );
  }
  if (pixels.hasAlpha) {
    // JPEG has no alpha; composite once on white, including partially transparent edges.
    final white = img.Image(width: pixels.width, height: pixels.height)
      ..clear(img.ColorRgb8(255, 255, 255));
    pixels = img.compositeImage(white, pixels);
  }
  return (
    bytes: img.encodeJpg(pixels, quality: 30, chroma: img.JpegChroma.yuv420),
    mime: 'image/jpeg',
  );
}

Future<Map<String, Object>> _prepare(
  String sourcePath,
  String output,
  String? knownSha,
  bool compress,
  int? nativeOrientation,
  bool avif,
) async {
  final file = File(sourcePath);
  final bytes = await file.readAsBytes();
  final decoder = img.findDecoderForData(bytes);
  if (decoder == null) throw _NeedsNativePixels(avif: isAvifImage(bytes));
  final info = decoder.startDecode(bytes);
  if (info == null) throw const TranslationFailure('INVALID_IMAGE');
  final chunk =
      nativeOrientation == null &&
          (info is img.PngInfo || info is img.WebPInfo && info.exif.isNotEmpty)
      ? _exifChunk(bytes, webp: info is img.WebPInfo)
      : null;
  final orientation = nativeOrientation ?? chunk?.orientation ?? 1;
  if (nativeOrientation == null &&
      (info is img.PngInfo && info.iccpData != null ||
          info is img.WebPInfo && info.iccp != null)) {
    throw _NeedsNativePixels(
      orientation: orientation,
      exifChunk: orientation == 1 ? null : chunk,
    );
  }
  final decoded = decoder.decodeFrame(0);
  if (decoded == null || decoded.width <= 0 || decoded.height <= 0) {
    throw const TranslationFailure('INVALID_IMAGE');
  }
  if (orientation != 1) decoded.exif.imageIfd.orientation = orientation;
  final jpegExif = decoder is img.JpegDecoder ? img.decodeJpgExif(bytes) : null;
  if (nativeOrientation == null && decoded.iccProfile != null) {
    throw _NeedsNativePixels(
      orientation:
          jpegExif?.imageIfd.orientation ??
          decoded.exif.imageIfd.orientation ??
          1,
    );
  }
  final sourceSha = knownSha ?? sha256.convert(bytes).toString();
  var upload = (bytes: bytes, mime: _mime(decoder));
  var pixels = decoded;
  // JPEG decoding already bakes orientation and clears its EXIF orientation.
  // Freeze those normalized pixels, rather than uploading the old byte layout.
  final hasExif = jpegExif != null || !decoded.exif.isEmpty;
  final normalize =
      hasExif ||
      decoded.iccProfile != null ||
      info.numFrames > 1 ||
      !const {'image/png', 'image/jpeg', 'image/webp'}.contains(upload.mime);
  if (normalize) {
    pixels = img.bakeOrientation(decoded).convert(format: img.Format.uint8)
      ..iccProfile = null;
  }
  final short = math.min(pixels.width, pixels.height);
  final resize = compress && short > _shortEdge;
  if (resize) {
    if (pixels.hasPalette) pixels = pixels.convert();
    pixels = img.copyResize(
      pixels,
      width: (pixels.width * _shortEdge / short).round(),
      height: (pixels.height * _shortEdge / short).round(),
      interpolation: img.Interpolation.average,
    );
  }
  final encodable = math.max(pixels.width, pixels.height) <= _jpegMaxEdge;
  if (compress && encodable && (resize || avif)) {
    upload = _lossyInput(pixels);
  } else {
    if (normalize || resize) {
      upload = (bytes: img.encodePng(pixels), mime: 'image/png');
    }
    if (compress && encodable && upload.bytes.length > _reencodeBytes) {
      try {
        final candidate = _lossyInput(pixels);
        if (candidate.bytes.length < upload.bytes.length) upload = candidate;
      } on img.ImageException {
        // An optional encoder failure must not reject an already valid input.
      }
    }
  }
  final changed = !identical(upload.bytes, bytes);
  if (changed) await File(output).writeAsBytes(upload.bytes, flush: true);
  return {
    'path': changed ? output : sourcePath,
    'sha256': changed ? sha256.convert(upload.bytes).toString() : sourceSha,
    'sourceSha256': sourceSha,
    'width': pixels.width,
    'height': pixels.height,
    'byteSize': upload.bytes.length,
    'mime': upload.mime,
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
