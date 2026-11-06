import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_glass_surface.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
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
            : NodeLaneFlutterTabBar.barHeight(
                    MediaQuery.textScalerOf(context),
                  ) +
                  NodeLaneTokens.space8 * 2) +
        MediaQuery.viewPaddingOf(context).bottom;
    if (!widget.visible) {
      // Pushed pages cover the shell. Keep its layout stable while offstage so
      // retained library scroll positions are not clamped to a shorter extent.
      return SizedBox(height: widget.maintainSpace ? height : 0);
    }
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    final grouped = groupedMobileRoutes(widget.routes);
    final visible = visibleMobileTabs(grouped);
    final selected = selectedMobileTab(visible, widget.location);
    MobileTabItem item(String route) {
      final (
        label,
        icon,
        selectedIcon,
        symbol,
        selectedSymbol,
      ) = switch (route) {
        mobileLibraryTab => (
          l10n.library,
          icons.library,
          icons.librarySelected,
          'books.vertical',
          'books.vertical.fill',
        ),
        '/updates' => (
          l10n.updates,
          icons.updates,
          icons.updatesSelected,
          'bell',
          'bell.fill',
        ),
        '/browser' => (
          '浏览器',
          icons.browser,
          icons.browserSelected,
          'square.on.square',
          'square.on.square.fill',
        ),
        '/browse' => ('来源', icons.web, icons.web, 'globe', 'globe'),
        '/trackerLibrary' => (
          l10n.tracking,
          icons.chapters,
          icons.chapters,
          'list.bullet.rectangle',
          'list.bullet.rectangle.fill',
        ),
        _ => (l10n.more, icons.more, icons.more, 'ellipsis', 'ellipsis'),
      };
      return MobileTabItem(
        id: route,
        label: label,
        icon: icon,
        selectedIcon: selectedIcon,
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
    return NodeLaneFlutterTabBar(
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
    required this.selectedIcon,
    required this.symbol,
    required this.selectedSymbol,
    this.badge = 0,
  });
  final String id, label, symbol, selectedSymbol;
  final IconData icon, selectedIcon;
  final int badge;
  Map<String, Object?> get nativeConfiguration => {
    'id': id,
    'label': label,
    'symbol': symbol,
    'selectedSymbol': selectedSymbol,
    'badge': badge,
  };
}

/// Flutter navigation shares the floating-control material and semantic icons.
/// iOS retains its native tab bar; routing and badge ownership stay in the shell.
class NodeLaneFlutterTabBar extends StatelessWidget {
  const NodeLaneFlutterTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });
  final List<MobileTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static double barHeight(TextScaler scaler) =>
      (NodeLaneTokens.iconSize +
              NodeLaneTokens.space4 +
              scaler.scale(NodeLaneTokens.navigationLabelSize) *
                  NodeLaneTokens.navigationLabelHeight +
              NodeLaneTokens.navigationInset * 2)
          .clamp(NodeLaneTokens.navigationHeight, double.infinity);

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return SafeArea(
      top: false,
      maintainBottomViewPadding: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: NodeLaneTokens.space16,
          vertical: NodeLaneTokens.space8,
        ),
        child: NodeLaneGlassSurface(
          elevated: true,
          borderRadius: BorderRadius.circular(NodeLaneTokens.navigationRadius),
          child: SizedBox(
            height: barHeight(MediaQuery.textScalerOf(context)),
            child: Padding(
              padding: const EdgeInsets.all(NodeLaneTokens.navigationInset),
              child: Row(
                children: [
                  for (var index = 0; index < items.length; index++)
                    Expanded(
                      child: Semantics(
                        selected: index == selectedIndex,
                        button: true,
                        label: items[index].label,
                        value: items[index].badge > 0
                            ? '${items[index].badge}'
                            : null,
                        child: Tooltip(
                          message: items[index].label,
                          excludeFromSemantics: true,
                          child: AnimatedContainer(
                            duration: MediaQuery.disableAnimationsOf(context)
                                ? Duration.zero
                                : NodeLaneTokens.disclosureDuration,
                            curve: Curves.easeOutCubic,
                            decoration: ShapeDecoration(
                              color: index == selectedIndex
                                  ? colors.accentSoft
                                  : Colors.transparent,
                              shape: const StadiumBorder(),
                            ),
                            child: InkWell(
                              customBorder: const StadiumBorder(),
                              onTap: () => onSelected(index),
                              child: ExcludeSemantics(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Badge(
                                      isLabelVisible: items[index].badge > 0,
                                      backgroundColor: colors.accent,
                                      textColor: colors.onAccent,
                                      textStyle: colors.caption,
                                      label: Text(
                                        items[index].badge > 99
                                            ? '99+'
                                            : '${items[index].badge}',
                                      ),
                                      child: Icon(
                                        index == selectedIndex
                                            ? items[index].selectedIcon
                                            : items[index].icon,
                                        size: NodeLaneTokens.iconSize,
                                        color: index == selectedIndex
                                            ? colors.accent
                                            : colors.ink,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: NodeLaneTokens.space4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: NodeLaneTokens.space4,
                                      ),
                                      child: Text(
                                        items[index].label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: colors.caption.copyWith(
                                          fontSize: NodeLaneTokens
                                              .navigationLabelSize,
                                          height: NodeLaneTokens
                                              .navigationLabelHeight,
                                          fontWeight: index == selectedIndex
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: index == selectedIndex
                                              ? colors.accent
                                              : colors.ink,
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
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
