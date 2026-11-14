import 'package:mangayomi/l10n/generated/app_localizations.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mangayomi/modules/webview/browser_navigation.dart';
import 'package:mangayomi/modules/webview/mobile_browser_widgets.dart';
import 'package:mangayomi/modules/webview/mobile_browser_start_page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/webview/mobile_browser_tabs_sheet.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mangayomi/modules/webview/browser_library_store.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';
import 'package:mangayomi/modules/webview/mobile_browser_library_sheet.dart';
import 'package:mangayomi/modules/webview/mobile_browser_menu.dart';

void main() {
  test(
    'iOS new-window links open once without replacing the original frame',
    () {
      final opened = <String>[];
      NavigationAction action({
        bool mainFrame = false,
        String url = 'https://preview.example/next',
      }) => NavigationAction(
        request: URLRequest(url: WebUri(url)),
        isForMainFrame: mainFrame,
        navigationType: NavigationType.LINK_ACTIVATED,
      );
      expect(
        browserNavigationPolicy(
          action(),
          isIos: true,
          active: true,
          openTab: opened.add,
        ),
        NavigationActionPolicy.CANCEL,
      );
      expect(opened, ['https://preview.example/next']);
      expect(
        browserNavigationPolicy(
          action(),
          isIos: true,
          active: false,
          openTab: opened.add,
        ),
        NavigationActionPolicy.CANCEL,
      );
      expect(
        browserNavigationPolicy(
          action(url: 'file:///private/page'),
          isIos: true,
          active: true,
          openTab: opened.add,
        ),
        NavigationActionPolicy.CANCEL,
      );
      expect(
        browserNavigationPolicy(
          action(mainFrame: true),
          isIos: true,
          active: true,
          openTab: opened.add,
        ),
        NavigationActionPolicy.ALLOW,
      );
      expect(
        browserNavigationPolicy(
          action(),
          isIos: false,
          active: true,
          openTab: opened.add,
        ),
        NavigationActionPolicy.ALLOW,
      );
      expect(opened, ['https://preview.example/next']);
    },
  );

  Future<void> mount(
    WidgetTester tester,
    Widget child, {
    double scale = 1,
  }) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale("zh"),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
            padding: const EdgeInsets.only(top: 24, bottom: 24),
            viewPadding: const EdgeInsets.only(top: 24, bottom: 24),
          ),
          child: child!,
        ),
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('small-screen browser controls keep independent action targets', (
    tester,
  ) async {
    var closes = 0, tabs = 0, controls = 0, pages = 0, newTabs = 0;
    final displays = <bool>[];
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await mount(
      tester,
      Column(
        children: [
          MobileBrowserHeader(
            url: 'https://preview.example/chapter?private=value',
            onSubmitted: (_) {},
            addressFocus: focus,
            onClose: () => closes++,
            menu: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz),
            ),
          ),
          Expanded(
            child: GestureDetector(
              key: const Key('page'),
              behavior: HitTestBehavior.opaque,
              onTap: () => pages++,
              child: const SizedBox.expand(),
            ),
          ),
          MobileBrowserToolbar(
            tabCount: 12,
            onTabs: () => tabs++,
            onNew: () => newTabs++,
            onDisplayChanged: displays.add,
            onControls: () => controls++,
          ),
        ],
      ),
    );
    expect(find.textContaining('private'), findsNothing);
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(
      find.text('https://preview.example/chapter?private=value'),
      findsOneWidget,
    );
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('返回'));
    await tester.tap(find.text('12'));
    await tester.tap(find.text('译图'));
    await tester.tap(find.byTooltip('新建标签页'));
    await tester.tap(find.byTooltip('网页翻译'));
    expect([closes, tabs, controls, pages, newTabs], [1, 1, 1, 0, 1]);
    expect(displays, [true]);
    expect(
      tester
          .widget<IconButton>(
            find.byWidgetPredicate((w) => w is IconButton && w.tooltip == '后退'),
          )
          .onPressed,
      isNull,
    );
    expect(
      tester.getSize(find.byKey(const Key('page'))).height,
      greaterThan(0),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('tab preview selection and close remain separate', (
    tester,
  ) async {
    var selects = 0, closes = 0;
    await mount(
      tester,
      Padding(
        padding: const EdgeInsets.all(20),
        child: MobileBrowserTabCard(
          title: 'A long chapter title in a currently selected tab',
          url: 'https://preview.example/chapter',
          selected: true,
          onSelect: () => selects++,
          onClose: () => closes++,
        ),
      ),
    );
    await tester.tap(find.byTooltip('关闭标签页'));
    expect([selects, closes], [0, 1]);
    await tester.tap(find.text('preview.example'));
    expect([selects, closes], [1, 1]);
    expect(find.text('当前'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'tab close is not repeated while saving and can retry a failed save',
    (tester) async {
      var attempts = 0;
      final first = Completer<List<Map<String, dynamic>>>();
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showNodeLaneCatalogSheet<void>(
              context,
              MobileBrowserTabsSheet(
                entries: const [
                  {'id': 'a', 'title': 'Chapter', 'url': 'https://example.org'},
                ],
                onClose: (_) {
                  attempts++;
                  return attempts == 1
                      ? first.future
                      : Future.value([
                          {'id': 'blank', 'url': '', 'title': ''},
                        ]);
                },
              ),
            ),
            child: const Text('Tabs'),
          ),
        ),
      );
      await tester.tap(find.text('Tabs'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('关闭标签页'));
      await tester.tap(find.byTooltip('关闭标签页'));
      expect(attempts, 1);
      first.completeError(StateError('temporary storage failure'));
      await tester.pumpAndSettle();
      expect(find.text('标签状态保存失败，请再次点击关闭重试。'), findsOneWidget);
      await tester.tap(find.byTooltip('关闭标签页'));
      await tester.pumpAndSettle();
      expect(attempts, 2);
      expect(find.text('标签页 · 1'), findsOneWidget);
      expect(find.text('新标签页'), findsOneWidget);
      expect(find.text('尚未打开网页'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('inline address validates and cancels without navigation', (
    tester,
  ) async {
    final results = <String>[];
    await mount(
      tester,
      MobileBrowserAddressField(
        url: 'https://preview.example/first',
        compact: true,
        onSubmitted: results.add,
      ),
    );
    await tester.enterText(find.byType(TextField), 'file:///not-a-webpage');
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();
    expect(find.text('请输入有效的网址'), findsOneWidget);
    expect(results, isEmpty);
    await tester.enterText(
      find.byType(TextField),
      'https://user:secret@preview.example',
    );
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();
    expect(results, isEmpty);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(results, isEmpty);
    expect(find.text('preview.example'), findsOneWidget);
    await tester.enterText(find.byType(TextField), ' preview.example/next ');
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pumpAndSettle();
    expect(results, ['https://preview.example/next']);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'start page keeps tabs beside the address and opens shared website rows',
    (tester) async {
      final opened = <String>[];
      await mount(
        tester,
        MobileBrowserStartPage(
          sources: [
            for (var i = 0; i < 6; i++)
              Source(name: 'Site $i', baseUrl: 'https://example.org/$i'),
          ],
          tabCount: 2,
          onOpen: (url, _) => opened.add(url),
          onManage: () {},
          onTabs: () {},
        ),
        scale: 2,
      );
      expect(tester.testTextInput.isVisible, isFalse);
      expect(find.byTooltip('新建标签页'), findsNothing);
      expect(find.byTooltip('返回'), findsNothing);
      expect(find.text('浏览器'), findsNothing);
      expect(find.text('展开'), findsNothing);
      expect(find.textContaining('已打开'), findsNothing);
      expect(
        tester.getRect(find.byType(MobileBrowserTabsButton)).left,
        greaterThan(
          tester.getRect(find.byType(MobileBrowserAddressField)).right,
        ),
      );
      await tester.scrollUntilVisible(
        find.text('Site 4'),
        160,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Site 4'), findsOneWidget);
      await tester.tap(find.text('Site 4'));
      expect(opened, ['https://example.org/4']);
      await tester.scrollUntilVisible(
        find.byType(MobileBrowserAddressField),
        -160,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.byType(TextField), 'example.org/typed');
      await tester.testTextInput.receiveAction(TextInputAction.go);
      await tester.pumpAndSettle();
      expect(opened.last, 'https://example.org/typed');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('website login clearing requires an explicit confirmation', (
    tester,
  ) async {
    final decisions = <bool?>[];
    await mount(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () async =>
              decisions.add(await confirmClearBrowserLogins(context)),
          child: const Text('Clear'),
        ),
      ),
    );
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(decisions, isEmpty);
    expect(find.text('所有标签页中的网站可能需要重新登录。'), findsOneWidget);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(decisions, [false]);
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('清除登录状态'));
    await tester.pumpAndSettle();
    expect(decisions, [false, true]);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'omnibox searches with the selected engine and keeps URL navigation',
    (tester) async {
      final opened = <String>[];
      await mount(
        tester,
        MobileBrowserAddressField(
          engine: BrowserSearchEngine.duckDuckGo,
          onSubmitted: opened.add,
        ),
      );
      await tester.enterText(find.byType(TextField), '漫画 & novels');
      expect(opened, isEmpty);
      await tester.testTextInput.receiveAction(TextInputAction.go);
      await tester.pumpAndSettle();
      expect(Uri.parse(opened.single).host, 'duckduckgo.com');
      expect(Uri.parse(opened.single).queryParameters['q'], '漫画 & novels');
      await tester.enterText(find.byType(TextField), 'example.org/read');
      await tester.testTextInput.receiveAction(TextInputAction.go);
      expect(opened.last, 'https://example.org/read');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'history search, deletion, confirmation and bookmarks are independent',
    (tester) async {
      FlutterSecureStorage.setMockInitialValues({});
      final store = BrowserLibraryStore();
      addTearDown(store.dispose);
      await store.visit('https://example.org/a', 'Alpha');
      await store.visit('https://example.org/b', 'Beta');
      await store.setBookmarked('https://example.org/b', 'Beta', true);
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showNodeLaneCatalogSheet<String>(
              context,
              MobileBrowserLibrarySheet(store: store),
            ),
            child: const Text('History'),
          ),
        ),
      );
      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'ALPHA');
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);
      final title = tester.widget<Text>(find.text('Alpha'));
      expect(title.maxLines, 1);
      expect(title.overflow, TextOverflow.ellipsis);
      expect(
        tester
            .widget<NodeLaneWebsiteIcon>(find.byType(NodeLaneWebsiteIcon))
            .url,
        'https://example.org/favicon.ico',
      );
      expect(find.text('Beta'), findsNothing);
      await tester.tap(find.byTooltip('删除'));
      await tester.pumpAndSettle();
      expect(store.history.single.title, 'Beta');
      expect(find.text('这里还是空的'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '');
      tester.testTextInput.hide();
      await tester.pumpAndSettle();
      await tester.tap(find.text('清除浏览历史'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(store.history, hasLength(1));
      await tester.tap(find.text('清除浏览历史'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('全部清除'));
      await tester.pumpAndSettle();
      expect(store.history, isEmpty);
      expect(store.bookmarks.single.title, 'Beta');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('engine choice and find controls fit a narrow large-text menu', (
    tester,
  ) async {
    BrowserSearchEngine? selected;
    await mount(
      tester,
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (context) => Align(
            alignment: Alignment.topLeft,
            child: Builder(
              builder: (anchor) => TextButton(
                onPressed: () async =>
                    selected = await showBrowserSearchEngines(
                      anchor,
                      BrowserSearchEngine.google,
                    ),
                child: const Text('Engines'),
              ),
            ),
          ),
        ),
      ),
      scale: 2,
    );
    await tester.tap(find.text('Engines'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bing'));
    await tester.pumpAndSettle();
    expect(selected, BrowserSearchEngine.bing);
    expect(find.text('Engines'), findsOneWidget);
    expect(tester.takeException(), isNull);
    final searches = <String>[], steps = <bool>[];
    await mount(
      tester,
      MobileBrowserFindBar(
        current: 1,
        total: 3,
        onFind: searches.add,
        onNext: steps.add,
        onClose: () {},
      ),
      scale: 2,
    );
    await tester.enterText(find.byType(TextField), 'Example');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.tap(find.byTooltip('上一个匹配'));
    await tester.tap(find.byTooltip('下一个匹配'));
    expect(searches, ['Example']);
    expect(steps, [false, true]);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'engine selection and cancellation preserve the address draft and selection',
    (tester) async {
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      addTearDown(tester.view.resetViewInsets);
      var engine = BrowserSearchEngine.google;
      var changes = 0;
      final opened = <String>[];
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await mount(
        tester,
        StatefulBuilder(
          builder: (context, update) => MobileBrowserAddressField(
            url: 'https://example.org/chapter',
            compact: true,
            focusNode: focus,
            engine: engine,
            onEngine: (value) async => update(() {
              engine = value;
              changes++;
            }),
            onSubmitted: opened.add,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), '漫画 & draft');
      final input = tester
          .widget<TextField>(find.byType(TextField))
          .controller!;
      const selection = TextSelection(baseOffset: 3, extentOffset: 7);
      input.selection = selection;
      await tester.tap(find.byTooltip('搜索引擎 · Google'));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.byType(PopupMenuItem<BrowserSearchEngine>), findsNWidgets(6));
      final menu = find.ancestor(
        of: find.text('DuckDuckGo'),
        matching: find.byType(SingleChildScrollView),
      );
      expect(tester.getBottomRight(menu).dy, lessThanOrEqualTo(340));
      await tester.tap(find.text('Bing'));
      await tester.pumpAndSettle();
      expect(engine, BrowserSearchEngine.bing);
      expect(input.text, '漫画 & draft');
      expect(input.selection, selection);
      expect(focus.hasFocus, isTrue);
      await tester.tap(find.byTooltip('搜索引擎 · Bing'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(310, 580));
      await tester.pumpAndSettle();
      expect(changes, 1);
      expect(input.text, '漫画 & draft');
      expect(input.selection, selection);
      expect(focus.hasFocus, isTrue);
      expect(opened, isEmpty);
      await tester.testTextInput.receiveAction(TextInputAction.go);
      expect(Uri.parse(opened.single).host, 'www.bing.com');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'engine menu can open above the field and scroll while the keyboard is visible',
    (tester) async {
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      addTearDown(tester.view.resetViewInsets);
      BrowserSearchEngine? selected;
      await mount(
        tester,
        Padding(
          padding: const EdgeInsets.only(top: 200),
          child: MobileBrowserAddressField(
            onSubmitted: (_) {},
            onEngine: (value) async => selected = value,
          ),
        ),
        scale: 2,
      );
      await tester.tap(find.byTooltip('搜索引擎 · Google'));
      await tester.pumpAndSettle();
      final menu = find.ancestor(
        of: find.text('DuckDuckGo'),
        matching: find.byType(SingleChildScrollView),
      );
      expect(
        tester.getBottomRight(menu).dy,
        lessThanOrEqualTo(
          tester.getTopLeft(find.byTooltip('搜索引擎 · Google')).dy,
        ),
      );
      await tester.ensureVisible(find.text('搜狗'));
      await tester.tap(find.text('搜狗'));
      await tester.pumpAndSettle();
      expect(selected, BrowserSearchEngine.sogou);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'page menu is anchored, scrolls at large text, and returns actions through a nested navigator',
    (tester) async {
      String? action;
      await mount(
        tester,
        Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => Align(
              alignment: Alignment.topRight,
              child: Builder(
                builder: (anchor) => TextButton(
                  onPressed: () async => action = await showBrowserPageMenu(
                    anchor,
                    canForward: false,
                    bookmarked: false,
                    pageReady: false,
                    clearingLogins: false,
                  ),
                  child: const Text('Menu'),
                ),
              ),
            ),
          ),
        ),
        scale: 2,
      );
      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      final forward = tester.widget<IconButton>(
        find.byWidgetPredicate(
          (widget) => widget is IconButton && widget.tooltip == '前进',
        ),
      );
      expect(forward.onPressed, isNull);
      await tester.tap(find.byTooltip('添加书签'));
      await tester.pumpAndSettle();
      expect(action, 'bookmark');
      expect(find.text('Menu'), findsOneWidget);
      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();
      final copy = find.text('复制链接');
      await tester.ensureVisible(copy);
      await tester.tap(copy);
      await tester.pumpAndSettle();
      expect(action, 'copy');
      expect(tester.takeException(), isNull);
    },
  );
}
