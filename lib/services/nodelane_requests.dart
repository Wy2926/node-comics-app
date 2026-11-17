import 'dart:ffi';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mangayomi/utils/nodelane_brand.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Shared construction for app-owned services; credentials stay with callers.
abstract final class NodeLaneRequests {
  static Uri uri(Uri base, String path) =>
      base.resolve('${base.path.replaceFirst(RegExp(r'/$'), '')}$path');

  static Future<String> get userAgent async {
    var version = 'unknown';
    try {
      final info = await PackageInfo.fromPlatform();
      final installed =
          '${info.version}${info.buildNumber.isEmpty ? '' : '+${info.buildNumber}'}';
      if (info.version.isNotEmpty &&
          RegExp(r'^[0-9A-Za-z.+_-]+$').hasMatch(installed)) {
        version = installed;
      }
    } catch (_) {
      // Missing package metadata must not block feedback or account recovery.
    }
    final architecture = Abi.current().toString().split('_').last;
    return '${NodeLaneBrand.userAgent}/$version '
        '(${Platform.operatingSystem}; $architecture)';
  }

  static Future<Map<String, String>> _headers() async => {
    HttpHeaders.userAgentHeader: await userAgent,
    HttpHeaders.acceptHeader: 'application/json',
  };

  static Future<HttpClientRequest> open(
    HttpClient client,
    String method,
    Uri uri,
  ) async {
    final headers = await _headers();
    final request = await client.openUrl(method, uri);
    request.followRedirects = false;
    headers.forEach((name, value) => request.headers.set(name, value));
    return request;
  }

  static Future<http.AbortableRequest> request(
    String method,
    Uri uri, {
    required Future<void> abortTrigger,
    bool followRedirects = false,
  }) async {
    final headers = await _headers();
    return http.AbortableRequest(method, uri, abortTrigger: abortTrigger)
      ..followRedirects = followRedirects
      ..headers.addAll(headers);
  }
}
