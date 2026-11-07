import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/repositories/translation_repository.dart';

import '../../contracts.dart';
import '../../identity.dart';
import '../../image_work.dart';
import 'http.dart';
import 'receipt.dart';
import 'protocol.dart';

class NodeLaneChannel implements TranslationChannel {
  NodeLaneChannel({
    required this.base,
    required this.userId,
    required this.accessToken,
    required this.repository,
    required this.images,
    this.allowLocalTestServer = false,
  });
  final Uri base;
  final String userId;
  final Future<String> Function() accessToken;
  final TranslationRepository repository;
  final TranslationImageWork images;
  final bool allowLocalTestServer;
  @override
  String get id => 'nodelane';
  @override
  String get label => 'NodeLane 官方';
  @override
  String get scope => translationKey([
    'nodelane',
    base.toString(),
    userId,
    nodeLaneTranslationProtocol,
  ]);
  @override
  ChannelRuntime createRuntime(TranslationOptions options) => OfficialRuntime(
    scope: scope,
    options: options,
    repository: repository,
    images: images,
    api: NodeLaneHttp(
      base,
      token: accessToken,
      allowLocalTestServer: allowLocalTestServer,
    ),
  );
}

class OfficialRuntime implements ChannelRuntime {
  OfficialRuntime({
    required this.scope,
    required this.options,
    required this.repository,
    required this.images,
    required this.api,
  });
  final String scope;
  final TranslationOptions options;
  final TranslationRepository repository;
  final TranslationImageWork images;
  final NodeLaneHttp api;
  final _updates = StreamController<void>.broadcast();
  final _windows = <String, List<TranslationTarget>>{};
  final _automatic = <String>{};
  final _requested = <String>{};
  final _receipts = <String, OfficialReceipt>{};
  final _states = <String, PageTranslationState>{};
  final _jobs = <String, TranslationCancellation>{};
  final _handled = <String>{};
  final _verified = <String>{};
  final _sourceChecked = <String>{};
  final _manual = <String, TranslationCancellation>{};
  final _control = DbWriteQueue();
  final _resultQueue = DbWriteQueue();
  final _resultJobs = <String, Future<(File, int, int)>>{};
  final _resultCancellations = <String, TranslationCancellation>{};
  final _life = TranslationCancellation();
  Map<String, dynamic>? _policy;
  DateTime? _policyTime, _retryAt;
  Timer? _retryTimer, _watchTimer;
  StreamSubscription<Map<String, dynamic>>? _subscription;
  TranslationCancellation? _watchCancellation;
  String _watchIds = '';
  int _failures = 0;

  @override
  Stream<void> get changes => _updates.stream;
  Map<String, TranslationTarget> get _wanted => {
    for (final window in _windows.values)
      for (final target in window) target.page.identity: target,
  };
  Set<String> get _scheduled => {
    for (final consumer in _automatic)
      for (final target in _windows[consumer] ?? <TranslationTarget>[])
        target.page.identity,
    ..._requested,
  };
  String _binding(TranslationPage page) =>
      'binding:${translationKey([scope, page.key, options.language])}';
  String _operation(String id) => 'operation:$scope:$id';
  @override
  PageTranslationState stateFor(TranslationPage page) =>
      _states[page.identity] ?? const PageTranslationState();

  void _notify() {
    if (!_life.isCancelled) _updates.add(null);
  }

  void _show(TranslationPage page, PageTranslationState state) {
    if (_life.isCancelled) return;
    _states[page.identity] = state;
    if (_states.length > 128) {
      final wanted = _wanted;
      for (final key in _states.keys.toList()) {
        if (_states.length <= 128) break;
        if (!wanted.containsKey(key)) _states.remove(key);
      }
    }
    _notify();
  }

  Future<void> _save(OfficialReceipt receipt) => repository.write(
    _operation(receipt.id),
    scope,
    receipt.active || receipt.unknown ? 'active' : 'completed',
    receipt.toJson(),
  );

  Future<void> _bind(OfficialReceipt receipt) => repository.writeBatch([
    (_operation(receipt.id), scope, 'active', receipt.toJson()),
    (receipt.key, scope, 'binding', <String, dynamic>{'id': receipt.id}),
  ]);

