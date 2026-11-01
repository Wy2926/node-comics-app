import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

// The same choices as the original settings menu. This is display data;
// changing the active language still belongs to TranslationService.
const translationLanguageNames = {
  'zh-Hans': '简体中文',
  'zh-Hant': '繁體中文',
  'en': 'English',
  'ja': '日本語',
};

Future<String?> showTranslationLanguagePicker(
  BuildContext context,
  String current,
) => showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  backgroundColor: NodeLaneTokens.of(context).surface,
  builder: (context) => NodeLaneModalScope(
    child: SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: const Text(
                        '目标语言',
                        style: NodeLaneTokens.modalTitleStyle,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: MaterialLocalizations.of(context)
                        .closeButtonTooltip,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: RadioGroup<String>(
                  groupValue: current,
                  onChanged: (value) => Navigator.pop(context, value),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final language in translationLanguageNames.entries)
                        RadioListTile<String>.adaptive(
                          title: Text(language.value),
                          value: language.key,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
