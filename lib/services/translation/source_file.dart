import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'contracts.dart';
import 'identity.dart';

/// Source transport has no translation credentials or service dependencies.
/// Headers are resolved for each redirect destination, never forwarded blindly.
class HttpSourceImageReader implements SourceImageReader {
  HttpSourceImageReader(
    this.url, {
    required this.headers,
    this.publicOnly = false,
  });
  final Uri url;
  final Future<Map<String, String>> Function(Uri) headers;
  final bool publicOnly;
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
      var current = url;
      for (var redirects = 0; redirects <= 5; redirects++) {
        cancellation.check();
        if (!{'https', 'http'}.contains(current.scheme) ||
            current.userInfo.isNotEmpty ||
            current.host.isEmpty) {
          throw const TranslationFailure('SOURCE_MISSING');
        }
        // Pin DNS for page-provided URLs; a later DNS rebind cannot reach a
        // private device endpoint after the initial public-address check.
        if (publicOnly) {
          final addresses = await InternetAddress.lookup(current.host)
              .timeout(const Duration(seconds: 15));
          if (addresses.isEmpty ||
              addresses.any((address) => !isPublicImageAddress(address))) {
            throw const TranslationFailure('SOURCE_MISSING');
          }
          final host = current.host, port = current.port;
          client.connectionFactory = (uri, proxyHost, proxyPort) {
            if (uri.host != host || uri.port != port || proxyHost != null) {
              throw const TranslationFailure('SOURCE_MISSING');
            }
            return Socket.startConnect(addresses.first, port);
          };
          client.findProxy = (_) => 'DIRECT';
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
          final next = current.resolve(location);
          if (current.scheme == 'https' && next.scheme != 'https') {
            throw const TranslationFailure('SOURCE_MISSING');
          }
          current = next;
          continue;
        }
        if (response.statusCode != 200 ||
            response.contentLength > 32 * 1024 * 1024) {
          throw const TranslationFailure('SOURCE_MISSING');
        }
        final sink = file.openWrite();
        var length = 0;
        try {
          await for (final chunk in response.timeout(
            const Duration(seconds: 30),
          )) {
            cancellation.check();
            length += chunk.length;
            if (length > 32 * 1024 * 1024) {
              throw const TranslationFailure('RESOURCE_LIMIT');
            }
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
      throw const TranslationFailure('SOURCE_MISSING');
    } catch (_) {
      if (await file.exists()) await file.delete();
      rethrow;
    } finally {
      remove();
      client.close(force: true);
    }
  }
}

bool isPublicImageAddress(InternetAddress address) {
  final bytes = address.rawAddress;
  if (bytes.length == 4) {
    return !(bytes[0] == 0 ||
        bytes[0] == 10 ||
        bytes[0] == 127 ||
        bytes[0] >= 224 ||
        (bytes[0] == 169 && bytes[1] == 254) ||
        (bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31) ||
        (bytes[0] == 192 && (bytes[1] == 168 || bytes[1] == 0)) ||
        (bytes[0] == 100 && bytes[1] >= 64 && bytes[1] <= 127) ||
        (bytes[0] == 198 && (bytes[1] == 18 || bytes[1] == 19)));
  }
  // Global unicast only; rejects loopback, mapped IPv4, ULA, link-local and multicast.
  return bytes.length == 16 &&
      (bytes[0] & 0xe0) == 0x20 &&
      !(bytes[0] == 0x20 &&
          bytes[1] == 0x01 &&
          bytes[2] == 0x0d &&
          bytes[3] == 0xb8);
}
