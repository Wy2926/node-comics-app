import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mangayomi/utils/downloaded_page_file.dart';

import 'reader_page_image.dart';

import 'u_chap_data_preload.dart';

/// Sniff local bytes because downloaded GIFs can have a .jpg file name.
/// Resolving a cached path does not fetch the remote image.
Future<ImageProvider?> readerGif(
  UChapDataPreload data,
  ProviderContainer providers,
) async {
  try {
    if (data.original.isArchiveEntry) {
      final bytes = await data.archiveBytes(providers);
      return bytes != null && isGifImage(bytes) ? MemoryImage(bytes) : null;
    }
    if (data.pageUrl?.url.trim().toLowerCase().contains('.gif') == true) {
      return data.getImageProvider(providers, true);
    }
    final source = await data.cachedReaderFile(providers);
    if (source == null) return null;
    final file = await source.open();
    try {
      return isGifImage(await file.read(6))
          ? data.getImageProvider(providers, true)
          : null;
    } finally {
      await file.close();
    }
  } catch (_) {
    // Sniffing is optional. The image widget owns source errors and retries.
    return null;
  }
}
