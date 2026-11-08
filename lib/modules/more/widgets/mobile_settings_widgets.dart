import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';
import 'package:mangayomi/modules/widgets/nodelane_reveal.dart';

/// Search destinations lay out the finite settings page so a row below the
/// fold can be revealed immediately. Ordinary navigation keeps lazy layout.
class MobileSettingsList extends StatelessWidget {
  const MobileSettingsList({
    super.key,
    required this.children,
    this.padding = NodeLaneTokens.pagePadding,
  });
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => NodeLaneRevealScope.activeOf(context)
      ? SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        )
      : ListView(padding: padding, children: children);
}

/// Choice presentation and cancellation only; preference writes stay with callers.
class MobileSettingsChoice<T> extends StatelessWidget {
  const MobileSettingsChoice({
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
    openOnReveal: true,
    title: title,
    value: label(value),
    icon: icon,
    onTap: () async {
      final result = await showMobileSettingsPicker<T>(
        context,
        title: title,
        current: value,
        options: options,
        searchable: searchable,
        inSheet: NodeLaneReaderScope.activeOf(context),
      );
      if (context.mounted && result != null && result.value != value) {
        onChanged(result.value);
      }
    },
  );
}

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
    if (title != null) NodeLaneRevealScope.reveal(context, title!);
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
