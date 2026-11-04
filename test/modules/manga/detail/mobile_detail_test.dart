import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_widgets.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  Future<void> show(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(2)),
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
    'large-text detail heading stacks and keeps primary actions reachable',
    (tester) async {
      final events = <String>[];
      await show(
        tester,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MobileDetailHeading(
              cover: SizedBox(key: Key('cover'), width: 96, height: 144),
              title: Text(
                'A long title with a second line',
                key: Key('title'),
                style: TextStyle(fontSize: 24),
              ),
              metadata: Text('Author · Source with a long translated name'),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  label: const Text('Resume reading'),
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => events.add('read'),
                ),
                NodeLaneSecondaryButton(
                  icon: Icons.add,
                  onPressed: () => events.add('favorite'),
                  child: const Text('Add to library'),
                ),
              ],
            ),
          ],
        ),
      );
      expect(
        tester.getTopLeft(find.byKey(const Key('title'))).dy,
        greaterThan(tester.getBottomLeft(find.byKey(const Key('cover'))).dy),
      );
      for (final label in ['Resume reading', 'Add to library']) {
        await tester.ensureVisible(find.text(label));
        await tester.tap(find.text(label));
      }
      expect(events, ['read', 'favorite']);
      expect(tester.takeException(), isNull);
    },
  );

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
}
