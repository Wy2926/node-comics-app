import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
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
        appBar: nodeLaneAppBar(context, title: l10n.manage_trackers),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: NodeLaneTokens.pagePadding,
            children: preferences.isEmpty
                ? [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            NodeLaneIcons.of(context).accountOutline,
                            size: 36,
                            color: colors.ink,
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
                          NodeLaneRow(
                            leading: TrackerAccountAvatar(
                              preference: preference,
                              radius: NodeLaneTokens.smallIconSize,
                            ),
                            title: preference.syncId == -1
                                ? l10n.local
                                : trackInfos(preference.syncId!).$2,
                            subtitle: preference.accountLabel,
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
