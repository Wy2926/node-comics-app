import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
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
import 'package:mangayomi/modules/manga/reader/utils/reader_page_window.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_preferences.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_scope.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_overlays.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/translation_service.dart';

import '../../helpers/pricing_launcher.dart';

class _LocalRuntime implements ChannelRuntime {
  final _changes = StreamController<void>.broadcast();
  List<TranslationTarget> window = [];
  int reads = 0, releases = 0;
  bool automatic = false;
  PageTranslationState? failure;
  final performed = <TranslationAction>[];
  @override
  Stream<void> get changes => _changes.stream;
  @override
  PageTranslationState stateFor(TranslationPage page) =>
      failure ??
      PageTranslationState(
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
  ) async {
    performed.add(action);
  }

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
  testWidgets(
    'translation retry and upgrade receive taps through page zones; surrounding taps still navigate',
    (tester) async {
      final page = UChapDataPreload(null, null, null, true, null, 0, null, 0);
      final window = ValueNotifier([page]);
      final runtime = _LocalRuntime()
        ..failure = const PageTranslationState(
          phase: TranslationPhase.failed,
          actions: {TranslationAction.retry},
        );
      final service = _LocalService(runtime);
      final launcher = PricingLauncher.install();
      int navigation = 0;
      void turn() => navigation++;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [translationServiceProvider.overrideWithValue(service)],
          child: MaterialApp(
            locale: const Locale('zh'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            home: Scaffold(
              body: ComicReaderScope(
                profile: const ComicBookSettings(mode: ComicReadingMode.paged)
                    .resolve(const ComicReaderDefaults()),
                habits: const ComicReaderHabits(),
                child: ReaderTranslationHost(
                  window: window,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Builder(
                          builder: (context) =>
                              ReaderTranslationHost.withStatus(
                                context,
                                page,
                                child: const SizedBox.expand(),
                              ),
                        ),
                      ),
                      Positioned.fill(
                        child: ReaderOverlays(
                          isReverseHorizontal: false,
                          hasCurrentPageImageError: false,
                          isContinuousMode: false,
                          onToggleUI: turn,
                          onPreviousPage: turn,
                          onNextPage: turn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('重试'));
      await tester.pumpAndSettle();
      expect(runtime.performed, [TranslationAction.retry]);
      expect(navigation, 0);
      runtime.failure = const PageTranslationState(
        phase: TranslationPhase.failed,
        failure: TranslationFailure('QUOTA_EXHAUSTED'),
        actions: {TranslationAction.retry},
      );
      runtime._changes.add(null);
      await tester.pumpAndSettle();
      expect(find.text('额度不足'), findsOneWidget);
      expect(find.textContaining('连接失败'), findsNothing);
      launcher.pending = Completer<bool>();
      await tester.tap(find.text('升级'));
      launcher.pending!.complete(false);
      await tester.pumpAndSettle();
      expect(find.text('网页暂时无法打开'), findsOneWidget);
      launcher.pending = null;
      await tester.tap(find.text('升级'));
      await tester.pump(const Duration(seconds: 7));
      await tester.pumpAndSettle();
      expect(launcher.urls, [publicPricingUrl, publicPricingUrl]);
      expect(runtime.performed, [TranslationAction.retry]);
      expect(navigation, 0);
      await tester.tapAt(const Offset(12, 200));
      await tester.pumpAndSettle();
      expect(navigation, 1);
      await tester.pumpWidget(const SizedBox());
      window.dispose();
      service.dispose();
    },
  );
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
    'split pages share one result, preserve source data and release display leases in background',
    (tester) async {
      final runtime = _LocalRuntime();
      final service = _LocalService(runtime);
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
      final window = ValueNotifier(
        ReaderPageWindow([left, right], 0, 1, backward: false).forward,
      );
      late UChapDataPreload shownLeft, shownRight;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [translationServiceProvider.overrideWithValue(service)],
          child: MaterialApp(
            locale: const Locale('zh'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ReaderTranslationHost(
              window: window,
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

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(runtime.window, isEmpty);
      expect(runtime.releases, 1);
      expect(
        ReaderTranslationHost.controllerOf(
          tester.element(find.byType(Scaffold)),
        )!.images,
        isEmpty,
      );

      // Paused applications release resources without scheduling a new frame.
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpWidget(const SizedBox());
      window.dispose();
      service.dispose();
    },
  );
}
