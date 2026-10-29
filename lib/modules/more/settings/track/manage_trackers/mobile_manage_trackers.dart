import 'package:flutter/material.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/widgets/tracker_account_avatar.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/constant.dart';

class MobileManageTrackers extends StatelessWidget {
  const MobileManageTrackers({
    super.key,
    required this.preferences,
    required this.onOpen,
  });
  final List<TrackPreference> preferences;
  final ValueChanged<TrackPreference> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.manage_trackers,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: preferences.isEmpty
                ? [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.manage_accounts_outlined,
                            size: 36,
                            color: colors.accent,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.tracking_accounts_empty,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ]
                : [
                    MobileSettingsGroup(
                      children: [
                        for (final preference in preferences)
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            leading: preference.syncId == -1
                                ? const Icon(Icons.local_library_outlined)
                                : SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ColoredBox(
                                        color: trackInfos(preference.syncId!)
                                            .$3,
                                        child: Image.asset(
                                          trackInfos(preference.syncId!).$1,
                                        ),
                                      ),
                                    ),
                                  ),
                            title: Text(
                              preference.syncId == -1
                                  ? l10n.local
                                  : trackInfos(preference.syncId!).$2,
                            ),
                            subtitle: preference.accountLabel == null
                                ? null
                                : Text(preference.accountLabel!),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => onOpen(preference),
                          ),
                      ],
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
