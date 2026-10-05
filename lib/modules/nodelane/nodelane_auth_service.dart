import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

import 'nodelane_config.dart';
import 'nodelane_credential_store.dart';
import 'nodelane_models.dart';

typedef NodeLaneBrowserLogin = Future<String> Function(
  Uri authorizationUrl,
  String callbackScheme,
);

/// Independent authenticated client for the NodeLane API. No source-site
/// client, cookie jar, tracker storage or default request logger is reused.
class NodeLaneAuthService extends ChangeNotifier {
  NodeLaneAuthService({
    required this.config,
    NodeLaneCredentialStore? store,
    http.Client? client,
    NodeLaneBrowserLogin? browserLogin,
    DateTime Function()? now,
  }) : _store = store ?? const SecureNodeLaneCredentialStore(),
       _client = client ?? http.Client(),
       _browserLogin = browserLogin ?? _openBrowser,
       _now = now ?? DateTime.now;

  final NodeLaneConfig config;
  final NodeLaneCredentialStore _store;
  final http.Client _client;
  final NodeLaneBrowserLogin _browserLogin;
  final DateTime Function() _now;
  NodeLaneAuthState _state = const NodeLaneAuthState();
  _Session? _session;
  _Session? _pendingRotation;
  Future<void>? _initializing;
  Future<_Session>? _refreshing;
  String? _refreshingSessionId;
  DateTime? _refreshRetryAt;
  Future<void> _storageQueue = Future.value();
  int _epoch = 0;
  bool _disposed = false;
  final _streamAborts = <Completer<void>>{};

  NodeLaneAuthState get state => _state;

  Future<void> initialize() => _initializing ??= _initialize();

  Future<void> _initialize() async {
    final epoch = _epoch;
    try {
      final raw = await _storage(() => _store.read(config.storageKey));
      _assertEpoch(epoch);
      if (raw != null) {
        try {
          final session = _Session.fromJson(_decodeObject(raw), config);
          _session = session;
          _publish(initialized: true);
          await reloadAccount();
        } on FormatException {
          await _storage(() => _store.delete(config.storageKey));
          _assertEpoch(epoch);
          _session = null;
          throw const NodeLaneException('SESSION_INVALID', '本机登录记录无效，请重新登录。');
        }
      }
      _assertEpoch(epoch);
      _publish(initialized: true);
    } catch (error) {
      if (epoch == _epoch) {
        _publish(initialized: true, error: _safeError(error));
      }
    }
  }

