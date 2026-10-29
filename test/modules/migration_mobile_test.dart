import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/widgets/migrate_screen.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_migration.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/source_fetch_gate.dart';

Manga _book() => Manga(
  name: 'Seed',
  author: null,
  artist: '',
  description: '',
  imageUrl: '',
  source: 'Original',
  sourceId: 12,
  genre: [],
  lang: 'en',
  link: '/seed',
  status: Status.unknown,
);

void main() {
  Future<void> mount(
    WidgetTester tester,
    Widget child, {
    double inset = 0,
  }) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
            viewInsets: EdgeInsets.only(bottom: inset),
            padding: const EdgeInsets.only(top: 24, bottom: 34),
          ),
          child: child!,
        ),
        home: child,
      ),
    );
    await tester.pump();
  }

  MobileMigrationPreviewPage preview({
    required Future<MManga> Function() load,
    required Future<void> Function(MManga, List<int>) confirm,
    Stream<List<Category>> Function()? categories,
    Future<void> Function()? edit,
  }) => MobileMigrationPreviewPage(
    oldTitle: 'Original book',
    oldSource: 'Source A',
    targetTitle: 'Selected book',
    targetSource: 'Source B · English',
    loadPreview: load,
    onConfirm: confirm,
    formatDate: (value) => throw const FormatException('invalid date'),
    watchCategories: categories,
    onEditCategories: edit,
  );

  testWidgets(
    'migration search keeps a draft, clears explicitly and builds a finite source viewport with keyboard',
    (tester) async {
      final input = TextEditingController(text: 'Seed');
      addTearDown(input.dispose);
      var query = 'Seed', built = 0;
      final submitted = <String>[];
      await mount(
        tester,
        StatefulBuilder(
          builder: (context, setState) => MobileMigrationSearchPage(
            title: 'Migrate',
            subject: 'Original book · Source A',
            query: query,
            controller: input,
            onSubmit: () {
              submitted.add(input.text);
              setState(() => query = input.text);
            },
            onClear: () {
              input.clear();
              setState(() => query = '');
            },
            sourceCount: 80,
            sourceBuilder: (_, i) {
              built++;
              return SizedBox(height: 180, child: Text('Source $i'));
            },
          ),
        ),
        inset: 260,
      );
      await tester.enterText(find.byType(TextField), 'Draft');
      await tester.pump();
      expect(submitted, isEmpty);
      expect(find.text('Results for “Seed”'), findsOneWidget);
      expect(built, lessThan(12));
      await tester.tap(find.byTooltip('Search...'));
      await tester.pump();
      expect(submitted, ['Draft']);
      expect(find.text('Results for “Draft”'), findsOneWidget);
      await tester.tap(find.byTooltip('Reset'));
      await tester.pump();
      expect(input.text, isEmpty);
      expect(find.text('Search for the destination title.'), findsOneWidget);
      expect(find.text('Source 0'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'preview retries reads, shows chapter metadata and ignores a cancelled late read without submitting',
    (tester) async {
      final lateRead = Completer<MManga>();
      var reads = 0, writes = 0;
      await mount(
        tester,
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => preview(
                    load: () async {
                      reads++;
                      if (reads == 1) throw StateError('Read failed');
                      if (reads == 2) {
                        return MManga(
                          chapters: [
                            MChapter(
                              name: 'Chapter with a readable title',
                              dateUpload: 'date not provided',
                              scanlator: 'A scanlator with a long name',
                            ),
                          ],
                        );
                      }
                      return lateRead.future;
                    },
                    confirm: (_, _) async => writes++,
                  ),
                ),
              ),
              child: const Text('Open preview'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open preview'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Read failed'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Migrate'))
            .onPressed,
        isNull,
      );
      final retry = tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Retry'))
          .onPressed!;
      retry();
      retry();
      await tester.pumpAndSettle();
      expect(reads, 2);
      expect(find.text('Chapter with a readable title'), findsOneWidget);
      expect(
        find.text('date not provided · A scanlator with a long name'),
        findsOneWidget,
      );
      expect(writes, 0);
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open preview'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
      lateRead.completeError(StateError('Cancelled read failed late'));
      await tester.pumpAndSettle();
      expect(writes, 0);
      expect(find.text('Open preview'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'confirmation submits once, blocks back while busy and does not retry a possibly partial write',
    (tester) async {
      final pending = Completer<void>();
      var writes = 0;
      MigrationPreviewOutcome? result;
      await mount(
        tester,
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => preview(
                      load: () async => MManga(
                        chapters: List.generate(
                          60,
                          (i) => MChapter(name: 'Chapter $i'),
                        ),
                      ),
                      confirm: (_, _) {
                        writes++;
                        return pending.future;
                      },
                    ),
                  ),
                );
              },
              child: const Text('Open preview'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open preview'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -1200));
      await tester.pumpAndSettle();
      final confirm = find.widgetWithText(FilledButton, 'Migrate');
      await tester.tap(confirm);
      await tester.tap(confirm);
      await tester.pump();
      expect(writes, 1);
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.byType(MobileMigrationPreviewPage), findsOneWidget);
      pending.completeError(StateError('Write interrupted'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Some changes may have been saved').hitTestable(),
        findsOneWidget,
      );
      expect(find.widgetWithText(FilledButton, 'Migrate'), findsNothing);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsNothing);
      await tester.tap(find.widgetWithText(FilledButton, 'Close'));
      await tester.pumpAndSettle();
      expect(result, MigrationPreviewOutcome.failed);
      expect(writes, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'tracker preview keeps one category stream and submits only still-existing selections',
    (tester) async {
      final categories = StreamController<List<Category>>.broadcast();
      addTearDown(categories.close);
      var watches = 0, edits = 0;
      List<int>? selected;
      MigrationPreviewOutcome? result;
      final detail = MManga(chapters: []);
      await mount(
        tester,
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => preview(
                      load: () async => detail,
                      categories: () {
                        watches++;
                        return categories.stream;
                      },
                      edit: () async => edits++,
                      confirm: (value, ids) async {
                        expect(identical(value, detail), isTrue);
                        selected = ids;
                      },
                    ),
                  ),
                );
              },
              child: const Text('Open preview'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open preview'));
      await tester.pump();
      categories.add([
        Category(id: 10, name: 'Adventure', forItemType: ItemType.manga),
      ]);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Adventure'));
      await tester.pump();
      await tester.tap(find.widgetWithText(TextButton, 'Edit'));
      expect(edits, 1);
      categories.add([
        Category(id: 20, name: 'Evening reading', forItemType: ItemType.manga),
      ]);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Evening reading'));
      await tester.pump();
      expect(watches, 1);
      await tester.tap(
        find.widgetWithText(FilledButton, 'Add to local library'),
      );
      await tester.pumpAndSettle();
      expect(selected, [20]);
      expect(result, MigrationPreviewOutcome.completed);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a disposed migration row releases its queued slot without starting a source request',
    (tester) async {
      final gate = FetchGate(1);
      await gate.acquire();
      var calls = 0;
      await mount(
        tester,
        ProviderScope(
          overrides: [
            searchProvider.overrideWith((ref, args) async {
              calls++;
              return null;
            }),
          ],
          child: Scaffold(
            body: MigrationSourceSearchScreen(
              query: 'Seed',
              manga: _book(),
              source: Source(id: 2, name: 'Source B', lang: 'en'),
              fetchGate: gate,
            ),
          ),
        ),
      );
      await tester.pumpWidget(const SizedBox());
      gate.release();
      await tester.pump();
      var available = false;
      final acquired = gate.acquire().then((_) => available = true);
      await tester.pump();
      expect(available, true);
      await acquired;
      gate.release();
      expect(calls, 0);
      expect(tester.takeException(), isNull);
    },
  );

  group('original migration search owner', () {
    late Isar database;
    late Directory directory;
    setUpAll(() async {
      await Isar.initializeIsarCore(download: true);
      directory = await Directory.systemTemp.createTemp(
        'nodelane-migration-test-',
      );
      database = await Isar.open(
        [SettingsSchema, SourceSchema],
        directory: directory.path,
        name: 'migration_test',
      );
      app.isar = database;
      database.writeTxnSync(() {
        database.settings.putSync(
          Settings(id: 227, onlyIncludePinnedSources: false),
        );
        database.sources.putSync(
          Source(
            id: 1,
            name: 'Source B',
            lang: 'en',
            isAdded: true,
            isActive: true,
          ),
        );
      });
    });
    tearDownAll(() async {
      await database.close(deleteFromDisk: true);
      await directory.delete(recursive: true);
    });

    testWidgets(
      'name-only seed searches once and clearing never restores it or submits an intermediate query',
      (tester) async {
        final old = Completer<MPages?>();
        final calls = <String>[];
        await mount(
          tester,
          ProviderScope(
            overrides: [
              searchProvider.overrideWith((ref, args) {
                calls.add(args.query);
                return args.query == 'Seed' ? old.future : Future.value(null);
              }),
            ],
            child: MigrationScreen(manga: _book()),
          ),
        );
        await tester.pump();
        expect(calls, ['Seed']);
        var field = tester.widget<SeachFormTextField>(
          find.byType(SeachFormTextField),
        );
        field.onSuffixPressed();
        await tester.pump();
        expect(find.byType(MigrationSourceSearchScreen), findsNothing);
        old.completeError(StateError('Old source failure'));
        await tester.pump();
        expect(calls, ['Seed']);
        await tester.enterText(find.byType(TextFormField), 'New');
        await tester.pump();
        expect(calls, ['Seed']);
        field = tester.widget<SeachFormTextField>(
          find.byType(SeachFormTextField),
        );
        field.onFieldSubmitted!('New');
        await tester.pumpAndSettle();
        expect(calls, ['Seed', 'New']);
        expect(find.text('No result'), findsOneWidget);
        field.onFieldSubmitted!('New');
        await tester.pump();
        expect(calls, ['Seed', 'New']);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  });
}
