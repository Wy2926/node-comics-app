import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/home/widget/mobile_source_filters.dart';
import 'package:mangayomi/modules/manga/home/widget/source_filter_labels.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';

void main() {
  test('known whole labels localize and unknown plugin text stays exact', () {
    final zh = lookupAppLocalizations(const Locale('zh'));
    final en = lookupAppLocalizations(const Locale('en'));
    expect(sourceFilterLabel(zh, ' Sort_by: '), '排序');
    expect(sourceFilterLabel(zh, 'Science-fiction'), '科幻');
    expect(sourceFilterLabel(zh, 'Genres'), '题材');
    expect(sourceFilterLabel(zh, 'Year of Released'), '年份');
    expect(sourceFilterLabel(zh, 'Most Views'), '浏览量');
    expect(sourceFilterLabel(zh, 'Trending'), '热门趋势');
    expect(sourceFilterLabel(zh, 'Adult Content'), '成人内容');
    expect(sourceFilterLabel(en, '状态'), 'Status');
    expect(sourceFilterLabel(en, 'Adventure'), 'Adventure');
    for (final text in [
      '  Site-specific name  ',
      'Status of the moon',
      '作者：山田',
    ]) {
      expect(sourceFilterLabel(zh, text), text);
      expect(sourceFilterLabel(en, text), text);
    }
  });

  testWidgets(
    'changing locale keeps the draft and returns original plugin values',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final locale = ValueNotifier(const Locale('zh'));
      addTearDown(locale.dispose);
      final filters = <dynamic>[
        TextFilter('author-key', 'Author', 'TextFilter', state: '山田 Original'),
        GroupFilter('genre-key', 'Genres', [
          CheckBoxFilter('adventure-key', 'Adventure', 'genre-17', 'CheckBox'),
        ], 'GroupFilter'),
        SelectFilter('status-key', 'Status', 0, [
          SelectFilterOption('All', 'any-wire', 'SelectOption'),
          SelectFilterOption('Ongoing', 'ongoing-wire', 'SelectOption'),
        ], 'SelectFilter'),
      ];
      List<dynamic>? applied;
      await tester.pumpWidget(
        ValueListenableBuilder(
          valueListenable: locale,
          builder: (context, value, _) => MaterialApp(
            locale: value,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  child: const Text('Open'),
                  onPressed: () async {
                    applied = await showNodeLaneCatalogSheet<List<dynamic>>(
                      context,
                      MobileSourceFilterSheet(
                        filters: filters,
                        defaults: () => filters,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('题材'), findsOneWidget);
      expect(find.text('冒险'), findsOneWidget);
      expect(find.text('全部'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), 'Untranslated query');
      await tester.tap(find.byType(NodeLaneSwitch));
      await tester.pumpAndSettle();
      locale.value = const Locale('en');
      await tester.pumpAndSettle();
      expect(find.text('Genres'), findsOneWidget);
      expect(find.text('Adventure'), findsOneWidget);
      expect(
        tester.widget<NodeLaneSwitch>(find.byType(NodeLaneSwitch)).value,
        isTrue,
      );
      expect(find.text('Untranslated query'), findsOneWidget);
      await tester.ensureVisible(find.text('Status'));
      await tester.tap(find.text('Status'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ongoing'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply filters'));
      await tester.pumpAndSettle();
      expect((applied![0] as TextFilter).name, 'Author');
      expect((applied![0] as TextFilter).state, 'Untranslated query');
      final genres = applied![1] as GroupFilter;
      expect(genres.name, 'Genres');
      expect(genres.type, 'genre-key');
      expect((genres.state.single as CheckBoxFilter).name, 'Adventure');
      expect((genres.state.single as CheckBoxFilter).value, 'genre-17');
      expect((genres.state.single as CheckBoxFilter).state, isTrue);
      final status = applied![2] as SelectFilter;
      expect(status.state, 1);
      expect((status.values[1] as SelectFilterOption).value, 'ongoing-wire');
      expect((filters[0] as TextFilter).state, '山田 Original');
      expect(
        ((filters[1] as GroupFilter).state.single as CheckBoxFilter).state,
        isFalse,
      );
      expect((filters[2] as SelectFilter).state, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'labeled filter rows advance the keyboard without applying and reset their draft',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final original = <dynamic>[
        TextFilter('author', 'Author', 'TextFilter', state: 'Original'),
        TextFilter('artist', 'Artist', 'TextFilter'),
        TextFilter('year', 'Year', 'TextFilter', state: '2020'),
      ];
      List<dynamic> defaults() => [
        TextFilter('author', 'Author', 'TextFilter'),
        TextFilter('artist', 'Artist', 'TextFilter'),
        TextFilter('year', 'Year', 'TextFilter'),
      ];
      List<dynamic>? applied;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  applied = await showNodeLaneCatalogSheet<List<dynamic>>(
                    context,
                    MobileSourceFilterSheet(
                      filters: original,
                      defaults: defaults,
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('作者'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).at(0))
            .focusNode
            .hasFocus,
        isTrue,
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'Draft author');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).at(1))
            .focusNode
            .hasFocus,
        isTrue,
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'Draft artist');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).at(2))
            .focusNode
            .hasFocus,
        isTrue,
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(applied, isNull);
      expect(find.byType(MobileSourceFilterSheet), findsOneWidget);
      await tester.tap(find.text('重置'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<EditableText>(find.byType(EditableText))
            .map((field) => field.controller.text),
        ['', '', ''],
      );
      expect((original.first as TextFilter).state, 'Original');
      expect((original.last as TextFilter).state, '2020');
      await tester.tap(find.text('应用筛选'));
      await tester.pumpAndSettle();
      expect(applied!.cast<TextFilter>().map((field) => field.state), [
        '',
        '',
        '',
      ]);
      expect(tester.takeException(), isNull);
    },
  );
}
