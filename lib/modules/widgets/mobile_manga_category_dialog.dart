import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Holds the selection draft only; its caller owns category reads and writes.
class MobileMangaCategoryDialog extends StatefulWidget {
  const MobileMangaCategoryDialog({
    super.key,
    required this.categories,
    required this.initialIds,
    required this.bookCount,
    required this.isBulk,
    required this.showHidden,
    required this.loading,
    required this.readFailed,
    required this.onRetry,
    required this.onEdit,
    required this.onSave,
    this.bookTitle,
  });
  final List<Category>? categories;
  final Iterable<int> initialIds;
  final int bookCount;
  final bool isBulk, showHidden, loading, readFailed;
  final String? bookTitle;
  final VoidCallback onRetry, onEdit;
  final Future<void> Function(List<int>) onSave;
  @override
  State<MobileMangaCategoryDialog> createState() =>
      _MobileMangaCategoryDialogState();
}

class _MobileMangaCategoryDialogState extends State<MobileMangaCategoryDialog> {
  late final _selected = widget.initialIds.toSet();
  bool _busy = false, _failed = false, _leaving = false;
  bool get _ready =>
      !_busy &&
      !_failed &&
      !_leaving &&
      !widget.loading &&
      !widget.readFailed &&
      widget.categories != null &&
      widget.bookCount > 0;

  Future<void> _save() async {
    if (!_ready) return;
    // Bulk replacement uses the union of visible categories. A single saved
    // comic retains its existing hidden categories, as in the original dialog.
    final selected = widget.categories!
        .where(
          (category) =>
              category.id != null &&
              (!widget.isBulk || !(category.hide ?? false)),
        )
        .where((category) => _selected.contains(category.id))
        .map((category) => category.id!)
        .toList(growable: false);
    setState(() => _busy = true);
    try {
      await widget.onSave(selected);
      if (mounted) {
        _leaving = true;
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _failed = true;
        });
      }
    }
  }

  void _close({bool edit = false}) {
    if (_busy || _leaving) return;
    _leaving = true;
    if (edit) {
      widget.onEdit();
    } else {
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final categories = [...?widget.categories]
      ..sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));
    final visible = categories
        .where(
          (category) =>
              category.id != null &&
              (widget.showHidden || !(category.hide ?? false)),
        )
        .toList();
    final retainsHidden =
        !widget.isBulk &&
        !widget.showHidden &&
        categories.any(
          (category) =>
              (category.hide ?? false) && _selected.contains(category.id),
        );
    return PopScope(
      canPop: !_busy,
      child: NodeLaneDialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: NodeLaneTokens.dialogMaxWidth,
            maxHeight: MediaQuery.sizeOf(context).height * .8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  l10n.set_categories,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
              ),
              Flexible(
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              widget.bookTitle ??
                                  l10n.bookshelf_selected_count(
                                    widget.bookCount,
                                  ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.isBulk
                                  ? l10n.bookshelf_categories_replace
                                  : l10n.bookshelf_categories_hint,
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.muted,
                              ),
                            ),
                            if (retainsHidden) ...[
                              const SizedBox(height: 8),
                              Text(
                                l10n.bookshelf_categories_hidden,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colors.muted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (_failed)
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            l10n.bookshelf_categories_incomplete,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                    if (!_failed && widget.readFailed)
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Text(l10n.failed),
                            TextButton(
                              onPressed: widget.loading ? null : widget.onRetry,
                              child: Text(l10n.retry),
                            ),
                          ],
                        ),
                      ),
                    if (!_failed && widget.loading)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: LinearProgressIndicator(),
                        ),
                      ),
                    if (!_failed &&
                        !widget.readFailed &&
                        !widget.loading &&
                        visible.isEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            categories.isEmpty
                                ? l10n.library_no_category_exist
                                : l10n.bookshelf_categories_none_visible,
                          ),
                        ),
                      ),
                    if (!_failed && !widget.readFailed)
                      SliverList.builder(
                        itemCount: visible.length,
                        itemBuilder: (_, index) {
                          final category = visible[index];
                          return CheckboxListTile.adaptive(
                            title: Text(category.name ?? ''),
                            value: _selected.contains(category.id),
                            onChanged: !_ready
                                ? null
                                : (value) => setState(() {
                                    value!
                                        ? _selected.add(category.id!)
                                        : _selected.remove(category.id);
                                  }),
                          );
                        },
                      ),
                  ],
                ),
              ),
              if (_busy) ...[
                const LinearProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(l10n.bookshelf_processing),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (!_failed)
                      TextButton(
                        onPressed: _busy ? null : () => _close(edit: true),
                        child: Text(l10n.bookshelf_manage_categories),
                      ),
                    TextButton(
                      onPressed: _busy ? null : _close,
                      child: Text(_failed ? l10n.close : l10n.cancel),
                    ),
                    if (!_failed)
                      FilledButton(
                        onPressed: _ready ? _save : null,
                        child: Text(l10n.save),
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
