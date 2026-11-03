import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/download_queue/mobile_download_queue.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';

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
              theme: ThemeData(platform: TargetPlatform.iOS),
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
      expect(find.text('Download failed'), findsOneWidget);
      expect(find.text('Retry downloads'), findsOneWidget);

      final handle = inside(1, ReorderableDragStartListener);
      final distance =
          tester.getSize(find.byKey(const ValueKey<int?>(1))).height + 8;
      final drag = await tester.startGesture(
        tester.getTopLeft(handle) + const Offset(4, 4),
      );
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

      await tester.tap(inside(1, NodeLaneIconButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel this chapter’s download'));
      await tester.pumpAndSettle();
      expect(cancelled.single.id, 1);
      expect(cancelledSeries, isEmpty);
      await tester.tap(inside(2, NodeLaneIconButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel all downloads for this title'));
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
            .widget<NodeLaneIconButton>(inside(3, NodeLaneIconButton))
            .onPressed,
        isNull,
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
        find.text('Add downloads from a title’s chapter list.'),
        findsOneWidget,
      );
      expect(
        tester.getCenter(find.text('No downloads queued')).dx,
        closeTo(180, .01),
      );
      await tester.tap(find.byTooltip('Downloads'));
      expect(settings, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'action sheet is compact, dismissible and checks the live queue',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var entries = [entry(1, 'Series', succeeded: 48)..isStartDownload = true];
      var scale = 1.0;
      final cancelled = <Download>[];
      final cancelledSeries = <Download>[];
      late StateSetter rebuild;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return MaterialApp(
              theme: ThemeData(platform: TargetPlatform.iOS),
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
                isStarting: false,
                onStart: () {},
                onReorder: (_, _) {},
                onSettings: () {},
                onCancel: cancelled.add,
                onCancelSeries: cancelledSeries.add,
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Downloading'), findsOneWidget);
      final open = tester
          .widget<NodeLaneIconButton>(
            find.ancestor(
              of: find.byTooltip('More'),
              matching: find.byType(NodeLaneIconButton),
            ),
          )
          .onPressed!;
      open();
      open();
      await tester.pumpAndSettle();
      expect(find.byType(NodeLaneCatalogSheet), findsOneWidget);
      expect(
        tester.getSize(find.byType(NodeLaneReaderSurface)).height,
        lessThan(400),
      );
      final subtitle = tester.getRect(find.text('Series · Chapter 1'));
      final firstAction = tester.getRect(
        find.text('Cancel this chapter’s download'),
      );
      expect(subtitle.left, 20);
      expect(subtitle.bottom, lessThan(firstAction.top));
      expect(
        844 - tester.getBottomLeft(find.byType(NodeLaneGroupSurface).last).dy,
        closeTo(34 + 24, .01),
      );
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(cancelled, isEmpty);

      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();
      rebuild(() => entries = []);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel all downloads for this title'));
      await tester.pumpAndSettle();
      expect(cancelledSeries, isEmpty);

      rebuild(() => entries = [entry(1, 'Series')]);
      await tester.pumpAndSettle();
      expect(find.text('Waiting to download'), findsOneWidget);
      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();
      final updated = entry(1, 'Series', succeeded: 80);
      rebuild(() => entries = [updated]);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel this chapter’s download'));
      await tester.pumpAndSettle();
      expect(cancelled.single, same(updated));

      rebuild(() => scale = 2.5);
      tester.view.physicalSize = const Size(320, 568);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.byTooltip('More'), 120);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.text('Cancel all downloads for this title'),
      );
      await tester.pumpAndSettle();
      // At 250% the translated action can be taller than the scroll viewport;
      // its visible portion remains an accessible target.
      final visibleAction = tester
          .getRect(find.text('Cancel all downloads for this title'))
          .intersect(
            tester.getRect(
              find.descendant(
                of: find.byType(NodeLaneCatalogSheet),
                matching: find.byType(SingleChildScrollView),
              ),
            ),
          );
      expect(visibleAction.isEmpty, isFalse);
      await tester.tapAt(visibleAction.center);
      await tester.pumpAndSettle();
      expect(cancelledSeries.single, same(updated));
      expect(tester.takeException(), isNull);
    },
  );
}
