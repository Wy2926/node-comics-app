import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/modules/nodelane/nodelane_auth_service.dart';
import 'package:mangayomi/modules/nodelane/nodelane_config.dart';
import 'package:mangayomi/modules/nodelane/nodelane_credential_store.dart';
import 'package:mangayomi/modules/nodelane/nodelane_models.dart';

void main() {
  test(
    'missing native client does not fall back to the browser client',
    () async {
      final h = _Harness(clientId: '');
      await expectLater(h.service.signIn(), _error('CLIENT_NOT_CONFIGURED'));
      expect(h.requests, isEmpty);
      expect(h.service.state.account, isNull);
    },
  );

  test('PKCE login validates API and persists isolated identity', () async {
    final h = _Harness();
    await h.service.signIn();
    final account = h.service.state.account!;
    expect(account.subject, 'subject-a');
    expect(account.user.id, 'user-subject-a');
    expect(account.entitlements.modes['classic']!.available, 30);
    expect(h.authorization!.queryParameters['client_id'], 'native-client');
    expect(h.authorization!.queryParameters['prompt'], 'login consent');
    expect(
      h.authorization!.queryParameters['scope'],
      'openid profile offline_access',
    );
    expect(h.storage.json['refresh_token'], 'refresh-1');
    expect(h.requests.every((r) => !r.followRedirects), isTrue);
    expect(account.toString(), isNot(contains('refresh-1')));
  });

  test(
    'callback state and exact path are checked before token exchange',
    () async {
      final h = _Harness();
      h.callbackTransform = (uri) => uri.replace(path: '/different');
      await expectLater(h.service.signIn(), _error('CALLBACK_INVALID'));
      expect(h.tokenRequests, 0);
      expect(h.storage.value, isNull);
    },
  );

  test('initial login requires refresh permission', () async {
    final h = _Harness();
    h.tokenHandler = (_) async => _json({
      'access_token': h.token(),
      'token_type': 'Bearer',
      'expires_in': 3600,
    });
    await expectLater(h.service.signIn(), _error('RESPONSE_INVALID'));
    expect(h.service.state.account, isNull);
    expect(h.storage.value, isNull);
  });

  test('API validation happens before credentials are persisted', () async {
    final h = _Harness();
    h.apiHandler = (_) async => http.Response('{}', 403);
    await expectLater(h.service.signIn(), _error('FORBIDDEN'));
    expect(h.storage.value, isNull);
    expect(h.service.state.account, isNull);
  });

  test(
    'parallel 401s share rotation and replay identical bodies only once',
    () async {
      final h = _Harness();
      await h.service.signIn();
      final rotating = Completer<void>();
      final started = Completer<void>();
      h.tokenHandler = (_) async {
        if (!started.isCompleted) started.complete();
        await rotating.future;
        return h.tokenResponse(version: 2);
      };
      final sends = <http.Request>[];
      h.apiHandler = (r) async {
        sends.add(r);
        if (r.headers['Authorization'] == 'Bearer ${h.token()}') {
          return http.Response('{}', 401);
        }
        expect(h.storage.json['refresh_token'], 'refresh-2');
        return _json({'ok': true});
      };
      final original = [1, 2, 3, 255];
      final a = h.service.request(
        'PUT',
        '/v1/translations/id-a/input',
        bodyBytes: original,
      );
      final b = h.service.request(
        'PUT',
        '/v1/translations/id-b/input',
        bodyBytes: original,
      );
      await started.future;
      await Future<void>.delayed(Duration.zero);
      original[0] = 88;
      rotating.complete();
      await Future.wait([a, b]);
      expect(h.refreshRequests, 1);
      expect(sends, hasLength(4));
      expect(
        sends.map((r) => r.bodyBytes.toList()),
        everyElement([1, 2, 3, 255]),
      );
      expect(
        sends.every((r) => r.headers['X-Translation-Protocol'] == 'overlay-v1'),
        isTrue,
      );
    },
  );

  test('a second 401 clears local credentials', () async {
    final h = _Harness();
    await h.service.signIn();
    h.apiHandler = (_) async => http.Response('{}', 401);
    await expectLater(
      h.service.request('GET', '/v1/me'),
      _error('LOGIN_REQUIRED'),
    );
    expect(h.refreshRequests, 1);
    expect(h.service.state.account, isNull);
    expect(h.storage.value, isNull);
  });

  for (final status in [403, 429, 500]) {
    test('HTTP $status preserves account credentials', () async {
      final h = _Harness();
      await h.service.signIn();
      final stored = h.storage.value;
      h.apiHandler = (_) async =>
          http.Response('{"token":"must-not-be-displayed"}', status);
      await expectLater(
        h.service.reloadAccount(),
        throwsA(isA<NodeLaneException>()),
      );
      expect(h.service.state.account, isNotNull);
      expect(h.storage.value, stored);
      expect(
        h.service.state.error.toString(),
        isNot(contains('must-not-be-displayed')),
      );
      expect(h.refreshRequests, 0);
    });
  }

  test(
    'temporary refresh failure shares cooldown and uses a still-valid token',
    () async {
      final h = _Harness();
      await h.service.signIn();
      h.now = h.now.add(const Duration(seconds: 3550));
      h.tokenHandler = (_) async => http.Response('{}', 503);
      await h.service.request('GET', '/v1/me');
      await h.service.request('GET', '/v1/me');
      expect(h.refreshRequests, 1);
      expect(h.service.state.account, isNotNull);
      expect(h.storage.json['refresh_token'], 'refresh-1');
    },
  );

  test('expired token is not sent during temporary refresh failure', () async {
    final h = _Harness();
    await h.service.signIn();
    h.now = h.now.add(const Duration(hours: 2));
    h.tokenHandler = (_) async =>
        throw http.ClientException('secret transport information');
    final before = h.apiRequests;
    await expectLater(
      h.service.request('GET', '/v1/me'),
      _error('CONNECTION_FAILED'),
    );
    expect(h.apiRequests, before);
    expect(h.service.state.account, isNotNull);
    expect(h.storage.value, isNotNull);
  });

  test('explicit invalid_grant clears credentials', () async {
    final h = _Harness();
    await h.service.signIn();
    h.now = h.now.add(const Duration(hours: 2));
    h.tokenHandler = (_) async => _json({'error': 'invalid_grant'}, 400);
    await expectLater(
      h.service.request('GET', '/v1/me'),
      _error('LOGIN_REQUIRED'),
    );
    expect(h.service.state.account, isNull);
    expect(h.storage.value, isNull);
  });

  test('late refresh cannot restore an account after sign-out', () async {
    final h = _Harness();
    await h.service.signIn();
    h.now = h.now.add(const Duration(hours: 2));
    final release = Completer<void>();
    final started = Completer<void>();
    h.tokenHandler = (_) async {
      started.complete();
      await release.future;
      return h.tokenResponse(version: 2);
    };
    final request = h.service.request('GET', '/v1/me');
    final checked = expectLater(request, _error('SESSION_CHANGED'));
    await started.future;
    await h.service.signOut();
    release.complete();
    await checked;
    expect(h.service.state.account, isNull);
    expect(h.storage.value, isNull);
  });

  test(
    'late old account response cannot overwrite a switched account',
    () async {
      final h = _Harness();
      await h.service.signIn();
      final oldAccount = h.service.state.account!;
      final returned = Completer<http.Response>();
      final started = Completer<void>();
      h.apiHandler = (_) {
        started.complete();
        return returned.future;
      };
      final request = h.service.reloadAccount();
      final checked = expectLater(request, _error('SESSION_CHANGED'));
      await started.future;
      await h.service.signOut();
      h.subject = 'subject-b';
      h.apiHandler = null;
      await h.service.signIn(selectAccount: true);
      returned.complete(h.meResponse(subject: 'subject-a'));
      await checked;
      expect(h.service.state.account!.subject, 'subject-b');
      expect(h.storage.json['subject'], 'subject-b');
      expect(h.service.state.account!.scopeKey, isNot(oldAccount.scopeKey));
    },
  );

  test('restored account remains available when API is offline', () async {
    final h = _Harness();
    await h.service.signIn();
    final restored = _Harness(store: h.storage);
    restored.apiHandler = (_) async => throw http.ClientException('offline');
    await restored.service.initialize();
    expect(restored.service.state.initialized, isTrue);
    expect(restored.service.state.account!.subject, 'subject-a');
    expect(restored.service.state.error!.code, 'CONNECTION_FAILED');
    expect(h.storage.value, isNotNull);
  });

  test(
    'profile update cannot roll back concurrently rotated credentials',
    () async {
      final h = _Harness();
      await h.service.signIn();
      final me = Completer<http.Response>();
      final meStarted = Completer<void>();
      final writing = Completer<void>();
      final writeRelease = Completer<void>();
      h.storage.beforeWrite = (value) async {
        if (jsonDecode(value)['refresh_token'] == 'refresh-2' &&
            !writing.isCompleted) {
          writing.complete();
          await writeRelease.future;
        }
      };
      h.apiHandler = (r) async {
        if (r.url.path == '/v1/me') {
          meStarted.complete();
          return me.future;
        }
        return r.headers['Authorization'] == 'Bearer ${h.token()}'
            ? http.Response('{}', 401)
            : _json({'ok': true});
      };
      final profile = h.service.reloadAccount();
      await meStarted.future;
      final mutation = h.service.request(
        'PUT',
        '/v1/translations/id-a',
        bodyBytes: [1],
      );
      await writing.future;
      me.complete(h.meResponse(name: 'Updated name'));
      await Future<void>.delayed(Duration.zero);
      writeRelease.complete();
      await Future.wait([profile, mutation]);
      expect(h.storage.json['refresh_token'], 'refresh-2');
      expect(h.service.state.account!.user.name, 'Updated name');
      expect(
        (h.storage.json['account'] as Map)['user']['name'],
        'Updated name',
      );
    },
  );

  test(
    'failed rotation save is retried before any API request or second refresh',
    () async {
      final h = _Harness();
      await h.service.signIn();
      h.now = h.now.add(const Duration(hours: 2));
      h.storage.failWrite = true;
      final before = h.apiRequests;
      await expectLater(
        h.service.request('GET', '/v1/me'),
        _error('STORAGE_FAILED'),
      );
      expect(h.apiRequests, before);
      expect(h.refreshRequests, 1);
      expect(h.storage.json['refresh_token'], 'refresh-1');
      h.storage.failWrite = false;
      await h.service.request('GET', '/v1/me');
      expect(h.refreshRequests, 1);
      expect(h.storage.json['refresh_token'], 'refresh-2');
    },
  );

  test(
    'unclassified identity 401 does not clear a renewable session',
    () async {
      final h = _Harness();
      await h.service.signIn();
      h.now = h.now.add(const Duration(hours: 2));
      h.tokenHandler = (_) async => http.Response('{}', 401);
      await expectLater(
        h.service.request('GET', '/v1/me'),
        _error('IDENTITY_FAILED'),
      );
      expect(h.service.state.account, isNotNull);
      expect(h.storage.value, isNotNull);
    },
  );

  for (final status in [200, 401]) {
    test('late old HTTP $status cannot affect a new account', () async {
      final h = _Harness();
      await h.service.signIn();
      final response = Completer<http.Response>();
      final started = Completer<void>();
      h.apiHandler = (_) {
        started.complete();
        return response.future;
      };
      final request = h.service.request('GET', '/v1/me');
      final checked = expectLater(request, _error('SESSION_CHANGED'));
      await started.future;
      await h.service.signOut();
      h.subject = 'subject-b';
      h.apiHandler = null;
      await h.service.signIn(selectAccount: true);
      response.complete(http.Response('{}', status));
      await checked;
      expect(h.service.state.account!.subject, 'subject-b');
      expect(h.storage.json['subject'], 'subject-b');
      expect(h.refreshRequests, 0);
    });
  }

  test(
    'old sign-out delete failure cannot clear a new sign-in busy state',
    () async {
      final h = _Harness();
      await h.service.signIn();
      final deleting = Completer<void>();
      final deleteFailure = Completer<void>();
      var deletes = 0;
      h.storage.beforeDelete = () async {
        if (deletes++ == 0) {
          deleting.complete();
          await deleteFailure.future;
          throw StateError('delete failed');
        }
      };
      final oldExit = h.service.signOut();
      final exitChecked = expectLater(oldExit, _error('STORAGE_FAILED'));
      await deleting.future;
      final browserStarted = Completer<void>();
      final finishLogin = Completer<void>();
      h.beforeBrowserReturn = () async {
        browserStarted.complete();
        await finishLogin.future;
      };
      final newLogin = h.service.signIn();
      deleteFailure.complete();
      await exitChecked;
      await browserStarted.future;
      expect(h.service.state.busy, isTrue);
      expect(h.service.state.error, isNull);
      finishLogin.complete();
      await newLogin;
      expect(h.service.state.account, isNotNull);
    },
  );

  test(
    'origin and credential separation reject cross-origin paths and cookies',
    () async {
      final h = _Harness();
      await h.service.signIn();
      await expectLater(
        h.service.request('GET', 'https://source.test/v1/me'),
        throwsArgumentError,
      );
      await expectLater(
        h.service.request('GET', '/v1/me', headers: {'Cookie': 'private'}),
        throwsArgumentError,
      );
      expect(h.requests.every((r) => !r.headers.containsKey('Cookie')), isTrue);
    },
  );
}

