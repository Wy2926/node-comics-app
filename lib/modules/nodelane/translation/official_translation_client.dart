import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import '../nodelane_auth_service.dart';
import '../nodelane_models.dart';
import 'translation_types.dart';

class OfficialTranslationClient {
  OfficialTranslationClient(this.auth);
  final NodeLaneAuthService auth;
  Future<Map<String, dynamic>> json(
    String method,
    String path, {
    String? body,
    Future<void>? abort,
  }) async {
    final bytes = body == null ? null : utf8.encode(body);
    final response = await auth.requestStream(
      method,
      path,
      headers: {'Content-Type': 'application/json'},
      body: bytes == null ? null : () => Stream.value(bytes),
      contentLength: bytes?.length,
      abort: abort,
    );
    return _readJson(response.stream);
  }

  static Future<Map<String, dynamic>> _readJson(
    Stream<List<int>> stream,
  ) async {
    final data = <int>[];
    await for (final chunk in stream) {
      if (data.length + chunk.length > 2 * 1024 * 1024) {
        throw const FormatException('Response too large');
      }
      data.addAll(chunk);
    }
    return jsonDecode(utf8.decode(data)) as Map<String, dynamic>;
  }

  Future<TranslationCapabilities> capabilities() async =>
      TranslationCapabilities(await json('GET', '/v1/capabilities'));
  Future<Map<String, dynamic>?> lookup(
    String uuid, {
    Future<void>? abort,
  }) async {
    try {
      return await json('GET', '/v1/translations/$uuid', abort: abort);
    } on NodeLaneException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> create(
    String uuid,
    String descriptor, {
    Future<void>? abort,
  }) => json('PUT', '/v1/translations/$uuid', body: descriptor, abort: abort);
  Future<Map<String, dynamic>> upload(
    String uuid,
    File input,
    String mime,
    int length, {
    Future<void>? abort,
  }) async {
    final response = await auth.requestStream(
      'PUT',
      '/v1/translations/$uuid/input',
      headers: {'Content-Type': mime},
      body: input.openRead,
      contentLength: length,
      abort: abort,
    );
    return _readJson(response.stream);
  }

  Stream<Map<String, dynamic>> events(
    List<String> ids,
    Future<void> abort,
  ) async* {
    if (ids.isEmpty || ids.length > 32) {
      throw ArgumentError('Invalid subscription');
    }
    final response = await auth.requestStream(
      'GET',
      '/v1/translations/events?ids=${ids.join(',')}',
      headers: {'Accept': 'text/event-stream'},
      abort: abort,
    );
    if (!(response.headers['content-type'] ?? '').startsWith(
      'text/event-stream',
    )) {
      await response.stream.listen(null).cancel();
      throw const FormatException('Invalid SSE type');
    }
    yield* parseEvents(response.stream);
  }

  static Stream<Map<String, dynamic>> parseEvents(
    Stream<List<int>> bytes,
  ) async* {
    var event = '';
    final data = StringBuffer();
    var size = 0;
    var lineBytes = 0;
    final bounded = bytes.map((chunk) {
      for (final b in chunk) {
        if (b == 10 || b == 13) {
          lineBytes = 0;
        } else if (++lineBytes > 2 * 1024 * 1024) {
          throw const FormatException('SSE line too large');
        }
      }
      return chunk;
    });
    await for (final line
        in bounded.transform(utf8.decoder).transform(const LineSplitter())) {
      size += line.length;
      if (size > 2 * 1024 * 1024) {
        throw const FormatException('SSE frame too large');
      }
      if (line.isEmpty) {
        if (event == 'snapshot' && data.isNotEmpty) {
          yield jsonDecode(data.toString()) as Map<String, dynamic>;
        }
        if (event == 'end') return;
        event = '';
        data.clear();
        size = 0;
      } else if (line.startsWith('event:')) {
        event = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        data.writeln(line.substring(5).trimLeft());
      }
    }
  }

  Future<void> download(
    String uuid,
    Map<String, dynamic> artifact,
    File target,
    Future<void> abort,
  ) async {
    final path = artifact['path'];
    final length = artifact['byte_size'];
    if (path != '/v1/translations/$uuid/result' ||
        length is! int ||
        length <= 0 ||
        length > 512 * 1024 * 1024 ||
        !RegExp(r'^[a-f0-9]{64}$')
            .hasMatch(artifact['sha256'] as String? ?? '')) {
      throw const FormatException('Invalid artifact');
    }
    final response = await auth.requestStream(
      'GET',
      path as String,
      headers: {'Accept': artifact['mime'] as String},
      abort: abort,
    );
    if (response.headers['content-type']?.split(';').first !=
            artifact['mime'] ||
        response.contentLength != null && response.contentLength != length) {
      await response.stream.listen(null).cancel();
      throw const FormatException('Artifact mismatch');
    }
    final output = target.openWrite();
    var count = 0;
    try {
      await for (final bytes in response.stream) {
        count += bytes.length;
        if (count > length) throw const FormatException('Artifact too long');
        output.add(bytes);
        await output.flush();
      }
      await output.flush();
    } finally {
      await output.close();
    }
    if (count != length ||
        (await sha256.bind(target.openRead()).first).toString() !=
            artifact['sha256']) {
      throw const FormatException('Artifact digest mismatch');
    }
  }

  Future<Map<String, dynamic>> cancel(String uuid, {Future<void>? abort}) =>
      json('POST', '/v1/translations/$uuid/cancel', abort: abort);
}
