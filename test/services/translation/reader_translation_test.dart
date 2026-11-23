import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:image/image.dart' as img;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source_image_processing.dart';
import 'package:mangayomi/modules/manga/reader/reader_page_image.dart';
import 'package:mangayomi/services/translation/image_work.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:mangayomi/modules/translation/translation_image_status.dart';
import 'package:mangayomi/modules/manga/reader/reader_translation.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/translation_service.dart';

class _LocalRuntime implements ChannelRuntime {
  final _changes = StreamController<void>.broadcast();
  List<TranslationTarget> window = [];
  int reads = 0, releases = 0;
  bool automatic = false;
  @override
  Stream<void> get changes => _changes.stream;
  @override
  PageTranslationState stateFor(TranslationPage page) => PageTranslationState(
    phase: TranslationPhase.succeeded,
    result: TranslationResultRef('local', page.identity),
  );
  @override
  Future<void> restore(List<TranslationTarget> targets) async {}
  @override
  void setWindow(
    String consumer,
    List<TranslationTarget> targets, {
    bool automatic = true,
  }) {
    window = targets;
    this.automatic = automatic;
  }

  @override
  void pause(String consumer) => window = [];
  @override
  Future<void> perform(
    TranslationTarget target,
    TranslationAction action,
  ) async {}
  @override
  Future<DisplayImageLease> readResult(
    TranslationResultRef result,
    TranslationCancellation cancellation,
  ) async {
    reads++;
    return DisplayImageLease(
      file: File('/synthetic-translation.png'),
      width: 100,
      height: 40,
      release: () => releases++,
    );
  }

  @override
  Future<void> dispose() => _changes.close();
}

class _LocalService extends TranslationService {
  _LocalService(ChannelRuntime value) {
    runtime = value;
  }
  @override
  Future<void> initialize() async {}
}

class _CachePath extends PathProviderPlatform {
  _CachePath(this.root);
  final Directory root;
  @override
  Future<String?> getApplicationCachePath() async => root.path;
}

