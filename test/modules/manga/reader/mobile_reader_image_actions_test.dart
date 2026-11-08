// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/reader/widgets/image_actions_dialog.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_image_actions.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

void main() {
  final bytes = Uint8List.fromList([137, 80, 78, 71, 13, 10, 26, 10, 1, 2, 3]);

  test('page export keeps original bytes and cover saves preserve the latest comic', () async {
    await Isar.initializeIsarCore(download: true);
    final root = await Directory.systemTemp.createTemp(
      'nodelane-image-actions-',
    );
    final database = await Isar.open(
      [SettingsSchema, MangaSchema, ChapterSchema, SourceSchema],
      directory: root.path,
      name: 'image_actions',
    );
    app.isar = database;
    final previousPaths = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _Paths(root.path);
    addTearDown(() async {
      PathProviderPlatform.instance = previousPaths;
      await database.close(deleteFromDisk: true);
      await root.delete(recursive: true);
    });
    Manga comic(int id) => Manga(
      id: id,
      source: 'local',
      author: '',
      artist: '',
      genre: [],
      imageUrl: '',
      lang: 'en',
      link: '',
      name: 'Comic $id',
      status: Status.unknown,
      description: '',
      sourceId: null,
      isLocalArchive: true,
    );
    final stale = comic(1);
    database.writeTxnSync(() {
      database.settings.putSync(Settings(id: 227));
      database.mangas.putAllSync([stale, comic(2)]);
    });
    final directory = (await StorageProvider().getGalleryDirectory())!;
    expect(p.isWithin(root.path, directory.path), isTrue);
    await saveReaderPageImage(bytes, 'sample');
    expect(
      await File(p.join(directory.path, 'sample.png')).readAsBytes(),
      bytes,
    );
    await Directory(p.join(directory.path, 'blocked.png')).create();
    await expectLater(
      saveReaderPageImage(bytes, 'blocked'),
      throwsA(isA<FileSystemException>()),
    );
    await mangaRepository.writeTransaction(() {
      final latest = mangaRepository.getById(1);
      latest.name = 'Updated comic';
      latest.lastRead = 77;
      latest.favorite = true;
      mangaRepository.putSync(latest);
    });
    await setReaderPageCover(stale, bytes);
    final latest = mangaRepository.getById(1);
    expect(latest.customCoverImage, bytes);
    expect(latest.name, 'Updated comic');
    expect(latest.lastRead, 77);
    expect(latest.favorite, isTrue);
    expect(mangaRepository.getById(2).customCoverImage, isNull);
    await mangaRepository.delete(1);
    await expectLater(setReaderPageCover(stale, bytes), throwsStateError);
    expect(mangaRepository.findById(1), isNull);
  });

  Future<void> mount(
    WidgetTester tester, {
    Future<Uint8List?> Function()? load,
    Future<void> Function(Uint8List)? save,
    Future<void> Function(BuildContext, Uint8List)? share,
    Future<void> Function(Uint8List)? cover,
    VoidCallback? closed,
    String title = 'Comic',
    GlobalKey<NavigatorState>? navigator,
  }) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        theme: ThemeData(platform: TargetPlatform.iOS),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                await showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  enableDrag: false,
                  builder: (_) => MobileReaderImageActions(
                    bookTitle: title,
                    chapterTitle: 'Full chapter name',
                    pageNumber: 2,
                    loadImage: load ?? () async => bytes,
                    onSave: save ?? (_) async {},
                    onShare: share ?? (_, _) async {},
                    onSetCover: cover ?? (_) async {},
                  ),
                );
                closed?.call();
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  Finder action(String text) => find.widgetWithText(ListTile, text);
  Finder close() =>
      find.byWidgetPredicate((w) => w is IconButton && w.tooltip == 'Close');

  testWidgets(
    'image failure offers one retry and late loading after close cannot act',
    (tester) async {
      var loads = 0, closed = 0;
      final pending = Completer<Uint8List?>();
      await mount(
        tester,
        load: () {
          loads++;
          return loads == 1 ? Future.value(null) : pending.future;
        },
        closed: () => closed++,
      );
      await tester.pumpAndSettle();
      expect(find.text("This image couldn't be loaded"), findsOneWidget);
      final retry = tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Retry'))
          .onPressed!;
      retry();
      retry();
      await tester.pump();
      expect(loads, 2);
      expect(action('Save'), findsNothing);
      await tester.tap(close());
      await tester.pumpAndSettle();
      pending.complete(bytes);
      await tester.pumpAndSettle();
      expect(closed, 1);
      expect(find.text('Open'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'save, share and cover confirmation serialize original-page actions',
    (tester) async {
      final save = Completer<void>(),
          share = Completer<void>(),
          cover = Completer<void>();
      var saves = 0, shares = 0, covers = 0, closed = 0;
      final longTitle = 'A complete comic title ${'with more words ' * 8}';
      await mount(
        tester,
        title: longTitle,
        save: (value) {
          expect(value, same(bytes));
          saves++;
          return save.future;
        },
        share: (_, value) {
          expect(value, same(bytes));
          shares++;
          return share.future;
        },
        cover: (value) {
          expect(value, same(bytes));
          covers++;
          return cover.future;
        },
        closed: () => closed++,
      );
      await tester.pumpAndSettle();
      expect(find.text(longTitle), findsOneWidget);
      final saveAction = tester.widget<ListTile>(action('Save')).onTap!;
      saveAction();
      saveAction();
      await tester.pump();
      expect(saves, 1);
      expect(tester.widget<IconButton>(close()).onPressed, isNull);
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.byType(MobileReaderImageActions), findsOneWidget);
      save.complete();
      await tester.pumpAndSettle();
      expect(tester.widget<ListTile>(action('Picture saved')).onTap, isNull);
      saveAction();
      expect(saves, 1);
      final shareAction = tester.widget<ListTile>(action('Share')).onTap!;
      shareAction();
      shareAction();
      await tester.pump();
      expect(shares, 1);
      share.complete();
      await tester.pumpAndSettle();
      expect(tester.widget<ListTile>(action('Share')).onTap, isNotNull);
      tester.view.physicalSize = const Size(740, 360);
      await tester.pumpAndSettle();
      await tester.ensureVisible(action('Set as cover'));
      await tester.tap(action('Set as cover'));
      await tester.pumpAndSettle();
      expect(find.text(longTitle), findsOneWidget);
      expect(
        find.widgetWithText(TextButton, 'Cancel').hitTestable(),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(FilledButton, 'Set as cover').hitTestable(),
        findsOneWidget,
      );
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();
      expect(covers, 0);
      await tester.ensureVisible(action('Set as cover'));
      await tester.tap(action('Set as cover'));
      await tester.pumpAndSettle();
      final confirm = tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Set as cover'),
          )
          .onPressed!;
      confirm();
      confirm();
      await tester.pump();
      expect(covers, 1);
      cover.complete();
      await tester.pumpAndSettle();
      confirm();
      expect(covers, 1);
      expect(closed, 1);
      expect(find.text('Open'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'cover size limit is explicit and an uncertain action cannot be retried in the same menu',
    (tester) async {
      final large = Uint8List(maxMangaCoverImageBytes);
      var saves = 0;
      await mount(
        tester,
        load: () async => large,
        save: (_) async {
          saves++;
          throw StateError('unavailable');
        },
      );
      await tester.pumpAndSettle();
      expect(tester.widget<ListTile>(action('Set as cover')).onTap, isNull);
      expect(
        find.text(
          'Cover images must be smaller than 5 MB. Saving and sharing remain available.',
        ),
        findsOneWidget,
      );
      expect(tester.widget<ListTile>(action('Share')).onTap, isNotNull);
      final save = tester.widget<ListTile>(action('Save')).onTap!;
      save();
      await tester.pumpAndSettle();
      save();
      expect(saves, 1);
      expect(
        find.text(
          'The action could not be confirmed. Close this menu and check the result before trying again.',
        ),
        findsOneWidget,
      );
      expect(tester.widget<ListTile>(action('Save')).onTap, isNull);
      expect(tester.widget<ListTile>(action('Share')).onTap, isNull);
      await tester.tap(close());
      await tester.pumpAndSettle();
      expect(find.text('Open'), findsOneWidget);
    },
  );

  testWidgets(
    'cover completion after forced route removal cannot pop the next page',
    (tester) async {
      final pending = Completer<void>();
      final navigator = GlobalKey<NavigatorState>();
      await mount(tester, navigator: navigator, cover: (_) => pending.future);
      await tester.pumpAndSettle();
      await tester.tap(action('Set as cover'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Set as cover'));
      await tester.pump();
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      navigator.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('Next page')),
        ),
      );
      await tester.pumpAndSettle();
      pending.complete();
      await tester.pumpAndSettle();
      expect(find.text('Next page'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

class _Paths extends PathProviderPlatform {
  _Paths(this.path);
  final String path;
  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}
