import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/translation/mobile_translation_settings.dart';
import 'package:mangayomi/modules/more/widgets/mobile_nodelane_account.dart';
import 'package:mangayomi/services/translation/translation_service.dart';

void main() {
  Future<void> showSettings(
    WidgetTester tester,
    _SettingsService service, {
    double textScale = 2.5,
    bool account = false,
  }) async {
    tester.view.physicalSize = const Size(360, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(service.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [translationServiceProvider.overrideWithValue(service)],
        child: MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScale),
              padding: const EdgeInsets.only(top: 24, bottom: 34),
            ),
            child: child!,
          ),
          home: account
              ? Scaffold(
                  body: ListView(children: const [MobileNodeLaneAccount()]),
                )
              : const MobileTranslationSettings(),
        ),
      ),
    );
  }

  Future<void> reveal(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 250);
    await tester.pumpAndSettle();
  }

  testWidgets('language sheet and cache feedback stay usable with large text', (
    tester,
  ) async {
    final service = _SettingsService()..ready.complete();
    await showSettings(tester, service);
    await tester.pumpAndSettle();
    expect(find.text('前往登录'), findsNothing);
    expect(find.text('退出登录'), findsNothing);
    final language = find.widgetWithText(ListTile, '目标语言');
    await reveal(tester, language);
    await tester.tap(language);
    await tester.pumpAndSettle();
    await tester.tap(find.text('简体中文').last);
    await tester.pumpAndSettle();
    expect(service.calls, isEmpty);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(service.calls, isEmpty);

    await tester.tap(language);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('日本語'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('日本語'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(service.calls, ['language:ja']);
    expect(find.byType(RadioListTile<String>), findsNothing);
    expect(tester.widget<ListTile>(language).onTap, isNull);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    service.finish();
    await tester.pumpAndSettle();
    expect(find.text('日本語'), findsOneWidget);

    final clear = find.widgetWithText(OutlinedButton, '清理译图缓存');
    await reveal(tester, clear);
    await tester.tap(clear);
    await tester.pump();
    await tester.tap(clear);
    expect(service.calls, ['language:ja', 'clear']);
    expect(tester.widget<OutlinedButton>(clear).onPressed, isNull);
    service.finish(error: '暂时无法清理缓存，请重试');
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(SnackBar),
        matching: find.text('暂时无法清理缓存，请重试'),
      ),
      findsOneWidget,
    );
    expect(find.text('译图缓存已清理，翻译记录已保留'), findsNothing);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.ensureVisible(clear);
    await tester.pumpAndSettle();
    await tester.tap(clear);
    await tester.pump();
    service.finish();
    await tester.pumpAndSettle();
    expect(service.calls, ['language:ja', 'clear', 'clear']);
    expect(find.text('译图缓存已清理，翻译记录已保留'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'account actions wait for initialization and reject repeat taps',
    (tester) async {
      final service = _SettingsService();
      await showSettings(tester, service, textScale: 2, account: true);
      final login = find.widgetWithText(FilledButton, '前往登录');
      expect(tester.widget<FilledButton>(login).onPressed, isNull);
      expect(find.text('正在读取账号…'), findsOneWidget);
      service.ready.complete();
      await tester.pumpAndSettle();
      await reveal(tester, login);
      await tester.tap(login);
      await tester.pump();
      await tester.ensureVisible(login);
      await tester.pump();
      await tester.tap(login);
      expect(service.calls, ['login']);
      service.finish(error: '登录未完成，请重试');
      await tester.pumpAndSettle();
      expect(find.text('登录未完成，请重试'), findsWidgets);
      expect(tester.widget<FilledButton>(login).onPressed, isNotNull);
      await tester.ensureVisible(login);
      await tester.pumpAndSettle();
      await tester.tap(login);
      await tester.pump();
      service.finish();
      await tester.pumpAndSettle();
      expect(service.calls, ['login', 'login']);
      await tester.scrollUntilVisible(find.text(service.accountName), -250);
      await tester.pumpAndSettle();
      expect(find.text(service.accountName), findsOneWidget);
      final logout = find.widgetWithText(OutlinedButton, '退出登录');
      await reveal(tester, logout);
      await tester.tap(logout);
      await tester.pump();
      expect(service.calls.last, 'logout');
      await tester.pumpWidget(const SizedBox());
      service.finish();
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('initialization failure stays visible without exposing details', (
    tester,
  ) async {
    final service = _SettingsService();
    await showSettings(tester, service, account: true);
    service.ready.completeError(StateError('private storage details'));
    await tester.pumpAndSettle();
    expect(find.text('暂时无法读取账号，请重新启动应用后再试。'), findsOneWidget);
    expect(find.textContaining('private storage'), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(service.calls, isEmpty);
    expect(tester.takeException(), isNull);
  });
}

class _SettingsService extends TranslationService {
  final ready = Completer<void>();
  final calls = <String>[];
  Completer<void>? _pending;
  String? _failure;
  bool _signedIn = false;

  @override
  bool get loggedIn => _signedIn;
  @override
  String get accountName => '很长的测试账号名称 NodeLane Reader';
  @override
  Future<void> initialize() => ready.future;

  Future<void> _run(String action, VoidCallback apply) async {
    calls.add(action);
    busy = true;
    error = null;
    _failure = null;
    _pending = Completer<void>();
    notifyListeners();
    await _pending!.future;
    error = _failure;
    if (error == null) apply();
    busy = false;
    notifyListeners();
  }

  void finish({String? error}) {
    _failure = error;
    _pending!.complete();
  }

  @override
  Future<void> login() => _run('login', () => _signedIn = true);
  @override
  Future<void> logout() => _run('logout', () => _signedIn = false);
  @override
  Future<void> setLanguage(String value) =>
      _run('language:$value', () => language = value);
  @override
  Future<void> clearResults() => _run('clear', () {});
}
