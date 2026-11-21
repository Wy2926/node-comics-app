import 'package:flutter/material.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MobileMangaDetailActionsButton extends StatelessWidget {
  const MobileMangaDetailActionsButton({
    super.key,
    required this.bookTitle,
    required this.localArchive,
    required this.favorite,
    required this.onSelected,
    this.title,
  });

  final String bookTitle;
  final String? title;
  final bool localArchive, favorite;
  final Future<void> Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    return _BookMenu(
      bookTitle: bookTitle,
      tooltip: title ?? l.manga_actions,
      icon: icons.more,
      onSelected: onSelected,
      items: (item) => [
        if (!localArchive) item(0, l.refresh, icons.refresh),
        if (favorite) item(1, l.set_categories, icons.folderOutline),
        if (!localArchive) item(2, l.share, icons.share),
        if (!localArchive || favorite) const PopupMenuDivider(),
        item(3, l.migrate, icons.migrate),
        item(6, l.mass_migration_title, icons.categories),
        if (!localArchive) item(4, l.extension_settings, icons.extensions),
        item(5, l.export_metadata, icons.export),
      ],
    );
  }
}

List<String> downloadRangeLabels(
  AppLocalizations l, {
  required bool episodes,
}) => [
  episodes ? l.next_episode : l.next_chapter,
  episodes ? l.next_5_episodes : l.next_5_chapters,
  episodes ? l.next_10_episodes : l.next_10_chapters,
  episodes ? l.next_25_episodes : l.next_25_chapters,
  episodes ? l.unwatched : l.unread,
  episodes ? l.all_episodes : l.all_chapters,
];

class MobileMangaDownloadActionsButton extends StatelessWidget {
  const MobileMangaDownloadActionsButton({
    super.key,
    required this.bookTitle,
    required this.hasChapters,
    required this.onSelected,
    this.episodes = false,
  });

  final String bookTitle;
  final bool hasChapters, episodes;
  final Future<void> Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    return _BookMenu(
      bookTitle: bookTitle,
      tooltip: l.download,
      icon: icons.download,
      onSelected: onSelected,
      items: (item) => [
        if (!hasChapters)
          PopupMenuItem(
            enabled: false,
            child: Text(episodes ? l.no_result : l.manga_download_scope_empty),
          )
        else
          for (final (i, label) in downloadRangeLabels(
            l,
            episodes: episodes,
          ).indexed) ...[
            if (i == 4) const PopupMenuDivider(),
            item(
              i,
              label,
              i < 4
                  ? icons.nextChapter
                  : i == 4
                  ? icons.unread
                  : icons.chapters,
            ),
          ],
      ],
    );
  }
}

typedef _Item = PopupMenuItem<int> Function(int, String, IconData);

class _BookMenu extends StatefulWidget {
  const _BookMenu({
    required this.bookTitle,
    required this.tooltip,
    required this.icon,
    required this.items,
    required this.onSelected,
  });
  final String bookTitle, tooltip;
  final IconData icon;
  final List<PopupMenuEntry<int>> Function(_Item) items;
  final Future<void> Function(int) onSelected;

  @override
  State<_BookMenu> createState() => _BookMenuState();
}

class _BookMenuState extends State<_BookMenu> {
  bool _busy = false;

  Future<void> _run(int value) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onSelected(value);
    } catch (_) {
      if (mounted) {
        showNodeLaneNotice(
          context.l10n.manga_action_incomplete,
          kind: NodeLaneNoticeKind.error,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => NodeLaneMenuButton<int>(
    tooltip: widget.tooltip,
    icon: widget.icon,
    busy: _busy,
    enabled: !_busy,
    onSelected: _run,
    itemBuilder: (_) => [
      if (widget.bookTitle.isNotEmpty)
        PopupMenuItem<int>(
          enabled: false,
          child: Text(
            widget.bookTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: NodeLaneTokens.of(context).secondary,
          ),
        ),
      ...widget.items(
        (value, label, icon) => nodeLaneSelectionMenuItem(
          context,
          value: value,
          label: label,
          icon: icon,
        ),
      ),
    ],
  );
}
