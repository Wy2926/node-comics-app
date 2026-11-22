import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';

void main() {
  testWidgets(
    'a popup changes edge when its contents grow and returns when they shrink',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(780, 400);
      addTearDown(tester.view.reset);
      final height = ValueNotifier(60.0);
      addTearDown(height.dispose);
      const key = ValueKey('content');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.centerLeft,
              child: Builder(
                builder: (anchor) => TextButton(
                  onPressed: () => showNodeLaneBubble<void>(
                    anchor,
                    label: 'Tools',
                    child: ValueListenableBuilder(
                      valueListenable: height,
                      builder: (_, h, _) => SizedBox(key: key, height: h),
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      final opener = find.widgetWithText(TextButton, 'Open');
      final trigger = tester.getRect(opener);
      await tester.tap(opener);
      await tester.pumpAndSettle();
      final panel = find.byKey(key), element = tester.element(find.byKey(key));
      final compact = tester.getRect(panel);
      expect(
        compact.top >= trigger.bottom || compact.bottom <= trigger.top,
        isTrue,
      );
      height.value = 300;
      await tester.pump();
      final tall = tester.getRect(panel);
      expect(tall.left, greaterThan(trigger.right));
      expect(tall.height, 300);
      height.value = 60;
      await tester.pump();
      expect(tester.getRect(panel), compact);
      expect(tester.element(panel), same(element));
    },
  );

  testWidgets(
    'a compact panel returns to the same nested draft and respects its write lock',
    (tester) async {
      final busy = ValueNotifier(true);
      addTearDown(busy.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (anchor) => TextButton(
                onPressed: () => showNodeLaneBubble<void>(
                  anchor,
                  label: 'Tools',
                  child: NodeLaneBubbleFlow(
                    home: Builder(
                      builder: (menu) => TextButton(
                        child: const Text('Choose category'),
                        onPressed: () => NodeLaneBubbleFlow.push<void>(
                          menu,
                          Builder(
                            builder: (form) => Column(
                              children: [
                                const TextField(),
                                TextButton(
                                  child: const Text('Manage'),
                                  onPressed: () => NodeLaneBubbleFlow.showPanel(
                                    form,
                                    ValueListenableBuilder<bool>(
                                      valueListenable: busy,
                                      builder: (_, value, _) => PopScope(
                                        canPop: !value,
                                        child: const Text('Cabinet'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose category'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'my draft');
      final form = tester.element(find.byType(TextField));
      final formHeight = tester.getSize(find.byType(NodeLaneBubbleFlow)).height;
      await tester.tap(find.text('Manage'));
      await tester.pumpAndSettle();
      expect(find.text('Manage').hitTestable(), findsNothing);
      expect(
        tester.getSize(find.byType(NodeLaneBubbleFlow)).height,
        lessThan(formHeight),
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Cabinet'), findsOneWidget);
      busy.value = false;
      await tester.pump();
      await tester.tapAt(const Offset(780, 570));
      await tester.pumpAndSettle();
      expect(find.text('my draft'), findsOneWidget);
      expect(tester.element(find.byType(TextField)), same(form));
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Choose category').hitTestable(), findsOneWidget);
      expect(find.byType(Navigator, skipOffstage: false), findsOneWidget);
    },
  );
  testWidgets(
    'first inline form finishes its push and pop before releasing its navigator',
    (tester) async {
      int? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            platform: TargetPlatform.windows,
            pageTransitionsTheme: NodeLaneMotion.pageTransitions,
          ),
          home: Scaffold(
            body: Builder(
              builder: (anchor) => TextButton(
                onPressed: () => showNodeLaneBubble<void>(
                  anchor,
                  label: 'Shelf',
                  child: NodeLaneBubbleFlow(
                    home: Builder(
                      builder: (home) => TextButton(
                        child: const Text('Categories'),
                        onPressed: () async {
                          result = await NodeLaneBubbleFlow.push<int>(
                            home,
                            Builder(
                              builder: (step) => Center(
                                child: TextButton(
                                  onPressed: () => Navigator.pop(step, 4),
                                  child: const Text('Save'),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final home = tester.element(find.text('Categories'));
      await tester.tap(find.text('Categories'));
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      final route = ModalRoute.of(tester.element(find.text('Save')))!;
      expect(route.animation!.value, inExclusiveRange(0, 1));
      expect(find.text('Categories').hitTestable(), findsNothing);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      expect(route.animation!.status, AnimationStatus.reverse);
      expect(route.animation!.value, inExclusiveRange(0, 1));
      expect(result, 4);
      await tester.pumpAndSettle();
      expect(tester.element(find.text('Categories').hitTestable()), same(home));
      expect(find.byType(Navigator, skipOffstage: false), findsOneWidget);
    },
  );

  testWidgets(
    'the same bubble grows from either edge, follows a resized trigger and dismisses without choosing',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(360, 740);
      addTearDown(tester.view.reset);
      final reduce = ValueNotifier(false);
      addTearDown(reduce.dispose);
      final results = <int?>[];
      const key = ValueKey('panel');
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ValueListenableBuilder(
            valueListenable: reduce,
            builder: (_, reduced, _) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
              child: child!,
            ),
          ),
          home: Scaffold(
            body: LayoutBuilder(
              builder: (_, box) => Align(
                alignment: box.maxWidth < 600
                    ? Alignment.bottomRight
                    : Alignment.topLeft,
                child: Builder(
                  builder: (button) => TextButton(
                    child: const Text('Tools'),
                    onPressed: () async {
                      results.add(
                        await showNodeLaneBubble<int>(
                          button,
                          label: 'Tools',
                          child: Builder(
                            builder: (panel) => SizedBox(
                              key: key,
                              height: 140,
                              child: TextButton(
                                onPressed: () => Navigator.pop(panel, 7),
                                child: const Text('Choose'),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Tools'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      final midway = tester.getRect(find.byKey(key));
      Color? scrim() => tester
          .widget<ModalBarrier>(
            find.byWidgetPredicate((w) => w is ModalBarrier && w.dismissible),
          )
          .color;
      final backdrop = scrim();
      await tester.pumpAndSettle();
      expect(backdrop, isNotNull);
      expect(scrim(), backdrop);
      final open = tester.getRect(find.byKey(key));
      expect(midway.width, lessThan(open.width));
      expect(open.bottom, lessThan(tester.getRect(find.text('Tools')).top));
      tester.view.viewInsets = const FakeViewPadding(bottom: 310);
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(key)).bottom, lessThan(740 - 310));
      tester.view.resetViewInsets();
      tester.view.physicalSize = const Size(1100, 700);
      await tester.pumpAndSettle();
      final wide = tester.getRect(find.byKey(key));
      expect(wide.left, lessThan(60));
      expect(wide.top, greaterThan(tester.getRect(find.text('Tools')).bottom));
      await tester.tapAt(const Offset(1050, 660));
      await tester.pumpAndSettle();
      expect(results, [null]);
      reduce.value = true;
      await tester.pump();
      await tester.tap(find.text('Tools'));
      await tester.pump();
      final instant = tester.getRect(find.byKey(key));
      await tester.pump(NodeLaneMotion.duration);
      expect(tester.getRect(find.byKey(key)), instant);
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      expect(results, [null, 7]);
    },
  );
}
