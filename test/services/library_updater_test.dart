import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/services/update_errors_provider.dart';

void main() {
  const hour = Duration.millisecondsPerHour;
  const now = 1000 * hour;

  testWidgets(
    'closing progress and its page keeps one update running; failures do not block later entries',
    (tester) async {
      final first = Completer<void>(), last = Completer<void>();
      final calls = <int>[];
      final entries = [
        for (var id = 1; id <= 3; id++)
          Manga(
            id: id,
            name: 'Book $id',
            source: 'Source',
            sourceId: 1,
            author: '',
            artist: '',
            genre: [],
            imageUrl: '',
            lang: 'en',
            link: '',
            status: Status.ongoing,
            description: '',
          ),
      ];
      final container = ProviderContainer(
        overrides: [
          updateErrorsProvider.overrideWith(_MemoryUpdateErrors.new),
          for (var id = 1; id <= 3; id++)
            updateMangaDetailProvider(
              mangaId: id,
              isInit: false,
              showToast: false,
            ).overrideWith((ref) async {
              calls.add(id);
              if (id == 2) throw StateError('source unavailable');
              await (id == 1 ? first.future : last.future);
            }),
        ],
      );
      addTearDown(container.dispose);
      final visible = ValueNotifier(true);
      addTearDown(visible.dispose);
      late BuildContext pageContext;
      late WidgetRef pageRef;
      late Future<void> run;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: ValueListenableBuilder(
                valueListenable: visible,
                builder: (_, visible, _) => visible
                    ? Consumer(
                        builder: (context, ref, _) {
                          pageContext = context;
                          pageRef = ref;
                          return TextButton(
                            onPressed: () {
                              run = updateLibrary(
                                ref: ref,
                                context: context,
                                mangaList: entries,
                                itemType: ItemType.manga,
                              );
                            },
                            child: const Text('Start'),
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Start'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await updateLibrary(
        ref: pageRef,
        context: pageContext,
        mangaList: entries,
        itemType: ItemType.manga,
      );
      expect(calls, [1]);
      expect(container.read(libraryUpdateProvider).total, 3);
      await tester.tap(find.byTooltip('Close'));
      visible.value = false;
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump();
      expect(pageContext.mounted, isFalse);
      first.complete();
      await tester.pump();
      expect(calls, [1, 2, 3]);
      expect(container.read(libraryUpdateProvider).done, 2);
      expect(container.read(libraryUpdateProvider).running, isTrue);
      last.complete();
      await tester.pump();
      await run;
      expect(container.read(libraryUpdateProvider).running, isFalse);
      expect(container.read(updateErrorsProvider).single.mangaId, 2);
      expect(find.byType(NodeLaneNotice), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  group('isLibraryUpdateDue', () {
    test('an interval of 0 never runs, however long it has been', () {
      expect(
        isLibraryUpdateDue(intervalHours: 0, lastRun: 0, now: now),
        isFalse,
      );
      expect(
        isLibraryUpdateDue(intervalHours: 0, lastRun: null, now: now),
        isFalse,
      );
    });

    test('a library that has never refreshed is due right away', () {
      expect(
        isLibraryUpdateDue(intervalHours: 24, lastRun: null, now: now),
        isTrue,
      );
    });

    test('waits out the interval, then runs', () {
      expect(
        isLibraryUpdateDue(
          intervalHours: 24,
          lastRun: now - 23 * hour,
          now: now,
        ),
        isFalse,
      );
      expect(
        isLibraryUpdateDue(
          intervalHours: 24,
          lastRun: now - 24 * hour,
          now: now,
        ),
        isTrue,
      );
    });

    test('a refresh that just started is not due again', () {
      expect(
        isLibraryUpdateDue(intervalHours: 12, lastRun: now, now: now),
        isFalse,
      );
    });

    test('every offered interval is honoured', () {
      for (final hours in libraryUpdateIntervals.where((h) => h > 0)) {
        expect(
          isLibraryUpdateDue(
            intervalHours: hours,
            lastRun: now - (hours - 1) * hour,
            now: now,
          ),
          isFalse,
          reason: 'an interval of $hours hours ran an hour early',
        );
        expect(
          isLibraryUpdateDue(
            intervalHours: hours,
            lastRun: now - hours * hour,
            now: now,
          ),
          isTrue,
          reason: 'an interval of $hours hours did not come due',
        );
      }
    });

    test('a clock that moved backwards does not run early', () {
      expect(
        isLibraryUpdateDue(
          intervalHours: 24,
          lastRun: now + 5 * hour,
          now: now,
        ),
        isFalse,
      );
    });
  });
}

class _MemoryUpdateErrors extends UpdateErrorsNotifier {
  @override
  List<UpdateError> build() => [];
  @override
  void set(List<UpdateError> errors) => state = errors;
}
