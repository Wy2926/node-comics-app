import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show FileImage;
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/services/nodelane_private_storage.dart';
import 'package:mangayomi/services/translation/identity.dart';

import 'browser_url.dart';

final browserLibraryStore = BrowserLibraryStore();

typedef BrowserMatch = ({
  String title,
  String url,
  String? tabId,
  BrowserPageEntry? bookmark,
});

class BrowserPageEntry {
  BrowserPageEntry({
    required this.url,
    required this.title,
    required this.time,
    this.iconUrl,
    this.anchor,
    this.thumbnailId,
  });
  final String url, title;
  final DateTime time;
  final String? iconUrl;
  final Map<String, dynamic>? anchor;
  final String? thumbnailId;
  // A fresh filename per clip keeps an old frame out of Flutter's image cache key.
  late final Future<File>? thumbnail = thumbnailId == null
      ? null
      : _clipFile(thumbnailId!);

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
    if (thumbnailId != null) 'thumbnail': thumbnailId,
  };

  static BrowserPageEntry? fromJson(dynamic value) {
    if (value is! Map || !isBrowserUrl(value['url'])) return null;
    final time = DateTime.tryParse(value['time']?.toString() ?? '');
    if (time == null) return null;
    final anchor = readingPosition(value['anchor']), id = value['thumbnail'];
    return BrowserPageEntry(
      url: value['url'] as String,
      title: value['title'] is String ? value['title'] as String : '',
      time: time,
      anchor: anchor,
      thumbnailId: anchor != null && id is String && _clipId.hasMatch(id)
          ? id
          : null,
      iconUrl: isBrowserUrl(value['iconUrl'])
          ? value['iconUrl'] as String
          : null,
    );
  }
}

final _clipId = RegExp(r'^[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12}$');
Future<Directory> _clipDirectory() async =>
    Directory('${(await nodeLanePrivateDirectory()).path}/browser-clips');
Future<File> _clipFile(String id) async =>
    File('${(await _clipDirectory()).path}/$id.jpg');

Future<void> _discardClipFile(FutureOr<File?> reference) async {
  try {
    final file = await reference;
    if (file == null) return;
    await FileImage(file).evict();
    await file.delete();
  } catch (_) {
    // The next capture can reclaim a missing or busy file without affecting the bookmark.
  }
}

/// Independent of open tabs; private storage never exports browsing metadata.
class BrowserLibraryStore extends ChangeNotifier {
  static const storageKey = 'nodelane.browser.library.v1';
  static const _readingKey = 'nodelane.browser.reading.v1';
  static const maxHistory = 500;
  List<BrowserPageEntry> _history = [], _bookmarks = [], _reading = [];
  BrowserSearchEngine _engine = BrowserSearchEngine.google;
  Future<void>? _loading;
  final _writes = DbWriteQueue();
  bool _checkedClipFiles = false;
  bool _inheritedReading = false;