  Future<OfficialReceipt?> _load(TranslationPage page) async {
    final known = _receipts[page.key];
    if (known != null) return known;
    final binding = await repository.read(_binding(page));
    if (binding == null) return null;
    final data = await repository.read(_operation(binding['id'] as String));
    if (data == null) throw const TranslationFailure('OUTCOME_UNKNOWN');
    final receipt = OfficialReceipt.fromJson(data);
    if (receipt.scope != scope ||
        receipt.pageKey != page.key ||
        receipt.language != options.language) {
      throw const TranslationFailure('OUTCOME_UNKNOWN');
    }
    _life.check();
    // A concurrent restore or explicit action may already own a newer receipt.
    final current = _receipts.putIfAbsent(page.key, () => receipt);
    if (_receipts.length > 128) {
      final protected = _wanted.values.map((t) => t.page.key).toSet();
      for (final key in _receipts.keys.toList()) {
        if (_receipts.length <= 128) break;
        if (!protected.contains(key)) {
          _verified.remove(_receipts.remove(key)?.id);
        }
      }
    }
    return current;
  }

  @override
  Future<void> restore(List<TranslationTarget> targets) async {
    for (final target in targets.take(4)) {
      _life.check();
      final receipt = await _load(target.page);
      if (receipt != null && !_jobs.containsKey(target.page.identity)) {
        _project(target.page, receipt);
      }
    }
  }

  @override
  void setWindow(
    String consumer,
    List<TranslationTarget> targets, {
    bool automatic = true,
  }) {
    if (_life.isCancelled) return;
    final before = _wanted;
    final scheduledBefore = _scheduled;
    _windows[consumer] = targets.take(4).toList(growable: false);
    if (automatic) {
      _automatic.add(consumer);
    } else {
      _automatic.remove(consumer);
    }
    final wanted = _wanted;
    _requested.removeWhere((key) => !wanted.containsKey(key));
    final scheduled = _scheduled;
    for (final key in before.keys) {
      if (!wanted.containsKey(key) ||
          (scheduledBefore.contains(key) && !scheduled.contains(key))) {
        _jobs[key]?.cancel();
        _handled.remove(key);
        if (!wanted.containsKey(key)) {
          _sourceChecked.remove(key);
          final pageKey = before[key]!.page.key;
          if (!wanted.values.any((target) => target.page.key == pageKey)) {
            _manual[pageKey]?.cancel();
          }
        }
      }
    }
    if (wanted.isEmpty) {
      _stopWatching();
      _retryTimer?.cancel();
      for (final cancel in _resultCancellations.values) {
        cancel.cancel();
      }
    } else {
      _pump();
      _watch();
    }
  }

  @override
  void pause(String consumer) {
    setWindow(consumer, const [], automatic: false);
    _windows.remove(consumer);
  }

  void _pump() {
    if (_life.isCancelled || _wanted.isEmpty) return;
    if (_retryAt != null && DateTime.now().isBefore(_retryAt!)) {
      _armRetry();
      return;
    }
    final scheduled = _scheduled;
    for (final entry in _wanted.entries) {
      if (_jobs.length >= 2) break;
      if (!scheduled.contains(entry.key) ||
          _jobs.containsKey(entry.key) ||
          _handled.contains(entry.key)) {
        continue;
      }
      final cancel = TranslationCancellation();
      _jobs[entry.key] = cancel;
      _handled.add(entry.key);
      final unlink = _life.onCancel(cancel.cancel);
      _process(entry.value, cancel)
          .catchError((Object error) {
            final receipt = _receipts[entry.value.page.key];
            if (receipt != null) _verified.remove(receipt.id);
            if (cancel.isCancelled || error is TranslationCancelled) {
              if (_wanted.containsKey(entry.key) &&
                  !_scheduled.contains(entry.key)) {
                if (receipt == null) {
                  _show(entry.value.page, const PageTranslationState());
                } else if (!receipt.active) {
                  _project(entry.value.page, receipt);
                } else {
                  _show(
                    entry.value.page,
                    const PageTranslationState(
                      phase: TranslationPhase.uncertain,
                      message: '翻译已暂停，可核实进度',
                      actions: {TranslationAction.verify},
                    ),
                  );
                }
              }
              return;
            }
            final failure = error is TranslationFailure
                ? error
                : const TranslationFailure('NETWORK');
            _show(
              entry.value.page,
              PageTranslationState(
                phase: receipt?.active == true
                    ? TranslationPhase.uncertain
                    : TranslationPhase.failed,
                message: failure.message,
                actions:
                    failure.code == 'SOURCE_CHANGED' &&
                        receipt != null &&
                        !receipt.active &&
                        !receipt.unknown
                    ? const {TranslationAction.regenerate}
                    : const {TranslationAction.verify},
              ),
            );
            if (failure.code == 'NETWORK' || failure.code == 'RATE_LIMITED') {
              _backoff(failure.retryAfter);
            }
          })
          .whenComplete(() {
            unlink();
            _jobs.remove(entry.key);
            final receipt = _receipts[entry.value.page.key];
            if (cancel.isCancelled ||
                (receipt != null && !receipt.active && !receipt.unknown)) {
              _requested.remove(entry.key);
            }
            _pump();
          });
    }
  }

