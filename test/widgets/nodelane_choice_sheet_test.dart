import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/translation/translation_language_picker.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';
import 'package:mangayomi/services/translation/languages.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  Future<void> mount(
    WidgetTester tester,
    Future<void> Function(BuildContext) open, {
    double textScale = 1,
  }) async {
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
          data: MediaQuery.of(context).copyWith(
            padding: const EdgeInsets.only(top: 47, bottom: 34),
            textScaler: TextScaler.linear(textScale),
          ),
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

  for (final scale in [1.0, 2.5]) {
    testWidgets(
      'translation choices stay reachable and select immediately at text scale $scale',
      (tester) async {
        var current = 'zh-Hans';
        final results = <String?>[];
        await mount(tester, (context) async {
          final result = await showTranslationLanguagePicker(context, current);
          results.add(result);
          if (result != null) current = result;
        }, textScale: scale);
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
        expect(tester.getTopLeft(hint).dx, NodeLaneTokens.gutter);
        final surface = tester.getRect(find.byType(NodeLaneReaderSurface));
        expect(surface.top, greaterThanOrEqualTo(47));
        expect(surface.bottom, lessThanOrEqualTo(844));
        expect(
          tester.getSemantics(first).flagsCollection.isSelected,
          Tristate.isTrue,
        );
        expect(find.byTooltip('Close').hitTestable(), findsOneWidget);
        await tester.tap(find.byTooltip('Close'));
        await tester.pumpAndSettle();
        expect(results, [null]);
        expect(current, 'zh-Hans');

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        final choice = translationLanguageNames.entries.last;
        final last = find.widgetWithText(NodeLaneRow, choice.value);
        await tester.scrollUntilVisible(
          last,
          300,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.drag(find.byType(Scrollable).last, const Offset(0, -1000));
        await tester.pumpAndSettle();
        expect(last.hitTestable(), findsOneWidget);
        expect(
          tester.getRect(find.byType(NodeLaneReaderSurface)).bottom -
              tester.getRect(last).bottom,
          greaterThanOrEqualTo(34),
        );
        await tester.tap(last);
        await tester.pumpAndSettle();
        expect(results, [null, choice.key]);
        expect(current, choice.key);
        expect(find.byType(NodeLaneReaderSurface), findsNothing);

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          last,
          300,
          scrollable: find.byType(Scrollable).last,
        );
        expect(
          tester.getSemantics(last).flagsCollection.isSelected,
          Tristate.isTrue,
        );
        await tester.tap(find.byTooltip('Close'));
        await tester.pumpAndSettle();
        expect(results, [null, choice.key, null]);
        expect(current, choice.key);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
