import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/design_tokens.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'mobile_reader_chapters.dart';

Widget btnToShowChapterListDialog(
  BuildContext context,
  String title,
  Chapter chapter, {
  void Function(bool)? onChanged,
  Color? iconColor,
  bool labeled = false,
}) {
  if (labeled &&
      isMobile &&
      !isTv &&
      chapter.manga.value?.itemType == ItemType.manga) {
    return MobileReaderChaptersButton(chapter: chapter, onChanged: onChanged);
  }
  Future<void> open() async {
    onChanged?.call(false);
    if (labeled && isMobile && !isTv) {
      await showNodeLaneCatalogSheet<void>(
        context,
        NodeLaneCatalogSheet(
          title: title,
          heightFactor: .75,
          child: ChapterListWidget(chapter: chapter, mobile: true),
        ),
      );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Container(
              width: context.width(0.85),
              constraints: BoxConstraints(maxHeight: context.height(0.8)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.primaryColor.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: context.primaryColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          color: context.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.primaryColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close_rounded,
                            color: context.primaryColor.withValues(alpha: 0.7),
                          ),
                          tooltip: context.l10n.close,
                        ),
                      ],
                    ),
                  ),
                  Flexible(child: ChapterListWidget(chapter: chapter)),
                ],
              ),
            ),
          );
        },
      );
    }
    if (context.mounted) onChanged?.call(true);
  }

  if (labeled) {
    return NodeLaneToolbarAction(
      label: title,
      icon: Icons.format_list_bulleted_rounded,
      onPressed: open,
    );
  }
  return IconButton(
    tooltip: title,
    onPressed: open,
    icon: Icon(Icons.format_list_numbered_outlined, color: iconColor),
  );
}

class ChapterListWidget extends StatefulWidget {
  final Chapter chapter;
  final bool mobile;
  const ChapterListWidget({
    super.key,
    required this.chapter,
    this.mobile = false,
  });

  @override
  State<ChapterListWidget> createState() => _ChapterListWidgetState();
}

