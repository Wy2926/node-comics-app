import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_info_header.dart';

void main() {
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
