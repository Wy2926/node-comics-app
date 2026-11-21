import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';

void main() {
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
      await tester.pumpAndSettle();
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
