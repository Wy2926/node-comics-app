import 'dart:io';

import 'package:image/image.dart' as img;

// PNG gAMA=1.0, including length and CRC.
const gammaChunk = [
  0,
  0,
  0,
  4,
  103,
  65,
  77,
  65,
  0,
  1,
  134,
  160,
  49,
  232,
  150,
  95,
];

Future<({int width, int height, String mime})> readImageHeader(
  File file,
) async {
  final bytes = await file.readAsBytes(),
      decoder = img.findDecoderForData(bytes)!;
  final info = decoder.startDecode(bytes)!;
  return (
    width: info.width,
    height: info.height,
    mime: 'image/${decoder is img.JpegDecoder ? 'jpeg' : decoder.format.name}',
  );
}
