import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations_en.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/modules/webview/translation_bridge.dart';
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
  PageTranslationState stateFor(TranslationPage page) =>
      const PageTranslationState();
  @override
  void pause(String consumer) {}
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
      controller,
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
