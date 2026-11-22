import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/widgets/nodelane_setting_bubble.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

import 'mobile_player_settings_widgets.dart';
import 'providers/player_decoder_state_provider.dart';

class MobilePlayerDecoderScreen extends ConsumerWidget {
  const MobilePlayerDecoderScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final hardware = ref.watch(enableHardwareAccelStateProvider);
    final debanding = {
      DebandingType.none: l10n.off,
      DebandingType.cpu: 'CPU',
      DebandingType.gpu: 'GPU',
    };
    return MobilePlayerSettingsPage(
      title: l10n.decoder,
      storageKey: 'mobile-player-decoder-settings',
      children: [
        MobileSettingsGroup(
          children: [
            NodeLaneSwitchRow(
              title: l10n.enable_hardware_accel,
              icon: NodeLaneIcons.of(context).memory,
              value: hardware,
              onChanged: ref
                  .read(enableHardwareAccelStateProvider.notifier)
                  .set,
            ),
            if (hardware)
              MobileSettingsChoice<String>(
                title: l10n.hwdec,
                icon: NodeLaneIcons.of(context).memory,
                value: ref.watch(hwdecModeStateProvider(rawValue: true)),
                label: (value) => value,
                options: const [
                  SettingOption('no', 'no'),
                  SettingOption('auto', 'auto'),
                  SettingOption('d3d11va', 'd3d11va', subtitle: 'Windows 8+'),
                  SettingOption(
                    'd3d11va-copy',
                    'd3d11va-copy',
                    subtitle: 'Windows 8+',
                  ),
                  SettingOption(
                    'videotoolbox',
                    'videotoolbox',
                    subtitle: 'iOS 9.0+',
                  ),
                  SettingOption(
                    'videotoolbox-copy',
                    'videotoolbox-copy',
                    subtitle: 'iOS 9.0+',
                  ),
                  SettingOption('nvdec', 'nvdec', subtitle: 'CUDA'),
                  SettingOption('nvdec-copy', 'nvdec-copy', subtitle: 'CUDA'),
                  SettingOption(
                    'mediacodec',
                    'mediacodec',
                    subtitle: 'HW (Android)',
                  ),
                  SettingOption(
                    'mediacodec-copy',
                    'mediacodec-copy',
                    subtitle: 'HW+ (Android)',
                  ),
                  SettingOption('crystalhd', 'crystalhd'),
                ],
                onChanged: ref
                    .read(hwdecModeStateProvider(rawValue: true).notifier)
                    .set,
              ),
          ],
        ),
        MobileSettingsGroup(
          title: l10n.display,
          children: [
            MobileSettingsChoice<DebandingType>(
              title: l10n.debanding,
              icon: NodeLaneIcons.of(context).palette,
              value: ref.watch(debandingStateProvider),
              label: (value) => debanding[value]!,
              options: [
                for (final entry in debanding.entries)
                  SettingOption(entry.key, entry.value),
              ],
              onChanged: ref.read(debandingStateProvider.notifier).set,
            ),
            NodeLaneSwitchRow(
              title: l10n.use_yuv420p,
              icon: NodeLaneIcons.of(context).palette,
              value: ref.watch(useYUV420PStateProvider),
              onChanged: ref.read(useYUV420PStateProvider.notifier).set,
            ),
            NodeLaneSwitchRow(
              title: l10n.enable_gpu_next,
              icon: NodeLaneIcons.of(context).categories,
              value: ref.watch(useGpuNextStateProvider),
              onChanged: ref.read(useGpuNextStateProvider.notifier).set,
            ),
          ],
        ),
      ],
    );
  }
}
