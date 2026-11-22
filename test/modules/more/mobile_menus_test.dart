import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/mobile_more_screen.dart';
import 'package:mangayomi/modules/more/settings/mobile_settings_layout.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_reveal.dart';
import 'package:mangayomi/modules/widgets/nodelane_setting_bubble.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/modules/more/widgets/mobile_nodelane_account.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
  }

  Widget largeText(BuildContext context, Widget? child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: TextScaler.linear(2.5),
      padding: const EdgeInsets.only(top: 24, bottom: 100),
    ),
    child: child!,
  );

  testWidgets('settings search follows visible media and survives navigation', (
    tester,
  ) async {
    phone(tester);
    final container = ProviderContainer(
      overrides: [
        hideItemsStateProvider.overrideWith(_HiddenItems.new),
        translationServiceProvider.overrideWith((ref) {
          final service = _AccountService();
          ref.onDispose(service.dispose);
          return service;
        }),
      ],
    );
    addTearDown(container.dispose);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const MobileMoreScreen()),
        GoRoute(
          path: '/appearance',
          builder: (_, state) => MobileSettingsLayout(
            category: '/appearance',
            child: NodeLaneRevealScope(
              path: state.uri.queryParametersAll['setting']!,
              child: Scaffold(
                appBar: AppBar(title: const Text('Appearance destination')),
                body: MobileSettingsChoice<int>(
                  title: 'App language',
                  icon: Icons.language,
                  value: 0,
                  label: (_) => 'English',
                  options: const [SettingOption(0, 'English')],
                  onChanged: (_) =>
                      fail('Opening search must not change the language'),
                ),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/playerDecoderScreen',
          builder: (_, _) => const Scaffold(body: Text('Decoder destination')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          builder: largeText,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('More'), findsNothing);
    await tester.scrollUntilVisible(
      find.byType(TextField),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final list = find.byType(CustomScrollView);
    await tester.drag(list, const Offset(0, -650));
    await tester.pumpAndSettle();
    final pinnedTop = tester.getTopLeft(find.byType(TextField)).dy;
    expect(pinnedTop, closeTo(24 + NodeLaneTokens.space8, .5));
    await tester.drag(list, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byType(TextField)).dy,
      closeTo(pinnedTop, .5),
    );
    expect(find.byType(TextField), findsOneWidget);
    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'welcome');
    await tester.pumpAndSettle();
    expect(find.text('No matching settings'), findsOneWidget);
    expect(find.text('Show the welcome screen'), findsNothing);
    await tester.enterText(find.byType(TextField), 'reader');
    await tester.pumpAndSettle();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isTrue,
    );
    expect(find.text('Manga Reader'), findsWidgets);
    expect(find.text('Novel Reader'), findsWidgets);
    container.read(hideItemsStateProvider.notifier).set([
      '/MangaLibrary',
      '/NovelLibrary',
    ]);
    await tester.pumpAndSettle();
    expect(find.text('Manga Reader'), findsNothing);
    expect(find.text('Novel Reader'), findsNothing);
    expect(find.text('Translation language'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'reader',
    );

    for (final query in ['display language', '显示语言']) {
      await tester.enterText(find.byType(TextField), query);
      await tester.pumpAndSettle();
      expect(find.text('App language'), findsOneWidget);
      expect(find.text('Appearance and interface'), findsOneWidget);
    }
    await tester.ensureVisible(find.text('App language'));
    await tester.tap(find.text('App language'));
    await tester.pumpAndSettle();
    final panel = find.byType(NodeLaneBubblePanel);
    expect(
      find.descendant(of: panel, matching: find.text('App language')),
      findsOneWidget,
    );
    expect(ModalRoute.of(tester.element(panel)), isA<PopupRoute>());
    expect(find.byType(MobileMoreScreen), findsNothing);
    final page = find.text('Appearance destination');
    expect(ModalRoute.of(tester.element(page)), isA<PageRoute>());
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(panel, findsNothing);
    expect(page, findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '显示语言',
    );
    expect(find.text('Appearance and interface'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'decoder');
    await tester.pumpAndSettle();
    final decoder = find.byWidgetPredicate(
      (widget) => widget is NodeLaneRow && widget.title == 'Decoder',
    );
    await tester.ensureVisible(decoder);
    await tester.tap(decoder);
    await tester.pumpAndSettle();
    expect(find.text('Decoder destination'), findsOneWidget);
    router.pop();
    await tester.pumpAndSettle();
    container.read(hideItemsStateProvider.notifier).set(['/AnimeLibrary']);
    await tester.pumpAndSettle();
    expect(decoder, findsNothing);

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.enterText(find.byType(TextField), 'missing setting');
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Clear search'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Clear search'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byType(TextField),
      -250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    expect(find.text('No result'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'tablet settings switch categories in place; a landscape phone keeps just the detail',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(840, 640);
      addTearDown(tester.view.reset);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: Text('Origin')),
          ),
          for (final path in ['/general', '/appearance'])
            GoRoute(
              path: path,
              builder: (_, _) => MobileSettingsLayout(
                category: path,
                child: Scaffold(
                  body: Center(child: TextField(key: ValueKey('draft:$path'))),
                ),
              ),
            ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [hideItemsStateProvider.overrideWith(_HiddenItems.new)],
          child: MaterialApp.router(
            routerConfig: router,
            theme: ThemeData(platform: TargetPlatform.iOS),
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      router.push('/general');
      await tester.pumpAndSettle();
      final sidebar = find.byKey(const PageStorageKey('settings-directory'));
      final appearance = find.descendant(
        of: sidebar,
        matching: find.text('Appearance and interface'),
      );
      final field = find.byType(TextField);
      expect(
        tester.getTopRight(sidebar).dx,
        lessThanOrEqualTo(tester.getTopLeft(field).dx),
      );
      await tester.ensureVisible(appearance);
      await tester.tap(appearance);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('draft:/appearance')), findsOneWidget);
      final state = tester.element(field);
      await tester.enterText(field, 'draft');
      tester.view.physicalSize = const Size(840, 390);
      await tester.pumpAndSettle();
      expect(sidebar, findsNothing);
      expect(tester.element(field), same(state));
      tester.view.physicalSize = const Size(600, 850);
      await tester.pumpAndSettle();
      expect(sidebar, findsOneWidget);
      expect(find.text('draft'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Origin'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'More groups phone settings by purpose and keeps tablet tools beside the results',
    (tester) async {
      phone(tester);
      final account = _AccountService();
      addTearDown(account.dispose);
      final container = ProviderContainer(
        overrides: [
          translationServiceProvider.overrideWithValue(account),
          hideItemsStateProvider.overrideWith(_HiddenItems.new),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            builder: largeText,
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const FloatingNavigationScope(
              enabled: true,
              child: MobileMoreScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(MobileNodeLaneAccountSummary), findsOneWidget);
      expect(find.text('Frequently used'), findsNothing);
      expect(find.text('Reading and translation'), findsOneWidget);
      expect(find.text('Translation model'), findsOneWidget);
      container.read(hideItemsStateProvider.notifier).set(['/browser']);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('More tools').hitTestable(),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('More tools'));
      await tester.pumpAndSettle();
      expect(find.text('Browser'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('About and help'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(
        tester.getBottomLeft(find.text('About and help')).dy,
        lessThan(640),
      );

      tester.view.physicalSize = const Size(1600, 1000);
      await tester.pumpAndSettle();
      final sidebar = find.byKey(const PageStorageKey('more-shortcuts'));
      expect(
        find.descendant(of: sidebar, matching: find.text('About and help')),
        findsOneWidget,
      );
      final search = find.descendant(
        of: sidebar,
        matching: find.byType(TextField),
      );
      for (final (title, parent) in [
        ('Downloaded only', 'Download settings'),
        ('Incognito Mode', 'Security and privacy'),
        ('Download Queue', 'Updates'),
        ('App feedback', 'About and help'),
      ]) {
        await tester.enterText(search, title);
        await tester.pumpAndSettle();
        final match = find.byWidgetPredicate(
          (w) => w is NodeLaneRow && w.title == title,
        );
        expect(tester.widget<NodeLaneRow>(match).subtitle, parent);
        expect(
          tester.getTopLeft(match).dx,
          greaterThanOrEqualTo(tester.getTopRight(sidebar).dx),
        );
      }
      expect(tester.takeException(), isNull);
    },
  );
}

class _HiddenItems extends HideItemsState {
  @override
  List<String> build() => [];
  @override
  void set(List<String> values) => state = values;
}

class _AccountService extends TranslationService {
  @override
  Future<void> initialize() async {}
}
