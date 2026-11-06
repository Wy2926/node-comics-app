// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/modules/library/widgets/library_dialogs.dart';
import 'package:mangayomi/modules/library/widgets/mobile_bookshelf_actions.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

Widget _app(Widget body) => MaterialApp(
  theme: ThemeData(platform: TargetPlatform.iOS),
  locale: const Locale('en'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: body),
);
void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(360, 740);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> _dialog(
  WidgetTester tester, {
  required Future<void> Function(bool, bool) onRemove,
  ValueChanged<bool?>? onClosed,
  List<String> titles = const ['Comic A', 'Comic B'],
}) async {
  _phone(tester);
  await tester.pumpWidget(
    _app(
      Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            final result = await showNodeLaneCatalogSheet<bool>(
              context,
              MobileBookshelfRemoveSheet(
                titles: titles,
                hasLocalArchives: true,
                onRemove: onRemove,
              ),
              dismissible: false,
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
    'menu preserves action identities and disables unavailable items',
    (tester) async {
      _phone(tester);
      final actions = <int>[];
      var updating = false, entries = false;
      late StateSetter change;
      await tester.pumpWidget(
        _app(
          StatefulBuilder(
            builder: (context, setState) {
              change = setState;
              return MobileBookshelfMenu(
                hasEntries: entries,
                updating: updating,
                ignoreFilters: false,
                onSelected: actions.add,
              );
            },
          ),
        ),
      );
      for (final label in [
        'Update library',
        'Open random entry',
        'Select works',
      ]) {
        expect(
          tester
              .widget<NodeLaneRow>(find.widgetWithText(NodeLaneRow, label))
              .onTap,
          isNull,
        );
      }
      await tester.tap(find.text('Update library'));
      await tester.tap(find.text('Open random entry'));
      expect(actions, isEmpty);
      change(() => updating = true);
      await tester.pump();
      await tester.tap(find.text('Stop library update'));
      expect(actions, [5]);
      change(() {
        updating = false;
        entries = true;
      });
      await tester.pump();
      await tester.tap(find.text('Update library'));
      await tester.tap(find.text('Open random entry'));
      await tester.tap(find.text('Search options'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(NodeLaneSwitch));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(NodeLaneSwitch));
      expect(actions, [5, 0, 1, 4]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'selection keeps frequent actions direct and secondary actions in More',
    (tester) async {
      _phone(tester);
      tester.view.physicalSize = const Size(320, 740);
      var visible = true;
      late StateSetter change;
      final actions = <int>[];
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
                  child: visible
                      ? MobileBookshelfSelectionBar(
                          hasSelection: true,
                          onCategories: () => actions.add(10),
                          onRead: () => actions.add(11),
                          onMore: actions.add,
                        )
                      : const SizedBox.shrink(),
                ),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('Categories'));
      await tester.tap(find.text('Mark read'));
      expect(find.text('Remove'), findsNothing);
      final position = tester.getCenter(find.text('More'));
      expect(position.dy, lessThan(740 - 34));
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      expect(actions, [10, 11, 3]);
      change(() => visible = false);
      await tester.pumpAndSettle();
      await tester.tapAt(position);
      expect(actions, [10, 11, 3]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'removal starts with no scope and cancellation preserves selection',
    (tester) async {
      var calls = 0;
      bool? result;
      await _dialog(
        tester,
        onRemove: (_, _) async {
          calls++;
        },
        onClosed: (value) => result = value,
        titles: [
          for (var i = 0; i < 25; i++) 'Comic $i with a complete edition name',
        ],
      );
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Remove'))
            .onPressed,
        isNull,
      );
      await tester.tap(find.text('View selected works'));
      await tester.pumpAndSettle();
      final list = find.byType(ListView).last;
      await tester.scrollUntilVisible(
        find.text('Comic 24 with a complete edition name'),
        100,
        scrollable: find.descendant(
          of: list,
          matching: find.byType(Scrollable),
        ),
      );
      expect(
        find.text('Comic 24 with a complete edition name'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Remove from bookshelf'));
      await tester.tap(find.text('Remove from bookshelf'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(calls, 0);
      expect(result, false);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'one confirmed removal blocks duplicate calls and back until completion',
    (tester) async {
      final pending = Completer<void>();
      final calls = <(bool, bool)>[];
      bool? result;
      await _dialog(
        tester,
        onRemove: (library, files) {
          calls.add((library, files));
          return pending.future;
        },
        onClosed: (value) => result = value,
      );
      await tester.tap(find.text('Remove from bookshelf'));
      await tester.tap(find.text('Delete downloaded files'));
      await tester.pumpAndSettle();
      final action = tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Remove'))
          .onPressed!;
      action();
      action();
      await tester.pump();
      expect(calls, [(true, true)]);
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.byType(MobileBookshelfRemoveSheet), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Remove'))
            .onPressed,
        isNull,
      );
      pending.complete();
      await tester.pumpAndSettle();
      expect(result, true);
      expect(find.byType(MobileBookshelfRemoveSheet), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'partial failure only permits closing and never repeats removal',
    (tester) async {
      var calls = 0;
      await _dialog(
        tester,
        onRemove: (_, _) async {
          calls++;
          throw StateError('partial');
        },
      );
      await tester.tap(find.text('Delete downloaded files'));
      await tester.pump();
      final action = tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Remove'))
          .onPressed!;
      action();
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Some works or files may have been processed'),
        findsOneWidget,
      );
      expect(find.widgetWithText(FilledButton, 'Remove'), findsNothing);
      action();
      await tester.pump();
      expect(calls, 1);
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Open'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  group('local file ordering', () {
    late Directory root;
    late Isar database;
    late PathProviderPlatform originalPaths;
    setUpAll(() async {
      originalPaths = PathProviderPlatform.instance;
      await Isar.initializeIsarCore(download: true);
      root = await Directory.systemTemp.createTemp('nodelane-removal-test-');
      database = await Isar.open(
        [
          SettingsSchema,
          SourceSchema,
          TrackSchema,
          MangaSchema,
          ChapterSchema,
          DownloadSchema,
        ],
        directory: root.path,
        name: 'removal_test',
      );
      app.isar = database;
      database.writeTxnSync(() => database.settings.putSync(Settings(id: 227)));
      PathProviderPlatform.instance = _Paths(root.path);
    });
    tearDownAll(() async {
      PathProviderPlatform.instance = originalPaths;
      await Isar.getInstance('removal_test')?.close(deleteFromDisk: true);
      if (root.existsSync()) await root.delete(recursive: true);
    });
    Future<(Manga, File)> book(String title) async {
      final folder = await Directory('${root.path}/$title').create();
      final file = await File('${folder.path}/book.cbz')
          .writeAsString('test-only');
      final manga = Manga(
        source: 'archive',
        author: '',
        artist: '',
        genre: [],
        imageUrl: '',
        lang: 'en',
        link: '',
        name: title,
        status: Status.unknown,
        description: '',
        sourceId: null,
        isLocalArchive: true,
        favorite: true,
      );
      database.writeTxnSync(() {
        database.mangas.putSync(manga);
        final chapter = Chapter(
          mangaId: manga.id,
          name: 'Chapter',
          archivePath: file.path,
        )..manga.value = manga;
        database.chapters.putSync(chapter);
        chapter.manga.saveSync();
        manga.chapters.loadSync();
      });
      return (manga, file);
    }

    test(
      'files precede one record removal, while library-only retains files',
      () async {
        final (both, file) = await book('both');
        final removed = <int>[];
        await removeMobileLibrarySelection(
          [both],
          fromLibrary: true,
          downloads: true,
          removeFromLibrary: (manga) async {
            expect(file.existsSync(), false);
            removed.add(manga.id!);
            database.writeTxnSync(
              () => database.chapters.deleteAllSync(
                manga.chapters.map((c) => c.id!).toList(),
              ),
            );
          },
        );
        expect(removed, [both.id]);
        final (library, original) = await book('library');
        await removeMobileLibrarySelection(
          [library],
          fromLibrary: true,
          downloads: false,
          removeFromLibrary: (manga) async => removed.add(manga.id!),
        );
        expect(original.existsSync(), true);
        final (files, archive) = await book('files');
        await removeMobileLibrarySelection(
          [files],
          fromLibrary: false,
          downloads: true,
          removeFromLibrary: (manga) async => removed.add(manga.id!),
        );
        expect(archive.existsSync(), false);
        expect(removed, [both.id, library.id, files.id]);
      },
    );
    test(
      'a failed record operation stops before touching the next book',
      () async {
        final (first, _) = await book('first');
        final (next, original) = await book('next');
        var calls = 0;
        await expectLater(
          removeMobileLibrarySelection(
            [first, next],
            fromLibrary: true,
            downloads: true,
            removeFromLibrary: (_) async {
              calls++;
              throw StateError('record failure');
            },
          ),
          throwsStateError,
        );
        expect(calls, 1);
        expect(original.existsSync(), true);
      },
    );
  });
}

class _Paths extends PathProviderPlatform {
  _Paths(this.path);
  final String path;
  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}
