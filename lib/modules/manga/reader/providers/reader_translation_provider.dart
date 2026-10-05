import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/nodelane/nodelane_models.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_provider.dart';
import 'package:mangayomi/modules/nodelane/translation/translation_types.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/utils/extensions/others.dart';

import '../u_chap_data_preload.dart';

String readerTranslationKey(UChapDataPreload data) {
  final chapter = data.chapter;
  final manga = chapter?.manga.value;
  return translationKey([
    manga?.sourceId,
    manga?.source,
    manga?.lang,
    manga?.link,
    chapter?.url,
    chapter?.archivePath,
    chapter?.url == null ? data.directory?.path : null,
    data.index,
  ]);
}

String readerLocatorSignature(UChapDataPreload data) =>
    translationKey([data.pageUrl?.url, data.localImagePath, data.index]);

/// The only bridge that knows source headers and Flutter page data.
TranslationPage readerTranslationPage(UChapDataPreload data, WidgetRef ref) {
  // Capture the source provider while the reader is alive. The core receives
  // neither WidgetRef nor site cookies and never reads a translated variant.
  final provider = data.getImageProvider(ref, false);
  return TranslationPage(
    key: readerTranslationKey(data),
    locatorSignature: readerLocatorSignature(data),
    openOriginal: () async {
      final local = await data.getLocalFilePath;
      if (local != null && await File(local).exists()) return File(local);
      if (provider is CustomExtendedNetworkImageProvider) {
        await provider.getNetworkImageData();
        final path = await data.getLocalFilePath;
        if (path != null && await File(path).exists()) return File(path);
      }
      throw const NodeLaneException('SOURCE_UNAVAILABLE', '原图尚未加载，请重试。');
    },
  );
}

/// Both file-based and ImageProvider-based readers receive the same variant.
/// A variant never overwrites any field on the source page.
final readerTranslationImageProvider = Provider.autoDispose
    .family<UChapDataPreload, UChapDataPreload>((ref, source) {
      final key = readerTranslationKey(source);
      final display = ref.watch(
        translationProvider.select((service) {
          final records = service.forPage(key);
          final current = records.firstOrNull;
          final result = records
              .where(
                (r) =>
                    r.published &&
                    r.sourceSha == current?.sourceSha &&
                    r.locatorSignature == readerLocatorSignature(source),
              )
              .firstOrNull;
          if (service.showOriginal(key) ||
              result == null ||
              result.original ||
              result.resultPath == null ||
              !File(result.resultPath!).existsSync()) {
            return null;
          }
          return (
            id: result.id,
            path: result.resultPath!,
            width: result.width,
            height: result.height,
            sourceWidth: result.sourceWidth,
            sourceHeight: result.sourceHeight,
          );
        }),
      );
      if (display == null) return source;
      final service = ref.read(translationProvider);
      final record = service.store!.get(display.id)!;
      service.pin(record);
      ref.onDispose(() => service.unpin(display.id));
      final rect = source.srcRect;
      final mapped = rect == null
          ? null
          : Rect.fromLTRB(
              rect.left / display.sourceWidth * display.width,
              rect.top / display.sourceHeight * display.height,
              rect.right / display.sourceWidth * display.width,
              rect.bottom / display.sourceHeight * display.height,
            );
      final variant =
          UChapDataPreload(
              source.chapter,
              source.directory,
              source.pageUrl,
              true,
              null,
              source.index,
              source.chapterUrlModel,
              source.pageIndex,
              srcRect: mapped,
              localImagePath: display.path,
              isLastChapter: source.isLastChapter,
              mangaName: source.mangaName,
            )
            ..resolvedFilePath = display.path
            ..loadedWidth = display.width.toDouble()
            ..loadedHeight = display.height.toDouble();
      ref.onDispose(() {
        variant.decodedImage?.dispose();
        variant.decodedImage = null;
      });
      return variant;
    });
