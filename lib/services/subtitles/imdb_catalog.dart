import 'dart:convert';

import 'subtitle_http.dart';
import 'subtitle_service.dart';

/// Title discovery is independent of subtitle providers and their credentials.
class ImdbSubtitleCatalog implements SubtitleCatalog {
  const ImdbSubtitleCatalog(this.http);
  final SubtitleHttp http;

  @override
  Future<List<SubtitleTitle>> searchTitles(String query) async {
    if (query.trim().isEmpty) return [];
    final data = await _get(
      Uri.https('api.imdbapi.dev', '/search/titles', {'query': query.trim()}),
    );
    try {
      return (data['titles'] as List? ?? []).map((entry) {
        final type = (entry['type'] as String? ?? '')
            .replaceAll('_', '')
            .toLowerCase();
        return SubtitleTitle(
          id: entry['id'] as String,
          name: entry['primaryTitle'] as String? ?? '',
          isSeries: type == 'tvseries' || type == 'tvminiseries',
          year: entry['startYear'] as int?,
          rating: (entry['rating']?['aggregateRating'] as num?)?.toDouble(),
        );
      }).toList();
    } catch (_) {
      throw const SubtitleFailure(SubtitleFailureCode.response);
    }
  }

  @override
  Future<List<SubtitleEpisode>> episodes(String titleId) async {
    final data = await _get(
      Uri.https('api.imdbapi.dev', '/titles/$titleId/episodes'),
    );
    try {
      return (data['episodes'] as List? ?? []).map((entry) {
        return SubtitleEpisode(
          name: entry['title'] as String? ?? '',
          season: int.parse('${entry['season']}'),
          episode: int.parse('${entry['episodeNumber']}'),
        );
      }).toList();
    } catch (_) {
      throw const SubtitleFailure(SubtitleFailureCode.response);
    }
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );
    checkSubtitleResponse(response.statusCode);
    try {
      return jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
    } catch (_) {
      throw const SubtitleFailure(SubtitleFailureCode.response);
    }
  }
}
