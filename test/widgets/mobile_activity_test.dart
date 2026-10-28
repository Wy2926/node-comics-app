import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/mobile_activity_widgets.dart';

void main() {
  testWidgets(
    'activity header restores after keyboard and card actions stay separate',
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
                MobileActivityHeader(
                  title: 'History',
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
                  controller: controller,
                  searchLabel: 'Search',
                  clearLabel: 'Clear',
                  onSearchChanged: () {},
                ),
                Expanded(
                  child: ListView(
                    children: [
                      MobileActivityCard(
                        title: 'A long book title',
                        chapter: 'A longer chapter title',
                        metadata: '10:35',
                        cover: const ColoredBox(color: Colors.blue),
                        readLabel: 'Resume',
                        detailLabel: 'Details',
                        onRead: () => reads++,
                        onDetail: () => details++,
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
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      expect(find.text('History'), findsNothing);
      await tester.tap(find.byTooltip('Clear'));
      await tester.pump();
      expect(controller.text, isEmpty);
      tester.view.viewInsets = FakeViewPadding.zero;
      await tester.pumpAndSettle();
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Manga'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
