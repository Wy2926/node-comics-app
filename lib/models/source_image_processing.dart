import 'dart:convert';

import 'package:crypto/crypto.dart';

/// A small declarative image operation, never JavaScript image bytes or code.
class SourceImageProcessing {
  final Map<String, int> seedMasks;
  SourceImageProcessing._(this.seedMasks);

  factory SourceImageProcessing.fromJson(Map<String, dynamic> value) {
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

  Map<String, dynamic> toJson() => {
    'type': 'tile-shuffle-v1',
    'algorithm': 3,
    'seedMasks': {
      for (final key in seedMasks.keys.toList()..sort()) key: seedMasks[key],
    },
  };

  String cacheKey(String url) =>
      md5.convert(utf8.encode('$url|${jsonEncode(toJson())}')).toString();
}
