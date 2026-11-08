import 'package:flutter/material.dart';

import '../settings/comic_reader_preferences.dart';

ColorFilter? buildReaderColorFilter(ComicReadingProfile profile) {
  if (!profile.invert && profile.brightness == 0 && profile.contrast == 1) {
    return null;
  }
  var scale = profile.contrast;
  var offset = 128 * (1 - scale) + 255 * profile.brightness;
  if (profile.invert) {
    scale = -scale;
    offset = 255 - offset;
  }
  return ColorFilter.matrix([
    scale,
    0,
    0,
    0,
    offset,
    0,
    scale,
    0,
    0,
    offset,
    0,
    0,
    scale,
    0,
    offset,
    0,
    0,
    0,
    1,
    0,
  ]);
}

Widget applyReaderColorFilter(Widget child, ComicReadingProfile profile) {
  final filter = buildReaderColorFilter(profile);
  return filter == null
      ? child
      : ColorFiltered(colorFilter: filter, child: child);
}
