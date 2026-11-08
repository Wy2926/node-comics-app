import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/providers/algorithm_weights_state_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/general/mobile_general_screen.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';
import 'package:mangayomi/modules/more/settings/general/providers/memory_probe_provider.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_text_dialog.dart';

void main() {
  Widget app(Widget child) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2.5)),
      child: child!,
    ),
    home: child,
  );

  void size(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets(
    'update choices preserve Wi-Fi preference and weight edits stay independent',
    (tester) async {
      size(tester);
      final container = ProviderContainer(
        overrides: [
          autoLibraryUpdateIntervalStateProvider.overrideWith(_Interval.new),
          autoLibraryUpdateWifiOnlyStateProvider.overrideWith(_Wifi.new),
          showNavDoubleTapTooltipStateProvider.overrideWith(_Tooltip.new),
          memoryOverlayVisibleProvider.overrideWith(_Memory.new),
          algorithmWeightsStateProvider.overrideWith(_Weights.new),
        ],
      );
      addTearDown(container.dispose);
      // Keep the fake's in-memory persistence while its row is hidden.
      final wifiSubscription = container.listen(
        autoLibraryUpdateWifiOnlyStateProvider,
        (_, _) {},
      );
      addTearDown(wifiSubscription.close);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: app(const MobileGeneralScreen()),
        ),
      );
      await tester.pumpAndSettle();
      final update = find.widgetWithText(
        NodeLaneRow,
        'Automatic library updates',
      );
      expect(
        find.descendant(of: update, matching: find.text('Never')),
        findsOneWidget,
      );
      Future<void> openUpdate() async {
        await tester.ensureVisible(update);
        await tester.pumpAndSettle();
        await tester.tap(update);
        await tester.pumpAndSettle();
      }

      await openUpdate();
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      final interval = container.read(
        autoLibraryUpdateIntervalStateProvider.notifier,
      ) as _Interval;
      expect(interval.writes, isEmpty);
      Future<void> choose(int value) async {
        await openUpdate();
        final tiles = tester
            .widgetList<NodeLaneRow>(find.byType(NodeLaneRow))
            .toList();
        final index = [0, 12, 24, 48, 168].indexOf(value);
        final tile = find.byWidget(tiles[index]);
        await tester.ensureVisible(tile);
        await tester.pumpAndSettle();
        await tester.tap(tile);
        await tester.pumpAndSettle();
      }

      await choose(24);
      final wifi = find.byType(NodeLaneSwitchRow).first;
      await tester.ensureVisible(wifi);
      await tester.pumpAndSettle();
      await tester.tap(wifi);
      await tester.pumpAndSettle();
      expect(container.read(autoLibraryUpdateWifiOnlyStateProvider), isFalse);
      await choose(0);
      await choose(24);
      expect(container.read(autoLibraryUpdateWifiOnlyStateProvider), isFalse);
      expect(interval.writes, [24, 0, 24]);

      final weightsSection = find.widgetWithText(
        NodeLaneDisclosure,
        'Recommendation Weights',
      );
      await tester.scrollUntilVisible(weightsSection, 250);
      await tester.pumpAndSettle();
      expect(find.text('Discord'), findsNothing);
      await tester.tap(weightsSection);
      await tester.pumpAndSettle();
      final slider = find.byType(Slider).first;
      await tester.ensureVisible(slider);
      await tester.pumpAndSettle();
      await tester.drag(slider, const Offset(45, 0));
      await tester.pumpAndSettle();
      final weights =
          container.read(algorithmWeightsStateProvider.notifier) as _Weights;
      expect(weights.writes, hasLength(1));
      expect(weights.writes.single.genre, isNot(30));
      expect(weights.writes.single.setting, 15);
      expect(weights.writes.single.synopsis, 40);
      expect(weights.writes.single.theme, 20);
      await tester.ensureVisible(find.widgetWithText(TextButton, 'Reset'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Reset'));
      await tester.pumpAndSettle();
      expect(weights.writes, hasLength(2));
      expect(weights.writes.last.genre, 30);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'text settings can cancel above the keyboard and distinguish an empty value',
    (tester) async {
      size(tester);
      final results = <String?>[];
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  results.add(
                    await showDialog<String>(
                      context: context,
                      builder: (_) => MobileSettingsTextDialog(
                        title: 'Custom network service address',
                        initialValue: 'https://original.invalid',
                        helper: 'The existing address is kept until you confirm. Leave empty to disable.',
                        isValid: (value) =>
                            value.isEmpty || value.startsWith('https://'),
                      ),
                    ),
                  );
                },
                child: const Text('Edit'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'invalid');
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Confirm'))
            .onPressed,
        isNull,
      );
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(results, [null]);
      tester.view.viewInsets = FakeViewPadding.zero;
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(results, [null, '']);
      expect(tester.takeException(), isNull);
    },
  );
}

class _Interval extends AutoLibraryUpdateIntervalState {
  final writes = <int>[];
  @override
  int build() => 0;
  @override
  void set(int value) {
    writes.add(value);
    state = value;
  }
}

class _Wifi extends AutoLibraryUpdateWifiOnlyState {
  @override
  bool build() => true;
  @override
  void set(bool value) => state = value;
}

class _Tooltip extends ShowNavDoubleTapTooltipState {
  @override
  bool build() => true;
  @override
  void set(bool value) => state = value;
}

class _Memory extends MemoryOverlayVisible {
  @override
  bool build() => false;
  @override
  void set(bool value) => state = value;
}

class _Weights extends AlgorithmWeightsState {
  final writes = <AlgorithmWeights>[];
  @override
  AlgorithmWeights build() => AlgorithmWeights();
  @override
  void set(AlgorithmWeights value) {
    writes.add(value);
    state = value;
  }
}
