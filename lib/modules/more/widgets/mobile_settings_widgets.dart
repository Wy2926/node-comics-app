import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
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
      padding: const EdgeInsets.only(bottom: NodeLaneTokens.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(
                left: NodeLaneTokens.space4,
                bottom: NodeLaneTokens.space8,
              ),
              child: NodeLaneSectionHeading(title!),
            ),
          NodeLaneGroupSurface(
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) Divider(height: 1, indent: 56, color: colors.line),
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
    this.subtitleMaxLines,
  });

  final String title;
  final String? subtitle;
  final int? subtitleMaxLines;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: NodeLaneTokens.space16,
        vertical: NodeLaneTokens.space4,
      ),
      minTileHeight: NodeLaneTokens.rowHeight,
      horizontalTitleGap: NodeLaneTokens.space12,
      leading: _SettingIcon(icon),
      title: Text(
        title,
        style: colors.body.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              maxLines: subtitleMaxLines,
              overflow: subtitleMaxLines == null ? null : TextOverflow.ellipsis,
              style: colors.secondary,
            ),
      trailing: Icon(
        NodeLaneIcons.of(context).forward,
        size: NodeLaneTokens.smallIconSize,
        color: colors.muted,
      ),
    );
  }
}

class MobileSettingsSwitch extends StatelessWidget {
  const MobileSettingsSwitch({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: NodeLaneTokens.space16,
        vertical: NodeLaneTokens.space4,
      ),
      secondary: _SettingIcon(icon),
      title: Text(
        title,
        style: colors.body.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: colors.secondary),
    );
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon(this.icon);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return SizedBox(
      width: 28,
      height: 36,
      child: Icon(icon, size: NodeLaneTokens.iconSize, color: colors.accent),
    );
  }
}
