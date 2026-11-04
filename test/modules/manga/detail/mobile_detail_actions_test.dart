import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_actions.dart';

Future<void> _show(WidgetTester tester, Widget button) async {
  tester.view.physicalSize = const Size(360, 740);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      key: UniqueKey(),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(platform: TargetPlatform.iOS),
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        appBar: AppBar(actions: [button]),
        body: const Text('Detail page'),
      ),
    ),
  );
}

Future<void> _open(WidgetTester tester, String tooltip) async {
  await tester.tap(find.byTooltip(tooltip));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'detail menu retains action values and local/favorite boundaries',
    (tester) async {
      final actions = <int>[];
      await _show(
        tester,
        MobileMangaDetailActionsButton(
          bookTitle: 'Comic A',
          localArchive: false,
          favorite: true,
          onSelected: (value) async => actions.add(value),
        ),
      );
      const expected = {
        'Refresh': 0,
        'Set categories': 1,
        'Share': 2,
        'Migrate': 3,
        'Mass migration': 6,
        'Extension settings': 4,
        'Export metadata': 5,
      };
      for (final entry in expected.entries) {
        await _open(tester, 'Comic actions');
        expect(find.text('Comic A'), findsOneWidget);
        await tester.ensureVisible(find.text(entry.key));
        await tester.tap(find.text(entry.key));
        await tester.pumpAndSettle();
        expect(actions.last, entry.value);
        expect(find.text('Detail page'), findsOneWidget);
      }
      expect(actions, expected.values.toList());

      for (final favorite in [true, false]) {
        await _show(
          tester,
          MobileMangaDetailActionsButton(
            bookTitle: 'Local comic',
            localArchive: true,
            favorite: favorite,
            onSelected: (value) async => actions.add(value),
          ),
        );
        await _open(tester, 'Comic actions');
        expect(find.text('Refresh'), findsNothing);
        expect(find.text('Share'), findsNothing);
        expect(find.text('Extension settings'), findsNothing);
        expect(
          find.text('Set categories'),
          favorite ? findsOneWidget : findsNothing,
        );
        await tester.tap(find.byTooltip('Close'));
        await tester.pumpAndSettle();
      }
      expect(actions, expected.values.toList());
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'download ranges stay separate and empty/short sheets remain usable',
    (tester) async {
      final actions = <int>[];
      await _show(
        tester,
        MobileMangaDownloadActionsButton(
          bookTitle:
              'A comic with a long title that stays complete in the menu',
          hasChapters: true,
          onSelected: (value) async => actions.add(value),
        ),
      );
      const labels = [
        'Next chapter',
        'Next 5 chapters',
        'Next 10 chapters',
        'Next 25 chapters',
        'Unread',
        'All chapters',
      ];
      for (var index = 0; index < labels.length; index++) {
        await _open(tester, 'Download');
        await tester.ensureVisible(find.text(labels[index]));
        await tester.tap(find.text(labels[index]));
        await tester.pumpAndSettle();
        expect(actions.last, index);
      }
      expect(actions, [0, 1, 2, 3, 4, 5]);

      await _show(
        tester,
        MobileMangaDownloadActionsButton(
          bookTitle: 'Empty filtered list',
          hasChapters: false,
          onSelected: (value) async => actions.add(value),
        ),
      );
      tester.view.physicalSize = const Size(640, 360);
      await tester.pump();
      await _open(tester, 'Download');
      expect(find.textContaining('No chapters match'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('All chapters'),
        160,
        scrollable: find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        ),
      );
      final tile = tester.widget<NodeLaneRow>(
        find.widgetWithText(NodeLaneRow, 'All chapters'),
      );
      expect(tile.onTap, isNull);
      expect(tile.enabled, false);
      expect(
        tester.getRect(find.byTooltip('Close')).top,
        greaterThanOrEqualTo(0),
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(actions, [0, 1, 2, 3, 4, 5]);
      expect(find.text('Detail page'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'menu selection and pending actions resist repeats and handle failure/disposal',
    (tester) async {
      var pending = Completer<void>();
      var calls = 0;
      await _show(
        tester,
        MobileMangaDetailActionsButton(
          bookTitle: 'Comic A',
          localArchive: true,
          favorite: true,
          onSelected: (_) {
            calls++;
            return pending.future;
          },
        ),
      );
      final reopen = tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is IconButton && widget.tooltip == 'Comic actions',
            ),
          )
          .onPressed!;
      await _open(tester, 'Comic actions');
      await tester.ensureVisible(find.text('Export metadata'));
      final choose = tester
          .widget<NodeLaneRow>(
            find.widgetWithText(NodeLaneRow, 'Export metadata'),
          )
          .onTap!;
      choose();
      choose();
      reopen();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(calls, 1);
      expect(find.text('Detail page'), findsOneWidget);
      expect(
        tester
            .widget<IconButton>(
              find.byWidgetPredicate(
                (widget) =>
                    widget is IconButton && widget.tooltip == 'Comic actions',
              ),
            )
            .onPressed,
        isNull,
      );
      pending.completeError(StateError('private fixture path'));
      await tester.pumpAndSettle();
      expect(find.textContaining('The action did not finish'), findsOneWidget);
      expect(find.textContaining('private fixture path'), findsNothing);
      expect(calls, 1);

      pending = Completer<void>();
      await _open(tester, 'Comic actions');
      await tester.tap(find.text('Set categories'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(calls, 2);
      await tester.pumpWidget(const MaterialApp(home: Text('Other page')));
      pending.completeError(StateError('late fixture failure'));
      await tester.pumpAndSettle();
      expect(find.text('Other page'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