  Future<void> signIn({bool selectAccount = false}) async {
    if (_state.busy) return;
    if (!config.canSignIn) {
      const error = NodeLaneException(
        'CLIENT_NOT_CONFIGURED',
        '尚未配置 NodeLane 原生应用 Client ID。',
      );
      _publish(initialized: true, error: error);
      throw error;
    }
    final epoch = ++_epoch;
    _abortStreams();
    _session = null;
    _pendingRotation = null;
    _refreshRetryAt = null;
    _publish(initialized: true, busy: true);
    try {
      // Switching accounts invalidates the previous local session before the
      // browser starts. Queued writes cannot resurrect it after this delete.
      await _storage(() => _store.delete(config.storageKey));
      _assertEpoch(epoch);
      final callback = config.callback;
      final identityResponse = await _send(
        'GET',
        config.endpoint('/v1/auth/config'),
      );
      _assertEpoch(epoch);
      _requireSuccess(identityResponse);
      final identity = _Identity.fromJson(_decodeObject(identityResponse.body));
      final verifier = _randomString(48);
      final state = _randomString(24);
      final createdAt = _now();
      final authorization = identity.authorization.replace(
        queryParameters: {
          'response_type': 'code',
          'client_id': config.clientId,
          'redirect_uri': callback.toString(),
          'scope': 'openid profile offline_access',
          'prompt': 'login consent',
          'state': state,
          'code_challenge': _base64(
            sha256.convert(utf8.encode(verifier)).bytes,
          ),
          'code_challenge_method': 'S256',
          'resource': identity.resource,
          'audience': identity.resource,
        },
      );
      final returned = Uri.parse(
        await _browserLogin(authorization, callback.scheme),
      );
      _assertEpoch(epoch);
      if (returned.scheme != callback.scheme ||
          returned.authority != callback.authority ||
          returned.path != callback.path ||
          returned.hasFragment ||
          returned.queryParametersAll['state']?.length != 1 ||
          returned.queryParameters['state'] != state ||
          _now().difference(createdAt) > const Duration(minutes: 10)) {
        throw const NodeLaneException('CALLBACK_INVALID', '登录状态无效或已过期，请重新登录。');
      }
      if (returned.queryParameters.containsKey('error')) {
        throw const NodeLaneException('LOGIN_CANCELLED', '登录未完成，可以重试。');
      }
      final code = returned.queryParameters['code'];
      if (code == null ||
          code.isEmpty ||
          returned.queryParametersAll['code']?.length != 1) {
        throw const NodeLaneException('CALLBACK_INVALID', '身份服务未返回有效授权码。');
      }
      final issuedAt = _now();
      final tokenResponse = await _tokenRequest(identity.token, {
        'grant_type': 'authorization_code',
        'client_id': config.clientId,
        'redirect_uri': callback.toString(),
        'code': code,
        'code_verifier': verifier,
        'resource': identity.resource,
      });
      _assertEpoch(epoch);
      _requireSuccess(tokenResponse, identity: true);
      final tokens = _Tokens.fromJson(
        _decodeObject(tokenResponse.body),
        issuedAt,
      );
      // The product API validates this exact token's signature, issuer,
      // audience, subject and expiry before its claims are used locally.
      final me = await _send(
        'GET',
        config.endpoint('/v1/me'),
        token: tokens.accessToken,
      );
      _assertEpoch(epoch);
      _requireSuccess(me);
      final subject = _subject(
        tokens.accessToken,
        identity.issuer,
        identity.resource,
      );
      final session = _Session(
        id: _randomString(24),
        issuer: identity.issuer,
        subject: subject,
        tokenEndpoint: identity.token,
        resource: identity.resource,
        tokens: tokens,
        accountJson: _decodeObject(me.body),
        config: config,
      );
      await _persist(session, epoch);
      _assertEpoch(epoch);
      _publish(initialized: true);
    } catch (error) {
      final safe = _safeError(error);
      if (epoch == _epoch) _publish(initialized: true, error: safe);
      throw safe;
    }
  }

  /// Local sign-out intentionally leaves the identity provider's other apps
  /// and browser SSO untouched; the next sign-in requests login and consent.
  Future<void> signOut() async {
    final epoch = ++_epoch;
    _abortStreams();
    _session = null;
    _pendingRotation = null;
    _refreshRetryAt = null;
    _publish(initialized: true);
    try {
      await _storage(() => _store.delete(config.storageKey));
    } catch (_) {
      const error = NodeLaneException('STORAGE_FAILED', '未能清除安全存储，请重试退出。');
      if (epoch == _epoch) _publish(initialized: true, error: error);
      throw error;
    }
  }

  Future<void> reloadAccount() async {
    if (_session == null) return;
    final epoch = _epoch;
    _publish(initialized: true, busy: true);
    try {
      final response = await request('GET', '/v1/me');
      _assertEpoch(epoch);
      final session = _session!;
      final accountJson = _decodeObject(response.body);
      final updated = session.withAccount(accountJson);
      // A different backend identity is never accepted into an existing scope.
      if (updated.account.user.id != session.account.user.id) {
        await signOut();
        throw const NodeLaneException('IDENTITY_CHANGED', '账户身份已变更，请重新登录。');
      }
      await _storage(() async {
        _assertEpoch(epoch);
        final current = _session;
        if (current == null || current.id != session.id) throw _sessionChanged;
        // Merge display data with the latest credentials inside the write
        // queue. A concurrent token rotation must never be rolled back.
        final merged = current.withAccount(accountJson);
        await _store.write(config.storageKey, jsonEncode(merged.toJson()));
        _assertEpoch(epoch);
        _session = merged;
      });
      _assertEpoch(epoch);
      _publish(initialized: true);
    } catch (error) {
      final safe = _safeError(error);
      if (epoch == _epoch) _publish(initialized: true, error: safe);
      throw safe;
    }
  }

