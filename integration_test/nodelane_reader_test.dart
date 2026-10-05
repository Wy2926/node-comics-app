// Offline device checks. Always run with --no-uninstall to retain app data.
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:image/image.dart' as img;
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/translation_record.dart';
import 'package:mangayomi/modules/manga/reader/image_view_paged.dart';
import 'package:mangayomi/modules/manga/reader/image_view_vertical.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_translation_provider.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/translation_actions.dart';
import 'package:mangayomi/modules/nodelane/nodelane_auth_service.dart';
import 'package:mangayomi/modules/nodelane/nodelane_config.dart';
import 'package:mangayomi/modules/nodelane/nodelane_models.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_coordinator.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_image_worker.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/translation_repository.dart';
import 'package:mangayomi/src/rust/frb_generated.dart';
import 'package:path_provider/path_provider.dart';

Future<String> _fixture((int, int, String) args) async {
  final image = img.Image(width: args.$1, height: args.$2, numChannels: 3);
  img.fill(image, color: img.ColorRgb8(245, 245, 245));
  for (var y = 40; y < args.$2 - 60; y += 260) {
    img.drawRect(
      image,
      x1: 30,
      y1: y,
      x2: args.$1 - 30,
      y2: math.min(y + 230, args.$2 - 1),
      color: img.ColorRgb8(30, 30, 30),
      thickness: 4,
    );
    img.drawString(
      image,
      'READING TEST PANEL',
      font: img.arial48,
      x: 65,
      y: y + 60,
      color: img.ColorRgb8(30, 30, 30),
    );
  }
  await File(args.$3).writeAsBytes(img.encodePng(image), flush: true);
  return args.$3;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('native image budgets and paged/continuous translation switching', (
    tester,
  ) async {
    await RustLib.init();
    final root = await Directory(
      '${(await getTemporaryDirectory()).path}/nodelane-reader-check',
    ).create(recursive: true);
    app.isar = await StorageProvider().initDB(root.path);
    final worker = TranslationImageWorker();
    final info = <String, Map<String, dynamic>>{};
    for (final sample in [
      ('normal', 1000, 1400),
      ('4k', 3072, 4096),
      ('strip', 1000, 18000),
    ]) {
      final source = await compute(_fixture, (
        sample.$2,
        sample.$3,
        '${root.path}/${sample.$1}.png',
      ));
      var peak = ProcessInfo.currentRss;
      final before = peak;
      final timer = Timer.periodic(
        const Duration(milliseconds: 10),
        (_) => peak = math.max(peak, ProcessInfo.currentRss),
      );
      final clock = Stopwatch()..start();
      final prepared = await worker.prepare(
        source,
        '${root.path}/${sample.$1}.input',
        128 * 1024 * 1024,
        100000,
      );
      clock.stop();
      timer.cancel();
      info[sample.$1] = prepared;
      debugPrint(
        'IMAGE_BENCH ${sample.$1}: ${clock.elapsedMilliseconds} ms, RSS before=$before peak=$peak bytes, input=${prepared['byte_size']} bytes, dimensions=${prepared['width']}x${prepared['height']}, network=0',
      );
    }
    final auth = _ReaderAccount();
    final repository = TranslationRepository(
      app.isar,
      Directory('${root.path}/results'),
    );
    final coordinator = TranslationCoordinator(
      auth: auth,
      repository: Future.value(repository),
    );
    await coordinator.ready;
    final source =
        UChapDataPreload(
            null,
            root,
            null,
            true,
            null,
            0,
            null,
            0,
            localImagePath: '${root.path}/4k.png',
          )
          ..resolvedFilePath = '${root.path}/4k.png'
          ..loadedWidth = 3072
          ..loadedHeight = 4096;
    final prepared = info['4k']!;
    final resultPath = '${root.path}/4k.input';
    final record = TranslationRecord()
      ..uuid = 'reader-fixture'
      ..scope = coordinator.scope!
      ..pageKey = readerTranslationKey(source)
      ..locatorSignature = readerLocatorSignature(source)
      ..language = 'zh-Hans'
      ..sourceSha = prepared['source_sha256'] as String
      ..inputSha = prepared['sha256'] as String
      ..inputPath = resultPath
      ..inputMime = prepared['content_type'] as String
      ..inputBytes = prepared['byte_size'] as int
      ..width = prepared['width'] as int
      ..height = prepared['height'] as int
      ..sourceWidth = 3072
      ..sourceHeight = 4096
      ..descriptorJson = '{}'
      ..remoteState = 'succeeded'
      ..phase = 'ready'
      ..published = true
      ..resultPath = resultPath;
    await repository.insert(record);
    final container = ProviderContainer(
      overrides: [translationProvider.overrideWith((ref) => coordinator)],
    );
    final controller = SubsamplingScaleImageViewController();
    Widget host(Widget child) => UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
    // Wide-page slices share the same original identity and use scaled bounds.
    final slice = UChapDataPreload(
      null,
      root,
      null,
      true,
      null,
      0,
      null,
      1,
      localImagePath: source.localImagePath,
      srcRect: const Rect.fromLTWH(1536, 0, 1536, 4096),
    );
    expect(readerTranslationKey(slice), readerTranslationKey(source));
    final selected = container.read(readerTranslationImageProvider(slice));
    expect(selected.srcRect, const Rect.fromLTWH(900, 0, 900, 2400));
    await tester.pumpWidget(
      host(
        ImageViewPaged(
          data: source,
          controller: controller,
          onLongPressData: (_) {},
          loadStateChanged: (_) => null,
        ),
      ),
    );
    await _wait(tester, () => controller.isReady);
    controller.setScaleAndCenter(
      controller.minScale * 1.7,
      Offset(controller.sWidth * .6, controller.sHeight * .6),
    );
    await tester.pump(const Duration(milliseconds: 100));
    final center = Offset(
      controller.center!.dx / controller.sWidth,
      controller.center!.dy / controller.sHeight,
    );
    final zoom = controller.scale / controller.minScale;
    coordinator.toggleOriginal(record.pageKey);
    await tester.pump();
    await _wait(tester, () => controller.isReady);
    expect(controller.center!.dx / controller.sWidth, closeTo(center.dx, .015));
    expect(
      controller.center!.dy / controller.sHeight,
      closeTo(center.dy, .015),
    );
    expect(controller.scale / controller.minScale, closeTo(zoom, .015));
    final scroll = ScrollController();
    await tester.pumpWidget(
      host(
        SingleChildScrollView(
          controller: scroll,
          child: Column(
            children: [
              ImageViewVertical(
                data: source,
                onLongPressData: (_) {},
                failedToLoadImage: (_) {},
                isHorizontal: false,
              ),
              const SizedBox(height: 1800),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    scroll.jumpTo(140);
    await tester.pump();
    final offset = scroll.offset;
    for (var i = 0; i < 5; i++) {
      coordinator.toggleOriginal(record.pageKey);
      await tester.pump(const Duration(milliseconds: 15));
    }
    await tester.pumpAndSettle();
    expect(scroll.offset, closeTo(offset, .5));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(
      host(
        Center(
          child: SizedBox(
            width: 320,
            child: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
              child: TranslationActions(data: source),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    debugPrint(
      'READER_CHECK: wide-page mapping, paged center/zoom, continuous offset and rapid toggle passed',
    );
    await tester.pumpWidget(const SizedBox());
    container.dispose();
    auth.dispose();
    scroll.dispose();
    controller.dispose();
    await app.isar.close();
  }, timeout: const Timeout(Duration(minutes: 8)));
}

Future<void> _wait(WidgetTester tester, bool Function() ready) async {
  for (var i = 0; i < 150 && !ready(); i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(ready(), isTrue);
}

class _ReaderAccount extends NodeLaneAuthService {
  _ReaderAccount()
    : super(
        config: NodeLaneConfig(
          serviceOrigin: 'https://offline.invalid',
          clientId: 'reader-test',
        ),
      );
  @override
  NodeLaneAuthState get state => NodeLaneAuthState(
    initialized: true,
    account: NodeLaneAccount(
      user: const NodeLaneUser(
        id: 'offline-reader',
        name: 'Reader',
        role: 'user',
      ),
      entitlements: NodeLaneEntitlements.fromJson({
        'plan': 'free',
        'modes': <String, dynamic>{},
      }),
      serviceOrigin: 'https://offline.invalid',
      issuer: 'https://offline.invalid',
      subject: 'reader',
      sessionId: 'reader',
    ),
  );
}
