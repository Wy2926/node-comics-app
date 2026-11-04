import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/modules/main_view/main_screen.dart';
import 'package:mangayomi/modules/main_view/providers/migration.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/floating_navigation_bar_state_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';

class _Order extends NavigationOrderState {
  @override
  List<String> build() => [
    '/MangaLibrary',
    '/AnimeLibrary',
    '/NovelLibrary',
    '/browse',
    '/more',
  ];
}

class _Hidden extends HideItemsState {
  _Hidden(this.hidden);
  final List<String> hidden;
  @override
  List<String> build() => hidden;
}

class _Tv extends AnimeOnlyTvMode {
  _Tv(this.enabled);
  final bool enabled;
  @override
  bool build() => enabled;
}

class _Locale extends L10nLocaleState {
  @override
  Locale build() => const Locale('en');
}

class _Tooltips extends ShowNavDoubleTapTooltipState {
  @override
  bool build() => false;
}

class _Floating extends FloatingNavigationBarState {
  @override
  bool build() => false;
}

class _Merged extends MergeLibraryNavMobileState {
  @override
  bool build() => false;
}

class _Sync extends Synching {
  @override
  SyncPreference build({required int? syncId}) => SyncPreference(syncId: 1);
}

class _Location extends RouterCurrentLocationState {
  @override
  String? build() => null;
}

void main() {
  for (final scenario in [
    (path: '/browse', hidden: <String>[], tv: false, expected: '/browse'),
    (
      path: '/NovelLibrary',
      hidden: <String>[],
      tv: false,
      expected: '/NovelLibrary',
    ),
    (
      path: '/more/about',
      hidden: <String>[],
      tv: false,
      expected: '/more/about',
    ),
    (
      path: '/MangaLibrary',
      hidden: ['/MangaLibrary'],
      tv: false,
      expected: '/AnimeLibrary',
    ),
    (
      path: '/MangaLibrary',
      hidden: <String>[],
      tv: true,
      expected: '/AnimeLibrary',
    ),
  ]) {
    testWidgets(
      'shell mount keeps explicit ${scenario.path}, hidden=${scenario.hidden}, tv=${scenario.tv}',
      (tester) async {
        final router = GoRouter(
          initialLocation: scenario.path,
          routes: [
            ShellRoute(
              builder: (_, _, child) => MainScreen(child: child),
              routes: [
                for (final path in [
                  '/MangaLibrary',
                  '/AnimeLibrary',
                  '/NovelLibrary',
                  '/browse',
                  '/more/about',
                ])
                  GoRoute(path: path, builder: (_, _) => Text(path)),
              ],
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              navigationOrderStateProvider.overrideWith(_Order.new),
              hideItemsStateProvider.overrideWith(
                () => _Hidden(scenario.hidden),
              ),
              animeOnlyTvModeProvider.overrideWith(() => _Tv(scenario.tv)),
              l10nLocaleStateProvider.overrideWith(_Locale.new),
              showNavDoubleTapTooltipStateProvider.overrideWith(_Tooltips.new),
              floatingNavigationBarStateProvider.overrideWith(_Floating.new),
              mergeLibraryNavMobileStateProvider.overrideWith(_Merged.new),
              synchingProvider(syncId: 1).overrideWith(_Sync.new),
              routerCurrentLocationStateProvider.overrideWith(_Location.new),
              // Exercise real shell initialization without mounting unrelated screens
              // or starting database migrations, scans and network calls.
              migrationProvider.overrideWith((_) => Completer<void>().future),
            ],
            child: MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await tester.pump();
        expect(
          router.routeInformationProvider.value.uri.path,
          scenario.expected,
        );
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(seconds: 6));
        expect(tester.takeException(), isNull);
      },
    );
  }
}