  void _backoff(Duration? duration) {
    _failures = (_failures + 1).clamp(1, 6);
    final retry = DateTime.now().add(
      duration ??
          Duration(
            milliseconds: ((1 << _failures) * (750 + Random().nextInt(500))),
          ),
    );
    if (_retryAt == null || retry.isAfter(_retryAt!)) _retryAt = retry;
    _armRetry();
  }

  void _armRetry() {
    _retryTimer?.cancel();
    if (_wanted.isEmpty || _retryAt == null) return;
    final wait = _retryAt!.difference(DateTime.now());
    _retryTimer = Timer(wait.isNegative ? Duration.zero : wait, () {
      _retryAt = null;
      for (final target in _wanted.values) {
        final receipt = _receipts[target.page.key];
        if (receipt == null || receipt.active) {
          _handled.remove(target.page.identity);
        }
      }
      _pump();
      _watch();
    });
  }

  Future<Map<String, dynamic>> _capabilities(
    TranslationCancellation cancel,
  ) async {
    if (_policy != null &&
        _policyTime != null &&
        DateTime.now().difference(_policyTime!) < const Duration(minutes: 5)) {
      return _policy!;
    }
    final value = await api.json(
      'GET',
      '/v1/capabilities',
      cancellation: cancel,
    );
    if (value['result_protocol'] != nodeLaneTranslationProtocol) {
      throw const TranslationFailure('CLIENT_UPGRADE_REQUIRED');
    }
    final modes = value['modes'];
    if (modes is! List ||
        !modes.any(
          (m) =>
              m is Map &&
              m['id'] == 'classic' &&
              m['enabled'] == true &&
              m['languages'] is List &&
              (m['languages'] as List).contains(options.language),
        )) {
      throw const TranslationFailure('UNSUPPORTED_LANGUAGE');
    }
    _policy = value;
    _policyTime = DateTime.now();
    return value;
  }

  Future<void> _reconcileCapacity(TranslationCancellation cancel) async {
    final entries = await repository.entries(scope, 'active');
    if (entries.length < 32) return;
    final receipts = entries.take(32).map(OfficialReceipt.fromJson).toList();
    final response = await api.json(
      'GET',
      '/v1/translations?${Uri(queryParameters: {'ids': receipts.map((r) => r.id).join(',')}).query}',
      cancellation: cancel,
    );
    final items = response['items'];
    if (items is! List || items.length > 32) {
      throw const TranslationFailure('INVALID_RESULT');
    }
    for (final value in items) {
      if (value is! Map<String, dynamic>) {
        throw const TranslationFailure('INVALID_RESULT');
      }
      final receipt = receipts.where((r) => r.id == value['id']).firstOrNull;
      if (receipt == null) {
        throw const TranslationFailure('INVALID_RESULT');
      }
      receipt.accept(value);
      await _save(receipt);
      if (_receipts[receipt.pageKey]?.id == receipt.id) {
        _receipts[receipt.pageKey] = receipt;
      }
    }
  }

