import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/categories/mobile_categories.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_selection_bar.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

/// Action identities stay with the existing library owner.
class MobileBookshelfMenu extends StatelessWidget {
  const MobileBookshelfMenu({
    super.key,
    required this.hasEntries,
    required this.ignoreFilters,
    required this.onSelected,
    required this.itemType,
  });
  final bool hasEntries, ignoreFilters;
  final ItemType itemType;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n, icons = NodeLaneIcons.of(context);
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        NodeLaneBubbleHeading(l10n.bookshelf_actions),
        if (hasEntries) ...[
          NodeLaneRow(
            title: l10n.bookshelf_select_entries,
            icon: icons.selected,
            onTap: () => onSelected(6),
          ),
          NodeLaneRow(
            title: l10n.open_random_entry,
            icon: icons.shuffle,
            onTap: () => onSelected(1),
          ),
        ],
        NodeLaneRow(
          title: l10n.bookshelf_manage_categories,
          icon: icons.categories,
          onTap: () => showCategoryManager(context, itemType),
        ),
        if (itemType == ItemType.anime)
          NodeLaneRow(
            title: l10n.torrent_stream,
            icon: icons.webLink,
            onTap: () => onSelected(3),
          ),
        NodeLaneSwitchRow(
          title: l10n.bookshelf_ignore_filters,
          value: ignoreFilters,
          onChanged: (_) => onSelected(4),
        ),
      ],
    );
  }
}

/// Temporary contextual toolbar, using the same action control as the reader.
class MobileBookshelfSelectionBar extends StatelessWidget {
  const MobileBookshelfSelectionBar({
    super.key,
    required this.hasSelection,
    this.anime = false,
    required this.onCategories,
    required this.onRead,
    required this.onMore,
  });
  final bool hasSelection, anime;
  final VoidCallback onCategories, onRead;
  final ValueChanged<int> onMore;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n, icons = NodeLaneIcons.of(context);
    return NodeLaneSelectionBar<int>(
      moreLabel: l10n.more,
      onMore: onMore,
      actions: [
        NodeLaneToolbarAction(
          label: l10n.categories,
          icon: icons.folderOutline,
          enabled: hasSelection,
          onPressed: onCategories,
        ),
        NodeLaneToolbarAction(
          label: anime ? l10n.bookshelf_mark_watched : l10n.bookshelf_mark_read,
          icon: anime ? icons.anime : icons.manga,
          enabled: hasSelection,
          onPressed: onRead,
        ),
      ],
      moreItems: [
        nodeLaneSelectionMenuItem(
          context,
          value: 0,
          label: anime
              ? l10n.bookshelf_mark_unwatched
              : l10n.bookshelf_mark_unread,
          icon: icons.unread,
          enabled: hasSelection,
        ),
        nodeLaneSelectionMenuItem(
          context,
          value: 2,
          label: l10n.migrate,
          icon: icons.migrate,
          enabled: hasSelection,
        ),
        const PopupMenuDivider(),
        nodeLaneSelectionMenuItem(
          context,
          value: 3,
          label: l10n.remove,
          icon: icons.delete,
          destructive: true,
          enabled: hasSelection,
        ),
      ],
    );
  }
}

/// Only collects removal choices and presents the existing operation's state.
/// A failed operation may have partially written, so it cannot be resubmitted
/// from this confirmation. Cancelling keeps the owner's selection intact.
class MobileBookshelfRemovePage extends StatefulWidget {
  const MobileBookshelfRemovePage({
    super.key,
    required this.titles,
    required this.hasLocalArchives,
    required this.onRemove,
  });
  final List<String> titles;
  final bool hasLocalArchives;
  final Future<void> Function(bool fromLibrary, bool downloads) onRemove;

  @override
  State<MobileBookshelfRemovePage> createState() =>
      _MobileBookshelfRemovePageState();
}

class _MobileBookshelfRemovePageState extends State<MobileBookshelfRemovePage> {
  bool _fromLibrary = false, _downloads = false, _busy = false, _failed = false;

  Future<void> _submit() async {
    if (_busy ||
        _failed ||
        widget.titles.isEmpty ||
        (!_fromLibrary && !_downloads)) {
      return;
    }
    setState(() => _busy = true);
    try {
      await widget.onRemove(_fromLibrary, _downloads);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _failed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), l10n = context.l10n;
    return PopScope(
      canPop: !_busy,
      child: MobileBrowsePage.form(
        title: l10n.remove,
        leading: NodeLaneCloseButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: _busy ? null : () => Navigator.pop(context, false),
        ),
        bottomAction: _failed
            ? null
            : NodeLaneModalActions(
                actions: [
                  NodeLaneDialogAction(
                    label: l10n.remove,
                    destructive: true,
                    busy: _busy,
                    onPressed:
                        widget.titles.isNotEmpty && (_fromLibrary || _downloads)
                        ? _submit
                        : null,
                  ),
                ],
              ),
        body: ListView(
          padding: const EdgeInsets.all(NodeLaneTokens.gutter),
          children: [
            Text(
              l10n.bookshelf_selected_count(widget.titles.length),
              style: t.readerLabel,
            ),
            const SizedBox(height: NodeLaneTokens.space8),
            NodeLaneDisclosure(
              title: l10n.bookshelf_view_selection,
              icon: NodeLaneIcons.of(context).chapters,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: NodeLaneTokens.rowHeight * 3,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.titles.length,
                  itemBuilder: (_, i) => NodeLaneRow(title: widget.titles[i]),
                ),
              ),
            ),
            const SizedBox(height: NodeLaneTokens.space16),
            if (_failed)
              NodeLaneNotice(
                message: l10n.bookshelf_remove_incomplete,
                kind: NodeLaneNoticeKind.error,
                contained: false,
              )
            else ...[
              NodeLaneGroupSurface(
                children: [
                  NodeLaneRow(
                    title: l10n.bookshelf_remove_library,
                    subtitle: l10n.bookshelf_remove_library_hint,
                    checkable: true,
                    selected: _fromLibrary,
                    onTap: _busy
                        ? null
                        : () => setState(() => _fromLibrary = !_fromLibrary),
                  ),
                  NodeLaneRow(
                    title: l10n.bookshelf_remove_downloads,
                    subtitle: l10n.bookshelf_remove_downloads_hint,
                    checkable: true,
                    selected: _downloads,
                    onTap: _busy
                        ? null
                        : () => setState(() => _downloads = !_downloads),
                  ),
                ],
              ),
              if (widget.hasLocalArchives)
                Padding(
                  padding: const EdgeInsets.only(top: NodeLaneTokens.space12),
                  child: Text(
                    l10n.bookshelf_remove_local_files_hint,
                    style: t.readerSecondary,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
