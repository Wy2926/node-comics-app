import 'package:mangayomi/services/app_update_manifest.dart';

import 'dart:async';
import 'dart:io';

import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/about/app_update_dialog.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/floating_navigation_bar_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/modules/widgets/loading_icon.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/modules/main_view/nav_shrink.dart';
import 'package:mangayomi/modules/main_view/providers/migration.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/auto_backup.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/main_view/widgets/tablet_layout.dart';
import 'package:mangayomi/modules/main_view/widgets/mobile_bottom_navigation.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_badges.dart';
import 'package:mangayomi/modules/main_view/widgets/nodelane_mobile_navigation.dart';
import 'package:mangayomi/modules/main_view/widgets/mobile_navigation_destinations.dart';
import 'package:mangayomi/utils/item_type_filters.dart';

/// Nav destinations kept off the anime-only TV layout (the manga & novel
/// libraries). True means "keep this destination".
bool _isNotHiddenLibOnTv(String nav) =>
    nav != "/MangaLibrary" && nav != "/NovelLibrary";

final _visibleRoutes = Provider<List<String>>((ref) {
  final hidden = ref.watch(hideItemsStateProvider);
  final animeOnly = ref.watch(animeOnlyTvModeProvider);
  return ref
      .watch(navigationOrderStateProvider)
      .where(
        (route) =>
            !hidden.contains(route) &&
            (!animeOnly || _isNotHiddenLibOnTv(route)),
      )
      .toList();
});

/// How close together two taps on the same nav destination need to land to
/// count as a double-tap/double-click, rather than two separate single taps.
const _navDoubleTapWindow = Duration(milliseconds: 450);

