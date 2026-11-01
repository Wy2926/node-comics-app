import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// The mobile hierarchy is media, then sources or extensions. Routing and
/// queries stay with BrowseScreen; this header only presents their controls.
class MobileBrowseHeader extends StatelessWidget {
  const MobileBrowseHeader({
    super.key,
    required this.title,
    required this.mediaMenu,
    required this.sourcesLabel,
    required this.extensionsLabel,
    required this.extensionsSelected,
    required this.onSectionChanged,
    required this.searchHint,
    required this.searchController,
    required this.onQueryChanged,
    required this.onGlobalSearch,
    required this.filterLabel,
    required this.onFilter,
    required this.clearLabel,
    required this.actions,
    this.updateCount = 0,
  });

  final String title, sourcesLabel, extensionsLabel, searchHint;
  final String filterLabel, clearLabel;
  final Widget mediaMenu;
  final List<Widget> actions;
  final bool extensionsSelected;
  final int updateCount;
  final TextEditingController searchController;
  final ValueChanged<bool> onSectionChanged;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onGlobalSearch, onFilter;

  @override
  Widget build(BuildContext context) {
    final inheritedMetrics = MediaQuery.of(context);
    // Scaffold consumes the keyboard inset. Subscribe to the view's metrics
    // here so dismissing Android's keyboard restores the header without a tap.
    return MediaQuery.fromView(
      view: View.of(context),
      child: Builder(
        builder: (keyboardContext) => MediaQuery(
          // Retain the surrounding safe-area and user text-scale adjustments.
          data: inheritedMetrics,
          child: _content(
            context,
            MediaQuery.viewInsetsOf(keyboardContext).bottom > 0,
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, bool compact) {
    final icons = NodeLaneIcons.of(context);
    return Padding(
      padding: NodeLaneTokens.headerPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            NodeLanePageHeading(
              title: title,
              mediaMenu: mediaMenu,
              actions: actions,
            ),
            const SizedBox(height: NodeLaneTokens.space16),
            NodeLaneSegments<bool>(
              value: extensionsSelected,
              onChanged: onSectionChanged,
              segments: [
                ButtonSegment(value: false, label: Text(sourcesLabel)),
                ButtonSegment(
                  value: true,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: Text(extensionsLabel)),
                      if (updateCount > 0) ...[
                        const SizedBox(width: NodeLaneTokens.space8),
                        Badge(label: Text(updateCount.toString())),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: NodeLaneTokens.space16),
          ],
          Row(
            children: [
              Expanded(
                child: extensionsSelected
                    ? NodeLaneSearchField(
                        controller: searchController,
                        hint: searchHint,
                        onChanged: onQueryChanged,
                        clearLabel: clearLabel,
                      )
                    : NodeLaneSearchLink(
                        hint: searchHint,
                        onTap: onGlobalSearch,
                      ),
              ),
              const SizedBox(width: NodeLaneTokens.space8),
              NodeLaneIconButton(
                tooltip: filterLabel,
                onPressed: onFilter,
                icon: extensionsSelected ? icons.translate : icons.filter,
                style: NodeLaneIconButtonStyle.field,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
