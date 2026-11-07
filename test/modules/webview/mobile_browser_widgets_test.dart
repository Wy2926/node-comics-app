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
}
