import 'package:mangayomi/utils/localized_message.dart';

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/repositories/translation_repository.dart';

import '../../contracts.dart';
import '../../identity.dart';
import '../../image_work.dart';
import '../../languages.dart';
import '../../source_images.dart';
import 'http.dart';
import 'receipt.dart';
import 'protocol.dart';
import 'overlay_tiles.dart';

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
  String get label =>
      localizedMessage((l10n) => l10n.translation_official_channel);
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
  final _sources = SourceImages();
  Future<void>? _bindingsReady;
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
  String _binding(String sha, String language) =>
      'binding:${translationKey([scope, sha, language])}';
  OfficialReceipt? _receiptFor(TranslationPage page) =>
      _receipts[_sources.hashFor(page)];
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

  // One local upgrade preserves prior UUIDs/results and removes slot bindings.
  // It is not part of normal per-image lookup or remote task admission.
  Future<void> _indexImages() async {
    final marker = 'image-bindings:$scope';
    if (await repository.read(marker) != null) return;
    final records = [
      ...await repository.entries(scope, 'completed'),
      ...await repository.entries(scope, 'active'),
    ];
    records.sort((a, b) {
      final left = OfficialReceipt.fromJson(a),
          right = OfficialReceipt.fromJson(b);
      final active = (left.active || left.unknown ? 1 : 0).compareTo(
        right.active || right.unknown ? 1 : 0,
      );
      return active != 0
          ? active
          : '${left.snapshot?['updated_at'] ?? ''}'.compareTo(
              '${right.snapshot?['updated_at'] ?? ''}',
            );
    });
    final values = <(String, String, String, Map<String, dynamic>)>[];
    final oldKeys = <String>{};
    for (final data in records) {
      oldKeys.add(data['key'] as String);
      data['key'] = _binding(
        data['sourceSha'] as String,
        data['language'] as String,
      );
      final receipt = OfficialReceipt.fromJson(data);
      values.add((
        _operation(receipt.id),
        scope,
        receipt.active || receipt.unknown ? 'active' : 'completed',
        receipt.toJson(),
      ));
      values.add((receipt.key, scope, 'binding', {'id': receipt.id}));
    }
    values.add((marker, scope, 'metadata', {'version': 1}));
    await repository.writeBatch(values, remove: oldKeys);
  }

  Future<OfficialReceipt?> _load(
    TranslationTarget target,
    TranslationCancellation cancel,
  ) async {
    final original = await _sources.acquire(target, cancel);
    final sha = original.sha;
    original.release();
    await (_bindingsReady ??= _indexImages().catchError((Object error) {
      _bindingsReady = null;
      throw error;
    }));
    cancel.check();
    final known = _receipts[sha];
    if (known != null) return known;
    final binding = await repository.read(_binding(sha, options.language));
    if (binding == null) return null;
    final data = await repository.read(_operation(binding['id'] as String));
    if (data == null) throw const TranslationFailure('OUTCOME_UNKNOWN');
    final receipt = OfficialReceipt.fromJson(data);
    if (receipt.scope != scope ||
        receipt.sourceSha != sha ||
        receipt.language != options.language) {
      throw const TranslationFailure('OUTCOME_UNKNOWN');
    }
    _life.check();
    // A concurrent restore or explicit action may already own a newer receipt.
    final current = _receipts.putIfAbsent(sha, () => receipt);
    if (_receipts.length > 128) {
      final protected = _wanted.values
          .map((t) => _sources.hashFor(t.page))
          .toSet();
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
      if (!_wanted.containsKey(target.page.identity)) continue;
      try {
        final receipt = await _load(target, _life);
        if (receipt != null &&
            _wanted.containsKey(target.page.identity) &&
            !_jobs.containsKey(target.page.identity)) {
          _project(target.page, receipt);
        }
      } on TranslationCancelled {
        // The new reading window owns its own source and display.
      } on TranslationFailure catch (failure) {
        if (_wanted.containsKey(target.page.identity) &&
            !_jobs.containsKey(target.page.identity)) {
          final unknown = failure.code == 'OUTCOME_UNKNOWN';
          _show(
            target.page,
            PageTranslationState(
              phase: unknown
                  ? TranslationPhase.uncertain
                  : TranslationPhase.failed,
              message: failure.message,
              actions: {
                unknown ? TranslationAction.verify : TranslationAction.retry,
              },
            ),
          );
        }
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
    _sources.retain(wanted.values.map((target) => target.page));
    final visibleHashes = wanted.values
        .map((target) => _sources.hashFor(target.page))
        .toSet();
    for (final entry in _manual.entries) {
      if (!visibleHashes.contains(entry.key) &&
          !wanted.containsKey(entry.key)) {
        entry.value.cancel();
      }
    }
    for (final key in wanted.keys.where((key) => !before.containsKey(key))) {
      _states.remove(key);
    }
    for (final key in before.keys) {
      if (!wanted.containsKey(key) ||
          (scheduledBefore.contains(key) && !scheduled.contains(key))) {
        _jobs[key]?.cancel();
        _handled.remove(key);
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
            final receipt = _receiptFor(entry.value.page);
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
                    PageTranslationState(
                      phase: TranslationPhase.uncertain,
                      message: localizedMessage(
                        (l10n) => l10n.translation_paused,
                      ),
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
            final local =
                (receipt == null || !receipt.sent) &&
                failure.code != 'OUTCOME_UNKNOWN';
            _show(
              entry.value.page,
              PageTranslationState(
                phase:
                    !local &&
                        (receipt?.active == true ||
                            receipt?.unknown == true ||
                            failure.code == 'OUTCOME_UNKNOWN')
                    ? TranslationPhase.uncertain
                    : TranslationPhase.failed,
                message: failure.message,
                actions: local
                    ? const {TranslationAction.retry}
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
            final receipt = _receiptFor(entry.value.page);
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
        final receipt = _receiptFor(target.page);
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
    final mode = modes is List
        ? modes.whereType<Map>().where((m) => m['id'] == 'classic').firstOrNull
        : null;
    if (mode == null || mode['enabled'] != true) {
      throw const TranslationFailure('TRANSLATION_MODE_UNAVAILABLE');
    }
    final languages = mode['languages'];
    if (languages is List
        ? !languages.contains(options.language)
        : !translationLanguageNames.containsKey(options.language)) {
      throw const TranslationFailure('UNSUPPORTED_LANGUAGE');
    }
    _policy = value;
    _policyTime = DateTime.now();
    return value;
  }

  Future<void> _process(
    TranslationTarget target,
    TranslationCancellation cancel,
  ) async {
    if (_receiptFor(target.page) == null) {
      _show(
        target.page,
        PageTranslationState(
          phase: TranslationPhase.preparing,
          message: localizedMessage(
            (l10n) => l10n.translation_preparing_ellipsis,
          ),
        ),
      );
    }
    var receipt = await _load(target, cancel);
    cancel.check();
    if (receipt == null) {
      final capabilities = await _capabilities(cancel);
      final original = await _sources.acquire(target, cancel);
      PreparedTranslationImage? input;
      try {
        cancel.check();
        input = await images.prepare(
          original.file,
          cancel,
          sourceSha: original.sha,
        );
        final format = nodeLaneResultFormat(
          capabilities,
          input.width,
          input.height,
        );
        receipt = await _control.run(() async {
          cancel.check();
          final existing = await _load(target, cancel);
          if (existing != null) return existing;
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
            key: _binding(original.sha, options.language),
            scope: scope,
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
              'result_format': ?format,
            },
          );
          await _bind(created);
          _receipts[original.sha] = created;
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
    // Content lookup keeps the same UUID across new locators and refreshes.
    if (current.sent && current.active && !_verified.contains(current.id)) {
      await _control.run(() async {
        cancel.check();
        // Another element may already be submitting this same image.
        if (!current.sent ||
            !current.active ||
            _verified.contains(current.id)) {
          return;
        }
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
      });
    }
    if (!current.sent) {
      await _control.run(() async {
        cancel.check();
        if (current.sent) return;
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
          PageTranslationState(
            phase: TranslationPhase.submitting,
            message: localizedMessage((l10n) => l10n.translation_submitting),
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
        if (current.state != 'needs_input') return;
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

  void _project(TranslationPage page, OfficialReceipt receipt) {
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
          TranslationPhase.awaitingInput => localizedMessage(
            (l10n) => l10n.translation_uploading_ellipsis,
          ),
          TranslationPhase.queued => localizedMessage(
            (l10n) => l10n.translation_waiting_ellipsis,
          ),
          TranslationPhase.running => localizedMessage(
            (l10n) => l10n.translation_running_ellipsis,
          ),
          TranslationPhase.uncertain => localizedMessage(
            (l10n) => l10n.translation_verify_result,
          ),
          TranslationPhase.failed => TranslationFailure(
            receipt.errorCode ?? 'REMOTE_FAILED',
          ).message,
          TranslationPhase.succeeded =>
            receipt.resultExpired
                ? localizedMessage((l10n) => l10n.translation_result_expired)
                : receipt.result?['kind'] == 'partial'
                ? localizedMessage((l10n) => l10n.translation_partial)
                : localizedMessage((l10n) => l10n.translation_ready),
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
            .map((t) => _receiptFor(t.page))
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
                      (t) => _sources.hashFor(t.page) == receipt.sourceSha,
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
                        (t) => _sources.hashFor(t.page) == receipt.sourceSha,
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
    final manualKey = _sources.hashFor(target.page) ?? target.page.identity;
    if (_manual.containsKey(manualKey)) return;
    final cancel = TranslationCancellation();
    _manual[manualKey] = cancel;
    final unlink = _life.onCancel(cancel.cancel);
    try {
      // A local read failure has no remote operation to verify. Let the normal
      // preparation path report another read failure or submit the new image.
      if (action == TranslationAction.retry &&
          _receiptFor(target.page) == null) {
        _policyTime = null;
        _requested.add(target.page.identity);
        _handled.remove(target.page.identity);
        _pump();
        return;
      }
      final previous = await _load(target, cancel);
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
      // Preparation retries resume the existing intent (if any), not retry_of.
      final retryPreparation =
          action == TranslationAction.retry &&
          (previous == null || !previous.sent);
      if (!retryPreparation &&
          (action == TranslationAction.retry ||
              action == TranslationAction.regenerate)) {
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
        _policyTime = null;
        final capabilities = await _capabilities(cancel);
        final format = nodeLaneResultFormat(
          capabilities,
          previous.width,
          previous.height,
        );
        final created = OfficialReceipt(
          id: translationUuid(),
          key: previous.key,
          scope: scope,
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
            'result_format': ?format,
          },
        );
        // Recover and check frozen input before creating the explicit new intent.
        final input = await _input(previous, cancel);
        try {
          cancel.check();
          await _bind(created);
          _receipts[previous.sourceSha] = created;
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
      _manual.remove(manualKey);
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
    // These are complete images validated before atomic publication. A cache
    // hit needs neither a source reread nor another hash/decode/composition.
    if (receipt.resultKey != null) {
      final cached = repository.file('result', receipt.resultKey!);
      if (await cached.exists()) {
        cancel.check();
        if (epoch != repository.cacheEpoch) throw const TranslationCancelled();
        await cached.setLastModified(DateTime.now());
        return (cached, receipt.displayWidth, receipt.displayHeight);
      }
    }
    if (receipt.result == null) {
      throw TranslationFailure(
        receipt.resultExpired ? 'RESULT_EXPIRED' : 'RESULT_UNAVAILABLE',
      );
    }
    final result = receipt.result!;
    final tiled = result['representation'] == overlayTilesFormat;
    final full = result['representation'] == 'full-image-v1';
    validateNodeLaneResult(
      result,
      id: receipt.id,
      inputSha: receipt.inputSha,
      width: receipt.width,
      height: receipt.height,
    );
    final artifact = result['artifact'];
    if (artifact is! Map) throw const TranslationFailure('RESULT_UNAVAILABLE');
    final width = result['width'] as int, height = result['height'] as int;
    final key = translationKey([
      scope,
      receipt.id,
      artifact['sha256'],
      'mobile-png-composite-v1',
    ]);
    await images.temporary.create(recursive: true);
    final patch = File(
      '${images.temporary.path}/${translationUuid()}.artifact',
    );
    OriginalImageLease? input;
    File? complete;
    try {
      if (!full) input = await _input(receipt, cancel);
      await api.download(
        receipt.id,
        patch,
        expectedSize: artifact['byte_size'] as int,
        mime: artifact['mime'] as String,
        cancellation: cancel,
      );
      if (await imageDigest(patch) != artifact['sha256']) {
        throw const TranslationFailure('INVALID_RESULT');
      }
      cancel.check();
      if (full) {
        complete = await images.decodeResult(
          patch,
          width: width,
          height: height,
          mime: artifact['mime'] as String,
          cancellation: cancel,
        );
      } else {
        final box = result['bbox'];
        final patches = tiled
            ? await readOverlayTiles(
                patch,
                inputSha: receipt.inputSha,
                width: width,
                height: height,
              )
            : <TranslationImagePatch>[
                (
                  x: box['x'] as int,
                  y: box['y'] as int,
                  width: box['width'] as int,
                  height: box['height'] as int,
                  offset: 0,
                  length: artifact['byte_size'] as int,
                  sha256: artifact['sha256'] as String,
                ),
              ];
        cancel.check();
        complete = await images.composite(
          input: input!.file,
          patch: patch,
          width: width,
          height: height,
          patchMime: 'image/webp',
          patches: patches,
          cancellation: cancel,
        );
      }
      cancel.check();
      final file = await repository.publish(
        'result',
        key,
        complete,
        epoch: epoch,
      );
      cancel.check();
      receipt.resultKey = key;
      receipt.resultWidth = width;
      receipt.resultHeight = height;
      await _save(receipt);
      // Keep the live receipt in sync so a later status save cannot drop cache metadata.
      final live = _receipts[receipt.sourceSha];
      if (live?.id == receipt.id) {
        live!.resultKey = key;
        live.resultWidth = width;
        live.resultHeight = height;
      }
      return (file, width, height);
    } finally {
      input?.release();
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
        (t) => _sources.hashFor(t.page) == receipt.sourceSha,
      );
      if (candidates.isEmpty) throw const TranslationFailure('SOURCE_MISSING');
      final target = candidates.first;
      final original = await _sources.acquire(target, cancel);
      PreparedTranslationImage? prepared;
      try {
        prepared = await images.prepare(
          original.file,
          cancel,
          sourceSha: original.sha,
        );
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
    _sources.dispose();
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
