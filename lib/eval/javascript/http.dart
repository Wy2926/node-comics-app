import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mangayomi/services/source_package.dart';

import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/http_response_extensions.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/http/source_session_client.dart';
import 'package:http/http.dart' as http;

class JsHttpClient {
  late JavascriptRuntime runtime;
  final SourcePackage? package;
  final Set<String> origins;
  JsHttpClient(this.runtime, {this.package, this.origins = const {}});

  void init() {
    // MClient.init reads the settings row and builds a new interceptor stack;
    // doing that per request added measurable overhead to every source call.
    // Reuse one client per distinct request options for this runtime's life.
    final clientCache = <String, http.Client>{};
    http.Client client(dynamic reqcopyWith) {
      final map = (reqcopyWith as Map?)?.toMapStringDynamic;
      return clientCache.putIfAbsent(
        jsonEncode(map ?? const <String, dynamic>{}),
        // Linux source catalogue requests otherwise carry no browser identity.
        // Keep other platforms unchanged and preserve any explicit source UA.
        () => SourceSessionClient(
          origins,
          MClient.init(
            reqcopyWith: package == null
                ? map
                : {
                    ...?map,
                    'useDartHttpClient': true,
                    'verifyCertificates': true,
                    'followRedirects': false,
                  },
            useDefaultUserAgent: Platform.isLinux,
          ),
          followRedirects: package == null
              ? (map?['followRedirects'] as bool?)
              : false,
          maxRedirects: map?['maxRedirects'] as int?,
        ),
      );
    }

    for (final method in jsHttpMethods) {
      runtime.onMessage(
        'http_${method.toLowerCase()}',
        (dynamic args) =>
            _toHttpResponse(client(args[1]), method, args, package: package),
      );
    }
    runtime.evaluate('''
class Client {
    constructor(reqcopyWith) {
        this.reqcopyWith = reqcopyWith;
    }
    static async #send(method, options, ...args) {
        return JSON.parse(await sendMessage("http_" + method, JSON.stringify([null, options, ...args])));
    }
    async head(url, headers) { return Client.#send("head", this.reqcopyWith, url, headers); }
    async get(url, headers) { return Client.#send("get", this.reqcopyWith, url, headers); }
    async post(url, headers, body) { return Client.#send("post", this.reqcopyWith, url, headers, body); }
    async put(url, headers, body) { return Client.#send("put", this.reqcopyWith, url, headers, body); }
    async delete(url, headers, body) { return Client.#send("delete", this.reqcopyWith, url, headers, body); }
    async patch(url, headers, body) { return Client.#send("patch", this.reqcopyWith, url, headers, body); }
}
''');
  }
}

Future<String> _toHttpResponse(
  Client client,
  String method,
  List args, {
  SourcePackage? package,
}) async {
  if (package != null) {
    return _packageHttpResponse(client, method, args, package);
  }
  final url = args[2] as String;
  final headers = (args[3] as Map?)?.toMapStringString;
  final body = args.length >= 5
      ? args[4] is List
            ? args[4] as List
            : args[4] is String
            ? args[4] as String
            : (args[4] as Map?)?.toMapStringDynamic
      : null;
  var request = http.Request(method, Uri.parse(url));
  request.headers.addAll(headers ?? {});
  if ((request.headers[HttpHeaders.contentTypeHeader]?.contains(
        "application/json",
      )) ??
      false) {
    request.body = json.encode(body);
    return jsonEncode(
      (await http.Response.fromStream(await client.send(request))).toJson(),
    );
  }
  final future = switch (method) {
    "HEAD" => client.head(Uri.parse(url), headers: headers),
    "GET" => client.get(Uri.parse(url), headers: headers),
    "POST" => client.post(Uri.parse(url), headers: headers, body: body),
    "PUT" => client.put(Uri.parse(url), headers: headers, body: body),
    "DELETE" => client.delete(Uri.parse(url), headers: headers, body: body),
    _ => client.patch(Uri.parse(url), headers: headers, body: body),
  };
  return jsonEncode((await future).toJson());
}

// Official packages use bounded text requests and validate every redirect.
// Site-specific parsing and verification challenges remain in the plugin/MClient.
Future<String> _packageHttpResponse(
  Client client,
  String method,
  List args,
  SourcePackage package,
) async {
  var uri = Uri.parse(args[2] as String);
  final headers = (args[3] as Map?)?.toMapStringString ?? {};
  final body = args.length > 4 ? args[4] : null;
  package.checkRequest(uri);
  for (var hop = 0; hop < 5; hop++) {
    final request = http.Request(method, uri)..followRedirects = false;
    request.headers.addAll(headers);
    if (body != null) {
      if (headers.entries.any(
        (e) =>
            e.key.toLowerCase() == 'content-type' &&
            e.value.contains('application/json'),
      )) {
        request.body = jsonEncode(body);
      } else if (body is String) {
        request.body = body;
      } else if (body is Map) {
        request.bodyFields = body.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        );
      } else {
        request.bodyBytes = (body as List).cast<int>();
      }
      if (request.bodyBytes.length > 1024 * 1024) throw StateError('插件请求体超过限制');
    }
    final response = await client
        .send(request)
        .timeout(const Duration(seconds: 30));
    if ([301, 302, 303, 307, 308].contains(response.statusCode)) {
      await response.stream.listen((_) {}).cancel();
      final location = response.headers['location'];
      if (location == null || method != 'GET' && method != 'HEAD') {
        throw StateError('插件请求重定向无法安全重试');
      }
      final next = uri.resolve(location);
      package.checkRequest(next);
      if (uri.origin != next.origin) stripCrossOriginHeaders(headers);
      uri = next;
      continue;
    }
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in response.stream.timeout(
      const Duration(seconds: 30),
    )) {
      if (bytes.length + chunk.length > 4 * 1024 * 1024) {
        throw StateError('插件响应超过 4 MiB');
      }
      bytes.add(chunk);
    }
    return jsonEncode(
      http.Response.bytes(
        bytes.takeBytes(),
        response.statusCode,
        headers: response.headers,
        request: request,
      ).toJson(),
    );
  }
  throw StateError('插件请求重定向过多');
}
