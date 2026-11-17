import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mangayomi/modules/webview/browser_url.dart';
import 'package:mangayomi/services/nodelane_private_storage.dart';
import 'package:mangayomi/services/nodelane_requests.dart';
import 'package:mangayomi/services/translation/identity.dart';
import 'package:mangayomi/utils/nodelane_brand.dart';

enum SupportRequestKind { app, website }

const supportAppCommentPrefix = '[NodeLane App]\n';

/// Only the public homepage is suggested, never a page title or signed URL.
String? supportWebsiteUrl(String value) {
  if (value.contains(r'\')) return null;
  final normalized = normalizeBrowserAddress(value);
  if (normalized == null) return null;
  final uri = Uri.parse(normalized);
  if (!{80, 443}.contains(uri.port) ||
      !uri.host.contains('.') ||
      uri.host.endsWith('.localhost') ||
      uri.host.endsWith('.local') ||
      uri.host.endsWith('.internal')) {
    return null;
  }
  return '${uri.origin}/';
}

class SupportRequestDraft {
  SupportRequestDraft({
    required this.kind,
    required this.comment,
    this.siteName = '',
    this.url = '',
    this.contact = '',
    this.appVersion = '',
    String? key,
    this.receipt,
  }) : key = key ?? translationUuid();

  final SupportRequestKind kind;
  final String siteName, url, comment, contact, appVersion, key;
  final String? receipt;

  String get commentPrefix => kind == SupportRequestKind.website
      ? ''
      : '$supportAppCommentPrefix${appVersion.isEmpty ? '' : '$appVersion\n'}';

  Map<String, String> get body => {
    // shortcut: app feedback uses "plugin"; switch when the API adds an app kind.
    'kind': kind == SupportRequestKind.website ? 'website' : 'plugin',
    'site_name': siteName,
    'url': url,
    'comment': '$commentPrefix$comment',
    'contact': contact,
  };

  Map<String, dynamic> toJson() => {
    ...body,
    'kind': kind.name,
    'comment': comment,
    'app_version': appVersion,
    'key': key,
    if (receipt != null) 'receipt': receipt,
  };

  factory SupportRequestDraft.fromJson(Map<String, dynamic> data) =>
      SupportRequestDraft(
        kind: SupportRequestKind.values.byName(data['kind'] as String),
        siteName: data['site_name'] as String,
        url: data['url'] as String,
        comment: data['comment'] as String,
        contact: data['contact'] as String,
        appVersion: data['app_version'] as String,
        key: data['key'] as String,
        receipt: data['receipt'] as String?,
      );

  SupportRequestDraft received(String id) => SupportRequestDraft(
    kind: kind,
    siteName: siteName,
    url: url,
    comment: comment,
    contact: contact,
    appVersion: appVersion,
    key: key,
    receipt: id,
  );
}

class SupportRequestRejected implements Exception {
  const SupportRequestRejected(this.status);
  final int status;
}

/// Anonymous submissions use their own client and vault entries, without cookies,
/// account tokens, logging, redirects or automatic retries.
class SupportRequests {
  SupportRequests({http.Client? client, Uri? base})
    : _client = client ?? http.Client(),
      _base = base ?? Uri.parse(NodeLaneBrand.apiBase);

  final http.Client _client;
  final Uri _base;
  String _storageKey(SupportRequestKind kind) =>
      'nodelane.support.${kind.name}.v1';

  Future<SupportRequestDraft?> load(SupportRequestKind kind) async {
    final stored = await nodeLanePrivateVault.read(key: _storageKey(kind));
    if (stored == null) return null;
    final draft = SupportRequestDraft.fromJson(
      jsonDecode(stored) as Map<String, dynamic>,
    );
    if (draft.kind != kind) {
      throw const FormatException('Invalid feedback kind');
    }
    return draft;
  }

  Future<void> save(SupportRequestDraft draft) => nodeLanePrivateVault.write(
    key: _storageKey(draft.kind),
    value: jsonEncode(draft.toJson()),
  );

  Future<void> clear(SupportRequestKind kind) =>
      nodeLanePrivateVault.delete(key: _storageKey(kind));

  Future<SupportRequestDraft> submit(SupportRequestDraft draft) async {
    if (_base.scheme != 'https' ||
        _base.host.isEmpty ||
        _base.userInfo.isNotEmpty ||
        _base.hasQuery ||
        _base.hasFragment) {
      throw const FormatException('Invalid feedback endpoint');
    }
    // Persist before writing remotely: even a lost response can be replayed.
    await save(draft);
    final abort = Completer<void>();
    final deadline = Timer(const Duration(seconds: 30), abort.complete);
    late http.Response response;
    try {
      final request = await NodeLaneRequests.request(
        'POST',
        NodeLaneRequests.uri(_base, '/v1/support-requests'),
        abortTrigger: abort.future,
      );
      request
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Idempotency-Key': draft.key,
        })
        ..body = jsonEncode(draft.body);
      final stream = await _client.send(request);
      final bytes = <int>[];
      await for (final part in stream.stream) {
        if (bytes.length + part.length > 65536) {
          if (!abort.isCompleted) abort.complete();
          throw const FormatException('Invalid feedback response');
        }
        bytes.addAll(part);
      }
      response = http.Response.bytes(bytes, stream.statusCode);
    } finally {
      deadline.cancel();
    }
    if ({400, 413, 422, 429}.contains(response.statusCode)) {
      throw SupportRequestRejected(response.statusCode);
    }
    if (response.statusCode != 201) {
      throw const FormatException('Feedback result unknown');
    }
    final data = jsonDecode(response.body);
    if (data is! Map ||
        data['id'] is! String ||
        !RegExp(
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
        ).hasMatch(data['id'] as String) ||
        data['created_at'] is! String ||
        DateTime.tryParse(data['created_at'] as String) == null) {
      throw const FormatException('Invalid feedback receipt');
    }
    final received = draft.received(data['id'] as String);
    await save(received);
    return received;
  }

  void close() => _client.close();
}
