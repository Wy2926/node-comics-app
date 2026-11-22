import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_setting_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/nodelane_reveal.dart';
import 'package:mangayomi/modules/widgets/nodelane_pane_layout.dart';

/// Search destinations lay out the finite settings page so a row below the
/// fold can be revealed immediately. Ordinary navigation keeps lazy layout.
class MobileSettingsList extends StatelessWidget {
  const MobileSettingsList({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => NodeLaneFormColumn(
    child: NodeLaneRevealScope.activeOf(context)
        ? SingleChildScrollView(
            padding: NodeLaneTokens.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          )
        : ListView(padding: NodeLaneTokens.pagePadding, children: children),
  );
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
  final List<SettingOption<T>> options;
  final ValueChanged<T> onChanged;
  final bool searchable;

  @override
  Widget build(BuildContext context) => NodeLaneRow(
    openOnReveal: true,
    title: title,
    value: label(value),
    icon: icon,
    onOpen: (anchor) async {
      final result = await showSettingChoice<T>(
        anchor,
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

/// Reader groups have a tighter gap and an outline.
class NodeLaneReaderScope extends InheritedWidget {
  const NodeLaneReaderScope({super.key, required super.child});

  @override
  bool updateShouldNotify(NodeLaneReaderScope oldWidget) => false;
}

class MobileSettingsGroup extends StatelessWidget {
  const MobileSettingsGroup({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (title != null) NodeLaneRevealScope.reveal(context, title!);
    final reader =
        context.dependOnInheritedWidgetOfExactType<NodeLaneReaderScope>() !=
        null;
    return Padding(
      padding: EdgeInsets.only(
        bottom: reader ? NodeLaneTokens.space16 : NodeLaneTokens.space24,
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
