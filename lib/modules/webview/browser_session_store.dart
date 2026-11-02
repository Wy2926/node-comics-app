import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/services/nodelane_private_storage.dart';
import 'package:mangayomi/services/translation/identity.dart';

import 'browser_url.dart';

final browserSessionStore = BrowserSessionStore();

/// Only logical metadata is persisted. Bounded page previews live in memory;
/// capturing them does not read cookies, bridge credentials or site storage.
class BrowserSessionStore extends ChangeNotifier {
  static const storageKey = 'nodelane.browser.tabs.v1';
  static const maxTabs = 12;
  List<Map<String, dynamic>> entries = [];
  final _previews = <String, Uint8List>{};
  Future<void>? _loading;
  Future<void> _writes = Future.value();
  bool _loaded = false;
  Uint8List? preview(String id) => _previews[id];
  Future<void> load() => _loading ??= _load();
  Future<void> _load() async {
    if (_loaded) return;
    try {
      final raw = await nodeLanePrivateVault.read(key: storageKey);
      if (raw != null && raw.length <= 256 * 1024) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
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
      }
    } catch (_) {}
    _loaded = true;
    notifyListeners();
  }

  void setPreview(String id, Uint8List bytes) {
    if (bytes.length > 384 * 1024) return;
    _previews.remove(id);
    _previews[id] = bytes;
    while (_previews.length > maxTabs) {
      _previews.remove(_previews.keys.first);
    }
    notifyListeners();
  }

  Future<void> save(List<Map<String, dynamic>> values) {
    entries = values
        .take(maxTabs)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    _loaded = true;
    _previews.removeWhere((id, _) => !entries.any((e) => e['id'] == id));
    notifyListeners();
    final text = jsonEncode(entries);
    if (text.length > 256 * 1024) return Future.value();
    // Serial writes keep a late page-save from restoring a closed tab.
    _writes = _writes
        .catchError((_) {})
        .then((_) => nodeLanePrivateVault.write(key: storageKey, value: text));
    return _writes;
  }

  Future<void> close(String id) {
    final remaining = entries.where((e) => e['id'] != id).toList();
    if (remaining.isEmpty) {
      remaining.add({
        'id': translationUuid(),
        'url': '',
        'title': '',
        'active': true,
      });
    } else if (!remaining.any((e) => e['active'] == true)) {
      remaining.last = {...remaining.last, 'active': true};
    }
    return save(remaining);
  }
}
