import 'package:mangayomi/utils/log/logger.dart';

class ChapterRecognition {
  static final _unwanted = RegExp(
    r"\b(?:v|ver|vol|version|volume|season|staffel|saison|temporada|s|t)[^a-z]?[0-9]+",
  );
  static final _unwantedWhiteSpace = RegExp(r"\s(?=extra|special|omake)");
  static final _seasonKeyword = RegExp(
    r"\b(?:staffel|season|saison|temporada|s|t)\s*([0-9]+)",
  );
  static final _episodeKeyword = RegExp(
    r"\b(?:folge|episode|episodio|ep\.?)\s*([0-9]+(?:\.[0-9]+)?)",
  );
  // lookbehind for "ch." then zero or more spaces.
  static final _chNotation = RegExp(
    r"(?<=ch\.) *([0-9]+)(\.[0-9]+)?(\.?[a-z]+)?",
  );
  static final _bareNumber = RegExp(r"([0-9]+)(\.[0-9]+)?(\.?[a-z]+)?");
  static final _annualIssue = RegExp(
    r'^#?\s*(?:annual\b|(?:19|20)\d{2}\s+annual\b)',
    caseSensitive: false,
  );

  // Dedup so a repeatedly-rebuilt chapter list doesn't spam the log file
  // with the same unrecognized name on every rebuild.
  static final Set<String> _loggedUnrecognized = {};

  /// Sort key for a single chapter with no list context. Always buckets by
  /// season when present: key = season * 100000 + episode.
  int parseChapterNumber(String mangaTitle, String chapterName) {
    final (season, ep) = rawSeasonAndNumber(mangaTitle, chapterName);
    return _withSeason(season, ep ?? 0).toInt();
  }

  /// Episode number within a season, for tracker updates (MAL/AniList/Kitsu)
  /// and AniSkip results. The tracker entry is already season-specific,
  /// so season is never applied.
  int parseEpisodeNumber(String mangaTitle, String chapterName) {
    final (_, ep) = rawSeasonAndNumber(mangaTitle, chapterName);
    return (ep ?? 0).toInt();
  }

  /// Estimate internal whole-number gaps per season, not catalog completeness.
  /// Annuals have a separate sequence, often a year; decimal parts share their
  /// whole-number slot. Neither creates gaps in the regular series. Unknown
  /// names and numbers outside each observed range cannot establish a gap.
  /// Sorting and progress identities are independent of this estimate.
  int missingChapterCount(String mangaTitle, Iterable<String> chapterNames) {
    final seasons = <int, Set<int>>{};
    for (final chapterName in chapterNames) {
      final label = chapterName
          .toLowerCase()
          .replaceAll(mangaTitle.toLowerCase(), '')
          .trim();
      if (_annualIssue.hasMatch(label)) continue;
      final (season, ep) = rawSeasonAndNumber(mangaTitle, chapterName);
      if (ep != null) seasons.putIfAbsent(season, () => {}).add(ep.floor());
    }
    var missing = 0;
    for (final numbers in seasons.values) {
      if (numbers.length < 2) continue;
      final lowest = numbers.reduce((a, b) => a < b ? a : b);
      final highest = numbers.reduce((a, b) => a > b ? a : b);
      missing += (highest - lowest + 1) - numbers.length;
    }
    return missing;
  }

  /// Numeric grouping key for cross-release progress matching, with an optional
  /// [scanlator]. Null when no positive number is recognized. This is not a
  /// unique catalog identity: different URLs can carry the same numeric key.
  String? chapterIdentityKey(
    String mangaTitle,
    String chapterName, [
    String? scanlator,
  ]) {
    final (season, ep) = rawSeasonAndNumber(mangaTitle, chapterName);
    if (ep == null || ep <= 0) return null;
    return '$season::$ep::${scanlator ?? ''}';
  }

  /// Raw (season, episode) pair, unbucketed — season is 0 if none matched.
  /// Episode keeps its fractional part (e.g. 12.5) for sorting and grouping.
  /// Null means no number was detected (e.g. "Special", "Prologue"), distinct
  /// from a genuine chapter 0. Different URLs still require separate records.
  (int, double?) rawSeasonAndNumber(String mangaTitle, String chapterName) {
    final name = chapterName
        .toLowerCase()
        .replaceAll(mangaTitle.toLowerCase(), '')
        .trim()
        .replaceAll(',', '.')
        .replaceAll('-', '.')
        .replaceAll(_unwantedWhiteSpace, '');

    final season =
        int.tryParse(_seasonKeyword.firstMatch(name)?.group(1) ?? '') ?? 0;

    final epMatch = _episodeKeyword.firstMatch(name);
    if (epMatch != null) {
      return (season, double.parse(epMatch.group(1)!));
    }

    final stripped = name.replaceAll(_unwanted, '');
    final ep = _extractNumber(stripped);
    if (ep == null && _loggedUnrecognized.add('$mangaTitle|$chapterName')) {
      AppLogger.log(
        'ChapterRecognition: no number detected in "$chapterName" (manga: "$mangaTitle")',
        logLevel: LogLevel.warning,
      );
    }
    return (season, ep);
  }

  // Combines season + episode into a sortable number.
  double _withSeason(int season, double ep) =>
      season > 0 ? season * 100000 + ep : ep;

  double? _extractNumber(String name) {
    final chMatch = _chNotation.firstMatch(name);
    if (chMatch != null) return _fromMatch(chMatch);

    final numMatch = _bareNumber.firstMatch(name);
    if (numMatch != null) return _fromMatch(numMatch);

    return null;
  }

  double _fromMatch(Match match) {
    final base = double.parse(match.group(1)!);
    return base + _decimalAddition(match.group(2), match.group(3));
  }

  double _decimalAddition(String? decimal, String? alpha) {
    if (decimal != null && decimal.isNotEmpty) return double.parse(decimal);
    if (alpha != null && alpha.isNotEmpty) {
      if (alpha.contains("extra")) {
        return 0.99;
      }
      if (alpha.contains("omake")) {
        return 0.98;
      }
      if (alpha.contains("special")) {
        return 0.97;
      }
      final trimmedAlpha = alpha.replaceFirst('.', '');
      if (trimmedAlpha.length == 1) {
        return _parseAlphaPostFix(trimmedAlpha[0]);
      }
    }

    return 0.0;
  }

  double _parseAlphaPostFix(String alpha) {
    final number = alpha.codeUnitAt(0) - ('a'.codeUnitAt(0) - 1);
    if (number >= 10) return 0.0;
    return number / 10.0;
  }
}
