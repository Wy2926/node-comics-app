import 'dart:async';

import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';

/// Owns native references and JavaScript timers, not host I/O resources.
/// The pinned QuickJS adapter does not release these in dispose().
class SourceJavascriptRuntime extends QuickJsRuntime2 {
  SourceJavascriptRuntime({super.timeout}) {
    run(enableHandlePromises);
  }

  final _references = <JSRef>{};
  final _nativeKeys = <Object>{};
  final _timers = <Timer>{};
  final _hostZone = Zone.current;
  bool _disposed = false;
  late final _zone = _hostZone.fork(
    specification: ZoneSpecification(
      createTimer: (self, parent, zone, duration, callback) {
        late Timer timer;
        timer = parent.createTimer(zone, duration, () {
          _timers.remove(timer);
          if (!_disposed) callback();
        });
        _timers.add(timer);
        return timer;
      },
      createPeriodicTimer: (self, parent, zone, duration, callback) {
        final timer = parent.createPeriodicTimer(zone, duration, (timer) {
          if (!_disposed) callback(timer);
        });
        _timers.add(timer);
        return timer;
      },
    ),
  );

  T run<T>(T Function() action) => _zone.run(action);

  @override
  void onMessage(String channelName, dynamic Function(dynamic args) fn) {
    super.onMessage(channelName, (args) {
      // Shared HTTPS sockets keep the zone in which they were opened. Owning
      // their read/write timers here makes a reused connection hang after this
      // runtime is disposed. Host bridges (HTTP, extractors, WebView, etc.)
      // retain their caller's lifetime; only JS setTimeout belongs to us.
      return channelName == 'SetTimeout'
          ? run(() => fn(args))
          : _hostZone.run(() => fn(args));
    });
  }

  @override
  JavascriptRuntime init() {
    // The pinned adapter frees native memory but leaves its Dart registry entry.
    // Engine creation is synchronous on this isolate; only our keys are captured.
    final previous = runtimeOpaques.keys.toSet();
    try {
      return run(super.init);
    } finally {
      _nativeKeys.addAll(
        runtimeOpaques.keys.where((key) => !previous.contains(key)),
      );
    }
  }

  @override
  JsEvalResult evaluate(
    String command, {
    String? name,
    int? evalFlags,
    String? sourceUrl,
  }) {
    if (_disposed) throw StateError('Source runtime is disposed');
    final result = run(
      () => super.evaluate(
        command,
        name: name,
        evalFlags: evalFlags,
        sourceUrl: sourceUrl,
      ),
    );
    void retain(dynamic value) {
      if (value is JSRef) {
        _references.add(value);
      } else if (value is List) {
        value.forEach(retain);
      } else if (value is Map) {
        value.values.forEach(retain);
      }
    }

    retain(result.rawResult);
    return result;
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
    JavascriptRuntime.channelFunctionsRegistered.remove(getEngineInstanceId());
    for (final reference in _references) {
      reference.free();
    }
    _references.clear();
    localContext.clear();
    dartContext.clear();
    try {
      super.dispose();
    } finally {
      for (final key in _nativeKeys) {
        runtimeOpaques.remove(key);
      }
      _nativeKeys.clear();
    }
  }
}
