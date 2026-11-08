import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/base_library_tab_screen.dart';

void main() {
  testWidgets(
    'activity tabs preserve media identity and query when visibility changes',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          hideItemsStateProvider.overrideWith(_HiddenItems.new),
          animeOnlyTvModeProvider.overrideWith(_AnimeOnly.new),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: _ActivityScreen(),
          ),
        ),
      );
      final state = tester.state<_ActivityState>(find.byType(_ActivityScreen));
      state.tabController.index = 1;
      await tester.pumpAndSettle();
      state.textEditingController.text = 'Keep this query';
      container.read(hideItemsStateProvider.notifier).set(['/MangaLibrary']);
      await tester.pumpAndSettle();
      expect(state.getCurrentItemType(), ItemType.anime);
      expect(state.textEditingController.text, 'Keep this query');
      container.read(hideItemsStateProvider.notifier).set(['/AnimeLibrary']);
      await tester.pumpAndSettle();
      expect(state.getCurrentItemType(), ItemType.manga);
      expect(state.textEditingController.text, isEmpty);
      container.read(hideItemsStateProvider.notifier).set([
        '/MangaLibrary',
        '/AnimeLibrary',
        '/NovelLibrary',
      ]);
      await tester.pumpAndSettle();
      expect(state.tabController.length, 0);
      container.read(hideItemsStateProvider.notifier).set([]);
      await tester.pumpAndSettle();
      state.tabController.index = 2;
      await tester.pumpAndSettle();
      expect(state.getCurrentItemType(), ItemType.novel);
      expect(tester.takeException(), isNull);
    },
  );
}

class _ActivityScreen extends ConsumerStatefulWidget {
  const _ActivityScreen();
  @override
  ConsumerState<_ActivityScreen> createState() => _ActivityState();
}

class _ActivityState extends BaseLibraryTabScreenState<_ActivityScreen> {
  @override
  String get title => 'Activity';
  @override
  Widget buildTab(ItemType type) => Center(child: Text(type.name));
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
