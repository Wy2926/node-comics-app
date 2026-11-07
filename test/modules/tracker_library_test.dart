import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/models/tracker_library_cache.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_section.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/tracker_library/tracker_section_screen.dart';
import 'package:mangayomi/repositories/tracker_library_cache_repository.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  late Directory directory;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = overrides;
    }
  });
  setUp(() async {
    directory = Directory.systemTemp.createTempSync('tracker_ui');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (_) async => directory.path,
        );
    app.isar = await Isar.open(
      [TrackSchema, TrackerLibraryCacheSchema],
      directory: directory.path,
      name: 'tracker_ui_${directory.path.hashCode}',
    );
  });
  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          null,
        );
    await app.isar.close(deleteFromDisk: true);
    directory.deleteSync(recursive: true);
  });

  Future<void> mount(
    WidgetTester tester,
    TrackLibrarySection section, {
    String identity = 'section',
    double scale = 1,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: NodeLaneSurface(
          child: Scaffold(
            body: ListView(
              padding: NodeLaneTokens.pagePadding,
              children: [
                TrackerSectionScreen(key: ValueKey(identity), section: section),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> settle(WidgetTester tester, {Finder? until}) async {
    // Isar runs outside the widget clock; wait for completion, not 120 ms.
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (DateTime.now().isBefore(deadline)) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 15)),
      );
      await tester.pump();
      if (until != null
          ? until.evaluate().isNotEmpty
          : find.byType(NodeLaneSkeleton).evaluate().isEmpty) {
        return;
      }
    }
    fail('Tracker section did not finish loading.');
  }

  testWidgets(
    'retry, rebuild and explicit refresh preserve section cache behavior',
    (tester) async {
      var requests = 0;
      TrackLibrarySection section() => TrackLibrarySection(
        name: 'Reading',
        syncId: 2,
        func: () async {
          requests++;
          if (requests == 1) throw StateError('offline');
          return [];
        },
      );
      await mount(tester, section(), scale: 2);
      await settle(tester);
      await tester.ensureVisible(find.text('Retry'));
      await tester.tap(find.text('Retry'));
      await settle(tester);
      expect(requests, 2);
      expect(find.text('Retry'), findsNothing);
      await mount(tester, section());
      await settle(tester);
      expect(requests, 2);
      await mount(tester, section(), identity: 'reopened');
      await settle(tester);
      expect(requests, 2);
      await tester.runAsync(
        () => trackerLibraryCacheRepository.deleteByPrefix('2-manga-'),
      );
      await mount(tester, section(), identity: 'refresh');
      await settle(tester);
      expect(requests, 3);
      expect(
        await tester.runAsync(
          () => trackerLibraryCacheRepository.get('2-manga-Reading'),
        ),
        isEmpty,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'replaced searches discard late results and do not write section cache',
    (tester) async {
      final old = Completer<List<TrackSearch>?>();
      await mount(
        tester,
        TrackLibrarySection(
          name: 'Search',
          syncId: 2,
          isSearch: true,
          func: () => old.future,
        ),
        identity: 'old',
      );
      await mount(
        tester,
        TrackLibrarySection(
          name: 'Search',
          syncId: 2,
          isSearch: true,
          func: () async => [],
        ),
        identity: 'new',
      );
      await settle(tester);
      old.complete([TrackSearch(title: 'Stale result')]);
      await settle(tester);
      expect(find.text('Stale result'), findsNothing);
      expect(
        await tester.runAsync(
          () => trackerLibraryCacheRepository.get('2-manga-Search'),
        ),
        isNull,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets(
    'search result badge only follows links from the current tracker',
    (tester) async {
      await tester.runAsync(
        () => app.isar.writeTxn(
          () => app.isar.tracks.put(
            Track(
              syncId: 3,
              mediaId: 42,
              mangaId: 8,
              status: TrackStatus.reading,
            ),
          ),
        ),
      );
      await mount(
        tester,
        TrackLibrarySection(
          name: 'Reading',
          syncId: 2,
          isSearch: true,
          func: () async => [
            TrackSearch(
              mediaId: 42,
              title: 'A long tracked title',
              score: 8.5,
              coverUrl: 'https://example.invalid/cover.png',
            ),
          ],
        ),
        scale: 2,
      );
      await settle(tester, until: find.text('A long tracked title'));
      expect(find.text('A long tracked title'), findsOneWidget);
      final libraryBadge = find.byWidgetPredicate(
        (widget) =>
            widget is NodeLaneCoverBadge && widget.semanticsLabel != null,
      );
      expect(libraryBadge, findsNothing);
      await tester.runAsync(
        () => app.isar.writeTxn(
          () => app.isar.tracks.put(
            Track(
              syncId: 2,
              mediaId: 42,
              mangaId: 9,
              status: TrackStatus.reading,
            ),
          ),
        ),
      );
      await settle(tester, until: libraryBadge);
      expect(libraryBadge, findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
