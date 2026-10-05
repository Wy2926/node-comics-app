import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/translation_record.dart';
import 'package:mangayomi/repositories/translation_repository.dart';

import '../nodelane_auth_service.dart';
import '../nodelane_models.dart';
import 'official_translation_client.dart';
import 'translation_image_worker.dart';
import 'translation_types.dart';

class TranslationCoordinator extends ChangeNotifier {
  TranslationCoordinator({
    required this.auth,
    required Future<TranslationRepository> repository,
    OfficialTranslationClient? client,
    TranslationImageWorker? worker,
  }) : client = client ?? OfficialTranslationClient(auth),
       worker = worker ?? TranslationImageWorker() {
    auth.addListener(_accountChanged);
    ready = repository.then((repo) async {
      await repo.initialize();
      store = repo;
      _accountChanged();
      _notify();
      if (scope != null) unawaited(recover());
    });
  }
  final NodeLaneAuthService auth;
  final OfficialTranslationClient client;
  final TranslationImageWorker worker;
  late final Future<void> ready;
  TranslationRepository? store;
  String? _session;
  bool _disposed = false, _foreground = true;
  final _preparing = <String, Future<TranslationRecord>>{};
  final _running = <int, Future<void>>{};
  final _retries = <int, Future<void>>{};
  final _aborts = <Completer<void>>{};
  final _taskAborts = <int, Completer<void>>{};
  final _pins = <int, int>{};
  Future<void> _preparationTail = Future.value();
  final _lanes = <Future<void>>[Future.value(), Future.value()];
  int _nextLane = 0;
  final _originalPages = <String>{};
  String language = 'zh-Hans';
  List<String> get languages => _capabilities?.languages ?? [language];
  TranslationCapabilities? _capabilities;
  Future<TranslationCapabilities>? _capabilityRequest;
  Completer<void>? _monitorStop;
  String _monitorIds = '';
  String? get scope => auth.state.account == null
      ? null
      : translationKey([
          auth.state.account!.scopeKey,
          'official',
          'classic',
          inputPolicy,
        ]);
  bool get foreground => _foreground;
  bool get initialized => store != null;
  List<TranslationRecord> get records =>
      scope == null ? [] : store?.recent(scope!) ?? [];
  bool preparing(String key) => _preparing.containsKey('$scope/$language/$key');
  bool busy(int id) => _running.containsKey(id) || _retries.containsKey(id);
  List<TranslationRecord> forPage(String key) =>
      scope == null ? [] : store?.page(scope!, key, language) ?? [];
  bool showOriginal(String key) => _originalPages.contains(key);
  void toggleOriginal(String key) {
    if (!_originalPages.remove(key)) _originalPages.add(key);
    _notify();
  }

  void setLanguage(String value) {
    if (language == value) return;
    language = value;
    _originalPages.clear();
    _notify();
  }

  void pin(TranslationRecord record) {
    _pins.update(record.id, (n) => n + 1, ifAbsent: () => 1);
    unawaited(store!.touch(record));
  }

  void unpin(int id) {
    final count = _pins[id] ?? 0;
    if (count <= 1) {
      _pins.remove(id);
    } else {
      _pins[id] = count - 1;
    }
  }

  void setForeground(bool value) {
    if (_foreground == value) return;
    _foreground = value;
    if (!value) {
      _stop();
    } else {
      _refreshMonitor();
      unawaited(recover());
    }
    _notify();
  }

  void _accountChanged() {
    final session = auth.state.account?.sessionId;
    if (session == _session) return;
    _session = session;
    _capabilities = null;
    _capabilityRequest = null;
    _originalPages.clear();
    _stop();
    _notify();
    if (session != null && store != null) unawaited(recover());
  }

  void _stop() {
    _monitorStop?.complete();
    _monitorStop = null;
    _monitorIds = '';
    for (final stop in _aborts) {
      if (!stop.isCompleted) stop.complete();
    }
  }

