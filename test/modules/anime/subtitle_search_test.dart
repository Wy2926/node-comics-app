import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/anime/widgets/search_subtitles.dart';
import 'package:mangayomi/modules/more/settings/player/subtitle_service_screen.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/services/subtitles/subtitle_preferences.dart';
import 'package:mangayomi/services/subtitles/subtitle_service.dart';

Widget app(ProviderContainer container, Widget home, {double keyboard = 0}) =>
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.5),
            viewInsets: EdgeInsets.only(bottom: keyboard),
          ),
          child: child!,
        ),
        home: home,
      ),
    );

Finder field(String key) => find.descendant(
  of: find.byKey(ValueKey(key)),
  matching: find.byType(TextFormField),
);

Future<void> tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));
  void size(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets(
    'unconfigured search opens settings; drafts cancel and failed saves can retry',
    (tester) async {
      size(tester);
      final store = _Store();
      final container = ProviderContainer(
        overrides: [subtitlePreferencesStoreProvider.overrideWithValue(store)],
      );
      addTearDown(container.dispose);
      final home = Scaffold(
        body: SubtitlesWidgetSearch(
          chapter: Chapter(mangaId: 1, name: 'Episode'),
          isLocal: false,
        ),
      );
      await tester.pumpWidget(app(container, home, keyboard: 180));
      await tester.pumpAndSettle();
      expect(
        find.text('Choose a subtitle service before searching.'),
        findsOneWidget,
      );
      expect(find.byType(TextFormField), findsNothing);
      await tap(
        tester,
        find.widgetWithText(NodeLaneRow, 'Online subtitle service'),
      );
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Subtitle source'));
      await tap(tester, find.widgetWithText(NodeLaneRow, 'My Wyzie key'));
      await tester.enterText(field('subtitle-key'), 'personal-fixture');
      expect(
        tester
            .widget<EditableText>(
              find.descendant(
                of: field('subtitle-key'),
                matching: find.byType(EditableText),
              ),
            )
            .obscureText,
        isTrue,
      );
      await tap(tester, find.byTooltip('Back'));
      expect((await store.read()).mode, SubtitleConnectionMode.disabled);

      await tap(
        tester,
        find.widgetWithText(NodeLaneRow, 'Online subtitle service'),
      );
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Subtitle source'));
      await tap(
        tester,
        find.widgetWithText(NodeLaneRow, 'My subtitle service'),
      );
      await tester.enterText(
        field('subtitle-address'),
        'https://own.example/search?key=bad',
      );
      await tap(tester, find.text('Save'));
      expect(
        find.text(
          'Use a complete HTTPS URL without a query, fragment or embedded credentials.',
        ),
        findsOneWidget,
      );
      expect(store.writes, 0);
      await tester.enterText(
        field('subtitle-address'),
        'https://own.example/api/subtitles',
      );
      await tester.enterText(field('subtitle-token'), 'custom-fixture');
      store.fail = true;
      await tap(tester, find.text('Save'));
      expect(
        find.text(
          'Could not read or save subtitle settings. Please try again.',
        ),
        findsOneWidget,
      );
      expect(
        tester.widget<TextFormField>(field('subtitle-token')).controller!.text,
        'custom-fixture',
      );
      expect((await store.read()).mode, SubtitleConnectionMode.disabled);
      store.fail = false;
      await tap(tester, find.text('Save'));
      expect(find.byType(SubtitleServiceScreen), findsNothing);
      expect((await store.read()).credential, 'custom-fixture');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'series selection uses parent ID and explicit retry; duplicate downloads are blocked',
    (tester) async {
      size(tester);
      final catalog = _Catalog(), source = _Source();
      final container = ProviderContainer(
        overrides: [
          subtitleSearchServiceProvider.overrideWith(
            (_, _) async =>
                SubtitleSearchService(catalog: catalog, source: source),
          ),
        ],
      );
      addTearDown(container.dispose);
      SubtitleContent? selected;
      await tester.pumpWidget(
        app(
          container,
          Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  selected = await showSubtitleSearch(
                    context,
                    chapter: Chapter(mangaId: 1, name: 'Episode'),
                    isLocal: false,
                  );
                },
                child: const Text('Search'),
              ),
            ),
          ),
        ),
      );
      await tap(tester, find.text('Search'));
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Series'));
      await tap(tester, find.widgetWithText(NodeLaneRow, 'S2E4: Episode'));
      expect(source.query!.titleId, 'tt-series');
      expect((source.query!.season, source.query!.episode), (2, 4));
      await tap(tester, find.widgetWithText(NodeLaneRow, 'Subtitle'));
      expect(source.downloads, 1);
      expect(
        find.text(
          'The subtitle service quota is exhausted. Check your account with that service.',
        ),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 1));
      expect(source.downloads, 1);
      source.pending = Completer<SubtitleContent>();
      await tester.tap(find.text('Retry'));
      await tester.pump();
      expect(source.downloads, 2);
      expect(find.widgetWithText(NodeLaneRow, 'Subtitle'), findsNothing);
      source.pending!.complete(
        const SubtitleContent(
          text: '字幕内容',
          name: 'Subtitle',
          language: 'zh',
          format: 'srt',
        ),
      );
      await tester.pumpAndSettle();
      expect(selected!.text, '字幕内容');
      expect(find.byType(SubtitlesWidgetSearch), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'configuration change discards pending results from the previous source',
    (tester) async {
      size(tester);
      final old = _Catalog()..pending = Completer<List<SubtitleTitle>>();
      final current = _Catalog()..title = 'Current service title';
      final container = ProviderContainer(
        overrides: [
          subtitleSearchServiceProvider.overrideWith((ref, _) async {
            final preferences = await ref.watch(
              subtitlePreferencesProvider.future,
            );
            return SubtitleSearchService(
              catalog: preferences.mode == SubtitleConnectionMode.customService
                  ? current
                  : old,
              source: _Source(),
            );
          }),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        app(
          container,
          Scaffold(
            body: SubtitlesWidgetSearch(
              chapter: Chapter(mangaId: 1, name: 'Episode'),
              isLocal: false,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      await container
          .read(subtitlePreferencesProvider.notifier)
          .save(
            SubtitlePreferences.customService('https://own.example/search'),
          );
      await tester.pumpAndSettle();
      expect(find.text('Current service title'), findsOneWidget);
      old.pending!.complete([
        const SubtitleTitle(id: 'old', name: 'Stale result'),
      ]);
      await tester.pumpAndSettle();
      expect(find.text('Stale result'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

class _Store extends SubtitlePreferencesStore {
  bool fail = false;
  int writes = 0;
  @override
  Future<void> write(SubtitlePreferences value) async {
    writes++;
    if (fail) throw StateError('Unavailable');
    await super.write(value);
  }
}

class _Catalog implements SubtitleCatalog {
  String title = 'Series';
  Completer<List<SubtitleTitle>>? pending;
  @override
  Future<List<SubtitleTitle>> searchTitles(String query) async =>
      pending != null
      ? pending!.future
      : [SubtitleTitle(id: 'tt-series', name: title, isSeries: true)];
  @override
  Future<List<SubtitleEpisode>> episodes(String titleId) async => [
    const SubtitleEpisode(name: 'Episode', season: 2, episode: 4),
  ];
}

class _Source implements SubtitleSource {
  SubtitleQuery? query;
  int downloads = 0;
  Completer<SubtitleContent>? pending;
  @override
  Future<List<SubtitleMatch>> search(SubtitleQuery query) async {
    this.query = query;
    return [
      SubtitleMatch(
        name: 'Subtitle',
        displayLanguage: '中文',
        format: 'srt',
        load: () async {
          downloads++;
          if (pending != null) return pending!.future;
          throw const SubtitleFailure(SubtitleFailureCode.quota);
        },
      ),
    ];
  }
}
