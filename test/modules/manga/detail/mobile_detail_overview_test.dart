import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_widgets.dart';

import '../../../fixtures/detail_overview_preview.dart';

void main() {
  testWidgets('overview keeps both actions aligned and chapters reachable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var readCalls = 0, libraryCalls = 0;
    await tester.pumpWidget(
      DetailOverviewPreview(
        statusPlaceholder: true,
        onRead: () => readCalls++,
        onLibrary: () => libraryCalls++,
      ),
    );
    await tester.pumpAndSettle();
    final read = tester.getRect(find.widgetWithText(FilledButton, '继续阅读'));
    final library = tester.getRect(find.widgetWithText(FilledButton, '已在书架'));
    expect(read.width, library.width);
    expect(read.top, library.top);
    expect(library.right, 374);
    expect(tester.getTopLeft(find.text('第12话  海风的回信')).dy, lessThan(720));
    await tester.tap(find.text('继续阅读'));
    await tester.tap(find.text('已在书架'));
    expect((readCalls, libraryCalls), (1, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'library action uses the available width when reading is hidden',
    (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 358,
              child: MobileDetailPrimaryActions(
                library: MobileDetailButton(
                  label: 'In library',
                  icon: Icons.check,
                  onPressed: () => calls++,
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(FilledButton)).width, 358);
      await tester.tap(find.text('In library'));
      expect(calls, 1);
      expect(tester.takeException(), isNull);
    },
  );
}
