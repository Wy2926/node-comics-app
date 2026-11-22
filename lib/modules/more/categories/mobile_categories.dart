import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/mobile_media_menu.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/modules/widgets/nodelane_progress.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/platform_utils.dart';

Future<void> showCategoryManager(BuildContext context, ItemType itemType) {
  final container = ProviderScope.containerOf(context, listen: false);
  final panel = MobileCategories(
    itemType: itemType,
    onCreate: categoryRepository.create,
    onSave: categoryRepository.save,
    onReorder: categoryRepository.putAll,
    onRemove: (category) async {
      await categoryRepository.remove(category);
      await container
          .read(synchingProvider(syncId: 1).notifier)
          .addChangedPartAsync(
            ActionType.removeCategory,
            category.id,
            '{}',
            true,
            clientId: category.clientId,
          );
    },
  );
  if (NodeLaneBubbleFlow.contains(context)) {
    return NodeLaneBubbleFlow.showPanel(context, panel);
  }
  return showNodeLaneDialog<void>(
    context: context,
    builder: (_) => NodeLaneDialog(child: panel),
  );
}

Category _copy(Category c) =>
    Category.fromJson(c.toJson())..forManga = c.forManga;

/// A single library's cabinet. Row tools expand in the list, keeping its scroll position.
class MobileCategories extends ConsumerStatefulWidget {
  const MobileCategories({
    super.key,
    required this.itemType,
    required this.onCreate,
    required this.onSave,
    required this.onRemove,
    required this.onReorder,
  });
  final ItemType itemType;
  final Future<void> Function(Category) onCreate, onSave, onRemove;
  final Future<void> Function(List<Category>) onReorder;
  @override
  ConsumerState<MobileCategories> createState() => _MobileCategoriesState();
}

class _MobileCategoriesState extends ConsumerState<MobileCategories> {
  bool _busy = false, _failed = false;
  int? _expanded;
  List<Category>? _pendingOrder;
  GetMangaCategorieStreamProvider get _provider =>
      getMangaCategorieStreamProvider(itemType: widget.itemType);

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

