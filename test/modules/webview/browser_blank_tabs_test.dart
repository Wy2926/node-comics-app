import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/webview/browser_pinned_sources_provider.dart';
import 'package:mangayomi/modules/webview/browser_session_store.dart';
import 'package:mangayomi/modules/webview/mobile_browser.dart';
import 'package:mangayomi/modules/webview/mobile_browser_start_page.dart';
import 'package:mangayomi/services/translation/translation_service.dart';

class _Service extends TranslationService {
  @override
  Future<void> initialize() async {}
}

class _WebPlatform extends InAppWebViewPlatform {
  int created = 0, disposed = 0;
  @override
  PlatformInAppWebViewWidget createPlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams params,
  ) {
    return _WebWidget(params, () => created++, () => disposed++);
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
  void dispose() {}
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
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

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
    final restored = BrowserTab.fromJson(tab.toJson())!;
    addTearDown(restored.translation.dispose);
    expect(restored.history, tab.history);
    expect(restored.historyIndex, 1);
    expect(BrowserTab.fromJson({'id': 'about', 'url': 'about:blank'}), isNull);
  });

  Future<void> mount(
    WidgetTester tester, {
    String? tabId,
    bool newTab = true,
    String url = '',
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final service = _Service();
    addTearDown(service.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          translationServiceProvider.overrideWithValue(service),
          browserPinnedSourcesProvider.overrideWithValue([]),
        ],
        child: MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: MobileComicBrowser(
            url: url,
            title: '',
            tabId: tabId,
            newTab: newTab,
          ),
        ),
      ),
    );
    if (url.isEmpty) await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets(
    'blank tabs create, close, restore and enforce capacity without loading WebViews',
    (tester) async {
      await browserSessionStore.save([]);
      await mount(tester);
      expect(find.byType(MobileBrowserStartPage), findsOneWidget);
      expect(find.byType(InAppWebView), findsNothing);
      expect(tester.testTextInput.isVisible, isFalse);
      final firstId = browserSessionStore.entries.single['id'];
      await tester.tap(find.byTooltip('新建标签页'));
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
      await browserSessionStore.save(browserSessionStore.entries);
      final restored = BrowserSessionStore();
      await restored.load();
      expect(restored.entries.single['url'], '');
      restored.dispose();

      // Keep the singleton session's serialized writes in the same fake clock.
      await browserSessionStore.save([
        for (var i = 0; i < BrowserSessionStore.maxTabs; i++)
          {'id': 'tab-$i', 'url': '', 'title': ''},
      ]);
      await mount(tester, tabId: 'tab-3', newTab: false);
      expect(find.byTooltip('标签页 · 12'), findsOneWidget);
      expect(
        browserSessionStore.entries
            .where((e) => e['active'] == true)
            .single['id'],
        'tab-3',
      );
      await tester.tap(find.byTooltip('新建标签页'));
      await tester.pumpAndSettle();
      expect(find.text('已打开 12 个标签页'), findsOneWidget);
      expect(browserSessionStore.entries.map((e) => e['id']), [
        for (var i = 0; i < 12; i++) 'tab-$i',
      ]);
      expect(find.byType(InAppWebView), findsNothing);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();

      // A hidden warm WebView must not collapse the blank start page or remount.
      final platform = _WebPlatform();
      final originalPlatform = InAppWebViewPlatform.instance;
      InAppWebViewPlatform.instance = platform;
      addTearDown(() {
        if (originalPlatform != null) {
          InAppWebViewPlatform.instance = originalPlatform;
        }
      });
      await browserSessionStore.save([]);
      await mount(tester, url: 'https://example.org');
      expect(platform.created, 1);
      await tester.tap(find.byTooltip('新建标签页'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.getSize(find.byType(MobileBrowserStartPage)).width, 390);
      expect(platform.created, 1);
      expect(platform.disposed, 0);
      await tester.tap(find.byTooltip('标签页 · 2'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('example.org'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(MobileBrowserStartPage), findsNothing);
      expect(platform.created, 1);
      expect(platform.disposed, 0);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      await browserSessionStore.save(browserSessionStore.entries);
    },
  );
}
