import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

// Synthetic 2x2 lossless RGBA WebP, generated with Pillow: red at half alpha,
// opaque white, green and blue. No external image asset or encoder dependency.
final tileWebp = base64Decode(
  'UklGRj4AAABXRUJQVlA4TDEAAAAvAUAAEB8gpiGmlf6XVmoIBAj+x1wREhBm+d+sIiAoum65+MeEjKAgbQMWdTei/5EDAA==',
);

Map<String, dynamic> tileManifest(String inputSha, int width, int height) => {
  'format': 'overlay-tiles-v1',
  'input_sha256': inputSha,
  'width': width,
  'height': height,
  'tiles': [
    for (final y in [0, height - 2])
      {
        'x': 0,
        'y': y,
        'width': 2,
        'height': 2,
        'byte_size': tileWebp.length,
        'sha256': sha256.convert(tileWebp).toString(),
      },
  ],
};

Uint8List tileContainer(Map<String, dynamic> manifest, {List<int>? body}) {
  final json = utf8.encode(jsonEncode(manifest));
  final header = ByteData(12)
    ..buffer.asUint8List().setRange(0, 8, ascii.encode('NCOT0001'))
    ..setUint32(8, json.length, Endian.little);
  return (BytesBuilder(copy: false)
        ..add(header.buffer.asUint8List())
        ..add(json)
        ..add(body ?? [...tileWebp, ...tileWebp]))
      .takeBytes();
}
