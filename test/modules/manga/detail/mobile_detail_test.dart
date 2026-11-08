import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_widgets.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  Future<void> show(
    WidgetTester tester,
    Widget child, {
    bool largeText = true,
  }) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(largeText ? 2 : 1)),
          child: child!,
        ),
        home: NodeLaneSurface(
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'chapter wraps metadata and separates reading, selection and download taps',
    (tester) async {
      final events = <String>[];
      await show(
        tester,
        MobileChapterTile(
          title: 'Chapter 12 — A long chapter title',
          metadata: '12 May · Scanlator with a long name · 20.5 MB',
          description: 'A short chapter description',
          read: false,
          bookmarked: true,
          selecting: false,
          selected: false,
          onTap: () => events.add('read'),
          onLongPress: () => events.add('select'),
          trailing: IconButton(
            tooltip: 'Download',
            icon: const Icon(Icons.download),
            onPressed: () => events.add('download'),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Download'));
      expect(events, ['download']);
      await tester.tap(find.text('Chapter 12 — A long chapter title'));
      await tester.longPress(find.text('Chapter 12 — A long chapter title'));
      expect(events, ['download', 'read', 'select']);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'large-text filter sheet scrolls its tabs and contents independently',
    (tester) async {
      final events = <String>[];
      await show(
        tester,
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 420),
          child: MobileChapterFilterSheet(
            labels: const ['Filter', 'Sort', 'Display'],
            closeLabel: 'Close',
            onClose: () => events.add('close'),
            children: [
              const Text('Unread filter'),
              Column(
                children: [
                  for (var i = 0; i < 10; i++)
                    TextButton(
                      onPressed: () => events.add('sort $i'),
                      child: Text('Sort option $i'),
                    ),
                ],
              ),
              const Text('Chapter title display'),
            ],
          ),
        ),
      );
      final compactHeight = tester
          .getSize(find.byType(MobileChapterFilterSheet))
          .height;
      await tester.ensureVisible(find.text('Sort'));
      await tester.tap(find.text('Sort'));
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(MobileChapterFilterSheet)).height,
        greaterThan(compactHeight),
      );
      await tester.ensureVisible(find.text('Sort option 9'));
      await tester.tap(find.text('Sort option 9'));
      await tester.ensureVisible(find.text('Display'));
      await tester.tap(find.text('Display'));
      await tester.pumpAndSettle();
      expect(find.text('Chapter title display'), findsOneWidget);
      expect(
        tester.getSize(find.byType(MobileChapterFilterSheet)).height,
        lessThan(200),
      );
      await tester.tap(find.byTooltip('Close'));
      expect(events, ['sort 9', 'close']);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'synopsis expands without invoking its independent genre action',
    (tester) async {
      var expanded = false;
      var genreCalls = 0;
      final changes = <bool>[];
      const description =
          'A letter brings the reader back to the seaside town. '
          'The story continues through the harbor and the old bookshop. '
          'An old friend has kept the final letter for many years. '
          'The answer is waiting at the lighthouse.';
      await show(
        tester,
        StatefulBuilder(
          builder: (context, setState) => MobileDetailSynopsis(
            title: 'Description',
            text: description,
            expanded: expanded,
            onChanged: (value) => setState(() {
              expanded = value;
              changes.add(value);
            }),
            genres: [
              TextButton(
                onPressed: () => genreCalls++,
                child: const Text('Slice of life'),
              ),
            ],
          ),
        ),
        largeText: false,
      );
      await tester.tap(find.text('Slice of life'));
      expect(genreCalls, 1);
      expect(changes, isEmpty);
      final collapsedHeight = tester
          .getSize(find.byType(MobileDetailSynopsis))
          .height;
      await tester.tap(find.text('Expand'));
      await tester.pumpAndSettle();
      expect(changes, [true]);
      expect(
        tester.getSize(find.byType(MobileDetailSynopsis)).height,
        greaterThan(collapsedHeight),
      );
      await tester.tap(find.text(description));
      await tester.pump();
      expect(changes, [true, false]);
      expect(genreCalls, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('conditional shortcuts stay left aligned with two-line labels', (
    tester,
  ) async {
    var calls = 0;
    await show(
      tester,
      Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 304,
          child: MobileDetailShortcuts(
            children: [
              NodeLaneToolbarAction(
                icon: Icons.sync,
                label: '3 个追踪器',
                onPressed: () => calls++,
              ),
              NodeLaneToolbarAction(
                icon: Icons.thumb_up,
                label: '推荐',
                onPressed: () {},
              ),
              NodeLaneToolbarAction(
                icon: Icons.book,
                label: '相关作品',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      largeText: false,
    );
    expect(tester.takeException(), isNull);
    expect(tester.getTopLeft(find.byType(NodeLaneToolbarAction).first).dx, 20);
    await tester.tap(find.text('3 个追踪器'));
    expect(calls, 1);
  });
}
