import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../nodelane_models.dart';

const inputPolicy = 'short-edge-1800-webp90-jpeg30-v2';

String translationKey(List<Object?> values) =>
    sha256.convert(utf8.encode(jsonEncode(values))).toString();
String translationUuid() {
  final random = Random.secure();
  final b = List.generate(16, (_) => random.nextInt(256));
  b[6] = (b[6] & 15) | 64;
  b[8] = (b[8] & 63) | 128;
  final h = b.map((n) => n.toRadixString(16).padLeft(2, '0')).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
}

class TranslationPage {
  const TranslationPage({
    required this.key,
    required this.locatorSignature,
    required this.openOriginal,
  });
  final String key;
  final String locatorSignature;
  final Future<File> Function() openOriginal;
}

class TranslationCapabilities {
  TranslationCapabilities(Map<String, dynamic> value) {
    if (value['result_protocol'] != 'overlay-v1') {
      throw const NodeLaneException('CLIENT_UPGRADE_REQUIRED', '请更新应用以使用翻译。');
    }
    representations = List<String>.from(value['representations'] as List);
    final limits = value['limits'] as Map;
    maxBytes = limits['max_bytes'] as int;
    maxDimension = limits['max_dimension'] as int;
    final modes = (value['modes'] as List).cast<Map>();
    final classic = modes
        .where((m) => m['id'] == 'classic' && m['enabled'] == true)
        .firstOrNull;
    languages = classic == null
        ? []
        : List<String>.from(classic['languages'] as List);
    if (maxBytes <= 0 || maxDimension <= 0) {
      throw const FormatException('Invalid capabilities');
    }
  }
  late final List<String> representations;
  late final List<String> languages;
  late final int maxBytes;
  late final int maxDimension;
}

String translationError(Object error) {
  if (error is NodeLaneException) return error.code;
  if (error is FileSystemException) return 'STORAGE_FAILED';
  return 'RESULT_INVALID';
}

String translationErrorMessage(String? code) => switch (code) {
  'LOGIN_REQUIRED' || 'SESSION_CHANGED' => '请登录 NodeLane 后继续',
  'LOCAL_INPUT_MISSING' => '送译副本缺失，无法恢复原任务',
  'IMAGE_WORKING_SET_LIMIT' => '图片超过当前设备处理预算，原图仍可阅读',
  'IMAGE_FORMAT_UNSUPPORTED' ||
  'IMAGE_COLOR_UNSUPPORTED' => '当前图片格式或色彩配置暂不支持翻译',
  'IMAGE_BYTES_LIMIT' || 'IMAGE_DIMENSIONS_LIMIT' => '图片超出当前翻译能力',
  'STORAGE_FAILED' => '存储空间不足或文件不可用',
  'RATE_LIMITED' => '服务繁忙，稍后继续同步',
  'DAILY_QUOTA_EXHAUSTED' => '当前常规翻译额度已用完，可在账号页查看',
  'FORBIDDEN' || 'PLUS_REQUIRED' => '当前账户没有此翻译权限',
  'QUEUE_FULL' => '待处理任务较多，请先同步或取消现有任务',
  'LANGUAGE_UNAVAILABLE' => '服务暂不支持所选目标语言',
  'WINDOW_CHANGED' => '已离开阅读窗口，尚未提交',
  'CONNECTION_FAILED' => '连接中断，继续同步即可恢复原任务',
  'SYNC_PAUSED' => '同步已暂停，后端任务仍可继续执行',
  'SOURCE_CHANGED' => '原图已变化，请重新打开当前页',
  _ => '暂时无法完成，请继续同步或查看任务状态',
};
