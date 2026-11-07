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

final current = Chapter(id: 1, mangaId: 1, name: 'Chapter 1', url: '/1');
final next = Chapter(id: 2, mangaId: 1, name: 'Chapter 2', url: '/2');

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
    'one request keeps a waiting slot then replaces it with the next image',
    () async {
      final manager = ChapterPreloadManager()..initialize([page(current, 0)]);
      final request = Completer<GetChapterPagesModel>();
      var calls = 0;
      Future<GetChapterPagesModel> fetch(Chapter chapter, bool retry) {
        expect(chapter, same(next));
        expect(retry, isFalse);
        calls++;
        return request.future;
      }

      final first = manager.loadNextChapter(
        current,
        findNextChapter: () => next,
        loadPages: fetch,
      );
      final boundary = manager.pages.last;
      expect(boundary.nextChapterState, NextChapterState.loading);
      expect(boundary.onRetryChapter, isNull);
      expect(
        await manager.loadNextChapter(
          current,
          findNextChapter: () => next,
          loadPages: fetch,
        ),
        isFalse,
      );
      request.complete(model([page(next, 0), page(next, 1)]));
      expect(await first, isTrue);
      expect(manager.pages.contains(boundary), isFalse);
      expect(boundary.nextChapterState, isNull);
      expect(boundary.onRetryChapter, isNull);
      expect(manager.pages.map((p) => p.pageIndex), [0, 1, 2]);
      await manager.loadNextChapter(
        current,
        findNextChapter: () => next,
        loadPages: fetch,
      );
      expect(calls, 1);
    },
  );

  for (final empty in [false, true]) {
    test(
      '${empty ? 'empty pages' : 'source RangeError'} remain retryable',
      () async {
        final manager = ChapterPreloadManager()..initialize([page(current, 0)]);
        final pendingRetry = Completer<GetChapterPagesModel>();
        var calls = 0;
        Future<GetChapterPagesModel> fetch(Chapter chapter, bool retry) async {
          calls++;
          if (retry) return pendingRetry.future;
          if (empty) return model([]);
          throw RangeError('source parser failed');
        }

        await manager.loadNextChapter(
          current,
          findNextChapter: () => next,
          loadPages: fetch,
        );
        final boundary = manager.pages.last;
        expect(
          boundary.nextChapterState,
          empty ? NextChapterState.empty : NextChapterState.failed,
        );
        expect(boundary.isLastChapter, isFalse);
        await manager.loadNextChapter(
          current,
          findNextChapter: () => next,
          loadPages: fetch,
        );
        expect(calls, 1); // Scrolling does not loop failed requests.
        final retry = boundary.onRetryChapter!;
        retry();
        retry();
        expect(calls, 2);
        expect(boundary.nextChapterState, NextChapterState.loading);
        expect(boundary.onRetryChapter, isNull);
        pendingRetry.complete(model([page(next, 0)]));
        await Future<void>.delayed(Duration.zero);
        expect(manager.pages, hasLength(2));
        expect(manager.pages.contains(boundary), isFalse);
        expect(manager.pages.last.chapter, same(next));
        expect(boundary.nextChapterState, isNull);
        retry(); // A callback retained by an old widget cannot append twice.
        expect(calls, 2);
      },
    );
  }

  test(
    'only a missing next chapter creates the end-of-manga boundary',
    () async {
      final manager = ChapterPreloadManager()..initialize([page(current, 0)]);
      await manager.loadNextChapter(
        current,
        findNextChapter: () => null,
        loadPages: (_, _) => throw StateError('must not fetch'),
      );
      expect(manager.pages.last.isLastChapter, isTrue);
      expect(manager.pages.last.nextChapterState, isNull);
      await manager.loadNextChapter(
        current,
        findNextChapter: () => throw StateError('already finished'),
        loadPages: (_, _) => throw StateError('must not fetch'),
      );
      expect(manager.pages, hasLength(2));
    },
  );

  test('navigation lookup errors show failure, never end of manga', () async {
    final manager = ChapterPreloadManager()..initialize([page(current, 0)]);
    await manager.loadNextChapter(
      current,
      findNextChapter: () => throw RangeError('catalog changed'),
      loadPages: (_, _) => throw StateError('must not fetch'),
    );
    expect(manager.pages.last.isLastChapter, isFalse);
    expect(manager.pages.last.nextChapterState, NextChapterState.failed);
    expect(manager.pages.last.onRetryChapter, isNotNull);
  });

  test(
    'late completion cannot mutate a disposed or reinitialized reader',
    () async {
      for (final reinitialize in [false, true]) {
        final manager = ChapterPreloadManager()..initialize([page(current, 0)]);
        final pending = Completer<GetChapterPagesModel>();
        final result = manager.loadNextChapter(
          current,
          findNextChapter: () => next,
          loadPages: (_, _) => pending.future,
        );
        await manager.dispose();
        if (reinitialize) manager.initialize([page(next, 0)]);
        var updates = 0;
        manager.onPagesUpdated = () => updates++;
        pending.complete(model([page(next, 0)]));
        expect(await result, isFalse);
        expect(manager.pages, hasLength(reinitialize ? 1 : 0));
        expect(updates, 0);
      }
    },
  );

  test('wrong chapter data cannot be appended to this reader', () async {
    final manager = ChapterPreloadManager()..initialize([page(current, 0)]);
    await manager.loadNextChapter(
      current,
      findNextChapter: () => next,
      loadPages: (_, _) async => model([page(current, 0)]),
    );
    expect(manager.pages, hasLength(2));
    expect(manager.pages.last.nextChapterState, NextChapterState.failed);
  });

  for (final mode in [ReaderMode.webtoon, ReaderMode.ltr]) {
    testWidgets('$mode failure retry remains clickable through tap zones', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final manager = ChapterPreloadManager()..initialize([page(current, 0)]);
      final pending = Completer<GetChapterPagesModel>();
      var calls = 0, overlayTaps = 0;
      await manager.loadNextChapter(
        current,
        findNextChapter: () => next,
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
                final boundary = manager.pages[1];
                return Stack(
                  children: [
                    if (boundary.isTransitionPage)
                      ReaderChapterBoundary(
                        data: boundary,
                        paged: mode == ReaderMode.ltr,
                      )
                    else
                      const Text('Next chapter image'),
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
      expect(find.text('Could not load the next chapter'), findsOneWidget);
      await tester.ensureVisible(find.text('Retry'));
      await tester.pump();
      await tester.tap(find.text('Retry'));
      await tester.pump();
      expect(calls, 2);
      expect(overlayTaps, 0);
      expect(find.text('Loading next chapter…'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
      pending.complete(model([page(next, 0)]));
      await tester.pump();
      expect(find.text('Loading next chapter…'), findsNothing);
      expect(find.text('Next chapter image'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await manager.dispose();
    });
  }
}
