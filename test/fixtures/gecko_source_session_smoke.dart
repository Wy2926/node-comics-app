// Run on Gecko Android. Only a loopback fixture is used; no user cookies are inspected.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/javascript/source_runtime.dart';
import 'package:mangayomi/eval/javascript/utils.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/modules/webview/gecko_browser_page.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/services/download_manager/download_isolate_pool.dart';
import 'package:mangayomi/services/http/source_session_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  final origin = 'http://127.0.0.1:${server.port}', scope = {origin};
  final other = 'http://localhost:${server.port}';
  final key = 'fixture_${server.port}';
  final pixel = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+j4/kAAAAASUVORK5CYII=',
  );
  server.listen((r) async {
    final allowed = r.cookies.any((c) => c.name == key && c.value == 'one');
    r.response.headers.set('cache-control', 'no-store');
    switch (r.uri.path) {
      case '/login':
      case '/logout':
        r.response.cookies.add(
          Cookie(key, 'one')
            ..httpOnly = true
            ..path = '/'
            ..maxAge = r.uri.path == '/login' ? 300 : 0,
        );
        r.response.headers.contentType = ContentType.html;
        r.response.write('<title>Ready</title>');
      case '/doc':
        r.response.headers.contentType = ContentType.html;
        r.response.write('<title>Source document</title>');
      case '/page.png':
        if (allowed) {
          r.response.headers.contentType = ContentType('image', 'png');
          r.response.add(pixel);
        } else {
          r.response.statusCode = 401;
        }
      case '/switch':
        r.response.statusCode = 302;
        r.response.headers.set('location', '$other/book');
      default:
        r.response.statusCode = allowed ? 200 : 401;
        // A response can refresh the HttpOnly cookie; JS must never see its value.
        if (allowed) {
          r.response.cookies.add(
            Cookie('${key}_refresh', 'test')
              ..httpOnly = true
              ..path = '/'
              ..maxAge = 300,
          );
        }
        r.response.write(allowed ? 'available' : 'signed out');
    }
    await r.response.close();
  });
  final runtime = SourceJavascriptRuntime();
  final old = http.Client(), client = SourceSessionClient(scope, old);
  JsHttpClient(runtime, origins: scope).init();
  JsUtils(runtime, origins: scope).init();
  Future<int> read(String path) async {
    final result = await runtime.evaluateAsync('''(async()=>{
      const r=await new Client().get(${jsonEncode(origin)} + ${jsonEncode(path)}, {});
      if(Object.keys(r.headers).some(k=>k.toLowerCase()==='set-cookie') ||
         Object.keys(r.request.headers).some(k=>k.toLowerCase()==='cookie')) throw Error('credential header');
      return r.statusCode;
    })()''');
    final done = await runtime.handlePromise(
      result,
      timeout: const Duration(seconds: 30),
    );
    if (done.isError) throw StateError('QuickJS request failed');
    return int.parse(done.stringResult);
  }

  runApp(
    Directionality(
      textDirection: TextDirection.ltr,
      child: GeckoBrowserPage.view(key, (id) async {
        final doc = Completer<void>();
        final page = GeckoBrowserPage(id, (e) async {
          if (e.method == 'document' &&
              e.arguments == '$origin/login' &&
              !doc.isCompleted) {
            doc.complete();
          }
        });
        try {
          await page.attach('$origin/login', true);
          await doc.future.timeout(const Duration(seconds: 60));
          page.detach();
          await GeckoBrowserPage.release(key);
          // The other site has its own login as well; the redirect must not use either identity.
          final otherClient = SourceSessionClient({other}, old);
          await otherClient.get(Uri.parse('$other/login'));
          if ((await otherClient.get(Uri.parse('$other/book'))).statusCode !=
              200) {
            throw StateError('second site login');
          }
          if (await read('/book') != 200 || await read('/switch') != 401) {
            throw StateError('same-site reuse or redirect isolation failed');
          }
          final image = '$origin/page.png';
          final provider = CustomExtendedNetworkImageProvider(
            image,
            cache: false,
            sessionOrigins: scope,
          );
          final reader = await provider.getNetworkImageData();
          if (reader == null || base64Encode(reader) != base64Encode(pixel))
            throw StateError('reader image');
          final temp = await Directory.systemTemp.createTemp('source_session_');
          try {
            final file = '${temp.path}/page';
            final done = Completer<void>();
            DownloadIsolatePool.configure(poolSize: 1);
            await DownloadIsolatePool.instance.submitFileDownload(
              taskId: key,
              pageUrls: [PageUrl(image, fileName: file)],
              concurrentDownloads: 1,
              sessionOrigins: scope,
              itemType: ItemType.manga,
              onProgress: (_) {},
              onComplete: done.complete,
              onError: done.completeError,
            );
            await done.future.timeout(const Duration(seconds: 35));
            if (base64Encode(await File('$file.png').readAsBytes()) !=
                base64Encode(pixel))
              throw StateError('downloaded image');
          } finally {
            await temp.delete(recursive: true);
          }
          final script =
              "fetch('/book').then(r=>r.text()).then(text=>window.flutter_inappwebview.callHandler('setResponse',text))";
          final hidden = await runtime.handlePromise(
            await runtime.evaluateAsync('''
            (async () => {
              const page = (s, seconds) => evaluateJavascriptViaWebview(${jsonEncode('$origin/doc')}, {}, [s], seconds);
              const values = await Promise.all([page('void 0', 2), page(${jsonEncode(script)}, 25), page(${jsonEncode(script)}, 25)]);
              return JSON.stringify(values);
            })()
          '''),
            timeout: const Duration(seconds: 40),
          );
          if (hidden.isError ||
              hidden.stringResult != '["","available","available"]') {
            throw StateError('hidden source document');
          }
          final before = await SourceSessionClient.cacheScope(scope);
          await client.get(Uri.parse('$origin/logout'));
          if (await read('/book') != 401) {
            throw StateError('logout was not applied');
          }
          if (await SourceSessionClient.cacheScope(scope) == before) {
            throw StateError('logout retained the reader cache scope');
          }
          debugPrint(
            'GECKO_SOURCE_PASS: closed tab, HttpOnly, reader and download, hidden pages, redirect, logout and cache scope',
          );
        } catch (e) {
          debugPrint('GECKO_SOURCE_FAIL: ${e.runtimeType} $e');
        } finally {
          runtime.dispose();
          old.close();
          await server.close(force: true);
        }
      }),
    ),
  );
}
