import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/reader/reader_translation.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_image_actions.dart';
import 'package:mangayomi/modules/widgets/image_actions_panel.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';

import '../reader_page_image.dart';

import 'package:mangayomi/utils/manga_cover_actions.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

Future<void> showReaderImageActions({
  required BuildContext context,
  required Offset globalPosition,
  required UChapDataPreload data,
  required Manga manga,
  required String chapterName,
}) async {
  if (!context.mounted ||
      data.isTransitionPage ||
      ModalRoute.of(context)?.isCurrent != true) {
    return;
  }
  final translationActions = ReaderTranslationHost.imageActions(context, data);
  final point = (context.findRenderObject()! as RenderBox).globalToLocal(
    globalPosition,
  );
  final actualChapter = data.chapter?.name ?? chapterName;
  final name = "${manga.name} $actualChapter - ${data.pageIndex}".replaceAll(
    RegExp(r'[^a-zA-Z0-9 .()\-\s]'),
    '_',
  );
  final Widget panel;
  final providers = ProviderScope.containerOf(context, listen: false);
  Future<Uint8List?> readOriginal() async =>
      data.original.archiveImage ??
      await (await data.readerFile(providers))?.readAsBytes();
  if (isMobile && !isTv) {
    final pageIndex = data.index ?? data.pageIndex;
    panel = MobileReaderImageActions(
      translationActions: translationActions,
      bookTitle: manga.name ?? '',
      chapterTitle: actualChapter,
      pageNumber: pageIndex == null ? null : pageIndex + 1,
      loadImage: readOriginal,
      onSave: (bytes) => saveReaderPageImage(bytes, name),
      onShare: (context, bytes) => _shareReaderPageImage(context, bytes, name),
      onSetCover: (bytes) => setReaderPageCover(manga, bytes),
    );
  } else {
    final bytes = await readOriginal();
    if (bytes == null ||
        !context.mounted ||
        ModalRoute.isCurrentOf(context) != true) {
      return;
    }
    panel = ImageActionsPanel(
      footer: translationActions,
      onSetCover: (row) async {
        if (!await confirmUseAsMangaCover(row) || !row.mounted) return;
        await applyMangaCover(row, manga, bytes);
        if (row.mounted) Navigator.pop(row);
      },
      onShare: (row) => _shareReaderPageImage(row, bytes, name),
      onSave: (row) async {
        try {
          await saveReaderPageImage(bytes, name);
          if (row.mounted) {
            showNodeLaneNotice(
              row.l10n.picture_saved,
              kind: NodeLaneNoticeKind.success,
            );
          }
        } catch (_) {
          if (row.mounted) {
            showNodeLaneNotice(
              row.l10n.reader_image_action_failed,
              kind: NodeLaneNoticeKind.error,
            );
          }
        }
      },
    );
  }
  await showNodeLaneBubble<void>(
    context,
    localPoint: point,
    label: context.l10n.reader_image_actions,
    width: NodeLaneTokens.bubbleFormWidth,
    child: panel,
  );
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
      files: [
        XFile.fromData(
          bytes,
          name: '$fileName$ext',
          mimeType: mimeTypeForImageExtension(ext),
        ),
      ],
      fileNameOverrides: ['$fileName$ext'],
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    ),
    fallbackName: '$fileName$ext',
  );
}
