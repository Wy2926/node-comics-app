import 'dart:convert';
import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:mangayomi/models/translation_entry.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/identity.dart';

/// All receipt mutations precede their network effects. Files are published
/// before their metadata, so a crash can leave an orphan, never a false success.
class TranslationRepository {
  TranslationRepository(this.database, this.directory);
  final Isar database;
  final Directory directory;
  final _writes = DbWriteQueue();
  final _files = DbWriteQueue();
  final _leases = <String, int>{};
  final _deleted = <String>{};
  int cacheEpoch = 0;
  static const inputBudget = 128 * 1024 * 1024;
  static const resultBudget = 256 * 1024 * 1024;
  static const metadataBudget = 16 * 1024 * 1024;

  Future<Map<String, dynamic>?> read(String key) async {
    final entry = await database.translationEntrys.getByKey(key);
    if (entry == null) return null;
    try {
      return jsonDecode(entry.payload) as Map<String, dynamic>;
    } catch (_) {
      // Corrupt receipts must not look like an absent, safe-to-submit request.
      throw const TranslationFailure('OUTCOME_UNKNOWN');
    }
  }

  Future<List<Map<String, dynamic>>> entries(String scope, String kind) async {
    final entries = await database.translationEntrys
        .filter()
        .scopeEqualTo(scope)
        .kindEqualTo(kind)
        .findAll();
    return entries
        .map((e) => jsonDecode(e.payload) as Map<String, dynamic>)
        .toList();
  }

  Future<void> write(
    String key,
    String scope,
    String kind,
    Map<String, dynamic> value,
  ) => writeBatch([(key, scope, kind, value)]);

  /// Binding and operation are one commit; a crash cannot hide an intent and
  /// cause the next visit to allocate another operation ID.
  Future<void> writeBatch(
    List<(String, String, String, Map<String, dynamic>)> values,
  ) => _writes.run(
    () => database.writeTxn(() async {
      for (final (key, scope, kind, value) in values) {
        final payload = jsonEncode(value);
        final old = await database.translationEntrys.getByKey(key);
        final size = await database.translationEntrys.getSize();
        if (size + payload.length * 3 - (old?.payload.length ?? 0) * 3 >
            metadataBudget) {
          throw const TranslationFailure('STORAGE_FULL');
        }
        final entry = TranslationEntry()
          ..id = old?.id ?? Isar.autoIncrement
          ..key = key
          ..scope = scope
          ..kind = kind
          ..payload = payload
          ..updatedAt = DateTime.now().millisecondsSinceEpoch;
        await database.translationEntrys.put(entry);
      }
    }),
  );

  Future<void> remove(String key) => _writes.run(
    () => database.writeTxn(() async {
      await database.translationEntrys.deleteByKey(key);
    }),
  );

  File file(String kind, String key) {
    if (!const {'input', 'result', 'source'}.contains(kind) ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(key)) {
      throw const TranslationFailure('INVALID_RESULT');
    }
    return File('${directory.path}/$kind/$key');
  }

  Future<File> publish(String kind, String key, File input, {int? epoch}) =>
      _files.run(() async {
        final target = file(kind, key);
        if (epoch != null && epoch != cacheEpoch) {
          throw const TranslationCancelled();
        }
        await target.parent.create(recursive: true);
        final length = await input.length();
        final incoming =
            length - (await target.exists() ? await target.length() : 0);
        if (kind == 'input' || kind == 'result') {
          await _evict(kind, incoming, target.path);
        }
        final temp = File('${target.path}.${translationUuid()}.tmp');
        try {
          final sink = temp.openWrite();
          try {
            await sink.addStream(input.openRead());
            await sink.flush();
          } finally {
            await sink.close();
          }
          if (epoch != null && epoch != cacheEpoch) {
            throw const TranslationCancelled();
          }
          await temp.rename(target.path);
          return target;
        } finally {
          if (await temp.exists()) await temp.delete();
        }
      });

  Future<int> diskSize(String kind) async {
    final dir = Directory('${directory.path}/$kind');
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final item in dir.list()) {
      if (item is File) total += await item.length();
    }
    return total;
  }

  void Function() retain(File file) {
    final path = file.path;
    _leases[path] = (_leases[path] ?? 0) + 1;
    var released = false;
    return () {
      if (released) return;
      released = true;
      final count = (_leases[path] ?? 1) - 1;
      if (count > 0) {
        _leases[path] = count;
      } else {
        _leases.remove(path);
        if (_deleted.remove(path)) file.delete().catchError((_) => file);
      }
    };
  }

  Future<void> deleteFile(File file) async {
    if (_leases.containsKey(file.path)) {
      _deleted.add(file.path);
    } else if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> clearResults() {
    cacheEpoch++;
    return _files.run(() async {
      final dir = Directory('${directory.path}/result');
      if (!await dir.exists()) return;
      await for (final file in dir.list()) {
        if (file is File) await deleteFile(file);
      }
    });
  }

  Future<void> _evict(String kind, int incoming, String target) async {
    final budget = kind == 'input' ? inputBudget : resultBudget;
    if (incoming > budget) throw const TranslationFailure('STORAGE_FULL');
    final pinned = <String>{target, ..._leases.keys};
    if (kind == 'input') {
      final active = await database.translationEntrys
          .filter()
          .kindEqualTo('active')
          .findAll();
      for (final entry in active) {
        final value = jsonDecode(entry.payload) as Map<String, dynamic>;
        pinned.add(file('input', value['inputKey'] as String).path);
      }
    }
    final dir = Directory('${directory.path}/$kind');
    if (!await dir.exists()) return;
    final files = <(File, FileStat)>[];
    var size = 0;
    await for (final file in dir.list()) {
      if (file is! File) continue;
      final stat = await file.stat();
      size += stat.size;
      if (!pinned.contains(file.path)) files.add((file, stat));
    }
    files.sort((a, b) => a.$2.modified.compareTo(b.$2.modified));
    for (final item in files) {
      if (size + incoming <= budget) break;
      await item.$1.delete();
      size -= item.$2.size;
    }
    if (size + incoming > budget) {
      throw const TranslationFailure('STORAGE_FULL');
    }
  }
}
