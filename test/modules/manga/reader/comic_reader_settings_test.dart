import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/settings/reader/mobile_reader_screen.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_preferences.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_preferences_provider.dart';
import 'package:mangayomi/modules/manga/reader/settings/comic_reader_settings_sheet.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MemoryPreferences extends ComicReaderPreferencesController {
  int writes = 0;
  bool fail = false;
  @override
  ComicReaderPreferences build() => const ComicReaderPreferences();
  @override
  Future<void> update(
    ComicReaderPreferences Function(ComicReaderPreferences) edit,
  ) async {
    if (fail) throw StateError('fixture write failure');
    writes++;
    state = edit(state);
  }
}

void main() {
  Future<ProviderContainer> mount(
    WidgetTester tester, {
    double scale = 1,
    bool global = false,
    Locale locale = const Locale('en'),
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        comicReaderPreferencesProvider.overrideWith(MemoryPreferences.new),
      ],
    );
    addTearDown(container.dispose);
    final running = ValueNotifier(false);
    addTearDown(running.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: nodeLaneModalTheme(ThemeData(platform: TargetPlatform.iOS)),
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(scale),
              padding: const EdgeInsets.only(top: 47, bottom: 34),
            ),
            child: child!,
          ),
          home: global
              ? const MobileReaderScreen()
              : Scaffold(
                  body: Builder(
                    builder: (context) => Center(
                      child: TextButton(
                        child: const Text('Open'),
                        onPressed: () => showNodeLaneCatalogSheet<void>(
                          context,
                          ComicReaderSettingsSheet(
                            bookId: 1,
                            bookTitle: '海风中的来信',
                            autoScroll: running,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
    if (!global) await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets(
    'shared choice navigation preserves book scope and cancellation; image options expand inline',
    (tester) async {
      final container = await mount(tester);
      final controller = container.read(
        comicReaderPreferencesProvider.notifier,
      ) as MemoryPreferences;
      expect(controller.writes, 0);
      expect(find.text('Left'), findsOneWidget);
      await tester.tap(find.widgetWithText(NodeLaneRow, 'Reading mode'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(controller.writes, 0);
      await tester.tap(find.widgetWithText(NodeLaneRow, 'Reading mode'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Scroll down'));
      await tester.pumpAndSettle();
      expect(find.text('Content width'), findsOneWidget);
      expect(find.text('Page layout'), findsNothing);
      expect(
        container.read(comicReaderPreferencesProvider).resolve(1).mode,
        ComicReadingMode.scroll,
      );
      expect(
        container.read(comicReaderPreferencesProvider).resolve(2).mode,
        ComicReadingMode.paged,
      );
      await tester.scrollUntilVisible(find.text('Fine-tune image'), 200);
      await tester.tap(find.text('Fine-tune image'));
      await tester.pumpAndSettle();
      expect(find.byType(NodeLaneCatalogSheet), findsOneWidget);
      expect(find.text('Wide pages'), findsNothing);
      await tester.scrollUntilVisible(find.text('Defaults & habits'), 200);
      await tester.tap(find.text('Defaults & habits'));
      await tester.pumpAndSettle();
      expect(find.byType(NodeLaneCatalogSheet), findsOneWidget);
      await tester.tap(
        find.widgetWithText(NodeLaneRow, 'Swipe to the next page'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Right'));
      await tester.pumpAndSettle();
      expect(
        container.read(comicReaderPreferencesProvider).resolve(2).turn,
        ComicPageTurn.right,
      );
      expect(
        container.read(comicReaderPreferencesProvider).resolve(1).mode,
        ComicReadingMode.scroll,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'global settings reuse novel-style controls and stay reachable with large Chinese text',
    (tester) async {
      await mount(tester, scale: 2.5, locale: const Locale('zh'), global: true);
      final context = tester.element(find.byType(ComicReaderSettingsContent));
      final l = AppLocalizations.of(context)!;
      await tester.scrollUntilVisible(find.text(l.comic_tap), 240);
      await tester.pumpAndSettle();
      expect(find.text(l.comic_tap).hitTestable(), findsOneWidget);
      expect(find.byType(NodeLaneSwitchRow), findsNWidgets(3));
      await tester.scrollUntilVisible(
        find.widgetWithText(NodeLaneRow, l.reading_mode),
        -240,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(NodeLaneRow, l.reading_mode));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l.comic_scroll));
      await tester.pumpAndSettle();
      expect(find.text(l.comic_turn), findsNothing);
      expect(find.text(l.comic_layout), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'failed save leaves the selection intact and reports the failure',
    (tester) async {
      final container = await mount(tester);
      (container.read(
        comicReaderPreferencesProvider.notifier,
      ) as MemoryPreferences).fail = true;
      await tester.tap(find.widgetWithText(NodeLaneRow, 'Reading mode'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Scroll down'));
      await tester.pumpAndSettle();
      expect(
        container.read(comicReaderPreferencesProvider).resolve(1).mode,
        ComicReadingMode.paged,
      );
      expect(find.text('Could not save. Please try again.'), findsOneWidget);
    },
  );
}
