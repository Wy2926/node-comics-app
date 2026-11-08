import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/modules/more/settings/player/providers/custom_buttons_provider.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/custom_button_repository.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'mobile_custom_button_editor.dart';
import 'mobile_player_action_dialog.dart';

class MobileCustomButtonScreen extends ConsumerStatefulWidget {
  const MobileCustomButtonScreen({super.key, this.repository});
  final CustomButtonRepository? repository;

  @override
  ConsumerState<MobileCustomButtonScreen> createState() =>
      _MobileCustomButtonScreenState();
}

class _MobileCustomButtonScreenState
    extends ConsumerState<MobileCustomButtonScreen> {
  bool _busy = false, _presenting = false, _failed = false;
  bool get _locked => _busy || _presenting;
  CustomButtonRepository get _repository =>
      widget.repository ?? customButtonRepository;

  Future<void> _perform(Future<void> Function() action) async {
    if (_locked) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      await action();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _present(Future<void> Function() action) async {
    if (_locked) return;
    setState(() => _presenting = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _presenting = false);
    }
  }

  Future<void> _edit(CustomButton? original) => _present(() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => MobileCustomButtonEditor(
          button: original,
          onSave: (draft) async {
            final existing = await _repository.findById(original?.id);
            final button = existing == null
                ? CustomButton(
                    title: '',
                    codePress: '',
                    pos: await _repository.count(),
                  )
                : CustomButton.fromJson(existing.toJson());
            await _repository.save(
              button
                ..title = draft.title
                ..codePress = draft.press
                ..codeLongPress = draft.longPress
                ..codeStartup = draft.startup,
            );
          },
        ),
      ),
    );
  });

  Future<void> _delete(CustomButton button) => _present(() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => MobilePlayerActionDialog(
        title: context.l10n.delete,
        message:
            '${button.title ?? ''}\n\n${context.l10n.custom_buttons_delete}',
        confirmLabel: context.l10n.delete,
        destructive: true,
        onConfirm: () => _repository.delete(button.id!),
      ),
    );
  });

  Future<void> _primary(List<CustomButton> buttons, CustomButton selected) =>
      _perform(
        () => _repository.putAll([
          for (final button in buttons)
            CustomButton.fromJson(button.toJson())
              ..isFavourite = button.id == selected.id,
        ]),
      );

  Future<void> _reorder(List<CustomButton> buttons, int from, int to) async {
    if (from == to) return;
    await _perform(() async {
      final reordered = [
        for (final button in buttons) CustomButton.fromJson(button.toJson()),
      ];
      // onReorderItem supplies the destination after removal.
      reordered.insert(to, reordered.removeAt(from));
      for (var index = 0; index < reordered.length; index++) {
        reordered[index].pos = buttons[index].pos;
      }
      await _repository.putAll(reordered);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final buttons = ref.watch(getCustomButtonsStreamProvider);
    return PopScope(
      canPop: !_busy,
      child: NodeLaneSurface(
        child: Scaffold(
          appBar: nodeLaneAppBar(
            context,
            title: l10n.custom_buttons,
            actions: [
              NodeLaneIconButton(
                key: const ValueKey('add-custom-button'),
                tooltip: l10n.add,
                onPressed: _locked ? null : () => _edit(null),
                icon: NodeLaneIcons.of(context).add,
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                if (_busy) const LinearProgressIndicator(),
                if (_failed)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(l10n.failed),
                    ),
                  ),
                Expanded(
                  child: buttons.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, _) => ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Text(l10n.failed),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _locked
                              ? null
                              : () => ref.invalidate(
                                  getCustomButtonsStreamProvider,
                                ),
                          icon: Icon(NodeLaneIcons.of(context).refresh),
                          label: Text(l10n.retry),
                        ),
                      ],
                    ),
                    data: (data) => data.isEmpty
                        ? ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                              MobileSettingsGroup(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Icon(
                                          NodeLaneIcons.of(context).navigation,
                                          size: 32,
                                          color: colors.ink,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          l10n.custom_buttons_empty_hint,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 20),
                                        FilledButton.icon(
                                          onPressed: _locked
                                              ? null
                                              : () => _edit(null),
                                          icon: Icon(
                                            NodeLaneIcons.of(context).add,
                                          ),
                                          label: Text(l10n.custom_buttons_add),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : ReorderableListView.builder(
                            key: const PageStorageKey('mobile-custom-buttons'),
                            padding: NodeLaneTokens.pagePadding,
                            buildDefaultDragHandles: false,
                            itemCount: data.length,
                            onReorderItem: (from, to) =>
                                _reorder(data, from, to),
                            itemBuilder: (context, index) {
                              final button = data[index];
                              return MobileSettingsGroup(
                                key: ValueKey('custom-button-${button.id}'),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      8,
                                      8,
                                      8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                button.title ?? '',
                                                style: colors.readerLabel,
                                              ),
                                            ),
                                            ReorderableDragStartListener(
                                              index: index,
                                              enabled: !_locked,
                                              child: SizedBox(
                                                width: 48,
                                                height: 48,
                                                child: Icon(
                                                  NodeLaneIcons.of(context)
                                                      .reorder,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          button.codePress ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: colors.readerSecondary
                                              .copyWith(
                                                fontFamily: 'monospace',
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 4,
                                          children: [
                                            Semantics(
                                              selected:
                                                  button.isFavourite ?? false,
                                              child: TextButton.icon(
                                                style:
                                                    button.isFavourite == true
                                                    ? TextButton.styleFrom(
                                                        disabledForegroundColor:
                                                            colors.accent,
                                                      )
                                                    : null,
                                                onPressed:
                                                    _locked ||
                                                        button.isFavourite ==
                                                            true
                                                    ? null
                                                    : () => _primary(
                                                        data,
                                                        button,
                                                      ),
                                                icon: Icon(
                                                  button.isFavourite == true
                                                      ? NodeLaneIcons.of(
                                                          context,
                                                        ).favorite
                                                      : NodeLaneIcons.of(
                                                          context,
                                                        ).favorite,
                                                ),
                                                label: Text(
                                                  l10n.custom_button_primary,
                                                ),
                                              ),
                                            ),
                                            NodeLaneIconButton(
                                              tooltip: l10n.edit,
                                              onPressed: _locked
                                                  ? null
                                                  : () => _edit(button),
                                              icon: NodeLaneIcons.of(context)
                                                  .edit,
                                            ),
                                            NodeLaneIconButton(
                                              tooltip: l10n.delete,
                                              onPressed: _locked
                                                  ? null
                                                  : () => _delete(button),
                                              icon: NodeLaneIcons.of(context)
                                                  .delete,
                                              destructive: true,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
