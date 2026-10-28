import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:mangayomi/services/nodelane_private_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import '../../contracts.dart';
import 'http.dart';

/// Credentials stay in the native vault. Browser pages only see display data.
class NodeLaneSession {
  NodeLaneSession(this.base);
  final Uri base;
  static const _vault = nodeLanePrivateVault;
  static const _key = 'nodelane.official.session.v1';
  static const redirect = String.fromEnvironment(
    'NODELANE_AUTH_REDIRECT',
    defaultValue: 'mangayomi://nodelane-auth',
  );
  Map<String, dynamic>? _value;
  Future<String>? _refresh;
  int _epoch = 0;
  String? get userId => _value?['userId'] as String?;
  String get name => _value?['name'] as String? ?? '';

  Future<void> restore() async {
    final stored = await _vault.read(key: _key);
    if (stored == null) return;
    try {
      final value = jsonDecode(stored) as Map<String, dynamic>;
      if (value['base'] == base.toString() &&
          value['userId'] is String &&
          value['accessToken'] is String &&
          value['refreshToken'] is String &&
          value['expires'] is int) {
        _https(value['endpoint'] as String);
        _value = value;
      }
    } catch (_) {
      throw const TranslationFailure('AUTH_REQUIRED');
    }
  }

  String _random(int count) =>
      base64UrlEncode(List.generate(count, (_) => Random.secure().nextInt(256)))
          .replaceAll('=', '');
  Uri _https(String value) {
    final uri = Uri.parse(value);
    if (uri.scheme != 'https' || uri.userInfo.isNotEmpty || uri.hasFragment) {
      throw const TranslationFailure('AUTH_REQUIRED');
    }
    return uri;
  }

  Future<void> login() async {
    final epoch = ++_epoch;
    final api = NodeLaneHttp(base);
    late Map<String, dynamic> config;
    try {
      config = await api.json('GET', '/v1/auth/config');
    } finally {
      api.close();
    }
    if (config['mode'] != 'oidc' || config['client_id'] is! String) {
      throw const TranslationFailure('AUTH_REQUIRED');
    }
    final authorization = _https(config['authorization_endpoint'] as String);
    final endpoint = _https(config['token_endpoint'] as String);
    final verifier = _random(48), state = _random(24);
    final callbackUri = Uri.parse(redirect);
    final started = DateTime.now();
    final resource = config['audience'] as String? ?? '';
    final query = <String, String>{
      'client_id': config['client_id'] as String,
      'response_type': 'code',
      'redirect_uri': redirect,
      'scope': 'openid profile offline_access',
      'prompt': 'login consent',
      'state': state,
      'code_challenge_method': 'S256',
      'code_challenge': base64UrlEncode(
        sha256.convert(utf8.encode(verifier)).bytes,
      ).replaceAll('=', ''),
      if (resource.isNotEmpty) 'resource': resource,
      if (resource.isNotEmpty) 'audience': resource,
    };
    final returned = Uri.parse(
      await FlutterWebAuth2.authenticate(
        url: authorization.replace(queryParameters: query).toString(),
        callbackUrlScheme: callbackUri.scheme,
      ),
    );
    final params = returned.queryParametersAll;
    if (returned.scheme != callbackUri.scheme ||
        returned.host != callbackUri.host ||
        returned.path != callbackUri.path ||
        returned.userInfo.isNotEmpty ||
        returned.hasFragment ||
        params['state']?.length != 1 ||
        params['state']?.single != state ||
        params['code']?.length != 1 ||
        params.containsKey('error') ||
        (params.containsKey('iss') &&
            (params['iss']?.length != 1 ||
                params['iss']?.single != config['issuer'])) ||
        DateTime.now().difference(started) > const Duration(minutes: 10) ||
        epoch != _epoch) {
      throw const TranslationFailure('AUTH_REQUIRED');
    }
    final tokens = await _exchange(endpoint, {
      'grant_type': 'authorization_code',
      'client_id': config['client_id'] as String,
      'code': params['code']!.single,
      'redirect_uri': redirect,
      'code_verifier': verifier,
      if (resource.isNotEmpty) 'resource': resource,
    });
    final session = <String, dynamic>{
      'base': base.toString(),
      'endpoint': endpoint.toString(),
      'clientId': config['client_id'],
      'resource': resource,
      ..._tokens(tokens),
    };
    final authenticated = NodeLaneHttp(
      base,
      token: () async => session['accessToken'] as String,
    );
    try {
      final me = await authenticated.json('GET', '/v1/me');
      final user = me['user'];
      if (user is! Map || user['id'] is! String) {
        throw const TranslationFailure('AUTH_REQUIRED');
      }
      session['userId'] = user['id'];
      session['name'] = user['name'] ?? '';
    } finally {
      authenticated.close();
    }
    if (epoch != _epoch) throw const TranslationCancelled();
    await _vault.write(key: _key, value: jsonEncode(session));
    if (epoch != _epoch) {
      await _vault.delete(key: _key);
      throw const TranslationCancelled();
    }
    _value = session;
  }

