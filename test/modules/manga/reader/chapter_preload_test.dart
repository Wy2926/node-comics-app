import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/managers/chapter_preload_manager.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_content_status.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_interactive_region.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';

final current = Chapter(id: 2, mangaId: 1, name: 'Chapter 2', url: '/2');

UChapDataPreload page(Chapter chapter, int index) =>
    UChapDataPreload(chapter, null, null, false, null, index, null, index);

GetChapterPagesModel model(List<UChapDataPreload> pages) =>
    GetChapterPagesModel(
      path: null,
      pageUrls: [],
      isLocaleList: [],
      archiveImages: [],
      uChapDataPreload: pages,
      localImagePaths: [],
    );

void main() {
  test(
    'both edges complete independently and earlier chapters stay ordered',
    () async {
      final chapters = [
        for (var i = 0; i < 5; i++)
          Chapter(id: i, mangaId: 1, name: '$i', url: '/$i'),
      ];
      final manager = ChapterPreloadManager([page(chapters[2], 0)]);
      final requests = <int, Completer<GetChapterPagesModel>>{};
      Future<bool> load(
        ChapterDirection direction,
      ) => manager.loadAdjacentChapter(
        direction,
        findChapter: (edge) =>
            chapters[edge.id! + (direction == ChapterDirection.next ? 1 : -1)],
        loadPages: (chapter, _) =>
            (requests[chapter.id!] = Completer<GetChapterPagesModel>()).future,
      );
      final previous = load(ChapterDirection.previous);
      final next = load(ChapterDirection.next);
      await Future<void>.delayed(Duration.zero);
      expect(requests.keys, unorderedEquals([1, 3]));
      expect(await load(ChapterDirection.previous), isFalse);
      expect(await load(ChapterDirection.next), isFalse);
      requests[3]!.complete(model([page(chapters[3], 0)]));
      expect(await next, isTrue);
      expect(manager.pages.first.chapterState, ChapterLoadState.loading);
      requests[1]!.complete(model([page(chapters[1], 0)]));
      expect(await previous, isTrue);
      final earlier = load(ChapterDirection.previous);
      await Future<void>.delayed(Duration.zero);
      requests[0]!.complete(model([page(chapters[0], 0)]));
      expect(await earlier, isTrue);
      expect(manager.pages.map((p) => p.chapter?.id), [0, 1, 2, 3]);
      expect(manager.pages.map((p) => p.pageIndex), [0, 1, 2, 3]);

      manager.evictOldChapters(chapters[3]);
      expect(manager.isChapterEvicted(chapters[0]), isTrue);
      await manager.loadAdjacentChapter(
        ChapterDirection.next,
        findChapter: (_) => chapters[0],
        loadPages: (_, _) =>
            throw StateError('evicted slots must never be refetched/inserted'),
      );
      expect(manager.pages.last.chapterState, ChapterLoadState.failed);
      expect(manager.pages.where((p) => p.chapter?.id == 0), hasLength(1));
      manager.markChapterAsLoaded(chapters[0]);
      manager.evictOldChapters(chapters[1]);
      expect(manager.isChapterEvicted(chapters[0]), isFalse);
      expect(manager.isChapterEvicted(chapters[3]), isTrue);
      manager.dispose();
    },
  );

  test(
    'source I/O runs while prepend waits; insertion validates the current list',
    () async {
      for (final change in ['none', 'disposed', 'duplicate']) {
        final previous = Chapter(id: 1, mangaId: 1, name: '1', url: '/1');
        final manager = ChapterPreloadManager([page(current, 0)]);
        final response = Completer<GetChapterPagesModel>();
        final boundaryIdle = Completer<void>();
        final idle = Completer<void>();
        var fetched = false;
        var commits = 0;
        manager.commitPrepend = (commit) async {
          await (++commits == 1 ? boundaryIdle.future : idle.future);
          commit();
        };
        final result = manager.loadAdjacentChapter(
          ChapterDirection.previous,
          findChapter: (_) => previous,
          loadPages: (_, _) {
            fetched = true;
            return response.future;
          },
        );
        await Future<void>.delayed(Duration.zero);
        expect(fetched, isTrue);
        expect(manager.pages, hasLength(1));
        boundaryIdle.complete();
        await Future<void>.delayed(Duration.zero);
        response.complete(model([page(previous, 0), page(previous, 1)]));
        await Future<void>.delayed(Duration.zero);
        expect(manager.pages.first.chapterState, ChapterLoadState.loading);
        expect(manager.pages, hasLength(2));
        if (change == 'disposed') manager.dispose();
        if (change == 'duplicate') {
          expect(
            await manager.loadAdjacentChapter(
              ChapterDirection.next,
              findChapter: (_) => previous,
              loadPages: (_, _) async => model([page(previous, 0)]),
            ),
            isTrue,
          );
        }
        idle.complete();
        expect(await result, change == 'none');
        expect(
          manager.pages.where((p) => !p.isTransitionPage).map((p) => p.index),
          switch (change) {
            'disposed' => [],
            'duplicate' => [0, 0],
            _ => [0, 1, 0],
          },
        );
        if (change == 'duplicate') {
          expect(manager.pages.first.chapterState, ChapterLoadState.failed);
          expect(
            manager.pages.where((p) => p.chapter == previous),
            hasLength(1),
          );
        }
        manager.dispose();
      }
    },
  );

  for (final direction in ChapterDirection.values) {
    final before = direction == ChapterDirection.previous;
    final next = Chapter(
      id: before ? 1 : 3,
      mangaId: 1,
      name: 'Adjacent',
      url: before ? '/1' : '/3',
    );
    UChapDataPreload edge(ChapterPreloadManager manager) =>
        before ? manager.pages.first : manager.pages.last;
    group(direction.name, () {
      test(
        'one request keeps a waiting slot then replaces it with the next image',
        () async {
          final manager = ChapterPreloadManager([
            for (var i = 0; i < 3; i++) page(current, i),
          ]);
          final request = Completer<GetChapterPagesModel>();
          var calls = 0;
          Future<GetChapterPagesModel> fetch(Chapter chapter, bool retry) {
            expect(chapter, same(next));
            expect(retry, isFalse);
            calls++;
            return request.future;
          }

          final first = manager.loadAdjacentChapter(
            direction,
            findChapter: (_) => next,
            loadPages: fetch,
          );
          final boundary = edge(manager);
          expect(boundary.chapterState, ChapterLoadState.loading);
          expect(boundary.onRetryChapter, isNull);
          expect(
            await manager.loadAdjacentChapter(
              direction,
              findChapter: (_) => next,
              loadPages: fetch,
            ),
            isFalse,
          );
          request.complete(model([page(next, 0), page(next, 1)]));
          expect(await first, isTrue);
          expect(manager.pages.any((page) => page.isTransitionPage), isFalse);
          expect(
            manager.pages.map((page) => page.chapter?.id),
            before ? [1, 1, 2, 2, 2] : [2, 2, 2, 3, 3],
          );
          expect(boundary.chapterState, isNull);
          expect(boundary.onRetryChapter, isNull);
          expect(manager.pages.map((p) => p.pageIndex), [0, 1, 2, 3, 4]);
          expect(calls, 1);
        },
      );

      for (final empty in [false, true]) {
        test('${empty ? 'empty pages' : 'source RangeError'} remain retryable', () async {
          final manager = ChapterPreloadManager([page(current, 0)]);
          final pendingRetry = Completer<GetChapterPagesModel>();
          var calls = 0;
          Future<GetChapterPagesModel> fetch(
            Chapter chapter,
            bool retry,
          ) async {
            calls++;
            if (retry) return pendingRetry.future;
            if (empty) return model([]);
            throw RangeError('source parser failed');
          }

          await manager.loadAdjacentChapter(
            direction,
            findChapter: (_) => next,
            loadPages: fetch,
          );
          final boundary = edge(manager);
          expect(
            boundary.chapterState,
            empty ? ChapterLoadState.empty : ChapterLoadState.failed,
          );

          await manager.loadAdjacentChapter(
            direction,
            findChapter: (_) => next,
            loadPages: fetch,
          );
          expect(calls, 1); // Scrolling does not loop failed requests.
          final retry = boundary.onRetryChapter!;
          retry();
          retry();
          expect(calls, 2);
          expect(boundary.chapterState, ChapterLoadState.loading);
          expect(boundary.onRetryChapter, isNull);
          pendingRetry.complete(model([page(next, 0)]));
          await Future<void>.delayed(Duration.zero);
          expect(manager.pages, hasLength(2));
          expect(manager.pages.contains(boundary), isFalse);
          expect(edge(manager).chapter, same(next));
          expect(boundary.chapterState, isNull);
          retry(); // A callback retained by an old widget cannot append twice.
          expect(calls, 2);
        });
      }

      test(
        'only a missing adjacent chapter creates a terminal boundary',
        () async {
          final manager = ChapterPreloadManager([page(current, 0)]);
          await manager.loadAdjacentChapter(
            direction,
            findChapter: (_) => null,
            loadPages: (_, _) => throw StateError('must not fetch'),
          );
          expect(edge(manager).chapterState, ChapterLoadState.exhausted);
          await manager.loadAdjacentChapter(
            direction,
            findChapter: (_) => throw StateError('already finished'),
            loadPages: (_, _) => throw StateError('must not fetch'),
          );
          expect(manager.pages, hasLength(2));
        },
      );

      test(
        'navigation lookup errors show failure, never end of manga',
        () async {
          final manager = ChapterPreloadManager([page(current, 0)]);
          await manager.loadAdjacentChapter(
            direction,
            findChapter: (_) => throw RangeError('catalog changed'),
            loadPages: (_, _) => throw StateError('must not fetch'),
          );
          expect(edge(manager).chapterState, ChapterLoadState.failed);
          expect(edge(manager).onRetryChapter, isNotNull);
        },
      );

      test('late completion cannot mutate a disposed reader', () async {
        final manager = ChapterPreloadManager([page(current, 0)]);
        final pending = Completer<GetChapterPagesModel>();
        final result = manager.loadAdjacentChapter(
          direction,
          findChapter: (_) => next,
          loadPages: (_, _) => pending.future,
        );
        await Future<void>.delayed(Duration.zero);
        manager.dispose();
        var updates = 0;
        manager.onPagesUpdated = () => updates++;
        pending.complete(model([page(next, 0)]));
        expect(await result, isFalse);
        expect(manager.pages, isEmpty);
        expect(updates, 0);
      });

      test('wrong chapter data cannot be appended to this reader', () async {
        final manager = ChapterPreloadManager([page(current, 0)]);
        await manager.loadAdjacentChapter(
          direction,
          findChapter: (_) => next,
          loadPages: (_, _) async => model([page(current, 0)]),
        );
        expect(manager.pages, hasLength(2));
        expect(edge(manager).chapterState, ChapterLoadState.failed);
      });

      final mode = before ? ReaderMode.webtoon : ReaderMode.ltr;
      testWidgets('$mode failure retry remains clickable through tap zones', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(390, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final manager = ChapterPreloadManager([page(current, 0)]);
        final pending = Completer<GetChapterPagesModel>();
        var calls = 0, overlayTaps = 0;
        await manager.loadAdjacentChapter(
          direction,
          findChapter: (_) => next,
          loadPages: (_, retry) {
            calls++;
            return retry ? pending.future : Future.error(StateError('offline'));
          },
        );
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.5)),
              child: child!,
            ),
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  manager.onPagesUpdated = () => setState(() {});
                  final boundary = edge(manager);
                  return Stack(
                    children: [
                      if (boundary.isTransitionPage)
                        ReaderChapterBoundary(
                          data: boundary,
                          paged: mode == ReaderMode.ltr,
                        )
                      else
                        const SizedBox.expand(
                          child: Text('Next chapter image'),
                        ),
                      Positioned.fill(
                        child: ReaderInteractiveHitTestBlocker(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => overlayTaps++,
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
        await tester.pump();
        expect(
          find.text(
            'Could not load the ${before ? 'previous' : 'next'} chapter',
          ),
          findsOneWidget,
        );
        await tester.ensureVisible(find.text('Retry'));
        await tester.pump();
        final retryPosition = tester.getCenter(find.text('Retry'));
        await tester.tapAt(const Offset(10, 10));
        expect(overlayTaps, 1);
        await tester.tap(find.text('Retry'));
        await tester.pump();
        expect(calls, 2);
        expect(overlayTaps, 1);
        expect(
          find.text('Loading ${before ? 'previous' : 'next'} chapter…'),
          findsOneWidget,
        );
        expect(find.text('Retry'), findsNothing);
        pending.complete(model([page(next, 0)]));
        await tester.pump();
        expect(
          find.text('Loading ${before ? 'previous' : 'next'} chapter…'),
          findsNothing,
        );
        expect(find.text('Next chapter image'), findsOneWidget);
        // Removing the retry widget releases its reserved hit-test region.
        await tester.tapAt(retryPosition);
        expect(overlayTaps, 2);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        manager.dispose();
      });
    });
  }
}
