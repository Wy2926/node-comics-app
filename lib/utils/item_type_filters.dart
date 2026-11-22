import 'package:mangayomi/models/manga.dart';

const libraryRoutes = {
  ItemType.manga: '/MangaLibrary',
  ItemType.anime: '/AnimeLibrary',
  ItemType.novel: '/NovelLibrary',
};

ItemType? libraryTypeForRoute(String? route) {
  for (final entry in libraryRoutes.entries) {
    if (entry.value == route) return entry.key;
  }
  return null;
}

List<ItemType> visibleItemTypes(List<String> hidden) => [
  for (final entry in libraryRoutes.entries)
    if (!hidden.contains(entry.value)) entry.key,
];

String? preferredLibraryRoute(List<String> visible, String? lastLibrary) {
  final libraries = visible.where(libraryRoutes.containsValue);
  return libraries.contains(lastLibrary) ? lastLibrary : libraries.firstOrNull;
}
