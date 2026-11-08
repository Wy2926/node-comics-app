import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:mangayomi/modules/manga/reader/widgets/double_page_view.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_animated_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_preferences.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_scope.dart';
import 'package:mangayomi/modules/manga/reader/controllers/reader_viewport_anchor.dart';
import 'package:mangayomi/modules/manga/reader/image_view_webtoon.dart';
import 'package:mangayomi/modules/manga/reader/image_view_vertical.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class _Frames extends ImageStreamCompleter {
  void emit(ui.Image image) => setImage(ImageInfo(image: image.clone()));
  void fail() => reportError(exception: StateError('fixture image failed'));
}

class _FrameImage extends ImageProvider<_FrameImage> {
  _FrameImage(this.frames);
  _Frames frames;
  @override
  Future<_FrameImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);
  @override
  ImageStreamCompleter loadImage(
    _FrameImage key,
    ImageDecoderCallback decode,
  ) => frames;
}

Future<Color> _pixel(GlobalKey key, int x, int y) async {
  final rendered =
      await (key.currentContext!.findRenderObject() as RenderRepaintBoundary)
          .toImage();
  final bytes = (await rendered.toByteData(
    format: ui.ImageByteFormat.rawRgba,
  ))!;
  final offset = (y * rendered.width + x) * 4;
  final color = Color.fromARGB(
    bytes.getUint8(offset + 3),
    bytes.getUint8(offset),
    bytes.getUint8(offset + 1),
    bytes.getUint8(offset + 2),
  );
  rendered.dispose();
  return color;
}

