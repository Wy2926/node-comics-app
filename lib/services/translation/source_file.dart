import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'contracts.dart';
import 'identity.dart';

/// Source transport has no translation credentials or service dependencies.
/// Headers are resolved for each redirect destination, never forwarded blindly.
class HttpSourceImageReader implements SourceImageReader {
  HttpSourceImageReader(this.url, {required this.headers});
  final Uri url;
  final Future<Map<String, String>> Function(Uri) headers;
  @override
  Future<OriginalImageLease> acquire(
    TranslationPage page,
    TranslationCancellation cancellation,
  ) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 20);
    final remove = cancellation.onCancel(() => client.close(force: true));
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/nodelane-source-${translationUuid()}');
    try {
      var current = url.removeFragment();
      final visited = <Uri>{};
      while (true) {
        cancellation.check();
        if (!{'https', 'http'}.contains(current.scheme) ||
            current.userInfo.isNotEmpty ||
            current.host.isEmpty ||
            !visited.add(current)) {
          throw const TranslationFailure('SOURCE_MISSING');
        }
        final request = await client
            .getUrl(current)
            .timeout(const Duration(seconds: 20));
        request.followRedirects = false;
        for (final entry in (await headers(current)).entries) {
          if (!{
            'host',
            'content-length',
            'connection',
          }.contains(entry.key.toLowerCase())) {
            request.headers.set(entry.key, entry.value);
          }
        }
        final response = await request.close().timeout(
          const Duration(seconds: 30),
        );
        if ({301, 302, 303, 307, 308}.contains(response.statusCode)) {
          final location = response.headers.value(HttpHeaders.locationHeader);
          request.abort();
          if (location == null) {
            throw const TranslationFailure('SOURCE_MISSING');
          }
          current = current.resolve(location).removeFragment();
          continue;
        }
        if (response.statusCode != 200) {
          throw const TranslationFailure('SOURCE_MISSING');
        }
        final sink = file.openWrite();
        try {
          await for (final chunk in response.timeout(
            const Duration(seconds: 30),
          )) {
            cancellation.check();
            sink.add(chunk);
            await sink.flush();
          }
        } finally {
          await sink.close();
        }
        cancellation.check();
        return OriginalImageLease(
          file,
          release: () {
            file.delete().catchError((_) => file);
          },
        );
      }
    } catch (_) {
      if (await file.exists()) await file.delete();
      rethrow;
    } finally {
      remove();
      client.close(force: true);
    }
  }
}
