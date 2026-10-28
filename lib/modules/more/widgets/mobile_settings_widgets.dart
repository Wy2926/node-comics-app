import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Small presentation pieces shared by the mobile More and Settings menus.
/// Routes, preferences, and side effects stay with their existing owners.
class MobileSettingsGroup extends StatelessWidget {
  const MobileSettingsGroup({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Semantics(
                header: true,
                child: Text(
                  title!,
                  style: TextStyle(fontSize: 13, color: colors.muted),
                ),
              ),
            ),
          Material(
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: colors.line),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) Divider(height: 1, indent: 64, color: colors.line),
                  children[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MobileSettingsLink extends StatelessWidget {
  const MobileSettingsLink({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minTileHeight: 64,
      horizontalTitleGap: 12,
      leading: _SettingIcon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colors.ink,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: TextStyle(fontSize: 13, color: colors.muted),
            ),
      trailing: Icon(Icons.chevron_right, size: 20, color: colors.muted),
    );
  }
}

class MobileSettingsSwitch extends StatelessWidget {
  const MobileSettingsSwitch({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String title, subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      secondary: _SettingIcon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colors.ink,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: colors.muted),
      ),
    );
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon(this.icon);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: colors.accent),
    );
  }
}