  Future<void> _name([Category? category]) => _run(() async {
    await showNodeLaneDialog<bool>(
      context: context,
      builder: (_) => MobileCategoryNameDialog(
        itemType: widget.itemType,
        initialName: category == null ? null : (category.name ?? ''),
        nameExists: (name) =>
            ref
                .read(_provider)
                .asData
                ?.value
                .any(
                  (c) =>
                      (category == null || c.id != category.id) &&
                      c.name == name,
                ) ??
            true,
        onSave: (name) async {
          if (category == null) {
            await widget.onCreate(
              Category(
                name: name,
                forItemType: widget.itemType,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
              ),
            );
          } else {
            // A sync or reorder can change the row while the keyboard is open.
            final latest = ref
                .read(_provider)
                .asData
                ?.value
                .where((c) => c.id == category.id)
                .firstOrNull;
            if (latest == null) throw StateError('Category unavailable');
            if (latest.name != name) {
              await widget.onSave(_copy(latest)..name = name);
            }
          }
        },
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n,
        t = NodeLaneTokens.of(context),
        icons = NodeLaneIcons.of(context);
    final state = ref.watch(_provider);
    final entries =
        _pendingOrder ??
        ([...?state.asData?.value]
          ..sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0)));
    final ready =
        !_busy && !_failed && state.asData != null && !state.isLoading;
    final local = NodeLaneBubbleFlow.contains(context);
    return PopScope(
      canPop: !_busy,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NodeLaneBubbleHeading(
            l.bookshelf_manage_categories,
            subtitle: widget.itemType.localized(l),
            actions: [
              NodeLaneIconButton(
                tooltip: l.add_category,
                icon: icons.add,
                onPressed: ready ? _name : null,
              ),
            ],
            closeButton: NodeLaneIconButton(
              tooltip: local
                  ? MaterialLocalizations.of(context).backButtonTooltip
                  : l.close,
              icon: local ? icons.back : icons.close,
              onPressed: _busy ? null : () => Navigator.maybePop(context),
            ),
          ),
          Flexible(
            child: ReorderableListView.builder(
              key: PageStorageKey(('category-manager', widget.itemType)),
              shrinkWrap: true,
              padding: NodeLaneTokens.bubbleContentPadding,
              buildDefaultDragHandles: false,
              header: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: NodeLaneTokens.space8,
                ),
                child: _failed || state.hasError
                    ? Column(
                        children: [
                          Text(l.failed),
                          TextButton(
                            onPressed: _busy
                                ? null
                                : () => _run(() async {
                                    ref.invalidate(_provider);
                                    await ref.read(_provider.future);
                                    if (mounted) {
                                      setState(() => _failed = false);
                                    }
                                  }),
                            child: Text(l.retry),
                          ),
                        ],
                      )
                    : state.isLoading
                    ? const Center(child: NodeLaneProgress())
                    : Text(
                        entries.isEmpty
                            ? l.edit_categories_description
                            : l.mobile_categories_hint,
                        style: t.readerSecondary,
                      ),
              ),
              itemCount: entries.length,
              itemBuilder: (_, i) {
                final c = entries[i], open = c.id == _expanded;
                return Padding(
                  key: ValueKey('category-${c.id}'),
                  padding: const EdgeInsets.only(bottom: NodeLaneTokens.space8),
                  child: NodeLaneGroupSurface(
                    outlined: true,
                    children: [
                      Row(
                        children: [
                          ReorderableDragStartListener(
                            index: i,
                            enabled: ready,
                            child: SizedBox.square(
                              dimension: NodeLaneTokens.minTapTarget,
                              child: Icon(icons.reorder, color: t.muted),
                            ),
                          ),
                          Expanded(
                            child: Semantics(
                              expanded: open,
                              child: NodeLaneRow(
                                title: c.name ?? '',
                                subtitle: (c.hide ?? false)
                                    ? l.mobile_category_hidden
                                    : null,
                                trailing: Icon(
                                  open ? icons.up : icons.down,
                                  size: NodeLaneTokens.smallIconSize,
                                  color: t.muted,
                                ),
                                enabled: ready,
                                onTap: () => setState(
                                  () => _expanded = open ? null : c.id,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (open) ...[
                        NodeLaneRow(
                          title: l.rename_category,
                          icon: icons.edit,
                          enabled: ready,
                          onTap: () => _name(c),
                        ),
                        NodeLaneSwitchRow(
                          title: l.mobile_category_visible,
                          icon: icons.visible,
                          value: !(c.hide ?? false),
                          onChanged: ready
                              ? (v) => _run(
                                  () => widget.onSave(_copy(c)..hide = !v),
                                )
                              : null,
                        ),
                        NodeLaneSwitchRow(
                          title: l.mobile_category_updates,
                          icon: icons.refresh,
                          value: c.shouldUpdate ?? true,
                          onChanged: ready
                              ? (v) => _run(
                                  () =>
                                      widget.onSave(_copy(c)..shouldUpdate = v),
                                )
                              : null,
                        ),
                        NodeLaneRow(
                          title: l.delete_category,
                          icon: icons.delete,
                          destructive: true,
                          enabled: ready,
                          onTap: () => _run(() async {
                            final confirmed = await showNodeLaneConfirmation(
                              context,
                              title: l.delete_category,
                              message: l.delete_category_msg(c.name ?? ''),
                              confirmLabel: l.delete,
                              destructive: true,
                            );
                            if (!confirmed || !mounted) return;
                            await widget.onRemove(c);
                            if (mounted) setState(() => _expanded = null);
                          }),
                        ),
                      ],
                    ],
                  ),
                );
              },
              onReorderItem: (from, to) {
                if (!ready || from == to) return;
                final next = entries.map(_copy).toList();
                next.insert(to, next.removeAt(from));
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
        ],
      ),
    );
  }
}

class MobileCategoryNameDialog extends StatefulWidget {
  const MobileCategoryNameDialog({
    super.key,
    required this.itemType,
    this.initialName,
    required this.nameExists,
    required this.onSave,
  });
  final ItemType itemType;
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
      _name.text.isNotEmpty &&
      _name.text != widget.initialName &&
      widget.nameExists(_name.text);
  bool get _valid =>
      _name.text.trim().isNotEmpty &&
      _name.text != widget.initialName &&
      !_duplicate;
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || ModalRoute.isCurrentOf(context) != true) return;
    if (!_valid) {
      setState(
        () {},
      ); // A concurrent edit can take the name after the last keystroke.
      return;
    }
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
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final media = widget.itemType.localized(l),
        creating = widget.initialName == null;
    return PopScope(
      canPop: !_busy,
      child: NodeLaneDialog(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(NodeLaneTokens.space20),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: NodeLaneTokens.space16,
            children: [
              // The coloured spine previews the label as it will read on this shelf.
              Semantics(
                label: media,
                child: ExcludeSemantics(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: t.accentSoft,
                      borderRadius: BorderRadius.circular(
                        NodeLaneTokens.coverRadius,
                      ),
                      border: BorderDirectional(
                        start: BorderSide(
                          width: NodeLaneTokens.space4,
                          color: t.accent,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: NodeLaneTokens.groupPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: NodeLaneTokens.space8,
                        children: [
                          Row(
                            children: [
                              Icon(
                                MobileMediaMenu.iconFor(
                                  context,
                                  widget.itemType,
                                ),
                                size: NodeLaneTokens.smallIconSize,
                                color: t.accent,
                              ),
                              const SizedBox(width: NodeLaneTokens.space8),
                              Expanded(
                                child: Text(
                                  media,
                                  style: t.readerSecondary.copyWith(
                                    color: t.accent,
                                  ),
                                ),
                              ),
                              Icon(
                                NodeLaneIcons.of(context).bookmark,
                                size: NodeLaneTokens.smallIconSize,
                                color: t.accent,
                              ),
                            ],
                          ),
                          Text(
                            _name.text.trim().isEmpty
                                ? l.new_category
                                : _name.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: t.readerTitle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              NodeLaneTextField(
                controller: _name,
                label: creating ? l.add_category : l.rename_category,
                hint: l.name,
                autofocus: !isTv,
                enabled: !_busy,
                textInputAction: TextInputAction.done,
                errorText: _duplicate ? l.add_category_error_exist : null,
                onChanged: (_) => setState(() => _failed = false),
                onSubmitted: (_) => _save(),
              ),
              if (_failed)
                Semantics(
                  liveRegion: true,
                  child: Text(
                    l.failed,
                    style: t.readerSecondary.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              NodeLaneModalActions(
                actions: [
                  NodeLaneDialogAction(
                    label: l.cancel,
                    secondary: true,
                    onPressed: _busy
                        ? null
                        : () => Navigator.pop(context, false),
                  ),
                  NodeLaneDialogAction(
                    label: creating ? l.add : l.ok,
                    busy: _busy,
                    onPressed: _busy || !_valid ? null : _save,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
