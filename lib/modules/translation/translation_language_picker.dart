import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

const translationLanguageNames = {
  'zh-Hans': '简体中文',
  'zh-Hant': '繁體中文',
  'en': 'English',
  'ja': '日本語',
};

Future<String?> showTranslationLanguagePicker(
  BuildContext context,
  String current,
) {
  var leaving = false;
  final l = context.l10n;
  return showNodeLaneCatalogSheet<String>(
    context,
    Builder(
      builder: (context) => NodeLaneCatalogSheet(
        title: l.settings_translation_language,
        subtitle:
            '${l.settings_translation_scope}\n${l.settings_immediate_choice}',
        fitContent: true,
        heightFactor: .9,
        child: ListView(
          shrinkWrap: true,
          padding: NodeLaneTokens.pagePadding,
          children: [
            NodeLaneGroupSurface(
              children: [
                for (final language in translationLanguageNames.entries)
                  NodeLaneRow(
                    title: language.value,
                    selected: language.key == current,
                    onTap: () {
                      if (leaving ||
                          ModalRoute.of(context)?.isCurrent != true) {
                        return;
                      }
                      leaving = true;
                      Navigator.pop(context, language.key);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// The sole language row, shared by More, reader and web translation controls.
class TranslationLanguageRow extends ConsumerStatefulWidget {
  const TranslationLanguageRow({super.key});
  @override
  ConsumerState<TranslationLanguageRow> createState() =>
      _TranslationLanguageRowState();
}

class _TranslationLanguageRowState
    extends ConsumerState<TranslationLanguageRow> {
  late final service = ref.read(translationServiceProvider);
  bool _initializing = true, _failed = false, _choosing = false;
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await service.initialize();
    } catch (_) {
      _failed = true;
    }
    if (mounted) setState(() => _initializing = false);
  }

  Future<void> _choose() async {
    if (_initializing || _failed || service.busy || _choosing) return;
    _choosing = true;
    final value = await showTranslationLanguagePicker(
      context,
      service.language,
    );
    if (!mounted) return;
    _choosing = false;
    if (value == null || value == service.language) return;
    await service.setLanguage(value);
    if (mounted && service.error != null) {
      showNodeLaneNotice(service.error!, kind: NodeLaneNoticeKind.error);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: service,
    builder: (context, _) => NodeLaneRow(
      title: context.l10n.settings_translation_language,
      value: translationLanguageNames[service.language] ?? service.language,
      subtitle: _failed ? context.l10n.settings_translation_init_error : null,
      icon: NodeLaneIcons.of(context).translate,
      enabled: !_initializing && !_failed && !service.busy,
      onTap: _choose,
    ),
  );
}
