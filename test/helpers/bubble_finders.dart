import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';

Finder inBubble(Finder target) => find.descendant(
  of: find.byType(NodeLaneBubblePanel).last,
  matching: target,
);

/// A popup leaves its caller onstage, sometimes showing the same label.
Future<Finder> revealBubble(
  WidgetTester tester,
  Finder target, {
  double delta = 160,
}) async {
  final scoped = inBubble(target);
  if (scoped.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      scoped,
      delta,
      scrollable: inBubble(
        find.byWidgetPredicate(
          (w) =>
              w is Scrollable &&
              axisDirectionToAxis(w.axisDirection) == Axis.vertical,
        ),
      ).first,
    );
  }
  await Scrollable.ensureVisible(tester.element(scoped), alignment: .5);
  await tester.pumpAndSettle();
  return scoped;
}
