import 'dart:async';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/webview/mobile_browser_home.dart';
import 'package:mangayomi/modules/webview/browser_pinned_sources_provider.dart';
import 'package:mangayomi/modules/webview/browser_session_store.dart';
import 'package:mangayomi/modules/webview/browser_webview_cache.dart';
import 'package:mangayomi/modules/webview/mobile_browser.dart';
import 'package:mangayomi/modules/webview/mobile_browser_start_page.dart';
import 'package:mangayomi/services/translation/translation_service.dart';

class _Service extends TranslationService {
  @override
  Future<void> initialize() async {}
}

class _WebPlatform extends InAppWebViewPlatform {
  int created = 0, disposed = 0;
  final tokens = <InAppWebViewKeepAlive?>[];
  @override
  PlatformInAppWebViewController createPlatformInAppWebViewControllerStatic() =>
      _StaticController();
  @override
  PlatformFindInteractionController createPlatformFindInteractionController(
    PlatformFindInteractionControllerCreationParams params,
  ) => _FindController(params);
  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) {
    tokens.add(params.keepAlive);
    return _WebWidget(params, () => created++, () => disposed++);
  }
}

class _StaticController extends PlatformInAppWebViewController {
  _StaticController()
    : super.implementation(
        const PlatformInAppWebViewControllerCreationParams(id: null),
      );
  @override
  Future<void> disposeKeepAlive(InAppWebViewKeepAlive keepAlive) async {}
}

class _SlowScreenshot extends _StaticController {
  final result = Completer<Uint8List?>();
  @override
  Future<Uint8List?> takeScreenshot({
    ScreenshotConfiguration? screenshotConfiguration,
  }) => result.future;
}

class _FindController extends PlatformFindInteractionController {
  _FindController(super.params) : super.implementation();
  bool disposed = false;
  @override
  void dispose({bool isKeepAlive = false}) {
    expect(disposed, isFalse, reason: 'Only the WebView owns this controller');
    disposed = true;
  }
}

class _WebWidget extends PlatformInAppWebViewWidget {
  _WebWidget(super.params, this.onMount, this.onDispose)
    : super.implementation();
  final VoidCallback onMount, onDispose;
  @override
  Widget build(BuildContext context) =>
      _WebProbe(onMount: onMount, onDispose: onDispose);
  @override
  T controllerFromPlatform<T>(PlatformInAppWebViewController controller) =>
      throw UnimplementedError();
  @override
  void dispose() => params.findInteractionController?.dispose(
    isKeepAlive: params.keepAlive != null,
  );
}

class _WebProbe extends StatefulWidget {
  const _WebProbe({required this.onMount, required this.onDispose});
  final VoidCallback onMount, onDispose;
  @override
  State<_WebProbe> createState() => _WebProbeState();
}

