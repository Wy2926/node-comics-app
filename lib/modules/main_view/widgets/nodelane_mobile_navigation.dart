import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'ios_native_tab_bar.dart';
import 'mobile_navigation_destinations.dart';

/// Presentation state only: the router and persisted navigation preferences
/// remain owned by MainScreen. Switching away remembers the last library type.
class NodeLaneMobileNavigation extends StatefulWidget {
  const NodeLaneMobileNavigation({
    super.key,
    required this.routes,
    required this.location,
    required this.visible,
    required this.nativeIos,
    required this.onSelected,
    this.badges = const {},
    this.maintainSpace = false,
  });
  final List<String> routes;
  final String? location;
  final bool visible, nativeIos;
  final bool maintainSpace;
  final ValueChanged<String> onSelected;
  final Map<String, int> badges;

  @override
  State<NodeLaneMobileNavigation> createState() =>
      _NodeLaneMobileNavigationState();
}

class _NodeLaneMobileNavigationState extends State<NodeLaneMobileNavigation> {
  String? _libraryRoute;

  void _select(String destination) {
    if (destination == mobileLibraryTab) {
      final libraries = widget.routes.where(mobileLibraryRoutes.contains);
      if (libraries.isEmpty) return;
      widget.onSelected(
        libraries.contains(_libraryRoute) ? _libraryRoute! : libraries.first,
      );
    } else {
      widget.onSelected(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mobileLibraryRoutes.contains(widget.location)) {
      _libraryRoute = widget.location;
    }
    if (widget.routes.isEmpty) {
      return const SizedBox.shrink();
    }
    final height =
        (widget.nativeIos
            ? 64.0
            : 58 + MediaQuery.textScalerOf(context).scale(12) * 1.2) +
        MediaQuery.viewPaddingOf(context).bottom;
    if (!widget.visible) {
      // Pushed pages cover the shell. Keep its layout stable while offstage so
      // retained library scroll positions are not clamped to a shorter extent.
      return SizedBox(height: widget.maintainSpace ? height : 0);
    }
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final grouped = groupedMobileRoutes(widget.routes);
    final visible = visibleMobileTabs(grouped);
    final selected = selectedMobileTab(visible, widget.location);
    MobileTabItem item(String route) {
      final (label, icon, symbol, selectedSymbol) = switch (route) {
        mobileLibraryTab => (
          l10n.library,
          Icons.auto_stories_rounded,
          'books.vertical',
          'books.vertical.fill',
        ),
        '/updates' => (
          l10n.updates,
          Icons.new_releases_outlined,
          'bell',
          'bell.fill',
        ),
        '/browser' => (
          '浏览器',
          Icons.tab_outlined,
          'square.on.square',
          'square.on.square.fill',
        ),
        '/browse' => ('来源', Icons.public_outlined, 'globe', 'globe'),
        '/trackerLibrary' => (
          l10n.tracking,
          Icons.account_tree_outlined,
          'list.bullet.rectangle',
          'list.bullet.rectangle.fill',
        ),
        _ => (l10n.more, Icons.more_horiz_rounded, 'ellipsis', 'ellipsis'),
      };
      return MobileTabItem(
        id: route,
        label: label,
        icon: icon,
        symbol: symbol,
        selectedSymbol: selectedSymbol,
        badge: route == mobileOverflowTab
            ? grouped
                  .skip(4)
                  .fold(
                    0,
                    (total, route) => total + (widget.badges[route] ?? 0),
                  )
            : widget.badges[route] ?? 0,
      );
    }

    Future<void> onSelected(int index) async {
      final route = visible[index];
      if (route != mobileOverflowTab) {
        _select(route);
        return;
      }
      final destination = await showNodeLaneCatalogSheet<String>(
        context,
        NodeLaneCatalogSheet(
          title: item(mobileOverflowTab).label,
          fitContent: true,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: [
              NodeLaneGroupSurface(
                children: [
                  for (final route in grouped.skip(4))
                    NodeLaneRow(
                      icon: item(route).icon,
                      title: item(route).label,
                      selected:
                          route == widget.location ||
                          route == mobileLibraryTab &&
                              mobileLibraryRoutes.contains(widget.location),
                      value: (widget.badges[route] ?? 0) > 0
                          ? '${widget.badges[route]}'
                          : null,
                      onTap: () => Navigator.pop(context, route),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
      if (mounted && destination != null) _select(destination);
    }

    final items = visible.map(item).toList();
    if (widget.nativeIos) {
      return SizedBox(
        height: height,
        child: IosNativeTabBar(
          items: items.map((e) => e.nativeConfiguration).toList(),
          selectedIndex: selected,
          accent: colors.accent,
          dark: Theme.of(context).brightness == Brightness.dark,
          onSelected: onSelected,
        ),
      );
    }
    return AndroidMobileTabBar(
      items: items,
      selectedIndex: selected,
      onSelected: onSelected,
    );
  }
}

class MobileTabItem {
  const MobileTabItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.symbol,
    required this.selectedSymbol,
    this.badge = 0,
  });
  final String id, label, symbol, selectedSymbol;
  final IconData icon;
  final int badge;
  Map<String, Object?> get nativeConfiguration => {
    'id': id,
    'label': label,
    'symbol': symbol,
    'selectedSymbol': selectedSymbol,
    'badge': badge,
  };
}

/// Android uses the same paper, ink, and accent tokens as the shelf.
class AndroidMobileTabBar extends StatelessWidget {
  const AndroidMobileTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });
  final List<MobileTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final labelHeight = MediaQuery.textScalerOf(context).scale(12) * 1.2;
    return Material(
      color: colors.surface,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.line)),
        ),
        child: SafeArea(
          top: false,
          maintainBottomViewPadding: true,
          child: SizedBox(
            height: 58 + labelHeight,
            child: Row(
              children: [
                for (var index = 0; index < items.length; index++)
                  Expanded(
                    child: Semantics(
                      selected: index == selectedIndex,
                      button: true,
                      label: items[index].label,
                      child: Tooltip(
                        message: items[index].label,
                        child: InkWell(
                          onTap: () => onSelected(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 8,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 54,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: index == selectedIndex
                                        ? colors.accentSoft
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Badge(
                                      isLabelVisible: items[index].badge > 0,
                                      label: Text('${items[index].badge}'),
                                      child: Icon(
                                        items[index].icon,
                                        size: 23,
                                        color: index == selectedIndex
                                            ? colors.accent
                                            : colors.muted,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ExcludeSemantics(
                                  child: Text(
                                    items[index].label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.2,
                                      fontWeight: index == selectedIndex
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: index == selectedIndex
                                          ? colors.accent
                                          : colors.muted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
