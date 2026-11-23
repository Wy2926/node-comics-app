import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:path/path.dart' as p;

import 'u_chap_data_preload.dart';

/// The encoded, source-restored page, before display crops, scaling or translation.
extension ReaderPageImage on UChapDataPreload {
  static const _folder = 'cacheimagemanga';
  String get _url => pageUrl?.url.trim() ?? '';

  Future<File?> get _localFile async {
    if (isTransitionPage) return null;
    final resolved = resolvedFilePath;
    for (final path in {resolved, localImagePath}.nonNulls) {
      final file = File(path);
      final stat = await file.stat();
      if (stat.type == FileSystemEntityType.file && stat.size > 0) return file;
    }
    if (archiveImage case final bytes?) {
      // An archive can be replaced in place with different pages.
      return cacheImageBytesToTempFile(
        tempDir: Directory.systemTemp,
        baseName: 'nodelane-comics_archive_${sha256.convert(bytes)}',
        extension: detectImageExtension(bytes),
        bytesProvider: () => bytes,
      );
    }
    if (isLocale == true) {
      if (directory == null || index == null) return null;
      return findDownloadedPageFileAsync(directory!, index!);
    }
    return null;
  }

  Future<File?> get cachedReaderFile async =>
      await _localFile ??
      (isLocale == true || isTransitionPage || _url.isEmpty
          ? null
          : await _network(null, false).cachedFile);

  Future<File?> readerFile(
    ProviderContainer providers, {
    bool reload = false,
    bool interactive = false,
    StreamController<ImageChunkEvent>? progress,
  }) async {
    if (!reload || isLocale == true) {
      final file = await _localFile;
      if (file != null) return file;
    }
    if (isTransitionPage || isLocale == true || _url.isEmpty) return null;
    final provider = _network(providers, interactive);
    if (reload) await provider.evict();
    return provider.loadFile(progress: progress);
  }

  CustomExtendedNetworkImageProvider _network(
    ProviderContainer? providers,
    bool interactive,
  ) {
    final manga = chapter?.manga.value;
    return CustomExtendedNetworkImageProvider(
      _url,
      imageProcessing: pageUrl?.imageProcessing,
      cacheMaxAge: const Duration(days: 7),
      imageCacheFolderName: _folder,
      showCloudFlareError: interactive,
      headers: {
        if (providers != null && manga?.source != null && manga?.lang != null)
          ...providers.read(
            headersProvider(
              source: manga!.source!,
              lang: manga.lang!,
              sourceId: manga.sourceId,
            ),
          ),
        ...?pageUrl?.headers,
      },
    );
  }

  ImageProvider<Object> getImageProvider(WidgetRef ref, bool interactive) {
    if (isTransitionPage) return const AssetImage(transparentAsset);
    if (isLocale != true) {
      return _network(
        ProviderScope.containerOf(ref.context, listen: false),
        interactive,
      );
    }
    if (archiveImage case final bytes?) return MemoryImage(bytes);
    if (localImagePath case final path?) return FileImage(File(path));
    return FileImage(
      findDownloadedPageFile(directory!, index!) ??
          File(p.join(directory!.path, '${padIndex(index!)}.jpg')),
    );
  }
}
