import 'package:flutter/material.dart';

typedef SettingsSectionBuilder = Widget Function(BuildContext context);

/// One entry in the settings home list ("Qualité", "Vitesse"...): an icon, a
/// label, an optional live current-value widget shown to the right of it
/// (e.g. "1.0×"), and either drill-down content or a direct action.
class SettingsEntry {
  final String label;
  final IconData icon;
  final WidgetBuilder? valueBuilder;
  final SettingsSectionBuilder? contentBuilder;
  final ValueChanged<BuildContext>? onTap;

  const SettingsEntry({
    required this.label,
    required this.icon,
    this.contentBuilder,
    this.onTap,
    this.valueBuilder,
  }) : assert(
         (contentBuilder == null) != (onTap == null),
         'Provide either contentBuilder or onTap',
       );
}

/// An inherited widget that exposes navigation actions for the active
/// settings surface, allowing options inside a section (e.g. playback speed,
/// fit, video track) to navigate back to the settings home list rather than
/// dismissing the whole sheet or popup menu.
class SettingsDrilldownScope extends InheritedWidget {
  final VoidCallback goHome;
  final VoidCallback close;
  final bool isDirectShortcut;
  final bool mobile;

  const SettingsDrilldownScope({
    super.key,
    required this.goHome,
    required this.close,
    this.isDirectShortcut = false,
    this.mobile = false,
    required super.child,
  });

  static SettingsDrilldownScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsDrilldownScope>();
  }

  @override
  bool updateShouldNotify(covariant SettingsDrilldownScope oldWidget) =>
      oldWidget.isDirectShortcut != isDirectShortcut ||
      oldWidget.mobile != mobile;
}
