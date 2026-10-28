import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/mobile_more_screen.dart';
import 'package:mangayomi/modules/more/providers/downloaded_only_state_provider.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';
import 'package:mangayomi/modules/more/settings/mobile_settings_screen.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/downloaded_only_widget.dart';
import 'package:mangayomi/utils/platform_utils.dart';

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
      overrides: [hideItemsStateProvider.overrideWith(_HiddenItems.new)],
    );
    addTearDown(container.dispose);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const MobileSettingsScreen()),
        GoRoute(
          path: '/appearance',
          builder: (_, _) => Scaffold(
            appBar: AppBar(title: const Text('Appearance destination')),
          ),
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
    await tester.enterText(find.byType(TextField), 'reader');
    await tester.pumpAndSettle();
    expect(find.text('Reader'), findsOneWidget);
    expect(find.text('Novel Reader'), findsOneWidget);
    container.read(hideItemsStateProvider.notifier).set([
      '/MangaLibrary',
      '/NovelLibrary',
    ]);
    await tester.pumpAndSettle();
    expect(find.text('Reader'), findsNothing);
    expect(find.text('Novel Reader'), findsNothing);
    expect(find.text('No result'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'reader',
    );

    await tester.enterText(find.byType(TextField), 'theme');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Appearance'));
    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    expect(find.text('Appearance destination'), findsOneWidget);
    router.pop();
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'theme',
    );
    expect(find.text('Appearance'), findsOneWidget);

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.enterText(find.byType(TextField), 'missing setting');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(TextButton, 'Reset'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Reset'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byType(TextField), -250);
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
      final container = ProviderContainer(
        overrides: [
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
      final downloaded =
          container.read(downloadedOnlyStateProvider.notifier) as _Downloaded;
      final incognito =
          container.read(incognitoModeStateProvider.notifier) as _Incognito;
      await tester.scrollUntilVisible(find.text('Downloaded only'), 250);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Downloaded only'));
      await tester.pumpAndSettle();
      expect(downloaded.writes, [true]);
      final toggle = find.descendant(
        of: find.byType(DownloadedOnlyWidget),
        matching: find.byType(Switch),
      );
      await tester.ensureVisible(toggle);
      await tester.pumpAndSettle();
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(downloaded.writes, [true, false]);
      expect(incognito.writes, isEmpty);
      await tester.scrollUntilVisible(find.text('Incognito Mode'), 250);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Incognito Mode'));
      await tester.pumpAndSettle();
      expect(incognito.writes, [true]);
      expect(downloaded.writes, [true, false]);

      container.read(hideItemsStateProvider.notifier).set(['/history']);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('History'), 300);
      await tester.pumpAndSettle();
      expect(find.text('History'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('About'), 300);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(tester.getBottomLeft(find.text('About')).dy, lessThan(640));
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
