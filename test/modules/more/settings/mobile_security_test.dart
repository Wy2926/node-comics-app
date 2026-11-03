import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/settings/security/app_lock_screen.dart';
import 'package:mangayomi/modules/more/settings/security/mobile_security_views.dart';
import 'package:mangayomi/modules/more/settings/security/providers/security_state_provider.dart';
import 'package:mangayomi/modules/more/settings/security/security_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget app(Widget child, {double textScale = 1}) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
        padding: const EdgeInsets.only(top: 24, bottom: 34),
      ),
      child: child!,
    ),
    home: child,
  );

  ProviderContainer preferences() {
    final container = ProviderContainer(
      overrides: [
        appLockEnabledStateProvider.overrideWith(_Enabled.new),
        appUnlockedStateProvider.overrideWith(_Unlocked.new),
      ],
    );
    addTearDown(container.dispose);
    // The production preferences are persisted, while these fakes are in memory.
    final enabled = container.listen(appLockEnabledStateProvider, (_, _) {});
    final unlocked = container.listen(appUnlockedStateProvider, (_, _) {});
    addTearDown(enabled.close);
    addTearDown(unlocked.close);
    return container;
  }

  testWidgets(
    'security changes require successful authentication and ignore duplicate or late responses',
    (tester) async {
      final auth = _DeviceAuth();
      final container = preferences();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: app(const SecurityScreen()),
        ),
      );
      await tester.pump();
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile)).onChanged,
        isNull,
      );
      // No biometrics, but a device credential is supported by the existing API.
      auth.supported.complete(true);
      await tester.pumpAndSettle();
      final enabled =
          container.read(appLockEnabledStateProvider.notifier) as _Enabled;
      final unlocked =
          container.read(appUnlockedStateProvider.notifier) as _Unlocked;
      Future<void> toggle() async {
        await tester.tap(find.byType(SwitchListTile));
        await tester.pump();
      }

      await toggle();
      await toggle();
      expect(auth.requests, hasLength(1));
      expect(auth.arguments.single['biometricOnly'], isFalse);
      expect(auth.arguments.single['stickyAuth'], isTrue);
      expect(auth.arguments.single['sensitiveTransaction'], isTrue);
      auth.requests.last.completeError(PlatformException(code: 'userCanceled'));
      await tester.pumpAndSettle();
      expect(enabled.writes, isEmpty);

      await toggle();
      auth.requests.last.complete(true);
      await tester.pumpAndSettle();
      expect(enabled.writes, [true]);
      expect(unlocked.unlocks, 0);

      await toggle();
      auth.requests.last.complete(false);
      await tester.pumpAndSettle();
      expect(container.read(appLockEnabledStateProvider), isTrue);
      expect(unlocked.unlocks, 0);
      await toggle();
      auth.requests.last.complete(true);
      await tester.pumpAndSettle();
      expect(enabled.writes, [true, false]);
      expect(unlocked.unlocks, 1);

      await toggle();
      await tester.pumpWidget(const SizedBox());
      auth.requests.last.complete(true);
      await tester.pumpAndSettle();
      expect(enabled.writes, [true, false]);
      expect(unlocked.unlocks, 1);

      auth.supported = Completer<bool>();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: app(const SecurityScreen()),
        ),
      );
      await tester.pump();
      auth.supported.completeError(PlatformException(code: 'unavailable'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile)).onChanged,
        isNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'locked screen retries after failure without duplicate authentication or late unlock',
    (tester) async {
      final auth = _DeviceAuth();
      final container = preferences();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: app(const AppLockScreen()),
        ),
      );
      await tester.pump();
      final unlocked =
          container.read(appUnlockedStateProvider.notifier) as _Unlocked;
      expect(auth.requests, hasLength(1));
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      auth.requests.last.complete(false);
      await tester.pumpAndSettle();
      expect(unlocked.unlocks, 0);

      await tester.tap(find.byType(FilledButton));
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(auth.requests, hasLength(2));
      auth.requests.last.completeError(PlatformException(code: 'unavailable'));
      await tester.pumpAndSettle();
      expect(unlocked.unlocks, 0);
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      auth.requests.last.complete(true);
      await tester.pumpAndSettle();
      expect(unlocked.unlocks, 1);

      await tester.tap(find.byType(FilledButton));
      await tester.pumpWidget(const SizedBox());
      auth.requests.last.complete(true);
      await tester.pumpAndSettle();
      expect(unlocked.unlocks, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'mobile security views scroll at large text and hide locked content from semantics and taps',
    (tester) async {
      tester.view.physicalSize = const Size(320, 440);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final semantics = tester.ensureSemantics();
      try {
        var retries = 0;
        var backgroundTaps = 0;
        Widget locked(bool busy) => app(
          Stack(
            fit: StackFit.expand,
            children: [
              Scaffold(
                body: TextButton(
                  onPressed: () => backgroundTaps++,
                  child: const Text('Private library'),
                ),
              ),
              MobileAppLockView(
                isAuthenticating: busy,
                onUnlock: () => retries++,
              ),
            ],
          ),
          textScale: 2.5,
        );
        await tester.pumpWidget(locked(false));
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel('Private library'), findsNothing);
        await tester.tapAt(const Offset(30, 45));
        expect(backgroundTaps, 0);
        await tester.ensureVisible(find.byType(FilledButton));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(FilledButton));
        expect(retries, 1);
        await tester.pumpWidget(locked(true));
        await tester.pumpAndSettle();
        expect(
          tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
          isNull,
        );
        expect(find.bySemanticsLabel('Private library'), findsNothing);

        await tester.pumpWidget(
          app(
            const MobileSecuritySettingsView(
              enabled: false,
              canAuthenticate: false,
              isChecking: true,
              isAuthenticating: false,
              onChanged: null,
            ),
            textScale: 2.5,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Checking device authentication…'), findsOneWidget);
        expect(
          tester
              .widget<NodeLaneSwitchRow>(find.byType(NodeLaneSwitchRow))
              .onChanged,
          isNull,
        );
        await tester.pumpWidget(
          app(
            const MobileSecuritySettingsView(
              enabled: false,
              canAuthenticate: false,
              isChecking: false,
              isAuthenticating: false,
              authenticationIncomplete: true,
              onChanged: null,
            ),
            textScale: 2.5,
          ),
        );
        await tester.pumpAndSettle();
        final notice = find.text(
          'Authentication was not completed. Your setting has not changed.',
        );
        await tester.scrollUntilVisible(notice, 250);
        await tester.pumpAndSettle();
        expect(notice, findsOneWidget);
        final description = find.textContaining('When app lock is enabled');
        await tester.scrollUntilVisible(description, 250);
        await tester.drag(find.byType(ListView), const Offset(0, -1500));
        await tester.pumpAndSettle();
        expect(
          tester.getBottomRight(description).dy,
          lessThanOrEqualTo(440 - 34),
        );
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );
}

class _DeviceAuth {
  _DeviceAuth() {
    const channel = MethodChannel('plugins.flutter.io/local_auth');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'getAvailableBiometrics':
          return <String>[];
        case 'isDeviceSupported':
          return supported.future;
        case 'authenticate':
          final request = Completer<bool>();
          requests.add(request);
          arguments.add(Map<String, Object?>.from(call.arguments as Map));
          return request.future;
        default:
          throw UnsupportedError(call.method);
      }
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
  }

  Completer<bool> supported = Completer<bool>();
  final requests = <Completer<bool>>[];
  final arguments = <Map<String, Object?>>[];
}

class _Enabled extends AppLockEnabledState {
  final writes = <bool>[];
  @override
  bool build() => false;
  @override
  void set(bool value) {
    writes.add(value);
    state = value;
  }
}

class _Unlocked extends AppUnlockedState {
  var unlocks = 0;
  @override
  bool build() => false;
  @override
  void unlock() {
    unlocks++;
    state = true;
  }
}
