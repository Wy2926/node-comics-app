import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_tracker_editor.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_tracker_search.dart';
import 'package:mangayomi/modules/more/settings/track/manage_trackers/mobile_tracking_detail.dart';

void main() {
  var keyboard = 0.0;
  setUp(() => keyboard = 0);
  Widget app(Widget child) => MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(2.5),
        padding: const EdgeInsets.only(top: 24, bottom: 34),
        viewInsets: EdgeInsets.only(bottom: keyboard),
      ),
      child: child!,
    ),
    home: child,
  );
  Future<void> start(WidgetTester tester, Widget home) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(home));
    await tester.pumpAndSettle();
  }

  Future<void> reveal(
    WidgetTester tester,
    Finder target, {
    double delta = 250,
  }) async {
    for (var attempt = 0; attempt < 2; attempt++) {
      if (target.evaluate().isEmpty) {
        await tester.scrollUntilVisible(
          target,
          delta,
          scrollable: find.byType(Scrollable).first,
        );
      }
      await Scrollable.ensureVisible(tester.element(target), alignment: .5);
      await tester.pump(const Duration(milliseconds: 350));
      if (target.hitTestable().evaluate().isNotEmpty) return;
    }
  }

  Future<void> tap(
    WidgetTester tester,
    Finder target, {
    double delta = 250,
  }) async {
    await reveal(tester, target, delta: delta);
    await tester.tap(target);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  Track record({
    int syncId = 2,
    int mediaId = 11,
    int? mangaId = 7,
    String title = 'Long tracked title with a local library link',
    ItemType type = ItemType.manga,
  }) => Track(
    id: 41,
    clientId: 98,
    syncId: syncId,
    mediaId: mediaId,
    mangaId: mangaId,
    title: title,
    itemType: type,
    status: TrackStatus.reading,
    lastChapterRead: 4,
    totalChapter: 12,
    score: 30,
    startedReadingDate: DateTime(2020, 1, 1).millisecondsSinceEpoch,
    finishedReadingDate: 0,
  );
  Widget editor({
    required Track track,
    required Future<void> Function(Track) update,
    required Future<void> Function() refresh,
    VoidCallback? remove,
    Future<void> Function()? match,
  }) => MobileTrackerEditor(
    track: track,
    itemType: track.itemType,
    statuses: const [TrackStatus.reading, TrackStatus.completed],
    scoreMax: 100,
    scoreStep: 30,
    scoreLabel: (value) => 'Score $value',
    startLabel: '2020/01/01',
    finishLabel: '—',
    onRefresh: refresh,
    onUpdate: update,
    onRemove: remove ?? () {},
    onChangeMatch: match,
  );

  testWidgets(
    'tracking choices preserve identity and original record, cancel drafts and gate progress and score values',
    (tester) async {
      final original = record();
      var current = original;
      final writes = <Track>[];
      var refreshes = 0, removes = 0, matches = 0;
      final home = StatefulBuilder(
        builder: (context, setState) => Scaffold(
          body: ListView(
            children: [
              editor(
                track: current,
                refresh: () async {
                  refreshes++;
                },
                update: (draft) async {
                  writes.add(draft);
                  setState(() => current = draft);
                },
                remove: () => removes++,
                match: () async {
                  matches++;
                },
              ),
            ],
          ),
        ),
      );
      await start(tester, home);
      expect(refreshes, 1);
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Status'));
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Completed'));
      await tester.pumpAndSettle();
      expect(writes.single.status, TrackStatus.completed);
      expect(original.status, TrackStatus.reading);
      expect(writes.single.id, original.id);
      expect(writes.single.clientId, original.clientId);
      expect(writes.single.mediaId, original.mediaId);
      expect(writes.single.syncId, original.syncId);
      expect(writes.single.mangaId, original.mangaId);
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Chapters'));
      keyboard = 280;
      await tester.pumpWidget(app(home));
      await tester.enterText(find.byType(TextField), '13');
      await tester.pumpAndSettle();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tester.enterText(find.byType(TextField), '8');
      await tap(tester, find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
      expect(writes.length, 1);
      keyboard = 0;
      await tester.pumpWidget(app(home));
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Chapters'));
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '4',
      );
      await tester.enterText(find.byType(TextField), '0');
      await tap(tester, find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(writes.last.lastChapterRead, 0);
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Score'));
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Score 60'));
      await tester.pumpAndSettle();
      expect(writes.last.score, 60);
      expect(tester.takeException(), isNull, reason: 'Before date picker');
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Start date'));
      expect(tester.takeException(), isNull, reason: 'Date picker layout');
      expect(
        tester
            .widget<CalendarDatePicker>(find.byType(CalendarDatePicker))
            .initialDate,
        DateTime(2020, 1, 1),
      );
      await tap(tester, find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(writes.length, 3);
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Start date'));
      await tap(tester, find.widgetWithText(TextButton, 'Switch to input'));
      expect(tester.takeException(), isNull, reason: 'Input mode');
      keyboard = 280;
      await tester.pumpWidget(app(home));
      await reveal(tester, find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), '01/02/2020');
      await tap(tester, find.widgetWithText(FilledButton, 'Confirm'));
      await tester.pumpAndSettle();
      expect(
        writes.last.startedReadingDate,
        DateTime(2020, 1, 2).millisecondsSinceEpoch,
      );
      expect(writes.last.finishedReadingDate, 0);
      keyboard = 0;
      await tester.pumpWidget(app(home));
      expect(tester.takeException(), isNull, reason: 'After date picker');
      final remove = find.widgetWithText(TextButton, 'Remove tracking');
      await tap(tester, remove);
      await tap(tester, find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
      expect(removes, 0);
      await tap(tester, remove);
      await tap(tester, find.widgetWithText(FilledButton, 'Remove'));
      await tester.pumpAndSettle();
      expect(removes, 1);
      await tap(
        tester,
        find.widgetWithText(TextButton, 'Change matching title'),
        delta: -250,
      );
      await tester.pumpAndSettle();
      expect(matches, 1);
      expect(refreshes, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'pending tracker edits block duplicate writes and back; failure requires refresh before another edit',
    (tester) async {
      final original = record();
      var writes = 0, refreshes = 0;
      final pending = Completer<void>();
      final recheck = Completer<void>();
      final home = Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => Scaffold(
                  body: ListView(
                    children: [
                      editor(
                        track: original,
                        refresh: () {
                          refreshes++;
                          return refreshes == 1
                              ? Future.value()
                              : recheck.future;
                        },
                        update: (draft) {
                          writes++;
                          return pending.future;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      );
      await start(tester, home);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final status = find.widgetWithText(NodeLaneRow, 'Status');
      await tap(tester, status);
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Completed'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(writes, 1);
      expect(tester.widget<NodeLaneRow>(status).onTap, isNull);
      await Navigator.of(tester.element(find.byType(MobileTrackerEditor)))
          .maybePop();
      await tester.pump();
      expect(find.byType(MobileTrackerEditor), findsOneWidget);
      pending.completeError(StateError('private service error'));
      await tester.pumpAndSettle();
      expect(original.status, TrackStatus.reading);
      expect(find.textContaining('private service error'), findsNothing);
      expect(tester.widget<NodeLaneRow>(status).onTap, isNull);
      final refresh = find.widgetWithText(TextButton, 'Refresh');
      await reveal(tester, refresh, delta: -250);
      final action = tester.widget<TextButton>(refresh).onPressed!;
      action();
      action();
      await tester.pump();
      expect(refreshes, 2);
      expect(writes, 1);
      recheck.complete();
      await tester.pumpAndSettle();
      expect(tester.widget<NodeLaneRow>(status).onTap, isNotNull);
      await Navigator.of(tester.element(find.byType(MobileTrackerEditor)))
          .maybePop();
      await tester.pumpAndSettle();
      expect(find.text('Open'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'entry list retains one subscription and isolates service/media records, search, expansion and retry',
    (tester) async {
      final events = StreamController<List<Track>>.broadcast();
      addTearDown(events.close);
      var loads = 0, mountedEditors = 0;
      final selected = <Track>[];
      final entries = [
        record(syncId: 1, title: 'Wrong service'),
        record(type: ItemType.anime, title: 'Wrong media'),
        record(title: 'No local link yet', mangaId: null),
        record(title: 'Selected local title'),
        record(title: 'Duplicate title'),
        record(mediaId: 44, mangaId: null, title: 'Unlinked record'),
      ];
      Stream<List<Track>> load() async* {
        loads++;
        yield entries;
        yield* events.stream;
      }

      final home = Scaffold(
        body: MobileTrackingEntries(
          syncId: 2,
          itemType: ItemType.manga,
          accountName: 'Readable account name',
          load: load,
          editorBuilder: (context, track) => _MountProbe(
            onMount: () {
              mountedEditors++;
              selected.add(track);
            },
          ),
        ),
      );
      await start(tester, home);
      expect(loads, 1);
      expect(mountedEditors, 0);
      expect(find.text('Wrong service'), findsNothing);
      expect(find.text('Wrong media'), findsNothing);
      expect(find.text('Duplicate title'), findsNothing);
      await tap(tester, find.text('Selected local title'));
      await tester.pumpAndSettle();
      expect(selected.single.title, 'Selected local title');
      expect(selected.single.syncId, 2);
      await tap(tester, find.text('Unlinked record'));
      await tester.pumpAndSettle();
      expect(mountedEditors, 1);
      await reveal(tester, find.byType(TextField), delta: -250);
      await tester.enterText(find.byType(TextField), 'no match');
      await tester.pumpAndSettle();
      expect(find.text('No result'), findsOneWidget);
      await tap(tester, find.byTooltip('Reset'));
      await tester.pumpAndSettle();
      expect(loads, 1);
      events.addError(StateError('repository failure'));
      await tester.pumpAndSettle();
      expect(find.textContaining('repository failure'), findsNothing);
      await tap(tester, find.widgetWithText(TextButton, 'Retry'));
      await tester.pumpAndSettle();
      expect(loads, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'tracker search preserves query on error, avoids duplicate requests and returns the selected result',
    (tester) async {
      final queries = <String>[];
      var response = Completer<List<TrackSearch>?>();
      TrackSearch? selected;
      final home = Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async {
              selected = await Navigator.of(context).push<TrackSearch>(
                MaterialPageRoute(
                  builder: (_) => MobileTrackerSearch(
                    initialQuery: 'Original title',
                    search: (query) {
                      queries.add(query);
                      return response.future;
                    },
                  ),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      );
      await start(tester, home);
      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(queries, ['Original title']);
      response.completeError(StateError('private search error'));
      await tester.pumpAndSettle();
      expect(find.textContaining('private search error'), findsNothing);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Original title',
      );
      response = Completer<List<TrackSearch>?>();
      keyboard = 280;
      await tester.pumpWidget(app(home));
      await tester.enterText(find.byType(TextField), '  Another title  ');
      final search = find.byType(FilledButton);
      await reveal(tester, search);
      final action = tester.widget<FilledButton>(search).onPressed!;
      action();
      action();
      await tester.pump();
      expect(queries, ['Original title', 'Another title']);
      final result = TrackSearch(
        mediaId: 77,
        title: 'A long returned title with its own metadata',
        publishingType: 'Manga',
        publishingStatus: 'Publishing',
      );
      response.complete([result]);
      await tester.pumpAndSettle();
      keyboard = 0;
      await tester.pumpWidget(app(home));
      await tap(tester, find.text(result.title!));
      await tester.pumpAndSettle();
      expect(selected, same(result));
      response = Completer<List<TrackSearch>?>();
      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pageBack();
      await tester.pump(const Duration(milliseconds: 500));
      response.completeError(StateError('late response'));
      await tester.pumpAndSettle();
      expect(find.text('Open'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

class _MountProbe extends StatefulWidget {
  const _MountProbe({required this.onMount});
  final VoidCallback onMount;
  @override
  State<_MountProbe> createState() => _MountProbeState();
}

class _MountProbeState extends State<_MountProbe> {
  @override
  void initState() {
    super.initState();
    widget.onMount();
  }

  @override
  Widget build(BuildContext context) => const Text('Editor');
}
