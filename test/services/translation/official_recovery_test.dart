import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:isar_community/isar.dart';
import 'package:mangayomi/models/translation_entry.dart';
import 'package:mangayomi/repositories/translation_repository.dart';
import 'package:mangayomi/services/translation/channels/nodelane/channel.dart';
import 'package:mangayomi/services/translation/contracts.dart';
import 'package:mangayomi/services/translation/image_work.dart';
import 'package:mangayomi/services/translation/identity.dart';
import 'package:mangayomi/services/translation/channels/nodelane/receipt.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';

class _Source implements SourceImageReader {
  _Source(this.file);
  final File file;
  int reads = 0;
  @override
  Future<OriginalImageLease> acquire(
    TranslationPage page,
    TranslationCancellation cancellation,
  ) async {
    reads++;
    return OriginalImageLease(file);
  }
}

class _HeldSource extends _Source {
  _HeldSource(super.file);
  final acquired = Completer<void>(), resume = Completer<void>();
  @override
  Future<OriginalImageLease> acquire(
    TranslationPage page,
    TranslationCancellation cancellation,
  ) async {
    if (!acquired.isCompleted) acquired.complete();
    await resume.future;
    cancellation.check();
    return super.acquire(page, cancellation);
  }
}

class _HeldReadRepository extends TranslationRepository {
  _HeldReadRepository(TranslationRepository repository, this.key)
    : super(repository.database, repository.directory);
  final String key;
  final started = Completer<void>(), resume = Completer<void>();
  @override
  Future<Map<String, dynamic>?> read(String key) async {
    final value = await super.read(key);
    if (key == this.key && !started.isCompleted) {
      started.complete();
      await resume.future;
    }
    return value;
  }
}

