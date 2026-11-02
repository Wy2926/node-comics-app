import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/global_search/global_search_screen.dart';
import 'package:mangayomi/modules/browse/global_search/mobile_global_search.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/services/get_popular.dart';
import 'package:mangayomi/services/search.dart';

void main() {
  Future<void> mount(
    WidgetTester tester,
    Widget child, {
    bool owner = false,
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
            textScaler: TextScaler.linear(owner ? 1 : 2.5),
            padding: const EdgeInsets.only(top: 24, bottom: 34),
            viewInsets: EdgeInsets.only(bottom: inset),
          ),
          child: child!,
        ),
        home: child,
      ),
    );
    await tester.pump();
  }

  testWidgets(
    'mobile search separates draft and submission and keeps empty action reachable with keyboard',
    (tester) async {
      final controller = TextEditingController(text: 'Original');
      addTearDown(controller.dispose);
      final submitted = <String>[];
      var actions = 0;
      await mount(
        tester,
        MobileGlobalSearchPage(
          controller: controller,
          onSubmit: () => submitted.add(controller.text),
          onClear: controller.clear,
          scope: 'Manga · 0 sources',
          query: 'Original',
          results: MobileGlobalSearchEmpty(
            message: 'No manga sources are installed.',
            hint: 'Add a repository, then install an extension for it.',
            actionLabel: 'Show extensions',
            onAction: () => actions++,
          ),
        ),
        inset: 260,
      );
      await tester.enterText(find.byType(TextField), 'Draft');
      await tester.pump();
      expect(submitted, isEmpty);
      expect(find.byKey(const ValueKey('Original')), findsOneWidget);
      final submit = find.byTooltip('Global search');
      expect(submit.hitTestable(), findsOneWidget);
      await tester.tap(submit);
      expect(submitted, ['Draft']);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      expect(submitted, ['Draft', 'Draft']);
      await tester.tap(find.byTooltip('Reset'));
      await tester.pump();
      expect(controller.text, isEmpty);
      final action = find.widgetWithText(FilledButton, 'Show extensions');
      await tester.scrollUntilVisible(
        action,
        160,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      expect(action.hitTestable(), findsOneWidget);
      expect(submit.hitTestable(), findsOneWidget);
      await tester.tap(action);
      expect(actions, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'mobile source header wraps and result actions stay independent across horizontal scrolling',
    (tester) async {
      final opened = <int>[], added = <int>[];
      var sourceOpened = 0;
      await mount(
        tester,
        Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: MobileGlobalSourceSection(
                title: 'A source with a long name that must wrap completely',
                language: 'English',
                onOpen: () => sourceOpened++,
                loading: false,
                count: 6,
                itemBuilder: (context, index) => MobileGlobalResultCard(
                  title: 'Result $index with a long title',
                  cover: const ColoredBox(color: Colors.blueGrey),
                  inLibrary: index == 0,
                  onOpen: () => opened.add(index),
                  onQuickAdd: () => added.add(index),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(
        find.text('A source with a long name that must wrap completely'),
      );
      expect(sourceOpened, 1);
      final first = find.byType(MobileGlobalResultCard).first;
      await tester.ensureVisible(first);
      await tester.pumpAndSettle();
      await tester.tap(first);
      await tester.longPress(first);
      expect(opened, [0]);
      expect(added, [0]);
      await tester.drag(find.byType(ListView), const Offset(-600, 0));
      await tester.pumpAndSettle();
      expect(
        find.text('Result 0 with a long title').hitTestable(),
        findsNothing,
      );
      expect(sourceOpened, 1);
      expect(tester.takeException(), isNull);
    },
  );

  test(
    'gate transfers a slot to queued work before admitting a new request',
    () async {
      final gate = FetchGate(1);
      await gate.acquire();
      var queuedEntered = false, newestEntered = false;
      final queued = gate.acquire().then((_) => queuedEntered = true);
      gate.release();
      final newest = gate.acquire().then((_) => newestEntered = true);
      await queued;
      expect(queuedEntered, isTrue);
      expect(newestEntered, isFalse);
      gate.release();
      await newest;
      expect(newestEntered, isTrue);
      gate.release();
    },
  );

  testWidgets(
    'disposed queued source releases its slot without starting a provider request',
    (tester) async {
      final gate = FetchGate(1);
      await gate.acquire();
      var requests = 0;
      await mount(
        tester,
        ProviderScope(
          overrides: [
            searchProvider.overrideWith((ref, args) async {
              requests++;
              return MPages(list: []);
            }),
          ],
          child: Scaffold(
            body: SourceSearchScreen(
              query: 'Queued',
              source: Source(id: 1, name: 'Sample', lang: 'en'),
              fetchGate: gate,
            ),
          ),
        ),
        owner: true,
      );
      await tester.pumpWidget(const SizedBox());
      gate.release();
      await tester.pump();
      expect(requests, 0);
      var acquired = false;
      unawaited(gate.acquire().then((_) => acquired = true));
      await tester.pump();
      expect(acquired, isTrue);
      gate.release();
      expect(tester.takeException(), isNull);
    },
  );

  group('query owner', () {
    late Directory directory;
    late Isar database;
    setUpAll(() async {
      await Isar.initializeIsarCore(download: true);
      directory = await Directory.systemTemp.createTemp(
        'nodelane-global-search-test-',
      );
      database = await Isar.open(
        [SourceSchema, SettingsSchema],
        directory: directory.path,
        name: 'global_search_test',
      );
      app.isar = database;
      database.writeTxnSync(() {
        database.settings.putSync(
          Settings(id: 227, onlyIncludePinnedSources: false, showNSFW: false),
        );
        database.sources.putSync(
          Source(
            id: 101,
            name: 'Sample source',
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
      'clear waits for a query and a new submission discards old failures without fetching popular',
      (tester) async {
        final calls = <String>[];
        final seed = Completer<MPages?>(), next = Completer<MPages?>();
        await mount(
          tester,
          ProviderScope(
            overrides: [
              searchProvider.overrideWith((ref, args) {
                calls.add(args.query);
                return args.query == 'Seed' ? seed.future : next.future;
              }),
              getPopularProvider.overrideWith((ref, args) async {
                calls.add('popular');
                return MPages(list: []);
              }),
            ],
            child: const GlobalSearchScreen(
              search: 'Seed',
              itemType: ItemType.manga,
            ),
          ),
          owner: true,
        );
        await tester.pump();
        expect(calls, ['Seed']);
        final field = tester.widget<SeachFormTextField>(
          find.byType(SeachFormTextField),
        );
        field.onSuffixPressed();
        await tester.pump();
        await tester.pump();
        expect(field.controller.text, isEmpty);
        expect(calls, ['Seed']);
        expect(find.byType(GlobalSearchPrompt), findsOneWidget);
        expect(find.text('1 source with no results'), findsNothing);
        await tester.enterText(find.byType(TextFormField), '  Next  ');
        await tester.pump();
        expect(calls, ['Seed']);
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pump();
        await tester.pump();
        expect(calls, ['Seed', 'Next']);
        expect(field.controller.text, 'Next');
        seed.completeError(StateError('old query failure'));
        await tester.pump();
        expect(find.text('1 source with no results'), findsNothing);
        next.complete(MPages(list: []));
        await tester.pumpAndSettle();
        expect(find.text('1 source with no results'), findsOneWidget);
        field.onFieldSubmitted!(' Next ');
        await tester.pump();
        expect(calls, ['Seed', 'Next']);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );

    testWidgets('an empty query never starts source requests', (tester) async {
      var requests = 0;
      await mount(
        tester,
        ProviderScope(
          overrides: [
            searchProvider.overrideWith((ref, args) async {
              requests++;
              return MPages(list: []);
            }),
            getPopularProvider.overrideWith((ref, args) async {
              requests++;
              return MPages(list: []);
            }),
          ],
          child: const GlobalSearchScreen(
            search: '   ',
            itemType: ItemType.manga,
          ),
        ),
        owner: true,
      );
      await tester.pumpAndSettle();
      expect(requests, 0);
      expect(find.byType(GlobalSearchPrompt), findsOneWidget);
      expect(find.byType(SourceSearchScreen), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });
  });
}
