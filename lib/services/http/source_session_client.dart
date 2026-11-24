import 'dart:async';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/browser_host.dart';
import 'package:mangayomi/services/source_catalog_config.dart';
import 'package:mangayomi/services/source_package.dart';

// Scope comes from the installed source, never a header or a URL returned by JS.
Set<String> sourceSessionOrigins(Source? source) {
  if (source == null ||
      source.isAdded != true ||
      (source.sourceCodeLanguage != SourceCodeLanguage.javascript &&
          source.sourceCodeLanguage != SourceCodeLanguage.lnreader)) {
    return const {};
  }
  final package = SourcePackage.of(source);
  if (package != null && source.repo?.jsonUrl == nodeLaneCatalogUrl) {
    return {for (final h in package.requestHosts) 'https://$h'};
  }
  return {
    if (Uri.tryParse(source.baseUrl ?? '') case final uri?
        when uri.host.isNotEmpty &&
            uri.userInfo.isEmpty &&
            uri.scheme == 'https')
      uri.origin,
  };
}

bool sourceSessionMatches(
  Set<String> origins,
  Uri url, [
  Map<String, String> headers = const {},
]) =>
    origins.isNotEmpty &&
    url.userInfo.isEmpty &&
    url.host.isNotEmpty &&
    (url.scheme == 'https' || url.scheme == 'http') &&
    origins.contains(url.origin) &&
    !headers.keys.any(
      (key) => const {'cookie', 'authorization'}.contains(key.toLowerCase()),
    );

// A redirect is a new request. Never forward a site's explicit credentials or a signed referrer.
void stripCrossOriginHeaders(Map<String, String> headers) {
  headers.removeWhere(
    (key, _) => !const {
      'accept',
      'accept-language',
      'user-agent',
      'referer',
    }.contains(key.toLowerCase()),
  );
  for (final key
      in headers.keys.where((k) => k.toLowerCase() == 'referer').toList()) {
    final uri = Uri.tryParse(headers[key]!);
    if (uri != null &&
        uri.scheme == 'https' &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty) {
      headers[key] = '${uri.origin}/';
    } else {
      headers.remove(key);
    }
  }
}

class SourceSessionClient extends http.BaseClient {
  SourceSessionClient(
    this.origins,
    this.fallback, {
    this.followRedirects,
    this.maxRedirects,
  });
  final Set<String> origins;
  final http.Client fallback;
  final bool? followRedirects;
  final int? maxRedirects;
  static final _channel = MethodChannel('${browserHost.name}/source-http');
  static Future<String?> cacheScope(Set<String> origins) async {
    if (origins.isEmpty || !await hasBrowserHost) return null;
    return (await browserHost.invokeMethod<String>('sourceCacheScope', [
      for (final origin in origins) Uri.parse(origin).host,
    ]))!;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!sourceSessionMatches(origins, request.url, request.headers) ||
        !await hasBrowserHost) {
      return fallback.send(request);
    }
    final headers = Map.of(request.headers);
    var body = await request.finalize().toBytes();
    var method = request.method, uri = request.url;
    for (var hop = 0; ; hop++) {
      final reply = (await _channel.invokeMapMethod<String, dynamic>('open', {
        'url': uri.toString(),
        'method': method,
        'headers': headers,
        'body': body,
        'anonymous': !sourceSessionMatches(origins, uri),
      }))!;
      final id = reply['id'] as int, status = reply['status'] as int;
      final responseHeaders = Map<String, String>.from(reply['headers'] as Map);
      final location = responseHeaders['location'];
      final redirect =
          location != null && [301, 302, 303, 307, 308].contains(status);
      if (!redirect ||
          !(followRedirects ?? request.followRedirects) ||
          !(method == 'GET' ||
              method == 'HEAD' ||
              method == 'POST' && status == 303)) {
        return http.StreamedResponse(
          _read(id),
          status,
          request: request,
          headers: responseHeaders,
          contentLength: responseHeaders.containsKey('content-encoding')
              ? null
              : int.tryParse(responseHeaders['content-length'] ?? ''),
          isRedirect: redirect,
        );
      }
      await _channel.invokeMethod<void>('close', id);
      if (hop >= (maxRedirects ?? request.maxRedirects)) {
        throw http.ClientException('Too many source redirects');
      }
      final next = uri.resolve(location);
      if (next.host.isEmpty ||
          next.userInfo.isNotEmpty ||
          !['http', 'https'].contains(next.scheme)) {
        throw http.ClientException('Invalid source redirect');
      }
      if (method == 'POST') {
        method = 'GET';
        body = Uint8List(0);
        headers.removeWhere((k, _) => k.toLowerCase().startsWith('content-'));
      }
      if (uri.origin != next.origin) stripCrossOriginHeaders(headers);
      uri = next;
    }
  }

  static Stream<List<int>> _read(int id) {
    late final StreamController<List<int>> stream;
    var pumping = false, done = false;
    Future<void> close() async {
      if (done) return;
      done = true;
      await _channel.invokeMethod<void>('close', id);
    }

    Future<void> pump() async {
      if (pumping || done) return;
      pumping = true;
      try {
        while (!done && !stream.isPaused) {
          final chunk = await _channel.invokeMethod<Uint8List>('read', id);
          if (done) break;
          if (chunk == null) {
            done = true;
            unawaited(stream.close());
            break;
          }
          stream.add(chunk);
        }
      } catch (e, st) {
        if (!done) {
          stream.addError(e, st);
          try {
            await close();
          } finally {
            unawaited(stream.close());
          }
        }
      } finally {
        pumping = false;
      }
    }

    stream = StreamController(
      sync: true,
      onListen: pump,
      onResume: pump,
      onCancel: close,
    );
    return stream.stream;
  }
}
