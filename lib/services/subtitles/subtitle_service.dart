/// The player consumes titles, subtitle choices and text, never service keys
/// or download URLs. A source is scoped to one configuration/account session.
abstract interface class SubtitleSource {
  Future<List<SubtitleMatch>> search(SubtitleQuery query);
}

abstract interface class SubtitleCatalog {
  Future<List<SubtitleTitle>> searchTitles(String query);
  Future<List<SubtitleEpisode>> episodes(String titleId);
}

class SubtitleSearchService {
  const SubtitleSearchService({required this.catalog, required this.source});
  final SubtitleCatalog catalog;
  final SubtitleSource source;
}

class SubtitleQuery {
  const SubtitleQuery(this.titleId, {this.season, this.episode})
    : assert((season == null) == (episode == null));
  final String titleId;
  final int? season, episode;
}

class SubtitleTitle {
  const SubtitleTitle({
    required this.id,
    required this.name,
    this.isSeries = false,
    this.year,
    this.rating,
  });
  final String id, name;
  final bool isSeries;
  final int? year;
  final double? rating;
}

class SubtitleEpisode {
  const SubtitleEpisode({
    required this.name,
    required this.season,
    required this.episode,
  });
  final String name;
  final int season, episode;
}

class SubtitleMatch {
  const SubtitleMatch({
    required this.name,
    required this.displayLanguage,
    required this.format,
    required this.load,
  });
  final String name, displayLanguage, format;

  /// Loading stays with the source that returned this choice; changing the
  /// configuration disposes that source's transport and invalidates its links.
  final Future<SubtitleContent> Function() load;
}

class SubtitleContent {
  const SubtitleContent({
    required this.text,
    required this.name,
    required this.language,
    required this.format,
  });
  final String text, name, language, format;
}

enum SubtitleFailureCode {
  configuration,
  authentication,
  quota,
  network,
  response,
}

class SubtitleFailure implements Exception {
  const SubtitleFailure(this.code);
  final SubtitleFailureCode code;

  // Never retain server bodies, keys or signed links in surfaced exceptions.
  @override
  String toString() => 'SubtitleFailure(${code.name})';
}