  /// Replays at most once on 401 with the same frozen bytes and headers.
  /// Only the configured center origin is reachable; redirects stay disabled.
  Future<http.Response> request(
    String method,
    String path, {
    List<int>? bodyBytes,
    Map<String, String> headers = const {},
  }) async {
    final bytes = bodyBytes == null ? null : List<int>.unmodifiable(bodyBytes);
    final response = await requestStream(
      method,
      path,
      body: bytes == null ? null : () => Stream.value(bytes),
      contentLength: bytes?.length,
      headers: headers,
    );
    return http.Response.fromStream(response);
  }

  /// Reopens the same frozen file on the single permitted 401 replay.
  /// The caller consumes/cancels the response stream; credentials never escape.
  Future<http.StreamedResponse> requestStream(
    String method,
    String path, {
    Stream<List<int>> Function()? body,
    int? contentLength,
    Map<String, String> headers = const {},
    Future<void>? abort,
    Duration idleTimeout = const Duration(seconds: 45),
  }) async {
    final epoch = _epoch;
    final immutableHeaders = Map<String, String>.unmodifiable(headers);
    if (immutableHeaders.keys.any(
      (key) => [
        'authorization',
        'cookie',
        'x-session-token',
      ].contains(key.toLowerCase()),
    )) {
      throw ArgumentError(
        'Foreign credentials are not allowed on NodeLane requests.',
      );
    }
    final uri = config.endpoint(path);
    var session = _session;
    if (session == null) {
      throw const NodeLaneException('LOGIN_REQUIRED', '请先登录 NodeLane。');
    }
    // A previous token rotation may have succeeded while secure storage was
    // temporarily unavailable. Retry saving those exact credentials first.
    final pending = _pendingRotation;
    if (pending != null && pending.id == session.id) {
      await _persist(pending, epoch);
      _assertEpoch(epoch);
      _pendingRotation = null;
      session = _session!;
    }
    if (!_now().isBefore(session.tokens.refreshAt)) {
      session = await _refresh(session);
    }
    _assertEpoch(epoch);
    var response = await _sendStream(
      method,
      uri,
      session.tokens.accessToken,
      body,
      contentLength,
      immutableHeaders,
      abort,
      epoch,
      idleTimeout,
    );
    _assertEpoch(epoch);
    if (response.statusCode == 401) {
      await response.stream.listen(null).cancel();
      session = await _refresh(session, force: true);
      _assertEpoch(epoch);
      response = await _sendStream(
        method,
        uri,
        session.tokens.accessToken,
        body,
        contentLength,
        immutableHeaders,
        abort,
        epoch,
        idleTimeout,
      );
      _assertEpoch(epoch);
      if (response.statusCode == 401 &&
          _session?.tokens.accessToken == session.tokens.accessToken) {
        await response.stream.listen(null).cancel();
        await signOut();
        throw const NodeLaneException('LOGIN_REQUIRED', '登录已失效，请重新登录。');
      }
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      // Do not expose raw backend payloads (which may contain private URLs).
      final status = response.statusCode;
      final retry = int.tryParse(response.headers['retry-after'] ?? '');
      String? code;
      try {
        final bytes = <int>[];
        await for (final chunk in response.stream) {
          if (bytes.length + chunk.length > 16384) break;
          bytes.addAll(chunk);
        }
        final value =
            (_tryObject(utf8.decode(bytes))?['error'] as Map?)?['code'];
        if (value is String &&
            RegExp(r'^[A-Z][A-Z0-9_]{0,59}$').hasMatch(value)) {
          code = value;
        }
      } catch (_) {
        _assertEpoch(epoch);
      }
      _assertEpoch(epoch);
      if (code != null) {
        throw NodeLaneException(
          code,
          '请求暂时未完成。',
          statusCode: status,
          retryAfterSeconds: retry,
        );
      }
      if (status == 429 || status == 503) {
        throw NodeLaneException(
          'RATE_LIMITED',
          '服务繁忙，请稍后继续。',
          statusCode: status,
          retryAfterSeconds: retry,
        );
      }
      _requireSuccess(http.Response('', status));
    }
    return response;
  }

