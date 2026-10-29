// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/detail/chapter_bulk_actions.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_chapter_actions.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(platform: TargetPlatform.iOS),
  locale: const Locale('en'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);
void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(320, 740);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> _dialog(
  WidgetTester tester, {
  required bool local,
  required Future<void> Function() onDelete,
  ValueChanged<bool?>? onClosed,
}) async {
  _phone(tester);
  await tester.pumpWidget(
    _app(
      Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            final result = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (_) => MobileChapterDeleteDialog(
                bookTitle: 'Comic A — the complete collection',
                titles: List.generate(25, (index) => 'Chapter ${index + 1}'),
                localArchive: local,
                lastChapters: true,
                onDelete: onDelete,
              ),
            );
            onClosed?.call(result);
          },
          child: const Text('Open'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'named actions reflect selection, stay above safe area, and disable while busy',
    (tester) async {
      _phone(tester);
      var visible = true, busy = false, following = true, download = true;
      var selected = [Chapter(id: 1, mangaId: 1, name: 'One')];
      late StateSetter change;
      final actions = <MobileChapterAction>[];
      await tester.pumpWidget(
        _app(
          StatefulBuilder(
            builder: (context, setState) {
              change = setState;
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(viewPadding: const EdgeInsets.only(bottom: 34)),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MobileChapterSelectionBar(
                    selected: selected,
                    visible: visible,
                    busy: busy,
                    hasFollowing: following,
                    canDownload: download,
                    canDelete: !download,
                    onAction: actions.add,
                  ),
                ),
              );
            },
          ),
        ),
      );
      for (final text in ['Bookmark', 'Mark read', 'Read below', 'Download']) {
        await tester.tap(find.text(text));
        expect(tester.getBottomRight(find.text(text)).dy, lessThan(706));
      }
      expect(actions, [
        MobileChapterAction.bookmark,
        MobileChapterAction.read,
        MobileChapterAction.readFollowing,
        MobileChapterAction.download,
      ]);
      change(() {
        selected = [
          Chapter(
            id: 1,
            mangaId: 1,
            name: 'One',
            isRead: true,
            isBookmarked: true,
          ),
        ];
        following = false;
        download = false;
      });
      await tester.pump();
      expect(find.text('Unbookmark'), findsOneWidget);
      expect(find.text('Mark unread'), findsOneWidget);
      expect(find.text('Read below'), findsNothing);
      await tester.tap(find.text('Delete'));
      expect(actions.last, MobileChapterAction.delete);
      change(() {
        selected = [...selected, Chapter(id: 2, mangaId: 1, name: 'Two')];
        busy = true;
      });
      await tester.pump();
      expect(find.text('Toggle bookmark'), findsOneWidget);
      expect(find.text('Mark read'), findsOneWidget);
      expect(
        tester
            .widgetList<ElevatedButton>(find.byType(ElevatedButton))
            .every((button) => button.onPressed == null),
        isTrue,
      );
      change(() {
        visible = false;
        busy = false;
      });
      await tester.pumpAndSettle();
      expect(find.text('Delete').hitTestable(), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'local delete shows scope and full list; cancel and ordinary back do not submit',
    (tester) async {
      var calls = 0;
      bool? result;
      await _dialog(
        tester,
        local: true,
        onDelete: () async {
          calls++;
        },
        onClosed: (value) => result = value,
      );
      expect(find.text('Delete chapter records'), findsOneWidget);
      expect(
        find.textContaining('Original local archives are kept'),
        findsOneWidget,
      );
      expect(find.textContaining('all chapters in this comic'), findsOneWidget);
      final staleSubmit = tester
          .widget<FilledButton>(find.byType(FilledButton))
          .onPressed!;
      await tester.ensureVisible(find.text('25 chapters selected'));
      await tester.tap(find.text('25 chapters selected'));
      await tester.pumpAndSettle();
      final titles = find.byKey(const ValueKey('chapter-delete-titles'));
      await tester.ensureVisible(titles);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Chapter 25'),
        120,
        scrollable: find.descendant(
          of: titles,
          matching: find.byType(Scrollable),
        ),
      );
      expect(find.text('Chapter 25'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      staleSubmit();
      await tester.pumpAndSettle();
      expect(calls, 0);
      expect(result, isFalse);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(calls, 0);
      expect(result, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'download delete awaits one operation, blocks back, and cannot retry a failure',
    (tester) async {
      var calls = 0;
      var pending = Completer<void>();
      bool? result;
      await _dialog(
        tester,
        local: false,
        onDelete: () {
          calls++;
          return pending.future;
        },
        onClosed: (value) => result = value,
      );
      expect(find.text('Delete downloaded files'), findsOneWidget);
      expect(find.textContaining('all chapters in this comic'), findsNothing);
      final submit = tester
          .widget<FilledButton>(find.byType(FilledButton))
          .onPressed!;
      submit();
      submit();
      await tester.pump();
      expect(calls, 1);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.byType(MobileChapterDeleteDialog), findsOneWidget);
      pending.completeError(StateError('private-path-must-not-be-shown'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Some changes may already be saved'),
        findsOneWidget,
      );
      expect(find.textContaining('private-path'), findsNothing);
      expect(find.byType(FilledButton), findsNothing);
      submit();
      expect(calls, 1);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
      pending = Completer<void>();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pump();
      pending.complete();
      await tester.pumpAndSettle();
      expect(result, isTrue);
      expect(calls, 2);
      expect(find.text('Open'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'deletion closes the original route even after its detail widget is disposed',
    (tester) async {
      _phone(tester);
      final exists = ValueNotifier(true);
      addTearDown(exists.dispose);
      var removeComic = false, completed = 0;
      var pending = Completer<void>();
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              child: const Text('Library'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                    body: ValueListenableBuilder<bool>(
                      valueListenable: exists,
                      builder: (_, present, _) => present
                          ? Builder(
                              builder: (detailContext) => TextButton(
                                child: const Text('Remove selected'),
                                onPressed: () =>
                                    showMobileChapterDeleteConfirmation(
                                      context: detailContext,
                                      bookTitle: 'Comic',
                                      titles: const ['One'],
                                      localArchive: true,
                                      lastChapters: removeComic,
                                      onDelete: () async {
                                        if (removeComic) exists.value = false;
                                        await pending.future;
                                        return removeComic;
                                      },
                                      onDeleted: () => completed++,
                                    ),
                              ),
                            )
                          : const Text('Detail disposed'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove selected'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      pending.complete();
      await tester.pumpAndSettle();
      expect(find.text('Remove selected'), findsOneWidget);
      expect(completed, 1);
      pending = Completer<void>();
      removeComic = true;
      await tester.tap(find.text('Remove selected'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pump();
      expect(find.text('Detail disposed'), findsOneWidget);
      pending.complete();
      await tester.pumpAndSettle();
      expect(find.text('Library'), findsOneWidget);
      expect(find.text('Detail disposed'), findsNothing);
      expect(completed, 2);
      expect(tester.takeException(), isNull);
    },
  );

  test('local removal preserves other comics, added chapters and archive files; empty comic removal is awaited', () async {
    await Isar.initializeIsarCore(download: true);
    final root = await Directory.systemTemp.createTemp(
      'nodelane-chapter-actions-',
    );
    final database = await Isar.open(
      [MangaSchema, SourceSchema, ChapterSchema],
      directory: root.path,
      name: 'chapter_actions',
    );
    app.isar = database;
    addTearDown(() async {
      await dbWriteQueue.run(() {});
      await database.close(deleteFromDisk: true);
      await root.delete(recursive: true);
    });
    final archive = File('${root.path}/original.cbz')
      ..writeAsStringSync('original');
    Manga comic(int id) => Manga(
      id: id,
      name: 'Comic $id',
      isLocalArchive: true,
      source: '',
      lang: 'en',
      link: '',
      imageUrl: '',
      author: '',
      artist: '',
      genre: [],
      status: Status.unknown,
      description: '',
      sourceId: null,
    );
    final a = comic(1), b = comic(2);
    final first = Chapter(
      id: 1,
      mangaId: 1,
      name: 'One',
      archivePath: archive.path,
    )..manga.value = a;
    final other = Chapter(id: 2, mangaId: 2, name: 'Other')..manga.value = b;
    database.writeTxnSync(() {
      database.mangas.putAllSync([a, b]);
      database.chapters.putAllSync([first, other]);
      first.manga.saveSync();
      other.manga.saveSync();
    });
    // A new chapter arrives after a confirmation captured the original one.
    final added = Chapter(id: 3, mangaId: 1, name: 'Added')..manga.value = a;
    database.writeTxnSync(() {
      database.chapters.putSync(added);
      added.manga.saveSync();
    });
    expect(
      await deleteMangaChapterSelection(
        manga: a,
        selected: [first, other],
        downloadedIds: {},
      ),
      isFalse,
    );
    expect(database.chapters.getSync(1), isNull);
    expect(database.chapters.getSync(2), isNotNull);
    expect(database.chapters.getSync(3), isNotNull);
    expect(database.mangas.getSync(1), isNotNull);
    expect(
      await deleteMangaChapterSelection(
        manga: a,
        selected: [added],
        downloadedIds: {},
      ),
      isTrue,
    );
    expect(database.chapters.getSync(3), isNull);
    expect(database.mangas.getSync(1), isNull);
    expect(database.mangas.getSync(2), isNotNull);
    expect(archive.readAsStringSync(), 'original');
  });
}
