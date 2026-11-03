import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/widgets/continue_reader_button.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/widgets/listview_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'mobile_bookshelf_card.dart';

class LibraryListViewWidget extends StatelessWidget {
  final List<Manga> entriesManga;
  final bool language;
  final bool sourceBadge;
  final bool downloadedChapter;
  final Set<int> mangaIdsList;
  final bool continueReaderBtn;
  final bool localSource;
  final Settings settings;
  const LibraryListViewWidget({
    super.key,
    required this.entriesManga,
    required this.language,
    this.sourceBadge = false,
    required this.downloadedChapter,
    required this.continueReaderBtn,
    required this.mangaIdsList,
    required this.localSource,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return SuperListViewWidget(
      itemCount: entriesManga.length,
      itemBuilder: (context, index) {
        final entry = entriesManga[index];
        return Consumer(
          builder: (context, ref, child) {
            final isLongPressed = ref.watch(isLongPressedStateProvider);
            if (isMobile && !isTv) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MobileBookshelfCard(
                  title: entry.name ?? '',
                  subtitle: [
                    if (sourceBadge)
                      (entry.isLocalArchive ?? false)
                          ? context.l10n.local
                          : entry.source ?? '',
                    if (language) entry.lang?.toUpperCase() ?? '',
                  ].where((value) => value.isNotEmpty).join(' · '),
                  image: resolveCoverImage(entry, ref),
                  list: true,
                  first: index == 0,
                  last: index == entriesManga.length - 1,
                  selected: mangaIdsList.contains(entry.id),
                  onTap: () => onTapEntry(
                    isLongPressed: isLongPressed,
                    ref: ref,
                    context: context,
                    entry: entry,
                  ),
                  onLongPress: () =>
                      handleLongOrSecondaryTap(isLongPressed, ref, entry),
                  selectionMode: ref.watch(isLongPressedStateProvider),
                  unreadCount: entry.unreadChaptersCount(settings),
                  unreadLabel: entry.itemType == ItemType.anime
                      ? context.l10n.unwatched
                      : context.l10n.unread,
                  downloadCount: libraryDownloadedCount(
                    entry,
                    ref,
                    enabled: downloadedChapter,
                  ),
                  local: localSource && (entry.isLocalArchive ?? false),
                  continueButton: continueReaderBtn && entry.chapters.isNotEmpty
                      ? ContinueReaderButton(entry: entry, large: true)
                      : null,
                ),
              );
            }
            return Material(
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onTapEntry(
                  isLongPressed: isLongPressed,
                  ref: ref,
                  context: context,
                  entry: entry,
                ),
                onLongPress: () =>
                    handleLongOrSecondaryTap(isLongPressed, ref, entry),
                onSecondaryTap: () =>
                    handleLongOrSecondaryTap(isLongPressed, ref, entry),
                child: Container(
                  color: mangaIdsList.contains(entry.id)
                      ? context.primaryColor.withValues(alpha: 0.4)
                      : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    child: SizedBox(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ── Thumbnail + title ──
                          Expanded(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Material(
                                    child: Ink.image(
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 45,
                                      image: resolveCoverImage(entry, ref),
                                      child: InkWell(
                                        child: Container(
                                          color: mangaIdsList.contains(entry.id)
                                              ? context.primaryColor.withValues(
                                                  alpha: 0.4,
                                                )
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(entry.name!),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── Right-side badge row ──
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LibraryBadgeWidget(
                                entry: entry,
                                showLocal: localSource,
                                showDownloaded: downloadedChapter,
                                settings: settings,
                              ),
                              if (language && (entry.lang?.isNotEmpty ?? false))
                                Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: EntryBadgeChip(
                                    label: entry.lang!.toUpperCase(),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                            ],
                          ),
                          if (continueReaderBtn)
                            ContinueReaderButton(entry: entry),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
