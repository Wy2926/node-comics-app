import 'dart:convert';

import 'package:crypto/crypto.dart';

/// A small declarative image operation, never JavaScript image bytes or code.
class SourceImageProcessing {
  final Map<String, int> seedMasks;
  final int? rows;
  final bool skipGif;
  final ({int grid, int alignment})? transpose;
  SourceImageProcessing._(
    this.seedMasks, {
    this.rows,
    this.skipGif = false,
    this.transpose,
  });

  factory SourceImageProcessing.fromJson(Map<String, dynamic> value) {
    if (value['type'] == 'tile-transpose-v1') {
      final grid = value['grid'], alignment = value['alignment'];
      if (grid is! int ||
          grid < 1 ||
          grid > 16 ||
          alignment is! int ||
          alignment < 1) {
        throw StateError('图片处理参数无效');
      }
      return SourceImageProcessing._(
        const {},
        transpose: (grid: grid, alignment: alignment),
      );
    }
    if (value['type'] == 'strip-reverse-v1') {
      final rows = value['rows'];
      if (rows is! int || rows < 1 || rows > 256 || value['skipGif'] is! bool) {
        throw StateError('图片处理参数无效');
      }
      return SourceImageProcessing._(
        const {},
        rows: rows,
        skipGif: value['skipGif'] as bool,
      );
    }
    if (value['type'] != 'tile-shuffle-v1' ||
        value['algorithm'] != 3 ||
        value['seedMasks'] is! Map) {
      throw StateError('图片处理协议不受支持，请更新来源或 App');
    }
    final masks = <String, int>{};
    for (final entry in (value['seedMasks'] as Map).entries) {
      if (entry.key is! String ||
          !RegExp(r'^[a-f0-9]{1,32}$').hasMatch(entry.key) ||
          entry.value is! int ||
          entry.value < 0 ||
          entry.value > 0xffffffff ||
          masks.length >= 8) {
        throw StateError('图片处理参数无效');
      }
      masks[entry.key] = entry.value;
    }
    return SourceImageProcessing._(Map.unmodifiable(masks));
  }

  Map<String, dynamic> toJson() {
    if (transpose case final t?) {
      return {
        'type': 'tile-transpose-v1',
        'grid': t.grid,
        'alignment': t.alignment,
      };
    }
    if (rows != null) {
      return {'type': 'strip-reverse-v1', 'rows': rows, 'skipGif': skipGif};
    }
    return {
      'type': 'tile-shuffle-v1',
      'algorithm': 3,
      'seedMasks': {
        for (final key in seedMasks.keys.toList()..sort()) key: seedMasks[key],
      },
    };
  }

  String cacheKey(String url) =>
      md5.convert(utf8.encode('$url|${jsonEncode(toJson())}')).toString();
}
