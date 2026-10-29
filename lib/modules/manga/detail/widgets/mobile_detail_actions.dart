import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

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
      icon: Theme.of(context).platform == TargetPlatform.iOS
          ? Icons.more_horiz
          : Icons.more_vert,
      onSelected: onSelected,
      menu: _MangaActionSheet(
        title: l10n.manga_actions,
        bookTitle: bookTitle,
        actions: (choose) => [
          if (!localArchive)
            _action(l10n.refresh, Icons.refresh, () => choose(0)),
          if (favorite)
            _action(
              l10n.set_categories,
              Icons.folder_outlined,
              () => choose(1),
            ),
          if (!localArchive)
            _action(l10n.share, Icons.ios_share_outlined, () => choose(2)),
          if (favorite || !localArchive) const Divider(),
          _action(l10n.migrate, Icons.swap_horiz_rounded, () => choose(3)),
          _action(
            l10n.mass_migration_title,
            Icons.drive_file_move_outline,
            () => choose(6),
          ),
          if (!localArchive)
            _action(
              l10n.extension_settings,
              Icons.extension_outlined,
              () => choose(4),
            ),
          const Divider(),
          _action(
            l10n.export_metadata,
            Icons.file_upload_outlined,
            () => choose(5),
          ),
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
      icon: Icons.download_outlined,
      onSelected: onSelected,
      menu: _MangaActionSheet(
        title: l10n.manga_download_scope,
        bookTitle: bookTitle,
        hint: hasChapters
            ? l10n.manga_download_scope_hint
            : l10n.manga_download_scope_empty,
        actions: (choose) => [
          for (var index = 0; index < labels.length; index++) ...[
            if (index == 4) const Divider(),
            _action(
              labels[index],
              index < 4
                  ? Icons.skip_next_outlined
                  : index == 4
                  ? Icons.markunread_outlined
                  : Icons.library_books_outlined,
              hasChapters ? () => choose(index) : null,
            ),
          ],
        ],
      ),
    );
  }
}

Widget _action(String label, IconData icon, VoidCallback? onTap) => ListTile(
  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
  minTileHeight: 56,
  enabled: onTap != null,
  leading: Icon(icon),
  title: Text(label),
  onTap: onTap,
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
      final value = await showModalBottomSheet<int>(
        context: context,
        useRootNavigator: true,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .85,
        ),
        builder: (_) => menu,
      );
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
  Widget build(BuildContext context) => IconButton(
    tooltip: widget.tooltip,
    onPressed: _opened ? null : _open,
    icon: _working
        ? SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              semanticsLabel: context.l10n.bookshelf_processing,
            ),
          )
        : Icon(widget.icon),
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
  final List<Widget> Function(ValueChanged<int>) actions;

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
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      namesRoute: true,
                      header: true,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: colors.ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.close,
                    onPressed: _close,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 12),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                    child: Text(
                      widget.bookTitle,
                      style: TextStyle(color: colors.muted, fontSize: 14),
                    ),
                  ),
                  if (widget.hint case final hint?)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Text(
                        hint,
                        style: TextStyle(color: colors.muted, fontSize: 13),
                      ),
                    ),
                  ...widget.actions(_close),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
