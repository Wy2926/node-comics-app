import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:mangayomi/models/source_image_processing.dart';

const sourceImageMaxBytes = 12 * 1024 * 1024;
const sourceImageMaxPixels = 8 * 1000 * 1000;

/// xorshift32 + Fisher-Yates permutation. Site seed masks come from the plugin.
List<int> sourceTileOrder(int seed, int count) {
  var state = (seed | 1) & 0xffffffff;
  final order = List.generate(count, (i) => i);
  for (var i = count - 1; i > 0; i--) {
    state = (state ^ (state << 13)) & 0xffffffff;
    state = (state ^ (state >> 17)) & 0xffffffff;
    state = (state ^ (state << 5)) & 0xffffffff;
    final next = state % (i + 1), previous = order[i];
    order[i] = order[next];
    order[next] = previous;
  }
  return order;
}

/// Called in a worker. Only the exact declared response protocol is accepted.
Uint8List restoreSourceImage(
  Uint8List bytes,
  Map<String, String> headers,
  SourceImageProcessing spec,
) {
  if (bytes.length < 12 || bytes.length > sourceImageMaxBytes) {
    throw StateError('图片超过处理大小限制');
  }
  final h = {for (final e in headers.entries) e.key.toLowerCase(): e.value};
  final grid = RegExp(r'^(\d+)x(\d+)$').firstMatch(h['x-scramble-grid'] ?? '');
  final seedText = h['x-scramble-seed'] ?? '';
  final seed = int.tryParse(seedText);
  if (h['x-scramble-algo'] != '3' ||
      grid == null ||
      !RegExp(r'^\d+$').hasMatch(seedText) ||
      seed == null ||
      seed > 0xffffffff) {
    throw StateError('图片还原响应协议已变化，请更新来源');
  }
  final cols = int.parse(grid[1]!), rows = int.parse(grid[2]!);
  if (cols < 1 || rows < 1 || cols * rows > 256) throw StateError('图片还原网格无效');
  final decoder = img.findDecoderForData(bytes);
  final info = decoder?.startDecode(bytes);
  if (info == null ||
      info.width < cols ||
      info.height < rows ||
      info.width * info.height > sourceImageMaxPixels ||
      info.numFrames != 1) {
    throw StateError('图片格式、尺寸或动画不在还原范围内');
  }
  final input = decoder!.decodeFrame(0);
  if (input == null) throw StateError('图片无法解码');
  final output = img.Image.from(input, noAnimation: true);
  final tileWidth = input.width ~/ cols, tileHeight = input.height ~/ rows;
  final mask = spec.seedMasks[h['x-scramble-hash']] ?? 0;
  final order = sourceTileOrder(seed ^ mask, cols * rows);
  for (var from = 0; from < order.length; from++) {
    final to = order[from];
    img.compositeImage(
      output,
      input,
      srcX: (from % cols) * tileWidth,
      srcY: (from ~/ cols) * tileHeight,
      srcW: tileWidth,
      srcH: tileHeight,
      dstX: (to % cols) * tileWidth,
      dstY: (to ~/ cols) * tileHeight,
      dstW: tileWidth,
      dstH: tileHeight,
      blend: img.BlendMode.direct,
    );
  }
  // Image.from preserves remainder pixels outside the equal-sized grid.
  return Uint8List.fromList(img.encodePng(output, level: 1));
}

Future<void> _processing = Future.value();
int _waiting = 0;
Future<Uint8List> restoreSourceImageInBackground(
  Uint8List bytes,
  Map<String, String> headers,
  SourceImageProcessing spec, {
  void Function()? checkCancelled,
}) async {
  if (_waiting >= 4) throw StateError('图片处理队列已满，请稍后重试');
  _waiting++;
  final previous = _processing, done = Completer<void>();
  _processing = done.future;
  try {
    await previous;
    checkCancelled?.call();
    final result = await compute(_restore, (bytes, headers, spec));
    checkCancelled?.call();
    return result;
  } finally {
    _waiting--;
    done.complete();
  }
}

Uint8List _restore(
  (Uint8List, Map<String, String>, SourceImageProcessing) value,
) => restoreSourceImage(value.$1, value.$2, value.$3);

Future<Uint8List> readBoundedSourceImage(http.StreamedResponse response) async {
  if (response.statusCode != 200 ||
      (response.contentLength ?? 0) > sourceImageMaxBytes) {
    await response.stream.listen((_) {}).cancel();
    throw StateError('图片请求失败或超过处理大小限制');
  }
  final builder = BytesBuilder(copy: false);
  await for (final chunk in response.stream.timeout(
    const Duration(seconds: 30),
  )) {
    if (builder.length + chunk.length > sourceImageMaxBytes) {
      throw StateError('图片超过处理大小限制');
    }
    builder.add(chunk);
  }
  return builder.takeBytes();
}
