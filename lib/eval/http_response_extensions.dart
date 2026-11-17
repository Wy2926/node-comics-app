// Keep the HTTP wire shape shared across eval backends.
import 'package:http/http.dart';

extension ResponseExtexsion on Response {
  String get _decodedBody {
    // Some servers append an empty MIME parameter; keep the declared charset.
    final contentType = headers['content-type'];
    if (contentType == null || !contentType.trimRight().endsWith(';')) {
      return body;
    }
    return Response.bytes(
      bodyBytes,
      statusCode,
      headers: {
        ...headers,
        'content-type': contentType.replaceFirst(RegExp(r'(;\s*)+$'), ''),
      },
    ).body;
  }

  Map<String, dynamic> toJson() => {
    'body': _decodedBody,
    'headers': headers,
    'isRedirect': isRedirect,
    'persistentConnection': persistentConnection,
    'reasonPhrase': reasonPhrase,
    'statusCode': statusCode,
    'request': {
      'contentLength': request?.contentLength,
      'finalized': request?.finalized,
      'followRedirects': request?.followRedirects,
      'headers': request?.headers,
      'maxRedirects': request?.maxRedirects,
      'method': request?.method,
      'persistentConnection': request?.persistentConnection,
      'url': request?.url.toString(),
    },
  };
}

extension ToMapExtension on Map? {
  Map<String, dynamic>? get toMapStringDynamic {
    return this?.map((key, value) => MapEntry(key.toString(), value));
  }

  Map<String, String>? get toMapStringString {
    return this?.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  }
}
