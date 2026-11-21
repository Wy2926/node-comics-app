import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/services/nodelane_private_storage.dart';

import 'browser_url.dart';

final browserLibraryStore = BrowserLibraryStore();

typedef BrowserMatch = ({
  String title,
  String url,
  String? tabId,
  BrowserPageEntry? bookmark,
});

class BrowserPageEntry {
  const BrowserPageEntry({
    required this.url,
    required this.title,
    required this.time,
    this.iconUrl,
    this.anchor,
  });
  final String url, title;
  final DateTime time;
  final String? iconUrl;
  final Map<String, dynamic>? anchor;

  // Persist only coordinates and the declared page number, never DOM or image URLs.
  static Map<String, dynamic>? readingPosition(dynamic raw) {
    if (raw is! Map ||
        raw['x'] is! num ||
        raw['y'] is! num ||
        !(raw['x'] as num).isFinite ||
        !(raw['y'] as num).isFinite) {
      return null;
    }
    return Map.unmodifiable({
      'x': raw['x'],
      'y': raw['y'],
      if (raw['slot'] is int &&
          raw['slot'] >= 0 &&
          raw['fraction'] is num &&
          (raw['fraction'] as num).isFinite) ...{
        'slot': raw['slot'],
        'fraction': (raw['fraction'] as num).clamp(0, 1),
        if (raw['across'] is num && (raw['across'] as num).isFinite)
          'across': (raw['across'] as num).clamp(0, 1),
      },
      if (raw['page'] is int && raw['page'] > 0) 'page': raw['page'],
    });
  }

  String get host => Uri.parse(url).host;
  String get displayTitle => title.isEmpty ? host : title;
  String get faviconUrl => isBrowserUrl(iconUrl)
      ? iconUrl!
      : Uri.parse(url).resolve('/favicon.ico').toString();

  Map<String, dynamic> toJson() => {
    'url': url,
    'title': title,
    'time': time.toIso8601String(),
    if (isBrowserUrl(iconUrl)) 'iconUrl': iconUrl,
    if (anchor != null) 'anchor': anchor,
  };

  static BrowserPageEntry? fromJson(dynamic value) {
    if (value is! Map || !isBrowserUrl(value['url'])) return null;
    final time = DateTime.tryParse(value['time']?.toString() ?? '');
    if (time == null) return null;
    return BrowserPageEntry(
      url: value['url'] as String,
      title: value['title'] is String ? value['title'] as String : '',
      time: time,
      anchor: readingPosition(value['anchor']),
      iconUrl: isBrowserUrl(value['iconUrl'])
          ? value['iconUrl'] as String
          : null,
    );
  }
}

/// Independent of open tabs; private storage never exports browsing metadata.
class BrowserLibraryStore extends ChangeNotifier {
  static const storageKey = 'nodelane.browser.library.v1';
  static const maxHistory = 500;
  List<BrowserPageEntry> _history = [], _bookmarks = [];
  BrowserSearchEngine _engine = BrowserSearchEngine.google;
  Future<void>? _loading;
  final _writes = DbWriteQueue();

  List<BrowserPageEntry> get history => List.unmodifiable(_history);
  List<BrowserPageEntry> get bookmarks => List.unmodifiable(_bookmarks);
  BrowserSearchEngine get engine => _engine;
  bool isBookmarked(String url) => _bookmarks.any((e) => e.url == url);
  BrowserPageEntry? get lastClip =>
      _bookmarks.where((e) => e.anchor != null).firstOrNull;

  Iterable<BrowserMatch> matches(
    String query,
    Iterable<Map<String, dynamic>> tabs,
  ) sync* {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return;
    final seen = <String>{};
    bool match(String title, String url) =>
        url.isNotEmpty &&
        '$title $url'.toLowerCase().contains(term) &&
        seen.add(url);
    for (final t in tabs) {
      final url = t['url'] as String, title = t['title'] as String? ?? '';
      if (match(title, url)) {
        yield (
          url: url,
          title: title,
          tabId: t['id'] as String,
          bookmark: null,
        );
      }
    }
    for (final entries in [_bookmarks, _history]) {
      for (final e in entries) {
        if (match(e.title, e.url)) {
          yield (
            url: e.url,
            title: e.displayTitle,
            tabId: null,
            bookmark: identical(entries, _bookmarks) ? e : null,
          );
        }
      }
    }
  }

