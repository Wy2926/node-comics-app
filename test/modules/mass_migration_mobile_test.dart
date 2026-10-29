import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/mass_migration/mass_migration_destination_screen.dart';
import 'package:mangayomi/modules/mass_migration/mass_migration_preview_screen.dart';
import 'package:mangayomi/modules/mass_migration/mass_migration_runner_screen.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mobile_mass_migration.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/headers.dart';

Manga book(int id) => Manga(
  id: id,
  name: 'Book $id',
  author: 'Author',
  artist: '',
  description: '',
  imageUrl: '',
  source: 'Source A',
  sourceId: 10,
  genre: [],
  lang: 'en',
  link: '/book/$id',
  status: Status.unknown,
  customCoverImage: base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
  ),
);
final destination = Source(id: 20, name: 'Source B', lang: 'en');
MassMigrationSourceGroup sourceGroup(List<Manga> items) =>
    MassMigrationSourceGroup(
      sourceName: 'Source A',
      itemType: ItemType.manga,
      items: items,
      sourceId: 10,
      lang: 'en',
    );

void main() {
  late Isar database;
  late Directory directory;
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    directory = await Directory.systemTemp.createTemp('nodelane-mass-test-');
    database = await Isar.open(
      [SettingsSchema, SourceSchema, TrackSchema, MangaSchema, ChapterSchema],
      directory: directory.path,
      name: 'mass_test',
    );
    app.isar = database;
    database.writeTxnSync(() => database.settings.putSync(Settings(id: 227)));
  });
  tearDownAll(() async {
    await database.close(deleteFromDisk: true);
    await directory.delete(recursive: true);
  });

  Future<void> mount(
    WidgetTester tester,
    Widget child, {
    bool owner = false,
    List<Override> overrides = const [],
  }) async {
    tester.view.physicalSize = owner
        ? const Size(900, 900)
        : const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          headersProvider.overrideWith((ref, args) => {}),
          ...overrides,
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          ),
          home: child,
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets(
    'selection keeps book and chapter actions separate and bounds chapter previews',
    (tester) async {
      final item = book(1);
      database.writeTxnSync(() {
        database.mangas.putSync(item);
        final chapters = List.generate(
          20,
          (i) => Chapter(mangaId: 1, name: 'Chapter $i'),
        );
        database.chapters.putAllSync(chapters);
        item.chapters.addAll(chapters);
        item.chapters.saveSync();
      });
      var toggles = 0, ranges = 0;
      await mount(
        tester,
        MobileBrowsePage(
          title: 'Select books',
          body: ListView(
            children: [
              MobileMassMigrationSelectionCard(
                item: item,
                source: null,
                selected: true,
                onToggle: () => toggles++,
                onSelectRange: () => ranges++,
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.text('Book 1'));
      await tester.longPress(find.text('Book 1'));
      expect((toggles, ranges), (1, 1));
      expect(item.chapters.length, 20);
      await tester.tap(find.text('Source chapters (20)'));
      await tester.pumpAndSettle();
      expect((toggles, ranges), (1, 1));
      expect(find.text('Chapter 11'), findsOneWidget);
      expect(find.text('Chapter 12'), findsNothing);
      expect(find.text('And 8 more...'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'match controls reflect readiness and loading without mixing book identities',
    (tester) async {
      final candidate = MManga(
        name: 'A destination title that needs several readable lines',
        link: '/target',
      );
      final item = MassMigrationResolvedItem(
        sourceItem: book(2),
        searchResult: MassMigrationSearchResult(
          queries: ['Book 2'],
          candidates: [candidate],
        ),
        selectedCandidate: candidate,
        errorMessage: 'Read interrupted',
      );
      final selected = <bool>[];
      var choices = 0;
      Future<void> show(MassMigrationResolvedItem value, bool loading) => mount(
        tester,
        MobileBrowsePage(
          title: 'Review',
          body: ListView(
            children: [
              MobileMassMigrationMatchCard(
                item: value,
                source: null,
                destination: destination,
                loading: loading,
                onSelect: selected.add,
                onChoose: () => choices++,
              ),
            ],
          ),
        ),
      );
      await show(item, false);
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Migrate'))
            .onSelected,
        isNull,
      );
      await tester.tap(find.text('Retry'));
      expect(choices, 1);
      final ready = item.copyWith(
        destinationPreview: MManga(chapters: [MChapter(name: 'New chapter')]),
        shouldMigrate: true,
        keepErrorMessage: false,
      );
      await show(ready, false);
      await tester.tap(find.widgetWithText(ChoiceChip, 'Skip'));
      expect(selected, [false]);
      await show(ready, true);
      expect(
        tester
            .widget<TextButton>(
              find.widgetWithText(TextButton, 'Choose another result'),
            )
            .onPressed,
        isNull,
      );
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Skip'))
            .onSelected,
        isNull,
      );
      expect(find.text('Book 2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'progress counts completed work and summary keeps exit reachable with a lazy failure list',
    (tester) async {
      await mount(
        tester,
        const MobileBrowsePage(
          title: 'Progress',
          body: MobileMassMigrationProgress(
            heading: 'Matching source',
            progressLabel: 'Working 1 of 3',
            completed: 0,
            total: 3,
            current: Text('Original title'),
            destination: Text('Target title'),
          ),
        ),
      );
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        0,
      );
      var exits = 0;
      await mount(
        tester,
        MobileBrowsePage(
          title: 'Result',
          body: MobileMassMigrationSummary(
            route: 'Source A → Source B',
            total: 100,
            matched: 100,
            migrated: 0,
            skipped: 0,
            failures: List.generate(100, (i) => 'Failed book $i'),
          ),
          bottomAction: FilledButton(
            onPressed: () => exits++,
            child: const Text('Exit'),
          ),
        ),
      );
      expect(
        find.textContaining('Some changes may have been saved'),
        findsOneWidget,
      );
      expect(find.text('Failed book 99'), findsNothing);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Exit'));
      expect(exits, 1);
      await mount(
        tester,
        const MobileBrowsePage(
          title: 'Result',
          body: MobileMassMigrationSummary(
            route: 'A → B',
            total: 3,
            matched: 2,
            migrated: 0,
            skipped: 3,
            failures: [],
          ),
        ),
      );
      expect(find.text('No items selected for migration.'), findsOneWidget);
      expect(
        find.text('All selected items were processed successfully.'),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  group('original selection and runner owners', () {
    testWidgets(
      'range and individual selection pass only the original selected objects to destination',
      (tester) async {
        final items = [book(1), book(2), book(3)];
        await mount(
          tester,
          MassMigrationPreviewScreen(sourceGroup: sourceGroup(items)),
          owner: true,
        );
        await tester.tap(find.text('Deselect all'));
        await tester.pump();
        expect(
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Select destination source'),
              )
              .onPressed,
          isNull,
        );
        await tester.tap(find.text('Book 1'));
        await tester.longPress(find.text('Book 3'));
        await tester.pump();
        await tester.tap(find.text('Book 2'));
        await tester.pump();
        await tester.tap(
          find.widgetWithText(FilledButton, 'Select destination source'),
        );
        await tester.pumpAndSettle();
        final filtered = tester
            .widget<MassMigrationDestinationScreen>(
              find.byType(MassMigrationDestinationScreen),
            )
            .sourceGroup;
        expect(filtered.items, [items.first, items.last]);
        expect(filtered.sourceId, 10);
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.textContaining('2/3 selected'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );

    testWidgets(
      'candidate reads block stale starts, retry explicitly, and all-skipped review finishes without writes',
      (tester) async {
        final pending = Completer<MManga>();
        final first = MManga(name: 'Book 1', link: '/first');
        final second = MManga(name: 'Alternative', link: '/second');
        var secondReads = 0;
        await mount(
          tester,
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MassMigrationRunnerScreen(
                      sourceGroup: sourceGroup([book(1)]),
                      destinationSource: destination,
                    ),
                  ),
                ),
                child: const Text('Open runner'),
              ),
            ),
          ),
          owner: true,
          overrides: [
            searchProvider.overrideWith(
              (ref, args) async =>
                  MPages(list: [first, second], hasNextPage: false),
            ),
            getDetailProvider.overrideWith((ref, args) {
              if (args.url == '/second' && ++secondReads == 1) {
                return pending.future;
              }
              return Future.value(MManga(chapters: []));
            }),
          ],
        );
        await tester.tap(find.text('Open runner'));
        await tester.pumpAndSettle();
        final staleStart = tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Migrate selected items (1)'),
            )
            .onPressed!;
        await tester.tap(find.text('Choose another result'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Alternative').last);
        await tester.pump(const Duration(milliseconds: 400));
        expect(
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Migrate selected items (1)'),
              )
              .onPressed,
          isNull,
        );
        staleStart();
        await tester.pump();
        expect(find.text('Migrating item 1 of 1'), findsNothing);
        pending.completeError(StateError('Detail unavailable'));
        await tester.pumpAndSettle();
        expect(find.textContaining('Detail unavailable'), findsOneWidget);
        expect(
          find.widgetWithText(FilledButton, 'Finish review'),
          findsOneWidget,
        );
        await tester.tap(find.text('Choose another result'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Alternative').last);
        await tester.pumpAndSettle();
        expect(secondReads, 2);
        expect(
          find.widgetWithText(FilledButton, 'Migrate selected items (1)'),
          findsOneWidget,
        );
        await tester.tap(find.widgetWithText(ChoiceChip, 'Skip'));
        await tester.pump();
        final finish = tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Finish review'),
            )
            .onPressed!;
        finish();
        finish();
        await tester.pumpAndSettle();
        expect(find.text('Mass migration complete'), findsOneWidget);
        await tester.tap(find.text('Exit Mass Migration'));
        await tester.pumpAndSettle();
        expect(find.text('Open runner'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );

    testWidgets(
      'leaving matching stops the next book after the in-flight request finishes',
      (tester) async {
        final pending = Completer<MPages?>();
        final queries = <String>[];
        await mount(
          tester,
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MassMigrationRunnerScreen(
                      sourceGroup: sourceGroup([book(1), book(2)]),
                      destinationSource: destination,
                    ),
                  ),
                ),
                child: const Text('Open runner'),
              ),
            ),
          ),
          owner: true,
          overrides: [
            searchProvider.overrideWith((ref, args) {
              queries.add(args.query);
              return pending.future;
            }),
          ],
        );
        await tester.tap(find.text('Open runner'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pageBack();
        await tester.pumpAndSettle();
        pending.complete(MPages(list: [], hasNextPage: false));
        await tester.pump(const Duration(seconds: 3));
        expect(queries, ['Book 1']);
        expect(find.text('Open runner'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  });
}
