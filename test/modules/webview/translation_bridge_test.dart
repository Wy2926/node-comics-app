import 'dart:async';
import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations_en.dart';
import 'package:mangayomi/modules/translation/translation_view_controller.dart';
import 'package:mangayomi/modules/webview/translation_bridge.dart';
import 'package:mangayomi/services/translation/contracts.dart';

class _Controller extends Fake implements InAppWebViewController {
  CallAsyncJavaScriptResult? result;
  Completer<CallAsyncJavaScriptResult?>? pending;
  Function? handler;
  String? token;

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
  @override
  void setWindow(
    String consumer,
    List<TranslationTarget> targets, {
    bool automatic = true,
  }) {}
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
                    'kind': 'blob',
                    'url': 'blob:https://reader.example/$revision',
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
}
