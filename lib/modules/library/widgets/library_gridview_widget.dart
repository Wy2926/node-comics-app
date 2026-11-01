import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/widgets/continue_reader_button.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/cover_view_widget.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'mobile_bookshelf_card.dart';

class LibraryGridViewWidget extends StatefulWidget {
  final bool isCoverOnlyGrid;
  final bool isComfortableGrid;
  final Set<int> mangaIdsList;
  final List<Manga> entriesManga;
  final bool language;
  final bool sourceBadge;
  final bool downloadedChapter;
  final bool continueReaderBtn;
  final bool localSource;
  final ItemType itemType;
  final Settings settings;
  const LibraryGridViewWidget({
    super.key,
    required this.entriesManga,
    required this.isCoverOnlyGrid,
    this.isComfortableGrid = false,
    required this.language,
    this.sourceBadge = false,
    required this.downloadedChapter,
    required this.continueReaderBtn,
    required this.mangaIdsList,
    required this.localSource,
    required this.itemType,
    required this.settings,
  });

  @override
  State<LibraryGridViewWidget> createState() => _LibraryGridViewWidgetState();
}

class _LibraryGridViewWidgetState extends State<LibraryGridViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final gridSize = ref.watch(
          libraryGridSizeStateProvider(itemType: widget.itemType),
        );
        if (isMobile && !isTv) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth - NodeLaneTokens.gutter * 2;
              final maxColumns = ((width + NodeLaneTokens.shelfGap) / 104)
                  .floor()
                  .clamp(1, 12);
              final columns = (gridSize ?? 0) == 0
                  ? ((width + NodeLaneTokens.shelfGap) / 194).round().clamp(
                      2,
                      6,
                    )
                  : gridSize!.clamp(1, maxColumns);
              final coverWidth =
                  (width - (columns - 1) * NodeLaneTokens.shelfGap) / columns;
              final coverOnly =
                  widget.isCoverOnlyGrid && !widget.isComfortableGrid;
              final scale = MediaQuery.textScalerOf(context);
              final captionHeight = coverOnly
                  ? 0.0
                  : NodeLaneTokens.space8 +
                        scale.scale(NodeLaneTokens.bookTitleSize) * 2.5 +
                        ((widget.sourceBadge || widget.language)
                            ? scale.scale(NodeLaneTokens.captionSize) * 1.3 + 4
                            : 0);
              return GridView.builder(
                key: PageStorageKey('mobile-shelf-${widget.itemType}'),
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  24,
                ).add(pageBottomInsets(context)),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: NodeLaneTokens.shelfGap,
                  mainAxisSpacing: NodeLaneTokens.space20,
                  mainAxisExtent:
                      coverWidth * NodeLaneTokens.coverAspectRatio +
                      captionHeight,
                ),
                itemCount: widget.entriesManga.length,
                itemBuilder: (context, index) {
                  final entry = widget.entriesManga[index];
                  final subtitle = [
                    if (widget.sourceBadge &&
                        (entry.source?.isNotEmpty ?? false))
                      entry.source!,
                    if (widget.language && (entry.lang?.isNotEmpty ?? false))
                      entry.lang!.toUpperCase(),
                  ].join(' · ');
                  return MobileBookshelfCard(
                    title: entry.name ?? '',
                    subtitle: subtitle,
                    image: resolveCoverImage(entry, ref),
                    selected: widget.mangaIdsList.contains(entry.id),
                    coverOnly: coverOnly,
                    onTap: () => onTapEntry(
                      isLongPressed: ref.read(isLongPressedStateProvider),
                      ref: ref,
                      context: context,
                      entry: entry,
                    ),
                    onLongPress: () => handleLongOrSecondaryTap(
                      ref.read(isLongPressedStateProvider),
                      ref,
                      entry,
                    ),
                    badges: LibraryBadgeWidget(
                      entry: entry,
                      showLocal: widget.localSource,
                      showDownloaded: widget.downloadedChapter,
                      settings: widget.settings,
                    ),
                    continueButton:
                        widget.continueReaderBtn && entry.chapters.isNotEmpty
                        ? ContinueReaderButton(entry: entry, large: true)
                        : null,
                  );
                },
              );
            },
          );
        }
        return GridViewWidget(
          gridSize: gridSize,
          childAspectRatio: widget.isComfortableGrid ? 0.642 : 0.69,
          itemCount: widget.entriesManga.length,
          itemBuilder: (context, index) {
            final entry = widget.entriesManga[index];
            return Consumer(
              builder: (context, ref, child) {
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: CoverViewWidget(
                    // On TV, make the first cover the content's focus target so the
                    // d-pad reliably lands on the grid (not the app bar).
                    autofocus: isTv && index == 0,
                    isLongPressed: widget.mangaIdsList.contains(entry.id),
                    isComfortableGrid: widget.isComfortableGrid,
                    bottomTextWidget: BottomTextWidget(
                      maxLines: 1,
                      text: entry.name!,
                      isComfortableGrid: widget.isComfortableGrid,
                    ),
                    image: resolveCoverImage(entry, ref),
                    onTap: () => onTapEntry(
                      isLongPressed: ref.read(isLongPressedStateProvider),
                      ref: ref,
                      context: context,
                      entry: entry,
                    ),
                    onLongPress: () => handleLongOrSecondaryTap(
                      ref.read(isLongPressedStateProvider),
                      ref,
                      entry,
                    ),
                    onSecondaryTap: () => handleLongOrSecondaryTap(
                      ref.read(isLongPressedStateProvider),
                      ref,
                      entry,
                    ),
                    children: [
                      Stack(
                        children: [
                          // ── Top-left: Local + download count + unread count ──
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: LibraryBadgeWidget(
                                entry: entry,
                                showLocal: widget.localSource,
                                showDownloaded: widget.downloadedChapter,
                                settings: widget.settings,
                              ),
                            ),
                          ),

                          // ── Top-right: Language ──
                          if (widget.language &&
                              (entry.lang?.isNotEmpty ?? false))
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  color: context.themeData.cardColor,
                                  child: EntryBadgeChip(
                                    label: entry.lang!.toUpperCase(),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(3),
                                      bottomLeft: Radius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      if (!widget.isComfortableGrid && !widget.isCoverOnlyGrid)
                        BottomTextWidget(text: entry.name!),

                      if (widget.continueReaderBtn)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(9),
                            child: ContinueReaderButton(entry: entry),
                          ),
                        ),

                      // ── Bottom-left: Source ──
                      if (widget.sourceBadge && (entry.source ?? '').isNotEmpty)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 96),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: context.themeData.cardColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(3),
                                ),
                              ),
                              child: Text(
                                entry.source!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