  Future<void> load() => _loading ??= _load().catchError((Object error) {
    _loading = null;
    throw error;
  });

  Future<void> _load() async {
    final raw = await nodeLanePrivateVault.read(key: storageKey);
    if (raw != null) {
      final data = jsonDecode(raw);
      if (data is! Map ||
          data['history'] is! List ||
          data['bookmarks'] is! List) {
        throw const FormatException('Invalid browser library');
      }
      _history = (data['history'] as List)
          .map(BrowserPageEntry.fromJson)
          .nonNulls
          .take(maxHistory)
          .toList();
      final seen = <String>{};
      _bookmarks = (data['bookmarks'] as List)
          .map(BrowserPageEntry.fromJson)
          .nonNulls
          .where((entry) => seen.add(entry.url))
          .toList();
      _engine =
          BrowserSearchEngine.values
              .where((engine) => engine.name == data['engine'])
              .firstOrNull ??
          BrowserSearchEngine.google;
    }
    notifyListeners();
  }

  // Apply mutations inside the queue, publishing only after a successful write.
  Future<void> _change({
    FutureOr<List<BrowserPageEntry>> Function()? history,
    List<BrowserPageEntry> Function()? bookmarks,
    BrowserSearchEngine? engine,
  }) => _writes.run(() async {
    await load();
    final nextHistory = history == null ? _history : await history();
    final nextBookmarks = bookmarks?.call() ?? _bookmarks;
    final nextEngine = engine ?? _engine;
    if (history == null && bookmarks == null && nextEngine == _engine) return;
    await nodeLanePrivateVault.write(
      key: storageKey,
      value: jsonEncode({
        'history': nextHistory.map((e) => e.toJson()).toList(),
        'bookmarks': nextBookmarks.map((e) => e.toJson()).toList(),
        'engine': nextEngine.name,
      }),
    );
    _history = nextHistory;
    _bookmarks = nextBookmarks;
    _engine = nextEngine;
    notifyListeners();
  });

  Future<void> visit(
    String url,
    String title, {
    DateTime? time,
    FutureOr<String?> iconUrl,
  }) {
    if (!isBrowserUrl(url)) return Future.value();
    final when = time ?? DateTime.now();
    return _change(
      history: () async {
        final icon = await iconUrl;
        return [
          BrowserPageEntry(
            url: url,
            title: title,
            time: when,
            iconUrl: isBrowserUrl(icon) ? icon : null,
          ),
          ..._history.where(
            (old) =>
                old.url != url || !_sameDay(old.time.toLocal(), when.toLocal()),
          ),
        ].take(maxHistory).toList();
      },
    );
  }

  Future<void> removeHistory(BrowserPageEntry entry) =>
      _change(history: () => _history.where((e) => e != entry).toList());

  Future<void> clearHistory() => _change(history: () => []);

  Future<void> setBookmarked(
    String url,
    String title,
    bool saved, {
    String? iconUrl,
    Map<String, dynamic>? anchor,
  }) {
    if (!isBrowserUrl(url)) return Future.value();
    final position = BrowserPageEntry.readingPosition(anchor);
    if (anchor != null && position == null) {
      throw const FormatException('Invalid reading position');
    }
    return _change(
      bookmarks: () => [
        if (saved)
          BrowserPageEntry(
            url: url,
            title: title,
            time: DateTime.now(),
            anchor: position,
            iconUrl: isBrowserUrl(iconUrl) ? iconUrl : null,
          ),
        ..._bookmarks.where((e) => e.url != url),
      ],
    );
  }

  Future<void> setEngine(BrowserSearchEngine value) => _change(engine: value);
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
