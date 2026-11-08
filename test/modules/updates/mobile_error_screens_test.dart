import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/about/mobile_error_reports_screen.dart';
import 'package:mangayomi/modules/updates/mobile_update_errors_screen.dart';
import 'package:mangayomi/services/crash_report.dart';

void main() {
  Future<void> start(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(2.5),
            padding: const EdgeInsets.only(top: 24, bottom: 34),
          ),
          child: child!,
        ),
        home: child,
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> reveal(
    WidgetTester tester,
    Finder finder, {
    double delta = 240,
  }) async {
    await tester.scrollUntilVisible(
      finder,
      delta,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'update errors keep record identity, full details, migration return and independent dismissal',
    (tester) async {
      const name = 'A very long shared book title across different sources';
      final first = UpdateError(
        mangaId: 1,
        name: name,
        error: 'First source is unavailable.',
      );
      final second = UpdateError(
        mangaId: 2,
        name: name,
        error: 'Second source is unavailable.\nA longer explanation that must remain readable in the expanded details.',
      );
      final missing = UpdateError(
        mangaId: 3,
        name: 'Removed book',
        error: 'Record remains after its book was removed.',
      );
      Manga book(int id) => Manga(
        id: id,
        name: name,
        source: 'Source $id',
        author: '',
        artist: '',
        genre: [],
        imageUrl: '',
        lang: 'en',
        link: '',
        status: Status.ongoing,
        description: '',
        sourceId: id,
      );
      final books = {1: book(1), 2: book(2)};
      final records = ValueNotifier([first, second, missing]);
      addTearDown(records.dispose);
      final dismissed = <int>[];
      final migrated = <Manga>[];
      var clears = 0;
      await start(
        tester,
        ValueListenableBuilder(
          valueListenable: records,
          builder: (context, errors, _) => MobileUpdateErrorsScreen(
            errors: errors,
            findManga: (id) => books[id],
            onMigrate: (book) {
              migrated.add(book);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(),
                    body: const Text('Original migration route'),
                  ),
                ),
              );
            },
            onDismiss: (id) {
              dismissed.add(id);
              records.value = records.value
                  .where((error) => error.mangaId != id)
                  .toList();
            },
            onClear: () {
              clears++;
              records.value = [];
            },
          ),
        ),
      );
      final secondTile = find.byKey(PageStorageKey(second));
      await reveal(tester, secondTile);
      await tester.tap(
        find.descendant(of: secondTile, matching: find.text('Error')),
      );
      await tester.pumpAndSettle();
      final full = find.byWidgetPredicate(
        (widget) => widget is SelectableText && widget.data == second.error,
      );
      await reveal(tester, full);
      expect(full, findsOneWidget);
      expect(dismissed, isEmpty);
      expect(migrated, isEmpty);
      final secondCard = find.byKey(ObjectKey(second));
      final migrate = find.descendant(
        of: secondCard,
        matching: find.text('Migrate'),
      );
      await reveal(tester, migrate);
      await tester.tap(migrate);
      await tester.pumpAndSettle();
      expect(migrated.single, same(books[2]));
      expect(find.text('Original migration route'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(full, findsOneWidget);
      records.value = [second, missing];
      await tester.pumpAndSettle();
      await reveal(tester, secondTile, delta: -240);
      expect(full, findsOneWidget);
      final dismiss = find.descendant(
        of: secondCard,
        matching: find.text('Dismiss'),
      );
      await reveal(tester, dismiss, delta: -240);
      await tester.tap(dismiss);
      await tester.pumpAndSettle();
      expect(dismissed, [2]);
      expect(records.value.single, same(missing));
      expect(find.text('Migrate'), findsNothing);
      await reveal(tester, find.text('Clear all'), delta: -240);
      await tester.tap(find.text('Clear all'));
      await tester.pumpAndSettle();
      expect(clears, 1);
      expect(find.text('No update errors'), findsOneWidget);
      expect(find.text('Clear all'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'report details wrap and preserve copy, scope restrictions and already-reported state',
    (tester) async {
      final appReport = CrashReport(
        time: DateTime(2026, 1, 1),
        source: 'FlutterError',
        screen: '/sampleReader',
        occurrences: 3,
        error: 'StateError: sample layout failure\nThe complete second line must remain accessible.',
        stack: '#0 SampleReader.build (package:sample/reader/long_file_name.dart:123)\n#1 SamplePanel.layout (package:sample/controls.dart:45)',
      );
      final extensionReport = CrashReport(
        time: DateTime(2026, 1, 2),
        source: 'updateMangaDetail',
        error: 'FormatException: sample source reply',
      );
      final networkReport = CrashReport(
        time: DateTime(2026, 1, 3),
        source: 'FlutterError',
        error: 'Failed to load http image: sample offline server',
      );
      final records = ValueNotifier([appReport]);
      final reported = ValueNotifier(<CrashReport>{});
      addTearDown(records.dispose);
      addTearDown(reported.dispose);
      final copies = <CrashReport>[];
      var reportsSent = 0, clears = 0;
      await start(
        tester,
        ListenableBuilder(
          listenable: Listenable.merge([records, reported]),
          builder: (_, _) => MobileErrorReportsScreen(
            reports: records.value,
            wasReported: reported.value.contains,
            onCopy: copies.add,
            onReport: (report) {
              reportsSent++;
              reported.value = {...reported.value, report};
            },
            onClear: () {
              clears++;
              records.value = [];
            },
          ),
        ),
      );
      expect(find.text('Report on GitHub'), findsNothing);
      await reveal(tester, find.text(appReport.summary));
      await tester.tap(find.text(appReport.summary));
      await tester.pumpAndSettle();
      final full = find.byWidgetPredicate(
        (widget) => widget is SelectableText && widget.data == appReport.error,
      );
      await reveal(tester, full);
      expect(full, findsOneWidget);
      final stack = find.byWidgetPredicate(
        (widget) => widget is SelectableText && widget.data == appReport.stack,
      );
      await reveal(tester, stack);
      expect(tester.getSize(stack).width, lessThan(360));
      await reveal(tester, find.text('Report on GitHub'));
      await tester.tap(find.text('Report on GitHub'));
      await tester.pumpAndSettle();
      expect(reportsSent, 1);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Already reported'),
            )
            .onPressed,
        isNull,
      );
      await reveal(tester, find.text('Copy'));
      await tester.tap(find.text('Copy'));
      expect(copies.single, same(appReport));
      for (final report in [extensionReport, networkReport]) {
        records.value = [report];
        await tester.pumpAndSettle();
        await reveal(tester, find.text(report.summary), delta: -240);
        await tester.tap(find.text(report.summary));
        await tester.pumpAndSettle();
        expect(find.byType(FilledButton), findsNothing);
        await reveal(tester, find.text('Copy'));
        await tester.tap(find.text('Copy'));
        expect(copies.last, same(report));
      }
      expect(reportsSent, 1);
      await reveal(tester, find.text('Clear'), delta: -240);
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();
      expect(clears, 1);
      expect(find.text('Clear'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
