import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/settings/reader/mobile_reader_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/translation/translation_language_picker.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  Future<void> mount(
    WidgetTester tester,
    Future<void> Function(BuildContext) open,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: nodeLaneModalTheme(ThemeData(platform: TargetPlatform.iOS)),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(padding: const EdgeInsets.only(top: 47, bottom: 34)),
          child: child!,
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => open(context),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'translation choices size to content and put guidance above the options',
    (tester) async {
      String? result;
      await mount(tester, (context) async {
        result = await showTranslationLanguagePicker(context, 'zh-Hans');
      });
      final heading = tester.element(find.byType(NodeLaneReaderHeading));
      final l10n = AppLocalizations.of(heading)!;
      final hint = find.text(
        '${l10n.settings_translation_scope}\n${l10n.settings_immediate_choice}',
      );
      final first = find.widgetWithText(NodeLaneRow, '简体中文');
      expect(
        tester.getBottomLeft(hint).dy,
        lessThan(tester.getTopLeft(first).dy),
      );
      expect(tester.getTopLeft(hint).dx, 20);
      final surface = tester.getRect(find.byType(NodeLaneReaderSurface));
      final last = tester.getRect(find.widgetWithText(NodeLaneRow, '日本語'));
      expect(surface.height, lessThan(500));
      expect(surface.bottom - last.bottom, closeTo(34 + 24, 1));
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(result, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'short choices stay compact, long choices scroll to selection and keyboard keeps close reachable',
    (tester) async {
      var count = 2;
      MobileSettingOption<int>? result;
      await mount(tester, (context) async {
        result = await showMobileReaderPicker<int>(
          context,
          title: 'Choice',
          current: count - 1,
          description: 'Applies to all comics',
          options: [
            for (var i = 0; i < count; i++) MobileSettingOption(i, 'Option $i'),
          ],
        );
      });
      final compact = tester.getSize(find.byType(NodeLaneReaderSurface)).height;
      expect(compact, lessThan(350));
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(result, isNull);
      count = 30;
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(NodeLaneReaderSurface)).height,
        greaterThan(compact),
      );
      expect(find.text('Option 29').hitTestable(), findsOneWidget);
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Close').hitTestable(), findsOneWidget);
      final sheet = tester.getRect(find.byType(NodeLaneReaderSurface));
      expect(sheet.bottom, lessThanOrEqualTo(544));
      await tester.scrollUntilVisible(
        find.text('Option 29'),
        250,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Option 29'));
      await tester.pumpAndSettle();
      expect(result?.value, 29);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'nested reader choices resize the existing sheet and restore its settings height',
    (tester) async {
      await mount(tester, (context) async {
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => NodeLaneReaderSurface(
            child: MobileReaderPickerHost(
              bookTitle: 'Book',
              onClose: () => Navigator.pop(context),
              child: Builder(
                builder: (context) => Center(
                  child: TextButton(
                    child: const Text('Select'),
                    onPressed: () => showMobileReaderPicker<int>(
                      context,
                      title: 'Choice',
                      current: 0,
                      description: 'Applies to this comic',
                      options: const [
                        MobileSettingOption(0, 'First'),
                        MobileSettingOption(1, 'Second'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
      final host = find.byType(MobileReaderPickerHost);
      final settingsHeight = tester.getSize(host).height;
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.text('Select'));
        await tester.pumpAndSettle();
        expect(tester.getSize(host).height, lessThan(400));
        expect(find.text('Second').hitTestable(), findsOneWidget);
        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();
        expect(tester.getSize(host).height, settingsHeight);
      }
      expect(tester.takeException(), isNull);
    },
  );
}
