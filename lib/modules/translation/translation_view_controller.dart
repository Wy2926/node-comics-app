import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/identity.dart';

/// Display lifetime and user intent, independent of any concrete channel.
class TranslationViewController extends ChangeNotifier {
  final consumer = translationUuid();
  ChannelRuntime? runtime;
  StreamSubscription<void>? _subscription;
  List<TranslationTarget> targets = const [];
  final images = <String, DisplayImageLease>{};
  final _requests = <String, TranslationCancellation>{};
  final _attempted = <String, String>{};
  bool enabled = false,
      showTranslation = true,
      foreground = true,
      _disposed = false;
  String? error;

  void attach(ChannelRuntime? value) {
    if (identical(value, runtime)) return;
    runtime?.pause(consumer);
    _subscription?.cancel();
    _release();
    runtime = value;
    _subscription = value?.changes.listen((_) => _changed());
    _sync();
  }

  void window(List<TranslationTarget> value) {
    targets = value.take(4).toList();
    final keep = targets.map((t) => t.page.identity).toSet();
    for (final key in images.keys.toList()) {
      if (!keep.contains(key)) images.remove(key)?.release();
    }
    for (final key in _requests.keys.toList()) {
      if (!keep.contains(key)) _requests.remove(key)?.cancel();
    }
    _attempted.removeWhere((key, _) => !keep.contains(key));
    _sync();
  }

  void configure({bool? enabled, bool? showTranslation, bool? foreground}) {
    if (enabled != null) this.enabled = enabled;
    if (showTranslation != null) this.showTranslation = showTranslation;
    if (foreground != null) this.foreground = foreground;
    if (!this.foreground) _release();
    _sync();
  }

  PageTranslationState state(TranslationTarget target) =>
      runtime?.stateFor(target.page) ?? const PageTranslationState();
  void _sync() {
    if (_disposed) return;
    if (enabled && foreground) {
      runtime?.setWindow(consumer, targets);
    } else {
      runtime?.pause(consumer);
    }
    _changed();
  }

  void _changed() {
    if (_disposed) return;
    if (foreground && showTranslation) {
      for (final target in targets) {
        final result = state(target).result;
        final key = target.page.identity;
        if (result == null) {
          _requests.remove(key)?.cancel();
          _attempted.remove(key);
          images.remove(key)?.release();
          continue;
        }
        if (runtime == null ||
            _requests.containsKey(key) ||
            _attempted[key] == result.operationId) {
          continue;
        }
        _attempted[key] = result.operationId;
        final cancel = TranslationCancellation();
        _requests[key] = cancel;
        runtime!
            .readResult(result, cancel)
            .then((lease) {
              if (_disposed ||
                  cancel.isCancelled ||
                  state(target).result?.operationId != result.operationId) {
                lease.release();
                return;
              }
              images.remove(key)?.release();
              images[key] = lease;
              notifyListeners();
            })
            .catchError((Object e) {
              if (!cancel.isCancelled) {
                error = e is TranslationFailure ? e.message : '译图读取失败';
                notifyListeners();
              }
            })
            .whenComplete(() {
              if (identical(_requests[key], cancel)) _requests.remove(key);
            });
      }
    }
    notifyListeners();
  }

  Future<void> perform(
    TranslationTarget target,
    TranslationAction action,
  ) async {
    error = null;
    try {
      await runtime?.perform(target, action);
      _attempted.remove(target.page.identity);
      _changed();
    } catch (e) {
      error = e is TranslationFailure ? e.message : '操作未完成';
      if (!_disposed) notifyListeners();
    }
  }

  void _release() {
    for (final c in _requests.values) {
      c.cancel();
    }
    _requests.clear();
    _attempted.clear();
    for (final image in images.values) {
      image.release();
    }
    images.clear();
  }

  @override
  void dispose() {
    _disposed = true;
    runtime?.pause(consumer);
    _subscription?.cancel();
    _release();
    super.dispose();
  }
}
