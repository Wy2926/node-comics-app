import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/anime/widgets/player_settings_navigation.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

export 'player_settings_navigation.dart';

/// A choice with an optional track detail or keyboard shortcut.
class SettingsOptionRow extends StatelessWidget {
  final String label;
  final bool selected;
  final String? hint;
  final VoidCallback onTap;

  const SettingsOptionRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    if (SettingsDrilldownScope.of(context)?.mobile == true) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: NodeLaneGroupSurface(
          selected: selected,
          child: NodeLaneRow(
            title: label,
            subtitle: hint,
            selected: selected,
            accented: selected,
            minHeight: NodeLaneTokens.menuItemHeight,
            onTap: onTap,
          ),
        ),
      );
    }
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final accent = colorScheme.primary;
    final onSurface = colorScheme.onSurface;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer.withValues(alpha: 0.45)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? accent : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? accent
                        : colorScheme.outline.withValues(alpha: 0.50),
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Icon(Icons.check, size: 13, color: colorScheme.onPrimary)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                    fontSize: 13.5,
                    color: selected ? accent : onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hint != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    hint!,
                    style: (textTheme.labelSmall ?? const TextStyle()).copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A non-selectable action row ("Load your own subtitles...",
/// "Search subtitles online...") — same density as [SettingsOptionRow], but a
/// leading icon and a chevron instead of a checkmark, so it doesn't read as a
/// dead/never-selected option.
class SettingsActionRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsActionRow({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (SettingsDrilldownScope.of(context)?.mobile == true) {
      return NodeLaneRow(
        title: label,
        icon: icon,
        minHeight: NodeLaneTokens.menuItemHeight,
        onTap: onTap,
      );
    }
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                    fontSize: 13.5,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Uppercase, muted group label ("QUALITÉ", "RENDU"...) inside a section body.
class SettingsSectionLabel extends StatelessWidget {
  final String text;
  const SettingsSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final mobile = SettingsDrilldownScope.of(context)?.mobile == true;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
      child: Text(
        mobile ? text : text.toUpperCase(),
        style: (textTheme.labelSmall ?? const TextStyle()).copyWith(
          fontSize: mobile ? 13 : null,
          letterSpacing: mobile ? 0 : 0.8,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// A "-"/"+" stepper row (subtitle delay, subtitle speed...) supporting optional manual text editing.
class SettingsStepperRow extends StatelessWidget {
  final String label;
  final String? value;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? suffix;
  final TextInputType? keyboardType;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const SettingsStepperRow({
    super.key,
    required this.label,
    this.value,
    this.controller,
    this.focusNode,
    this.suffix,
    this.keyboardType,
    required this.onDecrement,
    required this.onIncrement,
    this.onChanged,
    this.onSubmitted,
  }) : assert(
         value != null || controller != null,
         'Must provide value or controller',
       );

  @override
  Widget build(BuildContext context) {
    if (SettingsDrilldownScope.of(context)?.mobile == true) {
      final colors = NodeLaneTokens.of(context);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: TextStyle(fontSize: 16, color: colors.ink)),
            const SizedBox(height: 8),
            Material(
              color: colors.soft,
              borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
              child: Row(
                children: [
                  IconButton(
                    tooltip: '${context.l10n.decrease} $label',
                    onPressed: onDecrement,
                    icon: const Icon(Icons.remove),
                  ),
                  Expanded(
                    child: controller == null
                        ? Text(
                            value ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: colors.ink),
                          )
                        : Semantics(
                            label: label,
                            child: TextField(
                              controller: controller,
                              focusNode: focusNode,
                              keyboardType: keyboardType,
                              textInputAction: TextInputAction.done,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: colors.ink),
                              decoration: InputDecoration(
                                hintText: label,
                                suffixText: suffix,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(12),
                              ),
                              onChanged: onChanged,
                              onSubmitted: onSubmitted,
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                            ),
                          ),
                  ),
                  IconButton(
                    tooltip: '${context.l10n.increase} $label',
                    onPressed: onIncrement,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final onSurface = colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.60,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.30),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepperButton(icon: Icons.remove, onTap: onDecrement),
                if (controller != null)
                  SizedBox(
                    width: 78,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: keyboardType,
                      textAlign: TextAlign.center,
                      cursorHeight: 14,
                      style: (textTheme.labelMedium ?? const TextStyle())
                          .copyWith(
                            fontSize: 12,
                            color: onSurface,
                            fontFeatures: const [FontFeature.tabularFigures()],
                            fontWeight: FontWeight.w600,
                          ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        border: InputBorder.none,
                        suffixText: suffix,
                        suffixStyle:
                            (textTheme.labelMedium ?? const TextStyle())
                                .copyWith(
                                  fontSize: 11,
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                    ),
                  )
                else
                  SizedBox(
                    width: 64,
                    child: Text(
                      value ?? '',
                      textAlign: TextAlign.center,
                      style: (textTheme.labelMedium ?? const TextStyle())
                          .copyWith(
                            fontSize: 12,
                            color: onSurface,
                            fontFeatures: const [FontFeature.tabularFigures()],
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                _StepperButton(icon: Icons.add, onTap: onIncrement),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: colorScheme.onSurface),
        ),
      ),
    );
  }
}

/// The current value remains available to assistive technology in icon-only mode.
class PlayerPillButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;
  final String tooltip;
  final bool isCompact;
  final bool showLabel;

  const PlayerPillButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.label,
    required this.tooltip,
    this.isCompact = false,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final visibleLabel = showLabel ? label : null;

    final padH = isCompact ? 8.0 : 10.0;
    final padV = isCompact ? 4.5 : 6.0;

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: .70),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: .35),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: isCompact ? 14 : 15, color: Colors.white),
              if (visibleLabel != null) ...[
                SizedBox(width: isCompact ? 4 : 6),
                Text(
                  visibleLabel,
                  style: (textTheme.labelMedium ?? const TextStyle()).copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: isCompact ? 11 : null,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    final accessibleButton = !showLabel && label != null
        ? Semantics(value: label, child: button)
        : button;
    return Tooltip(message: tooltip, child: accessibleButton);
  }
}
