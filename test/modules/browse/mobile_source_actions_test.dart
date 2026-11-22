import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/home/providers/saved_searches_provider.dart';
import 'package:mangayomi/modules/manga/home/widget/mobile_source_actions.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';

class _Saved extends SavedSearchesNotifier {
  @override
  Map<int, List<SavedSearch>> build() => {
    1: [SavedSearch(sourceId: 1, name: '海岸', query: 'sea')],
    2: [SavedSearch(sourceId: 2, name: '海岸', query: 'beach')],
  };
  @override
  void remove(int sourceId, String name) => state = {
    ...state,
    sourceId: state[sourceId]!.where((s) => s.name != name).toList(),
  };
}

void main() {
  Future<void> mount(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [savedSearchesProvider.overrideWith(_Saved.new)],
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'source tools run in place and only look up plugin filters on open',
    (tester) async {
      SourceCatalogAction? result;
      var reads = 0;
      await mount(
        tester,
        MobileSourceMenu(
          canSave: false,
          local: false,
          hasFilters: () => ++reads > 0,
          filtering: () => true,
          onSelected: (menu, choice) async {
            expect(NodeLaneBubbleFlow.contains(menu), isTrue);
            result = choice;
          },
        ),
      );
      expect(reads, 0);
      await tester.tap(find.byTooltip('来源操作'));
      await tester.pumpAndSettle();
      expect(reads, 1);
      expect(find.text('保存当前搜索'), findsNothing);
      expect(find.text('在浏览器打开'), findsNothing);
      expect(find.text('网站说明'), findsOneWidget);
      await tester.tap(find.text('筛选 · 已应用'));
      await tester.pumpAndSettle();
      expect(result, SourceCatalogAction.filter);
    },
  );

  testWidgets(
    'saved searches open directly, expose removal only in manage mode and stay source-scoped',
    (tester) async {
      String? query;
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              query = await NodeLaneBubbleFlow.open<String>(
                context,
                title: '来源 A',
                child: const MobileSavedSearches(sourceId: 1, title: '来源 A'),
              );
            },
            child: const Text('打开'),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('移除'), findsNothing);
      expect(find.text('关键词：sea'), findsOneWidget);
      expect(find.text('关键词：beach'), findsNothing);
      await tester.tap(find.text('海岸'));
      await tester.pumpAndSettle();
      expect(query, 'sea');
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('管理'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('移除'));
      await tester.pumpAndSettle();
      expect(find.text('还没有保存的搜索'), findsOneWidget);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(MobileSavedSearches)),
      );
      expect(container.read(savedSearchesProvider)[2]!.single.query, 'beach');
      expect(tester.takeException(), isNull);
    },
  );
}