  Future<void> _process(
    TranslationTarget target,
    TranslationCancellation cancel,
  ) async {
    var receipt = await _load(target.page);
    cancel.check();
    if (receipt == null) {
      _show(
        target.page,
        const PageTranslationState(
          phase: TranslationPhase.preparing,
          message: '准备翻译…',
        ),
      );
      final caps = await _capabilities(cancel);
      final original = await target.source.acquire(target.page, cancel);
      PreparedTranslationImage? input;
      try {
        cancel.check();
        input = await images.prepare(original.file, cancel);
        final limits = caps['limits'] as Map? ?? const {};
        if (input.byteSize >
                ((limits['max_bytes'] as num?)?.toInt() ?? 128 * 1024 * 1024) ||
            input.width >
                ((limits['max_dimension'] as num?)?.toInt() ?? 100000) ||
            input.height >
                ((limits['max_dimension'] as num?)?.toInt() ?? 100000)) {
          throw const TranslationFailure('RESOURCE_LIMIT');
        }
        receipt = await _control.run(() async {
          cancel.check();
          final existing = await _load(target.page);
          if (existing != null) return existing;
          await _reconcileCapacity(cancel);
          if ((await repository.entries(scope, 'active')).length >= 32) {
            throw const TranslationFailure('OUTCOME_UNKNOWN');
          }
          final frozen = input!;
          final inputKey = translationKey([
            scope,
            frozen.sha256,
            translationInputProfile,
          ]);
          await repository.publish('input', inputKey, frozen.file);
          cancel.check();
          final created = OfficialReceipt(
            id: translationUuid(),
            key: _binding(target.page),
            scope: scope,
            pageKey: target.page.key,
            revision: target.page.revision,
            language: options.language,
            inputKey: inputKey,
            inputSha: frozen.sha256,
            sourceSha: frozen.sourceSha256,
            width: frozen.width,
            height: frozen.height,
            mime: frozen.mime,
            request: {
              'image': frozen.descriptor,
              'mode': 'classic',
              'target_language': options.language,
            },
          );
          await _bind(created);
          _receipts[target.page.key] = created;
          _sourceChecked.add(target.page.identity);
          return created;
        });
      } finally {
        if (input != null && input.file.path != original.file.path) {
          await input.file.delete().catchError((_) => input!.file);
        }
        original.release();
      }
    }
    cancel.check();
    final current = receipt;
    if (current == null) return;
    // Always resolve an earlier sending attempt before considering current
    // source revisions. A refreshed locator must not create a new request.
    if (current.sent && current.active && !_verified.contains(current.id)) {
      final snapshot = await api.json(
        'GET',
        '/v1/translations/${current.id}',
        cancellation: cancel,
        allowMissing: true,
      );
      cancel.check();
      if (snapshot['missing'] == true) {
        if (current.accepted) {
          current.unavailable = true;
          await _save(current);
          throw const TranslationFailure('TRANSLATION_UNAVAILABLE');
        }
        current.sent = false;
        await _save(current);
      } else {
        current.accept(snapshot);
        await _save(current);
      }
      _verified.add(current.id);
    }
    // Before submitting or resuming a task, verify the original bytes. Cached
    // display is restored separately without submitting or uploading images.
    if (!_sourceChecked.contains(target.page.identity)) {
      _show(
        target.page,
        const PageTranslationState(
          phase: TranslationPhase.preparing,
          message: '核对原图…',
        ),
      );
      await _checkSource(target, current, cancel);
    }
    if (!current.sent) {
      await _control.run(() async {
        cancel.check();
        if (_retryAt != null && DateTime.now().isBefore(_retryAt!)) {
          throw TranslationFailure(
            'RATE_LIMITED',
            retryAfter: _retryAt!.difference(DateTime.now()),
          );
        }
        current.sent = true;
        await _save(
          current,
        ); // durable BEFORE dispatch; cancellation is unknown
        _show(
          target.page,
          const PageTranslationState(
            phase: TranslationPhase.submitting,
            message: '正在提交…',
          ),
        );
        final snapshot = await api.json(
          'PUT',
          '/v1/translations/${current.id}',
          body: current.request,
          cancellation: cancel,
        );
        cancel.check();
        current.accept(snapshot);
        await _save(current);
        _verified.add(current.id);
      });
    }
    _project(target.page, current);
    _watch();
    if (current.state == 'needs_input') {
      await _control.run(() async {
        cancel.check();
        final input = await _input(current, cancel);
        try {
          final snapshot = await api.upload(
            current.id,
            input.file,
            current.mime,
            cancel,
          );
          cancel.check();
          current.accept(snapshot);
          await _save(current);
        } finally {
          input.release();
        }
      });
      _project(target.page, current);
      _watch();
    }
  }

