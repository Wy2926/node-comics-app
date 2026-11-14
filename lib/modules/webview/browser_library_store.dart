import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/services/nodelane_private_storage.dart';

import 'browser_url.dart';

final browserLibraryStore = BrowserLibraryStore();

class BrowserPageEntry {
  const BrowserPageEntry({
    required this.url,
    required this.title,
    required this.time,
    this.iconUrl,
  });
  final String url, title;
  final DateTime time;
  final String? iconUrl;

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
  };

  static BrowserPageEntry? fromJson(dynamic value) {
    if (value is! Map || !isBrowserUrl(value['url'])) return null;
    final time = DateTime.tryParse(value['time']?.toString() ?? '');
    if (time == null) return null;
    return BrowserPageEntry(
      url: value['url'] as String,
      title: value['title'] is String ? value['title'] as String : '',
      time: time,
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
  Future<void> _writes = Future.value();

  List<BrowserPageEntry> get history => List.unmodifiable(_history);
  List<BrowserPageEntry> get bookmarks => List.unmodifiable(_bookmarks);
  BrowserSearchEngine get engine => _engine;
  bool isBookmarked(String url) => _bookmarks.any((e) => e.url == url);

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
    List<BrowserPageEntry> Function()? history,
    List<BrowserPageEntry> Function()? bookmarks,
    BrowserSearchEngine? engine,
  }) {
    _writes = _writes.catchError((_) {}).then((_) async {
      await load();
      final nextHistory = history?.call() ?? _history;
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
    return _writes;
  }

  Future<void> visit(
    String url,
    String title, {
    DateTime? time,
    String? iconUrl,
  }) {
    if (!isBrowserUrl(url)) return Future.value();
    final entry = BrowserPageEntry(
      url: url,
      title: title,
      time: time ?? DateTime.now(),
      iconUrl: isBrowserUrl(iconUrl) ? iconUrl : null,
    );
    return _change(
      history: () => [
        entry,
        ..._history.where(
          (old) =>
              old.url != url ||
              !_sameDay(old.time.toLocal(), entry.time.toLocal()),
        ),
      ].take(maxHistory).toList(),
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
  }) {
    if (!isBrowserUrl(url)) return Future.value();
    return _change(
      bookmarks: () => [
        if (saved)
          BrowserPageEntry(
            url: url,
            title: title,
            time: DateTime.now(),
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
