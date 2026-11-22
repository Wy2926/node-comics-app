import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/widgets/source_preference_widget.dart';
import 'package:mangayomi/modules/browse/global_search/source_search_scope.dart';
import 'package:mangayomi/modules/browse/widgets/source_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_setting_bubble.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

void main() {
  Future<void> mount(
    WidgetTester tester,
    Widget child, {
    double scale = 1,
    double? inset,
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
            viewInsets: inset == null ? null : EdgeInsets.only(bottom: inset),
          ),
          child: child!,
        ),
        home: Scaffold(body: child),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'long single choices search by label and return the plugin value',
    (tester) async {
      int? choice;
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => choice = await showSourceChoice<int>(
              context,
              title: '版本',
              current: 500,
              options: [
                for (var i = 0; i < 12; i++)
                  SettingOption(500 + i, 'Version $i'),
              ],
            ),
            child: const Text('版本'),
          ),
        ),
      );
      await tester.tap(find.text('版本'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '11');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Version 11'));
      await tester.pumpAndSettle();
      expect(choice, 511);
    },
  );

  testWidgets(
    'text bubble keeps its draft above keyboard and cancel never returns a value',
    (tester) async {
      final saved = <String>[];
      await mount(
        tester,
        NodeLaneBubbleFlow(
          home: SourcePreferenceWidget(
            source: Source(id: 8, name: '测试来源'),
            sourcePreference: [
              SourcePreference(
                editTextPreference: EditTextPreference(
                  title: '编辑',
                  dialogTitle: '来源地址',
                  value: 'https://example.org',
                ),
              ),
            ],
            onSave: (pref, _) async =>
                saved.add(pref.editTextPreference!.value!),
          ),
        ),
      );
      await tester.tap(find.text('编辑'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'draft');
      tester.view.viewInsets = const FakeViewPadding(bottom: 330);
      await tester.pumpAndSettle();
      expect(find.text('确认').hitTestable(), findsOneWidget);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(saved, isEmpty);
      tester.view.viewInsets = FakeViewPadding.zero;
      await tester.tap(find.text('编辑'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'https://example.org',
      );
      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();
      expect(saved, ['']);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'filtered source choices preserve hidden selections across a failed write and retry',
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
            return saved.length == 1 ? pending.future : Future.value();
          },
        ),
      );
      await tester.tap(find.text('内容语言'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '日本');
      await tester.pumpAndSettle();
      await tester.tap(find.text('日本語'));
      await tester.pump();
      await tester.tap(find.text('日本語'));
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.text('日本語').hitTestable(), findsOneWidget);
      expect(saved.length, 1);
      expect(saved.single.multiSelectListPreference!.values, ['en', 'ja']);
      expect(pref.multiSelectListPreference!.values, ['en']);
      pending.completeError(StateError('failed'));
      await tester.pumpAndSettle();
      expect(find.textContaining('保存未完成').hitTestable(), findsOneWidget);
      await tester.tap(find.text('日本語'));
      await tester.pumpAndSettle();
      expect(saved, hasLength(2));
      expect(saved.last.multiSelectListPreference!.values, ['en', 'ja']);
      expect(find.textContaining('保存未完成').hitTestable(), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('English、日本語'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'scope updates while open, including searches with hidden selections',
    (tester) async {
      final sources = [
        Source(id: 1, name: 'Alpha', isAdded: true, isPinned: true),
        Source(id: 2, name: 'Beta', isAdded: true),
      ];
      SourceSearchScope? result;
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              await NodeLaneBubbleFlow.open<void>(
                context,
                title: '范围',
                child: SourceSearchScopePanel(
                  sources: sources,
                  current: result ?? const SourceSearchScope(),
                  onChanged: (next) => result = next,
                ),
              );
            },
            child: const Text('范围'),
          ),
        ),
      );
      await tester.tap(find.text('范围'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Beta');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beta').last);
      await tester.pumpAndSettle();
      expect(result!.ids, {1});
      expect(result!.mode, SourceSearchScopeMode.custom);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.tap(find.text('范围'));
      await tester.pumpAndSettle();
      expect(find.text('已选 1 个网站'), findsOneWidget);
      expect(
        sources.every((s) => s.isAdded == true && s.isActive == true),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'scope presets preserve hidden choices at large text with a keyboard',
    (tester) async {
      var scope = const SourceSearchScope();
      await mount(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => NodeLaneBubbleFlow.open<void>(
              context,
              title: '范围',
              child: SourceSearchScopePanel(
                sources: [
                  Source(id: 1, name: 'Alpha', lang: 'en', isPinned: true),
                  Source(id: 2, name: 'Beta', lang: 'zh'),
                ],
                current: scope,
                onChanged: (next) => scope = next,
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
      expect(scope.mode, SourceSearchScopeMode.pinned);
      await tap('Beta');
      expect(scope.ids, {1, 2});
      await top();
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Beta');
      await tester.pumpAndSettle();
      await tap('取消当前结果');
      expect(scope.ids, {1});
      await top();
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      await tap('全选');
      await tap('清空');
      expect(scope.ids, isEmpty);
      await top();
      await tap('全部');
      expect(scope.mode, SourceSearchScopeMode.all);
      await tap('自选');
      expect(scope.mode, SourceSearchScopeMode.custom);
      expect(scope.ids, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
}
