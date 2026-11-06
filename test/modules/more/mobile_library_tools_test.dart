import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/calendar/mobile_calendar.dart';
import 'package:mangayomi/modules/calendar/models/upcoming_ui_model.dart';
import 'package:mangayomi/modules/more/categories/mobile_categories.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/statistics/mobile_statistics.dart';
import 'package:mangayomi/modules/more/statistics/statistics_provider.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  late ValueNotifier<(double, double)> layout;
  setUp(() => layout = ValueNotifier((2.5, 0)));
  tearDown(() => layout.dispose());

  Future<void> start(
    WidgetTester tester,
    Widget home, {
    ProviderContainer? container,
  }) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final app = MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => ValueListenableBuilder(
        valueListenable: layout,
        builder: (_, value, _) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(value.$1),
            padding: const EdgeInsets.only(top: 24, bottom: 34),
            viewInsets: EdgeInsets.only(bottom: value.$2),
          ),
          child: child!,
        ),
      ),
      home: home,
    );
    await tester.pumpWidget(
      container == null
          ? app
          : UncontrolledProviderScope(container: container, child: app),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  Future<void> reveal(
    WidgetTester tester,
    Finder finder, {
    double delta = 250,
  }) async {
    if (finder.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        finder,
        delta,
        scrollable: find.byType(AlertDialog).evaluate().isNotEmpty
            ? find.byType(Scrollable).last
            : find.byType(Scrollable).first,
      );
    }
    await Scrollable.ensureVisible(tester.element(finder), alignment: .5);
    await tester.pump(const Duration(milliseconds: 350));
  }

  Future<void> tap(
    WidgetTester tester,
    Finder finder, {
    double delta = 250,
  }) async {
    if (finder.hitTestable().evaluate().isEmpty) {
      await reveal(tester, finder, delta: delta);
    }
    await tester.tap(finder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  Widget launcher(Future<void> Function(BuildContext) open) => Scaffold(
    body: Builder(
      builder: (context) =>
          TextButton(onPressed: () => open(context), child: const Text('Open')),
    ),
  );

  testWidgets(
    'statistics retain metrics and zero guards, query the chosen media and retry failed loads',
    (tester) async {
      final requests = <ItemType>[];
      var pending = Completer<StatisticsData>();
      final container = ProviderContainer(
        retry: (_, _) => null,
        overrides: [
          getStatisticsProvider.overrideWith((ref, type) {
            requests.add(type);
            if (type == ItemType.manga) return pending.future;
            return const StatisticsData(
              totalItems: 0,
              totalChapters: 0,
              readChapters: 0,
              completedItems: 0,
              downloadedItems: 0,
              totalReadingTimeSeconds: 0,
            );
          }),
        ],
      );
      addTearDown(container.dispose);
      await start(
        tester,
        const MobileStatistics(types: [ItemType.manga, ItemType.novel]),
        container: container,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      pending.completeError(StateError('query failed'));
      await tester.pumpAndSettle();
      pending = Completer<StatisticsData>();
      await tap(tester, find.text('Retry'));
      pending.complete(
        const StatisticsData(
          totalItems: 4,
          totalChapters: 144,
          readChapters: 48,
          completedItems: 1,
          downloadedItems: 7,
          totalReadingTimeSeconds: 3660,
        ),
      );
      await tester.pumpAndSettle();
      for (final value in [
        '4',
        '1',
        '25.0%',
        '144',
        '48',
        '96',
        '7',
        '36.00',
        '33.3%',
        '1h 1m',
        '15m',
      ]) {
        await reveal(tester, find.text(value));
        expect(find.text(value), findsOneWidget);
      }
      await tap(tester, find.widgetWithText(ChoiceChip, 'Novel'), delta: -250);
      await tester.pumpAndSettle();
      expect(find.textContaining('NaN'), findsNothing);
      await reveal(tester, find.text('0m').last);
      expect(find.text('0m'), findsNWidgets(2));
      expect(requests, [ItemType.manga, ItemType.manga, ItemType.novel]);
      expect(find.widgetWithText(ChoiceChip, 'Anime'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'category name drafts keep exact validation, keyboard cancellation and pending/failure guards',
    (tester) async {
      layout.value = (2.5, 240);
      final writes = <String>[];
      var pending = Completer<void>();
      await start(
        tester,
        launcher((context) async {
          await showDialog<bool>(
            context: context,
            builder: (_) => MobileCategoryNameDialog(
              initialName: 'Original',
              nameExists: (name) => name == 'Existing',
              onSave: (name) {
                writes.add(name);
                return pending.future;
              },
            ),
          );
        }),
      );
      await tap(tester, find.text('Open'));
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'OK'))
            .onPressed,
        isNull,
      );
      await tester.enterText(find.byType(TextField), 'Existing');
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'OK'))
            .onPressed,
        isNull,
      );
      await tap(tester, find.text('Cancel'));
      expect(writes, isEmpty);
      await tap(tester, find.text('Open'));
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Original',
      );
      await tester.enterText(find.byType(TextField), ' Existing ');
      await tester.pumpAndSettle();
      await tap(tester, find.widgetWithText(FilledButton, 'OK'));
      await tester.tap(
        find.widgetWithText(FilledButton, 'OK'),
        warnIfMissed: false,
      );
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.byType(MobileCategoryNameDialog), findsOneWidget);
      expect(writes, [' Existing ']);
      pending.completeError(StateError('write failed'));
      await tester.pumpAndSettle();
      expect(find.text('Failed!'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        ' Existing ',
      );
      pending = Completer<void>()..complete();
      await tap(tester, find.widgetWithText(FilledButton, 'OK'));
      await tester.pumpAndSettle();
      expect(find.byType(MobileCategoryNameDialog), findsNothing);
      expect(writes, [' Existing ', ' Existing ']);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'categories use the requested visible media, drag copies records and creation keeps the media',
    (tester) async {
      layout.value = (1, 0);
      final first = Category(
        id: 10,
        clientId: 110,
        name: 'Novel first',
        forItemType: ItemType.novel,
        pos: 0,
        hide: true,
        shouldUpdate: false,
        updatedAt: 7,
      )..forManga = false;
      final second = Category(
        id: 20,
        name: 'Novel second',
        forItemType: ItemType.novel,
        pos: 1,
      );
      var records = [first, second];
      final events = StreamController<List<Category>>.broadcast();
      addTearDown(events.close);
      final requests = <ItemType>[];
      final created = <Category>[];
      final reordered = <List<Category>>[];
      final container = ProviderContainer(
        overrides: [
          getMangaCategorieStreamProvider.overrideWith((ref, type) async* {
            requests.add(type);
            yield type == ItemType.novel ? records : [];
            yield* events.stream;
          }),
        ],
      );
      addTearDown(container.dispose);
      await start(
        tester,
        MobileCategories(
          types: [ItemType.manga, ItemType.novel],
          initialType: ItemType.novel,
          editing: true,
          onCreate: (category) async => created.add(category),
          onSave: (_) async => fail('No edit requested'),
          onRemove: (_) async => fail('No removal requested'),
          onReorder: (next) async {
            reordered.add(next);
            records = next;
            events.add(next);
          },
        ),
        container: container,
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<NodeLaneSegments<ItemType>>(
              find.byType(NodeLaneSegments<ItemType>),
            )
            .value,
        ItemType.novel,
      );
      final row = find.byKey(const ValueKey('category-10'));
      final handle = find.descendant(
        of: row,
        matching: find.byType(ReorderableDragStartListener),
      );
      final gesture = await tester.startGesture(tester.getCenter(handle));
      final distance = tester.getSize(row).height + 12;
      await tester.pump();
      await gesture.moveBy(Offset(0, distance / 2));
      await tester.pump(const Duration(milliseconds: 300));
      await gesture.moveBy(Offset(0, distance / 2));
      await tester.pump(const Duration(milliseconds: 300));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(reordered, hasLength(1));
      expect(reordered.single.map((c) => c.id), [20, 10]);
      expect(reordered.single.map((c) => c.pos), [0, 1]);
      expect(first.pos, 0);
      expect(first.updatedAt, 7);
      final moved = reordered.single.last;
      expect(
        (
          moved.clientId,
          moved.forItemType,
          moved.forManga,
          moved.hide,
          moved.shouldUpdate,
        ),
        (110, ItemType.novel, false, true, false),
      );
      await tap(tester, find.byTooltip('Add Category'));
      await tester.enterText(find.byType(TextField), ' Novel draft ');
      await tester.pumpAndSettle();
      await tap(tester, find.widgetWithText(FilledButton, 'Add'));
      await tester.pumpAndSettle();
      expect(created.single.name, ' Novel draft ');
      expect(created.single.forItemType, ItemType.novel);
      layout.value = (2.5, 0);
      await tester.pumpAndSettle();
      await tap(
        tester,
        find.descendant(
          of: find.byType(NodeLaneSegments<ItemType>),
          matching: find.text('Manga'),
        ),
        delta: -250,
      );
      await tester.pumpAndSettle();
      expect(requests, [ItemType.novel, ItemType.manga]);
      expect(find.text('Novel first'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'category edits keep IDs and independent flags; failures refresh without repeating writes and deletion cancels',
    (tester) async {
      final original = Category(
        id: 3,
        clientId: 33,
        name: 'A category with a long name',
        forItemType: ItemType.novel,
        pos: 7,
        updatedAt: 5,
      )..forManga = false;
      var records = [original];
      final events = StreamController<List<Category>>.broadcast();
      addTearDown(events.close);
      var pending = Completer<void>();
      final writes = <Category>[];
      var removals = 0, reads = 0;
      final container = ProviderContainer(
        overrides: [
          getMangaCategorieStreamProvider(itemType: ItemType.novel)
              .overrideWith((ref) async* {
                reads++;
                yield records;
                yield* events.stream;
              }),
        ],
      );
      addTearDown(container.dispose);
      await start(
        tester,
        launcher((context) async {
          await Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder: (_) => MobileCategoryDetails(
                category: original,
                onSave: (next) async {
                  writes.add(next);
                  await pending.future;
                  records = [next];
                  events.add(records);
                },
                onRemove: (_) async {
                  removals++;
                },
              ),
            ),
          );
        }),
        container: container,
      );
      await tap(tester, find.text('Open'));
      Finder toggle(String label) => find.descendant(
        of: find.widgetWithText(NodeLaneRow, label),
        matching: find.byType(NodeLaneSwitch),
      );
      await reveal(tester, toggle('Show in library'));
      expect(
        tester.widget<NodeLaneSwitch>(toggle('Show in library')).value,
        isTrue,
      );
      expect(
        tester
            .widget<NodeLaneSwitch>(toggle('Include in library updates'))
            .value,
        isTrue,
      );
      await tap(tester, toggle('Show in library'));
      await tester.pageBack();
      await tester.pump();
      expect(find.byType(MobileCategoryDetails), findsOneWidget);
      expect(writes, hasLength(1));
      expect(original.hide, isNull);
      expect(
        (
          writes.single.id,
          writes.single.clientId,
          writes.single.forItemType,
          writes.single.forManga,
          writes.single.pos,
          writes.single.shouldUpdate,
        ),
        (3, 33, ItemType.novel, false, 7, null),
      );
      pending.completeError(StateError('save failed'));
      await tester.pumpAndSettle();
      await tap(tester, find.text('Retry'), delta: -250);
      expect(reads, 2);
      expect(writes, hasLength(1));
      pending = Completer<void>()..complete();
      await tap(tester, toggle('Include in library updates'));
      await tester.pumpAndSettle();
      expect(records.single.shouldUpdate, isFalse);
      expect(records.single.hide, isNull);
      await tap(tester, find.text('Rename Category'), delta: -250);
      await tester.enterText(find.byType(TextField), 'Renamed');
      records = [
        Category.fromJson(records.single.toJson())
          ..forManga = false
          ..pos = 9
          ..hide = true,
      ];
      events.add(records);
      await tester.pumpAndSettle();
      await tap(tester, find.widgetWithText(FilledButton, 'OK'));
      await tester.pumpAndSettle();
      expect(
        (
          records.single.name,
          records.single.pos,
          records.single.hide,
          records.single.shouldUpdate,
          records.single.clientId,
        ),
        ('Renamed', 9, true, false, 33),
      );
      expect(original.name, 'A category with a long name');
      await tap(tester, find.text('Delete Category'));
      await tap(tester, find.text('Cancel'));
      expect(removals, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'calendar retries, selects unbuilt dates, retains week focus and returns original entries',
    (tester) async {
      final now = DateTime.now();
      final month = DateTime(now.year, now.month);
      final books = List.generate(
        20,
        (i) =>
            Manga.fromJson({
                'id': i + 1,
                'name': 'Calendar title ${i + 1} with a long name',
                'favorite': true,
                'status': 0,
              })
              ..customCoverImage = List<int>.of(
                base64Decode(
                  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aX1cAAAAASUVORK5CYII=',
                ),
              ),
      );
      final items = <UpcomingUIModel>[
        for (var i = 0; i < books.length; i++) ...[
          UpcomingHeader(
            date: DateTime(month.year, month.month, i + 1),
            mangaCount: 1,
          ),
          UpcomingItem(
            manga: books[i],
            expectedDate: DateTime(month.year, month.month, i + 1),
          ),
        ],
      ];
      final state = ValueNotifier<AsyncValue<List<UpcomingUIModel>>>(
        const AsyncLoading(),
      );
      addTearDown(state.dispose);
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final opened = <Manga>[];
      var retries = 0;
      await start(
        tester,
        ValueListenableBuilder(
          valueListenable: state,
          builder: (context, value, _) => MobileCalendar(
            types: const [ItemType.manga],
            itemType: ItemType.manga,
            data: value,
            onTypeChanged: (_) => fail('Only one media is visible'),
            onRetry: () {
              retries++;
              state.value = AsyncData(items);
            },
            onOpen: (manga) {
              opened.add(manga);
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      Scaffold(appBar: AppBar(), body: Text(manga.name!)),
                ),
              );
            },
          ),
        ),
        container: container,
      );
      state.value = AsyncError(
        StateError('calendar query failed'),
        StackTrace.empty,
      );
      await tester.pumpAndSettle();
      await tap(tester, find.text('Retry'));
      expect(retries, 1);
      expect(find.byKey(const ValueKey('calendar-20')), findsNothing);
      await tap(tester, find.text('20'));
      await tap(tester, find.byKey(const ValueKey('calendar-20')));
      expect(opened.single, same(books[19]));
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tap(tester, find.widgetWithText(ChoiceChip, 'Week'), delta: -250);
      var table = tester.widget<TableCalendar>(
        find.byWidgetPredicate((widget) => widget is TableCalendar),
      );
      expect(table.calendarFormat, CalendarFormat.week);
      await tap(tester, find.byTooltip('Next page'));
      await tester.pumpAndSettle();
      table = tester.widget<TableCalendar>(
        find.byWidgetPredicate((widget) => widget is TableCalendar),
      );
      final selected = table.focusedDay.add(const Duration(days: 1));
      await tap(tester, find.text('${selected.day}'));
      state.value = AsyncData([...items]);
      await tester.pumpAndSettle();
      table = tester.widget<TableCalendar>(
        find.byWidgetPredicate((widget) => widget is TableCalendar),
      );
      expect(isSameDay(table.focusedDay, selected), isTrue);
      await tap(tester, find.text('Show all dates'));
      table = tester.widget<TableCalendar>(
        find.byWidgetPredicate((widget) => widget is TableCalendar),
      );
      expect(table.selectedDayPredicate!(selected), isFalse);
      await tap(
        tester,
        find.widgetWithText(ChoiceChip, '2 weeks'),
        delta: -250,
      );
      expect(
        tester
            .widget<TableCalendar>(
              find.byWidgetPredicate((widget) => widget is TableCalendar),
            )
            .calendarFormat,
        CalendarFormat.twoWeeks,
      );
      await tap(tester, find.widgetWithText(ChoiceChip, 'Month'));
      expect(
        tester
            .widget<TableCalendar>(
              find.byWidgetPredicate((widget) => widget is TableCalendar),
            )
            .calendarFormat,
        CalendarFormat.month,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
