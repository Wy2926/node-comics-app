// Device check against browser_filter_server.py; no account or translation service.
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mangayomi/modules/webview/gecko_browser_page.dart';
import 'package:mangayomi/services/translation/identity.dart';

const _url = 'http://127.0.0.1:8769/';

void main() {
  final lease = translationUuid(), token = translationUuid();
  final document = Completer<void>(), image = Completer<Map>();
  final verdict = Completer<String>();
  runApp(
    Directionality(
      textDirection: TextDirection.ltr,
      child: GeckoBrowserPage.view(lease, (id) async {
        final engine = GeckoBrowserPage(id, (event) async {
          if (event.method == 'document' &&
              event.arguments == _url &&
              !document.isCompleted) {
            document.complete();
          }
          if (event.method == 'title' &&
              !verdict.isCompleted &&
              [
                'Site filter ON',
                'Site filter OFF',
                'FAIL: comic missing',
              ].contains(event.arguments)) {
            verdict.complete(event.arguments as String);
          }
        });
        try {
          await engine.attach(_url, true);
          await document.future.timeout(const Duration(seconds: 80));
          if (await verdict.future.timeout(const Duration(seconds: 10)) !=
              'Site filter ON') {
            throw StateError('First navigation did not filter the ad');
          }
          engine.listen((origin, url, message) async {
            if (url != _url || message is! Map || message['token'] != token) {
              return false;
            }
            for (final item in (message['items'] as List).whereType<Map>()) {
              if (item['url'].toString().contains('/book/page.png') &&
                  !image.isCompleted) {
                image.complete(item);
              }
            }
            return true;
          });
          await engine.install(_url, token, () => true);
          await engine.call(_url, token, 'state', {
            'active': true,
            'translated': false,
          });
          final item = await image.future.timeout(const Duration(seconds: 10));
          final begin = await engine.call(_url, token, 'inputBegin', {
            'id': item['id'],
            'revision': item['revision'],
          });
          final chunk = await engine.call(_url, token, 'inputChunk', {
            'id': item['id'],
            'offset': 0,
          });
          if (begin['value']['size'] != 68 ||
              chunk['value'] !=
                  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8'
                      '/x8AAwMCAO+j4/kAAAAASUVORK5CYII=') {
            throw StateError('Missing original PNG bytes');
          }
          await engine.call(_url, token, 'inputEnd', {});
          debugPrint(
            'GECKO_SMOKE_PASS: filtered first page and read original PNG',
          );
        } catch (error) {
          debugPrint('GECKO_SMOKE_FAIL: $error');
        } finally {
          engine.detach();
          await GeckoBrowserPage.release(lease);
        }
      }),
    ),
  );
}
