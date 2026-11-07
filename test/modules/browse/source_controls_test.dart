import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/widgets/source_preference_widget.dart';
import 'package:mangayomi/modules/browse/global_search/source_search_scope.dart';
import 'package:mangayomi/modules/browse/widgets/source_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  Future<void> mount(
    WidgetTester tester,
    Widget child, {
    double scale = 1,
    double inset = 0,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          platform: TargetPlatform.iOS,
          colorSchemeSeed: NodeLaneTokens.defaultMobileAccent,
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
            viewInsets: EdgeInsets.only(bottom: inset),
          ),
          child: child!,
        ),
        home: Scaffold(body: child),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'multi selection cancels, preserves hidden choices and commits once',
    (tester) async {
      Set<String>? result;
      var completions = 0;
      final original = {'en'};
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showSourceMultiChoice(
                context,
                title: '语言',
                current: original,
                options: const [
                  SourceOption('en', 'English'),
                  SourceOption('ja', '日本語'),
                ],
              );
              completions++;
            },
            child: const Text('打开'),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('日本語'));
      await tester.tap(find.byTooltip('关闭'));
      await tester.pumpAndSettle();
      expect(result, isNull);
      expect(original, {'en'});
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '日本');
      await tester.pumpAndSettle();
      await tester.tap(find.text('日本語'));
      expect(find.text('English'), findsNothing);
      await tester.tap(find.text('保存'));
      await tester.pumpAndSettle();
      expect(result, {'en', 'ja'});
      expect(original, {'en'});
      expect(completions, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'language reset means all languages and empty selection is explicit',
    (tester) async {
      Set<String>? result;
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showSourceMultiChoice(
                context,
                title: '语言筛选',
                current: <String>{},
                allLabel: '全部语言',
                reset: true,
                options: const [
                  SourceOption('en', 'English'),
                  SourceOption('ja', '日本語'),
                ],
              );
            },
            child: const Text('打开'),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('保存'));
      await tester.pumpAndSettle();
      expect(result, isEmpty);
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('重置'));
      await tester.tap(find.text('保存'));
      await tester.pumpAndSettle();
      expect(result, {'en', 'ja'});
    },
  );

  testWidgets(
    'text sheet keeps its draft above keyboard and cancel never returns a value',
    (tester) async {
      String? result;
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showSourceTextEditor(
                context,
                title: '来源地址',
                subtitle: '测试来源',
                initialValue: 'https://example.org',
              );
            },
            child: const Text('编辑'),
          ),
        ),
      );
      await tester.tap(find.text('编辑'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'draft');
      tester.view.viewInsets = const FakeViewPadding(bottom: 330);
      await tester.pumpAndSettle();
      expect(find.text('保存').hitTestable(), findsOneWidget);
      await tester.tap(find.byTooltip('关闭'));
      await tester.pumpAndSettle();
      expect(result, isNull);
      tester.view.viewInsets = FakeViewPadding.zero;
      await tester.tap(find.text('编辑'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'https://example.org',
      );
      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.text('保存'));
      await tester.pumpAndSettle();
      expect(result, '');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'preference write failure keeps original values and blocks duplicate writes',
    (tester) async {
      final pref = SourcePreference(
        key: 'langs',
        multiSelectListPreference: MultiSelectListPreference(
          title: '内容语言',
          entries: ['English', '日本語'],
          entryValues: ['en', 'ja'],
          values: ['en'],
        ),
      );
      final pending = Completer<void>();
      final saved = <SourcePreference>[];
      await mount(
        tester,
        SourcePreferenceWidget(
          sourcePreference: [pref],
          source: Source(id: 8, name: '来源 A'),
          onSave: (value, source) {
            saved.add(value);
            return pending.future;
          },
        ),
      );
      await tester.tap(find.text('内容语言'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('日本語'));
      await tester.tap(find.text('保存'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.tap(find.text('内容语言'));
      await tester.pump();
      expect(saved.length, 1);
      expect(saved.single.multiSelectListPreference!.values, ['en', 'ja']);
      expect(pref.multiSelectListPreference!.values, ['en']);
      pending.completeError(StateError('failed'));
      await tester.pumpAndSettle();
      expect(find.textContaining('保存未完成'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'search scope saves a local draft including hidden selections and cancels cleanly',
    (tester) async {
      final sources = [
        Source(id: 1, name: 'Alpha', isAdded: true, isPinned: true),
        Source(id: 2, name: 'Beta', isAdded: true),
      ];
      SourceSearchScope? result;
      final initial = const SourceSearchScope();
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showNodeLaneCatalogSheet<SourceSearchScope>(
                context,
                SourceSearchScopeSheet(sources: sources, current: initial),
              );
            },
            child: const Text('范围'),
          ),
        ),
      );
      await tester.tap(find.text('范围'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beta').last);
      await tester.tap(find.byTooltip('关闭'));
      await tester.pumpAndSettle();
      expect(result, isNull);
      expect(initial.mode, SourceSearchScopeMode.all);
      await tester.tap(find.text('范围'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Beta');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beta').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('搜索这 1 个网站'));
      await tester.pumpAndSettle();
      expect(result!.ids, {1});
      expect(result!.mode, SourceSearchScopeMode.custom);
      expect(
        sources.every((s) => s.isAdded == true && s.isActive == true),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'scope presets preserve hidden choices and keep apply reachable with large text and keyboard',
    (tester) async {
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showNodeLaneCatalogSheet(
              context,
              SourceSearchScopeSheet(
                sources: [
                  Source(id: 1, name: 'Alpha', lang: 'en', isPinned: true),
                  Source(id: 2, name: 'Beta', lang: 'zh'),
                ],
                current: const SourceSearchScope(),
              ),
            ),
            child: const Text('范围'),
          ),
        ),
        scale: 2.5,
        inset: 260,
      );
      await tester.tap(find.text('范围'));
      await tester.pumpAndSettle();
      final scrollable = find
          .descendant(
            of: find.byType(CustomScrollView),
            matching: find.byType(Scrollable),
          )
          .first;
      Future<void> top() async {
        tester.state<ScrollableState>(scrollable).position.jumpTo(0);
        await tester.pumpAndSettle();
      }

      Future<void> tap(String label) async {
        if (find.text(label).evaluate().isEmpty) {
          await tester.scrollUntilVisible(
            find.text(label),
            120,
            scrollable: scrollable,
          );
        } else {
          await tester.ensureVisible(find.text(label));
        }
        await tester.pumpAndSettle();
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
      }

      await tap('常用');
      expect(find.text('搜索这 1 个网站').hitTestable(), findsOneWidget);
      await tap('Beta');
      expect(find.text('搜索这 2 个网站').hitTestable(), findsOneWidget);
      await top();
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Beta');
      await tester.pumpAndSettle();
      await tap('取消当前结果');
      expect(find.text('搜索这 1 个网站'), findsOneWidget);
      await top();
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      await tap('全选');
      await tap('清空');
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await top();
      await tap('全部');
      expect(find.text('搜索这 2 个网站'), findsOneWidget);
      await tap('自选');
      expect(find.text('搜索这 0 个网站'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
