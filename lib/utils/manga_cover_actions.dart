import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/manga_repository.dart';

/// Shows the "use this as cover" confirmation.
/// Returns whether the user confirmed.
Future<bool> confirmUseAsMangaCover(BuildContext context) =>
    showNodeLaneConfirmation(
      context,
      title: context.l10n.use_this_as_cover_art,
      confirmLabel: context.l10n.ok,
    );

/// Applies [bytes] as [manga]'s custom cover and saves it
Future<void> applyMangaCover(
  BuildContext context,
  Manga manga,
  Uint8List? bytes,
) async {
  final coverImage = bytes?.getCoverImage;
  if (coverImage == null) return;
  await mangaRepository.save(manga..customCoverImage = coverImage);
  if (context.mounted) {
    showNodeLaneNotice(
      context.l10n.cover_updated,
      seconds: 3,
      kind: NodeLaneNoticeKind.success,
    );
  }
}
