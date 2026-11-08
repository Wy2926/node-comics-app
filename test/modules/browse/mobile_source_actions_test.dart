import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/home/providers/saved_searches_provider.dart';
import 'package:mangayomi/modules/manga/home/widget/mobile_source_actions.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';

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

  testWidgets('display choices and website actions return distinct values', (
    tester,
  ) async {
    Object? result;
    await mount(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            result = await showNodeLaneCatalogSheet<Object>(
              context,
              const MobileSourceActions(
                title: '来源',
                display: DisplayType.comfortableGrid,
                canSave: false,
                local: false,
                hasFilters: true,
                filtering: true,
                notes: '网站自己的说明内容',
              ),
            );
          },
          child: const Text('打开'),
        ),
      ),
    );
    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    expect(find.text('保存当前搜索'), findsNothing);
    expect(find.text('在浏览器打开'), findsNothing);
    expect(find.text('网站自己的说明内容'), findsNothing);
    await tester.tap(find.text('网站说明'));
    await tester.pumpAndSettle();
    expect(find.text('网站自己的说明内容'), findsOneWidget);
    expect(find.text('显示方式'), findsOneWidget);
    await tester.tap(find.text('仅封面'));
    await tester.pumpAndSettle();
    expect(result, DisplayType.compactGrid);
    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    expect(find.text('已应用'), findsOneWidget);
    await tester.tap(find.text('筛选'));
    await tester.pumpAndSettle();
    expect(result, SourceCatalogAction.filter);
  });

  testWidgets(
    'saved searches open directly, expose removal only in manage mode and stay source-scoped',
    (tester) async {
      String? query;
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              query = await showNodeLaneCatalogSheet<String>(
                context,
                const MobileSavedSearches(sourceId: 1, title: '来源 A'),
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
