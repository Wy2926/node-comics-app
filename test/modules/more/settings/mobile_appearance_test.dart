import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/settings/appearance/mobile_appearance_screen.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/app_font_family.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/app_ui_scale_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/date_format_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

void main() {
  Future<ProviderContainer> showAppearance(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    final container = ProviderContainer(
      overrides: [
        themeModeStateProvider.overrideWith(_Theme.new),
        followSystemThemeStateProvider.overrideWith(_Follow.new),
        pureBlackDarkModeStateProvider.overrideWith(_PureBlack.new),
        flexSchemeColorStateProvider.overrideWith(_Scheme.new),
        blendLevelStateProvider.overrideWith(_Blend.new),
        appUiScaleStateProvider.overrideWith(_Scale.new),
        appFontFamilyProvider.overrideWith(_Font.new),
        l10nLocaleStateProvider.overrideWith(_Locale.new),
        relativeTimesTampsStateProvider.overrideWith(_Relative.new),
        dateFormatStateProvider.overrideWith(_Date.new),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(2.5),
              padding: const EdgeInsets.only(top: 24, bottom: 34),
            ),
            child: child!,
          ),
          home: const MobileAppearanceScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Finder link(String title) => find.widgetWithText(NodeLaneRow, title);
  Future<void> open(WidgetTester tester, String title) async {
    await tester.scrollUntilVisible(link(title), 300);
    await tester.pumpAndSettle();
    await tester.tap(link(title));
    await tester.pumpAndSettle();
  }

  Future<void> choose(WidgetTester tester, String label) async {
    await tester.ensureVisible(find.text(label).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
  }

  testWidgets('theme choices keep pure-black and stored blend independent', (
    tester,
  ) async {
    final container = await showAppearance(tester);
    await open(tester, 'Theme');
    await choose(tester, 'Dark');
    expect(container.read(followSystemThemeStateProvider), isFalse);
    expect(container.read(themeModeStateProvider), isTrue);
    final pure = find.widgetWithText(NodeLaneSwitchRow, 'Pure black dark mode');
    await tester.scrollUntilVisible(pure, 200);
    await tester.pumpAndSettle();
    await tester.tap(pure);
    await tester.pumpAndSettle();
    expect(container.read(pureBlackDarkModeStateProvider), isTrue);
    expect(find.textContaining('Color blend level'), findsNothing);
    expect(container.read(blendLevelStateProvider), 20);

    await tester.scrollUntilVisible(link('Theme'), -250);
    await tester.pumpAndSettle();
    await open(tester, 'Theme');
    await choose(tester, 'Light');
    expect(container.read(pureBlackDarkModeStateProvider), isTrue);
    expect(container.read(themeModeStateProvider), isFalse);
    await tester.scrollUntilVisible(
      find.textContaining('Color blend level'),
      200,
    );
    await tester.pumpAndSettle();
    expect(find.text('Color blend level · 20'), findsOneWidget);
    final blend = container.read(blendLevelStateProvider.notifier) as _Blend;
    expect(blend.writes, isEmpty);

    await tester.scrollUntilVisible(link('Color'), -250);
    await tester.pumpAndSettle();
    await open(tester, 'Color');
    final name = ThemeAA.schemes[1].name;
    await tester.enterText(find.byType(TextField), name);
    await tester.pumpAndSettle();
    await choose(tester, name);
    expect(container.read(flexSchemeColorStateProvider).$2, 1);
    expect(
      (container.read(flexSchemeColorStateProvider.notifier) as _Scheme).writes,
      [1],
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'font cancellation differs from default and search works above the keyboard',
    (tester) async {
      final container = await showAppearance(tester);
      final font = container.read(appFontFamilyProvider.notifier) as _Font;
      await open(tester, 'Font');
      await tester.enterText(find.byType(TextField), 'no-such-font-123');
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.widgetWithText(TextButton, 'Reset'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Reset'));
      await tester.pumpAndSettle();
      expect(find.text('No result'), findsNothing);
      await tester.tap(find.byTooltip('Back'));
      tester.view.viewInsets = FakeViewPadding.zero;
      await tester.pumpAndSettle();
      expect(font.writes, isEmpty);
      expect(container.read(appFontFamilyProvider).$1, 'Roboto');
      await open(tester, 'Font');
      await choose(tester, 'Default');
      expect(font.writes, [null]);

      await open(tester, 'Date format');
      await choose(tester, 'dd/MM/yy');
      expect(container.read(dateFormatStateProvider), 'dd/MM/yy');
      await tester.scrollUntilVisible(
        find.textContaining('Interface scale ·'),
        -300,
      );
      await tester.pumpAndSettle();
      final slider = find.byWidgetPredicate(
        (widget) => widget is Slider && widget.min == .85,
      );
      await tester.ensureVisible(slider);
      await tester.pumpAndSettle();
      await tester.drag(slider, const Offset(40, 0));
      await tester.pumpAndSettle();
      final scale = container.read(appUiScaleStateProvider.notifier) as _Scale;
      expect(scale.commits, hasLength(1));
      expect(scale.commits.single, container.read(appUiScaleStateProvider));
      expect(tester.takeException(), isNull);
    },
  );
}

class _Theme extends ThemeModeState {
  @override
  bool build() => false;
  @override
  void setTheme(Brightness value) => state = value == Brightness.dark;
}

class _Follow extends FollowSystemThemeState {
  @override
  bool build() => true;
  @override
  void set(bool value) => state = value;
}

class _PureBlack extends PureBlackDarkModeState {
  @override
  bool build() => false;
  @override
  void set(bool value) => state = value;
}

class _Scheme extends FlexSchemeColorState {
  final writes = <int>[];
  @override
  (FlexSchemeColor, int) build() => (ThemeAA.schemes[0].light, 0);
  @override
  void setTheme(FlexSchemeColor color, int index) {
    writes.add(index);
    state = (color, index);
  }
}

class _Blend extends BlendLevelState {
  final writes = <double>[];
  @override
  double build() => 20;
  @override
  void setBlendLevel(double value, {bool end = false}) {
    state = value;
    if (end) writes.add(value);
  }
}

class _Scale extends AppUiScaleState {
  final commits = <double>[];
  @override
  double build() => 1;
  @override
  void set(double value, {bool end = false}) {
    state = value;
    if (end) commits.add(value);
  }
}

class _Font extends AppFontFamily {
  final writes = <String?>[];
  @override
  (String?, String?) build() => ('Roboto', 'Roboto');
  @override
  void set(String? value) {
    writes.add(value);
    state = (value, value);
  }
}

class _Locale extends L10nLocaleState {
  @override
  Locale build() => const Locale('en');
  @override
  void setLocale(Locale value) => state = value;
}

class _Relative extends RelativeTimesTampsState {
  @override
  int build() => 1;
  @override
  void set(int value) => state = value;
}

class _Date extends DateFormatState {
  @override
  String build() => 'yyyy-MM-dd';
  @override
  void set(String value) => state = value;
}
