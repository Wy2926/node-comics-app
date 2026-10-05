import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/nodelane/translation/official_translation_client.dart';

void main() {
  test(
    'SSE handles UTF8/chunk splits, heartbeat and end without another event',
    () async {
      final bytes = utf8.encode(
        ': heartbeat\r\nevent: snapshot\r\ndata: {"items":[{"state":"运行"}]}\r\n\r\nevent: end\ndata: {"reason":"complete"}\n\nevent: snapshot\ndata: {}\n\n',
      );
      final frames = await OfficialTranslationClient.parseEvents(
        Stream.fromIterable(bytes.map((b) => [b])),
      ).toList();
      expect(frames, [
        {
          'items': [
            {'state': '运行'},
          ],
        },
      ]);
    },
  );
  test(
    'an unterminated malicious SSE line is bounded before decoding',
    () async {
      final bytes = Stream.fromIterable(
        List.generate(33, (_) => List.filled(65536, 65)),
      );
      await expectLater(
        OfficialTranslationClient.parseEvents(bytes).drain<void>(),
        throwsFormatException,
      );
    },
  );
}
