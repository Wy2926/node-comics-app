import 'dart:async';

/// Caps how many source rows fetch at once.
///
/// Shared admission control only; each search screen owns its own queue.
/// Callers check whether they are still mounted after acquiring, and always
/// release the slot in finally. Source providers retain request ownership.
class FetchGate {
  FetchGate(this._maxConcurrent);
  final int _maxConcurrent;
  int _active = 0;
  final _waiting = <Completer<void>>[];

  Future<void> acquire() async {
    if (_active < _maxConcurrent) {
      _active++;
      return;
    }
    final completer = Completer<void>();
    _waiting.add(completer);
    await completer.future;
  }

  void release() {
    // Transfer the occupied slot directly. Making it available before the
    // waiting continuation runs lets a new query exceed the concurrency cap.
    if (_waiting.isNotEmpty) {
      _waiting.removeAt(0).complete();
    } else {
      _active--;
    }
  }
}