  Future<void> _checkSource(
    TranslationTarget target,
    OfficialReceipt receipt,
    TranslationCancellation cancel,
  ) async {
    final source = await target.source.acquire(target.page, cancel);
    try {
      if (await source.file.length() > 32 * 1024 * 1024 ||
          await imageDigest(source.file) != receipt.sourceSha) {
        throw const TranslationFailure('SOURCE_CHANGED');
      }
      cancel.check();
      receipt.revision = target.page.revision;
      await _save(receipt);
      _sourceChecked.add(target.page.identity);
    } finally {
      source.release();
    }
  }

  void _project(TranslationPage page, OfficialReceipt receipt) {
    if (page.revision != receipt.revision) {
      _show(
        page,
        const PageTranslationState(
          phase: TranslationPhase.failed,
          message: '原图已变化，请重新载入',
        ),
      );
      return;
    }
    final phase = receipt.unknown
        ? TranslationPhase.uncertain
        : switch (receipt.state) {
            'needs_input' => TranslationPhase.awaitingInput,
            'queued' => TranslationPhase.queued,
            'running' => TranslationPhase.running,
            'succeeded' => TranslationPhase.succeeded,
            'failed' => TranslationPhase.failed,
            'local' => TranslationPhase.preparing,
            _ => TranslationPhase.uncertain,
          };
    final original = receipt.result?['representation'] == 'original';
    _show(
      page,
      PageTranslationState(
        phase: phase,
        noText: original,
        result: phase == TranslationPhase.succeeded && !original
            ? TranslationResultRef(scope, receipt.id)
            : null,
        message: switch (phase) {
          TranslationPhase.awaitingInput => '上传原图…',
          TranslationPhase.queued => '等待翻译…',
          TranslationPhase.running => '正在翻译…',
          TranslationPhase.uncertain => '结果待核实',
          TranslationPhase.failed => TranslationFailure(
            receipt.errorCode ?? 'REMOTE_FAILED',
          ).message,
          TranslationPhase.succeeded =>
            receipt.resultExpired
                ? '译图已过期，请重新翻译'
                : receipt.result?['kind'] == 'partial'
                ? '部分内容已翻译'
                : '译图已就绪',
          _ => '',
        },
        actions: receipt.unknown
            ? const {TranslationAction.verify}
            : switch (phase) {
                TranslationPhase.succeeded when original => const {
                  TranslationAction.regenerate,
                },
                TranslationPhase.succeeded => const {
                  TranslationAction.readResult,
                  TranslationAction.regenerate,
                },
                TranslationPhase.failed =>
                  receipt.canRetry ? const {TranslationAction.retry} : const {},
                _ => const {TranslationAction.verify},
              },
      ),
    );
  }

  void _stopWatching() {
    _watchTimer?.cancel();
    _watchTimer = null;
    _watchCancellation?.cancel();
    _watchCancellation = null;
    _subscription?.cancel();
    _subscription = null;
    _watchIds = '';
  }

