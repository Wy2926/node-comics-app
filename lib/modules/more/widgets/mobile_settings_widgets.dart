import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';

/// Small presentation pieces shared by the mobile More and Settings menus.
/// Routes, preferences, and side effects stay with their existing owners.
class MobileSettingsGroup extends StatelessWidget {
  const MobileSettingsGroup({
    super.key,
    this.title,
    required this.children,
    this.spacing,
  });

  final String? title;
  final List<Widget> children;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final reader = NodeLaneReaderScope.activeOf(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: spacing ?? (reader ? 16 : NodeLaneTokens.space24),
      ),
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
          NodeLaneGroupSurface(outlined: reader, children: children),
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
    this.inlineSubtitle = false,
    this.valueLeading,
  });

  final String title;
  final String? subtitle;
  final int? subtitleMaxLines;
  final bool inlineSubtitle;
  final Widget? valueLeading;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final reader = NodeLaneReaderScope.activeOf(context);
    final inline = inlineSubtitle || reader;
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: NodeLaneTokens.space16,
        vertical: reader ? 0 : NodeLaneTokens.space4,
      ),
      minTileHeight: reader
          ? NodeLaneTokens.readerRowHeight
          : NodeLaneTokens.rowHeight,
      horizontalTitleGap: NodeLaneTokens.space12,
      leading: reader
          ? _SettingIcon(icon)
          : inlineSubtitle
          ? Icon(icon, size: 28, color: colors.muted)
          : _SettingIcon(icon),
      title: Text(
        title,
        style: reader
            ? colors.readerLabel
            : colors.body.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: inline || subtitle == null
          ? null
          : Text(
              subtitle!,
              maxLines: subtitleMaxLines,
              overflow: subtitleMaxLines == null ? null : TextOverflow.ellipsis,
              style: colors.secondary,
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (inline && subtitle != null) ...[
            if (valueLeading != null) ...[
              valueLeading!,
              const SizedBox(width: 8),
            ],
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 132),
              child: Text(
                subtitle!,
                maxLines: 2,
                style: reader ? colors.readerValue : colors.secondary,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Icon(
            NodeLaneIcons.of(context).forward,
            size: inline ? 16 : NodeLaneTokens.smallIconSize,
            color: colors.muted,
          ),
        ],
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
    final reader = NodeLaneReaderScope.activeOf(context);
    return SwitchListTile.adaptive(
      minTileHeight: reader && subtitle != null ? 84 : null,
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.symmetric(
        horizontal: NodeLaneTokens.space16,
        vertical: reader && subtitle == null ? 0 : NodeLaneTokens.space4,
      ),
      secondary: _SettingIcon(icon),
      title: Text(
        title,
        style: reader
            ? colors.readerLabel
            : colors.body.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: reader ? colors.readerSecondary : colors.secondary,
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
    final reader = NodeLaneReaderScope.activeOf(context);
    return SizedBox(
      width: 28,
      height: 36,
      child: Icon(
        reader ? NodeLaneIcons.of(context).readerSetting(icon) : icon,
        size: NodeLaneTokens.iconSize,
        color: reader ? colors.ink : colors.accent,
      ),
    );
  }
}
