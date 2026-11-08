import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/widgets/mobile_nodelane_account.dart';
import 'package:mangayomi/modules/translation/translation_language_picker.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/services/translation/channels/nodelane/account.dart';
import 'package:mangayomi/services/translation/translation_service.dart';

void main() {
  Future<void> mount(
    WidgetTester tester,
    _Service service, {
    double scale = 1,
    Widget child = const MobileNodeLaneAccountPage(),
  }) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(service.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [translationServiceProvider.overrideWithValue(service)],
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(platform: TargetPlatform.iOS),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(scale),
              padding: const EdgeInsets.only(top: 24, bottom: 34),
            ),
            child: child!,
          ),
          home: child,
        ),
      ),
    );
  }

  Future<void> reveal(
    WidgetTester tester,
    Finder finder, {
    double delta = 250,
  }) async {
    await tester.scrollUntilVisible(finder, delta);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'login waits for restoration, rejects repeats, retries and safely leaves pending action',
    (tester) async {
      final service = _Service();
      await mount(tester, service, scale: 2.5);
      final login = find.widgetWithText(FilledButton, '前往登录');
      expect(tester.widget<FilledButton>(login).onPressed, isNull);
      service.ready.complete();
      await tester.pumpAndSettle();
      await reveal(tester, login);
      await tester.tap(login);
      await tester.pump();
      await tester.tap(login, warnIfMissed: false);
      expect(service.calls, ['login']);
      service.finish(error: '登录未完成，请重试');
      await tester.pumpAndSettle();
      await reveal(tester, find.text('登录未完成，请重试'), delta: -250);
      expect(find.text('登录未完成，请重试'), findsOneWidget);
      await reveal(tester, login);
      await tester.tap(login);
      await tester.pump();
      service.finish();
      await tester.pumpAndSettle();
      await reveal(tester, find.text('很长的测试账号名称 NodeLane Reader'), delta: -300);
      expect(find.text('很长的测试账号名称 NodeLane Reader'), findsOneWidget);
      final logout = find.widgetWithText(NodeLaneRow, '退出登录');
      await reveal(tester, logout);
      await tester.tap(logout);
      await tester.pumpAndSettle();
      expect(service.calls, ['login', 'login']);
      await tester.tap(find.widgetWithText(FilledButton, '取消'));
      await tester.pumpAndSettle();
      expect(service.loggedIn, isTrue);
      await tester.tap(logout);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, '退出登录'));
      await tester.pump();
      expect(service.calls, ['login', 'login', 'logout']);
      await tester.pumpWidget(const SizedBox());
      service.finish();
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'free account separates purchased quota; details only expand locally',
    (tester) async {
      final service = _Service()
        ..ready.complete()
        ..signedIn = true;
      service.account = _account(free: true);
      await mount(tester, service, scale: 2.5);
      await tester.pumpAndSettle();
      await reveal(tester, find.text('免费账户'));
      expect(find.text('暂无有效订阅'), findsOneWidget);
      expect(find.text('购买额度与订阅分别计算'), findsNothing);
      expect(find.textContaining('更新于'), findsNothing);
      await reveal(tester, find.text('查看额度明细'));
      final reads = service.reads;
      await tester.tap(find.text('查看额度明细'));
      await tester.pumpAndSettle();
      await reveal(tester, find.text('剩余 150 页').last);
      await reveal(tester, find.text('已使用 50 页'));
      expect(find.text('已使用 50 页'), findsOneWidget);
      await reveal(tester, find.text('无到期时间'));
      expect(service.reads, reads);
      expect(service.calls, isEmpty);
      await reveal(tester, find.text('额度明细'), delta: -300);
      await tester.tap(find.text('额度明细'));
      await tester.pumpAndSettle();
      expect(find.text('已使用 50 页'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'failed refresh keeps the paid snapshot, then retry updates without changing translation',
    (tester) async {
      final service = _Service()
        ..ready.complete()
        ..signedIn = true;
      service.account = _account();
      await mount(tester, service);
      await tester.pumpAndSettle();
      service.accountLoadFailed = true;
      service.notifyListeners();
      await tester.pumpAndSettle();
      expect(find.text('暂时无法更新账号信息'), findsOneWidget);
      expect(find.text('PLUS'), findsOneWidget);
      expect(find.text('手动续费'), findsOneWidget);
      expect(find.textContaining('更新于'), findsNothing);
      await reveal(tester, find.text('重试'), delta: -250);
      final before = service.reads;
      await tester.tap(find.text('重试'));
      await tester.pumpAndSettle();
      expect(service.reads, before + 1);
      expect(service.runtime, isNull);
      expect(service.calls, isEmpty);
      expect(find.text('暂时无法更新账号信息'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'summary shows one tier and keeps it during refresh without loading copy',
    (tester) async {
      final service = _Service()
        ..ready.complete()
        ..signedIn = true;
      service.account = _account(free: true);
      await mount(
        tester,
        service,
        scale: 2.5,
        child: const Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(child: MobileNodeLaneAccountSummary()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Free'), findsOneWidget);
      expect(find.text('免费账户'), findsNothing);
      final initialSize = tester.getSize(find.byType(NodeLaneGroupSurface));
      service.accountLoading = true;
      service.notifyListeners();
      await tester.pump();
      expect(find.text('Free'), findsOneWidget);
      expect(find.textContaining('正在读取账号'), findsNothing);
      expect(tester.getSize(find.byType(NodeLaneGroupSurface)), initialSize);
      service.account = _account();
      service.accountLoading = false;
      service.notifyListeners();
      await tester.pumpAndSettle();
      expect(find.text('Free'), findsNothing);
      expect(find.text('PLUS'), findsOneWidget);
      service.account = _account(plan: 'pro');
      service.notifyListeners();
      await tester.pumpAndSettle();
      expect(find.text('PLUS'), findsNothing);
      expect(find.text('Pro'), findsOneWidget);
      expect(service.calls, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'account refresh retains visible details without adding loading or footer copy',
    (tester) async {
      final service = _Service()
        ..ready.complete()
        ..signedIn = true;
      service.account = _account();
      await mount(tester, service);
      await tester.pumpAndSettle();
      final initialTierPosition = tester.getTopLeft(find.text('PLUS'));
      service.accountLoading = true;
      service.notifyListeners();
      await tester.pump();
      expect(find.text('PLUS'), findsOneWidget);
      expect(tester.getTopLeft(find.text('PLUS')), initialTierPosition);
      expect(find.textContaining('正在读取账号'), findsNothing);
      service.accountLoading = false;
      service.notifyListeners();
      await tester.pumpAndSettle();
      await reveal(tester, find.text('退出登录'));
      expect(find.text('购买额度与订阅分别计算'), findsNothing);
      expect(find.textContaining('更新于'), findsNothing);
      expect(service.runtime, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'initialization failure disables login and never exposes storage details',
    (tester) async {
      final service = _Service();
      await mount(tester, service, scale: 2.5);
      service.ready.completeError(StateError('private storage details'));
      await tester.pumpAndSettle();
      expect(find.text('暂时无法读取账号，请重新启动应用后再试。'), findsOneWidget);
      expect(find.textContaining('private storage'), findsNothing);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(service.calls, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'shared language choice cancels, skips same value and writes once at large text',
    (tester) async {
      final service = _Service()
        ..language = 'zh-Hans'
        ..ready.complete();
      await mount(
        tester,
        service,
        scale: 2.5,
        child: const Scaffold(body: SafeArea(child: TranslationLanguageRow())),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('翻译目标语言'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('简体中文').last);
      await tester.pumpAndSettle();
      expect(service.calls, isEmpty);
      await tester.tap(find.text('翻译目标语言'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('关闭'));
      await tester.pumpAndSettle();
      expect(service.calls, isEmpty);
      await tester.tap(find.text('翻译目标语言'));
      await tester.pumpAndSettle();
      await reveal(tester, find.text('العربية'));
      await tester.tap(find.text('العربية'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(service.calls, ['language:ar']);
      expect(
        tester.widget<NodeLaneRow>(find.byType(NodeLaneRow)).enabled,
        isFalse,
      );
      service.finish();
      await tester.pumpAndSettle();
      expect(find.text('العربية'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

NodeLaneAccount _account({bool free = false, String plan = 'plus'}) =>
    NodeLaneAccount(
      id: 'account-a',
      name: '很长的测试账号名称 NodeLane Reader',
      updatedAt: DateTime.utc(2026, 11, 3),
      plan: free ? 'free' : plan,
      planName: free ? '免费账户' : 'PLUS',
      renewal: NodeLaneRenewal.manual,
      free: const NodeLaneQuota(
        available: 24,
        used: 6,
        reserved: 0,
        granted: 30,
      ),
      subscription: NodeLaneQuota(
        available: free ? 0 : 820,
        used: free ? 0 : 172,
        reserved: free ? 0 : 8,
        granted: free ? 0 : 1000,
      ),
      purchase: const NodeLaneQuota(
        available: 150,
        used: 50,
        reserved: 0,
        granted: 200,
      ),
    );

class _Service extends TranslationService {
  final ready = Completer<void>();
  final calls = <String>[];
  Completer<void>? pending;
  bool signedIn = false;
  int reads = 0;
  String? failure;
  @override
  bool get loggedIn => signedIn;
  @override
  String get accountName => '很长的测试账号名称 NodeLane Reader';
  @override
  String? get accountId => signedIn ? 'account-a' : null;
  @override
  Future<void> initialize() => ready.future;
  @override
  Future<void> refreshAccount() async {
    reads++;
    accountLoadFailed = false;
    notifyListeners();
  }

  Future<void> act(String name, VoidCallback apply) async {
    calls.add(name);
    busy = true;
    error = null;
    failure = null;
    pending = Completer<void>();
    notifyListeners();
    await pending!.future;
    error = failure;
    if (error == null) apply();
    busy = false;
    notifyListeners();
  }

  void finish({String? error}) {
    failure = error;
    pending!.complete();
  }

  @override
  Future<void> login() => act('login', () {
    signedIn = true;
    account = _account();
  });
  @override
  Future<void> logout() => act('logout', () {
    signedIn = false;
    account = null;
  });
  @override
  Future<void> setLanguage(String value) =>
      act('language:$value', () => language = value);
}
