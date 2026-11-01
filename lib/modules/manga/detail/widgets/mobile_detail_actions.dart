import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
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
          if (favorite || !localArchive) const Divider(),
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
          const Divider(),
          _action(
            l10n.export_metadata,
            NodeLaneIcons.of(context).export,
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
      icon: NodeLaneIcons.of(context).download,
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
}) => Builder(
  builder: (context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: NodeLaneTokens.space16,
    ),
    minTileHeight: 60,
    horizontalTitleGap: 16,
    enabled: onTap != null,
    leading: Icon(icon, size: 28),
    title: Text(
      label,
      style: NodeLaneTokens.of(context).body
          .copyWith(fontWeight: FontWeight.w500),
    ),
    trailing: disclosure
        ? Icon(
            NodeLaneIcons.of(context).forward,
            size: NodeLaneTokens.smallIconSize,
            color: NodeLaneTokens.of(context).muted,
          )
        : null,
    onTap: onTap,
  ),
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
        shape: NodeLaneTokens.detailSheetShape,
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
    final sections = <List<Widget>>[[]];
    for (final action in widget.actions(_close)) {
      if (action is Divider) {
        if (sections.last.isNotEmpty) sections.add([]);
      } else {
        sections.last.add(action);
      }
    }
    return NodeLaneSurface(
      child: NodeLaneSheetSurface(
        grouped: true,
        radius: NodeLaneTokens.detailSheetRadius,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NodeLaneSheetHeading(
                title: widget.title,
                subtitle: widget.bookTitle,
                description: widget.hint,
                detail: true,
                centerTitle: true,
                onClose: _close,
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(
                    NodeLaneTokens.detailGutter,
                    0,
                    NodeLaneTokens.detailGutter,
                    NodeLaneTokens.space12,
                  ),
                  children: [
                    for (final section in sections.where(
                      (items) => items.isNotEmpty,
                    ))
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: NodeLaneTokens.space12,
                        ),
                        child: NodeLaneGroupSurface(
                          child: Column(
                            children: [
                              for (var i = 0; i < section.length; i++) ...[
                                if (i > 0)
                                  Divider(
                                    height: 1,
                                    indent: 16,
                                    endIndent: 16,
                                    thickness: .5,
                                    color: colors.line,
                                  ),
                                section[i],
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