  void _watch() {
    if (_life.isCancelled ||
        _wanted.isEmpty ||
        (_retryAt != null && DateTime.now().isBefore(_retryAt!))) {
      return;
    }
    final ids =
        _wanted.values
            .map((t) => _receipts[t.page.key])
            .whereType<OfficialReceipt>()
            .where((r) => r.accepted && r.active && !r.unavailable)
            .map((r) => r.id)
            .toSet()
            .toList()
          ..sort();
    final signature = ids.join(',');
    if (signature == _watchIds) return;
    _stopWatching();
    if (ids.isEmpty) return;
    _watchIds = signature;
    final cancel = TranslationCancellation();
    _watchCancellation = cancel;
    final events = DbWriteQueue();
    _subscription = api
        .events(ids.take(32).toList(), cancel)
        .listen(
          (snapshot) {
            events
                .run(() async {
                  if (cancel.isCancelled) return;
                  final items = snapshot['items'];
                  if (items is! List || items.length > 32) {
                    throw const TranslationFailure('INVALID_RESULT');
                  }
                  for (final value in items) {
                    if (value is! Map<String, dynamic>) {
                      throw const TranslationFailure('INVALID_RESULT');
                    }
                    final matching = _receipts.values.where(
                      (r) => r.id == value['id'],
                    );
                    if (matching.isEmpty) continue;
                    final receipt = matching.first;
                    receipt.accept(value);
                    await _save(receipt);
                    for (final target in _wanted.values.where(
                      (t) => t.page.key == receipt.pageKey,
                    )) {
                      _project(target.page, receipt);
                      if (receipt.state == 'succeeded' ||
                          receipt.state == 'needs_input') {
                        _handled.remove(target.page.identity);
                      }
                    }
                  }
                  final missing = snapshot['missing_ids'];
                  if (missing is List) {
                    for (final receipt in _receipts.values.where(
                      (r) => missing.contains(r.id) && r.accepted,
                    )) {
                      receipt.unavailable = true;
                      await _save(receipt);
                      for (final target in _wanted.values.where(
                        (t) => t.page.key == receipt.pageKey,
                      )) {
                        _project(target.page, receipt);
                      }
                    }
                  }
                  _pump();
                  _watch();
                })
                .catchError((Object error) {
                  if (!cancel.isCancelled) {
                    _stopWatching();
                    _backoff(null);
                  }
                });
          },
          onError: (Object error) {
            if (!cancel.isCancelled) {
              _stopWatching();
              _backoff(error is TranslationFailure ? error.retryAfter : null);
            }
          },
          onDone: () {
            if (!cancel.isCancelled) {
              _watchIds = '';
              _watchTimer = Timer(const Duration(seconds: 2), _watch);
            }
          },
        );
  }

  @override
  Future<void> perform(
    TranslationTarget target,
    TranslationAction action,
  ) async {
    _life.check();
    if (!_wanted.containsKey(target.page.identity)) return;
    if (_manual.containsKey(target.page.key)) return;
    final cancel = TranslationCancellation();
    _manual[target.page.key] = cancel;
    final unlink = _life.onCancel(cancel.cancel);
    try {
      final previous = await _load(target.page);
      cancel.check();
      if (action == TranslationAction.readResult) {
        if (previous == null) return;
        final lease = await readResult(
          TranslationResultRef(scope, previous.id),
          cancel,
        );
        lease.release();
        _project(target.page, previous);
        return;
      }
      if (action == TranslationAction.retry ||
          action == TranslationAction.regenerate) {
        if (previous == null ||
            previous.active ||
            previous.unknown ||
            _jobs.containsKey(target.page.identity)) {
          throw const TranslationFailure('OUTCOME_UNKNOWN');
        }
        if ((action == TranslationAction.retry) !=
            (previous.state == 'failed')) {
          throw const TranslationFailure('OUTCOME_UNKNOWN');
        }
        if (action == TranslationAction.retry && !previous.canRetry) {
          throw TranslationFailure(previous.errorCode ?? 'REMOTE_FAILED');
        }
        if (!_sourceChecked.contains(target.page.identity) &&
            action == TranslationAction.regenerate) {
          try {
            await _checkSource(target, previous, cancel);
          } on TranslationFailure catch (failure) {
            if (failure.code != 'SOURCE_CHANGED') rethrow;
            // Explicitly translating changed bytes creates a new frozen input.
            await repository.remove(previous.key);
            _receipts.remove(target.page.key);
            cancel.check();
            _show(
              target.page,
              const PageTranslationState(phase: TranslationPhase.preparing),
            );
            _requested.add(target.page.identity);
            _handled.remove(target.page.identity);
            _pump();
            return;
          }
        }
        await _capabilities(cancel);
        final created = OfficialReceipt(
          id: translationUuid(),
          key: previous.key,
          scope: scope,
          pageKey: previous.pageKey,
          revision: previous.revision,
          language: previous.language,
          inputKey: previous.inputKey,
          inputSha: previous.inputSha,
          sourceSha: previous.sourceSha,
          width: previous.width,
          height: previous.height,
          mime: previous.mime,
          request: {
            action == TranslationAction.retry ? 'retry_of' : 'regenerate_of':
                previous.id,
          },
        );
        // Recover and check frozen input before creating the explicit new intent.
        final input = await _input(previous, cancel);
        try {
          cancel.check();
          await _bind(created);
          _receipts[target.page.key] = created;
          cancel.check();
        } finally {
          input.release();
        }
        _project(target.page, created);
      } else if (previous != null) {
        _verified.remove(previous.id);
      }
      _requested.add(target.page.identity);
      _handled.remove(target.page.identity);
      _pump();
    } finally {
      unlink();
      _manual.remove(target.page.key);
    }
  }

