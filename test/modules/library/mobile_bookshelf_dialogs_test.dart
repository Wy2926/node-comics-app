// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/widgets/mobile_manga_import_dialog.dart';
import 'package:mangayomi/modules/widgets/category_selection_dialog.dart';
import 'package:mangayomi/modules/widgets/mobile_manga_category_dialog.dart';

Future<void> _open(
  WidgetTester tester,
  Widget body, {
  ValueChanged<Object?>? onClosed,
}) async {
  tester.view.physicalSize = const Size(360, 740);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      key: UniqueKey(),
      theme: ThemeData(platform: TargetPlatform.iOS),
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              final result = await showDialog<Object?>(
                context: context,
                barrierDismissible: false,
                builder: (_) => body,
              );
              onClosed?.call(result);
            },
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Category _category(
  int id, {
  bool hidden = false,
  ItemType type = ItemType.manga,
}) => Category(
  id: id,
  name: 'Category $id with its full name',
  forItemType: type,
  pos: id,
  hide: hidden,
);

void main() {
  testWidgets(
    'import cancellation allows another choice, while pending work blocks duplicates and back',
    (tester) async {
      var pending = Completer<int>();
      var calls = 0;
      Object? result;
      await _open(
        tester,
        MobileMangaImportDialog(
          onImport: () {
            calls++;
            return pending.future;
          },
        ),
        onClosed: (value) => result = value,
      );
      expect(find.text('ZIP · CBZ'), findsOneWidget);
      final choose = tester
          .widget<FilledButton>(find.byType(FilledButton))
          .onPressed!;
      final cancel = tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Cancel'))
          .onPressed!;
      choose();
      choose();
      cancel();
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(calls, 1);
      expect(find.byType(MobileMangaImportDialog), findsOneWidget);
      pending.complete(0);
      await tester.pumpAndSettle();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
      pending = Completer<int>();
      await tester.tap(find.text('Choose files'));
      expect(calls, 2);
      pending.complete(1);
      await tester.pumpAndSettle();
      expect(result, 1);
      expect(find.text('Open'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'an incomplete import only offers close and cannot run again from a stale callback',
    (tester) async {
      var calls = 0;
      await _open(
        tester,
        MobileMangaImportDialog(
          onImport: () async {
            calls++;
            throw StateError('fixture failure');
          },
        ),
      );
      final choose = tester
          .widget<FilledButton>(find.byType(FilledButton))
          .onPressed!;
      choose();
      await tester.pumpAndSettle();
      expect(find.textContaining('Import did not finish'), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
      choose();
      expect(calls, 1);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Open'), findsOneWidget);
    },
  );

  testWidgets(
    'bulk category draft includes unbuilt rows and failed writes cannot be repeated',
    (tester) async {
      final pending = Completer<void>();
      final writes = <List<int>>[];
      await _open(
        tester,
        MobileMangaCategoryDialog(
          categories: [
            for (var i = 1; i <= 40; i++) _category(i),
            _category(99, hidden: true),
          ],
          initialIds: [1, 40, 99, 404],
          bookCount: 6,
          isBulk: true,
          showHidden: false,
          loading: false,
          readFailed: false,
          onRetry: () {},
          onEdit: () {},
          onSave: (ids) {
            writes.add(ids);
            return pending.future;
          },
        ),
      );
      expect(find.text('Category 40 with its full name'), findsNothing);
      final save = tester
          .widget<FilledButton>(find.byType(FilledButton))
          .onPressed!;
      save();
      save();
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(writes, [
        [1, 40],
      ]);
      expect(find.byType(MobileMangaCategoryDialog), findsOneWidget);
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Cancel'))
            .onPressed,
        isNull,
      );
      pending.completeError(StateError('fixture write failure'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('could not be saved completely'),
        findsOneWidget,
      );
      save();
      expect(writes, hasLength(1));
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Open'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'category reads distinguish loading and failure, and cancel discards edits',
    (tester) async {
      var loading = true, failed = false;
      List<Category>? categories;
      late StateSetter change;
      var retries = 0, writes = 0;
      final initial = <int>[1];
      await _open(
        tester,
        StatefulBuilder(
          builder: (_, setState) {
            change = setState;
            return MobileMangaCategoryDialog(
              categories: categories,
              initialIds: initial,
              bookCount: 1,
              bookTitle: 'Comic A',
              isBulk: false,
              showHidden: false,
              loading: loading,
              readFailed: failed,
              onRetry: () {
                retries++;
                change(() {
                  failed = false;
                  categories = [_category(1), _category(2)];
                });
              },
              onEdit: () {},
              onSave: (_) async {
                writes++;
              },
            );
          },
        ),
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      change(() {
        loading = false;
        categories = [];
      });
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(CustomScrollView)).height,
        lessThan(300),
      );
      change(() {
        categories = null;
        failed = true;
      });
      await tester.pumpAndSettle();
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(retries, 1);
      await tester.tap(find.text('Category 2 with its full name'));
      await tester.pump();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(initial, [1]);
      expect(writes, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'single saved comics keep hidden categories and a new favorite may choose them',
    (tester) async {
      for (final adding in [false, true]) {
        List<int>? selected;
        await _open(
          tester,
          MobileMangaCategoryDialog(
            categories: [_category(1), _category(2, hidden: true)],
            initialIds: adding ? [] : [1, 2, 404],
            bookCount: 1,
            bookTitle: 'Comic A',
            isBulk: false,
            showHidden: adding,
            loading: false,
            readFailed: false,
            onRetry: () {},
            onEdit: () {},
            onSave: (ids) async {
              selected = ids;
            },
          ),
        );
        if (adding) {
          await tester.tap(find.text('Category 2 with its full name'));
          await tester.pump();
        } else {
          expect(find.text('Category 2 with its full name'), findsNothing);
          expect(
            find.textContaining('hidden categories are kept'),
            findsOneWidget,
          );
        }
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(selected, adding ? [2] : [1, 2]);
        expect(find.text('Open'), findsOneWidget);
      }
    },
  );

  test('category writes preserve current metadata, avoid model mutation, and reuse favorite rules', () async {
    await Isar.initializeIsarCore(download: true);
    final root = await Directory.systemTemp.createTemp(
      'nodelane-category-dialog-',
    );
    Isar? database;
    try {
      database = await Isar.open(
        [MangaSchema, ChapterSchema, CategorySchema],
        directory: root.path,
        name: 'category_dialog',
      );
      app.isar = database;
      Manga book(int id, {bool favorite = true}) => Manga(
        id: id,
        source: 'fixture',
        author: '',
        artist: '',
        genre: [],
        imageUrl: '',
        lang: 'en',
        link: '',
        name: 'Comic $id',
        status: Status.unknown,
        description: 'Original metadata',
        sourceId: null,
        favorite: favorite,
        dateAdded: 100,
        categories: [2],
        isManga: true,
        customCoverFromTracker: 'fixture-cover',
      );
      final first = book(1),
          second = book(2),
          adding = book(3, favorite: false);
      database.writeTxnSync(() {
        database!.categorys.putAllSync([
          _category(1),
          _category(2, hidden: true),
          _category(3, type: ItemType.novel),
        ]);
        database.mangas.putAllSync([first, second, adding]);
        database.mangas.putSync(
          database.mangas.getSync(1)!..name = 'Updated elsewhere',
        );
      });
      await saveMobileMangaCategories(
        targets: [first, second],
        categoryIds: [1, 2, 3, 404],
        isBulk: true,
        isFavorite: false,
      );
      final saved = database.mangas.getSync(1)!;
      expect(saved.categories, [1]);
      expect(database.mangas.getSync(2)!.categories, [1]);
      expect(saved.name, 'Updated elsewhere');
      expect(saved.customCoverFromTracker, 'fixture-cover');
      expect(saved.isManga, true);
      expect(saved.dateAdded, 100);
      expect(first.categories, [2]);
      await saveMobileMangaCategories(
        targets: [first],
        categoryIds: [2],
        isBulk: false,
        isFavorite: true,
      );
      expect(database.mangas.getSync(1)!.categories, [2]);
      await saveMobileMangaCategories(
        targets: [adding],
        categoryIds: [],
        isBulk: false,
        isFavorite: false,
      );
      expect(database.mangas.getSync(3)!.favorite, true);
      expect(database.mangas.getSync(3)!.dateAdded, greaterThan(100));
      expect(adding.favorite, false);
    } finally {
      await database?.close(deleteFromDisk: true);
      await root.delete(recursive: true);
    }
  });
}
