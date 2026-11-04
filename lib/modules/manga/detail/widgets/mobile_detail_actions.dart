import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

/// Presents existing detail action values; dispatch remains with the owner.
class MobileMangaDetailActionsButton extends StatelessWidget {
  const MobileMangaDetailActionsButton({
    super.key,
    required this.bookTitle,
    required this.localArchive,
    required this.favorite,
    required this.onSelected,
  });

  final String bookTitle;
  final bool localArchive, favorite;
  final Future<void> Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _MangaMenuButton(
      tooltip: l10n.manga_actions,
      icon: NodeLaneIcons.of(context).more,
      onSelected: onSelected,
      menu: _MangaActionSheet(
        title: l10n.manga_actions,
        bookTitle: bookTitle,
        actions: (choose) => [
          [
            if (!localArchive)
              _action(
                l10n.refresh,
                NodeLaneIcons.of(context).refresh,
                () => choose(0),
              ),
            if (favorite)
              _action(
                l10n.set_categories,
                NodeLaneIcons.of(context).folderOutline,
                () => choose(1),
                disclosure: true,
              ),
            if (!localArchive)
              _action(
                l10n.share,
                NodeLaneIcons.of(context).share,
                () => choose(2),
              ),
          ],
          [
            _action(
              l10n.migrate,
              NodeLaneIcons.of(context).migrate,
              () => choose(3),
              disclosure: true,
            ),
            _action(
              l10n.mass_migration_title,
              NodeLaneIcons.of(context).categories,
              () => choose(6),
              disclosure: true,
            ),
            if (!localArchive)
              _action(
                l10n.extension_settings,
                NodeLaneIcons.of(context).extensions,
                () => choose(4),
                disclosure: true,
              ),
          ],
          [
            _action(
              l10n.export_metadata,
              NodeLaneIcons.of(context).export,
              () => choose(5),
            ),
          ],
        ],
      ),
    );
  }
}

/// Collects a download range only, without querying chapters or queue state.
class MobileMangaDownloadActionsButton extends StatelessWidget {
  const MobileMangaDownloadActionsButton({
    super.key,
    required this.bookTitle,
    required this.hasChapters,
    required this.onSelected,
  });

  final String bookTitle;
  final bool hasChapters;
  final Future<void> Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = [
      l10n.next_chapter,
      l10n.next_5_chapters,
      l10n.next_10_chapters,
      l10n.next_25_chapters,
      l10n.unread,
      l10n.all_chapters,
    ];
    return _MangaMenuButton(
      tooltip: l10n.download,
      icon: NodeLaneIcons.of(context).download,
      onSelected: onSelected,
      menu: _MangaActionSheet(
        title: l10n.manga_download_scope,
        bookTitle: bookTitle,
        hint: hasChapters
            ? l10n.manga_download_scope_hint
            : l10n.manga_download_scope_empty,
        actions: (choose) => [
          for (final indices in [
            const [0, 1, 2, 3],
            const [4, 5],
          ])
            [
              for (final index in indices)
                _action(
                  labels[index],
                  index < 4
                      ? NodeLaneIcons.of(context).forward
                      : index == 4
                      ? NodeLaneIcons.of(context).unread
                      : NodeLaneIcons.of(context).manga,
                  hasChapters ? () => choose(index) : null,
                ),
            ],
        ],
      ),
    );
  }
}

Widget _action(
  String label,
  IconData icon,
  VoidCallback? onTap, {
  bool disclosure = false,
}) => NodeLaneRow(
  title: label,
  icon: icon,
  enabled: onTap != null,
  onTap: onTap,
  trailing: disclosure ? null : const SizedBox.shrink(),
);

/// Only owns presentation and in-flight UI state. The callback keeps the
/// existing navigation, file picker, export and download implementations.
class _MangaMenuButton extends StatefulWidget {
  const _MangaMenuButton({
    required this.tooltip,
    required this.icon,
    required this.menu,
    required this.onSelected,
  });

  final String tooltip;
  final IconData icon;
  final Widget menu;
  final Future<void> Function(int) onSelected;

  @override
  State<_MangaMenuButton> createState() => _MangaMenuButtonState();
}

class _MangaMenuButtonState extends State<_MangaMenuButton> {
  bool _opened = false, _working = false;

  Future<void> _open() async {
    if (_opened) return;
    // Keep the action paired with the book for which this menu was opened.
    final action = widget.onSelected;
    final menu = widget.menu;
    setState(() => _opened = true);
    try {
      final value = await showNodeLaneCatalogSheet<int>(context, menu);
      if (!mounted || value == null) return;
      setState(() => _working = true);
      await action(value);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.manga_action_incomplete)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _opened = false;
          _working = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => NodeLaneIconButton(
    tooltip: widget.tooltip,
    onPressed: _opened ? null : _open,
    icon: widget.icon,
    busy: _working,
  );
}

class _MangaActionSheet extends StatefulWidget {
  const _MangaActionSheet({
    required this.title,
    required this.bookTitle,
    required this.actions,
    this.hint,
  });

  final String title, bookTitle;
  final String? hint;
  final List<List<Widget>> Function(ValueChanged<int>) actions;

  @override
  State<_MangaActionSheet> createState() => _MangaActionSheetState();
}

class _MangaActionSheetState extends State<_MangaActionSheet> {
  bool _leaving = false;

  void _close([int? value]) {
    if (!mounted || _leaving || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    _leaving = true;
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) => NodeLaneCatalogSheet(
    title: widget.title,
    subtitle: [
      widget.bookTitle,
      widget.hint,
    ].whereType<String>().where((text) => text.isNotEmpty).join('\n'),
    onClose: _close,
    heightFactor: .85,
    fitContent: true,
    child: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: NodeLaneTokens.gutter),
      children: [
        for (final section
            in widget.actions(_close).where((items) => items.isNotEmpty))
          NodeLaneGroupSurface(
            margin: const EdgeInsets.only(bottom: NodeLaneTokens.space16),
            children: section,
          ),
      ],
    ),
  );
}
