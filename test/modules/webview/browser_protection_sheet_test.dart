import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/webview/browser_page_controller.dart';
import 'package:mangayomi/modules/webview/browser_protection_sheet.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';

class _Protection extends Fake implements BrowserProtection {
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
  for (final brightness in Brightness.values) {
    testWidgets(
      '$brightness: retry reads back an uncertain change; reload is explicit',
      (tester) async {
        tester.view.physicalSize = const Size(320, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final protection = _Protection();
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
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () async => action =
                      await showNodeLaneCatalogSheet<SiteProtectionAction>(
                        context,
                        BrowserProtectionSheet(
                          protection: protection,
                          url: url,
                        ),
                      ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('open'));
        await tester.pump();
        expect(find.byType(NodeLaneSwitch), findsNothing);
        protection.reply.complete((enabled: true, blocked: 2, total: 71));
        await tester.pumpAndSettle();
        expect(find.text('reader.example'), findsOneWidget);
        expect(find.textContaining('private'), findsNothing);
        expect(find.text('71'), findsOneWidget);
        await tester.tap(find.text('过滤本站广告'));
        await tester.pump();
        final pending = tester.widget<NodeLaneSwitch>(
          find.byType(NodeLaneSwitch),
        );
        expect(pending.value, isTrue);
        expect(pending.onChanged, isNull);
        protection.reply.completeError(StateError('Lost response'));
        await tester.pumpAndSettle();
        expect(find.byType(NodeLaneSwitch), findsNothing);
        await tester.tap(find.text('重试'));
        await tester.pump();
        expect(protection.calls, [(url, null), (url, false), (url, null)]);
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
