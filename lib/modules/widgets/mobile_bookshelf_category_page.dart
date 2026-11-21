import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_progress.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Holds the selection draft only; its caller owns category reads and writes.
class MobileBookshelfCategoryPage extends StatefulWidget {
  const MobileBookshelfCategoryPage({
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
  State<MobileBookshelfCategoryPage> createState() =>
      _MobileBookshelfCategoryPageState();
}

class _MobileBookshelfCategoryPageState
    extends State<MobileBookshelfCategoryPage> {
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
    if (!_ready || ModalRoute.isCurrentOf(context) != true) return;
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

  void _close() {
    if (_busy || _leaving || ModalRoute.isCurrentOf(context) != true) return;
    _leaving = true;
    Navigator.pop(context, false);
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
      child: MobileBrowsePage.form(
        title: l10n.set_categories,
        leading: NodeLaneCloseButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: _busy || _leaving ? null : _close,
        ),
        bottomAction: _failed
            ? null
            : NodeLaneModalActions(
                actions: [
                  NodeLaneDialogAction(
                    label: l10n.save,
                    busy: _busy,
                    onPressed: _ready ? _save : null,
                  ),
                ],
              ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(NodeLaneTokens.gutter),
              sliver: SliverToBoxAdapter(
                child: Text(
                  widget.bookTitle ??
                      l10n.bookshelf_selected_count(widget.bookCount),
                  style: colors.readerLabel,
                ),
              ),
            ),
            if (_failed ||
                widget.readFailed ||
                widget.loading ||
                visible.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(NodeLaneTokens.gutter),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      if (_failed)
                        Text(
                          l10n.bookshelf_categories_incomplete,
                          style: colors.readerSecondary.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      else if (widget.loading)
                        const NodeLaneProgress()
                      else if (widget.readFailed) ...[
                        Text(l10n.failed),
                        TextButton(
                          onPressed: widget.onRetry,
                          child: Text(l10n.retry),
                        ),
                      ] else
                        Text(
                          categories.isEmpty
                              ? l10n.library_no_category_exist
                              : l10n.bookshelf_categories_none_visible,
                          style: colors.readerSecondary,
                        ),
                    ],
                  ),
                ),
              ),
            if (!_failed && !widget.readFailed && !widget.loading)
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: NodeLaneTokens.gutter,
                ),
                sliver: SliverList.builder(
                  itemCount: visible.length,
                  itemBuilder: (_, index) {
                    final category = visible[index];
                    return NodeLaneRow.card(
                      title: category.name ?? '',
                      checkable: true,
                      selected: _selected.contains(category.id),
                      first: index == 0,
                      last: index == visible.length - 1,
                      minHeight: NodeLaneTokens.rowHeight,
                      enabled: _ready,
                      onTap: () => setState(() {
                        if (!_selected.add(category.id!)) {
                          _selected.remove(category.id);
                        }
                      }),
                    );
                  },
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.all(NodeLaneTokens.gutter),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!_failed) ...[
                      Text(
                        widget.isBulk
                            ? l10n.bookshelf_categories_replace
                            : l10n.bookshelf_categories_hint,
                        style: colors.readerSecondary,
                      ),
                      if (retainsHidden)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: NodeLaneTokens.space8,
                          ),
                          child: Text(
                            l10n.bookshelf_categories_hidden,
                            style: colors.readerSecondary,
                          ),
                        ),
                      const SizedBox(height: NodeLaneTokens.space16),
                      NodeLaneRow.card(
                        title: l10n.bookshelf_manage_categories,
                        icon: NodeLaneIcons.of(context).categories,
                        onTap: _busy || _leaving ? null : widget.onEdit,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
