import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
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
        child: ListView(
          key: PageStorageKey(storageKey),
          padding: NodeLaneTokens.pagePadding,
          children: children,
        ),
      ),
    ),
  );
}

class MobilePlayerSettingChoice<T> extends StatelessWidget {
  const MobilePlayerSettingChoice({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.label,
    required this.options,
    required this.onChanged,
    this.searchable = false,
  });
  final String title;
  final IconData icon;
  final T value;
  final String Function(T) label;
  final List<MobileSettingOption<T>> options;
  final ValueChanged<T> onChanged;
  final bool searchable;

  @override
  Widget build(BuildContext context) => NodeLaneRow(
    title: title,
    subtitle: label(value),
    icon: icon,
    onTap: () async {
      final result = await showMobileSettingsPicker<T>(
        context,
        title: title,
        current: value,
        options: options,
        searchable: searchable,
      );
      if (context.mounted && result != null && result.value != value) {
        onChanged(result.value);
      }
    },
  );
}
