import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' show BytesBuilder;

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'browser_url.dart';

/// Only unfinished search terms go to the selected engine, never an address or a local match.
bool isSuggestionQuery(String draft) {
  final text = draft.trim();
  return text.isNotEmpty &&
      !RegExp(r'[\x00-\x1f\x7f:/\\@=]|(?:^|\s)\S+\.\S+').hasMatch(draft) &&
      normalizeBrowserAddress(text) == null &&
      resolveBrowserInput(text) != null;
}

Uri _endpoint(BrowserSearchEngine engine, String q) => switch (engine) {
  BrowserSearchEngine.google => Uri.https(
    'suggestqueries.google.com',
    '/complete/search',
    {'client': 'firefox', 'oe': 'utf-8', 'q': q},
  ),
  BrowserSearchEngine.bing => Uri.https('api.bing.com', '/qsonhs.aspx', {
    'form': 'bf',
    'q': q,
  }),
  BrowserSearchEngine.baidu => Uri.https('suggestion.baidu.com', '/su', {
    'action': 'opensearch',
    'ie': 'utf-8',
    'oe': 'utf-8',
    'wd': q,
  }),
  BrowserSearchEngine.duckDuckGo => Uri.https('duckduckgo.com', '/ac/', {
    'type': 'list',
    'q': q,
  }),
  BrowserSearchEngine.yahoo => Uri.https(
    'search.yahoo.com',
    '/sugg/gossip/gossip-us-ura/',
    {'output': 'fxjson', 'command': q},
  ),
  BrowserSearchEngine.sogou => Uri.https('sor.html5.qq.com', '/api/getsug', {
    'key': q,
  }),
};

// Sogou wraps its data in a fixed callback; parse only the JSON argument.
List<String> parseBrowserSuggestions(
  BrowserSearchEngine engine,
  String query,
  String body,
) {
  if (engine == BrowserSearchEngine.sogou) {
    final json = RegExp(
      r'^window\.sogou\.sug\((\[.*\]),\s*-1\);?$',
      dotAll: true,
    ).firstMatch(body.trim())?.group(1);
    if (json == null) return [];
    body = json;
  }
  final data = jsonDecode(body);
  final seen = {query.trim().toLowerCase()};
  final Iterable<dynamic> items;
  if (data case [String echoed, List terms, ...]
      when echoed.trim().toLowerCase() == seen.first) {
    items = terms;
  } else if (data case {'AS': {'Query': String echoed, 'Results': List groups}}
      when echoed.trim().toLowerCase() == seen.first) {
    items = [
      for (final group in groups)
        if (group case {'Suggests': List terms})
          for (final item in terms)
            if (item case {'Txt': String text}) text,
    ];
  } else {
    return [];
  }
  return items
      .whereType<String>()
      .map((s) => s.trim())
      .where(
        (s) =>
            s.isNotEmpty &&
            !RegExp(r'[\x00-\x1f\x7f\ufffd]').hasMatch(s) &&
            seen.add(s.toLowerCase()),
      )
      .take(5)
      .toList();
}

class BrowserSearchSuggestions {
  http.Client? _client;
  Completer<void>? _abort;
  Timer? _deadline;

  void cancel() {
    _deadline?.cancel();
    final abort = _abort;
    if (abort != null && !abort.isCompleted) abort.complete();
    _abort = null;
  }

  Future<List<String>> find(BrowserSearchEngine engine, String draft) async {
    cancel();
    if (!isSuggestionQuery(draft)) return [];
    final q = draft.trim(), abort = _abort = Completer<void>();
    _deadline = Timer(const Duration(seconds: 4), cancel);
    try {
      final request = http.AbortableRequest(
        'GET',
        _endpoint(engine, q),
        abortTrigger: abort.future,
      )..followRedirects = false;
      final response = await (_client ??= http.Client()).send(request);
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in response.stream) {
        if (response.statusCode != 200 ||
            abort.isCompleted ||
            bytes.length + chunk.length > 64 * 1024) {
          return [];
        }
        bytes.add(chunk);
      }
      if (abort.isCompleted || bytes.isEmpty) return [];
      final raw = bytes.takeBytes();
      String body;
      try {
        body = utf8.decode(raw);
      } on FormatException {
        if (engine != BrowserSearchEngine.sogou) return [];
        body =
            await const MethodChannel('nodelane/browser/charset')
                .invokeMethod<String>('gb18030', raw) ??
            '';
      }
      return abort.isCompleted ? [] : parseBrowserSuggestions(engine, q, body);
    } catch (_) {
      return [];
    } finally {
      if (_abort == abort) cancel();
    }
  }

  void close() {
    cancel();
    _client?.close();
    _client = null;
  }
}
