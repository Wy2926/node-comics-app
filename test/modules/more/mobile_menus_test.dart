import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/mobile_more_screen.dart';
import 'package:mangayomi/modules/more/providers/downloaded_only_state_provider.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/downloaded_only_widget.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/modules/more/widgets/mobile_nodelane_account.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

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
        morePendingDownloadsProvider.overrideWith((ref) => Stream.value(0)),
        downloadedOnlyStateProvider.overrideWith(_Downloaded.new),
        incognitoModeStateProvider.overrideWith(_Incognito.new),
        hideDiscordRpcInIncognitoStateProvider.overrideWith(_HideRpc.new),
      ],
    );
    addTearDown(container.dispose);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const MobileMoreScreen()),
        GoRoute(
          path: '/appearance',
          builder: (_, state) => Scaffold(
            appBar: AppBar(
              title: Text(
                state.uri.queryParameters['setting'] ??
                    'Appearance destination',
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
    await tester.scrollUntilVisible(find.byType(TextField), 250);
    await tester.pumpAndSettle();
    final list = find.byType(CustomScrollView);
    await tester.drag(list, const Offset(0, -650));
    await tester.pumpAndSettle();
    final pinnedTop = tester.getTopLeft(find.byType(TextField)).dy;
    expect(pinnedTop, greaterThanOrEqualTo(24 + kToolbarHeight));
    await tester.drag(list, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byType(TextField)).dy,
      closeTo(pinnedTop, .5),
    );
    expect(find.byType(TextField), findsOneWidget);
    await tester.tap(find.byType(TextField));
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
    expect(find.text('App language'), findsOneWidget);
    expect(find.byType(MobileMoreScreen), findsNothing);
    router.pop();
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
    'More switches write once and its last row clears the bottom bar',
    (tester) async {
      phone(tester);
      final account = _AccountService();
      addTearDown(account.dispose);
      final container = ProviderContainer(
        overrides: [
          translationServiceProvider.overrideWithValue(account),
          morePendingDownloadsProvider.overrideWith((ref) => Stream.value(0)),
          hideItemsStateProvider.overrideWith(_HiddenItems.new),
          downloadedOnlyStateProvider.overrideWith(_Downloaded.new),
          incognitoModeStateProvider.overrideWith(_Incognito.new),
          hideDiscordRpcInIncognitoStateProvider.overrideWith(_HideRpc.new),
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
      await tester.scrollUntilVisible(find.text('Downloaded only'), 250);
      await tester.pumpAndSettle();
      // The account card can push this group beyond the initial viewport.
      // Read its auto-dispose notifiers only after the switches are mounted.
      final downloaded =
          container.read(downloadedOnlyStateProvider.notifier) as _Downloaded;
      final incognito =
          container.read(incognitoModeStateProvider.notifier) as _Incognito;
      await tester.tap(find.text('Downloaded only'));
      await tester.pumpAndSettle();
      expect(downloaded.writes, [true]);
      final toggle = find.descendant(
        of: find.byType(DownloadedOnlyWidget),
        matching: find.byType(NodeLaneSwitch),
      );
      await tester.ensureVisible(toggle);
      await tester.pumpAndSettle();
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(downloaded.writes, [true, false]);
      expect(incognito.writes, isEmpty);
      await tester.scrollUntilVisible(
        find.text('Incognito Mode'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Incognito Mode'));
      await tester.pumpAndSettle();
      expect(incognito.writes, [true]);
      expect(downloaded.writes, [true, false]);

      final appearance = find.widgetWithText(
        NodeLaneRow,
        'Appearance and interface',
      );
      await tester.scrollUntilVisible(
        appearance,
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(tester.widget<NodeLaneRow>(appearance).value, isNull);
      expect(tester.widget<NodeLaneRow>(appearance).subtitle, isNull);

      container.read(hideItemsStateProvider.notifier).set(['/browser']);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('浏览器'),
        -300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('浏览器'), findsOneWidget);
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

class _Downloaded extends DownloadedOnlyState {
  final writes = <bool>[];
  @override
  bool build() => false;
  @override
  void setDownloadedOnly(bool value) {
    writes.add(value);
    state = value;
  }
}

class _Incognito extends IncognitoModeState {
  final writes = <bool>[];
  @override
  bool build() => false;
  @override
  void setIncognitoMode(bool value) {
    writes.add(value);
    state = value;
  }
}

class _HideRpc extends HideDiscordRpcInIncognitoState {
  @override
  bool build() => false;
}

class _AccountService extends TranslationService {
  @override
  Future<void> initialize() async {}
}
