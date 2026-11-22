import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';

void main() {
  testWidgets(
    'the classic shelf sheet fits only visited tabs, idles and returns to the opener',
    (tester) async {
      var closed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: const Text('Open tools'),
                onPressed: () async {
                  await customDraggableTabBar(
                    context: context,
                    tabs: const [
                      Tab(text: 'Filter'),
                      Tab(text: 'Sort'),
                      Tab(text: 'Display'),
                    ],
                    children: const [
                      SizedBox(height: 80, child: Text('Filter fields')),
                      SizedBox(height: 140, child: Text('Sort fields')),
                      SizedBox(
                        height: 900,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text('Last field'),
                        ),
                      ),
                    ],
                  );
                  closed = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open tools'));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.text('Filter fields').hitTestable(), findsOneWidget);
      expect(find.text('Last field', skipOffstage: false), findsNothing);
      final short = tester.getSize(find.byType(BottomSheet)).height;
      await tester.tap(find.text('Sort'));
      await tester.pumpAndSettle();
      expect(find.text('Sort fields').hitTestable(), findsOneWidget);
      expect(
        tester.getSize(find.byType(BottomSheet)).height,
        greaterThan(short),
      );
      expect(tester.binding.transientCallbackCount, 0);
      await tester.drag(find.byType(TabBarView), const Offset(-650, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(TabBarView), const Offset(0, -650));
      await tester.pumpAndSettle();
      expect(find.text('Last field').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(BottomSheet)).height,
        closeTo(short, .1),
      );
      await tester.drag(find.byType(TabBarView), const Offset(0, -350));
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(BottomSheet)).height,
        greaterThan(short),
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(closed, isTrue);
      expect(find.text('Open tools').hitTestable(), findsOneWidget);
    },
  );
}
