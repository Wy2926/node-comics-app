import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/novel/tts/mobile_tts_settings.dart';
import 'package:mangayomi/modules/novel/tts/novel_tts_service.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'providers/reader_state_provider.dart';

class MobileTtsSettingsScreen extends ConsumerWidget {
  const MobileTtsSettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tts = NovelTtsService.instance;
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(context, title: context.l10n.tts),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            key: const PageStorageKey('mobile-tts-settings'),
            child: MobileTtsSettings(
              speed: ref.watch(ttsSpeechRateStateProvider),
              pitch: ref.watch(ttsPitchStateProvider),
              language: ref.watch(ttsLanguageStateProvider),
              loadLanguages: tts.getLanguages,
              onSpeedChanged: (value) async {
                if (value != ref.read(ttsSpeechRateStateProvider)) {
                  ref.read(ttsSpeechRateStateProvider.notifier).set(value);
                }
                await tts.setSpeed(value);
              },
              onPitchChanged: (value) async {
                if (value != ref.read(ttsPitchStateProvider)) {
                  ref.read(ttsPitchStateProvider.notifier).set(value);
                }
                await tts.setPitch(value);
              },
              onLanguageChanged: (value) async {
                if (value != ref.read(ttsLanguageStateProvider)) {
                  ref.read(ttsLanguageStateProvider.notifier).set(value);
                }
                // Preserve the existing default: clear the stored preference
                // without assigning a language to the current speech engine.
                if (value != null) await tts.setLanguage(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}
