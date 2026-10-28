import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/download_queue/mobile_download_queue.dart';

Download entry(
  int id,
  String name, {
  int? total = 100,
  int? succeeded = 0,
  int failed = 0,
}) {
  final manga = Manga(
    id: id,
    source: 'fixture',
    author: null,
    artist: null,
    genre: null,
    imageUrl: null,
    lang: 'en',
    link: 'fixture/$id',
    name: name,
    status: Status.unknown,
    description: null,
    sourceId: 1,
  );
  final chapter = Chapter(id: id, mangaId: id, name: 'Chapter $id')
    ..manga.value = manga;
  return Download(
    id: id,
    succeeded: succeeded,
    failed: failed,
    total: total,
    isDownload: false,
    isStartDownload: false,
  )..chapter.value = chapter;
}

void main() {
  testWidgets(
    'queue actions stay separate while sorting, starting and scrolling at large text',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var entries = [
        entry(1, 'First series', total: 0, succeeded: null),
        entry(2, 'Second series', failed: 1, succeeded: 50),
        entry(
          3,
          'A very long manga title that must fit in a narrow mobile queue',
          succeeded: 130,
        ),
      ];
      var starting = false;
      var starts = 0;
      var settings = 0;
      var scale = 1.0;
      final moves = <(int, int)>[];
      final cancelled = <Download>[];
      final cancelledSeries = <Download>[];
      late StateSetter rebuild;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('en'),
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(scale),
                  padding: const EdgeInsets.only(top: 24, bottom: 34),
                ),
                child: child!,
              ),
              home: MobileDownloadQueue(
                entries: entries,
                isStarting: starting,
                onStart: () => setState(() {
                  starts++;
                  starting = true;
                }),
                onSettings: () => settings++,
                onReorder: (from, to) => setState(() {
                  moves.add((from, to));
                  entries = entries.toList();
                  entries.insert(to, entries.removeAt(from));
                }),
                onCancel: cancelled.add,
                onCancelSeries: cancelledSeries.add,
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      Finder inside(int id, Type type) => find.descendant(
        of: find.byKey(ValueKey<int?>(id)),
        matching: find.byType(type),
      );
      expect(
        tester
            .widget<LinearProgressIndicator>(inside(1, LinearProgressIndicator))
            .value,
        0,
      );
      expect(
        tester
            .widget<LinearProgressIndicator>(inside(2, LinearProgressIndicator))
            .value,
        .5,
      );
      expect(
        tester
            .widget<LinearProgressIndicator>(inside(3, LinearProgressIndicator))
            .value,
        1,
      );
      expect(find.text('Failed!'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      final handle = inside(1, ReorderableDragStartListener);
      final distance =
          tester.getSize(find.byKey(const ValueKey<int?>(1))).height + 8;
      final drag = await tester.startGesture(tester.getCenter(handle));
      await tester.pump();
      await drag.moveBy(Offset(0, distance / 2));
      await tester.pump(const Duration(milliseconds: 300));
      await drag.moveBy(Offset(0, distance / 2));
      await tester.pump(const Duration(milliseconds: 300));
      await drag.up();
      await tester.pumpAndSettle();
      expect(moves, [(0, 1)]);
      expect(entries.map((entry) => entry.id), [2, 1, 3]);
      expect(cancelled, isEmpty);

      await tester.tap(inside(1, PopupMenuButton<bool>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(cancelled.single.id, 1);
      expect(cancelledSeries, isEmpty);
      await tester.tap(inside(2, PopupMenuButton<bool>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel all for this series'));
      await tester.pumpAndSettle();
      expect(cancelledSeries.single.id, 2);
      expect(starts, 0);

      rebuild(() => scale = 2.5);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Chapter 3'), 220);
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byType(FilledButton)).bottom,
        lessThanOrEqualTo(766),
      );
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton));
      expect(starts, 1);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(
        tester
            .widget<PopupMenuButton<bool>>(inside(3, PopupMenuButton<bool>))
            .enabled,
        isFalse,
      );
      expect(
        tester
            .widget<ReorderableDragStartListener>(
              inside(3, ReorderableDragStartListener),
            )
            .enabled,
        isFalse,
      );

      rebuild(() {
        entries = [];
        starting = false;
      });
      await tester.pumpAndSettle();
      expect(find.byType(FilledButton), findsNothing);
      expect(
        find.text('Open a chapter list to add downloads.'),
        findsOneWidget,
      );
      await tester.tap(find.byIcon(Icons.settings_outlined));
      expect(settings, 1);
      expect(tester.takeException(), isNull);
    },
  );
}
