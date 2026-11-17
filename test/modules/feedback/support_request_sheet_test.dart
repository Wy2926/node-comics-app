import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/feedback/support_request_sheet.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/services/support_requests.dart';
import 'package:package_info_plus/package_info_plus.dart';

const _receipt = 'b741e1fb-9e21-4df4-bc46-6f122868922a';
http.Response _success() => http.Response(
  jsonEncode({'id': _receipt, 'created_at': '2026-11-17T00:00:00Z'}),
  201,
);

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'NodeLane',
      packageName: 'com.nodelane.comics',
      version: '0.1.2',
      buildNumber: '2003',
      buildSignature: '',
    );
  });

  Future<void> mount(
    WidgetTester tester,
    SupportRequests Function() requests, {
    SupportRequestKind kind = SupportRequestKind.app,
    double scale = 1,
    Locale locale = const Locale('zh'),
  }) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showNodeLaneCatalogSheet<void>(
                context,
                SupportRequestSheet(
                  kind: kind,
                  website: 'https://comics.example/private?token=secret#page',
                  requests: requests(),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String label) async {
    final target = find.widgetWithText(FilledButton, label);
    await tester.scrollUntilVisible(
      target,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'requires content and prevents repeated sends while showing a receipt',
    (tester) async {
      var calls = 0;
      final response = Completer<http.Response>();
      await mount(
        tester,
        () => SupportRequests(
          client: MockClient((request) {
            calls++;
            expect(
              jsonDecode(request.body)['comment'],
              '${supportAppCommentPrefix}0.1.2 (2003)\n按钮不响应',
            );
            return response.future;
          }),
        ),
      );
      await tap(tester, '提交反馈');
      expect(calls, 0);
      await tester.enterText(find.byType(TextField).first, '字' * 1000);
      await tap(tester, '提交反馈');
      expect(calls, 0);
      await tester.enterText(find.byType(TextField).first, '按钮不响应');
      await tap(tester, '提交反馈');
      expect(calls, 1);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      response.complete(_success());
      await tester.pumpAndSettle();
      expect(find.text(_receipt), findsOneWidget);
      expect(find.text('反馈已收到，感谢你的反馈！'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'lost reply keeps content and key across closing, then confirms without duplication',
    (tester) async {
      final sent = <http.Request>[];
      await mount(
        tester,
        () => SupportRequests(
          client: MockClient((request) async {
            sent.add(request);
            if (sent.length == 1) throw http.ClientException('offline');
            return _success();
          }),
        ),
      );
      await tester.enterText(find.byType(TextField).first, '保留这段反馈');
      await tap(tester, '提交反馈');
      expect(find.textContaining('提交结果尚未确认'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField).first).enabled,
        isFalse,
      );
      await tester.tap(find.byTooltip('关闭'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('保留这段反馈'), findsOneWidget);
      await tap(tester, '重试确认');
      expect(sent, hasLength(2));
      expect(sent[1].body, sent[0].body);
      expect(
        sent[1].headers['Idempotency-Key'],
        sent[0].headers['Idempotency-Key'],
      );
      expect(find.text(_receipt), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('rate limiting preserves editable input for an explicit retry', (
    tester,
  ) async {
    var calls = 0;
    await mount(
      tester,
      () => SupportRequests(
        client: MockClient((_) async {
          calls++;
          return calls == 1 ? http.Response('{}', 429) : _success();
        }),
      ),
    );
    await tester.enterText(find.byType(TextField).first, '保留内容');
    await tap(tester, '提交反馈');
    expect(find.text('提交较频繁，请稍后重试。'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).enabled,
      isTrue,
    );
    expect(find.text('保留内容'), findsOneWidget);
    await tap(tester, '提交反馈');
    expect(calls, 2);
    expect(find.text(_receipt), findsOneWidget);
  });

  testWidgets(
    'source request prefills only the homepage and supports narrow large-text RTL',
    (tester) async {
      http.Request? sent;
      await mount(
        tester,
        () => SupportRequests(
          client: MockClient((request) async {
            sent = request;
            return _success();
          }),
        ),
        kind: SupportRequestKind.website,
        scale: 2,
        locale: const Locale('ar'),
      );
      final labels = lookupAppLocalizations(const Locale('ar'));
      expect(find.textContaining('secret'), findsNothing);
      expect(find.text('comics.example'), findsOneWidget);
      await tap(tester, labels.feedback_submit);
      expect(jsonDecode(sent!.body), {
        'kind': 'website',
        'site_name': 'comics.example',
        'url': 'https://comics.example/',
        'comment': '',
        'contact': '',
      });
      await tester.ensureVisible(find.text(_receipt));
      expect(find.text(_receipt), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
