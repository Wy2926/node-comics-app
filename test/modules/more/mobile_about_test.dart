import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/about/mobile_about_screen.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:package_info_plus/package_info_plus.dart';

final _package = PackageInfo(
  appName: 'NodeLane Preview',
  packageName: 'example.preview',
  version: '0.1.0',
  buildNumber: '1',
);
void main() {
  Future<void> start(
    WidgetTester tester,
    Widget child, {
    double scale = 2.5,
    double height = 740,
    double width = 360,
  }) async {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          navigatorObservers: [BotToastNavigatorObserver()],
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(scale),
              padding: const EdgeInsets.only(top: 24, bottom: 34),
            ),
            child: BotToastInit()(context, child),
          ),
          home: child,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> reveal(
    WidgetTester tester,
    Finder target, {
    double delta = 200,
  }) async {
    await tester.scrollUntilVisible(
      target,
      delta,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump(const Duration(milliseconds: 150));
  }

  MobileAboutScreen about({
    AsyncValue<PackageInfo>? packageInfo,
    VoidCallback? onRetry,
    bool autoCheck = false,
    ValueChanged<bool>? onAuto,
    bool logs = false,
    Future<void> Function(bool)? onLogs,
    Future<void> Function()? onShare,
    int Function()? reportCount,
    Future<void> Function()? onReports,
    Future<void> Function()? onUpdates,
  }) => MobileAboutScreen(
    packageInfo: packageInfo ?? AsyncData(_package),
    onRetryPackageInfo: onRetry ?? () {},
    checkForUpdates: autoCheck,
    onAutoCheckChanged: onAuto ?? (_) {},
    logsEnabled: logs,
    onLogsChanged: onLogs ?? (_) async {},
    reportCount: reportCount ?? () => 0,
    onReports: onReports ?? () async {},
    onUpdates: onUpdates ?? () async {},
    onShareLogs: onShare ?? () async {},
    onGitHub: () async {},
  );

  testWidgets(
    'package retry, preferences, report count and sharing keep their own state',
    (tester) async {
      var package = const AsyncValue<PackageInfo>.error(
        'private package detail',
        StackTrace.empty,
      );
      var autoCheck = false, logs = true;
      var retries = 0, reportCount = 3, shares = 0;
      final sharing = Completer<void>();
      late StateSetter rebuild;
      await start(
        tester,
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return about(
              packageInfo: package,
              onRetry: () {
                retries++;
                rebuild(() => package = AsyncData(_package));
              },
              autoCheck: autoCheck,
              onAuto: (value) => rebuild(() => autoCheck = value),
              logs: logs,
              onLogs: (value) async {
                rebuild(() => logs = value);
              },
              onShare: () {
                shares++;
                return sharing.future;
              },
              reportCount: () => reportCount,
              onReports: () async {
                reportCount = 0;
              },
            );
          },
        ),
      );
      expect(find.textContaining('private package'), findsNothing);
      await tester.tap(find.widgetWithText(TextButton, 'Retry'));
      await tester.pumpAndSettle();
      expect(retries, 1);
      expect(find.text('NodeLane Comics'), findsOneWidget);
      expect(find.text('Version 0.1.0'), findsOneWidget);
      final auto = find.byType(NodeLaneSwitchRow).first;
      await reveal(tester, auto);
      await tester.tap(auto);
      await tester.pumpAndSettle();
      expect(autoCheck, isTrue);
      expect(logs, isTrue);
      await reveal(tester, find.text('Diagnostics and logs'));
      await tester.tap(find.text('Diagnostics and logs'));
      await tester.pumpAndSettle();
      final reports = find.text('Error reports');
      await reveal(tester, reports);
      expect(find.textContaining(' · 3'), findsOneWidget);
      await tester.tap(reports);
      await tester.pumpAndSettle();
      expect(find.textContaining(' · 3'), findsNothing);
      final share = find.widgetWithText(NodeLaneRow, 'Share app logs');
      await reveal(tester, share);
      await tester.tap(share);
      await tester.pump();
      expect(tester.widget<NodeLaneRow>(share).enabled, isFalse);
      expect(shares, 1);
      sharing.completeError(StateError('private path'));
      await tester.pumpAndSettle();
      expect(tester.widget<NodeLaneRow>(share).enabled, isTrue);
      expect(find.textContaining('private path'), findsNothing);
      final logging = find.widgetWithText(NodeLaneSwitchRow, 'Enable logging');
      await reveal(tester, logging, delta: -150);
      await tester.tap(logging);
      await tester.pumpAndSettle();
      expect(logs, isFalse);
      expect(autoCheck, isTrue);
      expect(find.text('Share app logs'), findsNothing);
      final repository = find.text('Wy2926/node-comics-app');
      await reveal(tester, repository, delta: -200);
      expect(tester.getRect(repository).bottom, lessThan(706));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('About exposes one guarded update entry and no welcome replay', (
    tester,
  ) async {
    var opens = 0;
    final pending = Completer<void>();
    await start(
      tester,
      about(
        onUpdates: () {
          opens++;
          return pending.future;
        },
      ),
      scale: 1,
    );
    final entry = find.text('Check for update');
    await tester.tap(entry);
    await tester.tap(entry);
    expect(opens, 1);
    expect(find.text('Show the welcome screen'), findsNothing);
    pending.complete();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
