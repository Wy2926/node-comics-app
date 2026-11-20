import 'package:mangayomi/services/app_update_manifest.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/about/app_update_dialog.dart';
import 'package:mangayomi/modules/more/about/software_update_screen.dart';
import 'package:mangayomi/modules/more/about/software_update_view.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/about/providers/get_package_info.dart';
import 'package:mangayomi/modules/widgets/nodelane_progress.dart';
import 'package:mangayomi/services/app_update_downloads.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:package_info_plus/package_info_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/link.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

final _package = PackageInfo(
  appName: 'NodeLane Preview',
  packageName: 'example.preview',
  version: '0.1.0',
  buildNumber: '1',
);
const _update = UpdateInfo(
  version: '1.0.0',
  build: 2,
  notes: 'Sample release notes',
  pageUrl: 'https://example.invalid/release',
  url: 'https://example.invalid/app.apk',
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
  UpdateDelta? requestedDelta;
  UpdateInfo? requestedRelease;
  bool installFails = false, queryFails = false;
  @override
  Future<UpdateDownload?> current() async {
    queries++;
    if (queryFails) throw StateError('download service unavailable');
    return task;
  }

  @override
  Future<UpdateDownload> start({
    required UpdateInfo release,
    required String title,
    UpdateDelta? delta,
  }) async {
    starts++;
    requestedNotes = release.notes;
    requestedDelta = delta;
    requestedRelease = release;
    return task = await pending!.future;
  }

  @override
  Future<void> cancel(UpdateDownload download) async {
    cancels++;
    task = null;
  }

  @override
  Future<UpdateDownload?> discardFailed(UpdateDownload download) async {
    if (task?.identity == download.identity &&
        task?.phase == UpdateDownloadPhase.failed) {
      task = null;
    }
    return task;
  }

  @override
  Future<UpdateInstallResult> install(UpdateDownload download) async {
    installs++;
    if (installFails) throw StateError('installation unavailable');
    return UpdateInstallResult.permissionRequired;
  }
}

