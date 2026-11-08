import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/browse/browse_screen.dart';
import 'package:mangayomi/modules/browse/extension/providers/extensions_provider.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/browse/sources/sources_screen.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';

void main() {
  testWidgets(
    'mounted browse consumes requests and preserves visible tab identity',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          hideItemsStateProvider.overrideWith(_HiddenItems.new),
          animeOnlyTvModeProvider.overrideWith(_AnimeOnly.new),
          showNSFWStateProvider.overrideWith(_ShowNSFW.new),
          developerModeStateProvider.overrideWith(_DeveloperMode.new),
          isExtensionServerInstalledStreamProvider.overrideWith(
            (ref) => Stream.value(true),
          ),
          for (final type in ItemType.values) ...[
            getSourcesStreamProvider(type)
                .overrideWith((ref) => Stream.value([])),
            getExtensionsStreamProvider(type)
                .overrideWith((ref) => Stream.value([])),
            extensionUpdateCountProvider(type)
                .overrideWith((ref) => Stream.value(0)),
            extensionsRepoStateProvider(type).overrideWith(_Repositories.new),
            fetchItemSourcesListProvider(
              id: null,
              reFresh: false,
              itemType: type,
            ).overrideWith((ref) async {}),
          ],
        ],
      );
      addTearDown(container.dispose);
      final requests = container.read(browseInitialTabProvider.notifier);
      requests.request(
        const BrowseTab(ItemType.anime, BrowseTabKind.extensions),
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: BrowseScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      TabController controller() =>
          tester.widget<TabBarView>(find.byType(TabBarView)).controller!;
      expect(controller().index, 4);
      expect(container.read(browseInitialTabProvider), isNull);

      // Hiding an earlier medium keeps Anime extensions selected rather than
      // keeping its former numeric index or disposing the controller mid-paint.
      container.read(hideItemsStateProvider.notifier).set(['/MangaLibrary']);
      await tester.pumpAndSettle();
      expect(controller().length, 4);
      expect(controller().index, 2);

      // Same tab count, different media: retain the section, choose a visible
      // medium, then accept a new request without remounting BrowseScreen.
      container.read(hideItemsStateProvider.notifier).set(['/AnimeLibrary']);
      await tester.pumpAndSettle();
      expect(controller().index, 2);
      requests.request(const BrowseTab(ItemType.novel, BrowseTabKind.sources));
      await tester.pumpAndSettle();
      expect(controller().index, 1);
      expect(container.read(browseInitialTabProvider), isNull);
      expect(tester.takeException(), isNull);
    },
  );
}

class _HiddenItems extends HideItemsState {
  @override
  List<String> build() => [];
  @override
  void set(List<String> values) => state = values;
}

class _AnimeOnly extends AnimeOnlyTvMode {
  @override
  bool build() => false;
}

class _ShowNSFW extends ShowNSFWState {
  @override
  bool build() => false;
}

class _DeveloperMode extends DeveloperModeState {
  @override
  bool build() => false;
}

class _Repositories extends ExtensionsRepoState {
  @override
  List<Repo> build(ItemType itemType) => [];
}
