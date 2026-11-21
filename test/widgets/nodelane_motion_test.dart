import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';

void main() {
  testWidgets(
    'pane paints intermediate positions without re-laying out its content; a reversed exit stays mounted',
    (tester) async {
      var open = false, layouts = 0, rtl = false, reduce = false;
      final page = LayoutBuilder(
        builder: (_, constraints) {
          layouts++;
          return const Text('page');
        },
      );
      Future<void> update() => tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: reduce),
              child: Directionality(
                textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 600,
                    height: 300,
                    child: Stack(
                      children: [
                        NodeLaneMotionPane(
                          start: open ? 200 : 600,
                          width: 400,
                          viewport: 600,
                          interactive: open,
                          child: open ? page : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await update();
      open = true;
      await update();
      final first = tester.element(find.text('page')), initialLayouts = layouts;
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 20));
        expect(
          tester.getTopLeft(find.text('page')).dx,
          inExclusiveRange(200, 600),
        );
      }
      expect(layouts, initialLayouts);
      open = false;
      await update();
      await tester.pump(const Duration(milliseconds: 30));
      expect(find.text('page').hitTestable(), findsNothing);
      open = true;
      await update();
      await tester.pumpAndSettle();
      expect(tester.element(find.text('page')), same(first));
      expect(tester.getTopLeft(find.text('page')).dx, 200);
      rtl = reduce = true;
      open = false;
      await update();
      expect(find.text('page', skipOffstage: false), findsNothing);
      open = true;
      await update();
      expect(tester.getTopLeft(find.text('page')).dx, 0);
    },
  );

  testWidgets(
    'Cupertino edge back still cancels or completes with the themed route',
    (tester) async {
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          theme: ThemeData(
            platform: TargetPlatform.iOS,
            pageTransitionsTheme: NodeLaneMotion.pageTransitions,
          ),
          home: const Scaffold(body: Text('root')),
        ),
      );
      navigator.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('detail')),
        ),
      );
      await tester.pumpAndSettle();
      final drag = await tester.startGesture(const Offset(2, 200));
      await drag.moveBy(const Offset(70, 0));
      await tester.pump(const Duration(milliseconds: 300));
      await drag.up();
      await tester.pumpAndSettle();
      expect(find.text('detail'), findsOneWidget);
      await tester.dragFrom(const Offset(2, 200), const Offset(680, 0));
      await tester.pumpAndSettle();
      expect(find.text('root'), findsOneWidget);
    },
  );

  for (final reduced in [false, true]) {
    testWidgets(
      'themed push and pop preserve the result, reduced motion $reduced',
      (tester) async {
        final navigator = GlobalKey<NavigatorState>();
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigator,
            theme: ThemeData(
              platform: TargetPlatform.windows,
              pageTransitionsTheme: NodeLaneMotion.pageTransitions,
            ),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
              child: child!,
            ),
            home: const Scaffold(),
          ),
        );
        final result = navigator.currentState!.push(
          MaterialPageRoute<int>(
            builder: (_) => const Scaffold(body: Text('next')),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        final x = tester.getTopLeft(find.text('next')).dx;
        expect(x, reduced ? equals(0) : greaterThan(0));
        await tester.pumpAndSettle();
        expect(tester.getTopLeft(find.text('next')).dx, 0);
        navigator.currentState!.pop(7);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 80));
        if (!reduced) {
          expect(tester.getTopLeft(find.text('next')).dx, greaterThan(0));
        }
        await tester.pumpAndSettle();
        expect(await result, 7);
        expect(find.text('next'), findsNothing);
      },
    );
  }
}
