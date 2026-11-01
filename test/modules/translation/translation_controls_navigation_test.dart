import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/more/widgets/mobile_nodelane_account.dart';
import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:mangayomi/modules/translation/translation_settings.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/translation_service.dart';

class _Runtime extends Fake implements ChannelRuntime {
  @override
  Stream<void> get changes => const Stream.empty();
  @override
  void pause(String consumer) {}
  @override
  Future<void> dispose() async {}
}

class _AccountService extends TranslationService {
  Completer<void>? pending;
  int loginCalls = 0;
  @override
  bool get loggedIn => runtime != null;
  @override
  String get accountName => 'Test Reader';
  @override
  Future<void> initialize() async {}
  @override
  Future<void> login() async {
    loginCalls++;
    busy = true;
    error = null;
    pending = Completer<void>();
    notifyListeners();
    await pending!.future;
    busy = false;
    notifyListeners();
  }

  void finishLogin({bool success = false}) {
    if (success) {
      runtime = _Runtime();
    } else {
      error = '登录未完成，请重试';
    }
    pending!.complete();
  }
}

void main() {
  late _AccountService service;
  late TranslationViewController controller;
  late ScrollController readingPosition;
  late GlobalKey readerKey;

  Future<void> mount(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    service = _AccountService();
    controller = TranslationViewController();
    readingPosition = ScrollController(initialScrollOffset: 320);
    readerKey = GlobalKey();
    // Reader and browser hosts already attach the updated service runtime.
    void attach() => controller.attach(service.runtime);
    service.addListener(attach);
    addTearDown(() {
      service.removeListener(attach);
      controller.dispose();
      service.dispose();
      readingPosition.dispose();
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [translationServiceProvider.overrideWithValue(service)],
        child: MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: Builder(
            builder: (context) => Scaffold(
              key: readerKey,
              appBar: AppBar(
                title: const Text('Reader'),
                actions: [
                  IconButton(
                    tooltip: 'Translation',
                    icon: const Icon(Icons.translate),
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => TranslationControlsContent(
                        controller: controller,
                        mobile: true,
                      ),
                    ),
                  ),
                ],
              ),
              body: ListView.builder(
                controller: readingPosition,
                itemExtent: 160,
                itemCount: 20,
                itemBuilder: (_, index) => Text('Page $index'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openLogin(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Translation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('登录后开启翻译'));
    await tester.pumpAndSettle();
    expect(find.byType(TranslationControlsContent), findsNothing);
    expect(find.byType(MobileNodeLaneAccount), findsOneWidget);
    expect(find.byType(TranslationSettings), findsNothing);
    expect(find.text('前往登录'), findsOneWidget);
  }

  testWidgets(
    'login destination has account actions and returns to the reader',
    (tester) async {
      await mount(tester);
      final reader = readerKey.currentState;
      for (var visit = 0; visit < 2; visit++) {
        await openLogin(tester);
        expect(service.loginCalls, 0);
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(readerKey.currentState, same(reader));
        expect(readingPosition.offset, 320);
        expect(find.byType(TranslationControlsContent), findsNothing);
        expect(controller.enabled, isFalse);
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('login failure can retry and settings remains a separate route', (
    tester,
  ) async {
    await mount(tester);
    await openLogin(tester);
    final login = find.widgetWithText(FilledButton, '前往登录');
    await tester.tap(login);
    await tester.pump();
    await tester.tap(login);
    expect(service.loginCalls, 1);
    service.finishLogin();
    await tester.pumpAndSettle();
    expect(find.text('登录未完成，请重试'), findsOneWidget);
    await tester.tap(login);
    await tester.pump();
    service.finishLogin(success: true);
    await tester.pumpAndSettle();
    expect(service.loginCalls, 2);
    expect(find.text('已登录 NodeLane'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(readingPosition.offset, 320);
    await tester.tap(find.byTooltip('Translation'));
    await tester.pumpAndSettle();
    expect(find.text('登录后开启翻译'), findsNothing);
    expect(controller.enabled, isFalse);
    final toggle = tester.widget<SwitchListTile>(
      find.widgetWithText(SwitchListTile, '翻译当前阅读范围'),
    );
    expect(toggle.onChanged, isNotNull);
    await tester.tap(find.text('翻译设置'));
    await tester.pumpAndSettle();
    expect(find.byType(TranslationSettings), findsOneWidget);
    expect(find.text('目标语言'), findsOneWidget);
    expect(find.byType(MobileNodeLaneAccount), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(readingPosition.offset, 320);
    expect(tester.takeException(), isNull);
  });

  testWidgets('translation settings are directly available before login', (
    tester,
  ) async {
    await mount(tester);
    final reader = readerKey.currentState;
    await tester.tap(find.byTooltip('Translation'));
    await tester.pumpAndSettle();
    expect(find.text('登录后开启翻译'), findsOneWidget);
    await tester.tap(find.text('翻译设置'));
    await tester.pumpAndSettle();
    expect(find.byType(TranslationSettings), findsOneWidget);
    expect(find.byType(MobileNodeLaneAccount), findsNothing);
    expect(service.loginCalls, 0);
    expect(controller.enabled, isFalse);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(readerKey.currentState, same(reader));
    expect(readingPosition.offset, 320);
    expect(tester.takeException(), isNull);
  });
}
