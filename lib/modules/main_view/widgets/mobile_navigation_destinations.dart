const mobileLibraryRoutes = {'/MangaLibrary', '/AnimeLibrary', '/NovelLibrary'};
const mobileLibraryTab = '_library';
const mobileOverflowTab = '_overflow';

/// Fold only presentation destinations; persisted routes/order are untouched.
List<String> groupedMobileRoutes(List<String> routes) {
  final result = <String>[];
  for (final route in routes) {
    final value = mobileLibraryRoutes.contains(route)
        ? mobileLibraryTab
        : route;
    if (!result.contains(value)) result.add(value);
  }
  return result;
}

List<String> visibleMobileTabs(List<String> grouped) =>
    grouped.length <= 5 ? grouped : [...grouped.take(4), mobileOverflowTab];

int selectedMobileTab(List<String> visible, String? location) {
  final value = mobileLibraryRoutes.contains(location)
      ? mobileLibraryTab
      : location;
  final index = visible.indexOf(value ?? '');
  return index >= 0
      ? index
      : visible.contains(mobileOverflowTab)
      ? visible.indexOf(mobileOverflowTab)
      : 0;
}
