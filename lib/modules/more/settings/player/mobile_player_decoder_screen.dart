import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
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
            MobileSettingsSwitch(
              title: l10n.enable_hardware_accel,
              subtitle: l10n.enable_hardware_accel_info,
              icon: Icons.memory_rounded,
              value: hardware,
              onChanged: ref
                  .read(enableHardwareAccelStateProvider.notifier)
                  .set,
            ),
            if (hardware)
              MobilePlayerSettingChoice<String>(
                title: l10n.hwdec,
                icon: Icons.developer_board_outlined,
                value: ref.watch(hwdecModeStateProvider(rawValue: true)),
                label: (value) => value,
                options: const [
                  MobileSettingOption('no', 'no'),
                  MobileSettingOption('auto', 'auto'),
                  MobileSettingOption(
                    'd3d11va',
                    'd3d11va',
                    subtitle: 'Windows 8+',
                  ),
                  MobileSettingOption(
                    'd3d11va-copy',
                    'd3d11va-copy',
                    subtitle: 'Windows 8+',
                  ),
                  MobileSettingOption(
                    'videotoolbox',
                    'videotoolbox',
                    subtitle: 'iOS 9.0+',
                  ),
                  MobileSettingOption(
                    'videotoolbox-copy',
                    'videotoolbox-copy',
                    subtitle: 'iOS 9.0+',
                  ),
                  MobileSettingOption('nvdec', 'nvdec', subtitle: 'CUDA'),
                  MobileSettingOption(
                    'nvdec-copy',
                    'nvdec-copy',
                    subtitle: 'CUDA',
                  ),
                  MobileSettingOption(
                    'mediacodec',
                    'mediacodec',
                    subtitle: 'HW (Android)',
                  ),
                  MobileSettingOption(
                    'mediacodec-copy',
                    'mediacodec-copy',
                    subtitle: 'HW+ (Android)',
                  ),
                  MobileSettingOption('crystalhd', 'crystalhd'),
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
            MobilePlayerSettingChoice<DebandingType>(
              title: l10n.debanding,
              icon: Icons.gradient_rounded,
              value: ref.watch(debandingStateProvider),
              label: (value) => debanding[value]!,
              options: [
                for (final entry in debanding.entries)
                  MobileSettingOption(entry.key, entry.value),
              ],
              onChanged: ref.read(debandingStateProvider.notifier).set,
            ),
            MobileSettingsSwitch(
              title: l10n.use_yuv420p,
              subtitle: l10n.use_yuv420p_info,
              icon: Icons.palette_outlined,
              value: ref.watch(useYUV420PStateProvider),
              onChanged: ref.read(useYUV420PStateProvider.notifier).set,
            ),
            MobileSettingsSwitch(
              title: l10n.enable_gpu_next,
              subtitle: l10n.enable_gpu_next_info,
              icon: Icons.layers_outlined,
              value: ref.watch(useGpuNextStateProvider),
              onChanged: ref.read(useGpuNextStateProvider.notifier).set,
            ),
          ],
        ),
      ],
    );
  }
}
