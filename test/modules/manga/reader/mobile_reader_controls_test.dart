import 'dart:async';

import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_widgets.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_entry_state.dart';
import 'package:mangayomi/modules/webview/browser_pinned_sources_provider.dart';
import 'package:mangayomi/modules/webview/browser_session_store.dart';
import 'package:mangayomi/modules/webview/mobile_browser_home.dart';
import 'package:mangayomi/modules/webview/mobile_browser_start_page.dart';

void main() {
  Future<void> mount(
    WidgetTester tester,
    Widget child, {
    double height = 600,
  }) async {
    tester.view.physicalSize = Size(320, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(2),
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              viewPadding: const EdgeInsets.only(top: 24, bottom: 24),
            ),
            child: child!,
          ),
          home: Scaffold(body: child),
        ),
      ),
    );
  }

  testWidgets('chapter entry retains context and bounds retry while leaving', (
    tester,
  ) async {
    final retry = Completer<void>();
    var retries = 0, backs = 0;
    String? failure;
    late StateSetter change;
    await mount(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          change = setState;
          return MobileReaderEntryState(
            bookTitle: 'A long comic title with retained context',
            chapterTitle: 'Chapter 12 — The letter from the sea',
            failureMessage: failure,
            failureDescription: 'The site refused access (HTTP 403).',
            onRetry: () {
              retries++;
              return retry.future;
            },
            onBack: () => backs++,
          );
        },
      ),
      height: 800,
    );
    await tester.pump(const Duration(milliseconds: 50));
    final title = find.text('A long comic title with retained context');
    final before = tester.getTopLeft(title);
    expect(find.text('Getting chapter images…'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Retry'), findsNothing);
    expect(find.byTooltip('Open in-app browser'), findsNothing);
    expect(find.textContaining('HTTP 403'), findsNothing);
    change(() => failure = 'Could not load this chapter');
    await tester.pump();
    expect(tester.getTopLeft(title), before);
    expect(find.byTooltip('Open in-app browser'), findsOneWidget);
    expect(find.textContaining('HTTP 403'), findsOneWidget);
    final button = find.widgetWithText(FilledButton, 'Retry');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.tap(button);
    expect(retries, 1);
    await tester.pump();
    expect(find.text('Chapter 12 — The letter from the sea'), findsOneWidget);
    expect(button, findsNothing);
    expect(find.byTooltip('Open in-app browser'), findsNothing);
    expect(find.textContaining('HTTP 403'), findsNothing);
    await tester.tap(find.byTooltip('Back'));
    expect(backs, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    retry.complete();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'each chapter browser visit selects a fresh tab, even for the same URL',
    (tester) async {
      FlutterSecureStorage.setMockInitialValues({});
      const url = 'https://example.test/chapter';
      final saved = {
        'id': 'reading',
        'url': url,
        'active': true,
        'y': 426,
        'history': ['https://example.test/series', url],
      };
      await browserSessionStore.save([saved]);
      final requests = <Completer<String?>>[];
      final router = GoRouter(
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (_, _, shell) => shell,
            branches: [
              for (final path in ['/', '/browser'])
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: path,
                      builder: (_, _) => Scaffold(body: Text('Tab $path')),
                    ),
                  ],
                ),
            ],
          ),
          GoRoute(
            path: '/mangawebview',
            builder: (_, state) => Scaffold(
              appBar: AppBar(),
              body: Text((state.extra! as Map)['url'] as String),
            ),
          ),
          GoRoute(
            path: '/reader',
            builder: (_, _) => MobileReaderEntryState(
              failureMessage: 'No images found for this chapter',
              resolveBrowserUrl: () {
                final request = Completer<String?>();
                requests.add(request);
                return request.future;
              },
              onBack: () {},
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [browserPinnedSourcesProvider.overrideWithValue([])],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      unawaited(router.push('/reader'));
      await tester.pumpAndSettle();
      expect(find.text('No images found for this chapter'), findsOneWidget);
      expect(find.textContaining('connection'), findsNothing);
      final open = find.byTooltip('Open in-app browser');
      await tester.tap(open);
      requests.single.complete(null);
      await tester.pumpAndSettle();
      expect(find.byType(MobileBrowserHome), findsOneWidget);
      final blank = browserSessionStore.entries.last;
      expect(blank['url'], '');
      expect(blank['active'], true);
      tester
          .widget<MobileBrowserStartPage>(find.byType(MobileBrowserStartPage))
          .onOpen(url, '');
      await tester.pumpAndSettle();
      expect(find.text(url), findsOneWidget);
      expect((router.state.extra as Map)['tabId'], blank['id']);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.byType(MobileBrowserHome), findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('No images found for this chapter'), findsOneWidget);
      for (final count in [3, 4]) {
        await tester.tap(open);
        await tester.tap(open);
        expect(requests.length, count - 1);
        requests.last.complete(url);
        await tester.pumpAndSettle();
        expect(find.text(url), findsOneWidget);
        final tabs = browserSessionStore.entries;
        expect(tabs.map((tab) => tab['id']).toSet(), hasLength(count));
        expect(tabs.where((tab) => tab['active'] == true).single, tabs.last);
        expect(tabs.last['url'], url);
        expect((router.state.extra as Map)['tabId'], tabs.last['id']);
        expect(tabs.first, {...saved, 'active': false});
        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();
        expect(open, findsOneWidget);
      }
      final reopened = BrowserSessionStore();
      await reopened.load();
      expect(
        reopened.entries.map((tab) => tab['id']),
        browserSessionStore.entries.map((tab) => tab['id']),
      );
      reopened.dispose();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'reader chrome keeps page geometry and yields hidden input and semantics',
    (tester) async {
      var visible = true;
      var pageTaps = 0;
      var settingsTaps = 0;
      var pageScrolls = 0;
      var pageKeys = 0;
      var sliderChanges = 0;
      final readerFocus = FocusNode();
      addTearDown(readerFocus.dispose);
      late StateSetter change;
      final semantics = tester.ensureSemantics();
      try {
        await mount(
          tester,
          StatefulBuilder(
            builder: (context, setState) {
              change = setState;
              return ReaderKeyboardHandler(
                onNextPage: () => pageKeys++,
              ).wrapWithKeyboardListener(
                focusNode: readerFocus,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (_) {
                    pageScrolls++;
                    return false;
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: GestureDetector(
                          key: const Key('page'),
                          behavior: HitTestBehavior.opaque,
                          onTap: () => pageTaps++,
                          child: const ColoredBox(color: Colors.black),
                        ),
                      ),
                      MobileReaderPanel(
                        visible: visible,
                        top: true,
                        child: MobileReaderHeading(
                          title: 'A long manga title',
                          chapter: 'Chapter 123 — extended chapter title',
                          onBack: () {},
                          menu: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_horiz),
                          ),
                        ),
                      ),
                      MobileReaderPanel(
                        visible: visible,
                        top: false,
                        child: Column(
                          children: [
                            MobileReaderProgress(
                              currentIndex: 0,
                              totalPages: 10,
                              label: '1',
                              reverse: false,
                              previousLabel: 'Previous',
                              nextLabel: 'Next',
                              onChanged: (_) => sliderChanges++,
                              onChangeEnd: (_) {},
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final label in [
                                  'Chapters',
                                  'Translate',
                                  'Reading',
                                ])
                                  Expanded(
                                    child: NodeLaneToolbarAction(
                                      label: label,
                                      icon: Icons.tune,
                                      onPressed: () {
                                        if (label == 'Reading') settingsTaps++;
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          height: 400,
        );
        final pageSize = tester.getSize(find.byKey(const Key('page')));
        await tester.ensureVisible(find.text('Reading'));
        expect(
          Scrollable.of(tester.element(find.text('Reading'))).position.pixels,
          greaterThan(0),
        );
        await tester.tap(find.text('Reading'));
        expect(settingsTaps, 1);
        expect(pageTaps, 0);
        expect(pageScrolls, 0);
        await tester.ensureVisible(find.byType(Slider));
        await tester.tap(find.byType(Slider));
        tester
            .widget<FocusableActionDetector>(
              find.descendant(
                of: find.byType(Slider),
                matching: find.byType(FocusableActionDetector),
              ),
            )
            .focusNode!
            .requestFocus();
        await tester.pump();
        expect(
          FocusManager.instance.primaryFocus?.context
              ?.findAncestorWidgetOfExactType<Slider>(),
          isNotNull,
        );
        final changesBeforeHide = sliderChanges;
        change(() => visible = false);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        expect(sliderChanges, changesBeforeHide);
        expect(pageKeys, 1);
        expect(tester.getSize(find.byKey(const Key('page'))), pageSize);
        expect(
          tester.semantics.simulatedAccessibilityTraversal().map(
            (node) => node.getSemanticsData().label,
          ),
          isNot(contains('Settings')),
        );
        await tester.tapAt(const Offset(160, 350));
        expect(pageTaps, 1);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets(
    'progress uses reading direction and one navigation commit per gesture',
    (tester) async {
      for (final reverse in [false, true]) {
        final changes = <int>[];
        final commits = <int>[];
        await mount(
          tester,
          Center(
            child: MobileReaderProgress(
              currentIndex: 0,
              totalPages: 10,
              label: '1',
              reverse: reverse,
              previousLabel: 'Previous',
              nextLabel: 'Next',
              onChanged: changes.add,
              onChangeEnd: commits.add,
            ),
          ),
        );
        final slider = tester.getRect(find.byType(Slider));
        await tester.tapAt(
          reverse
              ? slider.centerLeft + const Offset(2, 0)
              : slider.centerRight - const Offset(2, 0),
        );
        expect(changes.last, 9);
        expect(commits, [9]);
      }
      final commits = <int>[];
      for (final total in [0, 1]) {
        await mount(
          tester,
          Center(
            child: MobileReaderProgress(
              currentIndex: 0,
              totalPages: total,
              label: '$total',
              reverse: false,
              previousLabel: 'Previous',
              nextLabel: 'Next',
              onChanged: commits.add,
              onChangeEnd: commits.add,
            ),
          ),
        );
        await tester.tap(find.byType(Slider));
      }
      expect(commits, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
}
