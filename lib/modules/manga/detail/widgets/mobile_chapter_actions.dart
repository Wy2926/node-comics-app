import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/detail/chapter_bulk_actions.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

enum MobileChapterAction { bookmark, read, readFollowing, download, delete }

/// Keep route completion independent of the detail widget: removing the last
/// local chapter can dispose that widget before this modal returns.
Future<void> showMobileChapterDeleteConfirmation({
  required BuildContext context,
  required String bookTitle,
  required List<String> titles,
  required bool localArchive,
  required bool lastChapters,
  required Future<bool> Function() onDelete,
  required VoidCallback onDeleted,
}) async {
  final navigator = Navigator.of(context);
  final detailRoute = ModalRoute.of(context);
  var removedComic = false;
  final confirmed = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    builder: (_) => MobileChapterDeleteDialog(
      bookTitle: bookTitle,
      titles: titles,
      localArchive: localArchive,
      lastChapters: lastChapters,
      onDelete: () async {
        removedComic = await onDelete();
      },
    ),
  );
  if (confirmed != true || !navigator.mounted) return;
  onDeleted();
  if (removedComic && detailRoute?.isCurrent == true) navigator.pop();
}

/// Presents the existing selection actions without owning chapter state.
class MobileChapterSelectionBar extends StatelessWidget {
  const MobileChapterSelectionBar({
    super.key,
    required this.selected,
    required this.visible,
    required this.busy,
    required this.hasFollowing,
    required this.canDownload,
    required this.canDelete,
    required this.onAction,
  });

  final List<Chapter> selected;
  final bool visible, busy, hasFollowing, canDownload, canDelete;
  final ValueChanged<MobileChapterAction> onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n, icons = NodeLaneIcons.of(context);
    final singleBookmark =
        selected.length == 1 && selected.first.isBookmarked == true;
    final markRead = bulkChapterTargetReadState(selected);
    if (!visible) return const SizedBox.shrink();
    final enabled = !busy && selected.isNotEmpty;
    return NodeLaneSelectionBar<MobileChapterAction>(
      busy: busy,
      moreLabel: l10n.more,
      onMore: onAction,
      actions: [
        NodeLaneToolbarAction(
          label: selected.length == 1
              ? singleBookmark
                    ? l10n.chapter_remove_bookmark
                    : l10n.chapter_add_bookmark
              : l10n.chapter_swipe_toggle_bookmark,
          icon: singleBookmark ? icons.bookmark : icons.bookmarkOutline,
          enabled: enabled,
          onPressed: () => onAction(MobileChapterAction.bookmark),
        ),
        NodeLaneToolbarAction(
          label: markRead
              ? l10n.bookshelf_mark_read
              : l10n.bookshelf_mark_unread,
          icon: markRead ? icons.manga : icons.unread,
          enabled: enabled,
          onPressed: () => onAction(MobileChapterAction.read),
        ),
      ],
      moreItems: [
        if (hasFollowing)
          nodeLaneSelectionMenuItem(
            context,
            value: MobileChapterAction.readFollowing,
            label: l10n.chapter_read_following,
            icon: icons.chapters,
            enabled: enabled,
          ),
        if (canDownload)
          nodeLaneSelectionMenuItem(
            context,
            value: MobileChapterAction.download,
            label: l10n.download,
            icon: icons.download,
            enabled: enabled,
          ),
        if (canDelete) ...[
          const PopupMenuDivider(),
          nodeLaneSelectionMenuItem(
            context,
            value: MobileChapterAction.delete,
            label: l10n.delete,
            icon: icons.delete,
            destructive: true,
            enabled: enabled,
          ),
        ],
      ],
    );
  }
}

/// The owner supplies a fixed, already scoped list and performs the deletion.
class MobileChapterDeleteDialog extends StatefulWidget {
  const MobileChapterDeleteDialog({
    super.key,
    required this.bookTitle,
    required this.titles,
    required this.localArchive,
    required this.lastChapters,
    required this.onDelete,
  });

  final String bookTitle;
  final List<String> titles;
  final bool localArchive, lastChapters;
  final Future<void> Function() onDelete;

  @override
  State<MobileChapterDeleteDialog> createState() =>
      _MobileChapterDeleteDialogState();
}

class _MobileChapterDeleteDialogState extends State<MobileChapterDeleteDialog> {
  bool _busy = false, _failed = false, _leaving = false;

  void _close(bool result) {
    if (_leaving || ModalRoute.of(context)?.isCurrent != true) return;
    _leaving = true;
    Navigator.pop(context, result);
  }

  Future<void> _submit() async {
    if (!mounted ||
        _busy ||
        _failed ||
        _leaving ||
        widget.titles.isEmpty ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    setState(() => _busy = true);
    try {
      await widget.onDelete();
      if (mounted) _close(true);
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
    final l10n = context.l10n;
    final error = Theme.of(context).colorScheme.error;
    return PopScope(
      canPop: !_busy,
      child: NodeLaneAlertDialog(
        scrollable: true,
        title: Text(
          widget.localArchive
              ? l10n.chapter_delete_records
              : l10n.bookshelf_remove_downloads,
        ),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.bookTitle,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                widget.localArchive
                    ? l10n.chapter_delete_local_hint
                    : l10n.bookshelf_remove_downloads_hint,
              ),
              if (widget.localArchive && widget.lastChapters) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.chapter_delete_last_hint,
                  style: TextStyle(color: error),
                ),
              ],
              const SizedBox(height: 8),
              NodeLaneDisclosure(
                title: l10n.chapter_selected_count(widget.titles.length),
                icon: NodeLaneIcons.of(context).chapters,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: NodeLaneTokens.rowHeight * 3,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    key: const ValueKey('chapter-delete-titles'),
                    itemCount: widget.titles.length,
                    itemBuilder: (_, index) =>
                        NodeLaneRow(title: widget.titles[index]),
                  ),
                ),
              ),
              if (_failed) ...[
                const SizedBox(height: NodeLaneTokens.space16),
                NodeLaneNotice(
                  message: l10n.chapter_action_incomplete,
                  kind: NodeLaneNoticeKind.error,
                  contained: false,
                ),
              ],
            ],
          ),
        ),
        actions: [
          NodeLaneDialogAction(
            label: _failed ? l10n.close : l10n.cancel,
            secondary: true,
            onPressed: _busy ? null : () => _close(false),
          ),
          if (!_failed)
            NodeLaneDialogAction(
              label: l10n.delete,
              destructive: true,
              busy: _busy,
              onPressed: _busy || widget.titles.isEmpty ? null : _submit,
            ),
        ],
      ),
    );
  }
}
