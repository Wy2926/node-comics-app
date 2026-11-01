import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_widgets.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  Future<void> show(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        home: NodeLaneSurface(
          child: Scaffold(
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [child],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
            genres: TextButton(
              onPressed: () => genreCalls++,
              child: const Text('Slice of life'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Slice of life'));
      expect(genreCalls, 1);
      expect(changes, isEmpty);
      final collapsedHeight = tester
          .getSize(find.byType(MobileDetailSynopsis))
          .height;
      await tester.tap(find.text('Expand'));
      await tester.pump();
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

  testWidgets(
    'chapter download and long press stay separate from opening a chapter',
    (tester) async {
      var reads = 0, downloads = 0, selections = 0;
      await show(
        tester,
        MobileChapterTile(
          title: 'Chapter 12 · A letter from the sea',
          metadata: 'Page 6 · Sample team',
          read: false,
          bookmarked: true,
          selecting: false,
          selected: false,
          onTap: () => reads++,
          onLongPress: () => selections++,
          trailing: IconButton(
            tooltip: 'Download',
            onPressed: () => downloads++,
            icon: const Icon(Icons.download),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Download'));
      expect(downloads, 1);
      expect(reads, 0);
      await tester.longPress(find.text('Chapter 12 · A letter from the sea'));
      expect(selections, 1);
      expect(reads, 0);
      await tester.tap(find.text('Chapter 12 · A letter from the sea'));
      expect(reads, 1);
      expect(downloads, 1);
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
              MobileDetailShortcut(
                icon: Icons.sync,
                label: '3 个追踪器',
                onPressed: () => calls++,
              ),
              MobileDetailShortcut(
                icon: Icons.thumb_up,
                label: '推荐',
                onPressed: () {},
              ),
              MobileDetailShortcut(
                icon: Icons.book,
                label: '相关作品',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(tester.getTopLeft(find.byType(MobileDetailShortcut).first).dx, 20);
    await tester.tap(find.text('3 个追踪器'));
    expect(calls, 1);
  });
}
