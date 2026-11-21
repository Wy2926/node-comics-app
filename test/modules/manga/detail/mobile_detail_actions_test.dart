import 'dart:async';
import 'dart:ui' show SemanticsAction;

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_actions.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';

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
          onSelected: (origin, value) async {
            actions.add(value);
            if ([1, 3, 4, 6].contains(value)) {
              await pushBrowsePage<void>(
                origin,
                MobileBrowsePage(
                  title: 'Inline $value',
                  body: const Text('Form'),
                ),
              );
            }
          },
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
        expect(find.text('Detail page'), findsOneWidget);
        if ([1, 3, 4, 6].contains(entry.value)) {
          final form = find.text('Form');
          expect(
            find.ancestor(of: form, matching: find.byType(NodeLaneBubbleFlow)),
            findsOneWidget,
          );
          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();
          expect(find.text('Comic A').hitTestable(), findsOneWidget);
          await tester.tap(find.byTooltip('Close'));
          await tester.pumpAndSettle();
        }
      }
      for (final favorite in [true, false]) {
        await _show(
          tester,
          MobileMangaDetailActionsButton(
            bookTitle: 'Local comic',
            localArchive: true,
            favorite: favorite,
            onSelected: (_, value) async => actions.add(value),
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
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
      }
      expect(actions, expected.values.toList());
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'download ranges dispatch by scope and empty filters explain how to recover',
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
        final choice = index < 4
            ? find.byTooltip(labels[index])
            : find.text(labels[index]);
        await tester.ensureVisible(choice);
        if (index < 4) {
          final node = tester.getSemantics(
            find.widgetWithText(FilledButton, '${nextDownloadCounts[index]}'),
          );
          expect(node.label, labels[index]);
          expect(
            node.getSemanticsData().hasAction(SemanticsAction.tap),
            isTrue,
          );
        }
        await tester.tap(choice);
        await tester.pumpAndSettle();
      }

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
      expect(find.text('All chapters'), findsNothing);
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
          onSelected: (_, _) {
            calls++;
            return pending.future;
          },
        ),
      );
      await _open(tester, 'Comic actions');
      await tester.ensureVisible(find.text('Export metadata'));
      final point = tester.getCenter(find.text('Export metadata'));
      await tester.tapAt(point);
      await tester.pump(const Duration(milliseconds: 32));
      await tester.tapAt(point);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.byTooltip('Comic actions'), warnIfMissed: false);
      await tester.pump();
      expect(calls, 1);
      expect(find.text('Detail page'), findsOneWidget);
      expect(find.text('Export metadata'), findsNothing);
      pending.completeError(StateError('private fixture path'));
      await tester.pumpAndSettle();
      expect(find.textContaining('The action did not finish'), findsOneWidget);
      expect(find.textContaining('private fixture path'), findsNothing);
      expect(calls, 1);

      pending = Completer<void>();
      await _open(tester, 'Comic actions');
      await tester.tap(find.text('Export metadata'));
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
