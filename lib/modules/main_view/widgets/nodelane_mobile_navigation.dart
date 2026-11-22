import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_glass_surface.dart';
import 'package:mangayomi/modules/widgets/nodelane_brand_mark.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'ios_native_tab_bar.dart';
import 'mobile_navigation_destinations.dart';

/// Emits tab IDs; the shell resolves the grouped library to its current shelf.
class NodeLaneMobileNavigation extends StatelessWidget {
  const NodeLaneMobileNavigation({
    super.key,
    required this.routes,
    required this.location,
    required this.visible,
    required this.nativeIos,
    required this.onSelected,
    required this.child,
    this.badges = const {},
    this.maintainSpace = false,
  });
  final List<String> routes;
  final String? location;
  final bool visible, nativeIos;
  final bool maintainSpace;
  final ValueChanged<String> onSelected;
  final Map<String, int> badges;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final rail = !nativeIos && context.isAndroidTablet;
    final navigation = _navigation(context, rail);
    final shell = FloatingNavigationScope(
      enabled: !rail,
      child: Scaffold(
        backgroundColor: NodeLaneTokens.of(context).canvas,
        extendBody: !rail,
        body: Row(
          children: [
            if (rail) navigation,
            Expanded(
              child: SafeArea(
                top: false,
                left: false,
                right: false,
                bottom: rail,
                child: child,
              ),
            ),
          ],
        ),
        bottomNavigationBar: rail
            ? null
            : NodeLaneNoticeAvoidance(child: navigation),
      ),
    );
    if (nativeIos) return shell;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: shell,
    );
  }

  Widget _navigation(BuildContext context, bool rail) {
    if (routes.isEmpty) {
      return const SizedBox.shrink();
    }
    final height =
        (nativeIos
            ? 64.0
            : NodeLaneFlutterTabBar.barHeight(
                    MediaQuery.textScalerOf(context),
                  ) +
                  NodeLaneTokens.space8 * 2) +
        MediaQuery.viewPaddingOf(context).bottom;
    if (!visible) {
      // Pushed pages cover the shell. Keep its layout stable while offstage so
      // retained library scroll positions are not clamped to a shorter extent.
      if (rail) {
        // Also keep the grid under the user's finger when a long press starts selection.
        return const SafeArea(
          top: false,
          bottom: false,
          child: SizedBox(width: NodeLaneTokens.navigationRailWidth),
        );
      }
      return SizedBox(height: maintainSpace ? height : 0);
    }
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    final grouped = groupedMobileRoutes(routes);
    final tabs = rail ? grouped : visibleMobileTabs(grouped);
    final selected = selectedMobileTab(tabs, location);
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
          context.l10n.browser_title,
          icons.browser,
          icons.browserSelected,
          'square.on.square',
          'square.on.square.fill',
        ),
        '/browse' => (
          context.l10n.sources,
          icons.web,
          icons.web,
          'globe',
          'globe',
        ),
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
                  .fold(0, (total, route) => total + (badges[route] ?? 0))
            : badges[route] ?? 0,
      );
    }

    Future<void> selectTab(int index) async {
      final route = tabs[index];
      if (route != mobileOverflowTab) {
        onSelected(route);
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
                          route == location ||
                          route == mobileLibraryTab &&
                              libraryRoutes.containsValue(location),
                      value: (badges[route] ?? 0) > 0
                          ? '${badges[route]}'
                          : null,
                      onTap: () => Navigator.pop(context, route),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
      if (context.mounted && destination != null) onSelected(destination);
    }

    final items = tabs.map(item).toList();
    if (nativeIos) {
      return SizedBox(
        height: height,
        child: IosNativeTabBar(
          items: items.map((e) => e.nativeConfiguration).toList(),
          selectedIndex: selected,
          accent: colors.accent,
          dark: Theme.of(context).brightness == Brightness.dark,
          onSelected: selectTab,
        ),
      );
    }
    return NodeLaneFlutterTabBar(
      rail: rail,
      items: items,
      selectedIndex: selected,
      onSelected: selectTab,
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
    this.rail = false,
  });
  final List<MobileTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool rail;

  static double barHeight(TextScaler scaler) =>
      (NodeLaneTokens.iconSize +
              NodeLaneTokens.space4 +
              scaler.scale(NodeLaneTokens.navigationLabelSize) *
                  NodeLaneTokens.navigationLabelHeight +
              NodeLaneTokens.navigationInset * 2)
          .clamp(NodeLaneTokens.navigationHeight, double.infinity);

  @override
  Widget build(BuildContext context) {
    final height = barHeight(MediaQuery.textScalerOf(context));
    final tabs = [
      for (var index = 0; index < items.length; index++) _tab(context, index),
    ];
    final glass = NodeLaneGlassSurface(
      elevated: true,
      borderRadius: BorderRadius.circular(NodeLaneTokens.navigationRadius),
      child: Padding(
        padding: const EdgeInsets.all(NodeLaneTokens.navigationInset),
        child: rail
            ? SingleChildScrollView(
                primary: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: NodeLaneTokens.space12,
                      ),
                      child: Center(
                        child: NodeLaneBrandMark(
                          size: NodeLaneTokens.brandCompactMarkSize,
                        ),
                      ),
                    ),
                    for (final tab in tabs)
                      ConstrainedBox(
                        constraints: BoxConstraints(minHeight: height),
                        child: tab,
                      ),
                  ],
                ),
              )
            : SizedBox(
                height: height - NodeLaneTokens.navigationInset * 2,
                child: Row(
                  children: [for (final tab in tabs) Expanded(child: tab)],
                ),
              ),
      ),
    );
    return SafeArea(
      top: rail,
      maintainBottomViewPadding: true,
      child: SizedBox(
        width: rail ? NodeLaneTokens.navigationRailWidth : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: rail ? NodeLaneTokens.space8 : NodeLaneTokens.space16,
            vertical: rail ? NodeLaneTokens.space16 : NodeLaneTokens.space8,
          ),
          child: rail ? Center(child: glass) : glass,
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, int index) {
    final colors = NodeLaneTokens.of(context);
    return Semantics(
      selected: index == selectedIndex,
      button: true,
      label: items[index].label,
      value: items[index].badge > 0 ? '${items[index].badge}' : null,
      child: Tooltip(
        message: items[index].label,
        excludeFromSemantics: true,
        child: AnimatedContainer(
          duration: NodeLaneMotion.time(context),
          curve: NodeLaneMotion.curve,
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
                mainAxisSize: rail ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Badge(
                    isLabelVisible: items[index].badge > 0,
                    backgroundColor: colors.accent,
                    textColor: colors.onAccent,
                    textStyle: colors.caption,
                    label: Text(
                      items[index].badge > 99 ? '99+' : '${items[index].badge}',
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
                  const SizedBox(height: NodeLaneTokens.space4),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NodeLaneTokens.space4,
                    ),
                    child: Text(
                      items[index].label,
                      maxLines: rail ? 2 : 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: colors.caption.copyWith(
                        fontSize: NodeLaneTokens.navigationLabelSize,
                        height: NodeLaneTokens.navigationLabelHeight,
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
    );
  }
}
