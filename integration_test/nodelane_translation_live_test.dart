// Opt-in only. Uses the account already saved in this app's secure storage.
// No credentials, source images or API responses are written to the repository.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:image/image.dart' as img;
import 'package:mangayomi/modules/nodelane/nodelane_auth_service.dart';
import 'package:mangayomi/modules/nodelane/nodelane_config.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_coordinator.dart';
import 'package:mangayomi/modules/nodelane/translation/official_translation_client.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_types.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/translation_repository.dart';
import 'package:mangayomi/src/rust/frb_generated.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('authorized live account translation, restart and cache reuse', (
    tester,
  ) async {
    if (!const bool.fromEnvironment('NODELANE_LIVE_TEST')) return;
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('NodeLane 翻译联调'))),
    );
    await tester.runAsync(() async {
      await RustLib.init();
      final auth = NodeLaneAuthService(
        config: NodeLaneConfig.fromEnvironment(),
      );
      await auth.initialize();
      expect(
        auth.state.account,
        isNotNull,
        reason: 'Requires the existing signed-in app account',
      );
      final db = await StorageProvider().initDB(null);
      final directory = Directory(
        '${(await getApplicationSupportDirectory()).path}/nodelane_translation',
      );
      final repository = TranslationRepository(db, directory);
      final client = _CountingClient(auth);
      var service = TranslationCoordinator(
        auth: auth,
        client: client,
        repository: Future.value(repository),
      );
      await service.ready;
      final sample = File(
        '${(await getTemporaryDirectory()).path}/nodelane-live-sample.png',
      );
      final canvas = img.Image(width: 1000, height: 1400);
      img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
      img.drawRect(
        canvas,
        x1: 60,
        y1: 80,
        x2: 940,
        y2: 600,
        color: img.ColorRgb8(0, 0, 0),
        thickness: 5,
      );
      img.drawString(
        canvas,
        'HELLO! WELCOME TO OUR CITY.',
        font: img.arial48,
        x: 100,
        y: 180,
        color: img.ColorRgb8(0, 0, 0),
      );
      img.drawString(
        canvas,
        'LET US READ COMICS TOGETHER.',
        font: img.arial48,
        x: 75,
        y: 310,
        color: img.ColorRgb8(0, 0, 0),
      );
      await sample.writeAsBytes(img.encodePng(canvas), flush: true);
      final page = TranslationPage(
        key: translationKey(['live-smoke-v1']),
        locatorSignature: translationKey(['synthetic-public-test']),
        openOriginal: () async => sample,
      );
      final first = await service.translate(page);
      final duplicate = await service.translate(page);
      expect(duplicate.uuid, first.uuid);
      // Reconstruct the coordinator while the backend may still be executing.
      service.dispose();
      service = TranslationCoordinator(
        auth: auth,
        client: client,
        repository: Future.value(repository),
      );
      await service.ready;
      await service.resume(first.id);
      final deadline = DateTime.now().add(const Duration(minutes: 8));
      String? lastState;
      while (DateTime.now().isBefore(deadline)) {
        final record = repository.get(first.id)!;
        final state =
            '${record.remoteState}/${record.phase}/${record.errorCode ?? "none"}';
        if (state != lastState) {
          debugPrint('LIVE_TRANSLATION_STATE: $state');
          lastState = state;
        }
        if (record.published) break;
        if (record.remoteState == 'failed' ||
            record.remoteState == 'needs_attention') {
          fail(
            'Remote state ${record.remoteState}, category ${record.errorCode}',
          );
        }
        if (record.errorCode != null && record.phase == 'paused') {
          fail('Delivery category ${record.errorCode}');
        }
        await Future<void>.delayed(const Duration(seconds: 2));
      }
      final completed = repository.get(first.id)!;
      expect(completed.remoteState, 'succeeded');
      expect(completed.published, isTrue);
      expect(
        completed.original,
        isFalse,
        reason: 'Text fixture must produce a translated image',
      );
      expect(await File(completed.resultPath!).exists(), isTrue);
      final counts = (client.creates, client.uploads, client.downloads);
      final cached = await service.translate(page);
      expect(cached.uuid, first.uuid);
      expect((client.creates, client.uploads, client.downloads), counts);
      expect(repository.page(service.scope!, page.key, 'zh-Hans').length, 1);
      // Deliberately only redacted states and timing go to the test output.
      debugPrint(
        'LIVE_TRANSLATION: succeeded, complete image cached, same UUID reused after coordinator restart',
      );
      debugPrint(
        'LIVE_REQUESTS: create=${client.creates}, upload=${client.uploads}, download=${client.downloads}; cached repeat adds zero',
      );
      service.dispose();
      auth.dispose();
      await db.close();
    });
  }, timeout: const Timeout(Duration(minutes: 12)));
}

class _CountingClient extends OfficialTranslationClient {
  _CountingClient(super.auth);
  int creates = 0, uploads = 0, downloads = 0;
  @override
  Future<Map<String, dynamic>> create(
    String uuid,
    String descriptor, {
    Future<void>? abort,
  }) {
    creates++;
    return super.create(uuid, descriptor, abort: abort);
  }

  @override
  Future<Map<String, dynamic>> upload(
    String uuid,
    File input,
    String mime,
    int length, {
    Future<void>? abort,
  }) {
    uploads++;
    return super.upload(uuid, input, mime, length, abort: abort);
  }

  @override
  Future<void> download(
    String uuid,
    Map<String, dynamic> artifact,
    File target,
    Future<void> abort,
  ) {
    downloads++;
    return super.download(uuid, artifact, target, abort);
  }
}
