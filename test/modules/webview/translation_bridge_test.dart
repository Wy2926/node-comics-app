import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations_en.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/modules/webview/translation_bridge.dart';
import 'package:mangayomi/modules/webview/reader_transport.dart';
import 'package:mangayomi/modules/webview/image_archive.dart';
import 'package:mangayomi/services/translation/contracts.dart';

import 'fixtures.dart';

class _Controller extends Fake implements InAppWebViewController {
  CallAsyncJavaScriptResult? result;
  Completer<CallAsyncJavaScriptResult?>? pending;
  Function? handler;
  String? token;
  String? archive;
  int archiveCalls = 0;
  @override
  Future<String?> saveWebArchive({
    required String filePath,
    bool autoname = false,
  }) async {
    archiveCalls++;
    if (archive == null) return null;
    await File(filePath).writeAsString(archive!);
    return filePath;
  }

  @override
  void addJavaScriptHandler({
    required String handlerName,
    required Function callback,
  }) {
    handler = callback;
  }

  @override
  Function? removeJavaScriptHandler({required String handlerName}) => null;
  @override
  Future<dynamic> evaluateJavascript({
    required String source,
    ContentWorld? contentWorld,
  }) async {
    final config = RegExp(r'const config = (.*);').firstMatch(source);
    if (config != null) token = jsonDecode(config[1]!)['token'] as String;
  }

  @override
  Future<CallAsyncJavaScriptResult?> callAsyncJavaScript({
    required String functionBody,
    Map<String, dynamic> arguments = const {},
    ContentWorld? contentWorld,
  }) async {
    if (arguments['operation'] == 'state') {
      return CallAsyncJavaScriptResult(value: {'value': true});
    }
    return pending == null ? result : await pending!.future;
  }
}

class _Runtime extends Fake implements ChannelRuntime {
  File? resultFile;
  TranslationFailure? failure;
  void Function(List<TranslationTarget>)? onWindow;
  @override
  Stream<void> get changes => const Stream.empty();
  @override
  Future<void> restore(List<TranslationTarget> targets) async {}
  @override
  void setWindow(
    String consumer,
    List<TranslationTarget> targets, {
    bool automatic = true,
  }) {
    onWindow?.call(targets);
  }

  @override
  PageTranslationState stateFor(TranslationPage page) => PageTranslationState(
    phase: failure == null ? TranslationPhase.idle : TranslationPhase.failed,
    failure: failure,
    actions: {if (failure != null) TranslationAction.retry},
    result: resultFile == null
        ? null
        : const TranslationResultRef('local', 'op'),
  );
  @override
  Future<DisplayImageLease> readResult(
    TranslationResultRef result,
    TranslationCancellation cancel,
  ) async => DisplayImageLease(file: resultFile!, width: 1, height: 1);
  @override
  void pause(String consumer) {}
}

