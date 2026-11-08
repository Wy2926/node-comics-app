import 'dart:ui';

import '../u_chap_data_preload.dart';
import 'comic_reader_preferences.dart';

/// Display-only crops. The chapter loader always retains original source pages,
/// so changing direction, disabling splits or switching modes is reversible.
List<UChapDataPreload> projectComicPages(
  List<UChapDataPreload> sources,
  ComicReadingProfile profile,
  double viewportWidth,
) {
  if (!profile.splitPages(viewportWidth)) return List.unmodifiable(sources);
  return List.unmodifiable(
    sources.expand((page) {
      final width = page.loadedWidth, height = page.loadedHeight;
      if (page.isTransitionPage ||
          width == null ||
          height == null ||
          width <= height * 1.2) {
        return [page];
      }
      final crops = [
        Rect.fromLTWH(0, 0, width / 2, height),
        Rect.fromLTWH(width / 2, 0, width / 2, height),
      ];
      return (profile.turn == ComicPageTurn.right ? crops.reversed : crops).map(
        (rect) =>
            UChapDataPreload(
                page.chapter,
                page.directory,
                page.pageUrl,
                page.isLocale,
                page.archiveImage,
                page.index,
                page.chapterUrlModel,
                page.pageIndex,
                srcRect: rect,
                localImagePath: page.localImagePath,
              )
              ..resolvedFilePath = page.resolvedFilePath
              ..loadedWidth = rect.width
              ..loadedHeight = rect.height,
      );
    }),
  );
}