  @override
  Future<DisplayImageLease> readResult(
    TranslationResultRef result,
    TranslationCancellation cancellation,
  ) async {
    _life.check();
    cancellation.check();
    if (result.scope != scope) throw const TranslationFailure('AUTH_REQUIRED');
    var job = _resultJobs[result.operationId];
    if (job == null) {
      final cancel = TranslationCancellation();
      final unlink = _life.onCancel(cancel.cancel);
      _resultCancellations[result.operationId] = cancel;
      final epoch = repository.cacheEpoch;
      job = _resultQueue
          .run(() => _readResult(result, cancel, epoch))
          .whenComplete(() {
            unlink();
            _resultJobs.remove(result.operationId);
            _resultCancellations.remove(result.operationId);
          });
      _resultJobs[result.operationId] = job;
    }
    final (file, width, height) = await job;
    _life.check();
    cancellation.check();
    return DisplayImageLease(
      file: file,
      width: width,
      height: height,
      release: repository.retain(file),
    );
  }

  Future<(File, int, int)> _readResult(
    TranslationResultRef ref,
    TranslationCancellation cancel,
    int epoch,
  ) async {
    cancel.check();
    final data = await repository.read(_operation(ref.operationId));
    if (data == null) throw const TranslationFailure('RESULT_UNAVAILABLE');
    final receipt = OfficialReceipt.fromJson(data);
    if (receipt.scope != scope || receipt.state != 'succeeded') {
      throw const TranslationFailure('RESULT_UNAVAILABLE');
    }
    if (receipt.resultExpired && receipt.resultKey != null) {
      final cached = repository.file('result', receipt.resultKey!);
      if (await cached.exists() &&
          receipt.resultSha == await imageDigest(cached)) {
        cancel.check();
        if (epoch != repository.cacheEpoch) throw const TranslationCancelled();
        return (cached, receipt.width, receipt.height);
      }
    }
    if (receipt.result == null) {
      throw TranslationFailure(
        receipt.resultExpired ? 'RESULT_EXPIRED' : 'RESULT_UNAVAILABLE',
      );
    }
    final result = receipt.result!;
    if (result['normalization_version'] != 1 ||
        result['input_sha256'] != receipt.inputSha ||
        result['width'] != receipt.width ||
        result['height'] != receipt.height ||
        result['representation'] != 'overlay-v1' ||
        result['composite'] != 'source-atop' ||
        !const {'translated', 'partial'}.contains(result['kind'])) {
      throw const TranslationFailure('INVALID_RESULT');
    }
    final artifact = result['artifact'], box = result['bbox'];
    if (artifact is! Map ||
        box is! Map ||
        artifact['mime'] != 'image/webp' ||
        artifact['path'] != '/v1/translations/${receipt.id}/result' ||
        artifact['byte_size'] is! int ||
        (artifact['byte_size'] as int) <= 0 ||
        (artifact['byte_size'] as int) > TranslationRepository.inputBudget ||
        artifact['sha256'] is! String ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(artifact['sha256'] as String) ||
        !['x', 'y', 'width', 'height'].every((key) => box[key] is int) ||
        box['x'] < 0 ||
        box['y'] < 0 ||
        box['width'] < 1 ||
        box['height'] < 1 ||
        box['x'] + box['width'] > receipt.width ||
        box['y'] + box['height'] > receipt.height) {
      throw const TranslationFailure('INVALID_RESULT');
    }
    final key = translationKey([
      scope,
      receipt.id,
      artifact['sha256'],
      'mobile-png-composite-v1',
    ]);
    final cached = repository.file('result', key);
    if (receipt.resultKey == key &&
        await cached.exists() &&
        receipt.resultSha == await imageDigest(cached)) {
      cancel.check();
      if (epoch != repository.cacheEpoch) throw const TranslationCancelled();
      await cached.setLastModified(DateTime.now());
      return (cached, receipt.width, receipt.height);
    }
    final input = await _input(receipt, cancel);
    await images.temporary.create(recursive: true);
    final patch = File('${images.temporary.path}/${translationUuid()}.webp');
    File? complete;
    try {
      await api.download(
        receipt.id,
        patch,
        expectedSize: artifact['byte_size'] as int,
        mime: 'image/webp',
        cancellation: cancel,
      );
      if (await imageDigest(patch) != artifact['sha256']) {
        throw const TranslationFailure('INVALID_RESULT');
      }
      if ((await readImageHeader(patch)).mime != artifact['mime']) {
        throw const TranslationFailure('INVALID_RESULT');
      }
      cancel.check();
      complete = await images.composite(
        input: input.file,
        patch: patch,
        x: box['x'] as int,
        y: box['y'] as int,
        width: receipt.width,
        height: receipt.height,
        patchWidth: box['width'] as int,
        patchHeight: box['height'] as int,
        cancellation: cancel,
      );
      final digest = await imageDigest(complete);
      cancel.check();
      final file = await repository.publish(
        'result',
        key,
        complete,
        epoch: epoch,
      );
      cancel.check();
      receipt.resultKey = key;
      receipt.resultSha = digest;
      await _save(receipt);
      // Keep the live receipt in sync so a later status save cannot drop cache metadata.
      final live = _receipts[receipt.pageKey];
      if (live?.id == receipt.id) {
        live!.resultKey = key;
        live.resultSha = digest;
      }
      return (file, receipt.width, receipt.height);
    } finally {
      input.release();
      await patch.delete().catchError((_) => patch);
      if (complete != null) {
        await complete.delete().catchError((_) => complete!);
      }
    }
  }