  List<BrowserPageEntry> get history => UnmodifiableListView(_history);
  List<BrowserPageEntry> get bookmarks => UnmodifiableListView(_bookmarks);
  BrowserSearchEngine get engine => _engine;
  bool isBookmarked(String url) => _bookmarks.any((e) => e.url == url);
  List<BrowserPageEntry> get reading => UnmodifiableListView(_reading);

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
    final rawReading = await nodeLanePrivateVault.read(key: _readingKey);
    if (rawReading == null) {
      // Older versions kept marked positions inside bookmarks; leave the originals intact.
      _reading = _bookmarks.where((e) => e.anchor != null).toList();
      _inheritedReading = _reading.isNotEmpty;
    } else {
      final data = jsonDecode(rawReading);
      if (data is! List) throw const FormatException('Invalid reading list');
      final seen = <String>{};
      _reading = data
          .map(BrowserPageEntry.fromJson)
          .nonNulls
          .where((e) => e.anchor != null && seen.add(e.url))
          .toList();
    }
    notifyListeners();
  }

  // Recover interrupted replacements on the first capture, off the home page's read path.
  Future<void> _prepareClips(Directory directory) async {
    await directory.create(recursive: true);
    if (_checkedClipFiles) return;
    final keep = {
      for (final b in _bookmarks.followedBy(_reading))
        if (b.thumbnailId != null) '${b.thumbnailId}.jpg',
    };
    await for (final file in directory.list(followLinks: false)) {
      final name = file.uri.pathSegments.last;
      if (file is File &&
          name.endsWith('.jpg') &&
          _clipId.hasMatch(name.substring(0, name.length - 4)) &&
          !keep.contains(name)) {
        await _discardClipFile(file);
      }
    }
    _checkedClipFiles = true;
  }

  // Apply mutations inside the queue, publishing only after a successful write.
  Future<void> _change({
    FutureOr<List<BrowserPageEntry>> Function()? history,
    List<BrowserPageEntry> Function()? bookmarks,
    FutureOr<List<BrowserPageEntry>> Function()? reading,
    BrowserSearchEngine? engine,
  }) => _writes.run(() async {
    await load();
    final nextHistory = history == null ? _history : await history();
    final nextBookmarks = bookmarks?.call() ?? _bookmarks;
    final nextReading = reading == null ? _reading : await reading();
    final nextEngine = engine ?? _engine;
    final libraryChanged =
        nextHistory != _history ||
        nextBookmarks != _bookmarks ||
        nextEngine != _engine;
    if (!libraryChanged && nextReading == _reading) return;
    if (nextReading != _reading ||
        (_inheritedReading && nextBookmarks != _bookmarks)) {
      await nodeLanePrivateVault.write(
        key: _readingKey,
        value: jsonEncode(nextReading.map((e) => e.toJson()).toList()),
      );
      _inheritedReading = false;
    }
    if (libraryChanged) {
      await nodeLanePrivateVault.write(
        key: storageKey,
        value: jsonEncode({
          'history': nextHistory.map((e) => e.toJson()).toList(),
          'bookmarks': nextBookmarks.map((e) => e.toJson()).toList(),
          'engine': nextEngine.name,
        }),
      );
    }
    final old = _bookmarks.followedBy(_reading);
    final thumbnailsChanged =
        nextReading != _reading || nextBookmarks != _bookmarks;
    _history = nextHistory;
    _bookmarks = nextBookmarks;
    _reading = nextReading;
    _engine = nextEngine;
    notifyListeners();
    if (thumbnailsChanged) {
      final keep = {
        for (final e in _bookmarks.followedBy(_reading)) ?e.thumbnailId,
      };
      for (final id
          in old.map((e) => e.thumbnailId).nonNulls.toSet().difference(keep)) {
        await _discardClipFile(_clipFile(id));
      }
    }
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

  Future<void> removeReading(String url) =>
      _change(reading: () => _reading.where((e) => e.url != url).toList());

  Future<void> saveReading(
    String url,
    String title, {
    required Map<String, dynamic> anchor,
    String? iconUrl,
    FutureOr<Uint8List?> thumbnail,
    Future<Uint8List?> Function()? firstPreview,
  }) async {
    if (!isBrowserUrl(url)) return;
    final position = BrowserPageEntry.readingPosition(anchor);
    if (position == null) {
      throw const FormatException('Invalid reading position');
    }
    File? staged;
    final when = DateTime.now();
    try {
      await _change(
        reading: () async {
          final old = _reading.where((e) => e.url == url).firstOrNull;
          if (thumbnail == null &&
              old != null &&
              old == _reading.first &&
              (title.isEmpty || old.title == title) &&
              mapEquals(position, old.anchor)) {
            return _reading;
          }
          var id = thumbnail == null ? old?.thumbnailId : null;
          if (thumbnail != null || (old == null && firstPreview != null)) {
            try {
              final bytes = await (thumbnail ?? firstPreview?.call());
              if (bytes != null && bytes.isNotEmpty) {
                final next = translationUuid();
                staged = await _clipFile(next);
                await _prepareClips(staged!.parent);
                await staged!.writeAsBytes(bytes, flush: true);
                id = next;
              }
            } catch (_) {
              await _discardClipFile(staged);
            }
          }
          return [
            BrowserPageEntry(
              url: url,
              title: title.isEmpty ? old?.title ?? '' : title,
              time: when,
              anchor: position,
              thumbnailId: id,
              iconUrl: isBrowserUrl(iconUrl) ? iconUrl : old?.iconUrl,
            ),
            ..._reading.where((e) => e.url != url),
          ];
        },
      );
    } catch (_) {
      await _discardClipFile(staged);
      rethrow;
    }
  }

  Future<void> setEngine(BrowserSearchEngine value) => _change(engine: value);
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