class _InPageReader implements ReaderTransport {
  _InPageReader([this.archive]);
  String? token;
  ReaderMessage? send;
  final operations = <String>[];
  Map? validated;
  final states = <(int, bool)>[];
  final sent = Completer<void>();
  bool unreadablePixels = false;
  @override
  final WebImageArchive? archive;
  @override
  void listen(ReaderMessage? receive) => send = receive;
  @override
  Future<void> install(
    String url,
    String token,
    bool Function() isCurrent,
  ) async => this.token = token;
  @override
  Future<Object?> call(
    String url,
    String token,
    String operation,
    Map<String, dynamic> args,
  ) async {
    operations.add(operation);
    if (operation == 'state') {
      states.add((args['scope'] as int, args['translated'] as bool));
    }
    if (operation == 'resultEnd' && !sent.isCompleted) sent.complete();
    if (operation == 'validate') validated = args;
    if (operation == 'inputBegin' && unreadablePixels) {
      return {'error': 'SOURCE_MISSING'};
    }
    return {
      'value': switch (operation) {
        'inputBegin' => {'size': 3},
        'inputChunk' => 'AQID',
        _ => true,
      },
    };
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _Controller controller;
  late TranslationViewController view;
  late WebTranslationBridge bridge;
  setUp(() async {
    controller = _Controller();
    view = TranslationViewController();
    bridge = WebTranslationBridge(
      SystemReaderTransport(controller),
      view,
      'tab',
      l10n: AppLocalizationsEn(),
    );
    await bridge.install(Uri.parse('https://reader.example/chapter'));
  });
  tearDown(() {
    bridge.dispose();
    view.dispose();
  });

  test(
    'chapter hints work without translation, never cross document or origin',
    () async {
      final engine = _InPageReader(), reader = TranslationViewController();
      final reports = <(bool, String?)>[];
      final connected = WebTranslationBridge(
        engine,
        reader,
        'read',
        l10n: AppLocalizationsEn(),
        onReading: (chapter, next) => reports.add((chapter, next)),
      );
      addTearDown(reader.dispose);
      addTearDown(connected.dispose);
      const origin = 'https://reader.example',
          url = '$origin/read/1',
          next = '$origin/read/2';
      await connected.install(Uri.parse(url));
      final token = engine.token;
      var seq = 0;
      Future<bool> send(
        String? target, {
        String? documentToken,
        String document = url,
      }) => engine.send!(origin, document, {
        'token': documentToken ?? engine.token,
        'seq': ++seq,
        'reading': {'chapter': true, 'nextChapter': target},
      });
      expect(await send(next), isTrue);
      expect(reports.last, (true, next));
      for (final bad in [
        'https://other.example/read/2',
        'javascript:void(0)',
        '$url#more',
      ]) {
        expect(await send(bad), isTrue);
        expect(reports.last, (true, null));
      }
      expect(await send(next, document: next), isFalse);
      await connected.install(Uri.parse(next));
      expect(await send(url, document: next, documentToken: token), isFalse);
      reader.configure(foreground: false);
      expect(await send(url, document: next), isFalse);
      expect(reports.length, 4);
    },
  );

  test(
    'in-page HTTP images read in chunks only from the current top document',
    () async {
      final files = WebImageTestDirectory();
      await files.setUp();
      addTearDown(files.tearDown);
      final engine = _InPageReader(), reader = TranslationViewController();
      final connected = WebTranslationBridge(
        engine,
        reader,
        'gecko',
        l10n: AppLocalizationsEn(),
      );
      try {
        reader.attach(_Runtime());
        await connected.install(Uri.parse('https://reader.example/one'));
        final message = {
          'token': engine.token,
          'seq': 1,
          'items': [
            {
              'id': '1',
              'revision': '1',
              'kind': 'http',
              'url': 'https://unreachable.invalid/img',
            },
          ],
        };
        expect(
          await engine.send!(
            'https://other.example',
            'https://reader.example/one',
            message,
          ),
          isFalse,
        );
        expect(
          await engine.send!(
            'https://reader.example',
            'https://reader.example/two',
            message,
          ),
          isFalse,
        );
        expect(
          await engine.send!(
            'https://reader.example',
            'https://reader.example/one',
            message,
          ),
          isTrue,
        );
        final target = reader.targets.single;
        final lease = await target.source.acquire(
          target.page,
          TranslationCancellation(),
        );
        expect(await lease.file.readAsBytes(), [1, 2, 3]);
        expect(
          engine.operations,
          containsAllInOrder(['inputBegin', 'inputChunk', 'inputEnd']),
        );
        lease.release();
        await waitDeleted(lease.file);
        connected.navigate();
        await expectLater(
          target.source.acquire(target.page, TranslationCancellation()),
          throwsA(isA<TranslationCancelled>()),
        );
      } finally {
        connected.dispose();
        reader.dispose();
      }
    },
  );

  test('warm toggles send only display state and switching account invalidates the prepared scope', () async {
    final files = WebImageTestDirectory();
    await files.setUp();
    addTearDown(files.tearDown);
    final file = await File('${files.directory.path}/result')
        .writeAsBytes(List.filled(140000, 123));
    final reader = TranslationViewController()
      ..attach(_Runtime()..resultFile = file);
    final engine = _InPageReader();
    final connected = WebTranslationBridge(
      engine,
      reader,
      'warm',
      l10n: AppLocalizationsEn(),
    );
    addTearDown(reader.dispose);
    addTearDown(connected.dispose);
    const origin = 'https://reader.example', url = '$origin/read/2';
    await connected.install(Uri.parse(url));
    await engine.send!(origin, url, {
      'token': engine.token,
      'seq': 1,
      'items': [
        {'id': '1', 'revision': '1', 'kind': 'pixels', 'url': ''},
      ],
    });
    reader.configure(showTranslation: true);
    await engine.sent.future.timeout(const Duration(seconds: 3));
    await pumpEventQueue();
    expect(engine.operations.where((op) => op == 'resultChunk'), hasLength(2));
    final scope = engine.states.last.$1;
    engine.operations.clear();
    for (final show in [false, true, false, true]) {
      reader.configure(showTranslation: show);
    }
    await pumpEventQueue();
    expect(engine.operations, List.filled(4, 'state'));
    expect(engine.states.sublist(engine.states.length - 4), [
      (scope, false),
      (scope, true),
      (scope, false),
      (scope, true),
    ]);
    reader.attach(_Runtime());
    expect(engine.states.last.$1, isNot(scope));
  });

  test('web upgrade requires a quota error on the current image revision and never runs a translation', () async {
    final engine = _InPageReader(),
        runtime = _Runtime()
          ..failure = const TranslationFailure('DAILY_QUOTA_EXHAUSTED');
    final reader = TranslationViewController()..attach(runtime);
    var upgrades = 0;
    final connected = WebTranslationBridge(
      engine,
      reader,
      'quota',
      l10n: AppLocalizationsEn(),
      onUpgrade: () async => upgrades++,
    );
    addTearDown(reader.dispose);
    addTearDown(connected.dispose);
    const origin = 'https://reader.example', document = '$origin/chapter';
    await connected.install(Uri.parse(document));
    var sequence = 0;
    Future<bool> send(Map<String, Object> data) => engine.send!(
      origin,
      document,
      {'token': engine.token, 'seq': ++sequence, ...data},
    );
    await send({
      'items': [
        {'id': '1', 'revision': 'current', 'kind': 'pixels', 'url': ''},
      ],
    });
    Future<bool> upgrade(String revision) =>
        send({'id': '1', 'revision': revision, 'action': 'upgrade'});
    expect(await upgrade('old'), isFalse);
    expect(await upgrade('current'), isTrue);
    runtime.failure = const TranslationFailure('RATE_LIMITED');
    expect(await upgrade('current'), isFalse);
    expect(upgrades, 1);
  });

  test('archived SVG uses the original viewport and falls back to its bytes if pixel export fails', () async {
    final files = WebImageTestDirectory();
    await files.setUp();
    addTearDown(files.tearDown);
    const origin = 'https://reader.example',
        url = '$origin/read/1',
        image = '$origin/page';
    const svg =
        '<!-- <svg viewBox="wrong"> --><svg xmlns="http://www.w3.org/2000/svg" '
        'width="40" height="60" viewBox="10 20 30 30" preserveAspectRatio="xMaxYMin meet"><g/></svg>';
    final engine = _InPageReader(
      WebImageArchive(
        apple: false,
        save: (path) async {
          await File(path)
              .writeAsString(archiveFixture({image: utf8.encode(svg)}));
          return path;
        },
      ),
    );
    final reader = TranslationViewController()..attach(_Runtime());
    final connected = WebTranslationBridge(
      engine,
      reader,
      'svg',
      l10n: AppLocalizationsEn(),
    );
    addTearDown(reader.dispose);
    addTearDown(connected.dispose);
    await connected.install(Uri.parse(url));
    await engine.send!(origin, url, {
      'token': engine.token,
      'seq': 1,
      'items': [
        {'id': '1', 'revision': '2', 'kind': 'http', 'url': image},
      ],
    });
    final target = reader.targets.single;
    late Directory archiveDirectory;
    for (final tainted in [false, true]) {
      engine.unreadablePixels = tainted;
      final lease = await target.source.acquire(
        target.page,
        TranslationCancellation(),
      );
      try {
        if (tainted) archiveDirectory = lease.file.parent;
        expect(engine.validated, {
          'id': '1',
          'revision': '2',
          'svg': {
            'viewBox': '10 20 30 30',
            'preserveAspectRatio': 'xMaxYMin meet',
          },
        });
        expect(
          await lease.file.readAsBytes(),
          tainted ? utf8.encode(svg) : [1, 2, 3],
        );
      } finally {
        lease.release();
      }
    }
    connected.navigate();
    await waitDeleted(archiveDirectory);
  });

  test('reinstall starts a fresh window sequence and consecutive updates are not dropped', () async {
    view.runtime = _Runtime();
    Future<bool> send(String token, int sequence, String revision) async =>
        await controller.handler!(
          JavaScriptHandlerFunctionData(
            isMainFrame: true,
            origin: WebUri('https://reader.example'),
            requestUrl: WebUri('https://reader.example/chapter'),
            args: [
              {
                'token': token,
                'seq': sequence,
                'items': [
                  {
                    'id': '1',
                    'revision': revision,
                    'kind': 'pixels',
                    'url': '',
                  },
                ],
              },
            ],
          ),
        ) as bool;
    final oldToken = controller.token!;
    expect(await send(oldToken, 10, 'cover'), isTrue);
    final cover = view.targets.single.page;
    expect(await send(oldToken, 11, 'page-one'), isTrue);
    expect(view.targets.single.page.identity, isNot(cover.identity));
    await bridge.install(Uri.parse('https://reader.example/chapter'));
    expect(view.targets, isEmpty);
    final newToken = controller.token!;
    expect(newToken, isNot(oldToken));
    expect(await send(newToken, 1, 'page-two'), isTrue);
    final current = view.targets.single.page;
    expect(await send(oldToken, 12, 'old-page'), isFalse);
    expect(view.targets.single.page.identity, current.identity);
    expect(await send(newToken, 2, 'page-three'), isTrue);
    expect(await send(newToken, 1, 'page-two'), isFalse);
    expect(view.targets.single.page.identity, isNot(current.identity));
  });

  test('source errors retain their meaning; unknown JS details never become user messages', () async {
    for (final code in [
      'SOURCE_MISSING',
      'RESOURCE_LIMIT',
      'BRIDGE_INVALID',
      'private URL or script error',
    ]) {
      controller.result = CallAsyncJavaScriptResult(value: {'error': code});
      await expectLater(
        bridge.restoreAnchor({'y': 0}),
        throwsA(
          isA<TranslationFailure>().having(
            (error) => error.code,
            'code',
            code == 'private URL or script error' ? 'BRIDGE_INVALID' : code,
          ),
        ),
      );
    }
    controller.result = CallAsyncJavaScriptResult(
      error: 'native script failure',
    );
    await expectLater(
      bridge.restoreAnchor({'y': 0}),
      throwsA(
        isA<TranslationFailure>().having(
          (error) => error.code,
          'code',
          'BRIDGE_INVALID',
        ),
      ),
    );
  });

  test('wrapped successful values survive while late navigation results are cancelled', () async {
    controller.result = CallAsyncJavaScriptResult(
      value: {
        'value': {'x': 0, 'y': 120},
      },
    );
    expect(await bridge.captureAnchor(), {'x': 0, 'y': 120});
    controller.pending = Completer<CallAsyncJavaScriptResult?>();
    final restoration = bridge.restoreAnchor({'y': 120});
    bridge.navigate();
    controller.pending!.complete(
      CallAsyncJavaScriptResult(value: {'value': true}),
    );
    await expectLater(restoration, throwsA(isA<TranslationCancelled>()));
  });

  test(
    'a replaced DOM image cancels the old work instead of failing the new page',
    () async {
      controller.result = CallAsyncJavaScriptResult(
        value: {'error': 'SOURCE_CHANGED'},
      );
      await expectLater(
        bridge.restoreAnchor({'y': 0}),
        throwsA(isA<TranslationCancelled>()),
      );
    },
  );

  test('HTTP images use the loaded WebView bytes, and validate their live DOM revision', () async {
    final storage = WebImageTestDirectory();
    await storage.setUp();
    final directory = storage.directory;
    try {
      view.runtime = _Runtime();
      controller.archive = archiveFixture({
        'https://cdn.invalid/image': [1, 2, 3],
      });
      controller.result = CallAsyncJavaScriptResult(value: {'value': true});
      await controller.handler!(
        JavaScriptHandlerFunctionData(
          isMainFrame: true,
          origin: WebUri('https://reader.example'),
          requestUrl: WebUri('https://reader.example/chapter'),
          args: [
            {
              'token': controller.token,
              'seq': 1,
              'items': [
                {
                  'id': '1',
                  'revision': '1',
                  'kind': 'http',
                  'url': 'https://cdn.invalid/image',
                },
              ],
            },
          ],
        ),
      );
      final target = view.targets.single;
      final lease = await target.source.acquire(
        target.page,
        TranslationCancellation(),
      );
      expect(await lease.file.readAsBytes(), [1, 2, 3]);
      expect(
        controller.archiveCalls,
        1,
        reason: 'No native HTTP fetch of the inaccessible CDN',
      );
      lease.release();
      // The runtime starts reads before view listeners receive foreground or
      // account changes; those valid new reads must not be cancelled as stale.
      Future<OriginalImageLease>? resumed;
      void readWindow(List<TranslationTarget> targets) {
        if (targets.isNotEmpty && resumed == null) {
          resumed = targets.first.source.acquire(
            targets.first.page,
            TranslationCancellation(),
          );
        }
      }

      view.configure(foreground: false);
      (view.runtime! as _Runtime).onWindow = readWindow;
      view.configure(foreground: true);
      final resumedLease = await resumed!;
      expect(await resumedLease.file.readAsBytes(), [1, 2, 3]);
      resumedLease.release();
      resumed = null;
      view.attach(_Runtime()..onWindow = readWindow);
      final switchedLease = await resumed!;
      expect(await switchedLease.file.readAsBytes(), [1, 2, 3]);
      switchedLease.release();
      controller.result = CallAsyncJavaScriptResult(
        value: {'error': 'SOURCE_CHANGED'},
      );
      await expectLater(
        target.source.acquire(target.page, TranslationCancellation()),
        throwsA(isA<TranslationCancelled>()),
      );
      bridge.navigate();
      for (var i = 0; i < 100 && await directory.list().isEmpty == false; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      expect(await directory.list().length, 0);
    } finally {
      await storage.tearDown();
    }
  });
}