Future<void> _until(bool Function() check) async {
  final deadline = DateTime.now().add(const Duration(seconds: 8));
  while (!check()) {
    if (DateTime.now().isAfter(deadline)) fail('State transition timed out');
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // These service tests exercise a real loopback HTTP fixture.
  final previousHttpOverrides = HttpOverrides.current;
  HttpOverrides.global = null;
  tearDownAll(() => HttpOverrides.global = previousHttpOverrides);
  late Directory directory;
  late Isar db;
  late TranslationRepository repository;
  late HttpServer server;
  late TranslationTarget target;
  final runtimes = <ChannelRuntime>[];
  final puts = <(String, Map<String, dynamic>)>[];
  final gets = <String>[];
  final remote = <String, Map<String, dynamic>>{};
  bool dropCreate = false, absentCreate = false, dropUpload = false;
  int uploads = 0;
  String? terminalFailure;
  bool expiredResult = false;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('nodelane-recovery-');
    db = await Isar.open(
      [TranslationEntrySchema],
      name: 'test-${directory.path.hashCode}',
      directory: directory.path,
      inspector: false,
    );
    repository = TranslationRepository(db, directory);
    final file = await File('${directory.path}/source.png').writeAsBytes(
      img.encodePng(img.Image(width: 8, height: 12, numChannels: 4)),
    );
    target = TranslationTarget(
      const TranslationPage('chapter/source/page-0', 'revision-1'),
      _Source(file),
    );
    puts.clear();
    gets.clear();
    remote.clear();
    uploads = 0;
    terminalFailure = null;
    expiredResult = false;
    dropCreate = false;
    absentCreate = false;
    dropUpload = false;
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      expect(request.headers.value('cookie'), isNull);
      request.response.headers.contentType = ContentType.json;
      final path = request.uri.path;
      if (path.startsWith('/v1/translations')) {
        expect(request.headers.value('X-Translation-Protocol'), 'overlay-v1');
        expect(request.headers.value('authorization'), isNotNull);
      }
      Map<String, dynamic> body = {};
      if (path == '/v1/capabilities') {
        body = {
          'result_protocol': 'overlay-v1',
          'modes': [
            {
              'id': 'classic',
              'enabled': true,
              'languages': ['zh-Hans'],
            },
          ],
          'limits': {},
        };
      } else if (path.endsWith('/events')) {
        request.response.headers.contentType = ContentType(
          'text',
          'event-stream',
        );
        request.response.write('event: end\ndata: {}\n\n');
        await request.response.close();
        return;
      } else {
        final parts = path.split('/');
        final id = parts[3];
        if (request.method == 'PUT' && !path.endsWith('/input')) {
          body = jsonDecode(
            await utf8.decoder.bind(request).join(),
          ) as Map<String, dynamic>;
          puts.add((id, body));
          final image =
              body['image'] ??
              remote[body['retry_of'] ?? body['regenerate_of']]!['image'];
          body = {
            'id': id,
            'mode': 'classic',
            'target_language': 'zh-Hans',
            'image_sha256': image['sha256'],
            'image': image,
            'state': 'needs_input',
            'execution_resolved': false,
          };
          if (!absentCreate) remote[id] = body;
          if (dropCreate) {
            dropCreate = false;
            (await request.response.detachSocket()).destroy();
            return;
          }
        } else if (path.endsWith('/input')) {
          uploads++;
          final bytes = await request.fold<List<int>>(
            [],
            (buffer, chunk) => buffer..addAll(chunk),
          );
          expect(bytes, await (target.source as _Source).file.readAsBytes());
          body = remote[id]!;
          body['state'] = 'succeeded';
          body['execution_resolved'] = true;
          body['result'] = {
            'kind': 'no_text',
            'representation': 'original',
            'input_sha256': body['image_sha256'],
            'normalization_version': 1,
            'width': 8,
            'height': 12,
            'artifact': null,
          };
          if (terminalFailure != null) {
            body['state'] = 'failed';
            body['result'] = null;
            body['error'] = {'code': terminalFailure};
          } else if (expiredResult) {
            body['result'] = null;
            body['error'] = {'code': 'RESULT_EXPIRED'};
          }
          if (dropUpload) {
            dropUpload = false;
            (await request.response.detachSocket()).destroy();
            return;
          }
        } else {
          gets.add(id);
          body = remote[id] ?? {};
          if (body.isEmpty) request.response.statusCode = 404;
        }
      }
      request.response.write(jsonEncode(body));
      await request.response.close();
    });
  });
  tearDown(() async {
    for (final runtime in runtimes) {
      await runtime.dispose();
    }
    runtimes.clear();
    await server.close(force: true);
    await db.close(deleteFromDisk: true);
    await directory.delete(recursive: true);
  });
  ChannelRuntime runtime([String user = 'account-a']) {
    final value = NodeLaneChannel(
      base: Uri.parse('http://127.0.0.1:${server.port}'),
      userId: user,
      accessToken: () async => 'synthetic-token',
      repository: repository,
      images: TranslationImageWork(Directory('${directory.path}/temporary')),
      allowLocalTestServer: true,
    ).createRuntime(const TranslationOptions());
    runtimes.add(value);
    return value;
  }

  test('original display stops automatic preparation and translated display resumes only when enabled', () async {
    final source = _HeldSource((target.source as _Source).file);
    target = TranslationTarget(target.page, source);
    final value = runtime();
    final view = TranslationViewController()
      ..attach(value)
      ..window([target]);
    addTearDown(view.dispose);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(source.acquired.isCompleted, isFalse);
    expect(puts, isEmpty);
    view.configure(showTranslation: true);
    await source.acquired.future;
    view.configure(showTranslation: false);
    source.resume.complete();
    await _until(
      () => value.stateFor(target.page).phase == TranslationPhase.idle,
    );
    expect(puts, isEmpty);
    expect(uploads, 0);
    expect(view.enabled, isTrue);
    view.configure(enabled: false, showTranslation: true);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(puts, isEmpty);
    view.configure(enabled: true);
    await _until(() => value.stateFor(target.page).noText);
    expect(puts, hasLength(1));
    expect(uploads, 1);
  });
  test('lost create response survives runtime restart and verifies the original UUID', () async {
    dropCreate = true;
    final first = runtime()..setWindow('reader', [target]);
    await _until(
      () => first.stateFor(target.page).phase == TranslationPhase.uncertain,
    );
    await first.dispose();
    runtimes.remove(first);
    final next = runtime()..setWindow('browser', [target]);
    await _until(() => next.stateFor(target.page).noText);
    expect(puts, hasLength(1));
    expect(gets, contains(puts.single.$1));
    expect(uploads, 1);
    next.setWindow('reader', [target]);
    await next.restore([target]);
    expect(puts, hasLength(1));
    final other = runtime('account-b')..setWindow('reader', [target]);
    await _until(() => other.stateFor(target.page).noText);
    expect(puts, hasLength(2));
    expect(puts[0].$1, isNot(puts[1].$1));
  });
  test('cold cached display and single-image regeneration work without enabling automatic translation', () async {
    final first = runtime() as OfficialRuntime;
    first.setWindow('reader', [target]);
    await _until(() => first.stateFor(target.page).noText);
    await Future<void>.delayed(const Duration(milliseconds: 25));
    final id = puts.single.$1;
    final operation = 'operation:${first.scope}:$id';
    final receipt = OfficialReceipt.fromJson(
      (await repository.read(operation))!,
    );
    final sha = translationKey('fixture-overlay');
    receipt.snapshot!['result'] = {
      'kind': 'translated',
      'representation': 'overlay-v1',
      'normalization_version': 1,
      'input_sha256': receipt.inputSha,
      'width': receipt.width,
      'height': receipt.height,
      'composite': 'source-atop',
      'bbox': {'x': 0, 'y': 0, 'width': 1, 'height': 1},
      'artifact': {
        'mime': 'image/webp',
        'path': '/v1/translations/$id/result',
        'byte_size': 1,
        'sha256': sha,
      },
    };
    receipt.resultKey = translationKey([
      first.scope,
      id,
      sha,
      'mobile-png-composite-v1',
    ]);
    final source = target.source as _Source;
    final cached = await repository.publish(
      'result',
      receipt.resultKey!,
      source.file,
    );
    receipt.resultSha = await imageDigest(cached);
    await repository.write(
      operation,
      first.scope,
      'completed',
      receipt.toJson(),
    );
    await first.dispose();
    runtimes.remove(first);
    source.reads = 0;
    final next = runtime();
    final untouched = TranslationTarget(
      const TranslationPage('next-page', '1'),
      source,
    );
    final view = TranslationViewController()..configure(enabled: false);
    addTearDown(view.dispose);
    view.attach(next);
    view.window([target, untouched]);
    await _until(() => view.state(target).result != null);
    expect(view.images, isEmpty);
    view.configure(showTranslation: true);
    await _until(() => view.images.isNotEmpty);
    expect(view.images[target.page.identity]!.file.path, cached.path);
    expect(source.reads, 0);
    expect(puts, hasLength(1));
    expect(gets, isEmpty);
    expect(uploads, 1);
    view.configure(showTranslation: false);
    view.configure(showTranslation: true);
    expect(view.enabled, isFalse);
    expect(view.images, hasLength(1));
    await view.perform(target, TranslationAction.regenerate);
    await _until(() => puts.length == 2 && next.stateFor(target.page).noText);
    expect(puts.last.$2, {'regenerate_of': id});
    expect(view.enabled, isFalse);
    expect(next.stateFor(untouched.page).phase, TranslationPhase.idle);
  });
  test(
    'late cache restoration cannot replace the result of explicit regeneration',
    () async {
      final first = runtime() as OfficialRuntime;
      first.setWindow('reader', [target]);
      await _until(() => first.stateFor(target.page).noText);
      final id = puts.single.$1;
      await first.dispose();
      runtimes.remove(first);

      final held = _HeldReadRepository(
        repository,
        'operation:${first.scope}:$id',
      );
      repository = held;
      addTearDown(() {
        if (!held.resume.isCompleted) held.resume.complete();
      });
      final next = runtime();
      final restoration = next.restore([target]);
      await held.started.future;
      next.setWindow('reader', [target], automatic: false);
      terminalFailure = 'REMOTE_FAILED';
      await next.perform(target, TranslationAction.regenerate);
      await _until(
        () => next.stateFor(target.page).phase == TranslationPhase.failed,
      );
      expect(puts.last.$2, {'regenerate_of': id});
      held.resume.complete();
      await restoration;
      expect(next.stateFor(target.page).phase, TranslationPhase.failed);
      expect(next.stateFor(target.page).actions, {TranslationAction.retry});
    },
  );
  test(
    'only a verified absent request replays the same UUID and exact body',
    () async {
      dropCreate = true;
      absentCreate = true;
      final first = runtime()..setWindow('reader', [target]);
      await _until(
        () => first.stateFor(target.page).phase == TranslationPhase.uncertain,
      );
      await first.dispose();
      runtimes.remove(first);
      absentCreate = false;
      final next = runtime()..setWindow('reader', [target]);
      await _until(() => next.stateFor(target.page).noText);
      expect(puts, hasLength(2));
      expect(puts.first.$1, puts.last.$1);
      expect(puts.first.$2, puts.last.$2);
      expect(gets, [puts.first.$1]);
    },
  );

  test(
    'NodeLane failed-image retry uses a new UUID and preserves retry_of',
    () async {
      terminalFailure = 'REMOTE_FAILED';
      final value = runtime()..setWindow('reader', [target]);
      await _until(
        () => value.stateFor(target.page).phase == TranslationPhase.failed,
      );
      await Future<void>.delayed(const Duration(milliseconds: 25));
      terminalFailure = null;
      await value.perform(target, TranslationAction.retry);
      await _until(() => value.stateFor(target.page).noText);
      expect(puts, hasLength(2));
      expect(puts.last.$2, {'retry_of': puts.first.$1});
      expect(puts.first.$1, isNot(puts.last.$1));
    },
  );

  test(
    'NodeLane analysis limits cannot be retried or silently resubmitted',
    () async {
      terminalFailure = 'CLASSIC_REGION_LIMIT_EXCEEDED';
      final value = runtime()..setWindow('reader', [target]);
      await _until(
        () => value.stateFor(target.page).phase == TranslationPhase.failed,
      );
      await Future<void>.delayed(const Duration(milliseconds: 25));
      expect(value.stateFor(target.page).actions, isEmpty);
      expect(value.stateFor(target.page).message, contains('Split it'));
      await expectLater(
        value.perform(target, TranslationAction.retry),
        throwsA(isA<TranslationFailure>()),
      );
      expect(puts, hasLength(1));
    },
  );

  test(
    'NodeLane expired result stays terminal and requires explicit regeneration',
    () async {
      expiredResult = true;
      final value = runtime()..setWindow('reader', [target]);
      await _until(
        () => value.stateFor(target.page).phase == TranslationPhase.succeeded,
      );
      final result = value.stateFor(target.page).result!;
      await expectLater(
        value.readResult(result, TranslationCancellation()),
        throwsA(
          isA<TranslationFailure>().having(
            (e) => e.code,
            'code',
            'RESULT_EXPIRED',
          ),
        ),
      );
      expect(puts, hasLength(1));
      await Future<void>.delayed(const Duration(milliseconds: 25));
      expiredResult = false;
      await value.perform(target, TranslationAction.regenerate);
      await _until(() => value.stateFor(target.page).noText);
      expect(puts.last.$2, {'regenerate_of': puts.first.$1});
    },
  );

  test('a changed original never displays an old result or silently starts another task', () async {
    final value = runtime()..setWindow('reader', [target]);
    await _until(() => value.stateFor(target.page).noText);
    value.pause('reader');
    final replacement = img.Image(width: 8, height: 12, numChannels: 4)
      ..setPixelRgba(0, 0, 255, 0, 0, 255);
    await (target.source as _Source).file.writeAsBytes(
      img.encodePng(replacement),
    );
    value.setWindow('reader', [target]);
    await _until(
      () => value.stateFor(target.page).phase == TranslationPhase.failed,
    );
    expect(value.stateFor(target.page).result, isNull);
    expect(puts, hasLength(1));
    await Future<void>.delayed(const Duration(milliseconds: 25));
    await value.perform(target, TranslationAction.regenerate);
    await _until(() => puts.length == 2 && value.stateFor(target.page).noText);
    expect(puts.last.$2, contains('image'));
    expect(puts.last.$1, isNot(puts.first.$1));
  });
  test('lost upload response verifies completion; explicit regenerate alone creates new UUID', () async {
    dropUpload = true;
    final first = runtime()..setWindow('reader', [target]);
    await _until(
      () => first.stateFor(target.page).phase == TranslationPhase.uncertain,
    );
    await first.dispose();
    runtimes.remove(first);
    final next = runtime()..setWindow('reader', [target]);
    await _until(() => next.stateFor(target.page).noText);
    expect(uploads, 1);
    expect(puts, hasLength(1));
    await Future<void>.delayed(const Duration(milliseconds: 25));
    await next.perform(target, TranslationAction.regenerate);
    await _until(() => puts.length == 2 && next.stateFor(target.page).noText);
    expect(puts.last.$2, {'regenerate_of': puts.first.$1});
    expect(puts.last.$1, isNot(puts.first.$1));
  });
}
