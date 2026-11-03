import 'package:flutter/material.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/translation_service.dart';

class _Source extends Fake implements SourceImageReader {}

class _Runtime extends Fake implements ChannelRuntime {
  final actions = <TranslationAction>[];
  @override
  Stream<void> get changes => const Stream.empty();
  @override
  void pause(String consumer) {}
  @override
  void setWindow(String consumer, List<TranslationTarget> targets) {}
  @override
  Future<void> dispose() async {}
  @override
  PageTranslationState stateFor(TranslationPage page) => switch (page.key) {
    'done' => const PageTranslationState(
      phase: TranslationPhase.succeeded,
      message: '翻译完成',
    ),
    'failed' => const PageTranslationState(
      phase: TranslationPhase.failed,
      message: '翻译失败',
      actions: {TranslationAction.retry},
    ),
    _ => const PageTranslationState(
      phase: TranslationPhase.uncertain,
      message: '需要核实',
      actions: {TranslationAction.verify},
    ),
  };
  @override
  Future<void> perform(
    TranslationTarget target,
    TranslationAction action,
  ) async => actions.add(action);
}

void main() {
  Future<void> mount(
    WidgetTester tester,
    TranslationViewController controller,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final service = _Service();
    addTearDown(service.dispose);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [translationServiceProvider.overrideWithValue(service)],
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: Scaffold(
            body: TranslationControlsContent(
              controller: controller,
              mobile: true,
              browser: true,
              title: '网页翻译',
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('browser login and no-image states avoid unusable actions', (
    tester,
  ) async {
    final controller = TranslationViewController();
    await mount(tester, controller);
    expect(find.text('登录后开启翻译'), findsOneWidget);
    expect(find.text('翻译当前阅读范围'), findsNothing);
    controller.attach(_Runtime());
    await tester.pumpAndSettle();
    expect(find.text('登录后开启翻译'), findsNothing);
    expect(find.text('当前页面暂未发现可翻译图片'), findsOneWidget);
    expect(find.text('翻译目标语言'), findsOneWidget);
  });

  testWidgets(
    'collapsed progress exposes failures and preserves verify-only recovery',
    (tester) async {
      final runtime = _Runtime();
      final controller = TranslationViewController()..attach(runtime);
      controller.window([
        for (final key in ['done', 'failed', 'uncertain'])
          TranslationTarget(TranslationPage(key, '1'), _Source()),
      ]);
      controller.configure(enabled: true);
      await mount(tester, controller);
      expect(find.text('已完成 1 / 3 张'), findsOneWidget);
      expect(find.text('2 张需要处理 · 点击查看'), findsOneWidget);
      expect(find.byTooltip('本页翻译操作'), findsNothing);
      await tester.tap(find.text('原图'));
      await tester.pumpAndSettle();
      expect(controller.enabled, isTrue);
      expect(controller.showTranslation, isFalse);
      await tester.tap(find.text('已完成 1 / 3 张'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byTooltip('本页翻译操作').last);
      await tester.tap(find.byTooltip('本页翻译操作').last);
      await tester.pumpAndSettle();
      expect(find.text('核实状态'), findsOneWidget);
      expect(find.text('重新翻译本页'), findsNothing);
      await tester.tap(find.text('核实状态'));
      await tester.pumpAndSettle();
      expect(runtime.actions, [TranslationAction.verify]);
      expect(tester.takeException(), isNull);
    },
  );
}

class _Service extends TranslationService {
  @override
  Future<void> initialize() async {}
}
