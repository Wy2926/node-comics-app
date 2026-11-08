import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation only: callers retain the original routes and preference writes.
class MobilePlayerSettingsPage extends StatelessWidget {
  const MobilePlayerSettingsPage({
    super.key,
    required this.title,
    required this.storageKey,
    required this.children,
  });
  final String title, storageKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => NodeLaneSurface(
    child: Scaffold(
      appBar: nodeLaneAppBar(context, title: title),
      body: SafeArea(
        top: false,
        child: MobileSettingsList(
          key: PageStorageKey(storageKey),
          padding: NodeLaneTokens.pagePadding,
          children: children,
        ),
      ),
    ),
  );
}
