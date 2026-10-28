import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_header.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_source_card.dart';

Widget app(Widget child) => MaterialApp(
  theme: ThemeData(brightness: Brightness.dark),
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)),
    child: child!,
  ),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('browse controls remain reachable with large text and keyboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    var extensions = false, compact = false;
    var searches = 0, filters = 0;
    late StateSetter update;
    await tester.pumpWidget(
      app(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return Column(
              children: [
                MobileBrowseHeader(
                  title: '浏览',
                  mediaMenu: TextButton(
                    onPressed: () {},
                    child: const Text('漫画'),
                  ),
                  sourcesLabel: '来源',
                  extensionsLabel: '扩展',
                  extensionsSelected: extensions,
                  onSectionChanged: (value) =>
                      setState(() => extensions = value),
                  searchHint: extensions ? '搜索扩展' : '全局搜索',
                  searchController: controller,
                  onQueryChanged: (_) => setState(() {}),
                  onGlobalSearch: () => searches++,
                  filterLabel: '筛选',
                  onFilter: () => filters++,
                  clearLabel: '清除',
                  updateCount: 12,
                  compact: compact,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.folder_open),
                    ),
                  ],
                ),
                const Expanded(child: Placeholder()),
              ],
            );
          },
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('全局搜索'));
    await tester.tap(find.byTooltip('筛选'));
    expect(searches, 1);
    expect(filters, 1);
    await tester.tap(find.text('扩展'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'sample');
    update(() => compact = true);
    await tester.pump();
    expect(find.text('浏览'), findsNothing);
    expect(controller.text, 'sample');
    await tester.tap(find.byTooltip('清除'));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(tester.takeException(), isNull);
  });

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
            MobileSourceCard(
              title: 'A long source name that stays readable',
              icon: const Icon(Icons.extension),
              metadata: const Wrap(
                children: [Text('English · Version 1.0 · Example repository')],
              ),
              onTap: () => opened++,
              actions: TextButton.icon(
                onPressed: () => updated++,
                icon: const Icon(Icons.update),
                label: const Text('Update extension'),
              ),
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
