import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mangayomi/utils/constant.dart';

import 'subtitle_service.dart';

/// Dedicated transport: normal certificate validation, no source cookies,
/// request logging or retries. Closing the search sheet cancels its requests.
class SubtitleHttp {
  SubtitleHttp({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  final _pending = <Completer<void>>{};
  bool _closed = false;

  Future<http.Response> get(
    Uri uri, {
    Map<String, String> headers = const {},
    int maxBytes = 2 * 1024 * 1024,
  }) async {
    if (_closed) throw const SubtitleFailure(SubtitleFailureCode.network);
    if (!isSubtitleHttpsUrl(uri)) {
      throw const SubtitleFailure(SubtitleFailureCode.configuration);
    }
    final abort = Completer<void>();
    _pending.add(abort);
    void cancel() {
      if (!abort.isCompleted) abort.complete();
    }

    final deadline = Timer(const Duration(seconds: 30), cancel);
    try {
      final request =
          http.AbortableRequest('GET', uri, abortTrigger: abort.future)
            ..followRedirects = false
            ..headers.addAll({
              'Accept': '*/*',
              'User-Agent': metadataApiUserAgent,
              ...headers,
            });
      final response = await _client.send(request);
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in response.stream) {
        if (_closed || bytes.length + chunk.length > maxBytes) {
          throw const SubtitleFailure(SubtitleFailureCode.response);
        }
        bytes.add(chunk);
      }
      if (_closed || abort.isCompleted) {
        throw const SubtitleFailure(SubtitleFailureCode.network);
      }
      return http.Response.bytes(
        bytes.takeBytes(),
        response.statusCode,
        headers: response.headers,
      );
    } on SubtitleFailure {
      rethrow;
    } catch (_) {
      throw const SubtitleFailure(SubtitleFailureCode.network);
    } finally {
      deadline.cancel();
      cancel();
      _pending.remove(abort);
    }
  }

  void close() {
    _closed = true;
    for (final abort in _pending) {
      if (!abort.isCompleted) abort.complete();
    }
    _client.close();
  }
}

bool isSubtitleHttpsUrl(Uri uri) =>
    uri.scheme == 'https' &&
    uri.host.isNotEmpty &&
    uri.userInfo.isEmpty &&
    !uri.hasFragment;

void checkSubtitleResponse(int status) {
  if (status == 200) return;
  throw SubtitleFailure(switch (status) {
    401 || 403 => SubtitleFailureCode.authentication,
    402 || 429 => SubtitleFailureCode.quota,
    >= 500 => SubtitleFailureCode.network,
    _ => SubtitleFailureCode.response,
  });
}
