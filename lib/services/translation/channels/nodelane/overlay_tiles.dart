import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../../contracts.dart';
import '../../image_work.dart';
import 'protocol.dart';

/// Parse the existing NCOT0001 contract without retaining encoded tile bodies.
Future<List<TranslationImagePatch>> readOverlayTiles(
  File file, {
  required String inputSha,
  required int width,
  required int height,
}) async {
  final handle = await file.open();
  try {
    final size = await handle.length();
    final header = await handle.read(12);
    if (header.length != 12 ||
        ascii.decode(header.sublist(0, 8)) != 'NCOT0001') {
      throw const FormatException();
    }
    final length = ByteData.sublistView(header).getUint32(8, Endian.little);
    if (length < 1 || length > 256 * 1024 || 12 + length > size) {
      throw const FormatException();
    }
    final manifest = jsonDecode(utf8.decode(await handle.read(length)));
    if (manifest is! Map ||
        manifest['format'] != overlayTilesFormat ||
        manifest['input_sha256'] != inputSha ||
        manifest['width'] is! int ||
        manifest['height'] is! int ||
        manifest['width'] != width ||
        manifest['height'] != height ||
        manifest['tiles'] is! List) {
      throw const FormatException();
    }
    final tiles = manifest['tiles'] as List;
    if (tiles.isEmpty || tiles.length > 4096) throw const FormatException();
    final patches = <TranslationImagePatch>[];
    var offset = 12 + length;
    for (final tile in tiles) {
      if (tile is! Map ||
          ![
            'x',
            'y',
            'width',
            'height',
            'byte_size',
          ].every((key) => tile[key] is int) ||
          tile['sha256'] is! String ||
          !RegExp(r'^[a-f0-9]{64}$').hasMatch(tile['sha256'])) {
        throw const FormatException();
      }
      final region = (
        x: tile['x'] as int,
        y: tile['y'] as int,
        width: tile['width'] as int,
        height: tile['height'] as int,
        offset: offset,
        length: tile['byte_size'] as int,
        sha256: tile['sha256'] as String,
      );
      if (region.x < 0 ||
          region.y < 0 ||
          region.width < 1 ||
          region.width > 2048 ||
          region.height < 1 ||
          region.height > 4096 ||
          region.x + region.width > width ||
          region.y + region.height > height ||
          region.length < 1 ||
          offset + region.length > size ||
          patches.any(
            (other) =>
                region.x < other.x + other.width &&
                other.x < region.x + region.width &&
                region.y < other.y + other.height &&
                other.y < region.y + region.height,
          )) {
        throw const FormatException();
      }
      patches.add(region);
      offset += region.length;
    }
    if (offset != size) throw const FormatException();
    return patches;
  } on FormatException {
    throw const TranslationFailure('INVALID_RESULT');
  } finally {
    await handle.close();
  }
}
