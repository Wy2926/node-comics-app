import 'dart:convert';

import 'package:mangayomi/src/rust/api/translation_image.dart' as native;

import '../nodelane_models.dart';

class TranslationImageWorker {
  Future<void> _tail = Future.value();
  Future<Map<String, dynamic>> run(Future<String> Function() work) {
    final future = _tail.then((_) async {
      try {
        return jsonDecode(await work()) as Map<String, dynamic>;
      } catch (error) {
        final text = error.toString();
        final code =
            const [
              'IMAGE_WORKING_SET_LIMIT',
              'IMAGE_FORMAT_UNSUPPORTED',
              'IMAGE_COLOR_UNSUPPORTED',
              'IMAGE_BYTES_LIMIT',
              'IMAGE_DIMENSIONS_LIMIT',
            ].where(text.contains).firstOrNull ??
            'RESULT_INVALID';
        throw NodeLaneException(code, '图片处理未完成。');
      }
    });
    _tail = future.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return future;
  }

  Future<Map<String, dynamic>> prepare(
    String source,
    String output,
    int maxBytes,
    int maxDimension,
  ) => run(
    () => native.translationPrepare(
      source: source,
      output: output,
      maxBytes: BigInt.from(maxBytes),
      maxDimension: maxDimension,
    ),
  );
  Future<Map<String, dynamic>> compose(
    String input,
    String artifact,
    Map<String, dynamic> result,
    String output,
  ) => run(
    () => native.translationCompose(
      input: input,
      artifact: artifact,
      resultJson: jsonEncode(result),
      output: output,
    ),
  );
}
