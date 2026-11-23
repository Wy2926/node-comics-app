import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/more/widgets/mobile_nodelane_account.dart';
import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/services/translation/channels/nodelane/protocol.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/bubble_finders.dart';

const _freeName = 'Free (Preview)（1.0倍消耗）';
const _paidName = 'Paid Translation Model (Preview) (0.8 倍消耗)';

class _Runtime extends Fake implements ChannelRuntime {
  _Runtime([this.state = const PageTranslationState()]);
  final PageTranslationState state;
  @override
  PageTranslationState stateFor(TranslationPage page) => state;
  @override
  void setWindow(
    String consumer,
    List<TranslationTarget> targets, {
    bool automatic = true,
  }) {}
  @override
  Future<void> restore(List<TranslationTarget> targets) async {}
  @override
  Stream<void> get changes => const Stream.empty();
  @override
  void pause(String consumer) {}
  @override
  Future<void> dispose() async {}
}

class _Source extends Fake implements SourceImageReader {}

class _PricingLauncher extends UrlLauncherPlatform {
  final urls = <String>[];
  @override
  LinkDelegate? get linkDelegate => null;
  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    expect(options.mode, PreferredLaunchMode.externalApplication);
    urls.add(url);
    return true;
  }
}

class _AccountService extends TranslationService {
  Completer<void>? pending;
  int loginCalls = 0;
  int catalogReads = 0;
  bool paidAllowed = false;

  @override
  Future<List<TranslationModelOption>> readModels(
    TranslationCancellation cancel,
  ) async {
    if (++catalogReads == 1) throw const TranslationFailure('NETWORK');
    return nodeLaneModels({
      'translation_models': [
        {
          'id': 'free',
          'name': _freeName,
          'requires_paid': false,
          'available': false,
          'unavailable_reason': 'quota_exhausted',
          'quota_multiplier': 1.0,
        },
        {
          'id': 'paid',
          'name': _paidName,
          'requires_paid': true,
          'available': paidAllowed,
          'unavailable_reason': paidAllowed ? null : 'not_allowed',
          'quota_multiplier': 0.8,
        },
        {
          'id': 'offline',
          'name': 'Offline',
          'requires_paid': false,
          'available': false,
          'unavailable_reason': 'unavailable',
        },
        {'id': 'legacy', 'name': 'Legacy', 'available': true},
      ],
    });
  }

  @override
  Future<void> setModel(TranslationModel? value) async {
    model = value;
    notifyListeners();
  }

  @override
  bool get loggedIn => runtime != null;
  @override
  String get accountName => 'Test Reader';
  @override
  Future<void> initialize() async {}
  @override
  Future<void> refreshAccount() async {}
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

