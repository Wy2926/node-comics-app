import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/mobile_navigation_settings.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/router/router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ProviderContainer container() => ProviderContainer(
    overrides: [
      navigationOrderStateProvider.overrideWith(_Order.new),
      hideItemsStateProvider.overrideWith(_Hidden.new),
      animeOnlyTvModeProvider.overrideWith(_Tv.new),
    ],
  );

  testWidgets(
    'dragging moves one slot both ways without mutating the previous preference',
    (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final state = container();
      addTearDown(state.dispose);
      final scale = ValueNotifier(1.0);
      addTearDown(scale.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: state,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            builder: (context, child) => ValueListenableBuilder(
              valueListenable: scale,
              builder: (_, value, _) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(value)),
                child: child!,
              ),
            ),
            home: const MobileNavigationSettings(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Finder row(String route) => find.byKey(ValueKey(route));
      final before = state.read(navigationOrderStateProvider);
      final handle = find.descendant(
        of: row('/MangaLibrary'),
        matching: find.byType(ReorderableDragStartListener),
      );
      final distance = tester.getSize(row('/MangaLibrary')).height + 8;
      Future<void> drag(double dy) async {
        final gesture = await tester.startGesture(tester.getCenter(handle));
        await tester.pump();
        await gesture.moveBy(Offset(0, dy / 2));
        await tester.pump(const Duration(milliseconds: 300));
        await gesture.moveBy(Offset(0, dy / 2));
        await tester.pump(const Duration(milliseconds: 300));
        await gesture.up();
      }

      await drag(distance);
      await tester.pumpAndSettle();
      expect(state.read(navigationOrderStateProvider).take(2), [
        '/AnimeLibrary',
        '/MangaLibrary',
      ]);
      expect(before.take(2), ['/MangaLibrary', '/AnimeLibrary']);
      await drag(-distance);
      await tester.pumpAndSettle();
      expect(state.read(navigationOrderStateProvider), before);

      final mangaSwitch = find.descendant(
        of: row('/MangaLibrary'),
        matching: find.byType(SwitchListTile),
      );
      await tester.tap(mangaSwitch);
      await tester.pumpAndSettle();
      expect(state.read(hideItemsStateProvider), [
        '/trackerLibrary',
        '/MangaLibrary',
      ]);
      await tester.tap(mangaSwitch);
      await tester.pumpAndSettle();
      expect(state.read(hideItemsStateProvider), ['/trackerLibrary']);
      scale.value = 2.5;
      await tester.pumpAndSettle();
      for (final route in ['/browse', '/more']) {
        await tester.scrollUntilVisible(row(route), 250);
        await tester.pumpAndSettle();
        final toggle = tester.widget<SwitchListTile>(
          find.descendant(
            of: row(route),
            matching: find.byType(SwitchListTile),
          ),
        );
        expect(toggle.onChanged, isNull);
        expect(toggle.value, isTrue);
      }
      expect(
        (state.read(navigationOrderStateProvider.notifier) as _Order).writes,
        2,
      );
      expect(tester.takeException(), isNull);
    },
  );

  test('navigation changes retain the router and current location; a new router uses the new first tab', () async {
    final state = container();
    addTearDown(state.dispose);
    final orderSubscription = state.listen(
      navigationOrderStateProvider,
      (_, _) {},
    );
    addTearDown(orderSubscription.close);
    final subscription = state.listen(routerProvider, (_, _) {});
    addTearDown(subscription.close);
    final router = state.read(routerProvider);
    addTearDown(router.dispose);
    router.go('/customNavigationSettings');
    final reordered = state.read(navigationOrderStateProvider).toList();
    reordered.insert(0, reordered.removeAt(3));
    state.read(navigationOrderStateProvider.notifier).set(reordered);
    await state.pump();
    expect(identical(state.read(routerProvider), router), isTrue);
    expect(
      router.routeInformationProvider.value.uri.path,
      '/customNavigationSettings',
    );
    state.invalidate(routerProvider);
    final restarted = state.read(routerProvider);
    addTearDown(restarted.dispose);
    expect(restarted.routeInformationProvider.value.uri.path, '/updates');
  });
}

class _Order extends NavigationOrderState {
  var writes = 0;
  @override
  List<String> build() => items.toList();
  @override
  void set(List<String> value) {
    writes++;
    state = value;
  }
}

class _Hidden extends HideItemsState {
  @override
  List<String> build() => ['/trackerLibrary'];
  @override
  void set(List<String> value) => state = value;
}

class _Tv extends AnimeOnlyTvMode {
  @override
  bool build() => false;
  @override
  void set(bool value) => state = value;
}
