import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/nodelane_requests.dart';
import 'package:mangayomi/services/translation/channels/nodelane/protocol.dart';
import 'package:mangayomi/services/translation/channels/nodelane/session.dart';
import 'package:mangayomi/services/translation/channels/nodelane/account.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const nativeClient = 'pljp89y5gk6k5x2h9gp6q';
  final base = Uri.parse('https://api.example');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const browser = MethodChannel('flutter_web_auth_2');
  late HttpServer server;
  late HttpOverrides? previousOverrides;
  final exchanges = <Map<String, String>>[];
  late Uri authorization;
  Uri Function(Uri)? callbackOverride;
  bool billingFailure = false, wrongUser = false;
  final reads = <(String, String)>[];

  setUp(() async {
    PackageInfo.setMockInitialValues(
      appName: 'NodeLane Comics',
      packageName: 'com.nodelane.comics',
      version: '9.8.7',
      buildNumber: '654',
      buildSignature: '',
    );
    final userAgent = await NodeLaneRequests.userAgent;
    FlutterSecureStorage.setMockInitialValues({});
    exchanges.clear();
    callbackOverride = null;
    billingFailure = false;
    wrongUser = false;
    reads.clear();
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      expect(request.headers.value('user-agent'), userAgent);
      expect(request.headers.value('accept'), 'application/json');
      request.response.headers.contentType = ContentType.json;
      final Object body;
      switch (request.uri.path) {
        case '/v1/capabilities':
          body = {
            'translation_models': [
              {
                'id': 'free',
                'name': 'Free',
                'requires_paid': false,
                'available': request.headers.value('authorization') == null,
                'unavailable_reason':
                    request.headers.value('authorization') == null
                    ? null
                    : 'quota_exhausted',
                'quota_multiplier': 1,
              },
              {
                'id': 'premium',
                'name': 'Premium',
                'requires_paid': true,
                'available':
                    request.headers.value('authorization') ==
                    'Bearer renewed-access',
                'unavailable_reason':
                    request.headers.value('authorization') == null
                    ? 'not_allowed'
                    : null,
                'quota_multiplier': 1.75,
              },
            ],
          };
        case '/v1/auth/config':
          body = {
            'mode': 'oidc',
            'client_id': 'browser-client-must-not-be-used',
            'issuer': 'https://identity.example/oidc',
            'authorization_endpoint': 'https://identity.example/oidc/auth',
            'token_endpoint': 'https://identity.example/oidc/token',
            'audience': 'https://api.example',
          };
        case '/oidc/token':
          expect(request.headers.value('authorization'), isNull);
          expect(
            request.headers.contentType?.mimeType,
            'application/x-www-form-urlencoded',
          );
          final form = Uri.splitQueryString(
            await utf8.decoder.bind(request).join(),
          );
          exchanges.add(form);
          final refresh = form['grant_type'] == 'refresh_token';
          body = {
            'access_token': refresh ? 'renewed-access' : 'initial-access',
            'refresh_token': refresh ? 'renewed-refresh' : 'initial-refresh',
            'token_type': 'Bearer',
            'expires_in': refresh ? 3600 : 1,
          };
        case '/v1/me':
          expect(
            request.headers.value('authorization'),
            anyOf('Bearer initial-access', 'Bearer renewed-access'),
          );
          reads.add((request.method, request.uri.path));
          body = {
            'user': {
              'id': wrongUser ? 'other-user' : 'user-1',
              'name': 'Reader',
            },
            'entitlements': {
              'plan': 'plus',
              'plan_name': 'PLUS',
              'generated_at': '2026-11-03T08:00:00Z',
              'free_quota': {
                'available': 24,
                'used': 6,
                'reserved': 0,
                'granted': 30,
              },
            },
          };
        case '/v1/billing/status':
          reads.add((request.method, request.uri.path));
          expect(
            request.headers.value('authorization'),
            'Bearer renewed-access',
          );
          if (billingFailure) request.response.statusCode = 503;
          body = billingFailure
              ? {'code': 'UNAVAILABLE'}
              : {
                  'subscription': {
                    'auto_renew': true,
                    'next_billed_at': '2026-12-03T08:00:00Z',
                  },
                };
        case '/v1/billing/app-handoff':
          expect(request.method, 'POST');
          expect(
            request.headers.value('authorization'),
            'Bearer renewed-access',
          );
          reads.add((request.method, request.uri.path));
          body = {
            'account_id': wrongUser ? 'other' : 'user-1',
            'code': 'a' * 43,
            'url': 'https://other.invalid/',
          };
        default:
          fail('Unexpected request: ${request.uri.path}');
      }
      request.response.write(jsonEncode(body));
      await request.response.close();
    });
    previousOverrides = HttpOverrides.current;
    HttpOverrides.global = _LoopbackOverrides(server.port);
    messenger.setMockMethodCallHandler(browser, (call) async {
      if (call.method != 'authenticate') return null;
      authorization = Uri.parse(call.arguments['url'] as String);
      expect(call.arguments['callbackUrlScheme'], 'nodelane-comics');
      expect(
        authorization.queryParameters['redirect_uri'],
        'nodelane-comics://nodelane-auth',
      );
      final callback = Uri.parse(NodeLaneSession.redirect).replace(
        queryParameters: {
          'code': 'test-code',
          'state': authorization.queryParameters['state']!,
        },
      );
      return (callbackOverride?.call(callback) ?? callback).toString();
    });
  });

  tearDown(() async {
    messenger.setMockMethodCallHandler(browser, null);
    HttpOverrides.global = previousOverrides;
    await server.close(force: true);
  });

  test('upgrade uses the signed-in account and opens only a same-origin one-time fragment', () async {
    final session = NodeLaneSession(base);
    await expectLater(
      session.billingUpgradeLink(TranslationCancellation()),
      throwsA(isA<TranslationFailure>()),
    );
    await session.login();
    final url = await session.billingUpgradeLink(TranslationCancellation());
    expect(url, Uri.parse('$base/pricing/?app=1#app-billing=${'a' * 43}'));
    expect(reads.last, ('POST', '/v1/billing/app-handoff'));
    wrongUser = true;
    await expectLater(
      session.billingUpgradeLink(TranslationCancellation()),
      throwsA(isA<TranslationFailure>()),
    );
  });

  test('native client survives PKCE exchange, renewal and session restore', () async {
    final session = NodeLaneSession(base);
    await session.login();
    expect(authorization.queryParameters['client_id'], nativeClient);
    expect(authorization.queryParameters['resource'], base.toString());
    expect(exchanges.single['client_id'], nativeClient);
    expect(exchanges.single['redirect_uri'], NodeLaneSession.redirect);
    final challenge = base64UrlEncode(
      sha256.convert(utf8.encode(exchanges.single['code_verifier']!)).bytes,
    ).replaceAll('=', '');
    expect(authorization.queryParameters['code_challenge'], challenge);
    expect(authorization.queryParameters['code_challenge_method'], 'S256');
    expect(session.userId, 'user-1');

    // Concurrent callers share one refresh and keep the native client/resource.
    expect(await Future.wait([session.accessToken(), session.accessToken()]), [
      'renewed-access',
      'renewed-access',
    ]);
    expect(exchanges.length, 2);
    expect(exchanges.last, {
      'grant_type': 'refresh_token',
      'client_id': nativeClient,
      'refresh_token': 'initial-refresh',
      'resource': base.toString(),
    });
    final restored = NodeLaneSession(base);
    await restored.restore();
    expect(restored.userId, 'user-1');
    expect(await restored.accessToken(), 'renewed-access');
    expect(exchanges.length, 2);
    await restored.logout();
    final signedOut = NodeLaneSession(base);
    await signedOut.restore();
    expect(signedOut.userId, isNull);
  });

  test(
    'model availability follows the current account, including logout',
    () async {
      final session = NodeLaneSession(base);
      Future<void> checkCatalog({required bool signedIn}) async {
        final models = await session.readModels(TranslationCancellation());
        expect(models.map((m) => m.model.id), ['free', 'premium']);
        expect(models.first.requiresPaid, isFalse);
        expect(
          models.first.access,
          signedIn
              ? TranslationModelAccess.quotaExhausted
              : TranslationModelAccess.available,
        );
        expect(models.first.access.selectable, isTrue);
        expect(models.last.requiresPaid, isTrue);
        expect(models.last.quotaMultiplier, 1.75);
        expect(
          models.last.access,
          signedIn
              ? TranslationModelAccess.available
              : TranslationModelAccess.notAllowed,
        );
      }

      await checkCatalog(signedIn: false);
      await session.login();
      await checkCatalog(signedIn: true);
      await session.logout();
      await checkCatalog(signedIn: false);
    },
  );

  test(
    'older catalogs keep explicit availability without assuming a free tier',
    () {
      expect(nodeLaneModels({}), isEmpty);
      final models = nodeLaneModels({
        'translation_models': [
          {'id': 'old', 'available': true},
          {'id': 'missing', 'requires_paid': false},
          {'id': 'unknown', 'available': false, 'unavailable_reason': 'other'},
        ],
      });
      expect(models.first.requiresPaid, isNull);
      expect(models.map((m) => m.access.selectable), [true, false, false]);
    },
  );

  test('account overview uses authenticated reads and keeps entitlement data if billing fails', () async {
    final session = NodeLaneSession(base);
    await session.login();
    reads.clear();
    final account = await session.readAccount(TranslationCancellation());
    expect(reads, [('GET', '/v1/me'), ('GET', '/v1/billing/status')]);
    expect(account.free!.available, 24);
    expect(account.renewal, NodeLaneRenewal.automatic);
    billingFailure = true;
    final partial = await session.readAccount(TranslationCancellation());
    expect(partial.free!.available, 24);
    expect(partial.billingUnavailable, isTrue);
    expect(partial.renewal, NodeLaneRenewal.unknown);
    expect(session.userId, 'user-1');
  });

  test('account response cannot disclose another identity or continue into its billing', () async {
    final session = NodeLaneSession(base);
    await session.login();
    wrongUser = true;
    reads.clear();
    await expectLater(
      session.readAccount(TranslationCancellation()),
      throwsA(
        isA<TranslationFailure>().having(
          (e) => e.code,
          'code',
          'AUTH_REQUIRED',
        ),
      ),
    );
    expect(reads, [('GET', '/v1/me')]);
    expect(session.userId, 'user-1');
  });

  test(
    'invalid callback makes no token request and a new login can succeed',
    () async {
      final session = NodeLaneSession(base);
      final invalidCallbacks = <Uri Function(Uri)>[
        (uri) => uri.replace(scheme: 'mangayomi'),
        (uri) => uri.replace(port: 443),
        (uri) => uri.replace(
          queryParameters: {...uri.queryParameters, 'state': 'wrong-state'},
        ),
        (uri) =>
            uri.replace(queryParameters: {...uri.queryParameters, 'code': ''}),
      ];
      for (final invalid in invalidCallbacks) {
        callbackOverride = invalid;
        await expectLater(session.login(), throwsA(isA<TranslationFailure>()));
        expect(session.userId, isNull);
        expect(exchanges, isEmpty);
      }
      callbackOverride = null;
      await session.login();
      expect(session.userId, 'user-1');
      expect(exchanges.single['client_id'], nativeClient);
    },
  );

  test(
    'restoration isolates browser-client and other-service sessions',
    () async {
      for (final identity in [
        (base.toString(), 'old-browser-client'),
        ('https://another.example', nativeClient),
      ]) {
        FlutterSecureStorage.setMockInitialValues({
          'nodelane.official.session.v1': jsonEncode({
            'base': identity.$1,
            'clientId': identity.$2,
            'userId': 'other-user',
            'accessToken': 'other-access',
            'refreshToken': 'other-refresh',
            'expires': DateTime.now()
                .add(const Duration(hours: 1))
                .millisecondsSinceEpoch,
            'endpoint': 'https://identity.example/oidc/token',
            'resource': base.toString(),
          }),
        });
        final session = NodeLaneSession(base);
        await session.restore();
        expect(session.userId, isNull);
        await expectLater(
          session.accessToken(),
          throwsA(isA<TranslationFailure>()),
        );
      }
      expect(exchanges, isEmpty);
    },
  );
}

// Exercise the real HTTP/form handling against a local fixture. Production
// endpoints stay HTTPS; the test transport cannot contact any remote service.
class _LoopbackOverrides extends HttpOverrides {
  _LoopbackOverrides(this.port);
  final int port;

  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      _LoopbackClient(super.createHttpClient(context), port);
}

class _LoopbackClient implements HttpClient {
  _LoopbackClient(this.client, this.port);
  final HttpClient client;
  final int port;
  @override
  set connectionTimeout(Duration? value) => client.connectionTimeout = value;
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) => client.openUrl(
    method,
    url.replace(scheme: 'http', host: '127.0.0.1', port: port),
  );
  @override
  void close({bool force = false}) => client.close(force: force);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
