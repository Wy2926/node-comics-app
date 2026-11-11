import '../../contracts.dart';

/// NodeLane's authenticated, per-image translation protocol. Protocol fields
/// stay inside this adapter; readers consume only the public channel contract.
const nodeLaneTranslationProtocol = 'overlay-v1';
const nodeLaneTranslationProtocolHeader = 'X-Translation-Protocol';
const overlayTilesFormat = 'overlay-tiles-v1';
const overlayTilesMime = 'application/vnd.nodelane.overlay-tiles';

/// The WebP edge selects a result representation; it is not an input limit.
String? nodeLaneResultFormat(
  Map<String, dynamic> capabilities,
  int width,
  int height,
) {
  if (width <= 16383 && height <= 16383) return null;
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