class _WebProbeState extends State<_WebProbe> {
  @override
  void initState() {
    super.initState();
    widget.onMount();
  }

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    final original = InAppWebViewPlatform.instance;
    addTearDown(() {
      if (original != null) InAppWebViewPlatform.instance = original;
    });
  });

  test('blank restoration drops webpage state and first navigation has real history only', () {
    final tab = BrowserTab.fromJson({
      'id': 'empty',
      'url': '',
      'title': 'Old page',
      'y': 900,
      'history': ['https://old.example'],
      'historyIndex': 9,
      'anchor': {'page': 'old'},
    })!;
    addTearDown(tab.translation.dispose);
    expect(tab.isBlank, isTrue);
    expect(tab.title, isEmpty);
    expect(tab.history, isEmpty);
    expect(tab.anchor, isNull);
    expect(tab.translation.enabled, isTrue);
    expect(tab.translation.showTranslation, isFalse);
    tab.visited('https://reader.example/1');
    tab.visited('https://reader.example/1');
    expect(tab.history, ['https://reader.example/1']);
    tab.visited('https://reader.example/2');
    tab.historyIndex = 0;
    tab.visited('https://reader.example/new');
    expect(tab.history, [
      'https://reader.example/1',
      'https://reader.example/new',
    ]);
    tab.visited('javascript:alert(1)');
    expect(tab.url, 'https://reader.example/new');
    tab.translation.configure(enabled: false, showTranslation: true);
    final restored = BrowserTab.fromJson(tab.toJson())!;
    addTearDown(restored.translation.dispose);
    expect(restored.history, tab.history);
    expect(restored.historyIndex, 1);
    expect(restored.translation.enabled, isFalse);
    expect(restored.translation.showTranslation, isTrue);
    restored.visited('https://other.example/chapter');
    expect(restored.translation.showTranslation, isFalse);
    expect(restored.translation.enabled, isFalse);
    expect(BrowserTab.fromJson({'id': 'about', 'url': 'about:blank'}), isNull);
  });

  Future<GoRouter> mount(
    WidgetTester tester, {
    String? tabId,
    bool openBrowser = false,
    String url = '',
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final service = _Service();
    addTearDown(service.dispose);
    final router = GoRouter(
      initialLocation: openBrowser ? '/mangawebview' : '/browser',
      initialExtra: {'url': url, 'tabId': tabId},
      routes: [
        GoRoute(path: '/browser', builder: (_, _) => const MobileBrowserHome()),
        GoRoute(
          path: '/mangawebview',
          builder: (_, state) {
            final data = state.extra! as Map<String, dynamic>;
            return MobileComicBrowser(
              url: data['url'] as String,
              title: '',
              tabId: data['tabId'] as String?,
            );
          },
        ),
      ],
      observers: [BotToastNavigatorObserver()],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          translationServiceProvider.overrideWithValue(service),
          browserPinnedSourcesProvider.overrideWithValue([]),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: BotToastInit(),
          theme: ThemeData(platform: TargetPlatform.iOS),
        ),
      ),
    );
    if (url.isEmpty) await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));
    return router;
  }

  Future<void> verifyMountedTabs(WidgetTester tester) async {
    final platform = _WebPlatform();
    InAppWebViewPlatform.instance = platform;
    await browserSessionStore.save([
      for (final id in ['a', 'b', 'c', 'd'])
        {'id': id, 'url': 'https://$id.example', 'title': 'Page $id'},
    ]);
    await mount(
      tester,
      openBrowser: true,
      tabId: 'a',
      url: 'https://a.example',
    );
    final dynamic state = tester.state(find.byType(MobileComicBrowser));
    final first = state.current as BrowserTab;
    final screenshot = _SlowScreenshot();
    final anchor = Completer<Map<String, dynamic>?>();
    first
      ..pageReady = true
      ..controller = InAppWebViewController.fromPlatform(platform: screenshot)
      ..captureAnchor = () => anchor.future;
    Future<void> select(String id) async {
      await tester.tap(find.byTooltip('标签页 · 4'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Page $id'), findsOneWidget);
      await tester.tap(find.text('Page $id'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect((state.current as BrowserTab).id, id);
    }

    await select('b');
    expect(screenshot.result.isCompleted, isFalse);
    expect(anchor.isCompleted, isFalse);
    screenshot.result.complete(null);
    anchor.complete(null);
    await tester.pump();
    await select('c');
    await select('a');
    await select('b');
    expect(platform.created, 3);
    expect(platform.disposed, 0);
    expect(find.byType(InAppWebView), findsOneWidget);
    expect(find.byType(InAppWebView, skipOffstage: false), findsNWidgets(3));
    await select('d');
    expect(platform.created, 4);
    expect(platform.disposed, 1);
    await select('a');
    expect(
      platform.created,
      4,
      reason: 'LRU recency follows selection, not creation',
    );
    tester.binding.handleMemoryPressure();
    await tester.pump();
    expect(platform.disposed, 3);
    expect(find.byType(InAppWebView, skipOffstage: false), findsOneWidget);
    await select('b');
    expect(platform.created, 5);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    for (final id in ['a', 'b', 'c', 'd']) {
      browserWebViewCache.remove(id);
    }
    await browserSessionStore.save([]);
  }

  testWidgets(
    'blank tabs share the root page while website identity survives switching and capacity limits',
    (tester) async {
      await browserSessionStore.save([]);
      await mount(tester);
      expect(find.byType(MobileBrowserStartPage), findsOneWidget);
      expect(find.byType(InAppWebView), findsNothing);
      expect(tester.testTextInput.isVisible, isFalse);
      expect(find.byTooltip('新建标签页'), findsNothing);
      expect(find.byTooltip('返回'), findsNothing);
      await tester.tap(find.byTooltip('标签页 · 0'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('新建标签页'));
      await tester.pumpAndSettle();
      final firstId = browserSessionStore.entries.single['id'];
      await tester.tap(find.byTooltip('标签页 · 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('新建标签页'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 500));
      expect(browserSessionStore.entries.length, 2);
      expect(browserSessionStore.entries.first['id'], firstId);
      expect(browserSessionStore.entries.every((e) => e['url'] == ''), isTrue);
      await tester.tap(find.byTooltip('标签页 · 2'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('关闭标签页').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('关闭标签页').first);
      await tester.pumpAndSettle();
      expect(find.text('标签页 · 1'), findsOneWidget);
      expect(browserSessionStore.entries.single['url'], '');
      expect(browserSessionStore.entries.single['id'], isNot(firstId));
      await tester.tap(find.text('新标签页'));
      await tester.pumpAndSettle();
      expect(find.byType(MobileBrowserStartPage), findsOneWidget);
      expect(find.byType(InAppWebView), findsNothing);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();

      // Keep the singleton session's serialized writes in the same fake clock.
      await browserSessionStore.save([
        for (var i = 0; i < BrowserSessionStore.maxTabs; i++)
          {'id': 'tab-$i', 'url': '', 'title': ''},
      ]);
      await mount(tester, tabId: 'tab-3', openBrowser: true);
      expect(find.byTooltip('标签页 · 12'), findsOneWidget);
      expect(
        browserSessionStore.entries
            .where((e) => e['active'] == true)
            .single['id'],
        'tab-3',
      );
      await tester.tap(find.byTooltip('标签页 · 12'));
      await tester.pumpAndSettle();
      expect(find.text('已打开 12 个标签页'), findsOneWidget);
      expect(browserSessionStore.entries.map((e) => e['id']), [
        for (var i = 0; i < 12; i++) 'tab-$i',
      ]);
      expect(find.byType(InAppWebView), findsNothing);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();

      // The Flutter view leaves the root page; the native document keeps its token.
      final platform = _WebPlatform();
      InAppWebViewPlatform.instance = platform;
      await browserSessionStore.save([
        {
          'id': 'web',
          'url': 'https://example.org',
          'title': '',
          'y': 840,
          'translated': false,
          'history': ['https://example.org'],
          'historyIndex': 0,
        },
      ]);
      final router = await mount(
        tester,
        url: 'https://example.org',
        openBrowser: true,
      );
      expect(platform.created, 1);
      final originalToken = platform.tokens.single;
      expect(originalToken, isNotNull);
      await tester.tap(find.byTooltip('新建标签页'));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(MobileBrowserStartPage)).width, 390);
      expect(router.routeInformationProvider.value.uri.path, '/browser');
      final blankId = browserSessionStore.entries.last['id'];
      expect(browserSessionStore.entries.first['y'], 840);
      expect(browserSessionStore.entries.first['translated'], isFalse);
      expect(platform.created, 1);
      expect(platform.disposed, 1);
      await tester.tap(find.byTooltip('标签页 · 2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('example.org'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MobileBrowserStartPage), findsNothing);
      expect(platform.created, 2);
      expect(platform.disposed, 1);
      expect(platform.tokens.last, same(originalToken));
      await tester.tap(find.byTooltip('标签页 · 2'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('新标签页'));
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/browser');
      await tester.enterText(find.byType(TextField), 'example.org/next');
      await tester.testTextInput.receiveAction(TextInputAction.go);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MobileComicBrowser), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      expect(browserSessionStore.entries.length, 2);
      expect(
        browserSessionStore.entries.singleWhere(
          (e) => e['active'] == true,
        )['id'],
        blankId,
      );
      expect(
        browserSessionStore.entries.singleWhere(
          (e) => e['id'] == blankId,
        )['url'],
        'https://example.org/next',
      );
      await tester.tap(find.text('返回'));
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/browser');
      expect(find.byType(MobileBrowserStartPage), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      for (final entry in browserSessionStore.entries) {
        browserWebViewCache.remove(entry['id'] as String);
      }
      // Singleton storage queues must stay on the same fake clock.
      await verifyMountedTabs(tester);
    },
  );
}
