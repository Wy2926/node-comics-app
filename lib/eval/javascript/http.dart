import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mangayomi/services/source_package.dart';

import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/http_response_extensions.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:http/http.dart' as http;

class JsHttpClient {
  late JavascriptRuntime runtime;
  final SourcePackage? package;
  JsHttpClient(this.runtime, {this.package});

  void init() {
    // MClient.init reads the settings row and builds a new interceptor stack;
    // doing that per request added measurable overhead to every source call.
    // Reuse one client per distinct request options for this runtime's life.
    final clientCache = <String, InterceptedClient>{};
    InterceptedClient client(dynamic reqcopyWith) {
      final map = (reqcopyWith as Map?)?.toMapStringDynamic;
      return clientCache.putIfAbsent(
        jsonEncode(map ?? const <String, dynamic>{}),
        // Linux source catalogue requests otherwise carry no browser identity.
        // Keep other platforms unchanged and preserve any explicit source UA.
        () => MClient.init(
          reqcopyWith: package == null ? map : {...?map, 'useDartHttpClient': true, 'verifyCertificates': true},
          useDefaultUserAgent: Platform.isLinux,
        ),
      );
    }

    runtime.onMessage('http_head', (dynamic args) async {
      return await _toHttpResponse(
        client(args[1]),
        "HEAD",
        args,
        package: package,
      );
    });
    runtime.onMessage('http_get', (dynamic args) async {
      return await _toHttpResponse(
        client(args[1]),
        "GET",
        args,
        package: package,
      );
    });
    runtime.onMessage('http_post', (dynamic args) async {
      return await _toHttpResponse(
        client(args[1]),
        "POST",
        args,
        package: package,
      );
    });
    runtime.onMessage('http_put', (dynamic args) async {
      return await _toHttpResponse(
        client(args[1]),
        "PUT",
        args,
        package: package,
      );
    });
    runtime.onMessage('http_delete', (dynamic args) async {
      return await _toHttpResponse(
        client(args[1]),
        "DELETE",
        args,
        package: package,
      );
    });
    runtime.onMessage('http_patch', (dynamic args) async {
      return await _toHttpResponse(
        client(args[1]),
        "PATCH",
        args,
        package: package,
      );
    });
    runtime.evaluate('''
class Client {
    constructor(reqcopyWith) {
        this.reqcopyWith = reqcopyWith;
    }
    async head(url, headers) {
        headers = headers;
        const result = await sendMessage(
            "http_head",
            JSON.stringify([null, this.reqcopyWith, url, headers])
        );
        return JSON.parse(result);
    }
    async get(url, headers) {
        headers = headers;
        const result = await sendMessage(
            "http_get",
            JSON.stringify([null, this.reqcopyWith, url, headers])
        );
        return JSON.parse(result);
    }
    async post(url, headers, body) {
        headers = headers;
        const result = await sendMessage(
            "http_post",
            JSON.stringify([null, this.reqcopyWith, url, headers, body])
        );
        return JSON.parse(result);
    }
    async put(url, headers, body) {
        headers = headers;
        const result = await sendMessage(
            "http_put",
            JSON.stringify([null, this.reqcopyWith, url, headers, body])
        );
        return JSON.parse(result);
    }
    async delete(url, headers, body) {
        headers = headers;
        const result = await sendMessage(
            "http_delete",
            JSON.stringify([null, this.reqcopyWith, url, headers, body])
        );
        return JSON.parse(result);
    }
    async patch(url, headers, body) {
        headers = headers;
        const result = await sendMessage(
            "http_patch",
            JSON.stringify([null, this.reqcopyWith, url, headers, body])
        );
        return JSON.parse(result);
    }
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
    request.headers.addAll(headers ?? {});
    http.StreamedResponse response = await client.send(request);
    final res = Response(
      "",
      response.statusCode,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
    Map<String, dynamic> resMap = res.toJson();
    resMap["body"] = await response.stream.bytesToString();
    return jsonEncode(resMap);
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
  for (var hop = 0; hop < 5; hop++) {
    package.checkRequest(uri);
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
      uri = uri.resolve(location);
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
