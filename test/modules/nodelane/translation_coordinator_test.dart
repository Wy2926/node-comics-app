import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/models/translation_record.dart';
import 'package:mangayomi/modules/nodelane/nodelane_auth_service.dart';
import 'package:mangayomi/modules/nodelane/nodelane_config.dart';
import 'package:mangayomi/modules/nodelane/nodelane_models.dart';
import 'package:mangayomi/modules/nodelane/translation/official_translation_client.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_coordinator.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_image_worker.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_types.dart';
import 'package:mangayomi/repositories/translation_repository.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_translation_window.dart';

void main() {
  late Directory root;
  late Isar db;
  late TranslationRepository repository;
  late _Auth auth;
  late _Client client;
  late _Images images;
  late TranslationCoordinator coordinator;
  late TranslationPage page;
  setUpAll(() => Isar.initializeIsarCore(download: true));
  setUp(() async {
    root = await Directory.systemTemp.createTemp('nodelane-translation-test-');
    db = await Isar.open(
      [TranslationRecordSchema],
      directory: root.path,
      name: 'translation_test',
    );
    repository = TranslationRepository(db, Directory('${root.path}/images'));
    auth = _Auth();
    client = _Client(auth);
    images = _Images();
    coordinator = TranslationCoordinator(
      auth: auth,
      repository: Future.value(repository),
      client: client,
      worker: images,
    );
    await coordinator.ready;
    final source = await File('${root.path}/source.png')
        .writeAsBytes([1, 2, 3, 4]);
    page = TranslationPage(
      key: 'page',
      locatorSignature: 'location',
      openOriginal: () async => source,
    );
  });
  tearDown(() async {
    coordinator.dispose();
    auth.dispose();
    await db.close(deleteFromDisk: true);
    await root.delete(recursive: true);
  });

  test(
    'concurrent intents share one durable UUID and cached repeat does no I/O',
    () async {
      final a = coordinator.translate(page), b = coordinator.translate(page);
      expect(identical(a, b), isTrue);
      final row = await a;
      expect(row.published, isTrue);
      final gets = client.gets;
      expect((await coordinator.translate(page)).uuid, row.uuid);
      expect(client.gets, gets);
      expect(client.creates, 1);
      expect(client.uploads, 1);
      expect(images.prepares, 1);
      expect(repository.recent(coordinator.scope!).length, 1);
    },
  );
  test(
    'leaving the finite window during source acquisition submits nothing',
    () async {
      final gate = Completer<File>();
      final started = Completer<void>();
      var wanted = true;
      final leaving = coordinator.translate(
        TranslationPage(
          key: 'leaving',
          locatorSignature: 'location',
          openOriginal: () {
            started.complete();
            return gate.future;
          },
        ),
        isWanted: () => wanted,
      );
      final checked = expectLater(
        leaving,
        throwsA(
          isA<NodeLaneException>().having(
            (e) => e.code,
            'code',
            'WINDOW_CHANGED',
          ),
        ),
      );
      await started.future;
      wanted = false;
      gate.complete(await page.openOriginal());
      await checked;
      expect(client.creates, 0);
      expect(repository.recent(coordinator.scope!), isEmpty);
    },
  );
  test('automatic reading admits only four unique original pages', () async {
    final window = ReaderTranslationWindow(coordinator);
    window.update(
      List.generate(
        12,
        (i) => TranslationPage(
          key: 'p${i ~/ 2}',
          locatorSignature: 'same-location',
          openOriginal: page.openOriginal,
        ),
      ),
    );
    window.setEnabled(true);
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (client.uploads < 4 && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    window.setEnabled(false);
    window.dispose();
    expect(client.creates, 4);
    expect(images.prepares, 4);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(repository.recent(coordinator.scope!).length, 4);
  });
  test(
    'lost create response and coordinator restart query the same UUID',
    () async {
      client.loseCreate = true;
      final first = await coordinator.translate(page);
      expect(first.phase, 'paused');
      expect(client.creates, 1);
      coordinator.dispose();
      coordinator = TranslationCoordinator(
        auth: auth,
        repository: Future.value(repository),
        client: client,
        worker: images,
      );
      await coordinator.ready;
      await coordinator.resume(first.id);
      expect(repository.get(first.id)!.published, isTrue);
      expect(client.creates, 1);
      expect(client.uploads, 1);
      expect(client.tasks.keys.toList(), [first.uuid]);
    },
  );
  test(
    'delivery failure retains remote success and retries only result download',
    () async {
      client.overlay = true;
      client.failDownload = true;
      final first = await coordinator.translate(page);
      expect(first.remoteState, 'succeeded');
      expect(first.published, isFalse);
      client.failDownload = false;
      await coordinator.resume(first.id);
      final result = repository.get(first.id)!;
      expect(result.published, isTrue);
      expect(await File(result.resultPath!).readAsString(), 'complete-image');
      expect(client.creates, 1);
      expect(client.uploads, 1);
      expect(client.downloads, 2);
    },
  );
  test(
    'cancel during unknown lookup invalidates admission before PUT',
    () async {
      client.lookupGate = Completer<void>();
      final translating = coordinator.translate(page);
      await client.lookupStarted.future;
      final record = repository.recent(coordinator.scope!).single;
      final cancelling = coordinator.cancel(record.id);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      client.lookupGate!.complete();
      await translating;
      await cancelling;
      expect(client.creates, 0);
      expect(client.uploads, 0);
      expect(repository.get(record.id)!.phase, 'cancelled');
    },
  );
  test(
    'account change during composition cannot publish a late image',
    () async {
      client.overlay = true;
      images.composeGate = Completer<void>();
      final translating = coordinator.translate(page);
      await images.composeStarted.future;
      final oldScope = coordinator.scope!;
      auth.switchAccount('b');
      images.composeGate!.complete();
      await translating;
      expect(repository.recent(oldScope).single.published, isFalse);
      expect(coordinator.forPage(page.key), isEmpty);
      expect(
        await repository.directory
            .list()
            .where((f) => f.path.endsWith('.png'))
            .isEmpty,
        isTrue,
      );
    },
  );
  test('language and account changes isolate cached tasks', () async {
    final first = await coordinator.translate(page);
    coordinator.setLanguage('en');
    final english = await coordinator.translate(page);
    expect(english.uuid, isNot(first.uuid));
    expect(english.language, 'en');
    auth.switchAccount('b');
    final other = await coordinator.translate(page);
    expect(other.scope, isNot(english.scope));
    expect(client.creates, 3);
    expect(coordinator.forPage(page.key).map((r) => r.uuid), [other.uuid]);
  });
  test('regenerate inherits parent settings and concurrent clicks create one attempt', () async {
    final parent = await coordinator.translate(page);
    coordinator.setLanguage('en');
    await Future.wait([
      coordinator.retry(parent.id),
      coordinator.retry(parent.id),
    ]);
    final rows = repository.page(parent.scope, page.key, parent.language);
    expect(rows.length, 2);
    expect(rows.first.language, 'zh-Hans');
    expect(jsonDecode(rows.first.descriptorJson), {
      'regenerate_of': parent.uuid,
    });
    expect(client.creates, 2);
  });
  test('changed source bytes create a new task while URL changes reuse verified content', () async {
    final first = await coordinator.translate(page);
    final moved = TranslationPage(
      key: page.key,
      locatorSignature: 'new-location',
      openOriginal: page.openOriginal,
    );
    expect((await coordinator.translate(moved)).uuid, first.uuid);
    expect(repository.get(first.id)!.locatorSignature, 'new-location');
    await (await page.openOriginal()).writeAsBytes([5, 6, 7]);
    expect((await coordinator.translate(moved)).uuid, isNot(first.uuid));
    expect(client.creates, 2);
  });
}

class _Auth extends NodeLaneAuthService {
  _Auth()
    : super(
        config: NodeLaneConfig(
          serviceOrigin: 'https://center.test',
          clientId: 'fixture',
        ),
      ) {
    switchAccount('a');
  }
  late NodeLaneAuthState value;
  @override
  NodeLaneAuthState get state => value;
  void switchAccount(String subject) {
    value = NodeLaneAuthState(
      initialized: true,
      account: NodeLaneAccount(
        user: NodeLaneUser(id: subject, name: 'Test', role: 'user'),
        entitlements: NodeLaneEntitlements.fromJson({
          'plan': 'free',
          'modes': <String, dynamic>{},
        }),
        serviceOrigin: 'https://center.test',
        issuer: 'https://identity.test',
        subject: subject,
        sessionId: 'session-$subject',
      ),
    );
    notifyListeners();
  }
}

class _Images extends TranslationImageWorker {
  int prepares = 0;
  Completer<void>? composeGate;
  final composeStarted = Completer<void>();
  @override
  Future<Map<String, dynamic>> prepare(
    String source,
    String output,
    int maxBytes,
    int maxDimension,
  ) async {
    prepares++;
    final bytes = await File(source).readAsBytes();
    await File(output).writeAsBytes(bytes, flush: true);
    final hash = sha256.convert(bytes).toString();
    return {
      'source_sha256': hash,
      'sha256': hash,
      'byte_size': bytes.length,
      'content_type': 'image/png',
      'width': 100,
      'height': 200,
      'source_width': 100,
      'source_height': 200,
    };
  }

  @override
  Future<Map<String, dynamic>> compose(
    String input,
    String artifact,
    Map<String, dynamic> result,
    String output,
  ) async {
    if (!composeStarted.isCompleted) composeStarted.complete();
    await composeGate?.future;
    final bytes = utf8.encode('complete-image');
    await File(output).writeAsBytes(bytes, flush: true);
    return {
      'sha256': sha256.convert(bytes).toString(),
      'byte_size': bytes.length,
    };
  }
}

class _Client extends OfficialTranslationClient {
  _Client(super.auth);
  final tasks = <String, Map<String, dynamic>>{};
  int creates = 0, uploads = 0, gets = 0, downloads = 0;
  bool loseCreate = false, overlay = false, failDownload = false;
  Completer<void>? lookupGate;
  final lookupStarted = Completer<void>();
  @override
  Future<TranslationCapabilities> capabilities() async =>
      TranslationCapabilities({
        'result_protocol': 'overlay-v1',
        'representations': ['overlay-v1', 'overlay-tiles-v1'],
        'limits': {'max_bytes': 1024 * 1024, 'max_dimension': 65500},
        'modes': [
          {
            'id': 'classic',
            'enabled': true,
            'languages': ['zh-Hans', 'en'],
          },
        ],
      });
  @override
  Future<Map<String, dynamic>?> lookup(
    String uuid, {
    Future<void>? abort,
  }) async {
    gets++;
    if (!lookupStarted.isCompleted) lookupStarted.complete();
    await lookupGate?.future;
    return tasks[uuid];
  }

  @override
  Future<Map<String, dynamic>> create(
    String uuid,
    String descriptor, {
    Future<void>? abort,
  }) async {
    creates++;
    final request = jsonDecode(descriptor) as Map;
    final parent = request['regenerate_of'] ?? request['retry_of'];
    final snapshot = parent == null
        ? <String, dynamic>{
            'id': uuid,
            'state': 'needs_input',
            'mode': 'classic',
            'target_language': request['target_language'],
            'image_sha256': request['image']['sha256'],
          }
        : <String, dynamic>{
            ...tasks[parent]!,
            'id': uuid,
            'state': 'needs_input',
            'result': null,
          };
    tasks[uuid] = snapshot;
    if (loseCreate) {
      loseCreate = false;
      throw const NodeLaneException('CONNECTION_FAILED', 'fixture');
    }
    return snapshot;
  }

  @override
  Future<Map<String, dynamic>> upload(
    String uuid,
    File input,
    String mime,
    int length, {
    Future<void>? abort,
  }) async {
    uploads++;
    final task = tasks[uuid]!;
    expect(await input.length(), length);
    expect(
      (await sha256.bind(input.openRead()).first).toString(),
      task['image_sha256'],
    );
    return tasks[uuid] = {
      ...task,
      'state': 'succeeded',
      'result': {
        'kind': overlay ? 'translated' : 'no_text',
        'representation': overlay ? 'overlay-v1' : 'original',
        'input_sha256': task['image_sha256'],
        'normalization_version': 1,
        'width': 100,
        'height': 200,
        'composite': overlay ? 'source-atop' : null,
        'bbox': overlay ? {'x': 0, 'y': 0, 'width': 1, 'height': 1} : null,
        'artifact': overlay
            ? {
                'path': '/v1/translations/$uuid/result',
                'mime': 'image/webp',
                'byte_size': 4,
                'sha256': sha256.convert([1, 2, 3, 4]).toString(),
              }
            : null,
      },
    };
  }

  @override
  Stream<Map<String, dynamic>> events(
    List<String> ids,
    Future<void> abort,
  ) async* {
    await abort;
  }

  @override
  Future<void> download(
    String uuid,
    Map<String, dynamic> artifact,
    File target,
    Future<void> abort,
  ) async {
    downloads++;
    if (failDownload) {
      throw const NodeLaneException('CONNECTION_FAILED', 'fixture');
    }
    await target.writeAsBytes([1, 2, 3, 4]);
  }
}