void main() {
  testWidgets(
    'continuous width, gaps, background and image effects update visibly',
    (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final recorder = ui.PictureRecorder();
      Canvas(recorder).drawRect(
        const Rect.fromLTWH(0, 0, 200, 200),
        Paint()..color = Colors.blue,
      );
      final picture = recorder.endRecording();
      final image = await picture.toImage(200, 200);
      picture.dispose();
      final pages = [
        for (var i = 0; i < 2; i++)
          UChapDataPreload(null, null, null, false, null, i, null, i)
            ..decodedImage = image.clone()
            ..loadedWidth = 200
            ..loadedHeight = 200,
      ];
      addTearDown(() {
        for (final page in pages) {
          page.decodedImage?.dispose();
        }
        image.dispose();
      });
      final scroll = ReaderScrollController(), list = ListController();
      addTearDown(scroll.dispose);
      addTearDown(list.dispose);
      final anchor = ReaderViewportAnchorController();
      addTearDown(anchor.dispose);
      final key = GlobalKey();
      Future<void> mount(ComicBookSettings book, ComicCanvas canvas) async {
        final profile = book
            .copyWith(mode: ComicReadingMode.scroll)
            .resolve(const ComicReaderDefaults());
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: ComicReaderScope(
                profile: profile,
                habits: ComicReaderHabits(canvas: canvas),
                child: RepaintBoundary(
                  key: key,
                  child: Builder(
                    builder: (context) => ImageViewWebtoon(
                      pages: pages,
                      listController: list,
                      scrollController: scroll,
                      viewportAnchor: anchor,
                      minCacheExtent: 800,
                      physics: const ClampingScrollPhysics(),
                      backgroundColor: canvas.color(context),
                      widthFactor: profile.widthFactor,
                      gap: profile.gap ? 8 : 0,
                      onLongPressData: (_) {},
                      onFailedToLoadImage: (_, _) {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      await mount(const ComicBookSettings(), ComicCanvas.black);
      expect(tester.getSize(find.byType(ImageViewVertical).first).width, 400);
      expect(tester.getTopLeft(find.byType(ImageViewVertical).last).dy, 400);
      await mount(
        const ComicBookSettings(width: ComicContentWidth.narrow, gap: true),
        ComicCanvas.paper,
      );
      expect(tester.getSize(find.byType(ImageViewVertical).first).width, 336);
      expect(tester.getTopLeft(find.byType(ImageViewVertical).last).dy, 344);
      expect(
        await tester.runAsync(() => _pixel(key, 10, 100)),
        const Color(0xfff5f1e8),
      );
      expect(
        await tester.runAsync(() => _pixel(key, 100, 340)),
        const Color(0xfff5f1e8),
      );
      expect(
        await tester.runAsync(() => _pixel(key, 100, 100)),
        const Color(0xff2196f3),
      );
      await mount(
        const ComicBookSettings(width: ComicContentWidth.narrow, invert: true),
        ComicCanvas.gray,
      );
      expect(
        await tester.runAsync(() => _pixel(key, 10, 100)),
        const Color(0xff303030),
      );
      expect(
        await tester.runAsync(() => _pixel(key, 100, 100)),
        const Color(0xffde690c),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('double pages paint the selected canvas behind both images', (
    tester,
  ) async {
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawColor(Colors.blue, BlendMode.src);
    final picture = recorder.endRecording();
    final image = await picture.toImage(200, 200);
    picture.dispose();
    final pages = [
      for (var i = 0; i < 2; i++)
        UChapDataPreload(null, null, null, false, null, i, null, i)
          ..decodedImage = image.clone()
          ..loadedWidth = 200
          ..loadedHeight = 200,
    ];
    final key = GlobalKey();
    Future<void> mount(Color canvas) => tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ComicReaderScope(
            profile: const ComicBookSettings(
              mode: ComicReadingMode.paged,
              layout: ComicPageLayout.double,
            ).resolve(const ComicReaderDefaults()),
            habits: const ComicReaderHabits(),
            child: Center(
              child: SizedBox(
                width: 400,
                height: 600,
                child: RepaintBoundary(
                  key: key,
                  child: DoublePageView.paged(
                    pages: pages,
                    backgroundColor: canvas,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await mount(const Color(0xfff5f1e8));
    await tester.pumpAndSettle();
    expect(
      await tester.runAsync(() => _pixel(key, 10, 10)),
      const Color(0xfff5f1e8),
    );
    expect(
      await tester.runAsync(() => _pixel(key, 100, 300)),
      const Color(0xff2196f3),
    );
    await mount(const Color(0xff303030));
    await tester.pumpAndSettle();
    expect(
      await tester.runAsync(() => _pixel(key, 10, 10)),
      const Color(0xff303030),
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    for (final page in pages) {
      page.decodedImage?.dispose();
    }
    image.dispose();
  });

  testWidgets('GIF loading, failure and retry reserve the image column', (
    tester,
  ) async {
    final frames = _Frames();
    final provider = _FrameImage(frames);
    addTearDown(provider.evict);
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawColor(Colors.blue, BlendMode.src);
    final picture = recorder.endRecording();
    final image = await picture.toImage(40, 80);
    picture.dispose();
    addTearDown(image.dispose);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 200,
              child: ReaderAnimatedImage(
                image: provider,
                fit: BoxFit.fitWidth,
                cropBorders: false,
                naturalHeight: true,
                reservedSize: const Size(40, 80),
              ),
            ),
          ),
        ),
      ),
    );
    final reader = find.byType(ReaderAnimatedImage);
    expect(tester.getSize(reader), const Size(200, 400));
    frames.emit(image);
    await tester.pump();
    expect(tester.getSize(reader), const Size(200, 400));
    frames.fail();
    await tester.pump();
    expect(tester.getSize(reader), const Size(200, 400));
    final retry = provider.frames = _Frames();
    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(tester.getSize(reader), const Size(200, 400));
    retry.emit(image);
    await tester.pump();
    expect(tester.getSize(reader), const Size(200, 400));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'animated frames retain crop and reversible half-page selection',
    (tester) async {
      Future<ui.Image> frame(Color left, Color right) async {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);
        canvas.drawColor(Colors.black, BlendMode.src);
        canvas.drawRect(
          const Rect.fromLTWH(4, 4, 16, 12),
          Paint()..color = left,
        );
        canvas.drawRect(
          const Rect.fromLTWH(20, 4, 16, 12),
          Paint()..color = right,
        );
        final picture = recorder.endRecording();
        final image = await picture.toImage(40, 20);
        picture.dispose();
        return image;
      }

      final first = await frame(Colors.red, Colors.blue),
          second = await frame(Colors.green, Colors.yellow);
      final frames = _Frames();
      final imageProvider = _FrameImage(frames);
      final key = GlobalKey();
      Future<void> mount(bool crop, bool? rightHalf, {bool natural = false}) =>
          tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Center(
                child: SizedBox(
                  width: 200,
                  height: natural ? null : 200,
                  child: RepaintBoundary(
                    key: key,
                    child: ReaderAnimatedImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                      cropBorders: crop,
                      rightHalf: rightHalf,
                      naturalHeight: natural,
                    ),
                  ),
                ),
              ),
            ),
          );
      await mount(false, null);
      frames.emit(first);
      await tester.pump();
      expect(await tester.runAsync(() => _pixel(key, 5, 100)), Colors.black);
      await mount(true, false);
      await tester.runAsync(() async {
        await first.toByteData();
      });
      await tester.pump();
      expect(
        await tester.runAsync(() => _pixel(key, 20, 100)),
        const Color(0xfff44336),
      );
      frames.emit(second);
      await tester.pump();
      expect(
        await tester.runAsync(() => _pixel(key, 20, 100)),
        const Color(0xff4caf50),
      );
      await mount(true, true);
      await tester.pump();
      expect(
        await tester.runAsync(() => _pixel(key, 20, 100)),
        const Color(0xffffeb3b),
      );
      await mount(false, null, natural: true);
      await tester.pump();
      expect(tester.getSize(find.byType(ReaderAnimatedImage)).height, 100);
      expect(await tester.runAsync(() => _pixel(key, 5, 50)), Colors.black);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await imageProvider.evict();
      first.dispose();
      second.dispose();
    },
  );
}