  Future<http.StreamedResponse> _sendStream(
    String method,
    Uri uri,
    String token,
    Stream<List<int>> Function()? body,
    int? length,
    Map<String, String> headers,
    Future<void>? abort,
    int epoch,
    Duration idleTimeout,
  ) async {
    final stop = Completer<void>();
    void cancel() {
      if (!stop.isCompleted) stop.complete();
    }

    _streamAborts.add(stop);
    if (abort != null) unawaited(abort.then((_) => cancel()));
    final request = _FileStreamRequest(method, uri, body, stop.future)
      ..followRedirects = false
      ..contentLength = length
      ..headers.addAll({
        'Accept': 'application/json',
        ...headers,
        'Authorization': 'Bearer $token',
        if (uri.path.startsWith('/v1/translations'))
          'X-Translation-Protocol': 'overlay-v1',
      });
    try {
      final response = await _client
          .send(request)
          .timeout(
            const Duration(minutes: 2),
            onTimeout: () {
              cancel();
              throw _connectionError;
            },
          );
      _assertEpoch(epoch);
      late StreamController<List<int>> guarded;
      StreamSubscription<List<int>>? subscription;
      void cleanup() {
        cancel();
        _streamAborts.remove(stop);
      }

      void fail(Object error, StackTrace stack) {
        try {
          _assertEpoch(epoch);
        } catch (changed) {
          error = changed;
        }
        guarded.addError(
          error is NodeLaneException ? error : _connectionError,
          stack,
        );
        cleanup();
        unawaited(subscription?.cancel());
        unawaited(guarded.close());
      }

      guarded = StreamController<List<int>>(
        onListen: () {
          subscription = response.stream
              .timeout(idleTimeout)
              .listen(
                (chunk) {
                  try {
                    _assertEpoch(epoch);
                    guarded.add(chunk);
                  } catch (error, stack) {
                    fail(error, stack);
                  }
                },
                onError: fail,
                onDone: () {
                  try {
                    _assertEpoch(epoch);
                  } catch (error, stack) {
                    guarded.addError(error, stack);
                  }
                  cleanup();
                  unawaited(guarded.close());
                },
              );
        },
        onPause: () => subscription?.pause(),
        onResume: () => subscription?.resume(),
        onCancel: () async {
          cleanup();
          await subscription?.cancel();
        },
      );
      return http.StreamedResponse(
        guarded.stream,
        response.statusCode,
        headers: response.headers,
        contentLength: response.contentLength,
      );
    } catch (_) {
      cancel();
      _streamAborts.remove(stop);
      _assertEpoch(epoch);
      throw _connectionError;
    }
  }

  void _abortStreams() {
    for (final abort in _streamAborts) {
      if (!abort.isCompleted) abort.complete();
    }
    _streamAborts.clear();
  }

  Future<_Session> _refresh(_Session expected, {bool force = false}) async {
    final current = _session;
    if (current == null || current.id != expected.id) throw _sessionChanged;
    // A concurrent request may already have rotated the rejected token.
    if (current.tokens.accessToken != expected.tokens.accessToken) {
      return current;
    }
    if (_refreshing != null && _refreshingSessionId == current.id) {
      return _refreshing!;
    }
    if (_refreshRetryAt != null && _now().isBefore(_refreshRetryAt!)) {
      if (!force && _now().isBefore(current.tokens.expiresAt)) return current;
      throw _connectionError;
    }
    _refreshingSessionId = current.id;
    final future = _performRefresh(current, _epoch, force: force);
    _refreshing = future;
    try {
      return await future;
    } finally {
      if (identical(_refreshing, future)) {
        _refreshing = null;
        _refreshingSessionId = null;
      }
    }
  }

