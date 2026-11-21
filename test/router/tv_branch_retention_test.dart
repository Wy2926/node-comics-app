import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/platform_utils.dart';

void main() {
  tearDown(() => debugIsTvOverride = null);

  Future<void> pump(WidgetTester tester, int index) => tester.pumpWidget(
    MaterialApp(
      home: NodeLaneBranchStack(
        index: index,
        children: const [Text('branch 0'), Text('branch 1'), Text('branch 2')],
      ),
    ),
  );

  testWidgets('a television mounts only the branch it is showing', (
    tester,
  ) async {
    debugIsTvOverride = true;

    await pump(tester, 1);

    expect(find.text('branch 1'), findsOneWidget);
    await pump(tester, 2);
    expect(find.text('branch 2'), findsOneWidget);
    expect(find.text('branch 1', skipOffstage: false), findsNothing);
    expect(find.text('branch 0', skipOffstage: false), findsNothing);
  });

  testWidgets('everywhere else keeps every branch mounted', (tester) async {
    debugIsTvOverride = false;

    await pump(tester, 1);

    for (var i = 0; i < 3; i++) {
      expect(
        TickerMode.valuesOf(
          tester.element(find.text('branch $i', skipOffstage: false)),
        ).enabled,
        i == 1,
      );
    }
  });
}
