import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/services/nodelane_private_storage.dart';
import 'package:mangayomi/services/translation/identity.dart';

import 'browser_url.dart';

final browserSessionStore = BrowserSessionStore();

/// Only logical metadata is persisted. Bounded page previews live in memory;
/// capturing them does not read cookies, bridge credentials or site storage.
class BrowserSessionStore extends ChangeNotifier {
  static const storageKey = 'nodelane.browser.tabs.v1';
  static const maxTabs = 20;
  List<Map<String, dynamic>> entries = [];
  final _previews = <String, Uint8List>{};
  Future<void>? _loading;
  final _writes = DbWriteQueue();
  ({Map<String, dynamic> entry, int index, String? blank})? _closed;
  bool get canUndo => _closed != null && entries.length < maxTabs;
  Uint8List? preview(String id) => _previews[id];
  Future<void> load() => _loading ??= _load().catchError((Object error) {
    _loading = null;
    throw error;
  });
  Future<void> _load() async {
    final raw = await nodeLanePrivateVault.read(key: storageKey);
    if (raw != null) {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        throw const FormatException('Invalid browser session');
      }
      final seen = <String>{};
      entries = decoded
          .whereType<Map>()
          .where(
            (e) =>
                e['id'] is String &&
                (e['id'] as String).isNotEmpty &&
                (e['url'] == '' || isBrowserUrl(e['url'])) &&
                seen.add(e['id'] as String),
          )
          .take(maxTabs)
          .map(
            (e) => {
              ...Map<String, dynamic>.from(e),
              'title': e['title'] is String ? e['title'] : '',
            },
          )
          .toList();
    }
    notifyListeners();
  }

  void setPreview(String id, Uint8List bytes) {
    if (bytes.length > 384 * 1024) return;
    _previews.remove(id);
    _previews[id] = bytes;
    // Logical tabs need no bitmap; keep the existing mobile preview budget.
    while (_previews.length > 12) {
      _previews.remove(_previews.keys.first);
    }
    notifyListeners();
  }

  void clearPreview(String id) {
    if (_previews.remove(id) != null) notifyListeners();
  }

  Future<void> _publish(List<Map<String, dynamic>> next) async {
    if (next.length > maxTabs) throw StateError('Too many tabs');
    await nodeLanePrivateVault.write(key: storageKey, value: jsonEncode(next));
    entries = next;
    _previews.removeWhere((id, _) => !entries.any((e) => e['id'] == id));
  }

  Future<T> _change<T>(Future<T> Function() change) => _writes.run(() async {
    await load();
    final result = await change();
    notifyListeners();
    return result;
  });

  Future<void> save(List<Map<String, dynamic>> values) =>
      _change(() => _publish(values));

  static Map<String, dynamic> _tab({String url = '', String title = ''}) => {
    'id': translationUuid(),
    'url': url,
    'title': title,
    'active': true,
  };

  Future<void> close(String id, {List<Map<String, dynamic>>? snapshot}) =>
      _change(() async {
        final remaining = (snapshot ?? entries).toList();
        final index = remaining.indexWhere((e) => e['id'] == id);
        if (index < 0) return;
        final removed = remaining.removeAt(index);
        String? blank;
        if (remaining.isEmpty) {
          remaining.add(_tab());
          blank = remaining.single['id'] as String;
        } else if (!remaining.any((e) => e['active'] == true)) {
          remaining.last = {...remaining.last, 'active': true};
        }
        await _publish(remaining);
        _closed = (entry: removed, index: index, blank: blank);
      });

  Future<void> undoClose({List<Map<String, dynamic>>? snapshot}) =>
      _change(() async {
        final closed = _closed;
        if (closed == null) return;
        final next = [
          for (final e in snapshot ?? entries)
            if (e['id'] != closed.blank || e['url'] != '') e,
        ];
        if (next.length >= maxTabs ||
            next.any((e) => e['id'] == closed.entry['id'])) {
          return;
        }
        final active =
            closed.entry['active'] == true ||
            !next.any((e) => e['active'] == true);
        if (active) {
          for (var i = 0; i < next.length; i++) {
            next[i] = {...next[i], 'active': false};
          }
        }
        next.insert(closed.index.clamp(0, next.length), {
          ...closed.entry,
          'active': active,
        });
        await _publish(next);
        _closed = null;
      });

  Future<String?> createTab({String url = '', String title = ''}) =>
      _change(() async {
        if (url.isNotEmpty && !isBrowserUrl(url)) {
          throw const FormatException('Invalid browser tab URL');
        }
        if (entries.length >= maxTabs) return null;
        final tab = _tab(url: url, title: title);
        await _publish([
          for (final entry in entries) {...entry, 'active': false},
          tab,
        ]);
        return tab['id'] as String;
      });

  Future<void> select(String id) => _change(() async {
    if (!entries.any((entry) => entry['id'] == id)) return;
    await _publish([
      for (final entry in entries) {...entry, 'active': entry['id'] == id},
    ]);
  });
}
