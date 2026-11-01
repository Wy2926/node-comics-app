import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/detail/chapter_bulk_actions.dart';
import 'package:mangayomi/modules/widgets/bottom_select_bar.dart';
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
    final colors = NodeLaneTokens.of(context);
    final l10n = context.l10n;
    final singleBookmark =
        selected.length == 1 && selected.first.isBookmarked == true;
    final markRead = bulkChapterTargetReadState(selected);
    BottomSelectButton button(
      MobileChapterAction action,
      String label,
      IconData icon, {
      bool destructive = false,
    }) => BottomSelectButton(
      label: label,
      icon: Icon(
        icon,
        color: destructive ? Theme.of(context).colorScheme.error : colors.ink,
      ),
      onPressed: busy || selected.isEmpty ? null : () => onAction(action),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (visible && busy && ModalRoute.of(context)?.isCurrent == true)
          const LinearProgressIndicator(minHeight: 2),
        BottomSelectBar(
          isVisible: visible,
          respectSafeArea: true,
          backgroundColor: colors.surface,
          actions: [
            button(
              MobileChapterAction.bookmark,
              selected.length == 1
                  ? singleBookmark
                        ? l10n.chapter_remove_bookmark
                        : l10n.chapter_add_bookmark
                  : l10n.chapter_swipe_toggle_bookmark,
              singleBookmark
                  ? Icons.bookmark_remove_outlined
                  : Icons.bookmark_add_outlined,
            ),
            button(
              MobileChapterAction.read,
              markRead ? l10n.bookshelf_mark_read : l10n.bookshelf_mark_unread,
              markRead ? Icons.done_all : Icons.remove_done,
            ),
            if (hasFollowing)
              button(
                MobileChapterAction.readFollowing,
                l10n.chapter_read_following,
                Icons.playlist_add_check,
              ),
            if (canDownload)
              button(
                MobileChapterAction.download,
                l10n.download,
                Icons.download_outlined,
              ),
            if (canDelete)
              button(
                MobileChapterAction.delete,
                l10n.delete,
                Icons.delete_outline,
                destructive: true,
              ),
          ],
        ),
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
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(l10n.chapter_selected_count(widget.titles.length)),
                children: [
                  SizedBox(
                    height: (widget.titles.length * 52.0).clamp(0, 156),
                    child: ListView.builder(
                      key: const ValueKey('chapter-delete-titles'),
                      itemCount: widget.titles.length,
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(widget.titles[index]),
                      ),
                    ),
                  ),
                ],
              ),
              if (_failed)
                Text(
                  l10n.chapter_action_incomplete,
                  style: TextStyle(color: error),
                )
              else if (_busy) ...[
                const LinearProgressIndicator(),
                const SizedBox(height: 8),
                Text(l10n.bookshelf_processing),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _busy ? null : () => _close(false),
            child: Text(_failed ? l10n.close : l10n.cancel),
          ),
          if (!_failed)
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: _busy || widget.titles.isEmpty ? null : _submit,
              child: Text(l10n.delete),
            ),
        ],
      ),
    );
  }
}
