import 'package:mangayomi/utils/localized_message.dart';

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
  final _imageErrors = <String, String>{};
  final _expired = <String>{};
  final _actions = <String, Object>{};
  final _restored = <String>{};
  int _epoch = 0;
  bool enabled = true,
      showTranslation = false,
      foreground = true,
      _disposed = false;
  String? error;

  /// Keep the user's switch preference while original display pauses all
  /// automatic submissions, including pretranslation of neighboring images.
  bool get shouldTranslateAutomatically =>
      enabled && showTranslation && foreground;

  TranslationTarget? targetFor(TranslationPage page) => targets
      .where((target) => target.page.identity == page.identity)
      .firstOrNull;

  void attach(ChannelRuntime? value) {
    if (identical(value, runtime)) return;
    _epoch++;
    error = null;
    _actions.clear();
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
    _imageErrors.removeWhere((key, _) => !keep.contains(key));
    _expired.removeWhere((key) => !keep.contains(key));
    _restored.removeWhere((key) => !keep.contains(key));
    _sync();
  }

  void configure({bool? enabled, bool? showTranslation, bool? foreground}) {
    if (enabled != null) this.enabled = enabled;
    if (showTranslation != null) this.showTranslation = showTranslation;
    if (foreground != null) this.foreground = foreground;
    if (!this.foreground) _release();
    _sync();
  }

  bool isPerforming(TranslationTarget target) =>
      _actions.containsKey(target.page.identity);
  bool isReading(TranslationTarget target) =>
      _requests.containsKey(target.page.identity) &&
      !images.containsKey(target.page.identity);
  PageTranslationState state(TranslationTarget target) {
    final value =
        runtime?.stateFor(target.page) ?? const PageTranslationState();
    final failure = _imageErrors[target.page.identity];
    if (failure == null) return value;
    return PageTranslationState(
      phase: TranslationPhase.failed,
      message: failure,
      result: value.result,
      actions: {
        if (!_expired.contains(target.page.identity)) ...{
          if (value.result != null) TranslationAction.readResult,
          ...value.actions,
        } else if (value.actions.contains(TranslationAction.regenerate))
          TranslationAction.regenerate,
      },
    );
  }

  void _sync() {
    if (_disposed) return;
    if (foreground) {
      runtime?.setWindow(
        consumer,
        targets,
        automatic: shouldTranslateAutomatically,
      );
      _restore();
    } else {
      runtime?.pause(consumer);
    }
    _changed();
  }

  void _restore() {
    final attached = runtime;
    if (attached == null) return;
    final pending = targets
        .where((target) => _restored.add(target.page.identity))
        .toList();
    if (pending.isEmpty) return;
    final epoch = _epoch;
    attached
        .restore(pending)
        .then((_) {
          if (_disposed || epoch != _epoch || !foreground) return;
          _sync();
        })
        .catchError((Object failure) {
          if (_disposed || epoch != _epoch || !foreground) return;
          error = failure is TranslationFailure
              ? failure.message
              : localizedMessage((l10n) => l10n.translation_saved_read_failed);
          for (final target in pending) {
            _restored.remove(target.page.identity);
          }
          notifyListeners();
        });
  }

  void _changed() {
    if (_disposed) return;
    if (foreground && showTranslation) {
      for (final target in targets) {
        final result = runtime?.stateFor(target.page).result;
        final key = target.page.identity;
        if (result == null) {
          _requests.remove(key)?.cancel();
          _attempted.remove(key);
          _imageErrors.remove(key);
          _expired.remove(key);
          images.remove(key)?.release();
          continue;
        }
        if (_requests.containsKey(key) ||
            _attempted[key] == result.operationId) {
          continue;
        }
        _attempted[key] = result.operationId;
        _imageErrors.remove(key);
        _expired.remove(key);
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
                if (e is TranslationFailure && e.code == 'RESULT_EXPIRED') {
                  _expired.add(key);
                }
                _imageErrors[key] = e is TranslationFailure
                    ? e.message
                    : localizedMessage((l10n) => l10n.translation_read_failed);
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
    final attached = runtime;
    final key = target.page.identity;
    if (_disposed ||
        attached == null ||
        !foreground ||
        targetFor(target.page) == null ||
        !state(target).actions.contains(action) ||
        _actions.containsKey(key)) {
      return;
    }
    final epoch = _epoch;
    final request = Object();
    _actions[key] = request;
    error = null;
    _imageErrors.remove(key);
    notifyListeners();
    try {
      await attached.perform(target, action);
      if (_disposed || epoch != _epoch) return;
      _attempted.remove(key);
      _changed();
    } on TranslationCancelled {
      // Navigation and account replacement invalidate the old action.
    } catch (e) {
      if (!_disposed && epoch == _epoch && targetFor(target.page) != null) {
        final message = e is TranslationFailure
            ? e.message
            : localizedMessage((l10n) => l10n.operation_retry);
        _imageErrors[key] = message;
        error = message;
      }
    } finally {
      if (identical(_actions[key], request)) _actions.remove(key);
      if (!_disposed && epoch == _epoch) notifyListeners();
    }
  }

  void _release() {
    for (final c in _requests.values) {
      c.cancel();
    }
    _requests.clear();
    _attempted.clear();
    _imageErrors.clear();
    _expired.clear();
    _restored.clear();
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
