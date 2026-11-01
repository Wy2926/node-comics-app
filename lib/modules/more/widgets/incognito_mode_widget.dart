import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class IncognitoModeWidget extends ConsumerWidget {
  const IncognitoModeWidget({super.key, this.mobile = false});
  final bool mobile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    final hideDiscordRpcInIncognito = ref.watch(
      hideDiscordRpcInIncognitoStateProvider,
    );
    void change(bool value) {
      ref.read(incognitoModeStateProvider.notifier).setIncognitoMode(value);
      if (hideDiscordRpcInIncognito) {
        if (value) {
          discordRpc?.disconnect();
        } else {
          discordRpc?.connect(ref);
        }
      }
    }

    if (mobile) {
      return MobileSettingsSwitch(
        title: l10n!.incognito_mode,
        subtitle: l10n.incognito_mode_description,
        icon: NodeLaneIcons.of(context).incognito,
        value: incognitoMode,
        onChanged: change,
      );
    }
    return ListTileWidget(
      onTap: () => change(!incognitoMode),
      icon: CupertinoIcons.eyeglasses,
      subtitle: l10n!.incognito_mode_description,
      title: l10n.incognito_mode,
      trailing: Switch(value: incognitoMode, onChanged: change),
    );
  }
}
