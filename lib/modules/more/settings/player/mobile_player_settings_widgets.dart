import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
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
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          key: PageStorageKey(storageKey),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: children,
        ),
      ),
    ),
  );
}

class MobilePlayerSettingsSection extends StatelessWidget {
  const MobilePlayerSettingsSection({
    super.key,
    required this.storageKey,
    required this.title,
    required this.icon,
    required this.child,
  });
  final String storageKey, title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) => MobileSettingsGroup(
    children: [
      ExpansionTile(
        key: PageStorageKey(storageKey),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: const Border(),
        collapsedShape: const Border(),
        leading: Icon(icon, color: NodeLaneTokens.of(context).accent),
        title: Text(title),
        children: [child],
      ),
    ],
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
  Widget build(BuildContext context) => MobileSettingsLink(
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
