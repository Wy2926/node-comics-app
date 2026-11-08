import 'dart:io';

import 'package:mangayomi/utils/downloaded_page_file.dart';

import 'package:mangayomi/utils/extensions/others.dart';

import 'u_chap_data_preload.dart';

/// Sniff local bytes because downloaded GIFs can have a .jpg file name.
/// Resolving a cached path does not fetch the remote image.
Future<bool> isReaderGif(UChapDataPreload data) async {
  if (data.pageUrl?.url.trim().toLowerCase().contains('.gif') == true) {
    return true;
  }
  final archive = data.archiveImage;
  if (archive != null) return isGifImage(archive);
  final path =
      data.resolvedFilePath ??
      data.localImagePath ??
      await data.getLocalFilePath;
  if (path == null) return false;
  try {
    final file = await File(path).open();
    try {
      return isGifImage(await file.read(6));
    } finally {
      await file.close();
    }
  } on FileSystemException {
    return false;
  }
}
