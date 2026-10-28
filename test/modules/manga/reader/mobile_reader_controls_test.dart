import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_widgets.dart';
import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/services/translation/contracts.dart';

void main() {
  Future<void> mount(
    WidgetTester tester,
    Widget child, {
    double height = 600,
  }) async {
    tester.view.physicalSize = Size(320, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(2),
            padding: const EdgeInsets.only(top: 24, bottom: 24),
            viewPadding: const EdgeInsets.only(top: 24, bottom: 24),
          ),
          child: child!,
        ),
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets(
    'reader chrome keeps page geometry and yields hidden taps and semantics',
    (tester) async {
      var visible = true;
      var pageTaps = 0;
      var settingsTaps = 0;
      var pageScrolls = 0;
      late StateSetter change;
      final semantics = tester.ensureSemantics();
      try {
        await mount(
          tester,
          StatefulBuilder(
            builder: (context, setState) {
              change = setState;
              return NotificationListener<ScrollNotification>(
                onNotification: (_) {
                  pageScrolls++;
                  return false;
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        key: const Key('page'),
                        behavior: HitTestBehavior.opaque,
                        onTap: () => pageTaps++,
                        child: const ColoredBox(color: Colors.black),
                      ),
                    ),
                    MobileReaderPanel(
                      visible: visible,
                      top: true,
                      child: MobileReaderHeading(
                        title: 'A long manga title',
                        chapter: 'Chapter 123 — extended chapter title',
                        onBack: () {},
                        menu: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ),
                    ),
                    MobileReaderPanel(
                      visible: visible,
                      top: false,
                      child: Column(
                        children: [
                          MobileReaderProgress(
                            currentIndex: 0,
                            totalPages: 10,
                            label: '1',
                            reverse: false,
                            previousLabel: 'Previous',
                            nextLabel: 'Next',
                            onChanged: (_) {},
                            onChangeEnd: (_) {},
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final label in [
                                'Chapters',
                                'Translate',
                                'Display',
                                'Settings',
                              ])
                                Expanded(
                                  child: MobileReaderAction(
                                    label: label,
                                    icon: Icons.tune,
                                    onPressed: () {
                                      if (label == 'Settings') settingsTaps++;
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          height: 400,
        );
        final pageSize = tester.getSize(find.byKey(const Key('page')));
        await tester.ensureVisible(find.text('Settings'));
        expect(
          Scrollable.of(tester.element(find.text('Settings'))).position.pixels,
          greaterThan(0),
        );
        await tester.tap(find.text('Settings'));
        expect(settingsTaps, 1);
        expect(pageTaps, 0);
        expect(pageScrolls, 0);
        change(() => visible = false);
        await tester.pumpAndSettle();
        expect(tester.getSize(find.byKey(const Key('page'))), pageSize);
        expect(
          tester.semantics.simulatedAccessibilityTraversal().map(
            (node) => node.getSemanticsData().label,
          ),
          isNot(contains('Settings')),
        );
        await tester.tapAt(const Offset(160, 350));
        expect(pageTaps, 1);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets(
    'progress uses reading direction and one navigation commit per gesture',
    (tester) async {
      for (final reverse in [false, true]) {
        final changes = <int>[];
        final commits = <int>[];
        await mount(
          tester,
          Center(
            child: MobileReaderProgress(
              currentIndex: 0,
              totalPages: 10,
              label: '1',
              reverse: reverse,
              previousLabel: 'Previous',
              nextLabel: 'Next',
              onChanged: changes.add,
              onChangeEnd: commits.add,
            ),
          ),
        );
        final slider = tester.getRect(find.byType(Slider));
        await tester.tapAt(
          reverse
              ? slider.centerLeft + const Offset(2, 0)
              : slider.centerRight - const Offset(2, 0),
        );
        expect(changes.last, 9);
        expect(commits, [9]);
      }
      final commits = <int>[];
      for (final total in [0, 1]) {
        await mount(
          tester,
          Center(
            child: MobileReaderProgress(
              currentIndex: 0,
              totalPages: total,
              label: '$total',
              reverse: false,
              previousLabel: 'Previous',
              nextLabel: 'Next',
              onChanged: commits.add,
              onChangeEnd: commits.add,
            ),
          ),
        );
        await tester.tap(find.byType(Slider));
      }
      expect(commits, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('large-text reader settings tabs and close remain reachable', (
    tester,
  ) async {
    var closes = 0;
    await mount(
      tester,
      MobileReaderSettingsTabs(
        labels: const ['Reading mode', 'General', 'Custom filter'],
        closeLabel: 'Close',
        onClose: () => closes++,
        children: const [
          SingleChildScrollView(child: Text('Reading options')),
          SingleChildScrollView(child: Text('General options')),
          SingleChildScrollView(child: Text('Color options')),
        ],
      ),
    );
    await tester.ensureVisible(find.text('Custom filter'));
    await tester.tap(find.text('Custom filter'));
    await tester.pumpAndSettle();
    expect(find.text('Color options'), findsOneWidget);
    await tester.tap(find.byTooltip('Close'));
    expect(closes, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'original and translated display switches do not enable translation',
    (tester) async {
      final controller = TranslationViewController();
      addTearDown(controller.dispose);
      controller.window([
        TranslationTarget(
          const TranslationPage('preview', '1'),
          _NoImageRead(),
        ),
      ]);
      await mount(
        tester,
        TranslationControlsContent(controller: controller, mobile: true),
      );
      expect(find.textContaining('第 1 张'), findsNothing);
      for (var i = 0; i < 2; i++) {
        await tester.ensureVisible(find.text('原图'));
        await tester.tap(find.text('原图'));
        await tester.pump();
        expect(controller.showTranslation, isFalse);
        expect(controller.enabled, isFalse);
        await tester.tap(find.text('译图'));
        await tester.pump();
        expect(controller.showTranslation, isTrue);
        expect(controller.enabled, isFalse);
      }
      expect(tester.takeException(), isNull);
    },
  );
}

class _NoImageRead implements SourceImageReader {
  @override
  Future<OriginalImageLease> acquire(
    TranslationPage page,
    TranslationCancellation cancellation,
  ) => throw StateError('Display controls must not read source images');
}