  Future<void> mount(
    WidgetTester tester, {
    bool browser = false,
    Locale locale = const Locale('zh'),
  }) async {
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
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: Builder(
            builder: (context) => Scaffold(
              key: readerKey,
              appBar: AppBar(
                title: const Text('Reader'),
                actions: [
                  Builder(
                    builder: (anchor) => IconButton(
                      tooltip: 'Translation',
                      icon: const Icon(Icons.translate),
                      onPressed: () => showNodeLaneBubble<void>(
                        anchor,
                        label: 'Translation',
                        child: NodeLaneBubbleFlow(
                          home: TranslationControlsContent(
                            controller: controller,
                            mobile: true,
                            browser: browser,
                          ),
                        ),
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

  testWidgets(
    'web settings change automatic translation independently of image display',
    (tester) async {
      await mount(tester, browser: true);
      controller.attach(_Runtime());
      await tester.tap(find.byTooltip('Translation'));
      await tester.pumpAndSettle();
      expect(find.text('原图'), findsNothing);
      expect(find.text('译图'), findsNothing);
      await tester.tap(find.text('自动翻译'));
      await tester.pumpAndSettle();
      expect(controller.enabled, isFalse);
      expect(controller.showTranslation, isFalse);
      expect(find.text('翻译目标语言'), findsOneWidget);
    },
  );

  Future<void> openLogin(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Translation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('登录后开启翻译'));
    await tester.pumpAndSettle();
    expect(find.byType(TranslationControlsContent), findsNothing);
    expect(find.byType(MobileNodeLaneAccountPage), findsOneWidget);
    expect(find.text('前往登录'), findsOneWidget);
  }

  for (final browser in [false, true]) {
    testWidgets(
      '${browser ? 'web' : 'reader'} settings omit image controls and failures',
      (tester) async {
        await mount(tester, browser: browser);
        const failure = TranslationFailure('QUOTA_EXHAUSTED');
        service.runtime = _Runtime(
          const PageTranslationState(
            phase: TranslationPhase.failed,
            failure: failure,
          ),
        );
        controller
          ..attach(service.runtime)
          ..window([
            TranslationTarget(const TranslationPage('page', '1'), _Source()),
          ])
          ..error = 'panel error';
        await tester.tap(find.byTooltip('Translation'));
        await tester.pumpAndSettle();
        expect(find.text('自动翻译'), findsOneWidget);
        expect(find.text('翻译模型'), findsOneWidget);
        expect(find.text('图片显示'), findsNothing);
        expect(find.text('原图'), findsNothing);
        expect(find.text('译图'), findsNothing);
        expect(find.textContaining(failure.message), findsNothing);
        expect(find.text('panel error'), findsNothing);
        expect(find.text('升级'), findsNothing);
        expect(
          find.textContaining('已完成'),
          browser ? findsOneWidget : findsNothing,
        );
      },
    );
  }

  testWidgets(
    'login destination has account actions and returns to the reader',
    (tester) async {
      await mount(tester);
      final reader = readerKey.currentState;
      await openLogin(tester);
      expect(service.loginCalls, 0);
      await tester.tap(find.byTooltip('返回'));
      await tester.pumpAndSettle();
      expect(readerKey.currentState, same(reader));
      expect(readingPosition.offset, 320);
      expect(find.byType(TranslationControlsContent), findsNothing);
      expect(controller.shouldTranslateAutomatically, isFalse);
    },
  );

  testWidgets(
    'login failure retries without translating originals or changing reading position',
    (tester) async {
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
      expect(find.text('Test Reader'), findsOneWidget);
      await tester.tap(find.byTooltip('返回'));
      await tester.pumpAndSettle();
      expect(readingPosition.offset, 320);
      await tester.tap(find.byTooltip('Translation'));
      await tester.pumpAndSettle();
      expect(find.text('登录后开启翻译'), findsNothing);
      expect(controller.shouldTranslateAutomatically, isFalse);
      final toggle = tester.widget<NodeLaneSwitchRow>(
        find.widgetWithText(NodeLaneSwitchRow, '自动翻译'),
      );
      expect(toggle.onChanged, isNotNull);
      expect(toggle.value, isTrue);
    },
  );

  testWidgets('language choice is directly available before login', (
    tester,
  ) async {
    await mount(tester);
    final reader = readerKey.currentState;
    await tester.tap(find.byTooltip('Translation'));
    await tester.pumpAndSettle();
    expect(find.text('登录后开启翻译'), findsOneWidget);
    await tester.tap(find.text('翻译目标语言'));
    await tester.pumpAndSettle();
    expect(find.text('한국어'), findsOneWidget);
    expect(find.byType(MobileNodeLaneAccountPage), findsNothing);
    expect(service.loginCalls, 0);
    expect(controller.shouldTranslateAutomatically, isFalse);
    expect(find.byType(NodeLaneBubblePanel), findsNWidgets(2));
    await tester.tap(inBubble(find.byTooltip('关闭')));
    await tester.pumpAndSettle();
    expect(find.text('登录后开启翻译'), findsOneWidget);
    await tester.tap(find.byTooltip('关闭'));
    await tester.pumpAndSettle();
    expect(readerKey.currentState, same(reader));
    expect(readingPosition.offset, 320);
  });

  testWidgets(
    'long catalog names ellipsize after two lines beside the rate and upgrade link',
    (tester) async {
      const locale = Locale('fr');
      await mount(tester, locale: locale);
      tester.view.physicalSize = const Size(320, 844);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      service.catalogReads = 1;
      final l = lookupAppLocalizations(locale);
      await tester.tap(find.byTooltip('Translation'));
      await tester.pumpAndSettle();
      final row = await revealBubble(tester, find.text(l.translation_model));
      await tester.tap(row);
      await tester.pumpAndSettle();
      final paid = await revealBubble(
        tester,
        find.widgetWithText(NodeLaneRow, _paidName),
      );
      final name = tester.renderObject<RenderParagraph>(
        find.descendant(of: paid, matching: find.text(_paidName)),
      );
      expect(name.maxLines, 2);
      expect(name.overflow, TextOverflow.ellipsis);
      expect(name.didExceedMaxLines, isTrue);
      final link = find.descendant(
        of: paid,
        matching: find.text(l.translation_upgrade_quota),
      );
      expect(
        find.descendant(of: paid, matching: find.text('0,8×')),
        findsOneWidget,
      );
      expect(link.hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'model rows show compact rates and upgrade in place of locked choices',
    (tester) async {
      await mount(tester);
      final previous = UrlLauncherPlatform.instance,
          launcher = _PricingLauncher();
      UrlLauncherPlatform.instance = launcher;
      addTearDown(() => UrlLauncherPlatform.instance = previous);
      await tester.tap(find.byTooltip('Translation'));
      await tester.pumpAndSettle();
      final row = find.widgetWithText(NodeLaneRow, '翻译模型');
      await tester.ensureVisible(row);
      expect(service.catalogReads, 0);
      await tester.tap(row);
      await tester.pumpAndSettle();
      await tester.tap(inBubble(find.text('重试')));
      await tester.pumpAndSettle();
      final icons = NodeLaneIcons.of(tester.element(row));
      Finder optionRow(String title) =>
          inBubble(find.widgetWithText(NodeLaneRow, title));
      for (final (title, glyph, tier, labels) in [
        (_freeName, icons.modelFree, '免费模型', [_freeName, '1×']),
        (_paidName, icons.modelPaid, '付费模型', [_paidName, '0.8×', '升级']),
        ('Offline', icons.modelFree, '免费模型', ['Offline', '升级']),
        ('Legacy', icons.translate, null, ['Legacy']),
      ]) {
        final modelRow = optionRow(title);
        expect(
          tester
              .widgetList<Text>(
                find.descendant(of: modelRow, matching: find.byType(Text)),
              )
              .map((w) => w.data),
          labels,
        );
        final icon = tester.widget<Icon>(
          find.descendant(of: modelRow, matching: find.byIcon(glyph)),
        );
        expect(icon.semanticLabel, tier);
      }
      await tester.tap(inBubble(find.text(_paidName)));
      await tester.tap(inBubble(find.text('Offline')));
      expect(service.model, isNull);
      expect(launcher.urls, isEmpty);
      final paidRow = optionRow(_paidName);
      expect(
        find.descendant(
          of: paidRow,
          matching: find.byIcon(Icons.radio_button_unchecked),
        ),
        findsNothing,
      );
      final upgrade = find.descendant(of: paidRow, matching: find.text('升级'));
      await tester.tap(upgrade);
      await tester.tap(upgrade);
      expect(launcher.urls, ['https://comics.nodelane.net/pricing/']);
      expect(service.model, isNull);
      service.paidAllowed = true;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(service.catalogReads, 3);
      expect(upgrade, findsNothing);
      expect(
        find.descendant(
          of: paidRow,
          matching: find.byIcon(Icons.radio_button_unchecked),
        ),
        findsOneWidget,
      );
      expect(service.model, isNull);
      await tester.tap(inBubble(find.text(_freeName)));
      await tester.pumpAndSettle();
      expect(service.model, (id: 'free', name: _freeName));
      expect(find.text(_freeName).hitTestable(), findsOneWidget);
      await service.setModel((id: 'free', name: 'Previous catalog name'));
      await tester.pumpAndSettle();
      await tester.tap(row);
      await tester.pumpAndSettle();
      final selected = tester.widget<NodeLaneRow>(
        inBubble(find.widgetWithText(NodeLaneRow, _freeName)),
      );
      expect(selected.selected, isTrue);
      await tester.tap(inBubble(find.text('默认')));
      await tester.pumpAndSettle();
      expect(service.model, isNull);
      await tester.tap(find.byTooltip('关闭'));
      await tester.pumpAndSettle();
      expect(readingPosition.offset, 320);
    },
  );
}
