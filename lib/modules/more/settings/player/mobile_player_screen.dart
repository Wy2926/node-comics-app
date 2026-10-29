import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_text_dialog.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/language.dart';

import 'mobile_player_settings_widgets.dart';
import 'providers/player_state_provider.dart';

class MobilePlayerScreen extends ConsumerWidget {
  const MobilePlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return MobilePlayerSettingsPage(
      title: l10n.internal_player,
      storageKey: 'mobile-player-settings',
      children: [
        MobileSettingsGroup(
          title: l10n.general,
          children: [
            MobilePlayerSettingChoice<double>(
              title: l10n.default_playback_speed_length,
              icon: Icons.speed_rounded,
              value: ref.watch(defaultPlayBackSpeedStateProvider),
              label: l10n.playback_speed_multiplier,
              options: [
                for (final value in [
                  0.25,
                  0.5,
                  0.75,
                  1.0,
                  1.25,
                  1.5,
                  1.75,
                  2.0,
                ])
                  MobileSettingOption(
                    value,
                    l10n.playback_speed_multiplier(value),
                  ),
              ],
              onChanged: ref
                  .read(defaultPlayBackSpeedStateProvider.notifier)
                  .set,
            ),
            MobilePlayerSettingChoice<int>(
              title: l10n.markEpisodeAsSeenSetting,
              icon: Icons.task_alt_rounded,
              value: ref.watch(markEpisodeAsSeenTypeStateProvider),
              label: (value) => '$value%',
              options: [
                for (final value in [100, 95, 90, 85, 80, 75, 70])
                  MobileSettingOption(value, '$value%'),
              ],
              onChanged: ref
                  .read(markEpisodeAsSeenTypeStateProvider.notifier)
                  .set,
            ),
          ],
        ),
        MobileSettingsGroup(
          title: l10n.video_subtitle,
          children: [
            MobilePlayerSettingChoice<Locale>(
              title: l10n.default_subtitle_language,
              icon: Icons.translate_rounded,
              value: ref.watch(defaultSubtitleLangStateProvider),
              label: (value) => completeLanguageName(value.toLanguageTag()),
              searchable: true,
              options: [
                for (final locale in AppLocalizations.supportedLocales)
                  MobileSettingOption(
                    locale,
                    completeLanguageName(locale.toLanguageTag()),
                    subtitle: locale.toLanguageTag(),
                  ),
              ],
              onChanged: ref
                  .read(defaultSubtitleLangStateProvider.notifier)
                  .setLocale,
            ),
            MobileSettingsSwitch(
              title: l10n.use_libass,
              subtitle: l10n.use_libass_info,
              icon: Icons.subtitles_outlined,
              value: ref.watch(useLibassStateProvider),
              onChanged: ref.read(useLibassStateProvider.notifier).set,
            ),
          ],
        ),
        MobilePlayerSettingsSection(
          storageKey: 'player-controls',
          title: l10n.player_controls,
          icon: Icons.touch_app_outlined,
          child: const _Controls(),
        ),
        MobilePlayerSettingsSection(
          storageKey: 'player-display',
          title: l10n.display,
          icon: Icons.screen_rotation_outlined,
          child: const _Display(),
        ),
        const MobilePlayerSettingsSection(
          storageKey: 'player-aniskip',
          title: 'AniSkip',
          icon: Icons.skip_next_rounded,
          child: _AniSkip(),
        ),
      ],
    );
  }
}

class _Controls extends ConsumerWidget {
  const _Controls();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final intro = ref.watch(defaultSkipIntroLengthStateProvider);
    return Column(
      children: [
        MobileSettingsLink(
          title: l10n.default_skip_intro_length,
          subtitle: '${intro}s',
          icon: Icons.skip_next_outlined,
          onTap: () async {
            final result = await showDialog<String>(
              context: context,
              builder: (_) => MobileSettingsTextDialog(
                title: l10n.default_skip_intro_length,
                initialValue: '$intro',
                hint: '1–255 s',
                keyboardType: TextInputType.number,
                isValid: (text) {
                  final value = int.tryParse(text.trim());
                  return value != null && value >= 1 && value <= 255;
                },
              ),
            );
            if (!context.mounted || result == null) return;
            final value = int.parse(result.trim());
            if (value != ref.read(defaultSkipIntroLengthStateProvider)) {
              ref.read(defaultSkipIntroLengthStateProvider.notifier).set(value);
            }
          },
        ),
        MobilePlayerSettingChoice<int>(
          title: l10n.default_skip_forward_skip_length,
          icon: Icons.fast_forward_outlined,
          value: ref.watch(defaultDoubleTapToSkipLengthStateProvider),
          label: (value) => '${value}s',
          options: [
            for (final value in [30, 20, 10, 5, 3, 1])
              MobileSettingOption(value, '${value}s'),
          ],
          onChanged: ref
              .read(defaultDoubleTapToSkipLengthStateProvider.notifier)
              .set,
        ),
      ],
    );
  }
}

class _Display extends ConsumerWidget {
  const _Display();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Column(
      children: [
        MobileSettingsSwitch(
          title: l10n.full_screen_player,
          subtitle: l10n.full_screen_player_info,
          icon: Icons.fullscreen_rounded,
          value: ref.watch(fullScreenPlayerStateProvider),
          onChanged: ref.read(fullScreenPlayerStateProvider.notifier).set,
        ),
        MobileSettingsSwitch(
          title: l10n.forceLandscapeMode,
          subtitle: l10n.forceLandscapeModeSubtitle,
          icon: Icons.stay_current_landscape_rounded,
          value: ref.watch(forceLandscapePlayerStateProvider),
          onChanged: ref.read(forceLandscapePlayerStateProvider.notifier).set,
        ),
      ],
    );
  }
}

class _AniSkip extends ConsumerWidget {
  const _AniSkip();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final enabled = ref.watch(enableAniSkipStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.aniskip_requires_info,
            style: TextStyle(color: NodeLaneTokens.of(context).muted),
          ),
        ),
        MobileSettingsSwitch(
          title: l10n.enable_aniskip,
          icon: Icons.skip_next_rounded,
          value: enabled,
          onChanged: ref.read(enableAniSkipStateProvider.notifier).set,
        ),
        if (enabled) ...[
          MobileSettingsSwitch(
            title: l10n.enable_auto_skip,
            icon: Icons.fast_forward_rounded,
            value: ref.watch(enableAutoSkipStateProvider),
            onChanged: ref.read(enableAutoSkipStateProvider.notifier).set,
          ),
          MobilePlayerSettingChoice<int>(
            title: l10n.aniskip_button_timeout,
            icon: Icons.timer_outlined,
            value: ref.watch(aniSkipTimeoutLengthStateProvider),
            label: (value) => '${value}s',
            options: [
              for (final value in [5, 6, 7, 8, 9, 10])
                MobileSettingOption(value, '${value}s'),
            ],
            onChanged: ref.read(aniSkipTimeoutLengthStateProvider.notifier).set,
          ),
        ],
      ],
    );
  }
}
