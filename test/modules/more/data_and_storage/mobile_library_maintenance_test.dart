import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/delete_source.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/pre_import_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/mobile_library_action.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/mobile_library_choices.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/mobile_library_snapshots.dart';

void main() {
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
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(2.5),
          padding: const EdgeInsets.only(top: 24, bottom: 34),
        ),
        child: child!,
      ),
      home: home,
    );
    await tester.pumpWidget(
      container == null
          ? app
          : UncontrolledProviderScope(container: container, child: app),
    );
    await tester.pumpAndSettle();
  }

  Widget launcher(Future<void> Function(BuildContext) open) => Scaffold(
    body: Builder(
      builder: (context) =>
          TextButton(onPressed: () => open(context), child: const Text('Open')),
    ),
  );

  Future<void> tap(
    WidgetTester tester,
    Finder target, {
    double delta = 230,
  }) async {
    if (target.hitTestable().evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        target,
        delta,
        scrollable: find.byType(Scrollable).last,
      );
      await Scrollable.ensureVisible(tester.element(target), alignment: .5);
      await tester.pump(const Duration(milliseconds: 350));
    }
    await tester.tap(target);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  LibrarySourceGroup group({
    int? id,
    String? lang = 'en',
    ItemType type = ItemType.manga,
  }) => LibrarySourceGroup(
    sourceId: id,
    sourceName: 'Shared source',
    lang: lang,
    itemType: type,
    mangaCount: 3,
  );

  testWidgets(
    'source search keeps media, language and original source identity; back cancels',
    (tester) async {
      final english = group(id: 10);
      final french = group(id: 11, lang: 'fr');
      final anime = group(id: 12, type: ItemType.anime);
      var groups = [english, french, anime];
      final selections = <LibrarySourceGroup?>[];
      await start(
        tester,
        launcher((context) async {
          selections.add(
            await showMobileLibrarySourcePicker(
              context,
              groups: groups,
              title: 'Sources',
              description: null,
              emptyMessage: 'Nothing to maintain',
            ),
          );
        }),
      );
      await tap(tester, find.text('Open'));
      await tester.enterText(find.byType(TextField), 'fr');
      await tester.pumpAndSettle();
      expect(find.text('Shared source'), findsOneWidget);
      await tap(tester, find.text('Shared source'));
      expect(selections.single, same(french));
      await tap(tester, find.text('Open'));
      await tester.enterText(find.byType(TextField), 'Anime');
      await tester.pumpAndSettle();
      await tap(tester, find.text('Shared source'));
      expect(selections.last, same(anime));
      await tap(tester, find.text('Open'));
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(selections.last, isNull);
      groups = [];
      await tap(tester, find.text('Open'));
      expect(find.text('Nothing to maintain'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'delete options retain defaults, discard cancelled drafts, and omit absent extension',
    (tester) async {
      var source = group(id: 10);
      final choices = <LibraryDeleteChoices?>[];
      final counts = DeleteSourceCounts(
        mangaCount: 3,
        chapterCount: 52,
        historyCount: 7,
        updateCount: 2,
      );
      await start(
        tester,
        launcher((context) async {
          choices.add(
            await Navigator.push<LibraryDeleteChoices>(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    MobileDeleteSourceChoices(group: source, counts: counts),
              ),
            ),
          );
        }),
      );
      await tap(tester, find.text('Open'));
      Finder option(String name) => find.widgetWithText(SwitchListTile, name);
      await tester.scrollUntilVisible(option('Keep reading history'), 230);
      await tester.pumpAndSettle();
      expect(
        tester.widget<SwitchListTile>(option('Keep reading history')).value,
        isFalse,
      );
      expect(
        tester.widget<SwitchListTile>(option('Keep download records')).value,
        isFalse,
      );
      expect(
        tester
            .widget<SwitchListTile>(
              option('Also remove the installed extension'),
            )
            .value,
        isTrue,
      );
      await tap(tester, option('Keep reading history'));
      await tap(tester, option('Keep download records'));
      await tap(tester, option('Also remove the installed extension'));
      await tap(tester, find.text('Cancel'));
      expect(choices.single, isNull);
      await tap(tester, find.text('Open'));
      await tester.scrollUntilVisible(option('Keep reading history'), 230);
      await tester.pumpAndSettle();
      expect(
        tester.widget<SwitchListTile>(option('Keep reading history')).value,
        isFalse,
      );
      expect(
        tester
            .widget<SwitchListTile>(
              option('Also remove the installed extension'),
            )
            .value,
        isTrue,
      );
      await tap(tester, option('Keep reading history'));
      await tap(tester, find.widgetWithText(FilledButton, 'Delete'));
      expect(choices.last, (
        keepHistory: true,
        keepDownloads: false,
        removeExtension: true,
      ));
      source = group();
      await tap(tester, find.text('Open'));
      await tester.scrollUntilVisible(option('Keep reading history'), 230);
      await tester.pumpAndSettle();
      expect(option('Also remove the installed extension'), findsNothing);
      await tap(tester, find.widgetWithText(FilledButton, 'Delete'));
      expect(choices.last, (
        keepHistory: false,
        keepDownloads: false,
        removeExtension: false,
      ));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'primary selection starts from supplied order, cancels and returns the original manga',
    (tester) async {
      final first = Manga.fromJson({
        'id': 1,
        'name': 'Same title with a long name for a duplicate',
        'favorite': true,
        'status': 0,
      });
      final second = Manga.fromJson({
        'id': 2,
        'name': first.name,
        'favorite': true,
        'status': 0,
      });
      final chosen = <Manga?>[];
      await start(
        tester,
        launcher((context) async {
          chosen.add(
            await Navigator.push<Manga>(
              context,
              MaterialPageRoute(
                builder: (_) => MobileMergePrimary(
                  manga: [first, second],
                  chapterCounts: {1: 28, 2: 12},
                ),
              ),
            ),
          );
        }),
      );
      await tap(tester, find.text('Open'));
      expect(
        tester
            .widget<RadioGroup<Manga>>(find.byType(RadioGroup<Manga>))
            .groupValue,
        same(first),
      );
      await tap(tester, find.byKey(const ValueKey('merge-primary-2')));
      await tap(tester, find.text('Cancel'));
      expect(chosen.single, isNull);
      await tap(tester, find.text('Open'));
      expect(
        tester
            .widget<RadioGroup<Manga>>(find.byType(RadioGroup<Manga>))
            .groupValue,
        same(first),
      );
      await tap(tester, find.byKey(const ValueKey('merge-primary-2')));
      await tap(tester, find.byType(FilledButton));
      expect(chosen.last, same(second));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'snapshot loading failure retries; pending rollback blocks repeats/back and failure keeps records',
    (tester) async {
      var read = Completer<List<LibrarySafetySnapshot>>();
      final container = ProviderContainer(
        overrides: [
          lastLibrarySnapshotProvider.overrideWith((ref) => read.future),
        ],
      );
      addTearDown(container.dispose);
      var rollback = Completer<void>();
      final calls = <LibrarySafetySnapshot>[];
      final snapshot = LibrarySafetySnapshot(
        backupPath: '/fixture/snapshot',
        createdAt: 0,
        description: 'A complete description of a very long library change',
      );
      await start(
        tester,
        launcher((context) async {
          await Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder: (_) => MobileLibrarySnapshots(
                onRollback: (_, selected) {
                  calls.add(selected);
                  return rollback.future;
                },
              ),
            ),
          );
        }),
        container: container,
      );
      await tap(tester, find.text('Open'));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      read.completeError(StateError('unavailable'));
      await tester.pumpAndSettle();
      read = Completer<List<LibrarySafetySnapshot>>();
      await tap(tester, find.text('Retry'));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      read.complete([snapshot]);
      await tester.pumpAndSettle();
      final row = find.byKey(ValueKey(snapshot.backupPath));
      await tap(tester, row);
      await tester.tap(row, warnIfMissed: false);
      await tester.pageBack();
      await tester.pump();
      expect(find.byType(MobileLibrarySnapshots), findsOneWidget);
      expect(calls, [same(snapshot)]);
      rollback.completeError(StateError('restore failed'));
      await tester.pumpAndSettle();
      expect(find.text(snapshot.description), findsOneWidget);
      expect(find.text('Failed!'), findsOneWidget);
      rollback = Completer<void>();
      await tap(tester, row);
      expect(calls, hasLength(2));
      rollback.complete();
      await tester.pumpAndSettle();
      read = Completer<List<LibrarySafetySnapshot>>()..complete([]);
      container.invalidate(lastLibrarySnapshotProvider);
      await tester.pumpAndSettle();
      expect(find.text('No safety snapshots available.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'maintenance entry serializes its flow and releases the guard after failure',
    (tester) async {
      var operation = Completer<void>();
      var calls = 0;
      await start(
        tester,
        launcher((context) async {
          await Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(),
                body: MobileLibraryAction(
                  title: 'Maintain',
                  subtitle: 'Choices',
                  icon: Icons.library_books,
                  onOpen: () {
                    calls++;
                    return operation.future;
                  },
                ),
              ),
            ),
          );
        }),
      );
      await tap(tester, find.text('Open'));
      await tap(tester, find.text('Maintain'));
      await tester.tap(find.text('Maintain'), warnIfMissed: false);
      await tester.pageBack();
      await tester.pump();
      expect(calls, 1);
      expect(find.byType(MobileLibraryAction), findsOneWidget);
      operation.completeError(StateError('query failed'));
      await tester.pumpAndSettle();
      expect(find.text('Failed!'), findsOneWidget);
      operation = Completer<void>()..complete();
      await tap(tester, find.text('Maintain'));
      expect(calls, 2);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Open'), findsOneWidget);
    },
  );
}