Matcher _error(String code) =>
    throwsA(isA<NodeLaneException>().having((e) => e.code, 'code', code));
http.Response _json(Map<String, dynamic> body, [int status = 200]) =>
    http.Response(
      jsonEncode(body),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

class _MemoryStore implements NodeLaneCredentialStore {
  String? value;
  bool failWrite = false;
  Future<void> Function(String)? beforeWrite;
  Future<void> Function()? beforeDelete;
  Map<String, dynamic> get json => jsonDecode(value!) as Map<String, dynamic>;
  @override
  Future<String?> read(String key) async => value;
  @override
  Future<void> delete(String key) async {
    await beforeDelete?.call();
    value = null;
  }

  @override
  Future<void> write(String key, String value) async {
    await beforeWrite?.call(value);
    if (failWrite) throw StateError('secure storage unavailable');
    this.value = value;
  }
}

class _Harness {
  _Harness({String clientId = 'native-client', _MemoryStore? store})
    : storage = store ?? _MemoryStore() {
    service = NodeLaneAuthService(
      config: NodeLaneConfig(
        serviceOrigin: 'https://center.test',
        clientId: clientId,
      ),
      store: storage,
      now: () => now,
      client: MockClient(_handle),
      browserLogin: (uri, scheme) async {
        authorization = uri;
        expect(scheme, 'net.nodelane.comics');
        await beforeBrowserReturn?.call();
        final callback = Uri.parse(uri.queryParameters['redirect_uri']!)
            .replace(
              queryParameters: {
                'state': uri.queryParameters['state']!,
                'code': 'test-code',
              },
            );
        return (callbackTransform?.call(callback) ?? callback).toString();
      },
    );
    addTearDown(service.dispose);
  }
  final _MemoryStore storage;
  late final NodeLaneAuthService service;
  DateTime now = DateTime.utc(2026, 10, 5);
  String subject = 'subject-a';
  Uri? authorization;
  Uri Function(Uri)? callbackTransform;
  Future<void> Function()? beforeBrowserReturn;
  Future<http.Response> Function(http.Request)? tokenHandler;
  Future<http.Response> Function(http.Request)? apiHandler;
  final requests = <http.Request>[];
  int tokenRequests = 0;
  int refreshRequests = 0;
  int apiRequests = 0;

  String token({int version = 1}) {
    String encode(Object data) =>
        base64Url.encode(utf8.encode(jsonEncode(data))).replaceAll('=', '');
    return '${encode({'alg': 'RS256'})}.${encode({'iss': 'https://identity.test/oidc', 'aud': 'https://center.test', 'sub': subject, 'version': version})}.fixture-signature';
  }

  http.Response tokenResponse({int version = 2}) => _json({
    'access_token': token(version: version),
    'refresh_token': 'refresh-$version',
    'token_type': 'Bearer',
    'expires_in': 3600,
  });
  http.Response meResponse({String? subject, String name = 'Reader'}) => _json({
    'user': {
      'id': 'user-${subject ?? this.subject}',
      'name': name,
      'role': 'user',
    },
    'entitlements': {
      'plan': 'free',
      'plus_expires_at': null,
      'modes': {
        'classic': {
          'allowed': true,
          'unlimited': false,
          'quota_kind': 'daily',
          'quota': {'available': 30, 'used': 0, 'reserved': 0, 'granted': 30},
        },
      },
    },
  });
  Future<http.Response> _handle(http.Request request) async {
    requests.add(request);
    if (request.url.path == '/v1/auth/config') {
      return _json({
        'mode': 'oidc',
        'client_id': 'browser-client-must-not-be-used',
        'issuer': 'https://identity.test/oidc',
        'audience': 'https://center.test',
        'authorization_endpoint': 'https://identity.test/oidc/auth',
        'token_endpoint': 'https://identity.test/oidc/token',
      });
    }
    if (request.url.path == '/oidc/token') {
      tokenRequests++;
      final fields = Uri.splitQueryString(request.body);
      expect(fields['client_id'], 'native-client');
      expect(fields['resource'], 'https://center.test');
      if (fields['grant_type'] == 'authorization_code') {
        final challenge = base64Url
            .encode(sha256.convert(utf8.encode(fields['code_verifier']!)).bytes)
            .replaceAll('=', '');
        expect(challenge, authorization!.queryParameters['code_challenge']);
        return tokenHandler?.call(request) ?? tokenResponse(version: 1);
      }
      refreshRequests++;
      return tokenHandler?.call(request) ?? tokenResponse();
    }
    apiRequests++;
    return apiHandler?.call(request) ?? meResponse();
  }
}
