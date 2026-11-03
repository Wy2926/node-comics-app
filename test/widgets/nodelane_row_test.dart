import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

Widget app(Widget child) => MaterialApp(
  theme: ThemeData(brightness: Brightness.dark),
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)),
    child: child!,
  ),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('source actions do not open the card and long names can wrap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var opened = 0, updated = 0;
    await tester.pumpWidget(
      app(
        ListView(
          children: [
            NodeLaneGroupSurface(
              children: [
                NodeLaneRow(
                  title: 'A long source name that stays readable',
                  leading: const Icon(Icons.extension),
                  subtitle: 'English · Version 1.0 · Example repository',
                  onTap: () => opened++,
                ),
                TextButton.icon(
                  onPressed: () => updated++,
                  icon: const Icon(Icons.update),
                  label: const Text('Update extension'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    await tester.ensureVisible(find.text('Update extension'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update extension'));
    expect(updated, 1);
    expect(opened, 0);
    await tester.ensureVisible(
      find.text('A long source name that stays readable'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('A long source name that stays readable'));
    expect(opened, 1);
    expect(tester.takeException(), isNull);
  });
}
