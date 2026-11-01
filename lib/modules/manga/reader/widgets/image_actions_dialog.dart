import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_image_actions.dart';
import 'package:mangayomi/utils/manga_cover_actions.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/widgets/image_actions_sheet.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;

/// Bottom sheet dialog for long-press actions on manga images.
///
/// Provides options to:
/// - Set image as cover
/// - Share image
/// - Save image to gallery
class ImageActionsDialog {
  /// Shows the image actions dialog.
  ///
  /// Parameters:
  /// - [context]: Build context
  /// - [data]: The page data containing the image
  /// - [manga]: The manga the image belongs to
  /// - [chapterName]: Name of the chapter (for file naming)
  static Future<void> show({
    required BuildContext context,
    required UChapDataPreload data,
    required Manga manga,
    required String chapterName,
  }) async {
    if (!context.mounted ||
        data.isTransitionPage ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    if (isMobile && !isTv) {
      final actualChapter = data.chapter?.name ?? chapterName;
      final pageIndex = data.index ?? data.pageIndex;
      final name = "${manga.name} $actualChapter - ${data.pageIndex}"
          .replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_');
      await showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        showDragHandle: false,
        shape: NodeLaneTokens.readerSheetShape,
        builder: (_) => MobileReaderImageActions(
          bookTitle: manga.name ?? '',
          chapterTitle: actualChapter,
          pageNumber: pageIndex == null ? null : pageIndex + 1,
          loadImage: () => data.getImageBytes,
          onSave: (bytes) => saveReaderPageImage(bytes, name),
          onShare: (context, bytes) =>
              _shareReaderPageImage(context, bytes, name),
          onSetCover: (bytes) => setReaderPageCover(manga, bytes),
        ),
      );
      return;
    }
    final imageBytes = await data.getImageBytes;
    if (imageBytes == null || !context.mounted) return;

    final name = "${manga.name} $chapterName - ${data.pageIndex}".replaceAll(
      RegExp(r'[^a-zA-Z0-9 .()\-\s]'),
      '_',
    );

    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(maxWidth: context.width(1)),
      builder: (context) => _ImageActionsSheet(
        imageBytes: imageBytes,
        manga: manga,
        fileName: name,
      ),
    );
  }
}

/// The existing page export destination, extension detection and file contents.
Future<void> saveReaderPageImage(Uint8List bytes, String fileName) async {
  final dir = await StorageProvider().getGalleryDirectory();
  if (dir == null) throw StateError('Image directory unavailable');
  final ext = detectImageExtension(bytes);
  await File(p.join(dir.path, '$fileName$ext'))
      .writeAsBytes(bytes, flush: true);
}

/// A reader always targets an existing comic. Preserve changes made while the
/// image menu was open, and do not recreate a comic removed in the meantime.
Future<void> setReaderPageCover(Manga manga, Uint8List bytes) async {
  final cover = bytes.getCoverImage;
  if (cover == null) throw StateError('Image cannot be used as cover');
  await mangaRepository.writeTransaction(() {
    final current = mangaRepository.findById(manga.id!);
    if (current == null) throw StateError('Comic no longer available');
    current.customCoverImage = cover;
    current.updatedAt = DateTime.now().millisecondsSinceEpoch;
    mangaRepository.putSync(current);
  });
}

Future<void> _shareReaderPageImage(
  BuildContext context,
  Uint8List bytes,
  String fileName,
) async {
  if (!context.mounted) return;
  final box = context.findRenderObject();
  if (box is! RenderBox || !box.hasSize) {
    throw StateError('Share anchor unavailable');
  }
  final ext = detectImageExtension(bytes);
  await shareOrCopy(
    ShareParams(
      files: [XFile.fromData(bytes, mimeType: mimeTypeForImageExtension(ext))],
      fileNameOverrides: ['$fileName$ext'],
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    ),
    fallbackName: '$fileName$ext',
  );
}

class _ImageActionsSheet extends StatelessWidget {
  final Uint8List imageBytes;
  final Manga manga;
  final String fileName;

  const _ImageActionsSheet({
    required this.imageBytes,
    required this.manga,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return ImageActionsSheet(
      onSetCover: _setAsCover,
      onShare: _shareImage,
      onSave: _saveImage,
    );
  }

  Future<void> _setAsCover(BuildContext context) async {
    final confirmed = await confirmUseAsMangaCover(context);
    if (!confirmed || !context.mounted) return;
    await applyMangaCover(context, manga, imageBytes);
    if (context.mounted) Navigator.pop(context);
  }

  Future<void> _shareImage(BuildContext context) async {
    if (!context.mounted) return;

    final ext = detectImageExtension(imageBytes);
    final mime = mimeTypeForImageExtension(ext);

    final box = context.findRenderObject() as RenderBox?;
    await shareOrCopy(
      ShareParams(
        files: [
          XFile.fromData(imageBytes, name: '$fileName$ext', mimeType: mime),
        ],
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      ),
      fallbackName: '$fileName$ext',
    );
  }

  Future<void> _saveImage(BuildContext context) async {
    final dir = await StorageProvider().getGalleryDirectory();
    if (dir == null) return;
    final ext = detectImageExtension(imageBytes);

    final file = File(p.join(dir.path, "$fileName$ext"));
    await file.writeAsBytes(imageBytes, flush: true);

    if (context.mounted) botToast(context.l10n.picture_saved, second: 3);
  }
}
