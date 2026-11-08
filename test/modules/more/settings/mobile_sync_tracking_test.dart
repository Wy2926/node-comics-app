import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/mobile_sync_screen.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_connection_status_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_progress_provider.dart';
import 'package:mangayomi/modules/more/settings/track/mobile_track_screen.dart';
import 'package:mangayomi/modules/more/settings/track/manage_trackers/mobile_manage_trackers.dart';
import 'package:mangayomi/modules/more/widgets/mobile_account_login_dialog.dart';

void main() {
  var keyboard = 0.0;
  setUp(() => keyboard = 0);
  Widget app(Widget home) => MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(2.5),
        padding: const EdgeInsets.only(top: 24, bottom: 34),
        viewInsets: EdgeInsets.only(bottom: keyboard),
      ),
      child: child!,
    ),
    home: home,
  );
  Future<void> start(WidgetTester tester, Widget home) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(home));
    await tester.pumpAndSettle();
  }

  Future<void> reveal(
    WidgetTester tester,
    Finder target, {
    double delta = 250,
  }) async {
    // A lazy list can refine its scroll extent after an expanded group lays out.
    for (var attempt = 0; attempt < 2; attempt++) {
      if (target.evaluate().isEmpty) {
        await tester.scrollUntilVisible(
          target,
          delta,
          scrollable: find.byType(Scrollable).first,
        );
      }
      await Scrollable.ensureVisible(tester.element(target), alignment: .5);
      await tester.pump(const Duration(milliseconds: 350));
      if (target.hitTestable().evaluate().isNotEmpty) return;
    }
  }

  Future<void> tap(
    WidgetTester tester,
    Finder target, {
    double delta = 250,
  }) async {
    await reveal(tester, target, delta: delta);
    await tester.tap(target);
    await tester.pump(const Duration(milliseconds: 350));
  }

  testWidgets(
    'server login keeps a cancellable address draft and submits the original text only on confirmation',
    (tester) async {
      final submitted = <Map<String, String>>[];
      final home = Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => showNodeLaneCatalogSheet<void>(
              context,
              MobileAccountLoginDialog(
                title: AppLocalizations.of(context)!
                    .login_into(AppLocalizations.of(context)!.sync_service),
                submitLabel: 'Log in with browser',
                fields: const [
                  MobileAccountField(
                    id: 'server',
                    label: 'Sync Server Address',
                    initialValue: 'https://example.test/',
                    keyboardType: TextInputType.url,
                  ),
                ],
                onSubmit: (values) async {
                  submitted.add(values);
                  return (true, '');
                },
              ),
              dismissible: false,
            ),
            child: const Text('Open'),
          ),
        ),
      );
      await start(tester, home);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final field = find.byKey(const ValueKey('account-server'));
      expect(
        tester.widget<NodeLaneTextField>(field).controller!.text,
        'https://example.test/',
      );
      keyboard = 300;
      await tester.pumpWidget(app(home));
      await tester.enterText(field, '  ');
      await tester.pumpAndSettle();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tester.enterText(field, 'https://draft.test/');
      await tap(tester, find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(submitted, isEmpty);
      keyboard = 0;
      await tester.pumpWidget(app(home));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<NodeLaneTextField>(field).controller!.text,
        'https://example.test/',
      );
      await tester.enterText(field, ' https://exact.test/path/ ');
      await tap(tester, find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(submitted, [
        {'server': ' https://exact.test/path/ '},
      ]);
      expect(find.byType(MobileAccountLoginDialog), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'credential form preserves password text, gates duplicate submits and keeps the draft after a failed response',
    (tester) async {
      final submitted = <Map<String, String>>[];
      var result = Completer<(bool, String)>();
      final home = Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => showNodeLaneCatalogSheet<void>(
              context,
              MobileAccountLoginDialog(
                title: 'Login into Kitsu',
                submitLabel: 'Login',
                fields: const [
                  MobileAccountField(
                    id: 'email',
                    label: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  MobileAccountField(
                    id: 'password',
                    label: 'Password',
                    secret: true,
                  ),
                ],
                onSubmit: (values) {
                  submitted.add(values);
                  return result.future;
                },
              ),
              dismissible: false,
            ),
            child: const Text('Open'),
          ),
        ),
      );
      await start(tester, home);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final email = find.byKey(const ValueKey('account-email'));
      final password = find.byKey(const ValueKey('account-password'));
      keyboard = 300;
      await tester.pumpWidget(app(home));
      await tester.enterText(email, ' name@example.test ');
      await reveal(tester, password);
      await tester.enterText(password, ' pass phrase ');
      await tap(tester, find.byTooltip('Show password'));
      expect(tester.widget<NodeLaneTextField>(password).obscureText, false);
      await tap(tester, find.byTooltip('Hide password'));
      expect(tester.widget<NodeLaneTextField>(password).obscureText, true);
      final submit = tester
          .widget<FilledButton>(find.byType(FilledButton))
          .onPressed!;
      submit();
      submit();
      await tester.pump();
      expect(submitted, [
        {'email': ' name@example.test ', 'password': ' pass phrase '},
      ]);
      expect(tester.widget<NodeLaneTextField>(password).enabled, false);
      expect(
        tester
            .widget<NodeLaneCloseButton>(find.byType(NodeLaneCloseButton))
            .onPressed,
        isNull,
      );
      await Navigator.of(tester.element(find.byType(MobileAccountLoginDialog)))
          .maybePop();
      await tester.pump();
      expect(find.byType(MobileAccountLoginDialog), findsOneWidget);
      result.complete((false, 'Login rejected'));
      await tester.pumpAndSettle();
      await reveal(tester, find.text('Login rejected'));
      expect(find.text('Login rejected'), findsOneWidget);
      expect(
        tester.widget<NodeLaneTextField>(password).controller!.text,
        ' pass phrase ',
      );
      result = Completer<(bool, String)>();
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed!();
      await tester.pump();
      expect(submitted.length, 2);
      result.complete((true, ''));
      await tester.pumpAndSettle();
      expect(find.byType(MobileAccountLoginDialog), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sync frequency keeps eight choices, cancellation, hidden values and no work on expansion',
    (tester) async {
      var preference = SyncPreference(
        syncId: 1,
        authToken: 'fixture-token',
        server: 'https://example.test',
        syncOn: true,
        autoSyncFrequency: 987,
      );
      var failed = true, retries = 0, syncs = 0;
      final frequencies = <int>[], enabled = <bool>[];
      late StateSetter update;
      final home = StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return MobileSyncSettings(
            preference: preference,
            connection: SyncConnectionStatus.connected,
            progress: const SyncProgressState(),
            loadFailed: failed,
            onRetry: () {
              retries++;
              update(() => failed = false);
            },
            onEnabledChanged: (value) {
              enabled.add(value);
              update(
                () =>
                    preference = SyncPreference.fromJson(preference.toJson())
                      ..syncOn = value,
              );
            },
            onFrequencyChanged: (value) {
              frequencies.add(value);
              update(
                () =>
                    preference = SyncPreference.fromJson(preference.toJson())
                      ..autoSyncFrequency = value,
              );
            },
            onRecheck: () {},
            onLogin: () async {},
            onLogout: () {},
            onSync: (_) async {
              syncs++;
              return true;
            },
          );
        },
      );
      await start(tester, home);
      await tap(tester, find.widgetWithText(OutlinedButton, 'Retry'));
      await tester.pumpAndSettle();
      expect(retries, 1);
      expect(find.text('fixture-token'), findsNothing);
      final frequency = find.widgetWithText(NodeLaneRow, 'Auto Sync');
      await tap(tester, frequency);
      await tester.pumpAndSettle();
      final choices = [
        'Off',
        'Every 5 minutes',
        'Every 10 minutes',
        'Every 30 minutes',
        'Every 1 hour',
        'Every 3 hours',
        'Every 6 hours',
        'Every 12 hours',
      ];
      for (final label in choices) {
        await reveal(tester, find.widgetWithText(NodeLaneRow, label));
      }
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(frequencies, isEmpty);
      await tap(tester, frequency, delta: -250);
      await tester.pumpAndSettle();
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Every 12 hours'));
      await tester.pumpAndSettle();
      expect(frequencies, [43200]);
      await tap(tester, find.text('Advanced'));
      await tap(tester, find.text('About'));
      expect(syncs, 0);
      expect(enabled, isEmpty);
      await tap(tester, find.byType(NodeLaneSwitchRow), delta: -250);
      await tester.pumpAndSettle();
      expect(enabled, [false]);
      expect(find.widgetWithText(NodeLaneRow, 'Auto Sync'), findsNothing);
      expect(
        preference.autoSyncFrequency,
        43200,
      ); // The view delegates the original off/reset policy to its caller.
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sync operations recheck availability after confirmation, prevent repeats and report the existing result',
    (tester) async {
      var connection = SyncConnectionStatus.connected;
      var progress = const SyncProgressState();
      var result = Completer<bool>();
      final calls = <MobileSyncAction>[];
      var logouts = 0;
      late StateSetter update;
      final home = StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return MobileSyncSettings(
            preference: SyncPreference(
              syncId: 1,
              authToken: 'fixture-token',
              syncOn: true,
            ),
            connection: connection,
            progress: progress,
            onRetry: () {},
            onEnabledChanged: (_) {},
            onFrequencyChanged: (_) {},
            onRecheck: () {},
            onLogin: () async {},
            onLogout: () => logouts++,
            onSync: (action) {
              calls.add(action);
              return result.future;
            },
          );
        },
      );
      await start(tester, home);
      await tap(tester, find.text('Advanced'));
      final upload = find.widgetWithText(OutlinedButton, 'Upload only');
      await tap(tester, upload);
      await tap(tester, find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(calls, isEmpty);
      await tap(tester, upload);
      update(() => connection = SyncConnectionStatus.unreachable);
      await tester.pump();
      await tap(tester, find.widgetWithText(FilledButton, 'Confirm'));
      await tester.pumpAndSettle();
      expect(calls, isEmpty);
      update(() => connection = SyncConnectionStatus.connected);
      await tester.pumpAndSettle();
      await tap(tester, upload);
      await tap(tester, find.widgetWithText(FilledButton, 'Confirm'));
      expect(calls, [MobileSyncAction.upload]);
      expect(tester.widget<OutlinedButton>(upload).onPressed, isNull);
      result.complete(false);
      await tester.pumpAndSettle();
      await reveal(tester, find.text('Sync failed'), delta: -250);
      result = Completer<bool>();
      final sync = find.widgetWithText(FilledButton, 'Sync progress');
      await reveal(tester, sync, delta: -250);
      final startSync = tester.widget<FilledButton>(sync).onPressed!;
      startSync();
      startSync();
      await tester.pump();
      expect(calls, [MobileSyncAction.upload, MobileSyncAction.sync]);
      result.complete(true);
      await tester.pumpAndSettle();
      await reveal(tester, find.text('Sync finished'));
      update(
        () =>
            progress = const SyncProgressState(active: true, done: 1, total: 4),
      );
      await tester.pump();
      expect(tester.widget<FilledButton>(sync).onPressed, isNull);
      await reveal(tester, find.text('Syncing… 25%'));
      update(() => progress = const SyncProgressState());
      await tester.pumpAndSettle();
      final logout = find.widgetWithText(TextButton, 'Log out');
      await tap(tester, logout, delta: -250);
      await tap(tester, find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(logouts, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'tracking keeps service identity, explicit logout and account-management selection',
    (tester) async {
      final account = TrackPreference(
        syncId: 2,
        username: '987654321',
        displayName: 'Reader with a long account name',
        oAuth: 'fixture-token',
      );
      final accounts = [account];
      final logins = <int>[], logouts = <int>[], updates = <bool>[];
      var manages = 0;
      var loginResult = Completer<void>();
      late StateSetter update;
      final home = StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return MobileTrackingSettings(
            entries: accounts,
            updateProgress: true,
            onUpdateProgress: updates.add,
            onLogin: (id) {
              logins.add(id);
              return loginResult.future;
            },
            onLogout: (id) {
              logouts.add(id);
              update(() => accounts.removeWhere((entry) => entry.syncId == id));
            },
            onManage: () => manages++,
            onRetry: () {},
          );
        },
      );
      await start(tester, home);
      expect(find.text('987654321'), findsNothing);
      expect(find.text('fixture-token'), findsNothing);
      await tap(tester, find.byType(NodeLaneSwitchRow));
      expect(updates, [false]);
      final connected = find.byKey(const ValueKey('tracker-account-2'));
      final logout = find.descendant(
        of: connected,
        matching: find.widgetWithText(TextButton, 'Log out'),
      );
      await tap(tester, logout);
      await tap(tester, find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(logouts, isEmpty);
      await tap(tester, logout);
      await tap(tester, find.widgetWithText(FilledButton, 'Log out'));
      await tester.pumpAndSettle();
      expect(logouts, [2]);
      final kitsu = find.byKey(const ValueKey('tracker-account-3'));
      final login = find.descendant(
        of: kitsu,
        matching: find.widgetWithText(TextButton, 'Login'),
      );
      await reveal(tester, login);
      final signIn = tester.widget<TextButton>(login).onPressed!;
      signIn();
      signIn();
      await tester.pump();
      expect(logins, [3]);
      loginResult.completeError(StateError('unavailable'));
      await tester.pumpAndSettle();
      await reveal(tester, find.text('Failed!'), delta: -250);
      for (final id in [2, 3, 1, 4]) {
        await reveal(tester, find.byKey(ValueKey('tracker-account-$id')));
      }
      expect(find.byKey(const ValueKey('tracker-account-5')), findsNothing);
      expect(find.text('Trakt'), findsNothing);
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Manage trackers'));
      expect(manages, 1);
      final opened = <TrackPreference>[];
      await tester.pumpWidget(
        app(MobileManageTrackers(preferences: [account], onOpen: opened.add)),
      );
      await tester.pumpAndSettle();
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Anilist'));
      expect(opened.single, same(account));
      await tester.pumpWidget(
        app(MobileManageTrackers(preferences: const [], onOpen: opened.add)),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Connect a service in Tracking settings to manage its entries.',
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
