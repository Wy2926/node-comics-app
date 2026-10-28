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

class _Source implements SourceImageReader {
  _Source(this.file);
  final File file;
  @override
  Future<OriginalImageLease> acquire(
    TranslationPage page,
    TranslationCancellation cancellation,
  ) async => OriginalImageLease(file);
}

Future<void> _until(bool Function() check) async {
  final deadline = DateTime.now().add(const Duration(seconds: 8));
  while (!check()) {
    if (DateTime.now().isAfter(deadline)) fail('State transition timed out');
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
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
    dropCreate = false;
    absentCreate = false;
    dropUpload = false;
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      expect(request.headers.value('cookie'), isNull);
      request.response.headers.contentType = ContentType.json;
      final path = request.uri.path;
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
