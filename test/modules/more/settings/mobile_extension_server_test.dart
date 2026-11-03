import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/settings/browse/mobile_extension_server_settings.dart';

void main() {
  var textScale = 1.0, keyboardInset = 0.0;
  Widget app(Widget child) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
        viewInsets: EdgeInsets.only(bottom: keyboardInset),
        padding: const EdgeInsets.only(top: 24, bottom: 34),
      ),
      child: child!,
    ),
    home: child,
  );

  setUp(() {
    textScale = 1;
    keyboardInset = 0;
  });

  Future<void> reveal(WidgetTester tester, String label) async {
    await tester.scrollUntilVisible(
      find.text(label),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'runtime controls wait for verification, recover unknown outcomes and ignore duplicate or late actions',
    (tester) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final checks = <Completer<bool>>[];
      final operations = <Completer<void>>[];
      final changes = <bool>[];
      final autoStartChanges = <bool>[];
      var getServer = 0;
      Widget screen() => MobileExtensionServerSettings(
        proxyAddress: 'http://127.0.0.1:8080',
        onProxyAddressChanged: (_) => fail('No address edit requested'),
        onGetServer: () => getServer++,
        showRuntime: true,
        autoStart: false,
        onAutoStartChanged: autoStartChanges.add,
        checkRuntime: () {
          final check = Completer<bool>();
          checks.add(check);
          return check.future;
        },
        onRuntimeChange: (running) {
          changes.add(running);
          final operation = Completer<void>();
          operations.add(operation);
          return operation.future;
        },
      );
      await tester.pumpWidget(app(screen()));
      expect(checks, hasLength(1));
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(find.text('Runtime status: Checking status…'), findsOneWidget);
      checks.last.completeError(StateError('private status detail'));
      await tester.pumpAndSettle();
      expect(find.text('Runtime status: Unknown'), findsOneWidget);
      expect(find.textContaining('private status detail'), findsNothing);
      await tester.tap(find.text('Refresh'));
      await tester.pump();
      expect(changes, isEmpty);
      checks.last.complete(false);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start'));
      await tester.tap(find.text('Start'));
      await tester.pump();
      expect(changes, [true]);
      expect(checks, hasLength(2));
      expect(
        tester
            .widget<NodeLaneRow>(
              find.ancestor(
                of: find.text('Set proxy address'),
                matching: find.byType(NodeLaneRow),
              ),
            )
            .onTap,
        isNull,
      );
      operations.last.complete();
      await tester.pump();
      expect(checks, hasLength(3));
      checks.last.complete(false);
      await tester.pumpAndSettle();
      expect(find.text('Runtime status: Stopped'), findsOneWidget);
      expect(find.text('Failed!'), findsOneWidget);

      await tester.tap(find.text('Start'));
      await tester.pump();
      operations.last.complete();
      await tester.pump();
      checks.last.complete(true);
      await tester.pumpAndSettle();
      expect(find.text('Runtime status: Running'), findsOneWidget);
      expect(find.text('Failed!'), findsNothing);
      await tester.tap(find.text('Stop'));
      await tester.pump();
      operations.last.completeError(StateError('private runtime detail'));
      await tester.pumpAndSettle();
      expect(find.text('Runtime status: Unknown'), findsOneWidget);
      expect(find.textContaining('private runtime detail'), findsNothing);
      await tester.tap(find.text('Refresh'));
      await tester.pump();
      expect(changes, [true, true, false]);
      checks.last.complete(true);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Stop'));
      await tester.pump();
      operations.last.complete();
      await tester.pump();
      checks.last.complete(false);
      await tester.pumpAndSettle();
      expect(find.text('Runtime status: Stopped'), findsOneWidget);
      await tester.tap(find.text('Start'));
      await tester.pump();
      expect(changes, [true, true, false, false, true]);
      final checksBeforeLeaving = checks.length;
      await tester.pumpWidget(const SizedBox());
      operations.last.complete();
      await tester.pumpAndSettle();
      expect(checks, hasLength(checksBeforeLeaving));
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(app(screen()));
      checks.last.complete(true);
      await tester.pumpAndSettle();
      // A larger font changes presentation without restarting or probing again.
      final checksBeforeResize = checks.length;
      textScale = 2.5;
      await tester.pumpWidget(app(screen()));
      await tester.pumpAndSettle();
      await reveal(tester, 'Start server on launch');
      await tester.tap(find.text('Start server on launch'));
      expect(autoStartChanges, [true]);
      expect(changes, [true, true, false, false, true]);
      expect(checks, hasLength(checksBeforeResize));
      await reveal(tester, 'Get M-Extension-Server');
      await tester.tap(find.text('Get M-Extension-Server'));
      expect(getServer, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'proxy address drafts cancel, reopen and preserve the existing save contract at large text',
    (tester) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      textScale = 2.5;
      final addresses = <String>[];
      var address = 'https://example.com/a/long/extension/proxy/path';
      Widget screen() => StatefulBuilder(
        builder: (context, setState) => MobileExtensionServerSettings(
          proxyAddress: address,
          onProxyAddressChanged: (value) {
            addresses.add(value);
            setState(() => address = value);
          },
          onGetServer: () {},
          showRuntime: false,
          autoStart: false,
          onAutoStartChanged: (_) => fail('No runtime controls on Android'),
          checkRuntime: () => throw StateError('No runtime check on Android'),
          onRuntimeChange: (_) =>
              throw StateError('No runtime action on Android'),
        ),
      );
      await tester.pumpWidget(app(screen()));
      await tester.pumpAndSettle();
      expect(find.text('Zero interpreter'), findsNothing);
      expect(find.text(address), findsOneWidget);
      await tester.tap(find.text('Set proxy address'));
      await tester.pumpAndSettle();
      keyboardInset = 180;
      await tester.pumpWidget(app(screen()));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'https://draft.example/');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(addresses, isEmpty);
      keyboardInset = 0;
      await tester.pumpWidget(app(screen()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Set proxy address'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        address,
      );
      await tester.enterText(find.byType(TextField), 'http://127.0.0.1:8080//');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(addresses, ['http://127.0.0.1:8080/']);
      await tester.tap(find.text('Set proxy address'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(addresses, ['http://127.0.0.1:8080/', '']);
      expect(find.text('—'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
