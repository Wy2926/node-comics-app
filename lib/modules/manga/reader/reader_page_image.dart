import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
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

  Future<File?> _localFile(ProviderContainer providers) async {
    if (isTransitionPage) return null;
    for (final path in {
      resolvedFilePath,
      sourcePage?.resolvedFilePath,
      localImagePath,
    }.nonNulls) {
      final file = File(path);
      final stat = await file.stat();
      if (stat.type == FileSystemEntityType.file && stat.size > 0) return file;
    }
    if (await archiveBytes(providers) case final archiveBytes?) {
      // An archive can be replaced in place with different pages.
      return cacheImageBytesToTempFile(
        tempDir: Directory.systemTemp,
        baseName: 'nodelane-comics_archive_${sha256.convert(archiveBytes)}',
        extension: detectImageExtension(archiveBytes),
        bytesProvider: () => archiveBytes,
      );
    }
    if (isLocale == true) {
      if (directory == null || index == null) return null;
      return findDownloadedPageFileAsync(directory!, index!);
    }
    return null;
  }

  Future<Uint8List?> archiveBytes(ProviderContainer providers) async {
    final source = original;
    final bytes = source.archiveImage;
    if (bytes != null || !source.isArchiveEntry) return bytes;
    final model = source.chapterUrlModel;
    final archive = model?.archive;
    if (model == null || archive == null) {
      throw const FileSystemException('Archive unavailable');
    }
    return archive.read(
      source.index!,
      model.uChapDataPreload,
      (path) async =>
          (await providers.read(getArchiveDataFromFileProvider(path).future))
              .images,
    );
  }

  Future<File?> cachedReaderFile(ProviderContainer providers) async =>
      await _localFile(providers) ??
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
      final file = await _localFile(providers);
      if (file != null) return file;
    }
    if (isTransitionPage || isLocale == true || _url.isEmpty) return null;
    final provider = _network(providers, interactive);
    if (reload) await provider.evict();
    return provider.loadFile(progress: progress);
  }

  Future<VoidCallback> retainReaderFile(ProviderContainer providers) async {
    final file = await readerFile(providers);
    if (file == null) throw StateError('Page image unavailable');
    return CustomExtendedNetworkImageProvider.retainFile(file);
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

  ImageProvider<Object> getImageProvider(
    ProviderContainer providers,
    bool interactive,
  ) {
    if (isTransitionPage) return const AssetImage(transparentAsset);
    if (isLocale != true) {
      return _network(providers, interactive);
    }
    if (original.archiveImage case final bytes?) return MemoryImage(bytes);
    if (resolvedFilePath case final path?) return FileImage(File(path));
    if (localImagePath case final path?) return FileImage(File(path));
    return FileImage(
      findDownloadedPageFile(directory!, index!) ??
          File(p.join(directory!.path, '${padIndex(index!)}.jpg')),
    );
  }
}
