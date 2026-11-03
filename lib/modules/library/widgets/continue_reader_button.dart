import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class ContinueReaderButton extends ConsumerWidget {
  final Manga entry;
  final bool large;

  const ContinueReaderButton({
    super.key,
    required this.entry,
    this.large = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The button looks the same regardless of history, so the last-read
    // chapter is resolved on tap — a live watch per grid cell made scrolling
    // large libraries churn dozens of query subscriptions.
    void resume() {
      final incognitoMode = ref.read(incognitoModeStateProvider);
      final history = incognitoMode
          ? null
          : historyRepository.findByMangaId(entry.id!);
      if (history != null && !history.chapter.isLoaded) {
        history.chapter.loadSync();
      }
      final lastReadChapter = history?.chapter.value;
      if (lastReadChapter != null) {
        lastReadChapter.pushToReaderView(context);
      } else {
        final firstChapter =
            entry.getChapterListForReading().firstOrNull ??
            entry.chapters.firstOrNull;
        firstChapter?.pushToReaderView(context);
      }
    }

    if (large) {
      return NodeLaneIconButton(
        icon: entry.itemType == ItemType.anime
            ? NodeLaneIcons.of(context).anime
            : NodeLaneIcons.of(context).manga,
        tooltip: context.l10n.resume,
        active: true,
        onPressed: entry.chapters.isEmpty ? null : resume,
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: resume,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: context.primaryColor.withValues(alpha: 0.9),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(Icons.play_arrow, size: 19, color: Colors.white),
        ),
      ),
    );
  }
}
