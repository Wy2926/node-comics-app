import 'dart:async';
import 'dart:collection';

import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';

/// One bounded background queue for a reader, replaced as its window moves.
/// In-flight downloads may also serve visible widgets, so they keep their slot
/// until completion instead of starting another batch on every page change.
class ReaderImagePrefetcher {
  ReaderImagePrefetcher({required this.load});

  final Future<void> Function(UChapDataPreload page, bool Function() isCurrent)
  load;
  final _pending = Queue<UChapDataPreload>();
  final _active = <UChapDataPreload>{};
  Set<UChapDataPreload> _window = {};
  bool _disposed = false;

  void update(Iterable<UChapDataPreload> pages) {
    if (_disposed) return;
    _window = pages.where((page) => !page.isTransitionPage).toSet();
    _pending
      ..clear()
      ..addAll(_window.where((page) => !_active.contains(page)));
    _pump();
  }

  void _pump() {
    while (!_disposed && _active.length < 3 && _pending.isNotEmpty) {
      final page = _pending.removeFirst();
      _active.add(page);
      unawaited(_run(page));
    }
  }

  Future<void> _run(UChapDataPreload page) async {
    try {
      await load(page, () => !_disposed && _window.contains(page));
    } catch (_) {
      // Visible image widgets own errors/retries; background failure only
      // releases its slot so it cannot block the rest of the reading window.
    } finally {
      _active.remove(page);
      _pump();
    }
  }

  void clear() {
    _window.clear();
    _pending.clear();
  }

  void dispose() {
    _disposed = true;
    clear();
  }
}
