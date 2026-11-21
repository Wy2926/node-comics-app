import 'package:flutter/material.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
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
  final Future<void> Function(BuildContext, int) onSelected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, icons = NodeLaneIcons.of(context);
    return _DetailTool(
      label: title ?? l.manga_actions,
      icon: icons.more,
      width: NodeLaneTokens.bubbleFormWidth,
      onSelected: onSelected,
      panel: (finish) => NodeLaneBubbleFlow(
        home: Builder(
          builder: (menu) {
            Widget step(int id, String label, IconData icon) => NodeLaneRow(
              title: label,
              icon: icon,
              compact: true,
              onTap: () async {
                if (ModalRoute.isCurrentOf(menu) != true) return;
                try {
                  await onSelected(menu, id);
                } catch (_) {
                  if (menu.mounted) _failed(menu);
                }
              },
            );
            return _ToolPanel(
              title: title ?? l.manga_actions,
              subtitle: bookTitle,
              children: [
                MobileDetailShortcuts(
                  children: [
                    if (!localArchive)
                      NodeLaneToolbarAction(
                        icon: icons.refresh,
                        label: l.refresh,
                        onPressed: () => finish(0),
                      ),
                    if (!localArchive)
                      NodeLaneToolbarAction(
                        icon: icons.share,
                        label: l.share,
                        onPressed: () => finish(2),
                      ),
                    NodeLaneToolbarAction(
                      icon: icons.export,
                      label: l.export_metadata,
                      onPressed: () => finish(5),
                    ),
                  ],
                ),
                NodeLaneGroupSurface(
                  outlined: true,
                  children: [
                    if (favorite)
                      step(1, l.set_categories, icons.folderOutline),
                    if (!localArchive)
                      step(4, l.extension_settings, icons.extensions),
                    step(3, l.migrate, icons.migrate),
                    step(6, l.mass_migration_title, icons.categories),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

const nextDownloadCounts = [1, 5, 10, 25];

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
    final labels = downloadRangeLabels(l, episodes: episodes);
    return _DetailTool(
      label: l.download,
      icon: icons.download,
      width: NodeLaneTokens.bubbleToolWidth,
      onSelected: (_, value) => onSelected(value),
      panel: (finish) => _ToolPanel(
        title: episodes ? l.download : l.manga_download_scope,
        subtitle: bookTitle,
        children: !hasChapters
            ? [Text(episodes ? l.no_result : l.manga_download_scope_empty)]
            : [
                Text(
                  l.bookshelf_download_count,
                  style: NodeLaneTokens.of(context).readerLabel,
                ),
                LayoutBuilder(
                  builder: (context, box) {
                    const gap = NodeLaneTokens.space8;
                    final columns =
                        (box.maxWidth /
                                MediaQuery.textScalerOf(context)
                                    .scale(NodeLaneTokens.detailToolMinWidth))
                            .floor()
                            .clamp(1, 4);
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (final (i, n) in nextDownloadCounts.indexed)
                          SizedBox(
                            width:
                                (box.maxWidth - gap * (columns - 1)) / columns,
                            child: Tooltip(
                              message: labels[i],
                              excludeFromSemantics: true,
                              child: NodeLaneSecondaryButton(
                                onPressed: () => finish(i),
                                child: Text(
                                  '$n',
                                  semanticsLabel: labels[i],
                                  style: NodeLaneTokens.of(context).readerTitle,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                NodeLaneGroupSurface(
                  outlined: true,
                  children: [
                    for (
                      var i = nextDownloadCounts.length;
                      i < labels.length;
                      i++
                    )
                      NodeLaneRow(
                        title: labels[i],
                        compact: true,
                        icon: i == 4 ? icons.unread : icons.chapters,
                        trailing: const SizedBox.shrink(),
                        onTap: () => finish(i),
                      ),
                  ],
                ),
                if (!episodes)
                  Text(
                    l.manga_download_scope_hint,
                    style: NodeLaneTokens.of(context).readerSecondary,
                  ),
              ],
      ),
    );
  }
}

class _ToolPanel extends StatelessWidget {
  const _ToolPanel({
    required this.title,
    required this.subtitle,
    required this.children,
  });
  final String title, subtitle;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => ListView(
    shrinkWrap: true,
    padding: EdgeInsets.zero,
    children: [
      NodeLaneBubbleHeading(title, subtitle: subtitle),
      Padding(
        padding: NodeLaneTokens.bubbleContentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: NodeLaneTokens.space12,
          children: children,
        ),
      ),
    ],
  );
}

void _failed(BuildContext context) => showNodeLaneNotice(
  context.l10n.manga_action_incomplete,
  kind: NodeLaneNoticeKind.error,
);

class _DetailTool extends StatefulWidget {
  const _DetailTool({
    required this.label,
    required this.icon,
    required this.width,
    required this.panel,
    required this.onSelected,
  });
  final String label;
  final IconData icon;
  final double width;
  final Widget Function(ValueChanged<int>) panel;
  final Future<void> Function(BuildContext, int) onSelected;
  @override
  State<_DetailTool> createState() => _DetailToolState();
}

class _DetailToolState extends State<_DetailTool> {
  bool _open = false, _busy = false;
  Future<void> _show() async {
    if (_open || ModalRoute.isCurrentOf(context) != true) return;
    _open = true;
    try {
      final value = await showNodeLaneBubble<int>(
        context,
        label: widget.label,
        width: widget.width,
        child: Builder(
          builder: (bubble) => widget.panel((value) {
            if (ModalRoute.isCurrentOf(bubble) == true) {
              Navigator.pop(bubble, value);
            }
          }),
        ),
      );
      if (value == null || !mounted) return;
      setState(() => _busy = true);
      await widget.onSelected(context, value);
    } catch (_) {
      if (mounted) _failed(context);
    } finally {
      _open = false;
      if (mounted && _busy) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => NodeLaneIconButton(
    tooltip: widget.label,
    icon: widget.icon,
    onPressed: _show,
    busy: _busy,
  );
}
