import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/modules/widgets/nodelane_setting_bubble.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/local_directory_access.dart';
import 'package:path/path.dart' as p;

import 'mobile_downloads_screen.dart';

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  late final _defaultFolder = getDefaultLocalFolder();
  bool _isPickingDirectory = false;

  Future<String?> _pickDirectory() async {
    if (_isPickingDirectory) return null;
    _isPickingDirectory = true;
    try {
      // A cancelled iOS picker must not open a second picker through fallback.
      return await (Platform.isIOS
          ? LocalDirectoryAccess.pickDirectory()
          : FilePicker.getDirectoryPath(
              linuxOptions: const LinuxOptions(lockParentWindow: true),
            ));
    } finally {
      _isPickingDirectory = false;
    }
  }

  Future<void> _chooseDownloadLocation() async {
    final result = await _pickDirectory();
    if (mounted && result != null) {
      ref.read(downloadLocationStateProvider.notifier).set(result);
    }
  }

  Future<void> _addLocalFolder(BuildContext anchor) async {
    final result = await _pickDirectory();
    if (!mounted || !anchor.mounted || result == null) return;
    final name = await showSettingText(
      anchor,
      title: context.l10n.name,
      initialValue:
          LocalFolder.fromPath(path: result).name ?? p.basename(result),
      isValid: (value) => value.trim().isNotEmpty,
    );
    if (!mounted || name == null || name.trim().isEmpty) return;
    final folders = ref.read(localFoldersStateProvider).toList()
      ..add(LocalFolder(name: name.trim(), path: result));
    ref.read(localFoldersStateProvider.notifier).set(folders);
  }

  Future<void> _removeLocalFolder(
    BuildContext anchor,
    LocalFolder folder,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showNodeLaneConfirmation(
      anchor,
      title: l10n.delete,
      message: '${folder.name ?? ''}\n${folder.path ?? ''}',
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!mounted || confirmed != true) return;
    final folders = ref.read(localFoldersStateProvider).toList()
      ..removeWhere(
        (entry) => entry.name == folder.name && entry.path == folder.path,
      );
    ref.read(localFoldersStateProvider.notifier).set(folders);
  }

  @override
  Widget build(BuildContext context) {
    return MobileDownloadsScreen(
      defaultFolder: _defaultFolder,
      onPickLocation: _chooseDownloadLocation,
      onAddFolder: _addLocalFolder,
      onRemoveFolder: _removeLocalFolder,
      onRescan: () => ref.read(scanLocalLibraryProvider.future),
      onHelp: _showHelp,
    );
  }

  void _showHelp(BuildContext context) {
    final data = (
      "LocalFolder",
      [
        (
          "MangaName",
          [
            ("cover.jpg", Icons.image_outlined),
            (
              "Chapter1",
              [
                ("Page1.jpg", Icons.image_outlined),
                ("Page2.jpeg", Icons.image_outlined),
                ("Page3.png", Icons.image_outlined),
                ("Page4.webp", Icons.image_outlined),
              ],
            ),
            ("Chapter2.cbz", Icons.folder_zip_outlined),
            ("Chapter3.zip", Icons.folder_zip_outlined),
            ("Chapter4.cbt", Icons.folder_zip_outlined),
            ("Chapter5.tar", Icons.folder_zip_outlined),
          ],
        ),
        (
          "AnimeName",
          [
            ("cover.jpg", Icons.image_outlined),
            ("Episode1.mp4", Icons.video_file_outlined),
            (
              "Episode1_subtitles",
              [
                ("en.srt", Icons.subtitles_outlined),
                ("de.srt", Icons.subtitles_outlined),
              ],
            ),
            ("Episode2.mov", Icons.video_file_outlined),
            ("Episode3.avi", Icons.video_file_outlined),
            ("Episode4.flv", Icons.video_file_outlined),
            ("Episode5.wmv", Icons.video_file_outlined),
            ("Episode6.mpeg", Icons.video_file_outlined),
            ("Episode7.mkv", Icons.video_file_outlined),
          ],
        ),
        (
          "NovelName",
          [
            ("cover.jpg", Icons.image_outlined),
            ("NovelName.epub", Icons.book_outlined),
          ],
        ),
      ],
    );

    Widget buildSubFolder((String, Object) entry, int level) {
      final (name, content) = entry;
      final children = content is List<(String, Object)> ? content : null;
      final label = Text.rich(
        TextSpan(
          children: [
            for (int i = 1; i < level; i++)
              const WidgetSpan(child: SizedBox(width: 20)),
            if (level > 0)
              WidgetSpan(child: Icon(Icons.subdirectory_arrow_right)),
            WidgetSpan(
              child: Icon(
                children == null ? content as IconData : Icons.folder,
              ),
            ),
            const WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(text: name),
          ],
        ),
      );
      if (children == null) return label;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label,
          for (final child in children) buildSubFolder(child, level + 1),
        ],
      );
    }

    showNodeLaneBubble<void>(
      context,
      label: context.l10n.local_folder_structure,
      width: NodeLaneTokens.bubbleFormWidth,
      child: NodeLaneBubblePanel(
        title: context.l10n.local_folder_structure,
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            primary: false,
            scrollDirection: Axis.horizontal,
            child: buildSubFolder(data, 0),
          ),
        ),
      ),
    );
  }
}
