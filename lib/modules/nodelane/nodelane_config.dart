import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Public native application settings. The browser client returned by the API
/// is deliberately never used as the native client ID.
class NodeLaneConfig {
  NodeLaneConfig({
    required String serviceOrigin,
    required this.clientId,
    this.redirectUri = 'net.nodelane.comics://oauth/callback',
  }) : serviceOrigin = _origin(serviceOrigin);

  factory NodeLaneConfig.fromEnvironment() => NodeLaneConfig(
    serviceOrigin: const String.fromEnvironment(
      'NODELANE_SERVICE_ORIGIN',
      defaultValue: 'https://comics.nodelane.net',
    ),
    clientId: const String.fromEnvironment(
      'NODELANE_CLIENT_ID',
      defaultValue: 'pljp89y5gk6k5x2h9gp6q',
    ),
    redirectUri: const String.fromEnvironment(
      'NODELANE_REDIRECT_URI',
      defaultValue: 'net.nodelane.comics://oauth/callback',
    ),
  );

  final String serviceOrigin;
  final String clientId;
  final String redirectUri;

  bool get canSignIn => clientId.trim().isNotEmpty;

  String get storageKey =>
      'nodelane.session.v1.${sha256.convert(utf8.encode('$serviceOrigin\n$clientId\n$redirectUri'))}';

  Uri endpoint(String path) {
    final relative = Uri.parse(path);
    if (!path.startsWith('/v1/') ||
        relative.hasScheme ||
        relative.hasAuthority ||
        relative.hasFragment) {
      throw ArgumentError('NodeLane requests require a /v1/ relative path.');
    }
    return Uri.parse(serviceOrigin).resolveUri(relative);
  }

  Uri get callback {
    final uri = Uri.parse(redirectUri);
    if (!RegExp(r'^[a-z][a-z0-9+.-]*$').hasMatch(uri.scheme) ||
        ['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw const FormatException('Invalid native callback configuration.');
    }
    return uri;
  }

  static String _origin(String value) {
    final uri = Uri.parse(value);
    if (uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment ||
        (uri.path.isNotEmpty && uri.path != '/')) {
      throw const FormatException('NodeLane requires an HTTPS service origin.');
    }
    return uri.origin;
  }
}
