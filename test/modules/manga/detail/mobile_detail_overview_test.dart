import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_widgets.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_loading.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';

import '../../../fixtures/detail_overview_preview.dart';

void main() {
  testWidgets(
    'initial detail skeleton stays scrollable and allows back at large text',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                child: const Text('Open detail'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const MobileDetailLoadingPage(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open detail'));
      await tester.pumpAndSettle();
      expect(find.byType(MobileDetailSynopsisLoading), findsOneWidget);
      await tester.ensureVisible(find.byType(MobileChapterListLoading));
      expect(find.text('无结果'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('返回'));
      await tester.pumpAndSettle();
      expect(find.text('Open detail'), findsOneWidget);
    },
  );
  testWidgets('overview keeps both actions aligned and chapters reachable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var readCalls = 0, libraryCalls = 0;
    await tester.pumpWidget(
      DetailOverviewPreview(
        onRead: () => readCalls++,
        onLibrary: () => libraryCalls++,
      ),
    );
    await tester.pumpAndSettle();
    final read = tester.getRect(find.widgetWithText(FilledButton, '继续阅读'));
    final library = tester.getRect(find.widgetWithText(FilledButton, '已在书架'));
    expect(read.width, library.width);
    expect(read.top, library.top);
    expect(library.right, 370);
    expect(tester.getTopLeft(find.text('第12话  海风的回信')).dy, lessThan(720));
    await tester.tap(find.text('继续阅读'));
    await tester.tap(find.text('已在书架'));
    expect((readCalls, libraryCalls), (1, 1));
    final titlePosition = tester.getTopLeft(find.text('海岸来信'));
    await tester.pumpWidget(
      DetailOverviewPreview(
        loading: true,
        onRead: () => readCalls++,
        onLibrary: () => libraryCalls++,
      ),
    );
    await tester.pump();
    expect(tester.getTopLeft(find.text('海岸来信')), titlePosition);
    expect(find.byType(MobileChapterListLoading), findsOneWidget);
    expect(find.text('第12话  海风的回信'), findsNothing);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, '加载章节…'))
          .onPressed,
      isNull,
    );
    await tester.tap(find.text('已在书架'));
    expect((readCalls, libraryCalls), (1, 2));
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(320, 700);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      DetailOverviewPreview(
        onRead: () => readCalls++,
        onLibrary: () => libraryCalls++,
      ),
    );
    await tester.pumpAndSettle();
    final heading = tester.widget<MobileDetailHeading>(
      find.byType(MobileDetailHeading),
    );
    expect(
      tester.getTopLeft(find.text('海岸来信')).dy,
      greaterThan(tester.getBottomLeft(find.byWidget(heading.cover)).dy),
    );
    for (final label in ['继续阅读', '已在书架']) {
      await tester.ensureVisible(find.text(label));
      await tester.tap(find.text(label));
    }
    expect((readCalls, libraryCalls), (2, 3));
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
                library: NodeLaneSecondaryButton(
                  icon: Icons.check,
                  onPressed: () => calls++,
                  child: const Text('In library'),
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
