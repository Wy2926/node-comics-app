import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../contracts.dart';
import 'protocol.dart';

/// No source-client interceptors, cookie jar, logging or automatic retries.
class NodeLaneHttp {
  NodeLaneHttp(this.base, {this.token, bool allowLocalTestServer = false}) {
    final local = const {'127.0.0.1', '::1', 'localhost'}.contains(base.host);
    if ((base.scheme != 'https' &&
            !(allowLocalTestServer && local && base.scheme == 'http')) ||
        base.userInfo.isNotEmpty ||
        base.hasQuery ||
        base.hasFragment) {
      throw const TranslationFailure('CLIENT_UPGRADE_REQUIRED');
    }
  }
  final Uri base;
  final Future<String> Function()? token;
  final HttpClient _client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 30);

  Uri uri(String path) =>
      base.resolve('${base.path.replaceFirst(RegExp(r'/$'), '')}$path');

  Future<HttpClientRequest> _open(
    String method,
    String path,
    TranslationCancellation cancel,
  ) async {
    cancel.check();
    final authorization = token == null ? null : await token!();
    cancel.check();
    final request = await _client
        .openUrl(method, uri(path))
        .timeout(const Duration(seconds: 30));
    request.followRedirects = false;
    if (authorization != null) {
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer $authorization',
      );
    }
    if (path.startsWith('/v1/translations')) {
      request.headers.set(
        nodeLaneTranslationProtocolHeader,
        nodeLaneTranslationProtocol,
      );
    }
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    return request;
  }

  Future<Map<String, dynamic>> json(
    String method,
    String path, {
    Map<String, dynamic>? body,
    TranslationCancellation? cancellation,
    bool allowMissing = false,
  }) async {
    final cancel = cancellation ?? TranslationCancellation();
    final request = await _open(method, path, cancel);
    final deadline = Timer(
      const Duration(seconds: 30),
      () => request.abort(const TranslationFailure('NETWORK')),
    );
    final remove = cancel.onCancel(
      () => request.abort(const TranslationCancelled()),
    );
    try {
      if (body != null) {
        request.headers.contentType = ContentType.json;
        request.write(jsonEncode(body));
      }
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      if (allowMissing && response.statusCode == 404) {
        request.abort();
        return {'missing': true};
      }
      return await _jsonResponse(response, cancel);
    } finally {
      deadline.cancel();
      remove();
    }
  }

  Future<Map<String, dynamic>> upload(
    String id,
    File input,
    String mime,
    TranslationCancellation cancel,
  ) async {
    final request = await _open('PUT', '/v1/translations/$id/input', cancel);
    final remove = cancel.onCancel(
      () => request.abort(const TranslationCancelled()),
    );
    try {
      request.headers.set(HttpHeaders.contentTypeHeader, mime);
      request.contentLength = await input.length();
      await request.addStream(
        input.openRead().timeout(const Duration(seconds: 30)),
      );
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      return await _jsonResponse(response, cancel);
    } finally {
      remove();
    }
  }

  Future<void> download(
    String id,
    File output, {
    required int expectedSize,
    required String mime,
    required TranslationCancellation cancellation,
  }) async {
    final path = '/v1/translations/$id/result';
    var destination = uri(path), first = true;
    var authorized = true;
    String? authorization;
    final visited = <Uri>{};
    while (true) {
      cancellation.check();
      if (!visited.add(destination.removeFragment())) {
        throw const TranslationFailure('INVALID_RESULT');
      }
      final request = first
          ? await _open('GET', path, cancellation)
          : await _client
                .getUrl(destination)
                .timeout(const Duration(seconds: 30));
      final remove = cancellation.onCancel(
        () => request.abort(const TranslationCancelled()),
      );
      try {
        cancellation.check();
        request.followRedirects = false;
        if (first) {
          authorization = request.headers.value(
            HttpHeaders.authorizationHeader,
          );
        }
        if (!first && authorized) {
          if (authorization != null) {
            request.headers.set(HttpHeaders.authorizationHeader, authorization);
          }
          request.headers.set(
            nodeLaneTranslationProtocolHeader,
            nodeLaneTranslationProtocol,
          );
        }
        request.headers.set(HttpHeaders.acceptHeader, mime);
        final response = await request.close().timeout(
          const Duration(seconds: 30),
        );
        if (const {301, 302, 303, 307, 308}.contains(response.statusCode)) {
          final location = response.headers.value(HttpHeaders.locationHeader);
          final next = location == null ? null : destination.resolve(location);
          if (next == null ||
              !const {'https', 'http'}.contains(next.scheme) ||
              next.userInfo.isNotEmpty) {
            throw const TranslationFailure('INVALID_RESULT');
          }
          // Match fetch: credentials are stripped on crossing an origin, even
          // for another port or a later redirect back to the original host.
          authorized = authorized && next.origin == destination.origin;
          destination = next;
          first = false;
          continue;
        }
        if (response.statusCode != 200) {
          // Asset-host authorization failures do not invalidate the API login.
          if (authorized) await _jsonResponse(response, cancellation);
          throw const TranslationFailure('RESULT_UNAVAILABLE');
        }
        final contentType = response.headers.contentType?.mimeType;
        if ((contentType != null && contentType != mime) ||
            expectedSize < 1 ||
            (response.contentLength >= 0 &&
                response.contentLength != expectedSize)) {
          throw const TranslationFailure('INVALID_RESULT');
        }
        final sink = output.openWrite();
        var length = 0;
        try {
          await for (final chunk in response.timeout(
            const Duration(seconds: 30),
          )) {
            cancellation.check();
            length += chunk.length;
            if (length > expectedSize) {
              throw const TranslationFailure('INVALID_RESULT');
            }
            sink.add(chunk);
            await sink.flush();
          }
          if (length != expectedSize) {
            throw const TranslationFailure('INVALID_RESULT');
          }
          await sink.flush();
        } finally {
          await sink.close();
        }
        return;
      } finally {
        request.abort();
        remove();
      }
    }
  }

  Stream<Map<String, dynamic>> events(
    List<String> ids,
    TranslationCancellation cancel,
  ) async* {
    if (ids.isEmpty || ids.length > 32) return;
    final path =
        '/v1/translations/events?${Uri(queryParameters: {'ids': ids.join(',')}).query}';
    final request = await _open('GET', path, cancel);
    final remove = cancel.onCancel(
      () => request.abort(const TranslationCancelled()),
    );
    try {
      request.headers.set(HttpHeaders.acceptHeader, 'text/event-stream');
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      if (response.statusCode != 200 ||
          response.headers.contentType?.mimeType != 'text/event-stream') {
        await _jsonResponse(response, cancel);
        throw const TranslationFailure('CLIENT_UPGRADE_REQUIRED');
      }
      await for (final value in decodeTranslationEvents(
        response.timeout(const Duration(seconds: 45)).transform(utf8.decoder),
      )) {
        cancel.check();
        yield value;
      }
    } finally {
      request.abort();
      remove();
    }
  }

  Future<Map<String, dynamic>> _jsonResponse(
    HttpClientResponse response,
    TranslationCancellation cancel,
  ) async {
    final bytes = <int>[];
    await for (final part in response.timeout(const Duration(seconds: 30))) {
      cancel.check();
      if (bytes.length + part.length > 1024 * 1024) {
        throw const TranslationFailure('INVALID_RESULT');
      }
      bytes.addAll(part);
    }
    Map<String, dynamic>? value;
    try {
      value = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    } catch (_) {}
    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        value != null) {
      return value;
    }
    final retry = response.headers.value('retry-after') ?? '';
    var seconds = int.tryParse(retry);
    if (seconds == null && retry.isNotEmpty) {
      try {
        seconds = HttpDate.parse(retry).difference(DateTime.now()).inSeconds;
      } catch (_) {}
    }
    final error = value?['error'];
    final bodyRetry = error is Map ? error['retry_after_seconds'] : null;
    if (bodyRetry is num && bodyRetry.isFinite && bodyRetry > 0) {
      seconds = bodyRetry.ceil();
    }
    final code = error is Map ? error['code'] : null;
    final mapped = switch (response.statusCode) {
      401 || 403 => 'AUTH_REQUIRED',
      429 => 'RATE_LIMITED',
      410 when code == 'RESULT_EXPIRED' => 'RESULT_EXPIRED',
      410 => 'TRANSLATION_UNAVAILABLE',
      409 when code == 'CLIENT_UPGRADE_REQUIRED' => 'CLIENT_UPGRADE_REQUIRED',
      402 => 'QUOTA_EXHAUSTED',
      _ when code == 'DAILY_QUOTA_EXHAUSTED' => 'QUOTA_EXHAUSTED',
      _ when code == 'LANGUAGE_UNSUPPORTED' => 'UNSUPPORTED_LANGUAGE',
      _ when code == 'RESULT_UNAVAILABLE' => 'RESULT_UNAVAILABLE',
      _ when code == 'RESULT_FORMAT_UNAVAILABLE' => 'RESULT_FORMAT_UNAVAILABLE',
      _ when code == 'TRANSLATION_MODE_UNAVAILABLE' =>
        'TRANSLATION_MODE_UNAVAILABLE',
      _ when code is String && nodeLaneNonRetryableErrors.contains(code) =>
        code,
      _ => 'NETWORK',
    };
    throw TranslationFailure(
      mapped,
      retryAfter: seconds == null
          ? null
          : Duration(seconds: seconds.clamp(1, 86400)),
    );
  }

  void close() => _client.close(force: true);
}