class _ChapterListWidgetState extends State<ChapterListWidget> {
  final controller = ScrollController();
  late final chapterList = widget.chapter.manga.value!
      .getSortedFilteredChapters();
  late final currentChapIndex = chapterList.indexWhere(
    (element) =>
        element.name == widget.chapter.name &&
        element.dateUpload == widget.chapter.dateUpload &&
        element.scanlator == widget.chapter.scanlator &&
        element.url == widget.chapter.url,
  );
  @override
  void initState() {
    super.initState();
    _jumpTo();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _jumpTo() async {
    // Wait for the scroll view to layout before jumping
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted ||
        !controller.hasClients ||
        chapterList.isEmpty ||
        currentChapIndex < 0) {
      return;
    }
    controller.jumpTo(
      controller.position.maxScrollExtent /
          chapterList.length *
          currentChapIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (chapterList.isEmpty) return Center(child: Text(context.l10n.no_result));
    return Scrollbar(
      interactive: true,
      thickness: 8,
      radius: const Radius.circular(10),
      controller: controller,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SuperSliverList.builder(
              itemCount: chapterList.length,
              itemBuilder: (context, index) {
                final chapter = chapterList[index];
                final currentChap = index == currentChapIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ChapterListTile(
                    chapter: chapter,
                    currentChap: currentChap,
                    mobile: widget.mobile,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChapterListTile extends StatefulWidget {
  final Chapter chapter;
  final bool currentChap;
  final bool mobile;
  const ChapterListTile({
    super.key,
    required this.chapter,
    required this.currentChap,
    this.mobile = false,
  });

  @override
  State<ChapterListTile> createState() => _ChapterListTileState();
}

class _ChapterListTileState extends State<ChapterListTile> {
  late final chapter = widget.chapter;
  late bool isBookmarked = chapter.isBookmarked!;
  void _openChapter() {
    if (!widget.currentChap) {
      Navigator.pop(context);
      MangaChapterPageGalleryState.setNavigatingToChapter();
      pushReplacementMangaReaderView(context: context, chapter: chapter);
    }
  }

  void _toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    chapterRepository.save(chapter..isBookmarked = isBookmarked);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mobile) {
      final colors = NodeLaneTokens.of(context);
      return Consumer(
        builder: (context, ref, _) {
          final manga = chapter.manga.value!;
          final details = <String>[
            if (!(manga.isLocalArchive ?? false) &&
                (chapter.dateUpload?.isNotEmpty ?? false))
              dateFormat(chapter.dateUpload!, ref: ref, context: context),
            if (chapter.scanlator?.isNotEmpty ?? false) chapter.scanlator!,
            if (!(chapter.isRead ?? false) &&
                (chapter.lastPageRead?.isNotEmpty ?? false) &&
                chapter.lastPageRead != '1')
              manga.itemType == ItemType.anime
                  ? context.l10n.episode_progress(
                      Duration(
                        milliseconds: int.tryParse(chapter.lastPageRead!) ?? 0,
                      ).toString().substringBefore('.'),
                    )
                  : context.l10n.page(
                      manga.itemType == ItemType.manga
                          ? chapter.lastPageRead!
                          : '${((double.tryParse(chapter.lastPageRead!) ?? 0) * 100).toStringAsFixed(0)} %',
                    ),
          ];
          return Material(
            color: widget.currentChap ? colors.accentSoft : colors.surface,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              selected: widget.currentChap,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                chapter.name ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: widget.currentChap
                      ? colors.accent
                      : chapter.isRead!
                      ? colors.muted
                      : colors.ink,
                  fontWeight: widget.currentChap
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
              subtitle: details.isEmpty
                  ? null
                  : Text(
                      details.join(' · '),
                      style: TextStyle(fontSize: 12, color: colors.muted),
                    ),
              onTap: _openChapter,
              trailing: IconButton(
                tooltip: context.l10n.chapter_swipe_toggle_bookmark,
                onPressed: _toggleBookmark,
                icon: Icon(
                  isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isBookmarked ? colors.accent : colors.muted,
                ),
              ),
            ),
          );
        },
      );
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: widget.currentChap
            ? context.primaryColor.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: widget.currentChap
            ? Border.all(
                color: context.primaryColor.withValues(alpha: 0.4),
                width: 1.5,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _openChapter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Chapter indicator
                Container(
                  width: 4,
                  height: 48,
                  decoration: BoxDecoration(
                    color: chapter.isRead!
                        ? context.textColor.withValues(alpha: Alphas.disabled)
                        : context.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                // Chapter content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.name!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: widget.currentChap
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: chapter.isRead!
                              ? context.isLight
                                    ? Colors.black.withValues(alpha: 0.4)
                                    : Colors.white.withValues(alpha: 0.4)
                              : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (!(chapter.manga.value!.isLocalArchive ?? false))
                            Consumer(
                              builder: (context, ref, child) {
                                final dateText =
                                    chapter.dateUpload == null ||
                                        chapter.dateUpload!.isEmpty
                                    ? ""
                                    : dateFormat(
                                        chapter.dateUpload!,
                                        ref: ref,
                                        context: context,
                                      );
                                return dateText.isNotEmpty
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_rounded,
                                            size: 12,
                                            color: context.textColor.withValues(
                                              alpha: Alphas.secondary,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            dateText,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: context.textColor
                                                  .withValues(
                                                    alpha: Alphas.secondary,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                          if (chapter.scanlator != null &&
                              chapter.scanlator!.isNotEmpty)
                            Row(
                              children: [
                                if (!(chapter.manga.value!.isLocalArchive ??
                                        false) &&
                                    (chapter.dateUpload != null &&
                                        chapter.dateUpload!.isNotEmpty))
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Text(
                                      '•',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: context.textColor.withValues(
                                          alpha: Alphas.secondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                Icon(
                                  Icons.group_rounded,
                                  size: 12,
                                  color: context.textColor.withValues(
                                    alpha: Alphas.secondary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    chapter.scanlator!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: context.textColor.withValues(
                                        alpha: Alphas.secondary,
                                      ),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (!chapter.isRead! &&
                          chapter.lastPageRead!.isNotEmpty &&
                          chapter.lastPageRead != "1")
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.bookmark_rounded,
                                size: 12,
                                color: context.primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                chapter.manga.value!.itemType == ItemType.anime
                                    ? context.l10n.episode_progress(
                                        Duration(
                                          milliseconds: int.parse(
                                            chapter.lastPageRead!,
                                          ),
                                        ).toString().substringBefore("."),
                                      )
                                    : context.l10n.page(
                                        chapter.manga.value!.itemType ==
                                                ItemType.manga
                                            ? chapter.lastPageRead!
                                            : "${((double.tryParse(chapter.lastPageRead!) ?? 0) * 100).toStringAsFixed(0)} %",
                                      ),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: context.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Bookmark button
                Consumer(
                  builder: (context, ref, child) => Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _toggleBookmark,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline_rounded,
                          color: isBookmarked
                              ? context.primaryColor
                              : context.textColor.withValues(
                                  alpha: Alphas.disabled,
                                ),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
