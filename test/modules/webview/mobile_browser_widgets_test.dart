import 'package:mangayomi/l10n/generated/app_localizations.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mangayomi/modules/webview/browser_navigation.dart';
import 'package:mangayomi/modules/webview/mobile_browser_widgets.dart';
import 'package:mangayomi/modules/webview/mobile_browser_start_page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/webview/browser_tabs_panel.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mangayomi/modules/webview/browser_library_store.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';
import 'package:mangayomi/modules/webview/browser_search_suggestions.dart';
import 'package:mangayomi/modules/webview/browser_library_panel.dart';
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
      NavigationActionPolicy policy(
        NavigationAction request, {
        bool ios = true,
        bool active = true,
      }) => browserNavigationPolicy(
        request,
        isIos: ios,
        active: active,
        openTab: opened.add,
      );
      expect(policy(action()), NavigationActionPolicy.CANCEL);
      expect(opened, ['https://preview.example/next']);
      expect(policy(action(), active: false), NavigationActionPolicy.CANCEL);
      expect(
        policy(action(url: 'file:///private/page')),
        NavigationActionPolicy.CANCEL,
      );
      expect(policy(action(mainFrame: true)), NavigationActionPolicy.ALLOW);
      expect(policy(action(), ios: false), NavigationActionPolicy.ALLOW);
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
    var protection = 0;
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
            protection: IconButton(
              tooltip: '站点保护',
              icon: const Icon(Icons.shield),
              onPressed: () => protection++,
            ),
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
            onTabs: (_) => tabs++,
            onNew: () => newTabs++,
            onDisplayChanged: displays.add,
            onControls: (_) => controls++,
          ),
        ],
      ),
    );
    expect(find.textContaining('private'), findsNothing);
    await tester.tap(find.byTooltip('站点保护'));
    expect(protection, 1);
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(find.byTooltip('站点保护'), findsNothing);
    expect(
      find.text('https://preview.example/chapter?private=value'),
      findsOneWidget,
    );
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('离开网页'));
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
    await tester.tap(find.textContaining('preview.example'));
    expect([selects, closes], [1, 1]);
    expect(find.textContaining('当前'), findsOneWidget);
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
            onPressed: () => showNodeLaneBubble<void>(
              context,
              label: 'Tabs',
              child: BrowserTabsPanel(
                onUndo: () async => [],
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
      expect(find.text('标签状态保存失败，请重试。'), findsOneWidget);
      await tester.tap(find.byTooltip('关闭标签页'));
      await tester.pumpAndSettle();
      expect(attempts, 2);
      expect(find.text('标签页 · 1'), findsOneWidget);
      expect(find.text('新标签页'), findsOneWidget);
      expect(find.textContaining('尚未打开网页'), findsOneWidget);
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
    'bookmarks and history open beside their sections and clips keep their own position',
    (tester) async {
      final clip = BrowserPageEntry(
        url: 'https://reader.example/chapter',
        title: 'Chapter four',
        time: DateTime.now().subtract(const Duration(minutes: 19)),
        anchor: const {'x': 0, 'y': 540, 'slot': 1, 'page': 4, 'fraction': .75},
      );
      final opened = <String>[];
      await mount(
        tester,
        MobileBrowserStartPage(
          sources: [Source(name: 'Reader', baseUrl: 'https://reader.example')],
          history: [
            BrowserPageEntry(
              url: 'https://visited.example',
              title: 'Last visit',
              time: clip.time,
            ),
          ],
          tabCount: 1,
          onOpen: (_, _) {},
          onRequestSource: () {},
          reading: [
            clip,
            BrowserPageEntry(
              url: 'https://reader.example/long',
              title: 'A long chapter title ' * 10,
              time: clip.time,
              anchor: const {'x': 0, 'y': 10},
            ),
          ],
          onBookmarks: (_) => opened.add('bookmarks'),
          onHistory: (_) => opened.add('history'),
          onResume: (entry) => opened.add(entry.url),
        ),
      );
      final bookmarks = find.byTooltip('书签'), history = find.text('历史');
      expect(
        tester.getCenter(bookmarks).dy,
        lessThan(tester.getTopLeft(find.byType(MobileBrowserAddressField)).dy),
      );
      expect(
        tester.getCenter(history).dy,
        closeTo(tester.getCenter(find.text('最近访问')).dy, 3),
      );
      await tester.tap(bookmarks);
      await tester.ensureVisible(history);
      await tester.tap(history);
      tester.view.physicalSize = const Size(1100, 700);
      await tester.pumpAndSettle();
      final tile = find.widgetWithText(BrowserReadingCard, 'Chapter four');
      final cards = find.byType(BrowserReadingCard);
      expect(
        tester.getSize(cards.first).height,
        tester.getSize(cards.last).height,
      );
      expect(tester.widget<Text>(find.text('Chapter four')).maxLines, 2);
      expect(
        tester.getCenter(tile).dx,
        greaterThan(tester.getCenter(find.text('常用网站')).dx),
      );
      expect(
        tester.getBottomLeft(tile).dy,
        lessThan(tester.getCenter(find.text('最近访问')).dy),
      );
      expect(
        tester.getSize(find.byType(MobileBrowserAddressField)).width,
        lessThan(700),
      );
      expect(find.textContaining('75%'), findsNothing);
      expect(find.text('19分钟前'), findsNWidgets(2));
      await tester.tap(tile);
      expect(opened, ['bookmarks', 'history', clip.url]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the pin pane scrolls past eight sites without moving the address or the reading column',
    (tester) async {
      await mount(
        tester,
        MobileBrowserStartPage(
          sources: [
            for (int i = 0; i < 42; i++)
              Source(name: 'Website $i', baseUrl: 'https://$i.example'),
          ],
          history: [
            BrowserPageEntry(
              url: 'https://visited.example',
              title: 'Last visit',
              time: DateTime.now(),
            ),
          ],
          tabCount: 0,
          onOpen: (_, _) {},
          onRequestSource: () {},
        ),
      );
      tester.view.physicalSize = const Size(1100, 700);
      await tester.pumpAndSettle();
      final address = tester.getRect(find.byType(MobileBrowserAddressField));
      final history = tester.getRect(find.text('最近访问'));
      expect(find.text('继续读'), findsNothing);
      final list = find.descendant(
        of: find.byKey(const PageStorageKey('browser-pins')),
        matching: find.byType(Scrollable),
      );
      expect(find.text('Website 41'), findsNothing);
      await tester.scrollUntilVisible(
        find.text('Website 41'),
        320,
        scrollable: list,
      );
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(MobileBrowserAddressField)), address);
      expect(tester.getRect(find.text('最近访问')), history);
      expect(find.byType(Scrollbar), findsNothing);
    },
  );

  testWidgets('a pins-only start page opens website tiles at large text', (
    tester,
  ) async {
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
        onRequestSource: () {},
        onManage: () {},
        onTabs: (_) {},
      ),
      scale: 2,
    );
    expect(find.text('最近访问'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Site 4'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Site 4'));
    expect(opened, ['https://example.org/4']);
  });

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
    await tester.tap(find.text('清除Cookie'));
    await tester.pumpAndSettle();
    expect(decisions, [false, true]);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'omnibox searches with the selected engine and keeps URL navigation',
    (tester) async {
      final opened = <String>[];
      final selected = <BrowserMatch>[];
      await mount(
        tester,
        MobileBrowserAddressField(
          engine: BrowserSearchEngine.duckDuckGo,
          onSubmitted: opened.add,
          onMatch: selected.add,
          openTabs: const [
            {'id': 'open', 'url': 'https://reader.example/ch', 'title': '已开章节'},
          ],
        ),
      );
      await tester.enterText(find.byType(TextField), '已开');
      await tester.pumpAndSettle();
      await tester.tap(find.text('已开章节'));
      expect(selected.single.tabId, 'open');
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
    'engine hints debounce, ignore late replies and insert editable text without navigating',
    (tester) async {
      final sent = <Uri>[], opened = <String>[];
      final first = Completer<http.Response>();
      final client = MockClient((request) async {
        sent.add(request.url);
        final q = request.url.queryParameters['q'];
        return q == 'ma'
            ? first.future
            : http.Response(
                jsonEncode([
                  q,
                  ['$q reader', '$q books'],
                ]),
                200,
              );
      });
      await http.runWithClient(() async {
        await mount(
          tester,
          MobileBrowserAddressField(
            onSubmitted: opened.add,
            onMatch: (_) {},
            openTabs: const [
              {
                'id': 'local',
                'url': 'https://reader.example',
                'title': 'manga saved',
              },
            ],
          ),
        );
        final field = find.byType(TextField);
        await tester.enterText(field, 'ma');
        await tester.pump(const Duration(milliseconds: 300));
        await tester.enterText(field, 'mang');
        await tester.pump(const Duration(milliseconds: 70));
        await tester.enterText(field, 'manga');
        expect(find.text('manga saved'), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump();
        first.complete(http.Response('["ma",["late reply"]]', 200));
        await tester.pump();
        expect(sent.map((u) => u.queryParameters['q']), ['ma', 'manga']);
        expect(find.text('late reply'), findsNothing);
        await tester.tap(find.text('manga reader'));
        await tester.pump();
        final input = tester.widget<TextField>(field).controller!;
        expect(input.text, 'manga reader');
        expect(
          input.selection,
          TextSelection.collapsed(offset: 'manga reader'.length),
        );
        expect(opened, isEmpty);
        expect(tester.testTextInput.isVisible, isTrue);
        await tester.testTextInput.receiveAction(TextInputAction.go);
        await tester.pump();
        expect(Uri.parse(opened.single).queryParameters['q'], 'manga reader');
        await tester.enterText(field, 'https://reader.example/?private=1');
        await tester.pump(const Duration(milliseconds: 300));
        expect(sent, hasLength(2));
        await tester.pumpWidget(const SizedBox());
      }, () => client);
    },
  );

  test(
    'JSON, Bing groups and Sogou callback yield plain matching terms only',
    () {
      expect(
        parseBrowserSuggestions(
          BrowserSearchEngine.baidu,
          '漫画',
          '["漫画",["漫画"," 漫画书 ","漫画书",false]]',
        ),
        ['漫画书'],
      );
      expect(
        parseBrowserSuggestions(
          BrowserSearchEngine.bing,
          'comic',
          '{"AS":{"Query":"comic","Results":[{"Suggests":[{"Txt":"comic books"}]}]}}',
        ),
        ['comic books'],
      );
      expect(
        parseBrowserSuggestions(
          BrowserSearchEngine.sogou,
          '漫画',
          'window.sogou.sug(["漫画",["漫画书"]],-1);',
        ),
        ['漫画书'],
      );
      expect(
        parseBrowserSuggestions(
          BrowserSearchEngine.sogou,
          '漫画',
          'other(["漫画",["wrong"]],-1);',
        ),
        isEmpty,
      );
      expect(
        parseBrowserSuggestions(
          BrowserSearchEngine.yahoo,
          'new',
          '["earlier",["unrelated"]]',
        ),
        isEmpty,
      );
      for (final input in [
        'https://example.com/a?secret=1',
        'user:pw@example.com',
        '/private',
        'see site.example/page',
        'localhost:8000',
        'access_token=abc',
      ]) {
        expect(isSuggestionQuery(input), isFalse, reason: input);
      }
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
      BrowserPageEntry? chosen;
      await mount(
        tester,
        Builder(
          builder: (context) => Column(
            children: [
              for (final bookmarks in [false, true])
                TextButton(
                  onPressed: () async =>
                      chosen = await BrowserLibraryPanel.show(
                        context,
                        store: store,
                        collection: bookmarks
                            ? BrowserCollection.bookmarks
                            : BrowserCollection.history,
                      ),
                  child: Text(bookmarks ? 'Bookmarks' : 'History'),
                ),
            ],
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
      await tester.tap(find.byTooltip('清除浏览历史'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(store.history, hasLength(1));
      await tester.tap(find.byTooltip('清除浏览历史'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('全部清除'));
      await tester.pumpAndSettle();
      expect(store.history, isEmpty);
      await tester.tap(find.byTooltip('关闭'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bookmarks'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();
      expect(chosen?.url, 'https://example.org/b');
      expect(chosen?.anchor, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('find controls fit a narrow screen at large text', (
    tester,
  ) async {
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
      expect(find.text('DuckDuckGo'), findsOneWidget);
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
