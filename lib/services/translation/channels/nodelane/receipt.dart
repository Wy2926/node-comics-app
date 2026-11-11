import '../../contracts.dart';
import '../../image_work.dart';
import 'protocol.dart';

class OfficialReceipt {
  OfficialReceipt({
    required this.id,
    required this.key,
    required this.scope,
    required this.language,
    required this.inputKey,
    required this.inputSha,
    required this.sourceSha,
    required this.width,
    required this.height,
    required this.mime,
    required this.request,
    this.sent = false,
    this.accepted = false,
    this.snapshot,
    this.resultKey,
    this.resultWidth,
    this.resultHeight,
    this.unavailable = false,
  });
  final String id, key, scope, language;
  final String inputKey, inputSha, sourceSha, mime;
  final int width, height;
  final Map<String, dynamic> request;
  bool sent, accepted;
  bool unavailable;
  Map<String, dynamic>? snapshot;
  String? resultKey;
  // Cache metadata survives a later RESULT_EXPIRED snapshot without a descriptor.
  int? resultWidth, resultHeight;
  int get displayWidth => resultWidth ?? result?['width'] as int? ?? width;
  int get displayHeight => resultHeight ?? result?['height'] as int? ?? height;
  String get state =>
      snapshot?['state'] as String? ?? (sent ? 'uncertain' : 'local');
  bool get active => !const {'succeeded', 'failed'}.contains(state);
  bool get unknown =>
      unavailable ||
      state == 'uncertain' ||
      state == 'needs_attention' ||
      (snapshot?['error'] is Map &&
          snapshot?['error']['code'] == 'TRANSLATION_UNAVAILABLE' &&
          snapshot?['execution_resolved'] != true);
  Map<String, dynamic>? get result =>
      snapshot?['result'] as Map<String, dynamic>?;
  String? get errorCode =>
      snapshot?['error'] is Map ? snapshot!['error']['code'] as String? : null;
  bool get resultExpired => errorCode == 'RESULT_EXPIRED';
  bool get canRetry =>
      state == 'failed' && !nodeLaneNonRetryableErrors.contains(errorCode);

  void accept(Map<String, dynamic> value) {
    if (value['id'] != id ||
        value['mode'] != 'classic' ||
        value['target_language'] != language ||
        value['image_sha256'] != inputSha ||
        !const {
          'needs_input',
          'queued',
          'running',
          'succeeded',
          'failed',
          'needs_attention',
        }.contains(value['state'])) {
      throw const TranslationFailure('INVALID_RESULT');
    }
    // Do not let a stale nonterminal response undo an already received result.
    if (!active && !const {'succeeded', 'failed'}.contains(value['state'])) {
      return;
    }
    final previousTime = DateTime.tryParse('${snapshot?['updated_at']}');
    final nextTime = DateTime.tryParse('${value['updated_at']}');
    if (previousTime != null &&
        nextTime != null &&
        nextTime.isBefore(previousTime)) {
      return;
    }
    final expired =
        value['error'] is Map &&
        value['error']['code'] == 'RESULT_EXPIRED' &&
        value['result'] == null;
    if (value['state'] == 'succeeded' && !expired) {
      final result = value['result'];
      if (result is! Map) {
        throw const TranslationFailure('INVALID_RESULT');
      }
      validateNodeLaneResult(
        result,
        id: id,
        inputSha: inputSha,
        width: width,
        height: height,
      );
    }
    accepted = true;
    unavailable = false;
    snapshot = value;
  }

  Map<String, dynamic> toJson() => {
    'version': 1,
    'inputProfile': translationInputProfile,
    'encoderVersion': translationEncoderVersion,
    'id': id,
    'key': key,
    'scope': scope,
    'language': language,
    'inputKey': inputKey,
    'inputSha': inputSha,
    'sourceSha': sourceSha,
    'width': width,
    'height': height,
    'mime': mime,
    'request': request,
    'sent': sent,
    'accepted': accepted,
    'unavailable': unavailable,
    'snapshot': snapshot,
    'resultKey': resultKey,
    if (resultWidth != null) 'resultWidth': resultWidth,
    if (resultHeight != null) 'resultHeight': resultHeight,
  };
  factory OfficialReceipt.fromJson(Map<String, dynamic> value) {
    if (value['version'] != 1 ||
        value['inputProfile'] != translationInputProfile ||
        value['encoderVersion'] != translationEncoderVersion) {
      throw const TranslationFailure('CLIENT_UPGRADE_REQUIRED');
    }
    return OfficialReceipt(
      id: value['id'] as String,
      key: value['key'] as String,
      scope: value['scope'] as String,
      language: value['language'] as String,
      inputKey: value['inputKey'] as String,
      inputSha: value['inputSha'] as String,
      sourceSha: value['sourceSha'] as String,
      width: value['width'] as int,
      height: value['height'] as int,
      mime: value['mime'] as String,
      request: Map<String, dynamic>.from(value['request'] as Map),
      sent: value['sent'] == true,
      accepted: value['accepted'] == true,
      unavailable: value['unavailable'] == true,
      snapshot: value['snapshot'] == null
          ? null
          : Map<String, dynamic>.from(value['snapshot'] as Map),
      resultKey: value['resultKey'] as String?,
      resultWidth: value['resultWidth'] as int?,
      resultHeight: value['resultHeight'] as int?,
    );
  }
}