  Future<_Session> _performRefresh(
    _Session expected,
    int epoch, {
    required bool force,
  }) async {
    try {
      final issuedAt = _now();
      final response = await _tokenRequest(expected.tokenEndpoint, {
        'grant_type': 'refresh_token',
        'client_id': config.clientId,
        'refresh_token': expected.tokens.refreshToken,
        'resource': expected.resource,
      });
      _assertEpoch(epoch);
      if (response.statusCode == 400 || response.statusCode == 401) {
        final failure = _tryObject(response.body)?['error'];
        if ([
          'invalid_grant',
          'invalid_client',
          'unauthorized_client',
        ].contains(failure)) {
          await signOut();
          throw const NodeLaneException('LOGIN_REQUIRED', '登录授权已失效，请重新登录。');
        }
      }
      _requireSuccess(response, identity: true);
      final tokens = _Tokens.fromJson(
        _decodeObject(response.body),
        issuedAt,
        previousRefreshToken: expected.tokens.refreshToken,
      );
      if (_subject(tokens.accessToken, expected.issuer, expected.resource) !=
          expected.subject) {
        await signOut();
        throw const NodeLaneException('IDENTITY_CHANGED', '账户身份已变更，请重新登录。');
      }
      final updated = expected.withTokens(tokens);
      _pendingRotation = updated;
      // Persist rotated credentials before allowing any waiting API request.
      await _persist(updated, epoch);
      _assertEpoch(epoch);
      _pendingRotation = null;
      _refreshRetryAt = null;
      _publish(initialized: true, busy: _state.busy);
      return _session!;
    } catch (error) {
      final safe = _safeError(error);
      if (safe.code == 'LOGIN_REQUIRED' || safe.code == 'IDENTITY_CHANGED') {
        throw safe;
      }
      _assertEpoch(epoch);
      _refreshRetryAt = _now().add(const Duration(seconds: 30));
      if (!force &&
          _now().isBefore(expected.tokens.expiresAt) &&
          safe.code != 'STORAGE_FAILED') {
        return expected;
      }
      throw safe;
    }
  }

  Future<void> _persist(_Session session, int epoch) => _storage(() async {
    _assertEpoch(epoch);
    // Construct account before write so malformed API responses never persist.
    session.account;
    final current = _session;
    final merged = current != null && current.id == session.id
        ? session.withAccount(current.accountJson)
        : session;
    await _store.write(config.storageKey, jsonEncode(merged.toJson()));
    _assertEpoch(epoch);
    _session = merged;
  });

  Future<T> _storage<T>(Future<T> Function() operation) {
    final result = _storageQueue.then((_) async {
      try {
        return await operation();
      } on NodeLaneException {
        rethrow;
      } catch (_) {
        throw const NodeLaneException(
          'STORAGE_FAILED',
          '无法访问设备安全存储，请确认已设置系统锁屏密码后重试。',
        );
      }
    });
    _storageQueue = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return result;
  }

