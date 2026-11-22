import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/widgets/nodelane_progress.dart';
import 'package:mangayomi/modules/widgets/nodelane_setting_bubble.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

class TranslationModelRow extends ConsumerStatefulWidget {
  const TranslationModelRow({super.key});

  @override
  ConsumerState<TranslationModelRow> createState() =>
      _TranslationModelRowState();
}

class _TranslationModelRowState extends ConsumerState<TranslationModelRow> {
  late final service = ref.read(translationServiceProvider);
  late final ready = service.initialize();

  Future<void> _choose(BuildContext anchor) async {
    final account = service.accountId;
    final choice = await NodeLaneBubbleFlow.edit<SettingOption<String?>>(
      anchor,
      title: context.l10n.translation_model,
      body: (_, finish) => _ModelChoices(service: service, choose: finish),
    );
    if (!mounted ||
        account != service.accountId ||
        choice == null ||
        choice.value == service.model?.id) {
      return;
    }
    final id = choice.value;
    await service.setModel(id == null ? null : (id: id, name: choice.label));
    if (mounted && service.error != null) {
      showNodeLaneNotice(service.error!, kind: NodeLaneNoticeKind.error);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: ready,
    builder: (context, init) => ListenableBuilder(
      listenable: service,
      builder: (context, _) => NodeLaneRow(
        title: context.l10n.translation_model,
        value: service.model?.name ?? context.l10n.default0,
        icon: NodeLaneIcons.of(context).adjustments,
        subtitle: init.hasError
            ? context.l10n.settings_translation_init_error
            : null,
        enabled:
            init.connectionState == ConnectionState.done &&
            !init.hasError &&
            !service.busy,
        onOpen: _choose,
      ),
    ),
  );
}

class _ModelChoices extends StatefulWidget {
  const _ModelChoices({required this.service, required this.choose});
  final TranslationService service;
  final ValueChanged<SettingOption<String?>> choose;

  @override
  State<_ModelChoices> createState() => _ModelChoicesState();
}

class _ModelChoicesState extends State<_ModelChoices> {
  final _cancel = TranslationCancellation();
  late var _models = widget.service.readModels(_cancel);

  @override
  void dispose() {
    _cancel.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<TranslationModelOption>>(
        future: _models,
        builder: (context, snapshot) {
          final models = snapshot.data ?? const <TranslationModelOption>[];
          final current = widget.service.model;
          final l = context.l10n, icons = NodeLaneIcons.of(context);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (snapshot.connectionState != ConnectionState.done)
                NodeLaneProgress(semanticsLabel: l.translation_model)
              else if (snapshot.hasError)
                NodeLaneRow(
                  title: l.retry,
                  subtitle: snapshot.error is TranslationFailure
                      ? (snapshot.error as TranslationFailure).message
                      : l.translation_connection_failed,
                  icon: icons.refresh,
                  onTap: () => setState(() {
                    _models = widget.service.readModels(_cancel);
                  }),
                ),
              Flexible(
                child: SettingChoices<String?>(
                  current: current?.id,
                  options: [
                    SettingOption(null, l.default0),
                    for (final option in models)
                      SettingOption(
                        option.model.id,
                        option.model.name,
                        enabled: option.available,
                        icon: option.available ? null : icons.lock,
                        subtitle: option.quotaMultiplier == null
                            ? null
                            : l.translation_model_quota(
                                option.quotaMultiplier!,
                              ),
                      ),
                    if (current != null &&
                        !models.any((o) => o.model.id == current.id))
                      SettingOption(
                        current.id,
                        current.name,
                        enabled: false,
                        subtitle: snapshot.hasData
                            ? l.translation_model_unavailable
                            : null,
                      ),
                  ],
                  choose: widget.choose,
                ),
              ),
            ],
          );
        },
      );
}
