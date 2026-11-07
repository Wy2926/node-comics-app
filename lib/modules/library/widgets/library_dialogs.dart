import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:path/path.dart' as p;

import 'mobile_bookshelf_actions.dart';
import 'mobile_bookshelf_import_sheet.dart';

/// Shows a dialog for deleting selected manga from library and/or device.
void showDeleteMangaDialog({
  required BuildContext context,
  required WidgetRef ref,
  required ItemType itemType,
}) {
  if (isMobile && !isTv) {
    // Freeze this confirmation's scope; changing the underlying selection must
    // never add another book to an already-open removal operation.
    final mangas = ref
        .read(mangasListStateProvider)
        .map(mangaRepository.findById)
        .whereType<Manga>()
        .where((manga) => manga.itemType == itemType)
        .toList(growable: false);
    showNodeLaneCatalogSheet<bool>(
      context,
      MobileBookshelfRemoveSheet(
        titles: [for (final manga in mangas) manga.name ?? ''],
        hasLocalArchives: mangas.any((manga) => manga.isLocalArchive ?? false),
        onRemove: (fromLibrary, downloads) async {
          await removeMobileLibrarySelection(
            mangas,
            fromLibrary: fromLibrary,
            downloads: downloads,
            removeFromLibrary: (manga) =>
                mangaRepository.removeFromLibrary(ref, manga),
          );
          if (!context.mounted) return;
          ref.read(mangasListStateProvider.notifier).clear();
          ref.read(isLongPressedStateProvider.notifier).update(false);
        },
      ),
      dismissible: false,
    );
    return;
  }
  bool deleteFromLib = false;
  bool deleteDownloads = false;
  showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final mangaIdsList = ref.watch(mangasListStateProvider);
          final l10n = l10nLocalizations(context)!;
          final List<Manga> mangasList = [];
          for (var id in mangaIdsList) {
            mangasList.add(mangaRepository.getById(id));
          }
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(l10n.remove),
                content: SizedBox(
                  height: 100,
                  width: context.width(0.8),
                  child: Column(
                    children: [
                      ListTileChapterFilter(
                        label: l10n.from_library,
                        onTap: () =>
                            setState(() => deleteFromLib = !deleteFromLib),
                        type: deleteFromLib ? 1 : 0,
                      ),
                      ListTileChapterFilter(
                        label: itemType != ItemType.anime
                            ? l10n.downloaded_chapters
                            : l10n.downloaded_episodes,
                        onTap: () =>
                            setState(() => deleteDownloads = !deleteDownloads),
                        type: deleteDownloads ? 1 : 0,
                      ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.cancel),
                      ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: () async {
                          // From Library
                          if (deleteFromLib) {
                            for (var manga in mangasList) {
                              await mangaRepository.removeFromLibrary(
                                ref,
                                manga,
                              );
                            }
                          }
                          // Downloaded Chapters
                          if (deleteDownloads) {
                            for (var manga in mangasList) {
                              String mangaDirectory = "";
                              if (manga.isLocalArchive ?? false) {
                                // For local archives the archive file IS the chapter — there is
                                // nothing to re-download. So we delete the physical files and
                                // remove all Isar records, mirroring a full library removal.
                                mangaDirectory = await _deleteImport(
                                  manga,
                                  mangaDirectory,
                                );
                                await mangaRepository.removeFromLibrary(
                                  ref,
                                  manga,
                                );
                              } else {
                                // Regular manga: delete downloaded files and their download
                                // records, but leave the manga and chapter metadata intact so
                                // the user can re-download later.
                                mangaDirectory = await _deleteDownload(
                                  manga,
                                  mangaDirectory,
                                );
                              }
                              // If the manga's base directory is now empty,
                              // remove it too so we don't leave orphaned folders on disk.
                              if (mangaDirectory.isNotEmpty) {
                                final path = Directory(mangaDirectory);
                                if (path.existsSync() &&
                                    path.listSync().isEmpty) {
                                  path.deleteSync(recursive: true);
                                }
                              }
                            }
                          }

                          ref.read(mangasListStateProvider.notifier).clear();
                          ref
                              .read(isLongPressedStateProvider.notifier)
                              .update(false);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(l10n.ok),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}

/// Deletes the physical archive files (zip/cbz/mp4/epub) for a local-archive
/// manga from disk. Returns the parent directory path so the caller can clean
/// up the now-empty folder afterwards.
Future<String> _deleteImport(
  Manga manga,
  String mangaDirectory, {
  bool reportErrors = false,
}) async {
  for (var chapter in manga.chapters) {
    final path = chapter.archivePath;
    if (path == null) continue;
    final resolvedPath = await resolveLocalArchivePath(path);
    final chapterFile = File(resolvedPath);
    if (mangaDirectory.isEmpty) {
      mangaDirectory = p.dirname(resolvedPath);
    }
    try {
      if (chapterFile.existsSync()) {
        chapterFile.deleteSync();
      }
    } catch (_) {
      if (reportErrors) rethrow;
    }
  }
  return mangaDirectory;
}

/// Reuses the existing file/record operations. Local files have to be handled
/// before removing their chapter records; a local book is removed only once
/// even when both choices are selected. No retries after a partial failure.
Future<void> removeMobileLibrarySelection(
  List<Manga> mangas, {
  required bool fromLibrary,
  required bool downloads,
  required Future<void> Function(Manga) removeFromLibrary,
}) async {
  if (!fromLibrary && !downloads) return;
  for (final manga in mangas) {
    final local = manga.isLocalArchive ?? false;
    var directory = '';
    if (downloads) {
      directory = local
          ? await _deleteImport(manga, directory, reportErrors: true)
          : await _deleteDownload(manga, directory);
    }
    if (fromLibrary || (downloads && local)) {
      await removeFromLibrary(manga);
    }
    if (directory.isNotEmpty) {
      final folder = Directory(directory);
      if (folder.existsSync() && folder.listSync().isEmpty) {
        folder.deleteSync();
      }
    }
  }
}

/// Deletes the downloaded chapter files for a regular (non-local-archive)
/// manga from disk, then cleans up the corresponding Isar download records.
/// Returns the manga's base directory path so the caller can remove the
/// folder if it is left empty.
Future<String> _deleteDownload(Manga manga, String mangaDirectory) async {
  Directory? mangaDir;
  final downloadedIds = (await downloadRepository.getAllIds()).toSet();

  if (downloadedIds.isEmpty) return mangaDirectory;

  for (var chapter in manga.chapters) {
    if (chapter.id == null || !downloadedIds.contains(chapter.id)) continue;

    await chapter.deleteDownloadedFiles();
    if (mangaDirectory.isEmpty) {
      mangaDir ??= await StorageProvider().getMangaMainDirectory(chapter);
      if (mangaDir != null) mangaDirectory = mangaDir.path;
    }
  }
  return mangaDirectory;
}

/// Shows a dialog for importing local files (zip, cbz, epub, video).
void showImportLocalDialog(BuildContext context, ItemType itemType) {
  if (isMobile && !isTv) {
    showNodeLaneCatalogSheet<int>(
      context,
      Consumer(
        builder: (_, sheetRef, _) => MobileBookshelfImportSheet(
          itemType: itemType,
          onImport: (splitChapters) => sheetRef.refresh(
            importArchivesFromFileProvider(
              null,
              itemType: itemType,
              init: true,
              splitChapters: splitChapters,
            ).future,
          ),
        ),
      ),
      dismissible: false,
    );
    return;
  }
  final l10n = l10nLocalizations(context)!;
  final filesText = switch (itemType) {
    ItemType.manga => ".zip, .cbz",
    ItemType.anime => ".mp4, .mkv, .avi, and more",
    ItemType.novel => ".epub",
  };
  bool isLoading = false;
  bool splitChapters = true;
  showDialog(
    context: context,
    barrierDismissible: !isLoading,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.import_local_file),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Consumer(
              builder: (context, ref, child) {
                return SizedBox(
                  height: itemType == ItemType.novel ? 150 : 100,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          if (itemType == ItemType.novel)
                            SwitchListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                l10n.split_epub_chapters,
                                style: const TextStyle(fontSize: 13),
                              ),
                              subtitle: Text(
                                l10n.split_epub_chapters_description,
                                style: const TextStyle(fontSize: 10),
                              ),
                              value: splitChapters,
                              onChanged: (v) =>
                                  setState(() => splitChapters = v),
                            ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() => isLoading = true);
                                        await ref.watch(
                                          importArchivesFromFileProvider(
                                            itemType: itemType,
                                            null,
                                            init: true,
                                            splitChapters: splitChapters,
                                          ).future,
                                        );
                                        setState(() => isLoading = false);
                                        if (!context.mounted) return;
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(Icons.archive_outlined),
                                          Text(
                                            "${l10n.import_files} ( $filesText )",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .color,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isLoading)
                        Container(
                          width: context.width(1),
                          height: context.height(1),
                          color: Colors.transparent,
                          child: UnconstrainedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor,
                              ),
                              height: 50,
                              width: 50,
                              child: const NodeLaneEmptyState.loading(),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      );
    },
  );
}
