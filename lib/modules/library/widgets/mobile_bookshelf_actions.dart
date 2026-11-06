import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_glass_surface.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

/// Action identities stay with the existing library owner.
class MobileBookshelfMenu extends StatefulWidget {
  const MobileBookshelfMenu({
    super.key,
    required this.hasEntries,
    required this.updating,
    required this.ignoreFilters,
    required this.onSelected,
    this.anime = false,
  });
  final bool hasEntries, updating, ignoreFilters, anime;
  final ValueChanged<int> onSelected;
  @override
  State<MobileBookshelfMenu> createState() => _MobileBookshelfMenuState();
}

class _MobileBookshelfMenuState extends State<MobileBookshelfMenu> {
  bool _searchOptions = false;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n, icons = NodeLaneIcons.of(context);
    return NodeLaneCatalogSheet(
      title: l10n.bookshelf_actions,
      heightFactor: .66,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: NodeLaneTokens.gutter),
        children: [
          NodeLaneGroupSurface(
            children: [
              NodeLaneRow(
                enabled: widget.updating || widget.hasEntries,
                title: widget.updating
                    ? l10n.bookshelf_stop_update
                    : l10n.update_library,
                icon: widget.updating ? icons.stop : icons.refresh,
                onTap: widget.updating || widget.hasEntries
                    ? () => widget.onSelected(widget.updating ? 5 : 0)
                    : null,
              ),
              NodeLaneRow(
                title: l10n.bookshelf_select_entries,
                enabled: widget.hasEntries,
                icon: icons.selected,
                onTap: widget.hasEntries ? () => widget.onSelected(6) : null,
              ),
            ],
          ),
          const SizedBox(height: NodeLaneTokens.space16),
          NodeLaneGroupSurface(
            children: [
              NodeLaneRow(
                title: l10n.open_random_entry,
                enabled: widget.hasEntries,
                icon: icons.shuffle,
                onTap: widget.hasEntries ? () => widget.onSelected(1) : null,
              ),
              NodeLaneRow(
                title: l10n.bookshelf_manage_categories,
                icon: icons.categories,
                onTap: () => widget.onSelected(7),
              ),
              if (widget.anime)
                NodeLaneRow(
                  title: l10n.torrent_stream,
                  icon: icons.webLink,
                  onTap: () => widget.onSelected(3),
                ),
            ],
          ),
          const SizedBox(height: NodeLaneTokens.space16),
          NodeLaneGroupSurface(
            children: [
              NodeLaneRow(
                title: l10n.bookshelf_search_options,
                subtitle: l10n.bookshelf_ignore_filters,
                icon: icons.search,
                trailing: RotatedBox(
                  quarterTurns: _searchOptions ? 2 : 0,
                  child: Icon(icons.down, size: NodeLaneTokens.smallIconSize),
                ),
                onTap: () => setState(() => _searchOptions = !_searchOptions),
              ),
              if (_searchOptions)
                NodeLaneRow(
                  title: l10n.bookshelf_ignore_filters,
                  subtitle: l10n.bookshelf_ignore_filters_hint,
                  trailing: NodeLaneSwitch(
                    value: widget.ignoreFilters,
                    onChanged: (_) => widget.onSelected(4),
                  ),
                  onTap: () => widget.onSelected(4),
                ),
            ],
          ),
        ],
      ),
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
    Widget menuLabel(String label, IconData icon, {bool destructive = false}) =>
        Row(
          children: [
            Icon(
              icon,
              size: NodeLaneTokens.smallIconSize,
              color: destructive ? Theme.of(context).colorScheme.error : null,
            ),
            const SizedBox(width: NodeLaneTokens.space12),
            Flexible(
              child: Text(
                label,
                style: destructive
                    ? TextStyle(color: Theme.of(context).colorScheme.error)
                    : null,
              ),
            ),
          ],
        );
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: NodeLaneGlassSurface(
          elevated: true,
          borderRadius: BorderRadius.circular(NodeLaneTokens.capsuleRadius),
          child: Row(
            children: [
              Expanded(
                child: NodeLaneToolbarAction(
                  label: l10n.categories,
                  icon: icons.folderOutline,
                  enabled: hasSelection,
                  onPressed: onCategories,
                ),
              ),
              Expanded(
                child: NodeLaneToolbarAction(
                  label: anime
                      ? l10n.bookshelf_mark_watched
                      : l10n.bookshelf_mark_read,
                  icon: anime ? icons.anime : icons.manga,
                  enabled: hasSelection,
                  onPressed: onRead,
                ),
              ),
              Expanded(
                child: PopupMenuButton<int>(
                  useRootNavigator: true,
                  tooltip: l10n.more,
                  onSelected: onMore,
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 0,
                      enabled: hasSelection,
                      height: NodeLaneTokens.menuItemHeight,
                      child: menuLabel(
                        anime
                            ? l10n.bookshelf_mark_unwatched
                            : l10n.bookshelf_mark_unread,
                        icons.unread,
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      height: NodeLaneTokens.menuItemHeight,
                      child: menuLabel(
                        l10n.bookshelf_invert_selection,
                        icons.selected,
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      enabled: hasSelection,
                      height: NodeLaneTokens.menuItemHeight,
                      child: menuLabel(l10n.migrate, icons.migrate),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 3,
                      enabled: hasSelection,
                      height: NodeLaneTokens.menuItemHeight,
                      child: menuLabel(
                        l10n.remove,
                        icons.delete,
                        destructive: true,
                      ),
                    ),
                  ],
                  child: NodeLaneToolbarAction(
                    label: l10n.more,
                    icon: icons.more,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Only collects removal choices and presents the existing operation's state.
/// A failed operation may have partially written, so it cannot be resubmitted
/// from this confirmation. Cancelling keeps the owner's selection intact.
class MobileBookshelfRemoveSheet extends StatefulWidget {
  const MobileBookshelfRemoveSheet({
    super.key,
    required this.titles,
    required this.hasLocalArchives,
    required this.onRemove,
  });
  final List<String> titles;
  final bool hasLocalArchives;
  final Future<void> Function(bool fromLibrary, bool downloads) onRemove;

  @override
  State<MobileBookshelfRemoveSheet> createState() =>
      _MobileBookshelfRemoveSheetState();
}

class _MobileBookshelfRemoveSheetState
    extends State<MobileBookshelfRemoveSheet> {
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
      child: NodeLaneCatalogSheet(
        title: l10n.remove,
        subtitle: l10n.bookshelf_selected_count(widget.titles.length),
        heightFactor: .9,
        fitContent: true,
        canClose: !_busy,
        onClose: () => Navigator.pop(context, false),
        bottom: _failed
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
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(
            horizontal: NodeLaneTokens.gutter,
          ),
          children: [
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
