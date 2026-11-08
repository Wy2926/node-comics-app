import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_info_header.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_widgets.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  testWidgets(
    'expanding the synopsis keeps short tags together and wraps long tags',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      for (final scale in [1.0, 2.0]) {
        var expanded = false;
        await tester.pumpWidget(
          MaterialApp(
            key: ValueKey(scale),
            theme: ThemeData(platform: TargetPlatform.iOS),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: NodeLaneSurface(
              child: Scaffold(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: StatefulBuilder(
                    builder: (context, setState) => MobileDetailSynopsis(
                      title: '简介',
                      text: '一封信让她回到海边的小镇，故事从这里开始。' * 4,
                      expanded: expanded,
                      onChanged: (value) => setState(() => expanded = value),
                      genres: [
                        for (final label in ['冒险', '穿越', '很长的题材标签也可以正常换行显示'])
                          DetailGenreChip(
                            label: label,
                            mobile: true,
                            libraryLabel: '书架搜索',
                            sourceLabel: '来源搜索',
                            onSelected: (_) {},
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        for (var cycle = 0; cycle < 2; cycle++) {
          await tester.tap(find.text('简介'));
          await tester.pumpAndSettle();
          expect(expanded, isTrue);
          final first = tester.getRect(
            find.widgetWithText(DetailGenreChip, '冒险'),
          );
          final second = tester.getRect(
            find.widgetWithText(DetailGenreChip, '穿越'),
          );
          expect(first.top, second.top);
          expect(first.right, lessThan(second.left));
          expect(first.width, lessThan(144));
          expect(tester.takeException(), isNull);
          await tester.tap(find.text('简介'));
          await tester.pumpAndSettle();
          expect(expanded, isFalse);
        }
      }
    },
  );

  testWidgets('mobile genre chip opens both searches with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final selected = <int>[];
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: Scaffold(
          body: Center(
            child: DetailGenreChip(
              label: 'Animation',
              mobile: true,
              libraryLabel: 'Search genre in library',
              sourceLabel: 'Browse in source',
              onSelected: selected.add,
            ),
          ),
        ),
      ),
    );

    try {
      final semanticsData = tester
          .getSemantics(find.bySemanticsLabel('Animation'))
          .getSemanticsData();
      expect(semanticsData.label, 'Animation');
      expect(semanticsData.hasAction(SemanticsAction.tap), isTrue);
    } finally {
      semantics.dispose();
    }

    await tester.tap(find.text('Animation'));
    await tester.pumpAndSettle();

    expect(find.text('Search genre in library'), findsOneWidget);
    expect(find.text('Browse in source'), findsOneWidget);

    await tester.tap(find.text('Search genre in library'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Animation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Browse in source'));
    await tester.pumpAndSettle();

    expect(selected, [0, 1]);
    expect(tester.takeException(), isNull);
  });
}