/// Whether tapping [current] counts as a double-tap on [last], given when
/// [last] landed. Shared by the desktop rail and mobile bottom bar, which
/// each track their own last-tap state (an index vs. a route string) but
/// apply the same timing check to it.
bool isNavDoubleTap<T>(
  T current,
  T? last,
  DateTime? lastTapTime,
  DateTime now,
) {
  return current == last &&
      lastTapTime != null &&
      now.difference(lastTapTime) < _navDoubleTapWindow;
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  /// More has no media of its own. Use the last visible shelf, or the first
  /// library in the user's navigation order before they have visited one.
  static ItemType? libraryForTools(BuildContext context) => libraryTypeForRoute(
    context.findAncestorStateOfType<_MainScreenState>()?._libraryRoute,
  );

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  Timer? _backupTimer;
  Timer? _syncTimer;

  static final Map<String, String> _hyphenatedLabelsCache = {};

  final Map<String, List<NavigationRailDestination>> _desktopDestinationsCache =
      {};

  // Double-tapping a Manga/Anime/Novel destination on the mobile bottom bar
  // opens Global Search scoped to that type, mirroring the desktop rail's
  // double-click. Keyed by destination string since the bottom bar callback
  // only hands back the route, not an index.
  String? _lastMobileNavDest;
  String? _lastLibraryRoute;
  String? get _libraryRoute =>
      preferredLibraryRoute(ref.read(_visibleRoutes), _lastLibraryRoute);
  DateTime? _lastMobileNavTapTime;
  final Map<String, List<Widget>> _mobileDestinationsCache = {};
  void _clearCache() {
    _hyphenatedLabelsCache.clear();
    _desktopDestinationsCache.clear();
    _mobileDestinationsCache.clear();
  }

  String getHyphenatedUpdatesLabel(String languageCode, String defaultLabel) {
    final cacheKey = '$languageCode:$defaultLabel';
    return _hyphenatedLabelsCache.putIfAbsent(cacheKey, () {
      switch (languageCode) {
        case 'de':
          return "Aktuali-\nsierungen";
        case 'es':
        case 'es_419':
          return "Actuali-\nzaciones";
        case 'it':
          return "Aggiorna-\nmenti";
        case 'tr':
          return "Güncel-\nlemeler";
        default:
          return defaultLabel;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    final hiddenItems = ref.read(hideItemsStateProvider);
    final defaultLocation =
        ref.read(_visibleRoutes).firstOrNull ?? "/AnimeLibrary";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // The router already chooses the launch destination. When setup closes
        // this shell mounts again, so an unconditional redirect loses the
        // explicit source/library destination selected during onboarding.
        final location = GoRouter.of(context)
            .routeInformationProvider
            .value
            .uri
            .path;
        if (hiddenItems.contains(location) ||
            (ref.read(animeOnlyTvModeProvider) &&
                !_isNotHiddenLibOnTv(location))) {
          context.go(defaultLocation);
        }
        _initializeTimers();
        _initializeProviders();
      }
    });

    discordRpc?.connect(ref);
  }

  void _rescheduleSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = null;

    if (ref.read(restoreSyncGuardProvider)) return;

    final syncPrefs = ref.read(synchingProvider(syncId: 1));
    final freq = syncPrefs.autoSyncFrequency;
    if (syncPrefs.syncOn &&
        freq > 0 &&
        (syncPrefs.authToken?.isNotEmpty ?? false)) {
      _syncTimer = Timer.periodic(Duration(seconds: freq), _onSyncTimerTick);
    }
  }

  void _initializeTimers() {
    _backupTimer = Timer.periodic(
      const Duration(minutes: 5),
      _onBackupTimerTick,
    );

    _rescheduleSyncTimer();

    // Pauses the auto-sync timer for the duration of a restore (and its
    // post-restore upload), instead of just rescheduling it — a restore can
    // outlast one sync interval, so a reschedule alone could still let the
    // timer fire mid-restore. syncServerProvider.startSync also checks this
    // guard directly, covering a manual sync trigger too.
    ref.listenManual<bool>(restoreSyncGuardProvider, (_, restoring) {
      if (restoring) {
        _syncTimer?.cancel();
        _syncTimer = null;
        return;
      }
      _rescheduleSyncTimer();
    });

    // Listen to changes in sync preferences (frequency, syncOn, login/logout)
    // and immediately reschedule the timer and check if due.
    ref.listenManual(synchingProvider(syncId: 1), (prev, next) {
      _rescheduleSyncTimer();
      if (mounted) {
        unawaited(autoSyncIfDue(ref));
      }
    });
  }

  bool _updatePromptOpen = false;

  Future<void> _announceUpdate(UpdateInfo update) async {
    if (_updatePromptOpen) return;
    _updatePromptOpen = true;
    try {
      await showAppUpdateAnnouncement(context, update);
    } finally {
      _updatePromptOpen = false;
    }
  }

  void _initializeProviders() {
    // The extension-repo fetches (one per item type) and the GitHub update
    // check hit the network; delay them so they don't compete with the first
    // paint and the initial library queries.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        for (var type in ItemType.values) {
          ref.read(
            fetchItemSourcesListProvider(
              id: null,
              reFresh: false,
              itemType: type,
            ),
          );
        }
      }
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted || isTv) return;
      ref.listenManual<AsyncValue<UpdateInfo?>>(checkForUpdateProvider, (
        _,
        next,
      ) {
        next.whenData((updateInfo) {
          if (updateInfo != null && mounted) {
            unawaited(_announceUpdate(updateInfo));
          }
        });
      });
    });
  }

  void _onBackupTimerTick(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }
    ref.read(checkAndBackupProvider);
  }

  void _onSyncTimerTick(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }
    unawaited(autoSyncIfDue(ref));
  }

  @override
  void dispose() {
    _backupTimer?.cancel();
    _syncTimer?.cancel();
    discordRpc?.disconnect();
    super.dispose();
  }

  int currentIndex = 0;
  bool isLibSwitch = false;

  final NavShrink _navShrink = NavShrink();

  bool _onPageScroll(
    ScrollNotification notification, {
    required bool useFloatingNav,
  }) {
    if (!useFloatingNav || notification.metrics.axis != Axis.vertical) {
      return false;
    }

    var changed = false;
    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      if (metrics.maxScrollExtent <= 0 ||
          metrics.pixels <= metrics.minScrollExtent) {
        changed = _navShrink.reset();
      } else {
        changed = _navShrink.update(notification.scrollDelta ?? 0);
      }
    }
    if (changed) setState(() {});
    return false;
  }

  void _wakeNav() {
    if (_navShrink.reset()) setState(() {});
  }

  void _selectRoute(String destination) {
    final now = DateTime.now();
    final isDoubleTap = isNavDoubleTap(
      destination,
      _lastMobileNavDest,
      _lastMobileNavTapTime,
      now,
    );
    final itemType = libraryTypeForRoute(destination);
    if (isDoubleTap && itemType != null) {
      _lastMobileNavDest = null;
      _lastMobileNavTapTime = null;
      context.push('/globalSearch', extra: (null, itemType));
      return;
    }
    _lastMobileNavDest = destination;
    _lastMobileNavTapTime = now;
    context.go(destination);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Locale>(l10nLocaleStateProvider, (previous, next) {
      _clearCache();
      setState(() {});
    });
    // Destinations are cached by route list alone, so a toggle that only
    // changes what's baked into those same widgets (the tooltip) needs its
    // own cache-busting listener, same as the locale above.
    ref.listen<bool>(showNavDoubleTapTooltipStateProvider, (previous, next) {
      _clearCache();
      setState(() {});
    });
    ref.listen<bool>(floatingNavigationBarStateProvider, (previous, next) {
      if (!next) _wakeNav();
    });

    final l10n = context.l10n;
    final route = GoRouter.of(context);
    final navigationOrder = ref.watch(navigationOrderStateProvider);
    final visibleRoutes = ref.watch(_visibleRoutes);
    final mergeLibraryNavMobile = ref.watch(mergeLibraryNavMobileStateProvider);
    final migration = ref.watch(migrationProvider);
    return ListenableBuilder(
      listenable: route.routerDelegate,
      builder: (context, _) {
        final location = route.state.uri.path;
        if (libraryRoutes.containsValue(location) &&
            visibleRoutes.contains(location)) {
          _lastLibraryRoute = location;
        }
        return migration.when(
          data: (_) => Consumer(
            builder: (context, ref, child) {
              final useFloatingNav = shouldUseFloatingNav(
                enabled: ref.watch(floatingNavigationBarStateProvider),
              );
              final prefersNavRail = context.prefersNavRail(
                useFloatingNav: useFloatingNav,
              );
              final isLongPressed = ref.watch(isLongPressedStateProvider);
              if (isMobile &&
                  !isTv &&
                  (Platform.isAndroid || !prefersNavRail)) {
                return NavigationBadgeCounts(
                  routes: visibleRoutes,
                  builder: (badges) => NodeLaneMobileNavigation(
                    routes: visibleRoutes,
                    location: location,
                    visible:
                        !isLongPressed && navigationOrder.contains(location),
                    maintainSpace: !isLongPressed,
                    nativeIos: Platform.isIOS,
                    badges: badges,
                    onSelected: (tab) {
                      final destination = tab == mobileLibraryTab
                          ? _libraryRoute
                          : tab;
                      if (destination == null) return;
                      if (destination != location) dismissNodeLaneNotice();
                      _selectRoute(destination);
                    },
                    child: widget.child,
                  ),
                );
              }
              final mergedLibrary =
                  mergeLibraryNavMobile && !prefersNavRail && !isLibSwitch;
              final dest = !prefersNavRail && isLibSwitch
                  ? [
                      "_disableLibSwitch",
                      ...visibleRoutes.where(libraryRoutes.containsValue),
                    ]
                  : mergedLibrary
                  ? groupedMobileRoutes(visibleRoutes)
                  : visibleRoutes;

              if (isLibSwitch &&
                  (currentIndex >= dest.length ||
                      !libraryRoutes.containsValue(location))) {
                currentIndex = 0;
              } else {
                final currentIdx = dest.indexOf(
                  mergedLibrary && libraryRoutes.containsValue(location)
                      ? mobileLibraryTab
                      : location,
                );
                if (currentIdx != -1) {
                  currentIndex = currentIdx;
                }
              }

              return FloatingNavigationScope(
                enabled: useFloatingNav,
                child: Scaffold(
                  extendBody: useFloatingNav,
                  body: NotificationListener<ScrollNotification>(
                    onNotification: (notification) => _onPageScroll(
                      notification,
                      useFloatingNav: useFloatingNav,
                    ),
                    child: prefersNavRail
                        ? MainTabletLayout(
                            isLongPressed: isLongPressed,
                            location: location,
                            dest: dest,
                            currentIndex: currentIndex,
                            route: route,
                            ref: ref,
                            buildNavigationWidgetsDesktop:
                                _buildNavigationWidgetsDesktop,
                            child: widget.child,
                          )
                        : widget.child,
                  ),
                  bottomNavigationBar: prefersNavRail
                      ? null
                      : MainMobileBottomNavigation(
                          isLongPressed: isLongPressed,
                          location: location,
                          currentIndex: currentIndex,
                          dest: dest,
                          route: route,
                          ref: ref,
                          useFloatingNav: useFloatingNav,
                          shrink: _navShrink.shrunk ? 1.0 : 0.0,
                          onWake: _wakeNav,
                          buildNavigationWidgetsMobile:
                              _buildNavigationWidgetsMobile,
                          onDestinationSelected: (destination) {
                            if (destination == mobileLibraryTab) {
                              setState(() {
                                isLibSwitch = true;
                              });
                              if (!libraryRoutes.containsValue(location)) {
                                final target = visibleRoutes
                                    .where(libraryRoutes.containsValue)
                                    .firstOrNull;
                                if (target != null) route.go(target);
                              }
                            } else if (destination == "_disableLibSwitch") {
                              setState(() {
                                isLibSwitch = false;
                              });
                            } else {
                              _selectRoute(destination);
                            }
                          },
                        ),
                ),
              );
            },
          ),
          // A failed migration used to render the loading screen, so the app
          // sat on a blank splash forever with nothing to act on. Show what
          // happened and let the user run it again.
          error: (error, _) => Scaffold(
            body: NodeLaneEmptyState.error(
              title: l10n.startup_failed,
              message: error.toString(),
              onRetry: () => ref.invalidate(migrationProvider),
            ),
          ),
          loading: () => const LoadingIcon(),
        );
      },
    );
  }

  /// Wraps [icon] in a [Tooltip] with [message] unless the user turned the
  /// nav double-tap hint off in Settings, in which case it's the bare icon.
  Widget _navTooltipIcon(bool showTooltip, String message, Widget icon) {
    return showTooltip ? Tooltip(message: message, child: icon) : icon;
  }

  List<NavigationRailDestination> _buildNavigationWidgetsDesktop(
    WidgetRef ref,
    List<String> dest,
    BuildContext context,
  ) {
    final cacheKey = dest.join(',');
    if (_desktopDestinationsCache.containsKey(cacheKey)) {
      return _desktopDestinationsCache[cacheKey]!;
    }

    final l10n = context.l10n;
    final showTooltip = ref.read(showNavDoubleTapTooltipStateProvider);
    final destinations = List<NavigationRailDestination?>.filled(
      dest.length,
      null,
    );

    if (dest.contains("/MangaLibrary")) {
      destinations[dest.indexOf("/MangaLibrary")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: _navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.manga),
          const Icon(Icons.book_rounded),
        ),
        icon: _navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.manga),
          const Icon(Icons.book_outlined),
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.manga),
        ),
      );
    }
    if (dest.contains("/AnimeLibrary")) {
      destinations[dest.indexOf("/AnimeLibrary")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: _navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.anime),
          const Icon(Icons.video_collection_rounded),
        ),
        icon: _navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.anime),
          const Icon(Icons.video_collection_outlined),
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.anime),
        ),
      );
    }
    if (dest.contains("/NovelLibrary")) {
      destinations[dest.indexOf("/NovelLibrary")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: _navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.novel),
          const Icon(Icons.auto_stories_rounded),
        ),
        icon: _navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.novel),
          const Icon(Icons.auto_stories_outlined),
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.novel),
        ),
      );
    }
    if (dest.contains("/updates")) {
      destinations[dest.indexOf("/updates")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: UpdatesBadgeWidget(
          icon: const Icon(Icons.new_releases_rounded),
          ref: ref,
        ),
        icon: UpdatesBadgeWidget(
          icon: const Icon(Icons.new_releases_outlined),
          ref: ref,
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            getHyphenatedUpdatesLabel(
              ref.watch(l10nLocaleStateProvider).languageCode,
              l10n.updates,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (dest.contains("/browser")) {
      destinations[dest.indexOf("/browser")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: const Icon(Icons.tab),
        icon: const Icon(Icons.tab_outlined),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(context.l10n.browser_title),
        ),
      );
    }
    if (dest.contains("/browse")) {
      destinations[dest.indexOf("/browse")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: ExtensionBadgeWidget(
          icon: const Icon(Icons.explore_rounded),
          ref: ref,
        ),
        icon: ExtensionBadgeWidget(
          icon: const Icon(Icons.explore_outlined),
          ref: ref,
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.browse),
        ),
      );
    }
    if (dest.contains("/more")) {
      destinations[dest.indexOf("/more")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: const Icon(Icons.more_horiz_rounded),
        icon: const Icon(Icons.more_horiz_outlined),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.more),
        ),
      );
    }
    if (dest.contains("/trackerLibrary")) {
      destinations[dest.indexOf("/trackerLibrary")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: const Icon(Icons.account_tree_rounded),
        icon: const Icon(Icons.account_tree_outlined),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.tracking),
        ),
      );
    }

    final result = destinations.nonNulls.toList();
    _desktopDestinationsCache[cacheKey] = result;
    return result;
  }

  List<Widget> _buildNavigationWidgetsMobile(
    WidgetRef ref,
    List<String> dest,
    BuildContext context,
  ) {
    final cacheKey = dest.join(',');
    if (_mobileDestinationsCache.containsKey(cacheKey)) {
      return _mobileDestinationsCache[cacheKey]!;
    }

    final l10n = context.l10n;
    final showTooltip = ref.read(showNavDoubleTapTooltipStateProvider);
    final destinations = List<Widget>.filled(
      dest.length,
      const SizedBox.shrink(),
    );

    if (dest.contains("_disableLibSwitch")) {
      destinations[dest.indexOf("_disableLibSwitch")] = NavigationDestination(
        selectedIcon: const Icon(Icons.arrow_back_rounded),
        icon: const Icon(Icons.arrow_back_rounded),
        label: l10n.go_back,
      );
    }
    if (dest.contains(mobileLibraryTab)) {
      destinations[dest.indexOf(mobileLibraryTab)] = NavigationDestination(
        selectedIcon: const Icon(Icons.collections_bookmark_rounded),
        icon: const Icon(Icons.collections_bookmark_outlined),
        label: l10n.library,
      );
    }
    if (dest.contains("/MangaLibrary")) {
      destinations[dest.indexOf("/MangaLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Icons.book_rounded),
        icon: const Icon(Icons.book_outlined),
        label: l10n.manga,
        tooltip: showTooltip ? l10n.double_tap_search_hint(l10n.manga) : '',
      );
    }
    if (dest.contains("/AnimeLibrary")) {
      destinations[dest.indexOf("/AnimeLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Icons.video_collection_rounded),
        icon: const Icon(Icons.video_collection_outlined),
        label: l10n.anime,
        tooltip: showTooltip ? l10n.double_tap_search_hint(l10n.anime) : '',
      );
    }
    if (dest.contains("/NovelLibrary")) {
      destinations[dest.indexOf("/NovelLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Icons.auto_stories_rounded),
        icon: const Icon(Icons.auto_stories_outlined),
        label: l10n.novel,
        tooltip: showTooltip ? l10n.double_tap_search_hint(l10n.novel) : '',
      );
    }
    if (dest.contains("/updates")) {
      destinations[dest.indexOf("/updates")] = NavigationDestination(
        selectedIcon: UpdatesBadgeWidget(
          icon: const Icon(Icons.new_releases_rounded),
          ref: ref,
        ),
        icon: UpdatesBadgeWidget(
          icon: const Icon(Icons.new_releases_outlined),
          ref: ref,
        ),
        label: l10n.updates,
      );
    }
    if (dest.contains("/browser")) {
      destinations[dest.indexOf("/browser")] = NavigationDestination(
        selectedIcon: const Icon(Icons.tab),
        icon: const Icon(Icons.tab_outlined),
        label: context.l10n.browser_title,
      );
    }
    if (dest.contains("/browse")) {
      destinations[dest.indexOf("/browse")] = NavigationDestination(
        selectedIcon: ExtensionBadgeWidget(
          icon: const Icon(Icons.explore_rounded),
          ref: ref,
        ),
        icon: ExtensionBadgeWidget(
          icon: const Icon(Icons.explore_outlined),
          ref: ref,
        ),
        label: l10n.browse,
      );
    }
    if (dest.contains("/more")) {
      destinations[dest.indexOf("/more")] = NavigationDestination(
        selectedIcon: const Icon(Icons.more_horiz_rounded),
        icon: const Icon(Icons.more_horiz_outlined),
        label: l10n.more,
      );
    }
    if (dest.contains("/trackerLibrary")) {
      destinations[dest.indexOf("/trackerLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Icons.account_tree_rounded),
        icon: const Icon(Icons.account_tree_outlined),
        label: l10n.tracking,
      );
    }

    _mobileDestinationsCache[cacheKey] = destinations;
    return destinations;
  }
}
