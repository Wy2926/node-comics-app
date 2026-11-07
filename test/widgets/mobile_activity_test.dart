import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  testWidgets(
    'update search and grouped row targets stay usable with large text and keyboard',
    (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      var reads = 0, details = 0, removes = 0;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: Scaffold(
            body: Column(
              children: [
                NodeLanePageHeading.toolbar(
                  mediaMenu: const Text('Manga'),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_sweep),
                    ),
                  ],
                ),
                NodeLaneTextField.search(
                  controller: controller,
                  hint: 'Search updates',
                  clearLabel: 'Clear',
                ),
                Expanded(
                  child: ListView(
                    children: [
                      NodeLaneRow.card(
                        title: 'A long book title',
                        subtitle: 'A longer chapter title',
                        metadata: '10:35',
                        leading: const ColoredBox(color: Colors.blue),
                        leadingLabel: 'Details',
                        leadingSize: const Size.square(
                          NodeLaneTokens.activityCoverSize,
                        ),
                        onTap: () => reads++,
                        onLeadingTap: () => details++,
                        trailing: IconButton(
                          tooltip: 'Remove',
                          onPressed: () => removes++,
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Details'));
      await tester.tap(find.byTooltip('Remove'));
      expect(details, 1);
      expect(removes, 1);
      expect(reads, 0);
      await tester.tap(find.text('A long book title'));
      expect(reads, 1);
      await tester.enterText(find.byType(TextField), 'sample');
      await tester.pump();
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      expect(find.text('Manga'), findsOneWidget);
      await tester.tap(find.byTooltip('Clear'));
      await tester.pump();
      expect(controller.text, isEmpty);
      tester.view.viewInsets = FakeViewPadding.zero;
      await tester.pumpAndSettle();
      expect(find.text('Manga'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
