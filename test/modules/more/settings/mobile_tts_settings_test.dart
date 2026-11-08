import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/novel/tts/mobile_tts_settings.dart';

void main() {
  var scale = 1.0, keyboard = 0.0, speed = 0.5, pitch = 1.0;
  String? language = 'en-NZ';
  final writes = <(String, Object?)>[];
  final calls = <(String, Object?)>[];
  late Future<List<dynamic>> Function() load;
  Future<void> Function()? apply;
  var loads = 0;
  late StateSetter rebuild;

  Widget app() => MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(scale),
        padding: const EdgeInsets.only(top: 24, bottom: 34),
        viewInsets: EdgeInsets.only(bottom: keyboard),
      ),
      child: child!,
    ),
    home: StatefulBuilder(
      builder: (context, setState) {
        rebuild = setState;
        return Scaffold(
          appBar: AppBar(title: const Text('Speech settings')),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: MobileTtsSettings(
                speed: speed,
                pitch: pitch,
                language: language,
                loadLanguages: () {
                  loads++;
                  return load();
                },
                onSpeedChanged: (value) async {
                  if (value != speed) {
                    writes.add(('speed', value));
                    setState(() => speed = value);
                  }
                  calls.add(('speed', value));
                  await apply?.call();
                },
                onPitchChanged: (value) async {
                  if (value != pitch) {
                    writes.add(('pitch', value));
                    setState(() => pitch = value);
                  }
                  calls.add(('pitch', value));
                  await apply?.call();
                },
                onLanguageChanged: (value) async {
                  if (value != language) {
                    writes.add(('language', value));
                    setState(() => language = value);
                  }
                  // Same default rule as the existing service adapter.
                  if (value != null) calls.add(('language', value));
                  await apply?.call();
                },
              ),
            ),
          ),
        );
      },
    ),
  );

  setUp(() {
    scale = 1;
    keyboard = 0;
    speed = 0.5;
    pitch = 1;
    language = 'en-NZ';
    writes.clear();
    calls.clear();
    loads = 0;
    apply = null;
    load = () async => ['en-US', 'zh-CN', 'en-US', null, 42, ''];
  });
  void viewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<void> reveal(
    WidgetTester tester,
    Finder finder, {
    double delta = 250,
  }) async {
    await tester.scrollUntilVisible(
      finder,
      delta,
      scrollable: find.byType(Scrollable).first,
    );
    await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
    await tester.pumpAndSettle();
  }

  Future<void> openLanguage(WidgetTester tester) async {
    final tile = find.byType(NodeLaneRow);
    await reveal(tester, tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'large text language search keeps missing values and distinguishes cancel from default',
    (tester) async {
      viewport(tester);
      scale = 2.5;
      final pending = Completer<List<dynamic>>();
      load = () => pending.future;
      await tester.pumpWidget(app());
      await tester.pump();
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(
        tester.widget<Slider>(find.byType(Slider).first).onChanged,
        isNull,
      );
      expect(
        tester.widget<NodeLaneRow>(find.byType(NodeLaneRow)).onTap,
        isNull,
      );
      expect(writes, isEmpty);
      pending.complete(['en-US', 'zh-CN', 'en-US', null, 42, '']);
      await tester.pumpAndSettle();
      expect(
        find.text('This saved language is not in the device’s current list.'),
        findsOneWidget,
      );
      await openLanguage(tester);
      await tester.enterText(find.byType(TextField), 'en-US');
      await tester.pumpAndSettle();
      expect(find.widgetWithText(NodeLaneRow, 'en-US'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'not-a-language');
      keyboard = 180;
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(find.text('No result'), findsOneWidget);
      await tester.tap(find.byTooltip('Reset'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(language, 'en-NZ');
      expect(writes, isEmpty);
      keyboard = 0;
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await openLanguage(tester);
      await tester.tap(find.widgetWithText(NodeLaneRow, 'Default'));
      await tester.pumpAndSettle();
      expect(language, isNull);
      expect(writes, [('language', null)]);
      expect(calls, isEmpty);
      await openLanguage(tester);
      await tester.enterText(find.byType(TextField), 'zh-CN');
      await tester.pumpAndSettle();
      final chinese = find.widgetWithText(NodeLaneRow, '中文 (简体)');
      await reveal(tester, chinese);
      await tester.tap(chinese);
      await tester.pumpAndSettle();
      expect(language, 'zh-CN');
      expect(calls, [('language', 'zh-CN')]);
      expect(speed, 0.5);
      expect(pitch, 1);
      expect(loads, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sliders apply once at release and a failed apply can retry without duplicate persistence',
    (tester) async {
      viewport(tester);
      scale = 2.5;
      language = null;
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      final pending = Completer<void>();
      apply = () => pending.future;
      final slider = find.descendant(
        of: find.byKey(const ValueKey('tts-speed')),
        matching: find.byType(Slider),
      );
      await reveal(tester, slider);
      final gesture = await tester.startGesture(tester.getCenter(slider));
      await gesture.moveBy(const Offset(35, 0));
      await tester.pump();
      expect(writes, isEmpty);
      expect(calls, isEmpty);
      await gesture.up();
      await tester.pump();
      expect(writes, hasLength(1));
      expect(calls, hasLength(1));
      expect(calls.single.$1, 'speed');
      expect(pitch, 1);
      expect(language, isNull);
      for (final control in tester.widgetList<Slider>(find.byType(Slider))) {
        expect(control.onChanged, isNull);
      }
      pending.completeError(StateError('private engine details'));
      await tester.pumpAndSettle();
      expect(find.textContaining('private engine details'), findsNothing);
      final retry = find.byKey(const ValueKey('tts-retry-apply'));
      await reveal(tester, retry);
      final retryAction = tester.widget<TextButton>(retry).onPressed!;
      final retryPending = Completer<void>();
      apply = () => retryPending.future;
      retryAction();
      retryAction();
      await tester.pump();
      expect(calls, hasLength(2));
      expect(writes, hasLength(1));
      expect(calls[0], calls[1]);
      retryPending.complete();
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('tts-retry-apply')), findsNothing);
      final savedSpeed = speed;
      apply = null;
      final pitchSlider = find.descendant(
        of: find.byKey(const ValueKey('tts-pitch')),
        matching: find.byType(Slider),
      );
      await reveal(tester, pitchSlider, delta: -250);
      await tester.drag(pitchSlider, const Offset(30, 0));
      await tester.pumpAndSettle();
      expect(writes, hasLength(2));
      expect(calls, hasLength(3));
      expect(calls.last.$1, 'pitch');
      expect(speed, savedSpeed);
      expect(loads, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'language loading failure retries once, handles empty results and ignores completion after leaving',
    (tester) async {
      viewport(tester);
      final first = Completer<List<dynamic>>();
      load = () => first.future;
      await tester.pumpWidget(app());
      first.completeError(StateError('private path'));
      await tester.pumpAndSettle();
      expect(find.textContaining('private path'), findsNothing);
      final retry = find.byKey(const ValueKey('tts-retry-languages'));
      await reveal(tester, retry);
      final retryAction = tester.widget<TextButton>(retry).onPressed!;
      final second = Completer<List<dynamic>>();
      load = () => second.future;
      retryAction();
      retryAction();
      await tester.pump();
      expect(loads, 2);
      rebuild(() {});
      await tester.pump();
      expect(loads, 2);
      second.complete([]);
      await tester.pumpAndSettle();
      expect(
        find.text(
          'The speech engine returned no languages. Your saved selection is kept.',
        ),
        findsOneWidget,
      );
      expect(language, 'en-NZ');
      expect(writes, isEmpty);
      expect(calls, isEmpty);
      await openLanguage(tester);
      final saved = find.widgetWithText(NodeLaneRow, 'en-NZ');
      await reveal(tester, saved);
      await tester.tap(saved);
      await tester.pumpAndSettle();
      expect(writes, isEmpty);
      expect(calls, isEmpty);
      await tester.pumpWidget(const SizedBox.shrink());
      final lateLoad = Completer<List<dynamic>>();
      load = () => lateLoad.future;
      await tester.pumpWidget(app());
      expect(loads, 3);
      await tester.pumpWidget(const SizedBox.shrink());
      lateLoad.completeError(StateError('late failure'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
