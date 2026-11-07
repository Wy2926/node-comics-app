import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/modules/manga/download/providers/download_gate.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;

class ChapterPageDownload extends ConsumerWidget {
  final Chapter chapter;

  const ChapterPageDownload({
    super.key,
    required this.chapter,
    this.mobile = false,
  });

  final bool mobile;

  void _startDownload(WidgetRef ref, {bool? useWifi}) async {
    if (isDownloadScheduled(chapter.id)) return;
    await downloadRepository.enqueue(chapter);
    ref.invalidate(downloadChapterProvider(chapter: chapter, useWifi: useWifi));
    ref.read(downloadChapterProvider(chapter: chapter, useWifi: useWifi));
  }

  void _sendFile(BuildContext context) async {
    final files = (await _downloadedFiles()).map((e) => XFile(e.path)).toList();
    if (files.isNotEmpty && context.mounted) {
      final box = context.mounted
          ? context.findRenderObject() as RenderBox?
          : null;
      final origin = box != null && box.hasSize
          ? (box.localToGlobal(Offset.zero) & box.size)
          : null;
      shareOrCopy(
        ShareParams(
          files: files,
          text: chapter.name,
          sharePositionOrigin: origin,
        ),
      );
    }
  }

  Future<List<File>> _downloadedFiles() async {
    final files = <File>[];
    for (final entity in await _downloadedFileEntities()) {
      if (entity is File && await entity.exists()) {
        files.add(entity);
      } else if (entity is Directory && await entity.exists()) {
        await for (final child in entity.list()) {
          if (child is File) {
            files.add(child);
          }
        }
      }
    }
    return files;
  }

  Future<List<FileSystemEntity>> _downloadedFileEntities() async {
    final name = chapter.name;
    if (name == null || name.isEmpty) return const [];
    final storageProvider = StorageProvider();
    final chapterName = name.replaceForbiddenCharacters(' ');
    final candidates = <FileSystemEntity>[];

    final mangaDir = await storageProvider.getMangaMainDirectory(chapter);
    if (mangaDir != null) {
      candidates.addAll([
        File(p.join(mangaDir.path, "$name.cbz")),
        File(p.join(mangaDir.path, "$chapterName.cbz")),
        File(p.join(mangaDir.path, "$chapterName.mp4")),
        File(p.join(mangaDir.path, "$name.html")),
      ]);
      final chapterDir = await storageProvider.getMangaChapterDirectory(
        chapter,
        mangaMainDirectory: mangaDir,
      );
      if (chapterDir != null) {
        candidates.add(File(p.join(chapterDir.path, "$chapterName.html")));
        candidates.add(chapterDir);
      }
    }
    return candidates;
  }

