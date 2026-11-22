import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/webview/browser_page_controller.dart';
import 'package:mangayomi/modules/webview/browser_protection_panel.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

class _Protection extends Fake implements BrowserProtection {
  @override
  final ValueNotifier<int> changes = ValueNotifier(0);
  @override
  String get name => 'uBlock Origin';
  final calls = <(String, bool?)>[];
  late Completer<SiteProtectionState> reply;

  @override
  Future<SiteProtectionState> site(String url, {bool? enabled}) {
    calls.add((url, enabled));
    reply = Completer();
    return reply.future;
  }
}

void main() {
  const url = 'https://reader.example/chapter?private=123';
  testWidgets(
    'the badge coalesces engine notifications and discards a previous site reply',
    (tester) async {
      final protection = _Protection(), address = ValueNotifier(url);
      addTearDown(protection.changes.dispose);
      addTearDown(address.dispose);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ValueListenableBuilder(
            valueListenable: address,
            builder: (_, value, _) => Scaffold(
              body: BrowserProtectionButton(
                protection: protection,
                ready: true,
                url: value,
                onAction: (_) {},
              ),
            ),
          ),
        ),
      );
      address.value = 'https://other.example/';
      await tester.pump();
      protection.reply.complete((enabled: true, blocked: 157, total: 650));
      await tester.pump();
      expect(find.text('99+'), findsNothing);
      await tester.pump(const Duration(milliseconds: 300));
      expect(protection.calls.last, (address.value, null));
      protection.reply.complete((enabled: true, blocked: 2, total: 650));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
      protection.changes.value++;
      protection.changes.value++;
      await tester.pump(const Duration(milliseconds: 300));
      expect(protection.calls, [
        (url, null),
        (address.value, null),
        (address.value, null),
      ]);
      protection.reply.complete((enabled: true, blocked: 123, total: 771));
      await tester.pumpAndSettle();
      expect(find.text('99+'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );
  for (final brightness in Brightness.values) {
    testWidgets(
      '$brightness: retry reads back an uncertain change; reload is explicit',
      (tester) async {
        tester.view.physicalSize = const Size(320, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final protection = _Protection();
        final ready = ValueNotifier(false);
        addTearDown(ready.dispose);
        addTearDown(protection.changes.dispose);
        SiteProtectionAction? action;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              brightness: brightness,
              colorSchemeSeed: Colors.teal,
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('zh'),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.8)),
              child: child!,
            ),
            home: Scaffold(
              body: ValueListenableBuilder(
                valueListenable: ready,
                builder: (_, value, _) => BrowserProtectionButton(
                  protection: protection,
                  ready: value,
                  url: url,
                  onAction: (result) => action = result,
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byTooltip('广告过滤'));
        await tester.pumpAndSettle();
        expect(protection.calls, isEmpty);
        expect(find.text('网页就绪后显示过滤状态'), findsOneWidget);
        expect(find.textContaining('操作未完成'), findsNothing);
        ready.value = true;
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.byType(NodeLaneSwitch), findsNothing);
        protection.reply.completeError(StateError('No status yet'));
        await tester.pumpAndSettle();
        expect(find.text('暂时无法确认本站的过滤状态'), findsOneWidget);
        expect(find.textContaining('操作未完成'), findsNothing);
        await tester.tap(find.byTooltip('重试'));
        await tester.pump();
        protection.reply.complete((enabled: true, blocked: 2, total: 71));
        await tester.pumpAndSettle();
        expect(find.text('reader.example'), findsOneWidget);
        expect(find.textContaining('private'), findsNothing);
        expect(find.text('71'), findsOneWidget);
        await tester.tap(find.text('过滤本站广告'));
        await tester.pump();
        await tester.pump();
        final pending = tester.widget<NodeLaneSwitch>(
          find.byType(NodeLaneSwitch),
        );
        expect(pending.value, isTrue);
        expect(pending.onChanged, isNull);
        protection.reply.completeError(StateError('Lost response'));
        await tester.pumpAndSettle();
        expect(find.byType(NodeLaneSwitch), findsNothing);
        await tester.tap(find.byTooltip('重试'));
        await tester.pump();
        expect(protection.calls, [
          (url, null),
          (url, null),
          (url, false),
          (url, null),
        ]);
        protection.reply.complete((enabled: false, blocked: 2, total: 72));
        await tester.pumpAndSettle();
        expect(
          tester.widget<NodeLaneSwitch>(find.byType(NodeLaneSwitch)).value,
          isFalse,
        );
        await tester.ensureVisible(find.text('刷新并返回网页'));
        await tester.tap(find.text('刷新并返回网页'));
        await tester.pumpAndSettle();
        expect(action, SiteProtectionAction.reload);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