  void _guard(String? session) {
    if (_disposed ||
        session == null ||
        session != auth.state.account?.sessionId) {
      throw const NodeLaneException('SESSION_CHANGED', '账户会话已变更。');
    }
    if (!_foreground) throw const NodeLaneException('SYNC_PAUSED', '同步已暂停。');
  }

  void _guardRecord(TranslationRecord record, String? session) {
    _guard(session);
    if (record.scope != scope ||
        store!.get(record.id)?.deliveryRevision != record.deliveryRevision) {
      throw const NodeLaneException('DELIVERY_CHANGED', '本地交付已变更。');
    }
  }

  Future<TranslationCapabilities> capabilities() async {
    if (_capabilities != null) return _capabilities!;
    final session = auth.state.account?.sessionId;
    final future = _capabilityRequest ??= client.capabilities();
    try {
      final value = await future;
      _guard(session);
      _capabilities = value;
      _notify();
      return value;
    } finally {
      if (identical(_capabilityRequest, future)) _capabilityRequest = null;
    }
  }

  Future<TranslationRecord> translate(
    TranslationPage page, {
    bool Function()? isWanted,
    bool newAttempt = false,
  }) {
    final key = '$scope/$language/${page.key}';
    final existing = _preparing[key];
    if (existing != null) return existing;
    if (_preparing.length >= 4) {
      return Future.error(
        const NodeLaneException('QUEUE_FULL', '请等待当前图片处理完成。'),
      );
    }
    final session = auth.state.account?.sessionId;
    final selectedLanguage = language;
    final selectedScope = scope;
    final future = _preparationTail.then(
      (_) => _prepare(
        page,
        session,
        selectedLanguage,
        selectedScope,
        isWanted,
        newAttempt,
      ),
    );
    _preparationTail = future.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    _preparing[key] = future;
    _notify();
    unawaited(
      future.then(
        (_) {
          _preparing.remove(key);
          _notify();
        },
        onError: (Object _, StackTrace _) {
          _preparing.remove(key);
          _notify();
        },
      ),
    );
    return future;
  }

  Future<TranslationRecord> _prepare(
    TranslationPage page,
    String? session,
    String selectedLanguage,
    String? selectedScope,
    bool Function()? isWanted,
    bool newAttempt,
  ) async {
    void guard() {
      _guard(session);
      if (isWanted?.call() == false) {
        throw const NodeLaneException('WINDOW_CHANGED', '已离开阅读窗口。');
      }
    }

    await ready;
    guard();
    final source = await page.openOriginal();
    guard();
    final sourceHash = (await sha256.bind(source.openRead()).first).toString();
    guard();
    final previous = store!
        .page(selectedScope!, page.key, selectedLanguage)
        .where((r) => r.sourceSha == sourceHash)
        .firstOrNull;
    if (previous != null && !newAttempt) {
      await _update(previous, (r) {
        r.locatorSignature = page.locatorSignature;
        if (r.remoteState == 'unsubmitted' && r.phase == 'cancelled') {
          r.cancelIntent = false;
        }
      }, session);
      await resume(previous.id, isWanted: isWanted);
      return store!.get(previous.id) ?? previous;
    }
    if (store!.pending(selectedScope).length >= 32) {
      throw const NodeLaneException('QUEUE_FULL', '请先同步或取消未完成任务。');
    }
    final caps = await capabilities();
    guard();
    if (!caps.languages.contains(selectedLanguage)) {
      throw const NodeLaneException('LANGUAGE_UNAVAILABLE', '当前语言不可用。');
    }
    final uuid = translationUuid();
    final temp = store!.file('$uuid.input.part');
    final input = store!.file('$uuid.input');
    try {
      await store!.reserveInput(
        (await source.length()).clamp(1, caps.maxBytes),
        protected: _running.keys.toSet(),
      );
      final info = await worker.prepare(
        source.path,
        temp.path,
        caps.maxBytes,
        caps.maxDimension,
      );
      guard();
      final format =
          (info['width'] as int) > 16383 || (info['height'] as int) > 16383
          ? 'overlay-tiles-v1'
          : 'overlay-v1';
      if (!caps.representations.contains(format)) {
        throw const NodeLaneException('IMAGE_DIMENSIONS_LIMIT', '服务暂不支持此长图。');
      }
      await store!.reserveInput(
        info['byte_size'] as int,
        protected: _running.keys.toSet(),
      );
      await temp.rename(input.path);
      guard();
      final record = TranslationRecord()
        ..uuid = uuid
        ..scope = selectedScope
        ..pageKey = page.key
        ..locatorSignature = page.locatorSignature
        ..language = selectedLanguage
        ..sourceSha = info['source_sha256'] as String
        ..inputSha = info['sha256'] as String
        ..inputPath = input.path
        ..inputMime = info['content_type'] as String
        ..inputBytes = info['byte_size'] as int
        ..width = info['width'] as int
        ..height = info['height'] as int
        ..sourceWidth = info['source_width'] as int
        ..sourceHeight = info['source_height'] as int
        ..resultFormat = format
        ..createdAt = DateTime.now().millisecondsSinceEpoch
        ..accessedAt = DateTime.now().millisecondsSinceEpoch;
      record.descriptorJson = jsonEncode({
        'image': {
          'sha256': record.inputSha,
          'byte_size': record.inputBytes,
          'content_type': record.inputMime,
          'normalization_version': 1,
        },
        'mode': 'classic',
        'target_language': selectedLanguage,
        'result_format': format,
      });
      final saved = await store!.insert(record, newAttempt: newAttempt);
      _guard(session);
      if (saved.uuid != uuid) await input.delete();
      await resume(saved.id, isWanted: isWanted);
      return store!.get(saved.id) ?? saved;
    } catch (_) {
      if (await temp.exists()) await temp.delete();
      // A published receipt owns its input even when admission failed.
      if (await input.exists() && !store!.owns(uuid)) await input.delete();
      rethrow;
    }
  }

