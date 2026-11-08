import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mangayomi/services/app_update_manifest.dart';

/// Public static feed, with a URL-scoped cache and one in-flight refresh.
class AppUpdateFeed {
  AppUpdateFeed({
    required this.uri,
    required this.cacheFile,
    http.Client? client,
    DateTime Function()? now,
  }) : _client = client ?? http.Client(),
       _now = now ?? DateTime.now;

  final Uri uri;
  final Future<File> Function() cacheFile;
  final http.Client _client;
  final DateTime Function() _now;
  Future<List<UpdateInfo>>? _pending;
  static const interval = Duration(hours: 6);

  Future<List<UpdateInfo>> load({bool force = false}) async {
    if (_pending != null) return _pending!;
    final cached = await _readCache();
    if (!force && cached != null) {
      final age = _now().difference(cached.checkedAt);
      if (!age.isNegative && age < interval) {
        return parseAppUpdateManifest(cached.body);
      }
    }
    return _pending ??= _refresh(cached).whenComplete(() => _pending = null);
  }

  Future<List<UpdateInfo>> _refresh(_FeedCache? cached) async {
    final abort = Completer<void>();
    final request = http.AbortableRequest(
      'GET',
      uri,
      abortTrigger: abort.future,
    );
    request.headers.addAll({
      'Accept': 'application/json',
      if (cached?.etag != null) 'If-None-Match': cached!.etag!,
    });
    final http.Response response;
    try {
      response = await (() async => http.Response.fromStream(
        await _client.send(request),
      ))().timeout(const Duration(seconds: 20));
    } finally {
      abort.complete();
    }
    if (response.statusCode != 200 &&
        !(response.statusCode == 304 && cached != null)) {
      throw http.ClientException(
        'Update manifest request failed (${response.statusCode})',
      );
    }
    final body = response.statusCode == 304
        ? cached!.body
        : utf8.decode(response.bodyBytes);
    final updates = parseAppUpdateManifest(body);
    final next = _FeedCache(
      body,
      response.headers['etag'] ??
          (response.statusCode == 304 ? cached?.etag : null),
      _now(),
    );
    try {
      final file = await cacheFile();
      await file.parent.create(recursive: true);
      final temp = File('${file.path}.tmp');
      try {
        await temp.writeAsString(
          jsonEncode({
            'url': uri.toString(),
            'body': next.body,
            'etag': next.etag,
            'checked_at': next.checkedAt.toUtc().toIso8601String(),
          }),
          flush: true,
        );
        await temp.rename(file.path);
      } finally {
        if (await temp.exists()) await temp.delete();
      }
    } on FileSystemException {
      // A missing cache must not turn a successful network check into failure.
    }
    return updates;
  }

  Future<_FeedCache?> _readCache() async {
    try {
      final root = jsonDecode(await (await cacheFile()).readAsString());
      if (root is! Map<String, dynamic> ||
          root['url'] != uri.toString() ||
          root['body'] is! String ||
          root['checked_at'] is! String ||
          (root['etag'] != null && root['etag'] is! String)) {
        return null;
      }
      final checkedAt = DateTime.tryParse(root['checked_at'] as String);
      if (checkedAt == null) return null;
      parseAppUpdateManifest(root['body'] as String);
      return _FeedCache(
        root['body'] as String,
        root['etag'] as String?,
        checkedAt,
      );
    } on FileSystemException {
      return null;
    } on FormatException {
      return null;
    }
  }

  void close() => _client.close();
}

class _FeedCache {
  const _FeedCache(this.body, this.etag, this.checkedAt);
  final String body;
  final String? etag;
  final DateTime checkedAt;
}
