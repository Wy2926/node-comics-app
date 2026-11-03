import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/about/mobile_about_screen.dart';
import 'package:mangayomi/modules/more/about/mobile_app_update_view.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/about/providers/download_file_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/link.dart';
// The existing platform plugin is replaced only for the owner lifecycle test.
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

final _package = PackageInfo(
  appName: 'NodeLane Preview',
  packageName: 'example.preview',
  version: '0.9.9',
  buildNumber: '1',
);
const UpdateInfo _update = (
  '1.0.0',
  'Sample release notes',
  'https://example.invalid/release',
  <dynamic>[],
);

class _Launcher extends UrlLauncherPlatform {
  Completer<bool> result = Completer<bool>();
  final calls = <(String, PreferredLaunchMode)>[];
  @override
  LinkDelegate? get linkDelegate => null;
  @override
  Future<bool> launchUrl(String url, LaunchOptions options) {
    calls.add((url, options.mode));
    return result.future;
  }
}

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
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
            padding: const EdgeInsets.only(top: 24, bottom: 34),
          ),
          child: child!,
        ),
        home: child,
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
    required Future<UpdateInfo?> Function() onCheck,
    required Future<void> Function(UpdateInfo) onUpdate,
  }) => MobileAboutScreen(
    packageInfo: packageInfo ?? AsyncData(_package),
    onRetryPackageInfo: onRetry ?? () {},
    checkForUpdates: autoCheck,
    onAutoCheckChanged: onAuto ?? (_) {},
    logsEnabled: logs,
    onLogsChanged: onLogs ?? (_) async {},
    reportCount: reportCount ?? () => 0,
    onReports: onReports ?? () async {},
    onCheck: onCheck,
    updateBuilder: (update, onDismiss) => MobileAppUpdateView(
      currentVersion: '0.9.9',
      targetVersion: update.$1,
      notes: update.$2,
      downloadOnDevice: false,
      busy: false,
      installing: false,
      received: 0,
      total: 0,
      hasError: false,
      embedded: true,
      onContinue: () => onUpdate(update),
      onCancel: onDismiss,
    ),
    onShareLogs: onShare ?? () async {},
    onGitHub: () async {},
    onDiscord: () async {},
  );

  testWidgets(
    'manual checks stay independent, guard repeats and ignore late results after leaving',
    (tester) async {
      var pending = Completer<UpdateInfo?>();
      var checks = 0;
      final opened = <UpdateInfo>[];
      await start(
        tester,
        about(
          onCheck: () {
            checks++;
            return pending.future;
          },
          onUpdate: (value) async {
            opened.add(value);
          },
        ),
      );
      final check = find.widgetWithText(NodeLaneRow, 'Check for update');
      await reveal(tester, check);
      await tester.tap(check);
      await tester.pump();
      expect(find.textContaining('Searching for updates'), findsOneWidget);
      expect(checks, 1);
      // Manual checking still works with automatic checks disabled.
      pending.complete(null);
      await tester.pumpAndSettle();
      expect(
        find.text('No installable update found. You can try again later.'),
        findsOneWidget,
      );
      expect(opened, isEmpty);
      pending = Completer<UpdateInfo?>();
      await tester.tap(check);
      await tester.pump();
      pending.completeError(StateError('private network detail'));
      await tester.pumpAndSettle();
      expect(
        find.text('Unable to check for updates. Please try again.'),
        findsOneWidget,
      );
      expect(find.textContaining('private network'), findsNothing);
      pending = Completer<UpdateInfo?>();
      await tester.tap(check);
      await tester.pump();
      await tester.pumpWidget(const SizedBox());
      pending.complete(_update);
      await tester.pumpAndSettle();
      expect(checks, 3);
      expect(opened, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'available release stays inline until the user chooses its action',
    (tester) async {
      final opened = <UpdateInfo>[];
      await start(
        tester,
        about(
          onCheck: () async => _update,
          onUpdate: (update) async => opened.add(update),
        ),
        scale: 1,
      );
      await tester.tap(find.text('Check for update'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      expect(find.text('NodeLane Comics 1.0.0'), findsOneWidget);
      expect(opened, isEmpty);
      await reveal(tester, find.text('View update'));
      await tester.tap(find.text('View update'));
      await tester.pumpAndSettle();
      expect(opened, [_update]);
      expect(identical(opened.single.$4, _update.$4), isTrue);
      expect(tester.takeException(), isNull);
    },
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
              onCheck: () async => null,
              onUpdate: (_) async {},
            );
          },
        ),
      );
      expect(find.textContaining('private package'), findsNothing);
      await tester.tap(find.widgetWithText(TextButton, 'Retry'));
      await tester.pumpAndSettle();
      expect(retries, 1);
      expect(find.text('NodeLane Comics'), findsOneWidget);
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
      final discord = find.text('Mangayomi · Discord');
      await reveal(tester, discord, delta: -200);
      expect(tester.getRect(discord).bottom, lessThan(706));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'update dialog keeps cancel reachable while notes and transfer states change',
    (tester) async {
      var busy = false, installing = false, hasError = false, android = false;
      var received = 0, total = 0, continued = 0, canceled = 0;
      var notes = List.filled(
        20,
        'Long release notes remain selectable and scrollable.',
      ).join('\n');
      late StateSetter rebuild;
      await start(
        tester,
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return Scaffold(
              body: MobileAppUpdateView(
                currentVersion: '0.9.9',
                targetVersion: '1.0.0',
                notes: notes,
                downloadOnDevice: android,
                busy: busy,
                installing: installing,
                received: received,
                total: total,
                hasError: hasError,
                onContinue: () => continued++,
                onCancel: () => canceled++,
              ),
            );
          },
        ),
        height: 600,
      );
      final cancel = find.byType(TextButton);
      expect(cancel.hitTestable(), findsOneWidget);
      expect(tester.getRect(cancel).bottom, lessThan(566));
      await tester.tap(find.widgetWithText(FilledButton, 'View update'));
      expect(continued, 1);
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -350),
      );
      await tester.pumpAndSettle();
      expect(cancel.hitTestable(), findsOneWidget);
      rebuild(() {
        android = true;
        busy = true;
        received = 524288;
      });
      await tester.pump();
      expect(find.byType(FilledButton), findsNothing);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        isNull,
      );
      rebuild(() => total = 1048576);
      await tester.pump();
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        .5,
      );
      rebuild(() => installing = true);
      await tester.pump();
      expect(find.text('Preparing installation…'), findsOneWidget);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        isNull,
      );
      await tester.tap(cancel);
      expect(canceled, 1);
      rebuild(() {
        busy = false;
        installing = false;
        hasError = true;
        notes = '';
      });
      await tester.pumpAndSettle();
      expect(find.text('Failed!'), findsOneWidget);
      await reveal(tester, find.text('Release notes'));
      await tester.tap(find.text('Release notes'));
      await tester.pumpAndSettle();
      expect(find.text('No release notes provided.'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Download'));
      expect(continued, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'update owner cancels delayed browser completion without popping its parent and allows retry',
    (tester) async {
      PackageInfo.setMockInitialValues(
        appName: 'Preview',
        packageName: 'example.preview',
        version: '0.9.9',
        buildNumber: '1',
        buildSignature: '',
      );
      final oldLauncher = UrlLauncherPlatform.instance;
      final launcher = _Launcher();
      UrlLauncherPlatform.instance = launcher;
      addTearDown(() => UrlLauncherPlatform.instance = oldLauncher);
      await start(
        tester,
        ProviderScope(
          child: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) =>
                      const DownloadFileScreen(updateAvailable: _update),
                ),
                child: const Text('Open sample'),
              ),
            ),
          ),
        ),
        scale: 1,
        width: 800,
      );
      await tester.tap(find.text('Open sample'));
      await tester.pumpAndSettle();
      final primary = find.byType(FilledButton);
      await tester.tap(primary);
      await tester.pump();
      expect(find.byType(FilledButton), findsNothing);
      expect(launcher.calls, [
        (_update.$3, PreferredLaunchMode.externalApplication),
      ]);
      await tester.tap(find.text('Cancel'));
      // Complete during the closing transition, when mounted is still true.
      launcher.result.complete(true);
      await tester.pumpAndSettle();
      expect(find.text('Open sample'), findsOneWidget);
      expect(tester.takeException(), isNull);
      launcher.result = Completer<bool>();
      await tester.tap(find.text('Open sample'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      launcher.result.completeError(StateError('private launch detail'));
      await tester.pumpAndSettle();
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.textContaining('private launch detail'), findsNothing);
      launcher.result = Completer<bool>();
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      launcher.result.complete(true);
      await tester.pumpAndSettle();
      expect(launcher.calls, hasLength(3));
      expect(find.text('Open sample'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'inline update owner cancels locally and retries without closing About',
    (tester) async {
      PackageInfo.setMockInitialValues(
        appName: 'NodeLane Comics',
        packageName: 'example.preview',
        version: '0.9.9',
        buildNumber: '1',
        buildSignature: '',
      );
      final oldLauncher = UrlLauncherPlatform.instance;
      final launcher = _Launcher();
      UrlLauncherPlatform.instance = launcher;
      addTearDown(() => UrlLauncherPlatform.instance = oldLauncher);
      var visible = true;
      late StateSetter rebuild;
      await start(
        tester,
        ProviderScope(
          child: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return Scaffold(
                body: ListView(
                  children: [
                    const Text('About owner'),
                    if (visible)
                      DownloadFileScreen(
                        updateAvailable: _update,
                        embedded: true,
                        onDismiss: () => setState(() => visible = false),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        scale: 1,
      );
      expect(find.byType(Dialog), findsNothing);
      await tester.tap(find.text('View update'));
      await tester.pump();
      expect(launcher.calls, hasLength(1));
      expect(find.text('View update'), findsNothing);
      await tester.tap(find.text('Cancel'));
      launcher.result.complete(true);
      await tester.pumpAndSettle();
      expect(find.text('About owner'), findsOneWidget);
      expect(find.byType(DownloadFileScreen), findsNothing);
      launcher.result = Completer<bool>();
      rebuild(() => visible = true);
      await tester.pumpAndSettle();
      await tester.tap(find.text('View update'));
      await tester.pump();
      launcher.result.completeError(StateError('private launch details'));
      await tester.pumpAndSettle();
      expect(find.text('Failed!'), findsOneWidget);
      expect(find.textContaining('private launch'), findsNothing);
      launcher.result = Completer<bool>();
      await tester.tap(find.text('View update'));
      await tester.pump();
      launcher.result.complete(true);
      await tester.pumpAndSettle();
      expect(find.text('Release page opened'), findsOneWidget);
      expect(find.text('About owner'), findsOneWidget);
      expect(find.byType(Dialog), findsNothing);
      expect(launcher.calls, hasLength(3));
      expect(tester.takeException(), isNull);
    },
  );
}
