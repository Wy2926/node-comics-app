import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_text_dialog.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

import 'mobile_player_settings_widgets.dart';
import 'providers/player_audio_state_provider.dart';

class MobilePlayerAudioScreen extends ConsumerWidget {
  const MobilePlayerAudioScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final languages = ref.watch(audioPreferredLangStateProvider);
    final channels = {
      AudioChannel.auto: l10n.audio_channel_auto,
      AudioChannel.autoSafe: l10n.audio_channel_auto_safe,
      AudioChannel.mono: l10n.audio_channel_mono,
      AudioChannel.stereo: l10n.audio_channel_stereo,
      AudioChannel.reverseStereo: l10n.audio_channel_reverse_stereo,
    };
    return MobilePlayerSettingsPage(
      title: l10n.video_audio,
      storageKey: 'mobile-player-audio-settings',
      children: [
        MobileSettingsGroup(
          children: [
            MobileSettingsLink(
              title: l10n.audio_preferred_languages,
              subtitle: languages.isEmpty ? l10n.default0 : languages,
              icon: Icons.translate_rounded,
              onTap: () async {
                final result = await showDialog<String>(
                  context: context,
                  builder: (_) => MobileSettingsTextDialog(
                    title: l10n.audio_preferred_languages,
                    initialValue: languages,
                    helper: l10n.audio_preferred_languages_info,
                    hint: 'ja, en',
                  ),
                );
                if (context.mounted &&
                    result != null &&
                    result != ref.read(audioPreferredLangStateProvider)) {
                  // Keep the original free-form MPV language preference,
                  // including three-letter codes and an explicit empty value.
                  ref
                      .read(audioPreferredLangStateProvider.notifier)
                      .set(result);
                }
              },
            ),
            MobilePlayerSettingChoice<AudioChannel>(
              title: l10n.audio_channels,
              icon: Icons.speaker_group_outlined,
              value: ref.watch(audioChannelStateProvider),
              label: (value) => channels[value]!,
              options: [
                for (final entry in channels.entries)
                  MobileSettingOption(entry.key, entry.value),
              ],
              onChanged: ref.read(audioChannelStateProvider.notifier).set,
            ),
          ],
        ),
        MobileSettingsGroup(
          children: [
            MobileSettingsSwitch(
              title: l10n.enable_audio_pitch_correction,
              subtitle: l10n.enable_audio_pitch_correction_info,
              icon: Icons.graphic_eq_rounded,
              value: ref.watch(enableAudioPitchCorrectionStateProvider),
              onChanged: ref
                  .read(enableAudioPitchCorrectionStateProvider.notifier)
                  .set,
            ),
            _VolumeBoost(
              value: ref.watch(volumeBoostCapStateProvider),
              onChanged: ref.read(volumeBoostCapStateProvider.notifier).set,
            ),
          ],
        ),
      ],
    );
  }
}

class _VolumeBoost extends StatefulWidget {
  const _VolumeBoost({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;
  @override
  State<_VolumeBoost> createState() => _VolumeBoostState();
}

class _VolumeBoostState extends State<_VolumeBoost> {
  late double _draft = widget.value.clamp(0, 200).toDouble();
  @override
  void didUpdateWidget(covariant _VolumeBoost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _draft = widget.value.clamp(0, 200).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${context.l10n.volume_boost_cap}: ${_draft.toInt()}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Slider.adaptive(
          value: _draft,
          min: 0,
          max: 200,
          label: '${_draft.toInt()}',
          onChanged: (value) => setState(() => _draft = value),
          onChangeEnd: (value) {
            if (value.toInt() != widget.value) widget.onChanged(value.toInt());
          },
        ),
      ],
    ),
  );
}
