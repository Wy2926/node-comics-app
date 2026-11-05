import 'dart:convert';

import 'subtitle_http.dart';
import 'subtitle_service.dart';

/// Wyzie's wire format is confined here. Custom services use the same search
/// contract, with their own endpoint and optional Bearer token.
class WyzieSubtitleSource implements SubtitleSource {
  WyzieSubtitleSource.personal(this.http, String key)
    : endpoint = Uri.https('sub.wyzie.io', '/search'),
      _key = key,
      _token = '';

  WyzieSubtitleSource.custom(this.http, this.endpoint, {this._token = ''})
    : _key = '';

  final SubtitleHttp http;
  final Uri endpoint;
  final String _key, _token;

  Map<String, String> _headers(Uri uri) => {
    if (_token.isNotEmpty && uri.origin == endpoint.origin)
      'Authorization': 'Bearer $_token',
  };

  @override
  Future<List<SubtitleMatch>> search(SubtitleQuery query) async {
    final uri = endpoint.replace(
      queryParameters: {
        'id': query.titleId,
        if (query.season != null) 'season': '${query.season}',
        if (query.episode != null) 'episode': '${query.episode}',
        'encoding': 'utf-8',
        if (_key.isNotEmpty) 'key': _key,
      },
    );
    final response = await http.get(
      uri,
      headers: {..._headers(uri), 'Accept': 'application/json'},
    );
    // Wyzie represents a completed search with no matches as HTTP 400.
    if (response.statusCode == 400) {
      try {
        final message = jsonDecode(response.body)['message'];
        if (message == 'No subtitles found' ||
            message == 'No matching release found') {
          return [];
        }
      } catch (_) {}
    }
    checkSubtitleResponse(response.statusCode);
    try {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      final results = <SubtitleMatch>[];
      for (final entry in data.cast<Map<String, dynamic>>()) {
        final url = entry['url'];
        if (url is! String || url.isEmpty) continue;
        final download = endpoint.resolve(url);
        final format = (entry['format'] as String? ?? 'srt').toLowerCase();
        if (!isSubtitleHttpsUrl(download) ||
            !const {
              'srt',
              'ass',
              'ssa',
              'vtt',
              'sub',
              'txt',
            }.contains(format)) {
          continue;
        }
        final name = entry['media'] as String? ?? '';
        final language = entry['language'] as String? ?? '';
        results.add(
          SubtitleMatch(
            name: name,
            displayLanguage: entry['display'] as String? ?? language,
            format: format,
            load: () async {
              final file = await http.get(
                download,
                headers: _headers(download),
                maxBytes: 8 * 1024 * 1024,
              );
              checkSubtitleResponse(file.statusCode);
              try {
                final mime = file.headers['content-type']
                    ?.split(';')
                    .first
                    .trim();
                if (mime == 'application/json' || mime == 'text/html') {
                  throw const FormatException();
                }
                final text = utf8.decode(file.bodyBytes);
                if (text.trim().isEmpty) throw const FormatException();
                return SubtitleContent(
                  text: text,
                  name: name,
                  language: language,
                  format: format,
                );
              } catch (_) {
                throw const SubtitleFailure(SubtitleFailureCode.response);
              }
            },
          ),
        );
      }
      return results;
    } catch (_) {
      throw const SubtitleFailure(SubtitleFailureCode.response);
    }
  }
}
