import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_content_status.dart';

void main() {
  testWidgets('chapter retry scrolls clear of bottom floating controls', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    var retries = 0;
    final boundary =
        UChapDataPreload.transition(
            currentChapter: Chapter(id: 1, mangaId: 1, name: 'Chapter'),
            pageIndex: 1,
          )
          ..nextChapterState = NextChapterState.failed
          ..onRetryChapter = () => retries++;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: const MediaQueryData(viewPadding: EdgeInsets.only(bottom: 34)),
          child: Scaffold(
            body: Stack(
              children: [
                ListView(
                  controller: scroll,
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 800),
                    ReaderChapterBoundary(data: boundary),
                  ],
                ),
                const Positioned(
                  bottom: 42,
                  right: 12,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: ColoredBox(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    scroll.jumpTo(scroll.position.maxScrollExtent);
    await tester.pump();
    expect(
      tester.getBottomRight(find.byType(ReaderContentStatus)).dy,
      lessThanOrEqualTo(514),
    );
    await tester.tap(find.text('Retry'));
    expect(retries, 1);
    expect(tester.takeException(), isNull);
  });

  for (final (width, scale) in [(390.0, 1.0), (320.0, 2.0)]) {
    testWidgets('wide Chinese error and usable retry at $width / $scale', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var retries = 0;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 80),
                ReaderContentStatus(
                  message: '下一章暂时无法加载',
                  description: '请检查网络后重试',
                  onRetry: () => retries++,
                ),
                const Text('Following manga page'),
              ],
            ),
          ),
        ),
      );
      final title = find.text('下一章暂时无法加载');
      final paragraph = tester.renderObject<RenderParagraph>(title);
      final retry = find.widgetWithText(TextButton, '重试');
      expect(paragraph.constraints.maxWidth, greaterThan(230));
      if (scale == 1) {
        expect(
          paragraph
              .getBoxesForSelection(
                const TextSelection(baseOffset: 0, extentOffset: 10),
              )
              .length,
          1,
        );
        expect(
          tester.getSize(find.byType(ReaderContentStatus)).height,
          lessThan(100),
        );
      } else {
        expect(
          tester.getTopLeft(retry).dy,
          greaterThan(tester.getBottomLeft(title).dy),
        );
      }
      expect(tester.getSize(retry).height, greaterThanOrEqualTo(44));
      await tester.tap(retry);
      expect(retries, 1);
      expect(find.text('Following manga page'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('loading stays compact and respects reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: const Scaffold(
            body: Column(
              children: [
                ReaderContentStatus(message: '正在加载下一章…', loading: true),
              ],
            ),
          ),
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(ReaderContentStatus)).height,
      lessThan(80),
    );
    expect(
      tester
          .widget<CircularProgressIndicator>(
            find.byType(CircularProgressIndicator),
          )
          .value,
      isNotNull,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
