import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
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
    final button = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
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
          entry.chapters.first.pushToReaderView(context);
        }
      },
      child: Container(
        width: large ? 44 : null,
        height: large ? 44 : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(large ? 22 : 5),
          color: large
              ? Theme.of(context).colorScheme.primary
              : context.primaryColor.withValues(alpha: 0.9),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(
            Icons.play_arrow,
            size: 19,
            color: large
                ? Theme.of(context).colorScheme.onPrimary
                : Colors.white,
          ),
        ),
      ),
    );
    return large
        ? Tooltip(
            message: context.l10n.resume,
            child: Semantics(
              button: true,
              label: context.l10n.resume,
              child: button,
            ),
          )
        : button;
  }
}
