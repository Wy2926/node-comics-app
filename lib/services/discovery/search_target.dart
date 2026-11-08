import 'package:mangayomi/models/manga.dart';

/// A destination in the installed-source search.
///
/// Discovery providers may return seasons and episodes, which the app opens
/// through their parent title. Keeping that decision with the result
/// prevents the UI from guessing which library or query to use.
final class SearchTarget {
  const SearchTarget({required this.query, required this.itemType});

  final String query;
  final ItemType itemType;
}