  void _downloadChapter(BuildContext context, WidgetRef ref, {bool? useWifi}) {
    _startDownload(ref, useWifi: useWifi);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final initialDownload = downloadRepository.getByChapterId(chapter.id);
    return SizedBox(
      height: mobile ? NodeLaneTokens.minTapTarget : 41,
      width: mobile ? NodeLaneTokens.minTapTarget : 35,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: mobile ? 0 : 3),
        child: StreamBuilder<List<Download>>(
          initialData: initialDownload != null ? [initialDownload] : const [],
          stream: downloadRepository.watchByChapterId(chapter.id),
          builder: (context, snapshot) {
            if (mobile) {
              return _mobileControl(context, ref, snapshot.data?.firstOrNull);
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final entries = snapshot.data!;
              final download = entries.first;

              // 1. Completely downloaded
              if (download.isDownload == true) {
                return PopupMenuButton<int>(
                  popUpAnimationStyle: popupAnimationStyle,
                  child: Icon(
                    size: 25,
                    Icons.check_circle,
                    color: Theme.of(context).iconTheme.color!
                        .withValues(alpha: 0.7),
                  ),
                  onSelected: (value) {
                    if (value == 0) {
                      _sendFile(context);
                    } else if (value == 1) {
                      chapter.deleteDownloadedFiles();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 0, child: Text(l10n.send)),
                    PopupMenuItem(value: 1, child: Text(l10n.delete)),
                  ],
                );
              }

              // 2. Failed download state
              if ((download.failed ?? 0) > 0 &&
                  download.isStartDownload != true) {
                return PopupMenuButton<int>(
                  popUpAnimationStyle: popupAnimationStyle,
                  child: Icon(
                    Icons.error_outline_outlined,
                    color: Colors.red,
                    size: 25,
                  ),
                  onSelected: (value) {
                    if (value == 0) {
                      _downloadChapter(context, ref);
                    } else if (value == 1) {
                      _cancelTasks(downloadId: download.id);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 0, child: Text(l10n.retry)),
                    PopupMenuItem(value: 1, child: Text(l10n.cancel)),
                  ],
                );
              }

              // 3. Active download in progress or queued
              if (download.isStartDownload == true) {
                final succeeded = download.succeeded ?? 0;
                final total = download.total ?? 0;

                if (succeeded > 0 && total > 0) {
                  final progress = (succeeded / total).clamp(0.0, 1.0);
                  return PopupMenuButton<int>(
                    popUpAnimationStyle: popupAnimationStyle,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            tween: Tween<double>(begin: 0, end: progress),
                            builder: (context, value, _) => SizedBox(
                              height: 2,
                              width: 2,
                              child: CircularProgressIndicator(
                                strokeWidth: 19,
                                value: value,
                                color: Theme.of(context).iconTheme.color!
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_downward_sharp,
                            color: progress > 0.5
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Theme.of(context).iconTheme.color!
                                      .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    onSelected: (value) {
                      if (value == 0) {
                        _cancelTasks(downloadId: download.id);
                      } else if (value == 1) {
                        _downloadChapter(context, ref, useWifi: false);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 1, child: Text(l10n.retry)),
                      PopupMenuItem(value: 0, child: Text(l10n.cancel)),
                    ],
                  );
                }

                // Started / queued with zero progress yet
                return PopupMenuButton<int>(
                  popUpAnimationStyle: popupAnimationStyle,
                  child: _DownloadProgressIcon(isLoading: true),
                  onSelected: (value) {
                    if (value == 0) {
                      _cancelTasks(downloadId: download.id);
                    } else if (value == 1) {
                      _downloadChapter(context, ref, useWifi: false);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text(l10n.start_downloading),
                    ),
                    PopupMenuItem(value: 0, child: Text(l10n.cancel)),
                  ],
                );
              }

              // 4. Queued / paused but not started
              return IconButton(
                splashRadius: 5,
                iconSize: 17,
                onPressed: () {
                  _downloadChapter(context, ref);
                },
                icon: _DownloadProgressIcon(isLoading: false),
              );
            }

            // 5. Not downloaded
            return IconButton(
              splashRadius: 5,
              iconSize: 17,
              onPressed: () {
                _downloadChapter(context, ref);
              },
              icon: _DownloadProgressIcon(isLoading: false),
            );
          },
        ),
      ),
    );
  }

  Widget _mobileControl(
    BuildContext context,
    WidgetRef ref,
    Download? download,
  ) {
    final l10n = context.l10n, icons = NodeLaneIcons.of(context);
    final completed = download?.isDownload == true;
    final active = !completed && download?.isStartDownload == true;
    final failed = !completed && !active && (download?.failed ?? 0) > 0;
    if (!completed && !active && !failed) {
      return NodeLaneIconButton(
        tooltip: l10n.download,
        icon: icons.download,
        onPressed: () => _downloadChapter(context, ref),
      );
    }
    final succeeded = download?.succeeded ?? 0, total = download?.total ?? 0;
    PopupMenuItem<VoidCallback> action(
      String label,
      IconData icon,
      VoidCallback onTap, {
      bool destructive = false,
    }) => PopupMenuItem(
      value: onTap,
      padding: EdgeInsets.zero,
      child: NodeLaneRow(title: label, icon: icon, destructive: destructive),
    );
    return NodeLaneMenuButton<VoidCallback>(
      tooltip: completed
          ? l10n.downloaded
          : failed
          ? l10n.retry
          : l10n.download,
      icon: completed
          ? icons.downloaded
          : failed
          ? icons.error
          : icons.download,
      busy: active,
      progress: succeeded > 0 && total > 0
          ? (succeeded / total).clamp(0.0, 1.0)
          : null,
      onSelected: (callback) => callback(),
      itemBuilder: (_) => completed
          ? [
              action(l10n.send, icons.share, () => _sendFile(context)),
              action(
                l10n.delete,
                icons.delete,
                () => chapter.deleteDownloadedFiles(),
                destructive: true,
              ),
            ]
          : [
              action(
                active && succeeded == 0 ? l10n.start_downloading : l10n.retry,
                icons.download,
                () => _downloadChapter(
                  context,
                  ref,
                  useWifi: active ? false : null,
                ),
              ),
              action(
                l10n.cancel,
                icons.close,
                () => _cancelTasks(downloadId: download!.id),
              ),
            ],
    );
  }

  void _cancelTasks({int? downloadId}) {
    chapter.cancelDownloads(downloadId);
  }
}

class _DownloadProgressIcon extends StatelessWidget {
  final bool isLoading;

  const _DownloadProgressIcon({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).iconTheme.color!.withValues(alpha: 0.7);
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Icon(size: 18, Icons.arrow_downward_sharp, color: color),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              value: isLoading ? null : 1,
              color: color,
              strokeWidth: 2,
            ),
          ),
        ),
      ],
    );
  }
}
