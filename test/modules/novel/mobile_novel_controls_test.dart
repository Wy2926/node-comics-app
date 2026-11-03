import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_widgets.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/tts/mobile_tts_player_controls.dart';
import 'package:mangayomi/modules/novel/tts/tts_player_bar.dart';
import 'package:mangayomi/modules/novel/widgets/mobile_novel_controls.dart';
import 'package:mangayomi/modules/novel/widgets/mobile_novel_session_settings.dart';

void main() {
  late ValueNotifier<double> scale;
  setUp(() => scale = ValueNotifier(2.5));
  tearDown(() => scale.dispose());

  Future<void> start(
    WidgetTester tester,
    Widget child, {
    ProviderContainer? container,
  }) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final app = MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => ValueListenableBuilder(
        valueListenable: scale,
        builder: (_, value, _) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(value),
            padding: const EdgeInsets.only(top: 24, bottom: 34),
          ),
          child: child!,
        ),
      ),
      home: child,
    );
    await tester.pumpWidget(
      container == null
          ? app
          : UncontrolledProviderScope(container: container, child: app),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'novel controls preserve the viewport, isolate scrolling and keep independent actions',
    (tester) async {
      final visible = ValueNotifier(true);
      addTearDown(visible.dispose);
      final actions = <String>[];
      var pageScrolls = 0, pageTaps = 0;
      final seeks = <double>[];
      await start(
        tester,
        Scaffold(
          body: NotificationListener<ScrollNotification>(
            onNotification: (_) {
              pageScrolls++;
              return false;
            },
            child: ValueListenableBuilder(
              valueListenable: visible,
              builder: (_, shown, _) => Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => pageTaps++,
                      child: const ColoredBox(
                        key: ValueKey('page-viewport'),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  MobileNovelPanel(
                    controlsVisible: shown,
                    controls: MobileNovelControls(
                      progress: .42,
                      progressLabel: '41–42 / 160',
                      chapterAction: NodeLaneToolbarAction(
                        label: 'Chapters',
                        icon: Icons.list,
                        onPressed: () => actions.add('chapters'),
                      ),
                      onFontSize: () => actions.add('font'),
                      onSettings: () => actions.add('settings'),
                      onListen: () => actions.add('listen'),
                      listening: false,
                      onNextChapter: () => actions.add('next'),
                      onSeek: seeks.add,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      final viewport = tester.getRect(
        find.byKey(const ValueKey('page-viewport')),
      );
      expect(
        tester
            .widget<IconButton>(
              find.widgetWithIcon(IconButton, Icons.skip_previous_rounded),
            )
            .onPressed,
        isNull,
      );
      await tap(tester, find.byTooltip('Next chapter'));
      await tap(tester, find.text('Chapters'));
      await tap(tester, find.text('Font size'));
      await tap(tester, find.text('Text-to-Speech'));
      await tap(tester, find.text('Settings'));
      expect(actions, ['next', 'chapters', 'font', 'listen', 'settings']);
      expect(pageScrolls, 0);
      await tester.ensureVisible(find.byType(Slider));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Slider), const Offset(30, 0));
      expect(seeks, isNotEmpty);
      expect(seeks.every((value) => value >= 0 && value <= 1), isTrue);
      visible.value = false;
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byKey(const ValueKey('page-viewport'))),
        viewport,
      );
      await tester.tapAt(const Offset(180, 650));
      expect(pageTaps, 1);
      expect(find.text('Settings'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'hidden reader panels do not paint into the surrounding safe area',
    (tester) async {
      final visible = ValueNotifier(false);
      addTearDown(visible.dispose);
      final boundary = GlobalKey();
      await start(
        tester,
        Scaffold(
          body: RepaintBoundary(
            key: boundary,
            child: ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: visible,
                      builder: (_, shown, _) => MobileReaderPanel(
                        visible: shown,
                        top: true,
                        child: const SizedBox(
                          height: 40,
                          child: ColoredBox(color: Color(0xffff0000)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      Future<List<int>> pixel(int y) async {
        final image =
            await (boundary.currentContext!.findRenderObject()
                    as RenderRepaintBoundary)
                .toImage(pixelRatio: 1);
        final bytes = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        final at = (y * image.width + 180) * 4;
        final rgb = [for (var i = 0; i < 3; i++) bytes!.getUint8(at + i)];
        image.dispose();
        return rgb;
      }

      expect(await tester.runAsync(() => pixel(45)), [255, 255, 255]);
      visible.value = true;
      await tester.pumpAndSettle();
      expect(await tester.runAsync(() => pixel(120)), [255, 0, 0]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'font controls commit only on release, retain presets and close at large text',
    (tester) async {
      var value = 16;
      final writes = <int>[];
      await start(
        tester,
        Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) => SizedBox(
                    height: 430,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: MobileNovelFontSize(
                          value: value,
                          onChanged: (next) {
                            writes.add(next);
                            setState(() => value = next);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tap(tester, find.text('Open'));
      final slider = find.byType(Slider);
      await tester.ensureVisible(slider);
      await tester.pumpAndSettle();
      final gesture = await tester.startGesture(tester.getCenter(slider));
      await gesture.moveBy(const Offset(25, 0));
      await tester.pump();
      expect(writes, isEmpty);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(writes, hasLength(1));
      await tap(tester, find.widgetWithText(ChoiceChip, '28'));
      expect(writes.last, 28);
      await tap(tester, find.byTooltip('Close'));
      expect(find.byType(MobileNovelFontSize), findsNothing);
      final before = writes.length;
      await tap(tester, find.text('Open'));
      expect(find.text('28 px'), findsOneWidget);
      await tap(tester, find.byTooltip('Close'));
      expect(writes, hasLength(before));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'session settings cancel without writes, preserve hidden modes and use original auto-scroll values',
    (tester) async {
      final auto = ValueNotifier(false), speed = ValueNotifier(10.0);
      addTearDown(auto.dispose);
      addTearDown(speed.dispose);
      final modes = <ReaderMode>[], pages = <PageMode>[], speeds = <double>[];
      final container = ProviderContainer(
        overrides: [doublePageAutoStateProvider.overrideWith(_AutoPages.new)],
      );
      addTearDown(container.dispose);
      await start(
        tester,
        Scaffold(
          body: SingleChildScrollView(
            child: MobileNovelSessionSettings(
              readerMode: ReaderMode.ltr,
              pageMode: PageMode.doublePage,
              autoScroll: auto,
              speed: speed,
              onReaderModeChanged: modes.add,
              onPageModeChanged: pages.add,
              onAutoScrollChanged: (value) => auto.value = value,
              onSpeedPreview: (value) => speed.value = value,
              onSpeedChanged: speeds.add,
            ),
          ),
        ),
        container: container,
      );
      await tap(tester, find.text('Reading mode').last);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(modes, isEmpty);
      await tap(tester, find.text('Page mode'));
      await tap(tester, find.text('Single page'));
      expect(pages, [PageMode.onePage]);
      expect(container.read(doublePageAutoStateProvider), isFalse);
      await tap(tester, find.text('Reading mode').last);
      await tap(tester, find.text('Vertical continuous'));
      expect(modes, [ReaderMode.verticalContinuous]);
      expect(find.text('Page mode'), findsNothing);
      expect(find.byType(Slider), findsNothing);
      await tap(tester, find.text('Auto scroll'));
      expect(auto.value, isTrue);
      final slider = find.byType(Slider);
      await tester.ensureVisible(slider);
      await tester.pumpAndSettle();
      final gesture = await tester.startGesture(tester.getCenter(slider));
      await gesture.moveBy(const Offset(25, 0));
      await tester.pump();
      expect(speeds, isEmpty);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(speeds, hasLength(1));
      expect(speed.value, speeds.single);
      await tap(tester, find.text('Auto scroll'));
      expect(find.byType(Slider), findsNothing);
      await tap(tester, find.text('Auto scroll'));
      expect(tester.widget<Slider>(slider).value, speeds.single);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'speech controls survive toolbar toggles, block pending commands and stop once; late setup never speaks',
    (tester) async {
      const channel = MethodChannel('flutter_tts');
      final calls = <String>[];
      final utterance = Completer<int>();
      Completer<int>? pause, delayedRate;
      var failRate = false;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        calls.add(call.method);
        if (call.method == 'speak') return utterance.future;
        if (call.method == 'pause' && pause != null) return pause.future;
        if (call.method == 'setSpeechRate') {
          if (failRate) throw PlatformException(code: 'sample-init-failure');
          if (delayedRate != null) return delayedRate.future;
        }
        return 1;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      final container = ProviderContainer(
        overrides: [
          ttsSpeechRateStateProvider.overrideWith(_Rate.new),
          ttsPitchStateProvider.overrideWith(_Pitch.new),
          ttsLanguageStateProvider.overrideWith(_Language.new),
        ],
      );
      addTearDown(container.dispose);
      final controls = ValueNotifier(true), player = ValueNotifier(true);
      addTearDown(controls.dispose);
      addTearDown(player.dispose);
      var closes = 0;
      Widget home() => Scaffold(
        body: ListenableBuilder(
          listenable: Listenable.merge([controls, player]),
          builder: (_, _) => Stack(
            children: [
              const Positioned.fill(child: ColoredBox(color: Colors.white)),
              MobileNovelPanel(
                controlsVisible: controls.value,
                controls: const Text('Reader tools'),
                player: player.value
                    ? TtsPlayerBar(
                        key: const ValueKey('player'),
                        mobile: true,
                        htmlContent: '<p>First sample paragraph.</p><p>Second sample paragraph.</p>',
                        onClose: () {
                          closes++;
                          player.value = false;
                        },
                      )
                    : null,
              ),
            ],
          ),
        ),
      );
      await start(tester, home(), container: container);
      expect(calls.where((call) => call == 'speak'), hasLength(1));
      final before = tester.state(find.byType(TtsPlayerBar));
      controls.value = false;
      await tester.pumpAndSettle();
      controls.value = true;
      await tester.pumpAndSettle();
      expect(tester.state(find.byType(TtsPlayerBar)), same(before));
      expect(calls.where((call) => call == 'speak'), hasLength(1));
      pause = Completer<int>();
      await tap(tester, find.text('Pause'));
      await tap(tester, find.text('Pause'));
      expect(calls.where((call) => call == 'pause'), hasLength(1));
      pause.complete(1);
      await tester.pumpAndSettle();
      expect(find.text('Play'), findsOneWidget);
      await tap(tester, find.byTooltip('Stop'));
      expect(closes, 1);
      expect(find.byType(TtsPlayerBar), findsNothing);
      utterance.complete(1);
      await tester.pumpAndSettle();

      failRate = true;
      player.value = true;
      await tester.pumpAndSettle();
      expect(find.text('Failed!'), findsOneWidget);
      final failedView = tester.widget<MobileTtsPlayerControls>(
        find.byType(MobileTtsPlayerControls),
      );
      expect(failedView.failed, isTrue);
      await tap(tester, find.byTooltip('Stop'));
      expect(closes, 2);
      failRate = false;
      delayedRate = Completer<int>();
      player.value = true;
      await tester.pumpAndSettle();
      final speaksBeforeDispose = calls.where((call) => call == 'speak').length;
      player.value = false;
      await tester.pumpAndSettle();
      delayedRate.complete(1);
      await tester.pumpAndSettle();
      expect(
        calls.where((call) => call == 'speak'),
        hasLength(speaksBeforeDispose),
      );
      expect(tester.takeException(), isNull);
    },
  );
}

class _AutoPages extends DoublePageAutoState {
  @override
  bool build() => true;
  @override
  void set(bool value) => state = value;
}

class _Rate extends TtsSpeechRateState {
  @override
  double build() => .5;
}

class _Pitch extends TtsPitchState {
  @override
  double build() => 1;
}

class _Language extends TtsLanguageState {
  @override
  String? build() => null;
}
