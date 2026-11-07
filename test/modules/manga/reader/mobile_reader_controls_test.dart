import 'dart:async';

import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_widgets.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_entry_state.dart';
import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/translation_service.dart';

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
      ProviderScope(
        overrides: [
          translationServiceProvider.overrideWith((ref) {
            final service = _TranslationService();
            ref.onDispose(service.dispose);
            return service;
          }),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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
      ),
    );
  }

  testWidgets('chapter entry retains context and bounds retry while leaving', (
    tester,
  ) async {
    final retry = Completer<void>();
    var retries = 0, backs = 0;
    String? failure;
    late StateSetter change;
    await mount(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          change = setState;
          return MobileReaderEntryState(
            bookTitle: 'A long comic title with retained context',
            chapterTitle: 'Chapter 12 — The letter from the sea',
            failureMessage: failure,
            onRetry: () {
              retries++;
              return retry.future;
            },
            onBack: () => backs++,
          );
        },
      ),
      height: 800,
    );
    await tester.pump(const Duration(milliseconds: 50));
    final title = find.text('A long comic title with retained context');
    final before = tester.getTopLeft(title);
    expect(find.text('Getting chapter images…'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Retry'), findsNothing);
    change(() => failure = 'Could not load this chapter');
    await tester.pump();
    expect(tester.getTopLeft(title), before);
    final button = find.widgetWithText(FilledButton, 'Retry');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.tap(button);
    expect(retries, 1);
    await tester.pump();
    expect(find.text('Chapter 12 — The letter from the sea'), findsOneWidget);
    expect(button, findsNothing);
    await tester.tap(find.byTooltip('Back'));
    expect(backs, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    retry.complete();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'reader chrome keeps page geometry and yields hidden input and semantics',
    (tester) async {
      var visible = true;
      var pageTaps = 0;
      var settingsTaps = 0;
      var pageScrolls = 0;
      var pageKeys = 0;
      var sliderChanges = 0;
      final readerFocus = FocusNode();
      addTearDown(readerFocus.dispose);
      late StateSetter change;
      final semantics = tester.ensureSemantics();
      try {
        await mount(
          tester,
          StatefulBuilder(
            builder: (context, setState) {
              change = setState;
              return ReaderKeyboardHandler(
                onNextPage: () => pageKeys++,
              ).wrapWithKeyboardListener(
                focusNode: readerFocus,
                child: NotificationListener<ScrollNotification>(
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
                              onChanged: (_) => sliderChanges++,
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
                                    child: NodeLaneToolbarAction(
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
        await tester.ensureVisible(find.byType(Slider));
        await tester.tap(find.byType(Slider));
        tester
            .widget<FocusableActionDetector>(
              find.descendant(
                of: find.byType(Slider),
                matching: find.byType(FocusableActionDetector),
              ),
            )
            .focusNode!
            .requestFocus();
        await tester.pump();
        expect(
          FocusManager.instance.primaryFocus?.context
              ?.findAncestorWidgetOfExactType<Slider>(),
          isNotNull,
        );
        final changesBeforeHide = sliderChanges;
        change(() => visible = false);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        expect(sliderChanges, changesBeforeHide);
        expect(pageKeys, 1);
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

  testWidgets('status rows expose only the available recovery action', (
    tester,
  ) async {
    final runtime = _ProgressRuntime();
    final controller = TranslationViewController()..attach(runtime);
    addTearDown(controller.dispose);
    controller.window([
      TranslationTarget(
        const TranslationPage('preview/1', 'v1'),
        _NoImageRead(),
      ),
      TranslationTarget(
        const TranslationPage('preview/2', 'v1'),
        _NoImageRead(),
      ),
    ]);
    await mount(
      tester,
      TranslationControlsContent(controller: controller, mobile: true),
      height: 900,
    );
    final running = find.ancestor(
      of: find.text('第 1 张 · 正在翻译…'),
      matching: find.byType(ListTile),
    );
    expect(tester.widget<ListTile>(running).onTap, isNull);
    expect(tester.widget<ListTile>(running).trailing, isNull);
    expect(find.byTooltip('本页翻译操作'), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('本页翻译操作'));
    await tester.tap(find.byTooltip('本页翻译操作'));
    // A running page keeps its spinner alive, so do not wait for all animations.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('核实状态'), findsOneWidget);
    expect(find.text('重试本页翻译'), findsNothing);
    await tester.tap(find.text('核实状态'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(runtime.actions, [TranslationAction.verify]);
    expect(tester.takeException(), isNull);
  });
}

class _TranslationService extends TranslationService {
  @override
  Future<void> initialize() async {}
}

class _ProgressRuntime extends Fake implements ChannelRuntime {
  final actions = <TranslationAction>[];
  @override
  Stream<void> get changes => const Stream.empty();
  @override
  void pause(String consumer) {}
  @override
  PageTranslationState stateFor(TranslationPage page) => page.key == 'preview/1'
      ? const PageTranslationState(
          phase: TranslationPhase.running,
          message: '正在翻译…',
        )
      : const PageTranslationState(
          phase: TranslationPhase.uncertain,
          message: '结果待核实',
          actions: {TranslationAction.verify},
        );
  @override
  Future<void> perform(
    TranslationTarget target,
    TranslationAction action,
  ) async {
    actions.add(action);
  }
}

class _NoImageRead implements SourceImageReader {
  @override
  Future<OriginalImageLease> acquire(
    TranslationPage page,
    TranslationCancellation cancellation,
  ) => throw StateError('Display controls must not read source images');
}
