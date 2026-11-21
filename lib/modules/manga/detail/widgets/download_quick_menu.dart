import 'package:flutter/material.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/services/download_manager/next_downloads.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'mobile_detail_actions.dart';

/// The range is resolved against the current chapter filter at selection time.
class DownloadQuickMenu extends StatelessWidget {
  final ItemType itemType;
  final Manga manga;
  final bool hasChapters;
  final Future<void> Function(BuildContext context, List<Chapter> chapters)
  onDownload;

  const DownloadQuickMenu({
    super.key,
    required this.itemType,
    required this.manga,
    this.hasChapters = true,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (isMobile && !isTv) {
      return MobileMangaDownloadActionsButton(
        key: ValueKey(manga.id),
        episodes: itemType == ItemType.anime,
        bookTitle: manga.name ?? '',
        hasChapters: hasChapters,
        onSelected: (value) => _download(context, value),
      );
    }
    return PopupMenuButton(
      popUpAnimationStyle: popupAnimationStyle,
      icon: const Icon(Icons.download_outlined),
      tooltip: l10n.download,
      itemBuilder: (_) => [
        for (final (i, label) in downloadRangeLabels(
          l10n,
          episodes: itemType == ItemType.anime,
        ).indexed)
          PopupMenuItem<int>(value: i, child: Text(label)),
      ],
      onSelected: (value) => _download(context, value),
    );
  }

  Future<void> _download(BuildContext context, int value) async {
    final chapters = manga.getFilteredChapters();
    final chaptersToDownload = value <= 3
        ? selectNextDownloads(
            chapters,
            count: [1, 5, 10, 25][value],
            downloads: downloadRepository.getAll(),
          )
        : chapters
              .where((chapter) => value == 5 || chapter.isRead != true)
              .toList();
    await onDownload(context, chaptersToDownload);
  }
}
