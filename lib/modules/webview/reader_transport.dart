import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'image_archive.dart';

typedef ReaderMessage = Future<bool> Function(
  String origin,
  String url,
  Object? payload,
);

typedef BrowserDocumentCall = Future<Object?> Function(
  String operation,
  Map<String, dynamic> args,
);

/// Only messages from the top frame of the named document may reach the reader.
abstract interface class ReaderTransport {
  void listen(ReaderMessage? receive);
  Future<void> install(String url, String token, bool Function() isCurrent);
  Future<Object?> call(
    String url,
    String token,
    String operation,
    Map<String, dynamic> args,
  );
  WebImageArchive? get archive;
}

class SystemReaderTransport implements ReaderTransport {
  SystemReaderTransport(this.web);
  final InAppWebViewController web;
  @override
  late final archive = WebImageArchive(
    save: (path) => web.saveWebArchive(filePath: path),
    apple: Platform.isIOS || Platform.isMacOS,
  );
  @override
  void listen(ReaderMessage? receive) {
    if (receive == null) {
      web.removeJavaScriptHandler(handlerName: 'nodelaneImages');
    } else {
      web.addJavaScriptHandler(
        handlerName: 'nodelaneImages',
        callback: (JavaScriptHandlerFunctionData data) async =>
            data.isMainFrame &&
            data.args.length == 1 &&
            await receive(
              data.origin.toString(),
              data.requestUrl.toString(),
              data.args.single,
            ),
      );
    }
  }

  @override
  Future<void> install(
    String url,
    String token,
    bool Function() isCurrent,
  ) async {
    final script = await rootBundle.loadString('assets/nodelane_reader.js');
    if (!isCurrent()) return;
    await web.evaluateJavascript(
      source: script.replaceFirst(
        '__NODELANE_CONFIG__',
        jsonEncode({'token': token}),
      ),
    );
  }

  @override
  Future<Object?> call(
    String url,
    String token,
    String operation,
    Map<String, dynamic> args,
  ) async {
    if (operation == 'browserMangaPreview') {
      // WK 使用独立的内容世界；系统 Android 的独立世界通过同源子框架读取顶层文档。
      final result = await web.callAsyncJavaScript(
        functionBody: 'return ${args['program']};',
        contentWorld: ContentWorld.world(name: 'NodeLaneSourcePreview'),
      );
      return {'value': result?.value, 'error': result?.error};
    }
    final result = await web.callAsyncJavaScript(
      functionBody: '''
try {
  return {value: await window.__nodelaneReader.call(token, operation, args)};
} catch (error) {
  return {error: error.message};
}
''',
      arguments: {'token': token, 'operation': operation, 'args': args},
    );
    return result?.error == null ? result?.value : null;
  }
}