void main() {
  test(
    'translation and prefetch share the restored page, page Referer and retry',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final oldHttp = HttpOverrides.current,
          oldPaths = PathProviderPlatform.instance;
      HttpOverrides.global = null;
      final dir = await Directory.systemTemp.createTemp('reader-original-');
      PathProviderPlatform.instance = _CachePath(dir);
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final providers = ProviderContainer(
        overrides: [
          headersProvider.overrideWith(
            (_, _) => {'Referer': 'https://fixture.test/catalog'},
          ),
        ],
      );
      addTearDown(() async {
        providers.dispose();
        await server.close(force: true);
        PathProviderPlatform.instance = oldPaths;
        HttpOverrides.global = oldHttp;
        await dir.delete(recursive: true);
      });
      final pixels = img.Image(width: 2, height: 4)
        ..setPixelRgb(0, 2, 160, 30, 10);
      final raw = img.encodePng(pixels);
      const pageReferer = 'https://fixture.test/chapter';
      var requests = 0, available = false;
      server.listen((req) async {
        requests++;
        if (available && req.headers.value('referer') == pageReferer) {
          req.response.add(raw);
        } else {
          req.response.statusCode = 403;
        }
        await req.response.close();
      });
      final book = Manga.fromJson({
        'id': 42,
        'source': 'fixture',
        'lang': 'en',
        'sourceId': 7,
        'status': 0,
        'favorite': false,
      });
      final chapter = Chapter(id: 21, mangaId: 42, name: 'Fixture')
        ..manga.value = book;
      final data = UChapDataPreload(
        chapter,
        null,
        PageUrl(
          'http://127.0.0.1:${server.port}/page',
          headers: {'Referer': pageReferer},
          imageProcessing: SourceImageProcessing.fromJson({
            'type': 'strip-reverse-v1',
            'rows': 2,
            'skipGif': true,
          }),
        ),
        false,
        null,
        0,
        null,
        0,
      )..resolvedFilePath = '${dir.path}/evicted';
      final reader = ReaderSourceImageReader(data, providers);
      Future<OriginalImageLease> acquire() => reader.acquire(
        readerTranslationPage(data),
        TranslationCancellation(),
      );
      await expectLater(
        acquire(),
        throwsA(
          isA<TranslationFailure>().having(
            (e) => e.code,
            'code',
            'SOURCE_MISSING',
          ),
        ),
      );
      available = true;
      requests = 0;
      final pending = acquire();
      final displayed = (await data.readerFile(providers))!;
      final lease = await pending;
      expect(lease.file.path, displayed.path);
      expect(requests, 1);
      final input = await TranslationImageWork(dir)
          .prepare(lease.file, TranslationCancellation());
      expect(
        img.decodePng(await input.file.readAsBytes())!.getPixel(0, 0).r,
        160,
      );
      lease.release();
      available = false;
      (await acquire()).release();
      expect(requests, 1);
      data.pageUrl = PageUrl('data:image/png;base64,${base64Encode(raw)}');
      final inline = await acquire();
      expect(await inline.file.readAsBytes(), raw);
      inline.release();
    },
  );

  testWidgets(
    'split pages share one result, preserve source data and release decoded projections in background',
    (tester) async {
      final runtime = _LocalRuntime();
      final service = _LocalService(runtime);
      final index = ValueNotifier<int?>(0);
      UChapDataPreload source(double x) => UChapDataPreload(
        null,
        null,
        null,
        true,
        null,
        0,
        null,
        0,
        localImagePath: '/synthetic-original.png',
        srcRect: Rect.fromLTWH(x, 0, 100, 80),
      )..resolvedFilePath = '/synthetic-original.png';
      final left = source(0), right = source(100);
      late UChapDataPreload shownLeft, shownRight;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [translationServiceProvider.overrideWithValue(service)],
          child: MaterialApp(
            locale: const Locale('zh'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ReaderTranslationHost(
              pages: [left, right],
              visibleCount: 2,
              pageListenable: index,
              actualIndex: () => index.value!,
              child: Builder(
                builder: (context) {
                  shownLeft = ReaderTranslationHost.display(context, left);
                  shownRight = ReaderTranslationHost.display(context, right);
                  return Scaffold(
                    appBar: AppBar(
                      actions: [ReaderTranslationHost.button(context)],
                    ),
                    bottomNavigationBar: ReaderTranslationHost.button(
                      context,
                      labeled: true,
                    ),
                    body: ReaderTranslationHost.withStatus(
                      context,
                      left,
                      child: const SizedBox(width: 240, height: 300),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(runtime.window, hasLength(1));
      expect(runtime.reads, 0);
      expect(runtime.automatic, isFalse);
      expect(identical(shownLeft, left), isTrue);
      await tester.tap(find.text('原图'));
      await tester.pumpAndSettle();
      expect(runtime.reads, 1);
      expect(runtime.automatic, isTrue);
      expect(find.byType(TranslationImageBadge), findsNothing);
      expect(find.byTooltip('图片更多操作'), findsNothing);
      expect(find.text('已翻译'), findsNothing);
      expect(shownLeft.srcRect, const Rect.fromLTWH(0, 0, 50, 40));
      expect(shownRight.srcRect, const Rect.fromLTWH(50, 0, 50, 40));
      expect(left.resolvedFilePath, '/synthetic-original.png');
      expect(right.resolvedFilePath, '/synthetic-original.png');

      await tester.tap(find.text('译图'));
      await tester.pumpAndSettle();
      expect(runtime.automatic, isFalse);
      expect(identical(shownLeft, left), isTrue);
      expect(identical(shownRight, right), isTrue);
      await tester.tap(find.text('原图'));
      await tester.pumpAndSettle();
      expect(runtime.automatic, isTrue);
      expect(runtime.reads, 1);

      final recorder = ui.PictureRecorder();
      ui.Canvas(recorder).drawRect(const Rect.fromLTWH(0, 0, 1, 1), Paint());
      final picture = recorder.endRecording();
      final decoded = picture.toImageSync(1, 1);
      picture.dispose();
      final originalDecoded = decoded.clone();
      left.decodedImage = originalDecoded;
      shownLeft.decodedImage = decoded;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(runtime.window, isEmpty);
      expect(runtime.releases, 1);
      expect(decoded.debugDisposed, isTrue);
      expect(originalDecoded.debugDisposed, isFalse);

      // Paused applications release resources without scheduling a new frame.
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpWidget(const SizedBox());
      originalDecoded.dispose();
      index.dispose();
      service.dispose();
    },
  );
}
