import 'package:mangayomi/modules/widgets/nodelane_notice.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/widgets/floating_nav_bar.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'nav_badges.dart';
import 'nodelane_mobile_navigation.dart';

class MainMobileBottomNavigation extends StatelessWidget {
  const MainMobileBottomNavigation({
    super.key,
    required this.isLongPressed,
    required this.location,
    required this.currentIndex,
    required this.dest,
    required this.route,
    required this.ref,
    required this.buildNavigationWidgetsMobile,
    required this.onDestinationSelected,
    required this.useFloatingNav,
    this.shrink = 0,
    this.onWake,
    this.mobileRoutes,
  });

  final bool isLongPressed;
  final String? location;
  final int currentIndex;
  final List<String> dest;
  final GoRouter route;
  final WidgetRef ref;
  final List<Widget> Function(WidgetRef, List<String>, BuildContext)
  buildNavigationWidgetsMobile;
  final Function(String) onDestinationSelected;
  final bool useFloatingNav;
  final double shrink;
  final VoidCallback? onWake;
  final List<String>? mobileRoutes;

  @override
  Widget build(BuildContext context) =>
      NodeLaneNoticeAvoidance(child: _buildNavigation(context));

  void _selectDestination(String destination) {
    if (destination != location) dismissNodeLaneNotice();
    onDestinationSelected(destination);
  }

  Widget _buildNavigation(BuildContext context) {
    if (isMobile && !isTv && mobileRoutes != null) {
      return NavigationBadgeCounts(
        routes: mobileRoutes!,
        builder: (badges) => NodeLaneMobileNavigation(
          routes: mobileRoutes!,
          location: location,
          visible: _getBottomNavigationHeight(isLongPressed, location) != 0,
          maintainSpace: !isLongPressed,
          nativeIos: Platform.isIOS,
          badges: badges,
          onSelected: _selectDestination,
        ),
      );
    }
    if (useFloatingNav) {
      return SizedBox(
        width: context.width(1),
        height: _getBottomNavigationHeight(isLongPressed, location),
        child: FloatingNavBar(
          destinations: buildNavigationWidgetsMobile(
            ref,
            dest,
            context,
          ).cast<NavigationDestination>(),
          currentIndex: currentIndex,
          onSelected: (newIndex) => _selectDestination(dest[newIndex]),
          showLabels: context.isLandscape,
          shrink: shrink,
          onWake: onWake,
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      width: context.width(1),
      height: _getBottomNavigationHeight(isLongPressed, location),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(overflow: TextOverflow.ellipsis),
          ),
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: NavigationBar(
          animationDuration: const Duration(milliseconds: 500),
          selectedIndex: currentIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: buildNavigationWidgetsMobile(ref, dest, context),
          onDestinationSelected: (newIndex) {
            _selectDestination(dest[newIndex]);
          },
        ),
      ),
    );
  }

  static double? _getBottomNavigationHeight(
    bool isLongPressed,
    String? location,
  ) {
    if (isLongPressed) return 0;

    const validLocations = {
      '/MangaLibrary',
      '/AnimeLibrary',
      '/NovelLibrary',
      '/browser',
      '/updates',
      '/browse',
      '/more',
      '/trackerLibrary',
    };

    return (location == null || validLocations.contains(location)) ? null : 0;
  }
}