  Future<void> resume(int id, {bool Function()? isWanted}) {
    final running = _running[id];
    if (running != null) return running;
    if (_running.length >= 32) return Future.value();
    final lane = _nextLane++ % _lanes.length;
    final session = auth.state.account?.sessionId;
    final future = _lanes[lane].then((_) => _drive(id, session, isWanted));
    _running[id] = future;
    _lanes[lane] = future.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    void done() {
      _running.remove(id);
      _notify();
      _refreshMonitor();
    }

    unawaited(
      future.then((_) => done(), onError: (Object _, StackTrace _) => done()),
    );
    return future;
  }

  Future<void> _drive(
    int id,
    String? session,
    bool Function()? isWanted,
  ) async {
    await ready;
    var record = store!.get(id);
    if (record == null || record.scope != scope) return;
    final revision = record.deliveryRevision;
    final stop = Completer<void>();
    _aborts.add(stop);
    _taskAborts[id] = stop;
    try {
      _guardRecord(record, session);
      if (record.published &&
          (record.original ||
              record.resultPath != null &&
                  await File(record.resultPath!).exists())) {
        return;
      }
      await _update(record, (r) {
        r.phase = 'syncing';
        r.errorCode = null;
      }, session);
      var snapshot = await client.lookup(record.uuid, abort: stop.future);
      _guardRecord(record, session);
      if (snapshot == null) {
        if (record.cancelIntent || isWanted?.call() == false) {
          await _update(record, (r) {
            r.phase = 'cancelled';
            r.cancelIntent = true;
          }, session);
          return;
        }
        await _verifyInput(record);
        _guardRecord(record, session);
        if (isWanted?.call() == false) {
          await _update(record, (r) {
            r.phase = 'cancelled';
            r.cancelIntent = true;
          }, session);
          return;
        }
        snapshot = await client.create(
          record.uuid,
          record.descriptorJson,
          abort: stop.future,
        );
      }
      _guardRecord(record, session);
      record = await _snapshot(record, snapshot, session) ?? record;
      if (record.cancelIntent) {
        if (['succeeded', 'failed'].contains(record.remoteState)) {
          record =
              await _update(record, (r) => r.cancelIntent = false, session) ??
              record;
        } else {
          final cancelled = await client.cancel(
            record.uuid,
            abort: stop.future,
          );
          _guardRecord(record, session);
          await _snapshot(record, cancelled, session);
          return;
        }
      }
      if (record.remoteState == 'needs_input') {
        await _verifyInput(record);
        _guardRecord(record, session);
        await _update(record, (r) => r.phase = 'uploading', session);
        snapshot = await client.upload(
          record.uuid,
          File(record.inputPath),
          record.inputMime,
          record.inputBytes,
          abort: stop.future,
        );
        _guardRecord(record, session);
        record = await _snapshot(record, snapshot, session) ?? record;
      }
      if (record.remoteState == 'succeeded') {
        await _materialize(record, session, stop.future);
      }
    } catch (error) {
      if (!_disposed && session == auth.state.account?.sessionId) {
        await store!.update(id, revision, (r) {
          r.errorCode = translationError(error);
          r.phase = 'paused';
        });
        _notify();
      }
    } finally {
      if (!stop.isCompleted) stop.complete();
      _aborts.remove(stop);
      _taskAborts.remove(id);
    }
  }

