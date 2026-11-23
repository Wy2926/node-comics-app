import 'dart:io';

import 'package:mangayomi/utils/downloaded_page_file.dart';

import 'reader_page_image.dart';

import 'u_chap_data_preload.dart';

/// Sniff local bytes because downloaded GIFs can have a .jpg file name.
/// Resolving a cached path does not fetch the remote image.
Future<bool> isReaderGif(UChapDataPreload data) async {
  if (data.pageUrl?.url.trim().toLowerCase().contains('.gif') == true) {
    return true;
  }
  final archive = data.archiveImage;
  if (archive != null) return isGifImage(archive);
  try {
    final source = await data.cachedReaderFile;
    if (source == null) return false;
    final file = await source.open();
    try {
      return isGifImage(await file.read(6));
    } finally {
      await file.close();
    }
  } on FileSystemException {
    return false;
  }
}