  Future<http.Response> _tokenRequest(Uri uri, Map<String, String> fields) =>
      _send(
        'POST',
        uri,
        bytes: utf8.encode(Uri(queryParameters: fields).query),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

  Future<http.Response> _send(
    String method,
    Uri uri, {
    String? token,
    List<int>? bytes,
    Map<String, String> headers = const {},
  }) async {
    final request = http.Request(method, uri)..followRedirects = false;
    request.headers.addAll({'Accept': 'application/json', ...headers});
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    if (uri.path.startsWith('/v1/translations')) {
      request.headers['X-Translation-Protocol'] = 'overlay-v1';
    }
    if (bytes != null) request.bodyBytes = bytes;
    try {
      return await _client
          .send(request)
          .then(http.Response.fromStream)
          .timeout(const Duration(seconds: 15));
    } catch (_) {
      throw _connectionError;
    }
  }

  void _assertEpoch(int epoch) {
    if (_disposed || epoch != _epoch) throw _sessionChanged;
  }

  void _publish({
    required bool initialized,
    bool busy = false,
    NodeLaneException? error,
  }) {
    if (_disposed) return;
    _state = NodeLaneAuthState(
      initialized: initialized,
      busy: busy,
      account: _session?.account,
      error: error,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    ++_epoch;
    _abortStreams();
    _client.close();
    super.dispose();
  }

  static Future<String> _openBrowser(Uri uri, String scheme) =>
      FlutterWebAuth2.authenticate(
        url: uri.toString(),
        callbackUrlScheme: scheme,
      );
}

class _FileStreamRequest extends http.BaseRequest with http.Abortable {
  _FileStreamRequest(super.method, super.url, this.body, this.abortTrigger);
  final Stream<List<int>> Function()? body;
  @override
  final Future<void> abortTrigger;
  @override
  http.ByteStream finalize() {
    super.finalize();
    return http.ByteStream(body?.call() ?? const Stream.empty());
  }
}

const _connectionError = NodeLaneException(
  'CONNECTION_FAILED',
  '暂时无法连接 NodeLane，请稍后重试。',
);
const _sessionChanged = NodeLaneException('SESSION_CHANGED', '账户会话已变更，请重试。');

NodeLaneException _safeError(Object error) {
  if (error is NodeLaneException) return error;
  if (error is PlatformException &&
      ['CANCELED', 'CANCELLED', 'cancelled', 'canceled'].contains(error.code)) {
    return const NodeLaneException('LOGIN_CANCELLED', '登录窗口已关闭，可以重试。');
  }
  if (error is FormatException || error is TypeError) {
    return const NodeLaneException(
      'RESPONSE_INVALID',
      'NodeLane 返回的数据无效，请稍后重试。',
    );
  }
  return _connectionError;
}

void _requireSuccess(http.Response response, {bool identity = false}) {
  final status = response.statusCode;
  if (status >= 200 && status < 300) return;
  if (status == 401 && !identity) {
    throw NodeLaneException(
      'LOGIN_REQUIRED',
      '登录已失效，请重新登录。',
      statusCode: status,
    );
  }
  if (status == 403) {
    throw NodeLaneException('FORBIDDEN', '当前账户没有此操作的权限。', statusCode: status);
  }
  if (status == 429) {
    throw NodeLaneException(
      'RATE_LIMITED',
      '请求过于频繁，请稍后重试。',
      statusCode: status,
    );
  }
  throw NodeLaneException(
    identity ? 'IDENTITY_FAILED' : 'REQUEST_FAILED',
    identity ? '身份服务暂时不可用，请稍后重试。' : 'NodeLane 请求失败，请稍后重试。',
    statusCode: status,
  );
}

Map<String, dynamic> _decodeObject(String value) =>
    jsonDecode(value) as Map<String, dynamic>;
Map<String, dynamic>? _tryObject(String value) {
  try {
    return _decodeObject(value);
  } catch (_) {
    return null;
  }
}

String _base64(List<int> bytes) => base64Url.encode(bytes).replaceAll('=', '');
String _randomString(int count) {
  final random = Random.secure();
  return _base64(List.generate(count, (_) => random.nextInt(256)));
}

Uri _identityUrl(String value) {
  final uri = Uri.parse(value);
  if (uri.scheme != 'https' ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      uri.hasFragment ||
      uri.hasQuery) {
    throw const FormatException('Invalid HTTPS identity endpoint.');
  }
  return uri;
}

String _subject(String token, String issuer, String resource) {
  final parts = token.split('.');
  if (parts.length != 3) throw const FormatException('Invalid access token.');
  final claims = _decodeObject(
    utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
  );
  final subject = claims['sub'];
  final audience = claims['aud'];
  final matchesAudience =
      audience == resource || (audience is List && audience.contains(resource));
  if (claims['iss'] != issuer ||
      !matchesAudience ||
      subject is! String ||
      subject.isEmpty) {
    throw const FormatException('Invalid access token identity.');
  }
  return subject;
}

class _Identity {
  _Identity.fromJson(Map<String, dynamic> json)
    : issuer = json['issuer'] as String,
      resource = json['audience'] as String,
      authorization = _identityUrl(json['authorization_endpoint'] as String),
      token = _identityUrl(json['token_endpoint'] as String) {
    if (json['mode'] != 'oidc' ||
        resource.isEmpty ||
        authorization.origin != _identityUrl(issuer).origin ||
        token.origin != authorization.origin) {
      throw const FormatException('Invalid NodeLane identity configuration.');
    }
  }
  final String issuer;
  final String resource;
  final Uri authorization;
  final Uri token;
}

class _Tokens {
  _Tokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.refreshAt,
  });
  factory _Tokens.fromJson(
    Map<String, dynamic> json,
    DateTime issuedAt, {
    String? previousRefreshToken,
  }) {
    final access = json['access_token'];
    final refresh = json['refresh_token'] ?? previousRefreshToken;
    final seconds = json['expires_in'];
    if (access is! String ||
        access.isEmpty ||
        refresh is! String ||
        refresh.isEmpty ||
        (json['token_type'] as String?)?.toLowerCase() != 'bearer' ||
        seconds is! int ||
        seconds <= 0) {
      throw const FormatException('Incomplete renewable token response.');
    }
    final expiresAt = issuedAt.add(Duration(seconds: seconds));
    return _Tokens(
      accessToken: access,
      refreshToken: refresh,
      expiresAt: expiresAt,
      refreshAt: expiresAt.subtract(
        Duration(milliseconds: min(60000, seconds * 100)),
      ),
    );
  }
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final DateTime refreshAt;
}