  Future<void> _verifyInput(TranslationRecord r) async {
    final file = File(r.inputPath);
    if (!await file.exists() ||
        await file.length() != r.inputBytes ||
        (await sha256.bind(file.openRead()).first).toString() != r.inputSha) {
      throw const NodeLaneException('LOCAL_INPUT_MISSING', '送译副本不可用。');
    }
  }

  Future<TranslationRecord?> _update(
    TranslationRecord r,
    void Function(TranslationRecord) change,
    String? session,
  ) async {
    _guardRecord(r, session);
    final result = await store!.update(r.id, r.deliveryRevision, (v) {
      _guard(session);
      change(v);
    });
    _notify();
    return result;
  }

  Future<TranslationRecord?> _snapshot(
    TranslationRecord r,
    Map<String, dynamic> snapshot,
    String? session,
  ) async {
    if (snapshot['id'] != r.uuid ||
        snapshot['image_sha256'] != r.inputSha ||
        snapshot['mode'] != 'classic' ||
        snapshot['target_language'] != r.language ||
        !const [
          'needs_input',
          'queued',
          'running',
          'succeeded',
          'failed',
          'needs_attention',
        ].contains(snapshot['state'])) {
      throw const FormatException('Task identity mismatch');
    }
    return _update(r, (v) {
      final state = snapshot['state'] as String;
      if (const ['succeeded', 'failed'].contains(v.remoteState) &&
          v.remoteState != state) {
        return;
      }
      // Persist only the protocol fields needed for recovery, never error messages/URLs.
      final raw = snapshot['result'] as Map?;
      final result = raw == null
          ? null
          : <String, dynamic>{
              for (final key in [
                'kind',
                'representation',
                'input_sha256',
                'normalization_version',
                'width',
                'height',
                'bbox',
                'composite',
                'artifact',
              ])
                key: raw[key],
            };
      if (result != null) {
        if (result['artifact'] is Map) {
          final a = result['artifact'] as Map;
          result['artifact'] = {
            for (final key in ['path', 'sha256', 'byte_size', 'mime'])
              key: a[key],
          };
        }
        if (result['bbox'] is Map) {
          final b = result['bbox'] as Map;
          result['bbox'] = {
            for (final key in ['x', 'y', 'width', 'height']) key: b[key],
          };
        }
        _validateResult(r, result);
      }
      v.remoteState = state;
      v.snapshotJson = jsonEncode({
        'id': r.uuid,
        'state': state,
        'result': result,
      });
      if (state != 'succeeded') {
        v.phase = state;
      } else if (!v.published) {
        v.phase = 'downloading';
      }
      final code = (snapshot['error'] as Map?)?['code'];
      v.errorCode =
          code is String && RegExp(r'^[A-Z][A-Z0-9_]{0,59}$').hasMatch(code)
          ? code
          : null;
    }, session);
  }

