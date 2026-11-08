import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mangayomi/services/source_package.dart';

/// One refresh per official endpoint, shared by launch, resume and manual
/// refresh. Persist only scheduling metadata; installed code stays in Isar.
class SourceCatalogRefresh {
  SourceCatalogRefresh({
    required this.url,
    required this.stateFile,
    required this.update,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  final String url;
  final Future<File> Function() stateFile;
  final Future<void> Function(void Function() catalogReady) update;
  final DateTime Function() now;
  Future<void>? _pending;
  Future<void> _completion = Future.value();
  Completer<void>? _ready;
  Map<String, dynamic> _receipt = {};
  bool _loaded = false;

  /// Pages wait for metadata only; installation continues on the shared queue.
  Future<void> refresh({bool force = false}) {
    if (_pending != null) return _ready!.future;
    final ready = _ready = Completer<void>();
    _completion = _pending = _run(
      force,
      ready,
    ).whenComplete(() => _pending = null);
    // Background package failures must not become uncaught UI errors.
    _completion.ignore();
    return ready.future;
  }

  Future<void> get completion => _completion;

  Future<void> _run(bool force, Completer<void> ready) async {
    try {
      await _updateIfDue(force, () {
        if (!ready.isCompleted) ready.complete();
      });
      if (!ready.isCompleted) ready.complete();
    } catch (error, stack) {
      if (!ready.isCompleted) ready.completeError(error, stack);
      rethrow;
    }
  }

  Future<void> _updateIfDue(bool force, void Function() catalogReady) async {
    final timestamp = now().millisecondsSinceEpoch;
    File? file;
    try {
      file = await stateFile();
      if (!_loaded) {
        final saved =
            jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        if (saved['url'] == url) _receipt = saved;
      }
    } catch (_) {
      // Scheduling metadata is optional; storage failures must not block loading.
    } finally {
      _loaded = true;
    }
    bool recent(String field, Duration interval) {
      final value = _receipt[field];
      if (value is! int) return false;
      final elapsed = timestamp - value;
      return elapsed >= 0 && elapsed < interval.inMilliseconds;
    }

    if (!force &&
        (recent('success', const Duration(hours: 12)) ||
            recent('attempt', const Duration(minutes: 15)))) {
      return;
    }
    Future<void> save(Map<String, dynamic> value) async {
      _receipt = value;
      final destination = file;
      if (destination == null) return;
      try {
        await destination.parent.create(recursive: true);
        final temporary = File('${destination.path}.tmp');
        await temporary.writeAsString(jsonEncode(value), flush: true);
        await temporary.rename(destination.path);
      } on FileSystemException {
        // Retain the in-memory cooldown even when the receipt cannot be saved.
      }
    }

    // A process exit or foreground pause is incomplete work, not a failure.
    // Only completed attempts establish a cooldown.
    await save({'url': url});
    try {
      await update(catalogReady);
      await save({'url': url, 'success': now().millisecondsSinceEpoch});
    } on SourceInstallationPaused {
      rethrow;
    } catch (_) {
      await save({'url': url, 'attempt': now().millisecondsSinceEpoch});
      rethrow;
    }
  }
}