  Map<String, dynamic> _tokens(
    Map<String, dynamic> value, {
    String? previousRefresh,
  }) {
    final seconds = value['expires_in'];
    if (value['access_token'] is! String ||
        (value['access_token'] as String).isEmpty ||
        '${value['token_type']}'.toLowerCase() != 'bearer' ||
        seconds is! num ||
        seconds <= 0 ||
        seconds > 31536000 ||
        (value['refresh_token'] ?? previousRefresh) is! String) {
      throw const TranslationFailure('AUTH_REQUIRED');
    }
    return {
      'accessToken': value['access_token'],
      'refreshToken': value['refresh_token'] ?? previousRefresh,
      'expires': DateTime.now()
          .add(Duration(seconds: seconds.toInt()))
          .millisecondsSinceEpoch,
    };
  }

  Future<String> accessToken() async {
    final value = _value;
    if (value == null) throw const TranslationFailure('AUTH_REQUIRED');
    if (DateTime.now().millisecondsSinceEpoch + 60000 <
        (value['expires'] as int)) {
      return value['accessToken'] as String;
    }
    return _refresh ??= _renew().whenComplete(() => _refresh = null);
  }

  Future<String> _renew() async {
    final epoch = _epoch, value = _value!;
    final tokens = await _exchange(_https(value['endpoint'] as String), {
      'grant_type': 'refresh_token',
      'client_id': value['clientId'] as String,
      'refresh_token': value['refreshToken'] as String,
      if ((value['resource'] as String).isNotEmpty)
        'resource': value['resource'] as String,
    });
    if (epoch != _epoch) throw const TranslationCancelled();
    final next = {
      ...value,
      ..._tokens(tokens, previousRefresh: value['refreshToken'] as String),
    };
    await _vault.write(key: _key, value: jsonEncode(next));
    if (epoch != _epoch) {
      await _vault.delete(key: _key);
      throw const TranslationCancelled();
    }
    _value = next;
    return next['accessToken'] as String;
  }

  Future<Map<String, dynamic>> _exchange(
    Uri uri,
    Map<String, String> body,
  ) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      return await (() async {
        final request = await client.postUrl(uri);
        request.followRedirects = false;
        request.headers.contentType = ContentType(
          'application',
          'x-www-form-urlencoded',
        );
        request.write(Uri(queryParameters: body).query);
        final response = await request.close();
        final bytes = <int>[];
        await for (final chunk in response) {
          if (bytes.length + chunk.length > 65536) {
            throw const TranslationFailure('AUTH_REQUIRED');
          }
          bytes.addAll(chunk);
        }
        if (response.statusCode != 200) {
          throw const TranslationFailure('AUTH_REQUIRED');
        }
        return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      })().timeout(const Duration(seconds: 20));
    } on TranslationFailure {
      rethrow;
    } catch (_) {
      throw const TranslationFailure('NETWORK');
    } finally {
      client.close(force: true);
    }
  }

  Future<void> logout() async {
    _epoch++;
    _value = null;
    await _vault.delete(key: _key);
  }
}