  void _validateResult(TranslationRecord r, Map<String, dynamic> result) {
    if (!['translated', 'partial', 'no_text'].contains(result['kind'])) {
      throw const FormatException('Result kind mismatch');
    }
    if (result['input_sha256'] != r.inputSha ||
        result['normalization_version'] != 1 ||
        result['width'] != r.width ||
        result['height'] != r.height) {
      throw const FormatException('Result identity mismatch');
    }
    final representation = result['representation'];
    if (representation == 'original') {
      if (result['artifact'] != null) {
        throw const FormatException('Unexpected artifact');
      }
      return;
    }
    if (!['overlay-v1', 'overlay-tiles-v1'].contains(representation) ||
        representation == 'overlay-tiles-v1' &&
            r.resultFormat != 'overlay-tiles-v1' ||
        result['composite'] != 'source-atop') {
      throw const FormatException('Result representation mismatch');
    }
    final a = result['artifact'] as Map?;
    if (a == null ||
        a['path'] != '/v1/translations/${r.uuid}/result' ||
        a['mime'] !=
            (representation == 'overlay-v1'
                ? 'image/webp'
                : 'application/vnd.nodelane.overlay-tiles')) {
      throw const FormatException('Artifact identity mismatch');
    }
  }

  Future<void> _materialize(
    TranslationRecord r,
    String? session,
    Future<void> abort,
  ) async {
    final result = Map<String, dynamic>.from(
      (jsonDecode(r.snapshotJson!) as Map)['result'] as Map,
    );
    _validateResult(r, result);
    if (result['representation'] == 'original') {
      await _update(r, (v) {
        v.phase = 'ready';
        v.original = true;
        v.published = true;
        v.errorCode = null;
      }, session);
      return;
    }
    await _verifyInput(r);
    final artifact = store!.file(
      '${r.uuid}.${r.deliveryRevision}.artifact.part',
    );
    final output = store!.file('${r.uuid}.${r.deliveryRevision}.png.part');
    try {
      await client.download(
        r.uuid,
        Map<String, dynamic>.from(result['artifact'] as Map),
        artifact,
        abort,
      );
      _guardRecord(r, session);
      await _update(r, (v) => v.phase = 'composing', session);
      final info = await worker.compose(
        r.inputPath,
        artifact.path,
        result,
        output.path,
      );
      _guardRecord(r, session);
      await store!.publish(r, output, info, () => _guard(session));
      _notify();
      await store!.evictResults({..._running.keys, ..._pins.keys});
    } finally {
      for (final f in [artifact, output]) {
        if (await f.exists()) await f.delete();
      }
    }
  }

  Future<void> recover() async {
    await ready;
    if (!_foreground || scope == null || _disposed) return;
    final pending = store!.pending(scope!);
    for (final r in pending) {
      if (!_foreground || scope != r.scope) break;
      await resume(r.id);
    }
    _refreshMonitor();
  }

  void _refreshMonitor() {
    if (_disposed || !_foreground || scope == null || store == null) return;
    final ids = store!
        .pending(scope!)
        .where(
          (r) =>
              ['queued', 'running', 'needs_attention'].contains(r.remoteState),
        )
        .take(32)
        .map((r) => r.uuid)
        .toList();
    final key = ids.join(',');
    if (key == _monitorIds) return;
    _monitorStop?.complete();
    _monitorStop = null;
    _monitorIds = key;
    if (ids.isEmpty) return;
    final stop = Completer<void>();
    _monitorStop = stop;
    unawaited(_monitor(ids, stop, auth.state.account!.sessionId));
  }

