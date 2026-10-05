import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/modules/nodelane/account_screen.dart';
import 'package:mangayomi/modules/nodelane/nodelane_auth_service.dart';
import 'package:mangayomi/modules/nodelane/nodelane_config.dart';
import 'package:mangayomi/modules/nodelane/nodelane_credential_store.dart';
import 'package:mangayomi/modules/nodelane/nodelane_provider.dart';
import 'package:mangayomi/modules/nodelane/nodelane_models.dart';

class _EmptyStore implements NodeLaneCredentialStore {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}

  @override
  Future<void> delete(String key) async {}
}

class _AccountSnapshot extends NodeLaneAuthService {
  _AccountSnapshot(this.snapshot)
    : super(
        config: NodeLaneConfig(
          serviceOrigin: 'https://example.test',
          clientId: 'native-test',
        ),
        store: _EmptyStore(),
      );

  final NodeLaneAuthState snapshot;
  @override
  NodeLaneAuthState get state => snapshot;
}

Future<void> _show(
  WidgetTester tester,
  NodeLaneAuthService service, {
  TextScaler textScaler = TextScaler.noScaling,
}) async {
  await service.initialize();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [nodeLaneAuthProvider.overrideWithValue(service)],
      child: MaterialApp(
        home: const NodeLaneAccountScreen(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: child!,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'signed-in account stays readable on a narrow phone with large text',
    (tester) async {
      tester.view.physicalSize = const Size(320, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final service = _AccountSnapshot(
        NodeLaneAuthState(
          initialized: true,
          account: NodeLaneAccount(
            user: const NodeLaneUser(
              id: 'test-user',
              name: 'A longer reader name',
              role: 'user',
            ),
            entitlements: NodeLaneEntitlements.fromJson({
              'plan': 'free',
              'modes': {
                'classic': {
                  'allowed': true,
                  'quota': {'available': 12, 'used': 2, 'reserved': 0},
                },
              },
            }),
            serviceOrigin: 'https://example.test',
            issuer: 'https://identity.test/oidc',
            subject: 'test-subject',
            sessionId: 'test-session',
          ),
        ),
      );
      addTearDown(service.dispose);
      await _show(tester, service, textScaler: const TextScaler.linear(2));
      await tester.scrollUntilVisible(find.text('12'), 200);
      expect(tester.takeException(), isNull);
      expect(find.text('12'), findsOneWidget);
    },
  );

  testWidgets(
    'missing native client disables sign-in without sending requests',
    (tester) async {
      var requests = 0;
      final service = NodeLaneAuthService(
        config: NodeLaneConfig(
          serviceOrigin: 'https://example.test',
          clientId: '',
        ),
        store: _EmptyStore(),
        client: MockClient((_) async {
          requests++;
          return http.Response('{}', 200);
        }),
      );
      addTearDown(service.dispose);
      await _show(tester, service);
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
      expect(
        find.textContaining('Mobile sign-in has not been configured'),
        findsOneWidget,
      );
      expect(requests, 0);
    },
  );

  testWidgets(
    'account errors are handled and raw identity response stays hidden',
    (tester) async {
      final service = NodeLaneAuthService(
        config: NodeLaneConfig(
          serviceOrigin: 'https://example.test',
          clientId: 'native-test',
        ),
        store: _EmptyStore(),
        client: MockClient(
          (_) async => http.Response('private-provider-response', 503),
        ),
      );
      addTearDown(service.dispose);
      await _show(tester, service);
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.textContaining('temporarily unavailable'), findsOneWidget);
      expect(find.textContaining('private-provider-response'), findsNothing);
      expect(service.state.account, isNull);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
    },
  );
}
