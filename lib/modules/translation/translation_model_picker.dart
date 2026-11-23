import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/widgets/nodelane_progress.dart';
import 'package:mangayomi/modules/widgets/nodelane_setting_bubble.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final choice =
        await NodeLaneBubbleFlow.edit<SettingOption<TranslationModel?>>(
          anchor,
          title: context.l10n.translation_model,
          body: (_, finish) => _ModelChoices(service: service, choose: finish),
        );
    if (!mounted ||
        account != service.accountId ||
        choice == null ||
        choice.value?.id == service.model?.id) {
      return;
    }
    await service.setModel(choice.value);
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
  final ValueChanged<SettingOption<TranslationModel?>> choose;

  @override
  State<_ModelChoices> createState() => _ModelChoicesState();
}

class _ModelChoicesState extends State<_ModelChoices>
    with WidgetsBindingObserver {
  final _cancel = TranslationCancellation();
  late var _models = widget.service.readModels(_cancel);
  late final String? _account;
  bool _pricingOpen = false;

  @override
  void initState() {
    super.initState();
    _account = widget.service.accountId;
    WidgetsBinding.instance.addObserver(this);
  }

  bool _current() =>
      mounted &&
      _account == widget.service.accountId &&
      ModalRoute.isCurrentOf(context) == true;

  Future<void> _upgrade() async {
    if (_pricingOpen || !_current()) return;
    final unavailable = context.l10n.translation_upgrade_unavailable;
    _pricingOpen = true;
    try {
      if (!await launchUrl(
        Uri.https('comics.nodelane.net', '/pricing/'),
        mode: LaunchMode.externalApplication,
      )) {
        throw const TranslationFailure('BILLING_UNAVAILABLE');
      }
    } catch (_) {
      _pricingOpen = false;
      if (_current()) {
        showNodeLaneNotice(unavailable, kind: NodeLaneNoticeKind.error);
      }
    }
  }

  void _reload() => setState(() {
    _models = widget.service.readModels(_cancel);
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pricingOpen) {
      _pricingOpen = false;
      if (_current()) _reload();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancel.cancel();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) => FutureBuilder<List<TranslationModelOption>>(
    future: _models,
    builder: (context, snapshot) {
      final models = snapshot.data ?? const <TranslationModelOption>[];
      final saved = widget.service.model;
      final listed = models.where((o) => o.model.id == saved?.id).firstOrNull;
      final l = context.l10n, icons = NodeLaneIcons.of(context);
      final rateFormat = NumberFormat(
        '0.####',
        Localizations.localeOf(context).toLanguageTag(),
      );
      final upgrade = TextButton(
        onPressed: _upgrade,
        child: Text(l.translation_upgrade_quota, textAlign: TextAlign.center),
      );
      SettingOption<TranslationModel?> choice(TranslationModelOption option) {
        final (icon, label) = switch (option.requiresPaid) {
          false => (icons.modelFree, l.translation_model_free),
          true => (icons.modelPaid, l.translation_model_paid),
          null => (icons.translate, null),
        };
        return SettingOption(
          option.model,
          option.model.name,
          icon: icon,
          iconLabel: label,
          badge: option.quotaMultiplier == null
              ? null
              : '${rateFormat.format(option.quotaMultiplier)}×',
          trailing: option.access.selectable ? null : upgrade,
          enabled: option.access.selectable,
        );
      }

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
              onTap: _reload,
            ),
          Flexible(
            child: SettingChoices<TranslationModel?>(
              current: listed?.model ?? saved,
              titleMaxLines: 2,
              options: [
                SettingOption(null, l.default0, icon: icons.adjustments),
                ...models.map(choice),
                if (saved != null && listed == null)
                  SettingOption(
                    saved,
                    saved.name,
                    icon: icons.translate,
                    trailing: snapshot.hasData
                        ? upgrade
                        : const SizedBox.shrink(),
                    enabled: false,
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