  Future<void> _monitor(
    List<String> ids,
    Completer<void> stop,
    String session,
  ) async {
    var delay = 2;
    while (!stop.isCompleted &&
        !_disposed &&
        _foreground &&
        session == auth.state.account?.sessionId) {
      try {
        await for (final payload in client.events(ids, stop.future)) {
          _guard(session);
          if (stop.isCompleted) break;
          for (final snapshot in (payload['items'] as List? ?? [])) {
            final row = store!
                .pending(scope!)
                .where((r) => r.uuid == (snapshot as Map)['id'])
                .firstOrNull;
            if (row == null) continue;
            final saved = await _snapshot(
              row,
              Map<String, dynamic>.from(snapshot as Map),
              session,
            );
            if (saved?.remoteState == 'succeeded' ||
                saved?.remoteState == 'needs_input') {
              unawaited(resume(row.id));
            }
          }
          _refreshMonitor();
          delay = 2;
        }
      } catch (error) {
        if (error is NodeLaneException && error.retryAfterSeconds != null) {
          delay = error.retryAfterSeconds!.clamp(2, 300);
        }
      }
      if (stop.isCompleted) break;
      await Future.any([
        Future<void>.delayed(Duration(seconds: delay)),
        stop.future,
      ]);
      if (stop.isCompleted) break;
      // Reconcile original UUIDs before a bounded SSE reconnect.
      for (final id in ids) {
        if (stop.isCompleted) break;
        final row = records.where((r) => r.uuid == id).firstOrNull;
        if (row != null) await resume(row.id);
      }
      delay = (delay * 2).clamp(2, 60);
    }
  }

  Future<void> cancel(int id) async {
    await ready;
    final r = store!.get(id);
    if (r == null || r.scope != scope) return;
    await store!.update(id, r.deliveryRevision, (v) {
      v.deliveryRevision++;
      v.cancelIntent = true;
      v.phase = 'cancelling';
    });
    final abort = _taskAborts[id];
    if (abort != null && !abort.isCompleted) abort.complete();
    _notify();
    await _running[id];
    await resume(id);
  }

  Future<void> retry(int id) {
    if (_retries[id] != null) return _retries[id]!;
    if (_retries.length >= 4) {
      return Future.error(
        const NodeLaneException('QUEUE_FULL', '请等待当前图片处理完成。'),
      );
    }
    final future = _preparationTail.then((_) => _retry(id));
    _retries[id] = future;
    _notify();
    _preparationTail = future.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    void done() {
      _retries.remove(id);
      _notify();
    }

    unawaited(
      future.then((_) => done(), onError: (Object _, StackTrace _) => done()),
    );
    return future;
  }

  Future<void> _retry(int id) async {
    await ready;
    final parent = store!.get(id);
    if (parent == null || parent.scope != scope) return;
    if (!['succeeded', 'failed'].contains(parent.remoteState)) return;
    final session = auth.state.account?.sessionId;
    _guard(session);
    final newest = store!
        .page(parent.scope, parent.pageKey, parent.language)
        .where((r) => r.sourceSha == parent.sourceSha)
        .firstOrNull;
    if (newest != null && newest.id != parent.id) {
      await resume(newest.id);
      return;
    }
    final uuid = translationUuid();
    final input = store!.file('$uuid.input');
    await _verifyInput(parent);
    await store!.reserveInput(
      parent.inputBytes,
      protected: {parent.id, ..._running.keys},
    );
    await File(parent.inputPath).copy(input.path);
    _guard(session);
    final r = TranslationRecord()
      ..uuid = uuid
      ..scope = parent.scope
      ..pageKey = parent.pageKey
      ..locatorSignature = parent.locatorSignature
      ..language = parent.language
      ..sourceSha = parent.sourceSha
      ..inputSha = parent.inputSha
      ..inputPath = input.path
      ..inputMime = parent.inputMime
      ..inputBytes = parent.inputBytes
      ..width = parent.width
      ..height = parent.height
      ..sourceWidth = parent.sourceWidth
      ..sourceHeight = parent.sourceHeight
      ..resultFormat = parent.resultFormat
      ..createdAt = DateTime.now().millisecondsSinceEpoch
      ..accessedAt = DateTime.now().millisecondsSinceEpoch
      ..descriptorJson = jsonEncode({
        parent.remoteState == 'succeeded' ? 'regenerate_of' : 'retry_of':
            parent.uuid,
      });
    final saved = await store!.insert(r, newAttempt: true);
    await resume(saved.id);
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _stop();
    auth.removeListener(_accountChanged);
    super.dispose();
  }
}