/// Bounded SSE framing: data can span lines and network chunks, and comments
/// do not clear the pending event. Only blank lines dispatch complete events.
Stream<Map<String, dynamic>> decodeTranslationEvents(
  Stream<String> chunks,
) async* {
  var pending = '', event = '', data = '';
  await for (final chunk in chunks) {
    pending += chunk;
    if (pending.length + data.length > 1024 * 1024) {
      throw const TranslationFailure('INVALID_RESULT');
    }
    while (pending.contains('\n')) {
      final at = pending.indexOf('\n');
      final line = pending.substring(0, at).replaceFirst(RegExp(r'\r$'), '');
      pending = pending.substring(at + 1);
      if (line.isEmpty) {
        if (event == 'end') return;
        if (event == 'snapshot' && data.isNotEmpty) {
          final value = jsonDecode(data);
          if (value is! Map<String, dynamic>) {
            throw const TranslationFailure('INVALID_RESULT');
          }
          yield value;
        }
        data = '';
        event = '';
      } else if (!line.startsWith(':')) {
        final colon = line.indexOf(':');
        final field = colon < 0 ? line : line.substring(0, colon);
        var value = colon < 0 ? '' : line.substring(colon + 1);
        if (value.startsWith(' ')) value = value.substring(1);
        if (field == 'event') event = value;
        if (field == 'data') data += '$value\n';
      }
    }
  }
}
