import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/modules/browse/extension/extension_detail.dart';
import 'package:mangayomi/modules/manga/detail/widgets/migrate_screen.dart';
import 'package:mangayomi/modules/mass_migration/mass_migration_source_selection_screen.dart';
import 'package:mangayomi/modules/manga/detail/providers/export_metadata.dart';
import 'package:mangayomi/modules/widgets/category_selection_dialog.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

Future<void> handleDetailOverflowAction({
  required int value,
  required BuildContext context,
  required WidgetRef ref,
  required Manga manga,
  required bool isLocalArchive,
  required Future<void> Function() onRefresh,
}) async {
  final l10n = l10nLocalizations(context)!;
  switch (value) {
    case 0:
      await onRefresh();
      break;
    case 1:
      await showCategorySelectionDialog(
        context: context,
        ref: ref,
        itemType: manga.itemType,
        singleManga: manga,
      );
      break;
    case 2:
      final source = getSource(
        manga.lang!,
        manga.source!,
        manga.sourceId,
        installedOnly: true,
      );
      if (source == null) return;
      final url = "${source.baseUrl}${manga.link!.getUrlWithoutDomain}";
      final box = context.findRenderObject() as RenderBox?;
      await shareOrCopy(
        ShareParams(
          text: url,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        ),
      );
      break;
    case 3:
      if (NodeLaneBubbleFlow.contains(context)) {
        await NodeLaneBubbleFlow.push<void>(
          context,
          MigrationScreen(manga: manga),
        );
        return;
      }
      context.push("/migrate", extra: manga);
      break;
    case 4:
      final source = getSource(
        manga.lang!,
        manga.source!,
        manga.sourceId,
        installedOnly: true,
      );
      if (source == null) {
        showNodeLaneNotice(l10n.source_not_added);
        return;
      }
      if (NodeLaneBubbleFlow.contains(context)) {
        await NodeLaneBubbleFlow.open(
          context,
          title: l10n.settings_source_preferences,
          child: ExtensionDetail(source: source),
        );
        return;
      }
      context.push('/extension_detail', extra: source);
      break;
    case 5:
      try {
        final result = await FilePicker.getDirectoryPath(
          linuxOptions: const LinuxOptions(lockParentWindow: true),
        );
        if (result != null && context.mounted) {
          final headers = isLocalArchive
              ? null
              : ref.read(
                  headersProvider(
                    source: manga.source!,
                    lang: manga.lang!,
                    sourceId: manga.sourceId,
                  ),
                );
          await exportMangaMetadata(
            manga: manga,
            directory: Directory(result),
            headers: headers,
          );
          showNodeLaneNotice(l10n.exported, kind: NodeLaneNoticeKind.success);
        }
      } catch (e) {
        showNodeLaneNotice(
          l10n.failed_to_export_metadata(e),
          kind: NodeLaneNoticeKind.error,
        );
      }
      break;
    case 6:
      if (NodeLaneBubbleFlow.contains(context)) {
        await NodeLaneBubbleFlow.push<void>(
          context,
          MassMigrationSourceSelectionScreen(
            itemType: manga.itemType,
            prioritizedManga: manga,
          ),
        );
        return;
      }
      context.push("/massMigration", extra: (manga.itemType, manga));
      break;
  }
}
