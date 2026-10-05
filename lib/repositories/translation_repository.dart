import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:mangayomi/models/translation_record.dart';
import 'package:mangayomi/modules/nodelane/nodelane_models.dart';

import 'db_write_queue.dart';

/// One collection is both the durable receipt and the complete-image index.
class TranslationRepository {
  TranslationRepository(this.db, this.directory);
  final Isar db;
  final Directory directory;
  static const inputBudget = 256 * 1024 * 1024;
  static const resultBudget = 512 * 1024 * 1024;

  Future<void> initialize() async {
    await directory.create(recursive: true);
    final refs = <String>{};
    for (final r in await db.translationRecords.where().findAll()) {
      refs.add(r.inputPath);
      if (r.resultPath != null) refs.add(r.resultPath!);
    }
    final cutoff = DateTime.now().subtract(const Duration(days: 1));
    await for (final f in directory.list()) {
      if (f is File &&
          !refs.contains(f.path) &&
          (await f.stat()).modified.isBefore(cutoff)) {
        await f.delete();
      }
    }
  }

  File file(String name) => File('${directory.path}/$name');
  TranslationRecord? get(int id) => db.translationRecords.getSync(id);
  List<TranslationRecord> page(String scope, String key, String language) => db
      .translationRecords
      .where(sort: Sort.desc)
      .anyId()
      .filter()
      .scopeEqualTo(scope)
      .pageKeyEqualTo(key)
      .languageEqualTo(language)
      .findAllSync();
  List<TranslationRecord> recent(String scope) => db.translationRecords
      .where(sort: Sort.desc)
      .anyId()
      .filter()
      .scopeEqualTo(scope)
      .limit(100)
      .findAllSync();
  List<TranslationRecord> pending(String scope) => db.translationRecords
      .where()
      .filter()
      .scopeEqualTo(scope)
      .publishedEqualTo(false)
      .not()
      .remoteStateEqualTo('failed')
      .not()
      .phaseEqualTo('cancelled')
      .limit(32)
      .findAllSync();
  bool owns(String uuid) =>
      db.translationRecords.where().uuidEqualTo(uuid).findFirstSync() != null;
  Future<TranslationRecord> insert(
    TranslationRecord record, {
    bool newAttempt = false,
  }) => dbWriteQueue.run(
    () => db.writeTxn(() async {
      if (!newAttempt) {
        final existing = await db.translationRecords
            .where(sort: Sort.desc)
            .anyId()
            .filter()
            .scopeEqualTo(record.scope)
            .pageKeyEqualTo(record.pageKey)
            .languageEqualTo(record.language)
            .sourceShaEqualTo(record.sourceSha)
            .findFirst();
        if (existing != null) return existing;
      }
      record.id = await db.translationRecords.put(record);
      return record;
    }),
  );
  Future<TranslationRecord?> update(
    int id,
    int revision,
    void Function(TranslationRecord) change,
  ) => dbWriteQueue.run(
    () => db.writeTxn(() async {
      final record = await db.translationRecords.get(id);
      if (record == null || record.deliveryRevision != revision) return null;
      change(record);
      await db.translationRecords.put(record);
      return record;
    }),
  );
  Future<void> publish(
    TranslationRecord record,
    File temporary,
    Map<String, dynamic> info,
    void Function() guard,
  ) async {
    guard();
    final target = file('${record.uuid}.${record.deliveryRevision}.png');
    await temporary.rename(target.path);
    try {
      final saved = await update(record.id, record.deliveryRevision, (r) {
        guard();
        r.phase = 'ready';
        r.resultPath = target.path;
        r.resultSha = info['sha256'] as String;
        r.resultBytes = info['byte_size'] as int;
        r.published = true;
        r.errorCode = null;
        r.accessedAt = DateTime.now().millisecondsSinceEpoch;
      });
      if (saved == null && await target.exists()) await target.delete();
    } catch (_) {
      if (await target.exists()) await target.delete();
      rethrow;
    }
  }

  Future<void> touch(TranslationRecord record) => update(
    record.id,
    record.deliveryRevision,
    (r) => r.accessedAt = DateTime.now().millisecondsSinceEpoch,
  );
  Future<void> reserveInput(int bytes, {Set<int> protected = const {}}) async {
    final records = await db.translationRecords
        .where()
        .sortByAccessedAt()
        .findAll();
    var used = 0;
    final candidates = <TranslationRecord>[];
    for (final r in records) {
      if (!await File(r.inputPath).exists()) continue;
      used += r.inputBytes;
      if (!protected.contains(r.id) &&
          r.published &&
          (r.original ||
              r.resultPath != null && await File(r.resultPath!).exists())) {
        candidates.add(r);
      }
    }
    for (final r in candidates) {
      if (used + bytes <= inputBudget) break;
      await File(r.inputPath).delete();
      used -= r.inputBytes;
    }
    if (used + bytes > inputBudget) {
      throw const NodeLaneException('STORAGE_FAILED', '送译缓存空间不足。');
    }
  }

  Future<void> evictResults(Set<int> protected) async {
    final records = await db.translationRecords
        .where()
        .sortByAccessedAt()
        .findAll();
    var size = records.fold<int>(0, (n, r) => n + r.resultBytes);
    for (final r in records) {
      if (size <= resultBudget) break;
      if (r.resultPath == null || protected.contains(r.id)) continue;
      final path = r.resultPath!;
      final saved = await update(r.id, r.deliveryRevision, (v) {
        v.deliveryRevision++;
        v.phase = 'evicted';
        v.resultPath = null;
        v.resultBytes = 0;
      });
      if (saved != null) {
        size -= r.resultBytes;
        final f = File(path);
        if (await f.exists()) await f.delete();
      }
    }
  }
}