void main() {
  Future<GoRouter> start(
    WidgetTester tester, {
    AppUpdateDownloads? downloads,
    Future<UpdateInfo?> Function()? check,
    bool open = true,
    double scale = 1,
    double width = 390,
    double height = 844,
    bool dark = false,
    PackageInfo? installed,
  }) async {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(
            body: Column(
              children: [
                const Text('About owner'),
                TextButton(
                  onPressed: () => context.push('/appUpdate'),
                  child: const Text('Check for update'),
                ),
                TextButton(
                  onPressed: () => showAppUpdateAnnouncement(context, _update),
                  child: const Text('Announce'),
                ),
              ],
            ),
          ),
        ),
        GoRoute(
          path: '/appUpdate',
          builder: (_, state) =>
              SoftwareUpdateScreen(update: state.extra as UpdateInfo?),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appUpdateDownloadsProvider.overrideWithValue(downloads),
          manualAppUpdateCheckProvider.overrideWithValue(
            check ?? () async => _update,
          ),
          getPackageInfoProvider.overrideWith(
            (_) async => installed ?? _package,
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          theme: nodeLaneModalTheme(
            ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: dark ? Brightness.dark : Brightness.light,
              ),
            ),
          ),
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
        ),
      ),
    );
    await tester.pumpAndSettle();
    if (open) {
      await tester.tap(find.text('Check for update'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
    }
    return router;
  }

  testWidgets(
    'manual check guards repeats, retries failure and ignores completion after leaving',
    (tester) async {
      var pending = Completer<UpdateInfo?>();
      var checks = 0;
      final router = await start(
        tester,
        check: () {
          checks++;
          return pending.future;
        },
        scale: 2.5,
        width: 360,
        height: 740,
      );
      expect(find.textContaining('Searching for updates'), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
      expect(checks, 1);
      pending.complete(null);
      await tester.pumpAndSettle();
      expect(
        find.text('No installable update found. You can try again later.'),
        findsOneWidget,
      );
      pending = Completer<UpdateInfo?>();
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      pending.completeError(StateError('private network detail'));
      await tester.pumpAndSettle();
      expect(
        find.text('Unable to check for updates. Please try again.'),
        findsOneWidget,
      );
      expect(find.textContaining('private network'), findsNothing);
      pending = Completer<UpdateInfo?>();
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      router.pop();
      await tester.pumpAndSettle();
      pending.complete(_update);
      await tester.pumpAndSettle();
      expect(checks, 3);
      expect(find.text('About owner'), findsOneWidget);
      expect(find.byType(SoftwareUpdateScreen), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'reminder only navigates; manual and reminder entries share one page',
    (tester) async {
      var checks = 0;
      final downloads = _Downloads();
      final oldLauncher = UrlLauncherPlatform.instance;
      final launcher = _Launcher();
      UrlLauncherPlatform.instance = launcher;
      addTearDown(() => UrlLauncherPlatform.instance = oldLauncher);
      final router = await start(
        tester,
        open: false,
        downloads: downloads,
        check: () async {
          checks++;
          return _update;
        },
      );
      await tester.tap(find.text('Announce'));
      await tester.pumpAndSettle();
      expect(find.byType(AppUpdateDialog), findsOneWidget);
      expect(find.byType(SoftwareUpdateView), findsNothing);
      expect(downloads.queries, 0);
      await tester.tap(find.text('Later'));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/');
      await tester.tap(find.text('Announce'));
      await tester.pumpAndSettle();
      final view = tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'View update'),
          )
          .onPressed!;
      view();
      view();
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/appUpdate');
      expect(find.byType(SoftwareUpdateScreen), findsOneWidget);
      expect(find.text('Sample release notes'), findsOneWidget);
      expect(find.byType(Dialog), findsNothing);
      expect(downloads.starts, 0);
      expect(launcher.calls, isEmpty);
      expect(checks, 0);
      // Another startup result cannot stack a reminder on the update page.
      await showAppUpdateAnnouncement(
        tester.element(find.byType(SoftwareUpdateScreen)),
        _update,
      );
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      router.pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check for update'));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/appUpdate');
      expect(checks, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'browser opens direct or page URLs, preserves notes, retries and ignores late completion',
    (tester) async {
      final oldLauncher = UrlLauncherPlatform.instance;
      final launcher = _Launcher();
      UrlLauncherPlatform.instance = launcher;
      addTearDown(() => UrlLauncherPlatform.instance = oldLauncher);
      var release = const UpdateInfo(
        version: '1.2',
        platform: 'ios',
        url: 'http://cdn.example:8080/get?package=app.ipa',
        notes: 'Changes\nFull Changelog: https://example.org/changes',
      );
      final router = await start(tester, check: () async => release);
      await tester.pumpAndSettle();
      expect(find.text(release.notes), findsOneWidget);
      expect(launcher.calls, isEmpty);
      final open = find.widgetWithText(FilledButton, 'Open in browser');
      await tester.tap(open);
      await tester.tap(open);
      await tester.pump();
      expect(launcher.calls, [
        (release.url, PreferredLaunchMode.externalApplication),
      ]);
      launcher.result.complete(false);
      await tester.pumpAndSettle();
      expect(find.text('Failed!'), findsOneWidget);
      launcher.result = Completer<bool>();
      await tester.tap(open);
      await tester.pump();
      launcher.result.complete(true);
      await tester.pumpAndSettle();
      expect(find.text('Update link opened'), findsOneWidget);
      expect(router.state.uri.path, '/appUpdate');
      launcher.result = Completer<bool>();
      await tester.tap(open);
      await tester.pump();
      router.pop();
      await tester.pumpAndSettle();
      launcher.result.complete(true);
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/');
      release = _update;
      launcher.result = Completer<bool>();
      await tester.tap(find.text('Check for update'));
      await tester.pumpAndSettle();
      await tester.tap(open);
      await tester.pump();
      expect(launcher.calls.last, (
        _update.pageUrl,
        PreferredLaunchMode.externalApplication,
      ));
      launcher.result.complete(true);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('native service failure does not block discovery', (
    tester,
  ) async {
    var checks = 0;
    await start(
      tester,
      downloads: _Downloads()..queryFails = true,
      check: () async {
        checks++;
        return _update;
      },
    );
    await tester.pumpAndSettle();
    expect(checks, 1);
    expect(find.text('Download update'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'late patch failure and offline recovery require an explicit full download',
    (tester) async {
      const patch = UpdateDelta(
        '0.2.0',
        4007,
        'base',
        'https://example.invalid/change',
        1048576,
        'patch',
      );
      const release = UpdateInfo(
        version: '0.2.1',
        build: 4008,
        url: 'https://example.invalid/full.apk',
        size: 10485760,
        sha256: 'target',
        delta: patch,
      );
      const failed = UpdateDownload(
        version: '0.2.1',
        build: 4008,
        url: 'https://example.invalid/full.apk',
        phase: UpdateDownloadPhase.failed,
        isDelta: true,
        fullSize: 10485760,
        sha256: 'target',
      );
      final downloads = _Downloads()..pending = Completer<UpdateDownload>();
      final router = await start(
        tester,
        downloads: downloads,
        check: () async => release,
        installed: PackageInfo(
          appName: 'test',
          packageName: 'test',
          version: '0.2.0',
          buildNumber: '4007',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Download patch (1.0 MiB)'), findsOneWidget);
      // Native failure arrives after the last UI snapshot, before the tap is handled.
      downloads.task = failed;
      await tester.tap(find.text('Download patch (1.0 MiB)'));
      await tester.pumpAndSettle();
      expect(downloads.starts, 0);
      expect(find.text('Download full APK (10.0 MiB)'), findsOneWidget);
      router.pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check for update'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Download full APK (10.0 MiB)'));
      await tester.pump();
      expect(downloads.starts, 1);
      expect(downloads.requestedDelta, isNull);
      downloads.pending!.complete(
        const UpdateDownload(
          version: '0.2.1',
          build: 4008,
          url: 'https://example.invalid/full.apk',
          phase: UpdateDownloadPhase.ready,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Install'), findsOneWidget);
    },
  );

  testWidgets(
    'failed transfer can recheck offline, accept a rotated URL and refresh after cancellation',
    (tester) async {
      const failed = UpdateDownload(
        version: '0.2.1',
        build: 4008,
        url: 'https://old.example/a.apk',
        phase: UpdateDownloadPhase.failed,
        isDelta: true,
        fullSize: 10485760,
        sha256: 'target',
      );
      const rotated = UpdateInfo(
        version: '0.2.1',
        build: 4008,
        url: 'https://new.example/a.apk',
        size: 11534336,
        sha256: 'target',
      );
      const next = UpdateInfo(
        version: '0.2.2',
        build: 4009,
        url: 'https://new.example/b.apk',
        size: 12582912,
      );
      final downloads = _Downloads()
        ..task = failed
        ..pending = Completer<UpdateDownload>();
      var checks = 0;
      await start(
        tester,
        downloads: downloads,
        check: () async {
          switch (++checks) {
            case 1:
              throw StateError('offline');
            case 2:
              return rotated;
            default:
              return next;
          }
        },
      );
      await tester.pumpAndSettle();
      expect(downloads.task, same(failed));
      expect(find.text('Download full APK (10.0 MiB)'), findsOneWidget);
      await tester.tap(find.text('Check for update'));
      await tester.pumpAndSettle();
      expect(downloads.task, isNull);
      expect(downloads.starts, 0);
      await tester.tap(find.text('Download full APK (11.0 MiB)'));
      await tester.pump();
      expect(downloads.requestedRelease?.url, rotated.url);
      downloads.pending!.complete(
        const UpdateDownload(
          version: '0.2.1',
          build: 4008,
          url: 'https://new.example/a.apk',
          phase: UpdateDownloadPhase.downloading,
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Cancel download'));
      await tester.pumpAndSettle();
      expect(find.text('0.2.2'), findsOneWidget);
      expect(find.text('Download full APK (12.0 MiB)'), findsOneWidget);
      expect(downloads.starts, 1);
      expect(checks, 3);
    },
  );

  testWidgets('rechecking a failed task cannot remove a new active transfer', (
    tester,
  ) async {
    final downloads = _Downloads()
      ..task = const UpdateDownload(
        version: '0.2.1',
        build: 2,
        url: 'https://old.example/a.apk',
        phase: UpdateDownloadPhase.failed,
      );
    final query = Completer<UpdateInfo?>();
    await start(tester, downloads: downloads, check: () => query.future);
    const replacement = UpdateDownload(
      version: '0.2.2',
      build: 3,
      url: 'https://old.example/retry.apk',
      phase: UpdateDownloadPhase.downloading,
      received: 2,
      total: 10,
    );
    downloads.task = replacement;
    query.complete(null);
    await tester.pumpAndSettle();
    expect(downloads.task, same(replacement));
    expect(find.text('20%'), findsOneWidget);
    expect(downloads.cancels, 0);
  });

  testWidgets(
    'retry shows a replacement target before starting a failed full download',
    (tester) async {
      const original = UpdateInfo(
        version: '0.2.1',
        build: 4008,
        size: 1048576,
        url: 'https://cdn.example/old',
      );
      const next = UpdateInfo(
        version: '0.2.2',
        build: 4009,
        size: 2097152,
        url: 'https://cdn.example/new',
      );
      final downloads = _Downloads()
        ..task = UpdateDownload(
          version: original.version,
          build: original.build,
          fullSize: original.size,
          url: original.url,
          phase: UpdateDownloadPhase.failed,
        );
      var offer = original;
      await start(tester, downloads: downloads, check: () async => offer);
      await tester.pumpAndSettle();
      offer = next;
      await tester.tap(find.text('Download full APK (1.0 MiB)'));
      await tester.pumpAndSettle();
      expect(find.text(next.version), findsOneWidget);
      expect(find.text('Download full APK (2.0 MiB)'), findsOneWidget);
      expect(downloads.starts, 0);
      expect(downloads.task, isNull);
    },
  );

  testWidgets(
    'a replacement patch URL is offered without automatically starting it or the full APK',
    (tester) async {
      const oldUrl = 'https://cdn.example/expired';
      const fullUrl = 'https://cdn.example/full';
      final downloads = _Downloads()
        ..task = const UpdateDownload(
          version: '0.2.1',
          build: 4008,
          url: fullUrl,
          fullSize: 2097152,
          isDelta: true,
          patchUrl: oldUrl,
          phase: UpdateDownloadPhase.failed,
        );
      var patchUrl = oldUrl;
      await start(
        tester,
        downloads: downloads,
        installed: PackageInfo(
          appName: 'test',
          packageName: 'test',
          version: '0.2.0',
          buildNumber: '4007',
        ),
        check: () async => UpdateInfo(
          version: '0.2.1',
          build: 4008,
          url: fullUrl,
          size: 2097152,
          delta: UpdateDelta('0.2.0', 4007, 'base', patchUrl, 1048576, 'patch'),
        ),
      );
      await tester.pumpAndSettle();
      patchUrl = 'https://cdn.example/renewed';
      await tester.tap(find.text('Check for update'));
      await tester.pumpAndSettle();
      expect(find.text('Download patch (1.0 MiB)'), findsOneWidget);
      expect(downloads.starts, 0);
      expect(downloads.task, isNull);
    },
  );

  testWidgets(
    'download survives leaving, resumes offline, retries, keeps position, and installs without redownloading',
    (tester) async {
      final downloads = _Downloads()..pending = Completer<UpdateDownload>();
      var checks = 0;
      final router = await start(
        tester,
        downloads: downloads,
        check: () async {
          checks++;
          return _update;
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Download update'));
      await tester.tap(find.text('Download update'));
      await tester.pump();
      expect(downloads.starts, 1);
      expect(downloads.requestedNotes, _update.notes);
      router.pop();
      await tester.pumpAndSettle();
      downloads.pending!.complete(
        UpdateDownload(
          version: '1.0.0',
          build: 2,
          url: 'https://example.invalid/app.apk',
          phase: UpdateDownloadPhase.downloading,
          notes: List.filled(30, 'Saved release notes').join('\n'),
          received: 100,
          total: 1000,
        ),
      );
      await tester.pumpAndSettle();
      expect(downloads.cancels, 0);
      await tester.tap(find.text('Check for update'));
      await tester.pumpAndSettle();
      expect(checks, 1);
      expect(find.text('10%'), findsOneWidget);
      final scroll = find
          .descendant(
            of: find.byKey(const PageStorageKey('app-update-content')),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.drag(scroll, const Offset(0, -400));
      await tester.pumpAndSettle();
      final position = tester.state<ScrollableState>(scroll).position.pixels;
      expect(position, greaterThan(0));
      downloads.queryFails = true;
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(find.text('Retry'), findsOneWidget);
      final queries = downloads.queries;
      await tester.pump(const Duration(seconds: 3));
      expect(downloads.queries, queries);
      downloads.queryFails = false;
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump();
      expect(downloads.starts, 1);
      expect(tester.state<ScrollableState>(scroll).position.pixels, position);
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
        build: 2,
        url: 'https://example.invalid/app.apk',
        phase: UpdateDownloadPhase.ready,
        notes: 'Saved release notes',
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
      downloads.installFails = true;
      await tester.tap(find.text('Install'));
      await tester.pumpAndSettle();
      expect(find.text('Failed!'), findsOneWidget);
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
      expect(find.text('Download update'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'unknown progress, waiting and installation use the shared progress style',
    (tester) async {
      var installing = false, waiting = true, failed = false, total = 0;
      late StateSetter rebuild;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: StatefulBuilder(
            builder: (_, setState) {
              rebuild = setState;
              return Scaffold(
                body: SoftwareUpdateView(
                  currentVersion: '1',
                  targetVersion: '2',
                  notes: '',
                  downloadOnDevice: true,
                  busy: !failed,
                  installing: installing,
                  waiting: waiting,
                  received: 512,
                  total: total,
                  hasError: failed,
                  onContinue: () {},
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(NodeLaneProgress), findsOneWidget);
      LinearProgressIndicator progress() =>
          tester.widget(find.byType(LinearProgressIndicator));
      expect(progress().value, isNull);
      expect(find.textContaining('Waiting for the system'), findsOneWidget);
      rebuild(() {
        total = 1024;
        waiting = false;
      });
      await tester.pump();
      expect(progress().value, .5);
      expect(progress().trackGap, 0);
      expect(progress().stopIndicatorRadius, 0);
      rebuild(() => installing = true);
      await tester.pump();
      expect(progress().value, isNull);
      expect(find.text('Preparing installation…'), findsOneWidget);
      rebuild(() {
        failed = true;
        installing = false;
      });
      await tester.pumpAndSettle();
      expect(find.text('Retry').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'short screens, large text, RTL, themes and long versions retain usable controls',
    (tester) async {
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      for (final dark in [false, true]) {
        for (final locale in [const Locale('zh'), const Locale('ar')]) {
          var actions = 0;
          await tester.pumpWidget(
            MaterialApp(
              theme: nodeLaneModalTheme(
                ThemeData(
                  brightness: dark ? Brightness.dark : Brightness.light,
                ),
              ),
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(2.5),
                  highContrast: dark,
                ),
                child: child!,
              ),
              home: Scaffold(
                body: SoftwareUpdateView(
                  currentVersion: '0.10.99',
                  targetVersion: '2026.11.100',
                  notes: List.filled(30, 'Release notes').join('\n'),
                  downloadOnDevice: true,
                  busy: false,
                  installing: false,
                  received: 0,
                  total: 0,
                  hasError: false,
                  onContinue: () => actions++,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.tap(find.byType(FilledButton));
          expect(actions, 1);
          await tester.drag(
            find.byKey(const PageStorageKey('app-update-content')),
            const Offset(0, -450),
          );
          await tester.pumpAndSettle();
          expect(find.byType(FilledButton).hitTestable(), findsOneWidget);
        }
      }
      final router = await start(
        tester,
        open: false,
        scale: 2.5,
        width: 320,
        height: 480,
      );
      await tester.tap(find.text('Announce'));
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(FilledButton, 'View update').hitTestable(),
        findsOneWidget,
      );
      expect(find.text('Later').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Later'));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/');
    },
  );
}
