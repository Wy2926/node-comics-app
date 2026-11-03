import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Holds the selection draft only; its caller owns category reads and writes.
class MobileBookshelfCategorySheet extends StatefulWidget {
  const MobileBookshelfCategorySheet({
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
  State<MobileBookshelfCategorySheet> createState() =>
      _MobileBookshelfCategorySheetState();
}

class _MobileBookshelfCategorySheetState
    extends State<MobileBookshelfCategorySheet> {
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
      child: NodeLaneCatalogSheet(
        title: l10n.set_categories,
        subtitle:
            widget.bookTitle ?? l10n.bookshelf_selected_count(widget.bookCount),
        heightFactor: .78,
        canClose: !_busy && !_leaving,
        onClose: _close,
        bottom: Row(
          children: [
            Expanded(
              child: NodeLaneSecondaryButton(
                onPressed: _busy ? null : _close,
                child: Text(_failed ? l10n.close : l10n.cancel),
              ),
            ),
            if (!_failed) ...[
              const SizedBox(width: NodeLaneTokens.space12),
              Expanded(
                child: FilledButton(
                  onPressed: _ready ? _save : null,
                  child: Text(l10n.save),
                ),
              ),
            ],
          ],
        ),
        child: CustomScrollView(
          slivers: [
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
                        const LinearProgressIndicator()
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
                    return NodeLaneGroupSurface(
                      first: index == 0,
                      last: index == visible.length - 1,
                      child: Column(
                        children: [
                          NodeLaneRow(
                            title: category.name ?? '',
                            checkable: true,
                            selected: _selected.contains(category.id),
                            onTap: !_ready
                                ? null
                                : () => setState(() {
                                    if (!_selected.add(category.id!)) {
                                      _selected.remove(category.id);
                                    }
                                  }),
                          ),
                          if (index < visible.length - 1)
                            const NodeLaneGroupDivider(),
                        ],
                      ),
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
                        onTap: _busy ? null : () => _close(edit: true),
                      ),
                    ],
                    if (_busy) ...[
                      const SizedBox(height: NodeLaneTokens.space16),
                      const LinearProgressIndicator(),
                      const SizedBox(height: NodeLaneTokens.space8),
                      Semantics(
                        liveRegion: true,
                        child: Text(l10n.bookshelf_processing),
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
