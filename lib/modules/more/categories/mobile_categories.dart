import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

Category _copyCategory(Category category) =>
    Category.fromJson(category.toJson())..forManga = category.forManga;

class MobileCategories extends ConsumerStatefulWidget {
  const MobileCategories({
    super.key,
    required this.types,
    required this.initialType,
    required this.editing,
    required this.onCreate,
    required this.onSave,
    required this.onRemove,
    required this.onReorder,
  });
  final List<ItemType> types;
  final ItemType? initialType;
  final bool editing;
  final Future<void> Function(Category) onCreate, onSave, onRemove;
  final Future<void> Function(List<Category>) onReorder;

  @override
  ConsumerState<MobileCategories> createState() => _MobileCategoriesState();
}

class _MobileCategoriesState extends ConsumerState<MobileCategories> {
  late ItemType? _type = widget.types.contains(widget.initialType)
      ? widget.initialType
      : widget.types.firstOrNull;
  bool _busy = false, _failed = false;
  List<Category>? _pendingOrder;

  Future<void> _run(Future<void> Function() operation) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await operation();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _pendingOrder = null;
        });
      }
    }
  }

  Future<void> _refresh() async {
    final type = _type;
    if (type == null) return;
    await _run(() async {
      final provider = getMangaCategorieStreamProvider(itemType: type);
      ref.invalidate(provider);
      await ref.read(provider.future);
      if (mounted) setState(() => _failed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final type = _type;
    final categories = type == null
        ? null
        : ref.watch(getMangaCategorieStreamProvider(itemType: type));
    final entries =
        _pendingOrder ??
        ([...?categories?.asData?.value]
          ..sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0)));
    final ready =
        !_busy &&
        !_failed &&
        categories?.asData != null &&
        !categories!.isLoading;
    return NodeLaneSurface(
      child: PopScope(
        canPop: !_busy,
        child: Scaffold(
          appBar: nodeLaneAppBar(
            context,
            title: widget.editing ? l10n.edit_categories : l10n.categories,
            actions: [
              NodeLaneIconButton(
                tooltip: l10n.add_category,
                icon: icons.add,
                onPressed: !ready || type == null
                    ? null
                    : () => _run(() async {
                        await showDialog<bool>(
                          context: context,
                          builder: (_) => MobileCategoryNameDialog(
                            nameExists: (name) =>
                                ref
                                    .read(
                                      getMangaCategorieStreamProvider(
                                        itemType: type,
                                      ),
                                    )
                                    .asData
                                    ?.value
                                    .any((c) => c.name == name) ??
                                true,
                            onSave: (name) => widget.onCreate(
                              Category(
                                name: name,
                                forItemType: type,
                                updatedAt:
                                    DateTime.now().millisecondsSinceEpoch,
                              ),
                            ),
                          ),
                        );
                      }),
              ),
            ],
            busy: _busy && (ModalRoute.isCurrentOf(context) ?? true),
          ),
          body: SafeArea(
            top: false,
            child: AbsorbPointer(
              absorbing: _busy,
              child: ReorderableListView.builder(
                key: PageStorageKey('mobile-categories-$type'),
                padding: const EdgeInsets.fromLTRB(
                  NodeLaneTokens.gutter,
                  NodeLaneTokens.space8,
                  NodeLaneTokens.gutter,
                  NodeLaneTokens.space24,
                ),
                buildDefaultDragHandles: false,
                header: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.types.length > 1) ...[
                      NodeLaneSegments<ItemType>(
                        value: type ?? widget.types.first,
                        segments: [
                          for (final value in widget.types)
                            ButtonSegment(
                              value: value,
                              label: Text(value.localized(l10n)),
                            ),
                        ],
                        onChanged: (value) {
                          if (_busy) return;
                          setState(() {
                            _type = value;
                            _failed = false;
                          });
                        },
                      ),
                      const SizedBox(height: NodeLaneTokens.space20),
                    ],
                    if (_failed || categories?.hasError == true) ...[
                      Text(l10n.failed),
                      TextButton(
                        onPressed: _busy ? null : _refresh,
                        child: Text(l10n.retry),
                      ),
                    ] else if (categories?.isLoading == true)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (type == null)
                      Text(l10n.no_result)
                    else if (entries.isEmpty)
                      Text(l10n.edit_categories_description)
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          l10n.mobile_categories_hint,
                          style: t.readerSecondary,
                        ),
                      ),
                  ],
                ),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final category = entries[index];
                  return Padding(
                    key: ValueKey('category-${category.id}'),
                    padding: const EdgeInsets.only(
                      bottom: NodeLaneTokens.space8,
                    ),
                    child: NodeLaneGroupSurface(
                      child: Row(
                        children: [
                          ReorderableDragStartListener(
                            index: index,
                            enabled: ready,
                            child: SizedBox(
                              width: NodeLaneTokens.minTapTarget,
                              height: NodeLaneTokens.catalogRowHeight,
                              child: Icon(
                                icons.reorder,
                                color: t.muted,
                                size: NodeLaneTokens.iconSize,
                              ),
                            ),
                          ),
                          Expanded(
                            child: NodeLaneRow(
                              title: category.name ?? '',
                              subtitle: (category.hide ?? false)
                                  ? l10n.mobile_category_hidden
                                  : l10n.mobile_category_visible,
                              onTap: !ready
                                  ? null
                                  : () => _run(() async {
                                      await Navigator.push<void>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MobileCategoryDetails(
                                            category: category,
                                            onSave: widget.onSave,
                                            onRemove: widget.onRemove,
                                          ),
                                        ),
                                      );
                                    }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                onReorderItem: (oldIndex, newIndex) {
                  if (!ready || oldIndex == newIndex) return;
                  final next = entries.map(_copyCategory).toList();
                  next.insert(newIndex, next.removeAt(oldIndex));
                  final now = DateTime.now().millisecondsSinceEpoch;
                  for (var i = 0; i < next.length; i++) {
                    next[i].pos = i;
                    next[i].updatedAt = now;
                  }
                  _pendingOrder = next;
                  _run(() => widget.onReorder(next));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileCategoryDetails extends ConsumerStatefulWidget {
  const MobileCategoryDetails({
    super.key,
    required this.category,
    required this.onSave,
    required this.onRemove,
  });
  final Category category;
  final Future<void> Function(Category) onSave, onRemove;

  @override
  ConsumerState<MobileCategoryDetails> createState() =>
      _MobileCategoryDetailsState();
}

class _MobileCategoryDetailsState extends ConsumerState<MobileCategoryDetails> {
  bool _busy = false, _failed = false;

  Future<void> _run(Future<void> Function() operation) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await operation();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final provider = getMangaCategorieStreamProvider(
      itemType: widget.category.forItemType,
    );
    final state = ref.watch(provider);
    final category = state.asData?.value
        .where((c) => c.id == widget.category.id)
        .firstOrNull;
    return NodeLaneSurface(
      child: PopScope(
        canPop: !_busy,
        child: Scaffold(
          appBar: nodeLaneAppBar(
            context,
            title: l10n.category,
            busy: _busy && (ModalRoute.isCurrentOf(context) ?? true),
          ),
          body: SafeArea(
            top: false,
            child: AbsorbPointer(
              absorbing: _busy,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  NodeLaneTokens.gutter,
                  NodeLaneTokens.space8,
                  NodeLaneTokens.gutter,
                  NodeLaneTokens.space24,
                ),
                children: [
                  if (_failed || state.hasError) ...[
                    Text(l10n.failed),
                    TextButton(
                      onPressed: () => _run(() async {
                        ref.invalidate(provider);
                        await ref.read(provider.future);
                        if (mounted) setState(() => _failed = false);
                      }),
                      child: Text(l10n.retry),
                    ),
                  ],
                  if (state.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (category == null)
                    Text(l10n.no_result)
                  else ...[
                    Text(category.name ?? '', style: t.readerTitle),
                    const SizedBox(height: 24),
                    AbsorbPointer(
                      absorbing: _failed || state.hasError,
                      child: Column(
                        children: [
                          NodeLaneGroupSurface(
                            children: [
                              NodeLaneRow(
                                title: l10n.rename_category,
                                icon: icons.edit,
                                onTap: () => _run(() async {
                                  await showDialog<bool>(
                                    context: context,
                                    builder: (_) => MobileCategoryNameDialog(
                                      initialName: category.name ?? '',
                                      nameExists: (name) =>
                                          ref
                                              .read(provider)
                                              .asData
                                              ?.value
                                              .any(
                                                (c) =>
                                                    c.id != category.id &&
                                                    c.name == name,
                                              ) ??
                                          true,
                                      onSave: (name) async {
                                        final current = ref
                                            .read(provider)
                                            .asData
                                            ?.value
                                            .where((c) => c.id == category.id)
                                            .firstOrNull;
                                        if (current == null) {
                                          throw StateError(
                                            'Category unavailable',
                                          );
                                        }
                                        if (current.name == name) return;
                                        await widget.onSave(
                                          _copyCategory(current)..name = name,
                                        );
                                      },
                                    ),
                                  );
                                }),
                              ),
                              NodeLaneRow(
                                title: l10n.mobile_category_visible,
                                icon: icons.visible,
                                onTap: () => _run(
                                  () => widget.onSave(
                                    _copyCategory(category)
                                      ..hide = !(category.hide ?? false),
                                  ),
                                ),
                                trailing: NodeLaneSwitch(
                                  value: !(category.hide ?? false),
                                  onChanged: (value) => _run(
                                    () => widget.onSave(
                                      _copyCategory(category)..hide = !value,
                                    ),
                                  ),
                                ),
                              ),
                              NodeLaneRow(
                                title: l10n.mobile_category_updates,
                                icon: icons.refresh,
                                onTap: () => _run(
                                  () => widget.onSave(
                                    _copyCategory(category)
                                      ..shouldUpdate =
                                          !(category.shouldUpdate ?? true),
                                  ),
                                ),
                                trailing: NodeLaneSwitch(
                                  value: category.shouldUpdate ?? true,
                                  onChanged: (value) => _run(
                                    () => widget.onSave(
                                      _copyCategory(category)
                                        ..shouldUpdate = value,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: NodeLaneTokens.space24),
                          NodeLaneRow.card(
                            title: l10n.delete_category,
                            icon: icons.delete,
                            destructive: true,
                            onTap: () => _run(() async {
                              final confirmed = await showNodeLaneConfirmation(
                                context,
                                title: l10n.delete_category,
                                message: l10n.delete_category_msg(
                                  category.name ?? '',
                                ),
                                confirmLabel: l10n.delete,
                                destructive: true,
                              );
                              if (!confirmed || !context.mounted) return;
                              await widget.onRemove(category);
                              if (context.mounted) Navigator.pop(context);
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileCategoryNameDialog extends StatefulWidget {
  const MobileCategoryNameDialog({
    super.key,
    this.initialName,
    required this.nameExists,
    required this.onSave,
  });
  final String? initialName;
  final bool Function(String) nameExists;
  final Future<void> Function(String) onSave;

  @override
  State<MobileCategoryNameDialog> createState() =>
      _MobileCategoryNameDialogState();
}

class _MobileCategoryNameDialogState extends State<MobileCategoryNameDialog> {
  late final _name = TextEditingController(text: widget.initialName ?? '');
  bool _busy = false, _failed = false;
  bool get _duplicate =>
      _name.text != widget.initialName && widget.nameExists(_name.text);
  bool get _valid =>
      _name.text.isNotEmpty && _name.text != widget.initialName && !_duplicate;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !_valid) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      await widget.onSave(_name.text);
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
    final l10n = context.l10n;
    final t = NodeLaneTokens.of(context);
    return PopScope(
      canPop: !_busy,
      child: NodeLaneAlertDialog(
        scrollable: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            NodeLaneTextField(
              controller: _name,
              label: widget.initialName == null
                  ? l10n.add_category
                  : l10n.rename_category,
              enabled: !_busy,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() => _failed = false),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 12),
            Text(
              _duplicate
                  ? l10n.add_category_error_exist
                  : l10n.category_name_required,
              style: t.readerSecondary.copyWith(
                color: _duplicate
                    ? Theme.of(context).colorScheme.error
                    : t.muted,
              ),
            ),
            if (_failed) Text(l10n.failed),
          ],
        ),
        actions: [
          NodeLaneDialogAction(
            label: l10n.cancel,
            secondary: true,
            onPressed: _busy ? null : () => Navigator.pop(context, false),
          ),
          NodeLaneDialogAction(
            label: widget.initialName == null ? l10n.add : l10n.ok,
            busy: _busy,
            onPressed: _busy || !_valid ? null : _save,
          ),
        ],
      ),
    );
  }
}
