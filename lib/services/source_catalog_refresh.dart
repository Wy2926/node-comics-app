import 'dart:convert';
import 'dart:io';

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
  final Future<void> Function() update;
  final DateTime Function() now;
  Future<void>? _pending;
  Map<String, dynamic> _receipt = {};
  bool _loaded = false;

  Future<void> refresh({bool force = false}) =>
      _pending ??= _run(force).whenComplete(() => _pending = null);

  Future<void> _run(bool force) async {
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

    final receipt = {'url': url, 'attempt': timestamp};
    await save(receipt);
    await update();
    await save({...receipt, 'success': now().millisecondsSinceEpoch});
  }
}