class _Session {
  _Session({
    required this.id,
    required this.issuer,
    required this.subject,
    required this.tokenEndpoint,
    required this.resource,
    required this.tokens,
    required this.accountJson,
    required this.config,
  });
  factory _Session.fromJson(Map<String, dynamic> json, NodeLaneConfig config) {
    if (json['version'] != 1 ||
        json['service_origin'] != config.serviceOrigin ||
        json['client_id'] != config.clientId ||
        json['redirect_uri'] != config.redirectUri) {
      throw const FormatException('Incompatible session configuration.');
    }
    final session = _Session(
      id: json['id'] as String,
      issuer: json['issuer'] as String,
      subject: json['subject'] as String,
      tokenEndpoint: _identityUrl(json['token_endpoint'] as String),
      resource: json['resource'] as String,
      tokens: _Tokens(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        expiresAt: DateTime.parse(json['expires_at'] as String),
        refreshAt: DateTime.parse(json['refresh_at'] as String),
      ),
      accountJson: json['account'] as Map<String, dynamic>,
      config: config,
    );
    if (session.id.isEmpty ||
        session.subject.isEmpty ||
        session.resource.isEmpty ||
        session.tokens.refreshToken.isEmpty ||
        session.tokenEndpoint.origin != _identityUrl(session.issuer).origin ||
        _subject(
              session.tokens.accessToken,
              session.issuer,
              session.resource,
            ) !=
            session.subject ||
        !session.tokens.refreshAt.isBefore(session.tokens.expiresAt)) {
      throw const FormatException('Invalid stored session.');
    }
    session.account;
    return session;
  }
  final String id;
  final String issuer;
  final String subject;
  final Uri tokenEndpoint;
  final String resource;
  final _Tokens tokens;
  final Map<String, dynamic> accountJson;
  final NodeLaneConfig config;
  NodeLaneAccount get account => NodeLaneAccount(
    user: NodeLaneUser.fromJson(accountJson['user'] as Map<String, dynamic>),
    entitlements: NodeLaneEntitlements.fromJson(
      accountJson['entitlements'] as Map<String, dynamic>,
    ),
    serviceOrigin: config.serviceOrigin,
    issuer: issuer,
    subject: subject,
    sessionId: id,
  );
  _Session withTokens(_Tokens updated) => _Session(
    id: id,
    issuer: issuer,
    subject: subject,
    tokenEndpoint: tokenEndpoint,
    resource: resource,
    tokens: updated,
    accountJson: accountJson,
    config: config,
  );
  _Session withAccount(Map<String, dynamic> updated) => _Session(
    id: id,
    issuer: issuer,
    subject: subject,
    tokenEndpoint: tokenEndpoint,
    resource: resource,
    tokens: tokens,
    accountJson: updated,
    config: config,
  );
  Map<String, dynamic> toJson() => {
    'version': 1,
    'id': id,
    'service_origin': config.serviceOrigin,
    'client_id': config.clientId,
    'redirect_uri': config.redirectUri,
    'issuer': issuer,
    'subject': subject,
    'token_endpoint': tokenEndpoint.toString(),
    'resource': resource,
    'access_token': tokens.accessToken,
    'refresh_token': tokens.refreshToken,
    'expires_at': tokens.expiresAt.toIso8601String(),
    'refresh_at': tokens.refreshAt.toIso8601String(),
    'account': accountJson,
  };
}
