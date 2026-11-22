import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) => MobileBrowsePage(
    title: title,
    body: MobileSettingsList(
      key: PageStorageKey(storageKey),
      children: children,
    ),
  );
}
