import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mangayomi/modules/webview/browser_navigation.dart';
import 'package:mangayomi/modules/webview/mobile_browser_widgets.dart';

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

  Future<void> mount(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(2.5),
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
    var addresses = 0, closes = 0, tabs = 0, translations = 0, pages = 0;
    await mount(
      tester,
      Column(
        children: [
          MobileBrowserHeader(
            title: 'A very long webpage title with chapter information',
            url: 'https://preview.example/chapter?private=value',
            onAddress: () => addresses++,
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
            translating: false,
            onTabs: () => tabs++,
            onTranslate: () => translations++,
          ),
        ],
      ),
    );
    expect(find.textContaining('private'), findsNothing);
    await tester.tap(find.text('preview.example'));
    await tester.tap(find.byTooltip('返回应用'));
    await tester.ensureVisible(find.text('标签'));
    await tester.tap(find.text('标签'));
    await tester.tap(find.text('翻译'));
    expect([addresses, closes, tabs, translations, pages], [1, 1, 1, 1, 0]);
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, '后退'))
          .onPressed,
      isNull,
    );
    expect(
      tester.getSize(find.byKey(const Key('page'))).height,
      greaterThan(0),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('tab selection and close remain separate with large titles', (
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
    expect(tester.widget<ListTile>(find.byType(ListTile)).selected, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'address form validates, cancels and submits without a disposed controller',
    (tester) async {
      final results = <String?>[];
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => results.add(
              await showBrowserAddress(
                context,
                initialUrl: 'https://preview.example/first',
              ),
            ),
            child: const Text('Address'),
          ),
        ),
      );
      await tester.tap(find.text('Address'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'file:///not-a-webpage');
      await tester.testTextInput.receiveAction(TextInputAction.go);
      await tester.pumpAndSettle();
      expect(find.text('请输入有效的 http 或 https 网址'), findsOneWidget);
      expect(results, isEmpty);
      await tester.enterText(
        find.byType(TextField),
        'https://user:secret@preview.example',
      );
      await tester.testTextInput.receiveAction(TextInputAction.go);
      await tester.pumpAndSettle();
      expect(results, isEmpty);
      await tester.ensureVisible(find.text('取消'));
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(results, [null]);
      await tester.tap(find.text('Address'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField),
        '  https://preview.example/next  ',
      );
      await tester.testTextInput.receiveAction(TextInputAction.go);
      await tester.pumpAndSettle();
      expect(results, [null, 'https://preview.example/next']);
      expect(tester.takeException(), isNull);
    },
  );
}
