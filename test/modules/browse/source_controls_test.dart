import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/widgets/source_preference_widget.dart';
import 'package:mangayomi/modules/browse/global_search/source_search_scope.dart';
import 'package:mangayomi/modules/browse/widgets/source_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  Future<void> mount(WidgetTester tester, Widget child) async {
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
      await tester.tap(find.text('取消'));
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
      await tester.tap(find.text('取消'));
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
      final initial = SourceSearchScope({1, 2}, false);
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await Navigator.of(context).push<SourceSearchScope>(
                MaterialPageRoute(
                  builder: (_) => SourceSearchScopePage(
                    sources: sources,
                    current: initial,
                    media: '漫画',
                  ),
                ),
              );
            },
            child: const Text('范围'),
          ),
        ),
      );
      await tester.tap(find.text('范围'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beta').last);
      await tester.tap(find.byTooltip('返回'));
      await tester.pumpAndSettle();
      expect(result, isNull);
      expect(initial.ids, {1, 2});
      await tester.tap(find.text('范围'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Beta');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beta').last);
      await tester.tap(find.byType(Switch));
      await tester.tap(find.text('保存'));
      await tester.pumpAndSettle();
      expect(result!.ids, {1});
      expect(result!.pinnedOnly, isTrue);
      expect(
        sources.every((s) => s.isAdded == true && s.isActive == true),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
