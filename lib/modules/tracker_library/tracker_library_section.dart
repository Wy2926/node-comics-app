import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track_search.dart';

class TrackLibrarySection {
  String name;

  /// Stable across display languages; defaults to the legacy name for callers.
  final String cacheKey;
  Future<List<TrackSearch>?> Function() func;
  ItemType itemType;
  int syncId;
  bool isSearch;

  TrackLibrarySection({
    required this.name,
    String? cacheKey,
    required this.func,
    required this.syncId,
    this.itemType = ItemType.manga,
    this.isSearch = false,
  }) : cacheKey = cacheKey ?? name;
}
