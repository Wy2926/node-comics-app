import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/about/mobile_about_screen.dart';
import 'package:mangayomi/modules/more/about/mobile_app_update_view.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/about/providers/download_file_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mangayomi/services/app_update_downloads.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/link.dart';
// The existing platform plugin is replaced only for the owner lifecycle test.
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

final _package = PackageInfo(
  appName: 'NodeLane Preview',
  packageName: 'example.preview',
  version: '0.1.0',
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

class _Downloads implements AppUpdateDownloads {
  UpdateDownload? task;
  Completer<UpdateDownload>? pending;
  int starts = 0, cancels = 0, queries = 0, installs = 0;
  String? requestedNotes;
  bool installFails = false, queryFails = false;
  @override
  Future<UpdateDownload?> current() async {
    queries++;
    if (queryFails) throw StateError('download service unavailable');
    return task;
  }

  @override
  Future<UpdateDownload> start({
    required String version,
    required List<String> assets,
    required String title,
    required String notes,
  }) async {
    starts++;
    requestedNotes = notes;
    return task = await pending!.future;
  }

  @override
  Future<void> cancel(UpdateDownload download) async {
    cancels++;
    task = null;
  }

  @override
  Future<UpdateInstallResult> install(UpdateDownload download) async {
    installs++;
    if (installFails) throw StateError('installation unavailable');
    return UpdateInstallResult.permissionRequired;
  }
}

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: _package.appName,
      packageName: _package.packageName,
      version: _package.version,
      buildNumber: _package.buildNumber,
      buildSignature: '',
    );
  });

  Future<void> start(
    WidgetTester tester,
    Widget child, {
    double scale = 2.5,
    double height = 740,
    double width = 360,
    AppUpdateDownloads? downloads,
  }) async {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appUpdateDownloadsProvider.overrideWithValue(downloads)],
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
    required Future<UpdateInfo?> Function() onCheck,
    required Future<void> Function(UpdateInfo) onUpdate,
    Future<UpdateInfo?> Function()? onRestore,
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
    onRestoreUpdate: onRestore,
    updateBuilder: (update, onDismiss) => MobileAppUpdateView(
      currentVersion: _package.version,
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

  testWidgets(
    'update dialog keeps actions reachable without a separate background button',
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
                currentVersion: _package.version,
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
      expect(cancel, findsNothing);
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
      expect(cancel, findsNothing);
      rebuild(() {
        busy = false;
        installing = false;
        hasError = true;
        notes = '';
      });
      await tester.pumpAndSettle();
      await tester.tap(cancel);
      expect(canceled, 1);
      expect(find.text('Failed!'), findsOneWidget);
      await reveal(tester, find.text('Release notes'));
      await tester.tap(find.text('Release notes'));
      await tester.pumpAndSettle();
      expect(find.text('No release notes provided.'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Retry'));
      expect(continued, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'local update restores without a network check; restoration errors do not block checking',
    (tester) async {
      var checks = 0;
      await start(
        tester,
        about(
          onRestore: () async => _update,
          onCheck: () async {
            checks++;
            throw StateError('offline');
          },
          onUpdate: (_) async {},
        ),
        scale: 1,
      );
      expect(find.textContaining('1.0.0'), findsOneWidget);
      await tester.tap(find.text('Release notes'));
      await tester.pumpAndSettle();
      expect(find.text(_update.$2), findsOneWidget);
      expect(checks, 0);
      await tester.pumpWidget(const SizedBox());
      await start(
        tester,
        about(
          onRestore: () async => throw StateError('platform unavailable'),
          onCheck: () async {
            checks++;
            return null;
          },
          onUpdate: (_) async {},
        ),
        scale: 1,
      );
      await tester.tap(find.text('Check for update'));
      await tester.pumpAndSettle();
      expect(checks, 1);
      expect(
        find.text('No installable update found. You can try again later.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'download survives dismissal, restores after background, and only explicit cancellation removes it',
    (tester) async {
      final downloads = _Downloads()..pending = Completer<UpdateDownload>();
      var visible = true;
      var shownUpdate = _update;
      late StateSetter rebuild;
      await start(
        tester,
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return Scaffold(
              body: ListView(
                children: [
                  if (visible)
                    DownloadFileScreen(
                      updateAvailable: shownUpdate,
                      embedded: true,
                      onDismiss: () => setState(() => visible = false),
                    ),
                ],
              ),
            );
          },
        ),
        scale: 1,
        downloads: downloads,
      );
      await tester.tap(find.text('Download'));
      await tester.tap(find.text('Download'));
      await tester.pump();
      expect(downloads.starts, 1);
      expect(downloads.requestedNotes, _update.$2);
      expect(find.text('Continue in background'), findsNothing);
      rebuild(() => visible = false);
      await tester.pump();
      downloads.pending!.complete(
        const UpdateDownload(
          version: '1.0.0',
          url: 'https://example.invalid/app.apk',
          phase: UpdateDownloadPhase.downloading,
          notes: 'Sample release notes',
          received: 100,
          total: 1000,
        ),
      );
      await tester.pumpAndSettle();
      expect(downloads.cancels, 0);
      expect(downloads.task, isNotNull);
      rebuild(() {
        shownUpdate = ('1.0.0', '', '', <dynamic>[]);
        visible = true;
      });
      await tester.pump();
      await tester.pump();
      expect(find.text('10%'), findsOneWidget);
      await tester.tap(find.text('Release notes'));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Sample release notes'), findsOneWidget);
      downloads.queryFails = true;
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(find.text('Retry'), findsOneWidget);
      final failedQueries = downloads.queries;
      await tester.pump(const Duration(seconds: 3));
      expect(downloads.queries, failedQueries);
      downloads.queryFails = false;
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump();
      expect(find.text('Retry'), findsNothing);
      expect(downloads.starts, 1);
      for (final state in [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
      final before = downloads.queries;
      await tester.pump(const Duration(seconds: 5));
      expect(downloads.queries, before);
      downloads.task = const UpdateDownload(
        version: '1.0.0',
        url: 'https://example.invalid/app.apk',
        phase: UpdateDownloadPhase.ready,
        notes: 'Sample release notes',
        received: 1000,
        total: 1000,
      );
      for (final state in [
        AppLifecycleState.hidden,
        AppLifecycleState.inactive,
        AppLifecycleState.resumed,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
      await tester.pumpAndSettle();
      expect(find.text('Install'), findsOneWidget);
      downloads.installFails = true;
      await tester.tap(find.text('Install'));
      await tester.pumpAndSettle();
      expect(find.text('Failed!'), findsOneWidget);
      expect(downloads.task, isNotNull);
      downloads.installFails = false;
      await tester.tap(find.text('Install'));
      await tester.pumpAndSettle();
      expect(downloads.installs, 2);
      expect(find.textContaining('Allow app installation'), findsOneWidget);
      expect(downloads.cancels, 0);
      await tester.tap(find.text('Remove downloaded package'));
      await tester.pumpAndSettle();
      expect(downloads.cancels, 1);
      expect(downloads.task, isNull);
      expect(find.text('Download'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  for (final embedded in [false, true]) {
    testWidgets(
      'browser update (${embedded ? 'inline' : 'dialog'}) ignores dismissed results and recovers from failure',
      (tester) async {
        final oldLauncher = UrlLauncherPlatform.instance;
        final launcher = _Launcher();
        UrlLauncherPlatform.instance = launcher;
        addTearDown(() => UrlLauncherPlatform.instance = oldLauncher);
        var visible = false;
        await start(
          tester,
          StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: ListView(
                children: [
                  const Text('About owner'),
                  TextButton(
                    onPressed: () {
                      if (embedded) {
                        setState(() => visible = true);
                      } else {
                        showDialog<void>(
                          context: context,
                          builder: (_) => const DownloadFileScreen(
                            updateAvailable: _update,
                          ),
                        );
                      }
                    },
                    child: const Text('Open update'),
                  ),
                  if (visible)
                    DownloadFileScreen(
                      updateAvailable: _update,
                      embedded: true,
                      onDismiss: () => setState(() => visible = false),
                    ),
                ],
              ),
            ),
          ),
          scale: 1,
          width: embedded ? 360 : 800,
        );
        await tester.tap(find.text('Open update'));
        await tester.pumpAndSettle();
        expect(find.byType(Dialog), embedded ? findsNothing : findsOneWidget);
        await tester.tap(find.text('View update'));
        await tester.pump();
        expect(find.text('View update'), findsNothing);
        expect(launcher.calls, [
          (_update.$3, PreferredLaunchMode.externalApplication),
        ]);
        await tester.tap(find.text('Cancel'));
        // Completion during dismissal must not pop the containing About page.
        launcher.result.complete(true);
        await tester.pumpAndSettle();
        expect(find.text('About owner'), findsOneWidget);
        expect(find.byType(DownloadFileScreen), findsNothing);

        launcher.result = Completer<bool>();
        await tester.tap(find.text('Open update'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('View update'));
        await tester.pump();
        launcher.result.completeError(StateError('private launch detail'));
        await tester.pumpAndSettle();
        expect(find.text('Failed!'), findsOneWidget);
        expect(find.textContaining('private launch'), findsNothing);
        launcher.result = Completer<bool>();
        await tester.tap(find.text('View update'));
        await tester.pump();
        launcher.result.complete(true);
        await tester.pumpAndSettle();
        expect(launcher.calls, hasLength(3));
        expect(find.text('About owner'), findsOneWidget);
        expect(find.byType(Dialog), findsNothing);
        expect(
          find.byType(DownloadFileScreen),
          embedded ? findsOneWidget : findsNothing,
        );
        if (embedded) expect(find.text('Release page opened'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
