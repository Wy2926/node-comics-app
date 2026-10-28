import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/providers/downloaded_only_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class DownloadedOnlyWidget extends ConsumerWidget {
  const DownloadedOnlyWidget({super.key, this.mobile = false});
  final bool mobile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    final downloadedOnly = ref.watch(downloadedOnlyStateProvider);
    void change(bool value) =>
        ref.read(downloadedOnlyStateProvider.notifier).setDownloadedOnly(value);
    if (mobile) {
      return MobileSettingsSwitch(
        title: l10n!.downloaded_only,
        subtitle: l10n.downloaded_only_description,
        icon: Icons.cloud_off_outlined,
        value: downloadedOnly,
        onChanged: change,
      );
    }
    return ListTileWidget(
      onTap: () => change(!downloadedOnly),
      icon: Icons.cloud_off_outlined,
      subtitle: l10n!.downloaded_only_description,
      title: l10n.downloaded_only,
      trailing: Switch(value: downloadedOnly, onChanged: change),
    );
  }
}
