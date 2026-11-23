import '../../contracts.dart';
import '../../image_work.dart' show webpMaxEdge;

/// NodeLane's authenticated, per-image translation protocol. Protocol fields
/// stay inside this adapter; readers consume only the public channel contract.
const nodeLaneTranslationProtocol = 'overlay-v1';
const nodeLaneTranslationProtocolHeader = 'X-Translation-Protocol';
const overlayTilesFormat = 'overlay-tiles-v1';
const overlayTilesMime = 'application/vnd.nodelane.overlay-tiles';

final _modelId = RegExp(r'^[a-zA-Z0-9_-]{1,36}$');

TranslationModel? nodeLaneModel(Object? value) {
  if (value is! Map) return null;
  final id = value['id'], name = value['name'];
  if (id is! String || !_modelId.hasMatch(id)) return null;
  return (id: id, name: name is String && name.trim().isNotEmpty ? name : id);
}

List<TranslationModelOption> nodeLaneModels(Map<String, dynamic> capabilities) {
  final entries = capabilities['translation_models'];
  if (entries == null) return const []; // Older services only support default.
  if (entries is! List) throw const TranslationFailure('INVALID_RESULT');
  final seen = <String>{};
  return [
    for (final entry in entries.whereType<Map>())
      if (nodeLaneModel(entry) case final model? when seen.add(model.id))
        (
          model: model,
          access: switch ((entry['available'], entry['unavailable_reason'])) {
            (true, _) => TranslationModelAccess.available,
            (false, 'quota_exhausted') => TranslationModelAccess.quotaExhausted,
            (false, 'not_allowed') => TranslationModelAccess.notAllowed,
            _ => TranslationModelAccess.unavailable,
          },
          requiresPaid: entry['requires_paid'] is bool
              ? entry['requires_paid'] as bool
              : null,
          quotaMultiplier: switch (entry['quota_multiplier']) {
            final num n when n.isFinite && n > 0 => n,
            _ => null,
          },
        ),
  ];
}

/// The WebP edge selects a result representation; it is not an input limit.
String? nodeLaneResultFormat(
  Map<String, dynamic> capabilities,
  int width,
  int height,
) {
  if (width <= webpMaxEdge && height <= webpMaxEdge) return null;
  final representations = capabilities['representations'];
  if (representations is! List ||
      !representations.contains(overlayTilesFormat)) {
    throw const TranslationFailure('RESULT_FORMAT_UNAVAILABLE');
  }
  return overlayTilesFormat;
}

/// Validate descriptors both on receipt and before materializing stored results.
/// Full-image results describe their own output size; overlays describe input pixels.
void validateNodeLaneResult(
  Map result, {
  required String id,
  required String inputSha,
  required int width,
  required int height,
}) {
  final representation = result['representation'];
  final full = representation == 'full-image-v1';
  if (result['normalization_version'] != 1 ||
      result['input_sha256'] != inputSha ||
      result['width'] is! int ||
      result['width'] <= 0 ||
      result['height'] is! int ||
      result['height'] <= 0 ||
      (!full && (result['width'] != width || result['height'] != height))) {
    throw const TranslationFailure('INVALID_RESULT');
  }
  final artifact = result['artifact'], box = result['bbox'];
  if (representation == 'original') {
    if (result['kind'] != 'no_text' ||
        artifact != null ||
        box != null ||
        result['composite'] != null) {
      throw const TranslationFailure('INVALID_RESULT');
    }
    return;
  }
  if (!const {'translated', 'partial'}.contains(result['kind']) ||
      artifact is! Map ||
      artifact['path'] != '/v1/translations/$id/result' ||
      artifact['byte_size'] is! int ||
      artifact['byte_size'] <= 0 ||
      artifact['sha256'] is! String ||
      !RegExp(r'^[a-f0-9]{64}$').hasMatch(artifact['sha256']) ||
      artifact['mime'] is! String) {
    throw const TranslationFailure('INVALID_RESULT');
  }
  if (full) {
    if (box != null || result['composite'] != null) {
      throw const TranslationFailure('INVALID_RESULT');
    }
    return;
  }
  if (result['composite'] != 'source-atop') {
    throw const TranslationFailure('INVALID_RESULT');
  }
  if (representation == overlayTilesFormat) {
    if (box != null || artifact['mime'] != overlayTilesMime) {
      throw const TranslationFailure('INVALID_RESULT');
    }
    return;
  }
  if (representation != 'overlay-v1' ||
      artifact['mime'] != 'image/webp' ||
      box is! Map ||
      !['x', 'y', 'width', 'height'].every((key) => box[key] is int) ||
      box['x'] < 0 ||
      box['y'] < 0 ||
      box['width'] < 1 ||
      box['height'] < 1 ||
      box['x'] + box['width'] > width ||
      box['y'] + box['height'] > height) {
    throw const TranslationFailure('INVALID_RESULT');
  }
}

const nodeLaneNonRetryableErrors = {
  'CLASSIC_ANALYSIS_TOO_LARGE',
  'CLASSIC_REGION_LIMIT_EXCEEDED',
  'CLASSIC_TEXT_LIMIT_EXCEEDED',
};
