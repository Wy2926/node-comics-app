import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/controllers/reader_viewport_anchor.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_page_index_math.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

void main() {
  for (final (axis, reverse, doublePage) in [
    (Axis.vertical, false, false),
    (Axis.vertical, false, true),
    (Axis.horizontal, true, false),
  ]) {
    testWidgets(
      'prepend preserves image offset/state: $axis reverse=$reverse double=$doublePage',
      (tester) async {
        tester.view.physicalSize = const Size(400, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        List<UChapDataPreload> chapter(int id, int count) => [
          for (var i = 0; i < count; i++)
            UChapDataPreload(
                Chapter(id: id, mangaId: 1, name: '$id'),
                null,
                null,
                false,
                null,
                i,
                null,
                i,
              )
              ..loadedWidth = i == 3 ? 1600 : 400
              ..loadedHeight = 1100 + i * 130,
        ];
        var pages = chapter(3, 8);
        final scroll = ScrollController();
        final list = ListController();
        VoidCallback? onLayoutChanged;
        final anchors = ReaderViewportAnchorController(
          onLayoutChanged: () => onLayoutChanged?.call(),
        );
        addTearDown(scroll.dispose);
        addTearDown(list.dispose);
        late StateSetter rebuild;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  rebuild = setState;
                  final spreads = ReaderPageIndexMath(
                    isDoublePageActive: doublePage,
                    singleFirst: false,
                    pageCount: pages.length,
                    pages: pages,
                  ).spreads;
                  final indices = <Key, int>{
                    for (var i = 0; i < spreads.length; i++)
                      ValueKey(pages[spreads[i].firstIndex].identity): i,
                  };
                  return SuperListView.builder(
                    controller: scroll,
                    listController: list,
                    scrollDirection: axis,
                    reverse: reverse,
                    cacheExtent: 500,
                    itemCount: spreads.length,
                    // Deliberately inaccurate, as network images are initially unknown.
                    extentEstimation: (_, _) => 270,
                    findChildIndexCallback: (key) => indices[key],
                    itemBuilder: (context, index) {
                      final actual = spreads[index].firstIndex;
                      final page = pages[actual];
                      final extent = page.loadedHeight! / (doublePage ? 2 : 1);
                      Widget item = ReaderViewportItem(
                        key: ValueKey('image-${page.identity}'),
                        identity: page.identity,
                        controller: anchors,
                        child: SizedBox(
                          height: axis == Axis.vertical ? extent : null,
                          width: axis == Axis.horizontal ? extent : null,
                          child: Text(page.identity),
                        ),
                      );
                      if (axis == Axis.vertical) {
                        item = Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (actual > 0 &&
                                pages[actual - 1].chapter?.id !=
                                    page.chapter?.id)
                              const SizedBox(height: 44),
                            item,
                          ],
                        );
                      }
                      return KeyedSubtree(
                        key: ValueKey(page.identity),
                        child: item,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
        scroll.jumpTo(220);
        await tester.pumpAndSettle();
        final anchor = anchors.capture(scroll)!;
        expect(anchor.identity, pages.first.identity);
        expect(anchor.leading, closeTo(-220, 0.1));
        final originalState = tester.state(
          find.byKey(ValueKey('image-${anchor.identity}')),
        );

        List<String> items() => [
          for (final spread in ReaderPageIndexMath(
            isDoublePageActive: doublePage,
            singleFirst: false,
            pageCount: pages.length,
            pages: pages,
          ).spreads)
            pages[spread.firstIndex].identity,
        ];
        for (final id in [2, 1]) {
          final oldItems = items();
          final measuredExtent = list.extentForIndex(
            oldItems.indexOf(anchor.identity),
          );
          rebuild(() => pages = [...chapter(id, id == 2 ? 5 : 3), ...pages]);
          final actual = pages.indexWhere(
            (page) => page.identity == anchor.identity,
          );
          final index = ReaderPageIndexMath(
            isDoublePageActive: doublePage,
            singleFirst: false,
            pageCount: pages.length,
            pages: pages,
          ).actualToPageViewIndex(actual);
          anchors.reindex(oldItems: oldItems, newItems: items(), list: list);
          final restored = anchors.restore(
            anchor,
            index: index,
            list: list,
            scroll: scroll,
            isCurrent: () => true,
          );
          // Sizes must follow the page, not its former global index; otherwise
          // a later slider jump uses an unrelated image's cached height.
          expect(list.extentForIndex(index), measuredExtent);
          for (var frame = 0; frame < 6; frame++) {
            await tester.pump(const Duration(milliseconds: 16));
          }
          await restored;
          final current = anchors.capture(scroll)!;
          expect(current.identity, anchor.identity);
          expect(current.leading, closeTo(anchor.leading, 0.5));
          expect(
            tester.state(find.byKey(ValueKey('image-${anchor.identity}'))),
            same(originalState),
          );
        }
        // A preceding network image can finish decoding after the prepend's
        // first layout. Its final height must not move the held reading point.
        final currentItems = items();
        final anchorIndex = currentItems.indexOf(anchor.identity);
        Future<void>? correction;
        onLayoutChanged = () {
          onLayoutChanged = null;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            correction = anchors.restore(
              anchor,
              index: anchorIndex,
              list: list,
              scroll: scroll,
              isCurrent: () => true,
            );
          });
        };
        final previous = pages.firstWhere(
          (page) => page.identity == currentItems[anchorIndex - 1],
        );
        rebuild(() => previous.loadedHeight = previous.loadedHeight! + 700);
        for (var frame = 0; frame < 6; frame++) {
          await tester.pump(const Duration(milliseconds: 16));
        }
        expect(correction, isNotNull);
        await correction;
        final afterDecode = anchors.capture(scroll)!;
        expect(afterDecode.identity, anchor.identity);
        expect(afterDecode.leading, closeTo(anchor.leading, 0.5));
        expect(
          tester.state(find.byKey(ValueKey('image-${anchor.identity}'))),
          same(originalState),
        );

        // A new reading action cancels a pending correction instead of
        // pulling the reader back to the old anchor on the following frame.
        var current = true;
        final cancelled = anchors.restore(
          anchor,
          index: anchorIndex,
          list: list,
          scroll: scroll,
          isCurrent: () => current,
        );
        current = false;
        scroll.jumpTo(scroll.offset + 100);
        await tester.pumpAndSettle();
        await cancelled;
        expect(
          anchors.capture(scroll)!.leading,
          closeTo(anchor.leading - 100, 0.5),
        );
        await tester.pumpWidget(const SizedBox());
        expect(anchors.capture(scroll), isNull);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
