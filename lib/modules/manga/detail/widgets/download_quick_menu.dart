import 'package:flutter/material.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/services/download_manager/next_downloads.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'mobile_detail_actions.dart';

/// The range is resolved against the current chapter filter at selection time.
class DownloadQuickMenu extends StatelessWidget {
  final Manga manga;
  final bool hasChapters;
  final Future<void> Function(List<Chapter>) onDownload;

  const DownloadQuickMenu({
    super.key,
    required this.manga,
    required this.hasChapters,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (isMobile && !isTv) {
      return MobileMangaDownloadActionsButton(
        key: ValueKey(manga.id),
        episodes: manga.itemType == ItemType.anime,
        bookTitle: manga.name ?? '',
        hasChapters: hasChapters,
        onSelected: _download,
      );
    }
    return NodeLaneBubbleButton(
      icon: const Icon(Icons.download_outlined),
      tooltip: l10n.download,
      itemBuilder: (_) => [
        for (final (i, label) in downloadRangeLabels(
          l10n,
          episodes: manga.itemType == ItemType.anime,
        ).indexed)
          PopupMenuItem<int>(value: i, child: Text(label)),
      ],
      onSelected: _download,
    );
  }

  Future<void> _download(int value) {
    final chapters = manga.getFilteredChapters();
    final chaptersToDownload = value < nextDownloadCounts.length
        ? selectNextDownloads(
            chapters,
            count: nextDownloadCounts[value],
            downloads: downloadRepository.getAll(),
          )
        : chapters
              .where((chapter) => value == 5 || chapter.isRead != true)
              .toList();
    return onDownload(chaptersToDownload);
  }
}