  Future<OriginalImageLease> _input(
    OfficialReceipt receipt,
    TranslationCancellation cancel,
  ) async {
    var file = repository.file('input', receipt.inputKey);
    if (!await file.exists()) {
      final candidates = _wanted.values.where(
        (t) =>
            t.page.key == receipt.pageKey &&
            t.page.revision == receipt.revision,
      );
      if (candidates.isEmpty) throw const TranslationFailure('SOURCE_MISSING');
      final target = candidates.first;
      final original = await target.source.acquire(target.page, cancel);
      PreparedTranslationImage? prepared;
      try {
        if (await imageDigest(original.file) != receipt.sourceSha) {
          throw const TranslationFailure('SOURCE_CHANGED');
        }
        prepared = await images.prepare(original.file, cancel);
        if (prepared.sha256 != receipt.inputSha ||
            prepared.width != receipt.width ||
            prepared.height != receipt.height) {
          throw const TranslationFailure('SOURCE_CHANGED');
        }
        cancel.check();
        file = await repository.publish(
          'input',
          receipt.inputKey,
          prepared.file,
        );
      } finally {
        if (prepared != null && prepared.file.path != original.file.path) {
          await prepared.file.delete().catchError((_) => prepared!.file);
        }
        original.release();
      }
    }
    final release = repository.retain(file);
    try {
      if (await imageDigest(file) != receipt.inputSha) {
        throw const TranslationFailure('SOURCE_CHANGED');
      }
      cancel.check();
      await file.setLastModified(DateTime.now());
      return OriginalImageLease(file, release: release);
    } catch (_) {
      release();
      rethrow;
    }
  }

  @override
  Future<void> clearResults() async {
    for (final cancel in _resultCancellations.values) {
      cancel.cancel();
    }
    await repository.clearResults();
    _notify();
  }

  @override
  Future<void> dispose() async {
    _life.cancel();
    _stopWatching();
    _retryTimer?.cancel();
    _windows.clear();
    _automatic.clear();
    _requested.clear();
    _states.clear();
    _receipts.clear();
    api.close();
    await _updates.close();
  }
}
