import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/local_directory_access.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_text_dialog.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:mangayomi/utils/platform_utils.dart';
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

  Future<void> _addLocalFolder() async {
    final result = await _pickDirectory();
    if (!mounted || result == null) return;
    final name = await _showLocalFolderNameDialog(
      context,
      LocalFolder.fromPath(path: result).name ?? p.basename(result),
    );
    if (!mounted || name == null || name.trim().isEmpty) return;
    final folders = ref.read(localFoldersStateProvider).toList()
      ..add(LocalFolder(name: name.trim(), path: result));
    ref.read(localFoldersStateProvider.notifier).set(folders);
  }

  Future<void> _removeLocalFolder(LocalFolder folder) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(l10n.delete),
        content: Text('${folder.name ?? ''}\n${folder.path ?? ''}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.ok),
          ),
        ],
      ),
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
    if (isMobile && !isTv) {
      return MobileDownloadsScreen(
        defaultFolder: _defaultFolder,
        onPickLocation: _chooseDownloadLocation,
        onAddFolder: _addLocalFolder,
        onRemoveFolder: _removeLocalFolder,
        onRescan: () => ref.read(scanLocalLibraryProvider.future),
        onHelp: () => _showHelpDialog(context),
      );
    }
    final saveAsCBZArchiveState = ref.watch(saveAsCBZArchiveStateProvider);
    final deleteDownloadAfterReading = ref.watch(
      deleteDownloadAfterReadingStateProvider,
    );
    final onlyOnWifiState = ref.watch(onlyOnWifiStateProvider);
    final concurrentDownloads = ref.watch(concurrentDownloadsStateProvider);
    final allowConcurrentDownloads = ref.watch(
      allowConcurrentDownloadsStateProvider,
    );
    final downloadDelaySeconds = ref.watch(downloadDelaySecondsStateProvider);
    final localFolders = ref.watch(localFoldersStateProvider);
    final downloadLocation = ref.watch(downloadLocationStateProvider);
    final l10n = l10nLocalizations(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.downloads)),
      body: SingleChildScrollView(
        padding: tvPageInsets,
        child: Column(
          children: [
            SwitchListTile(
              value: onlyOnWifiState,
              title: Text(l10n.only_on_wifi),
              onChanged: (value) {
                ref.read(onlyOnWifiStateProvider.notifier).set(value);
              },
            ),
            SwitchListTile(
              value: saveAsCBZArchiveState,
              title: Text(l10n.save_as_cbz_archive),
              onChanged: (value) {
                ref.read(saveAsCBZArchiveStateProvider.notifier).set(value);
              },
            ),
            SwitchListTile(
              value: deleteDownloadAfterReading,
              title: Text(l10n.delete_download_after_reading),
              onChanged: (value) {
                ref
                    .read(deleteDownloadAfterReadingStateProvider.notifier)
                    .set(value);
              },
            ),
            SwitchListTile(
              value: allowConcurrentDownloads,
              title: Text(l10n.allow_concurrent_downloads),
              subtitle: Text(l10n.allow_concurrent_downloads_subtitle),
              onChanged: (value) {
                ref
                    .read(allowConcurrentDownloadsStateProvider.notifier)
                    .set(value);
              },
            ),
            if (allowConcurrentDownloads)
              ListTile(
                onTap: () {
                  int currentIntValue = concurrentDownloads;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(context.l10n.concurrent_downloads),
                        content: StatefulBuilder(
                          builder: (context, setState) => SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NumberPicker(
                                  value: currentIntValue,
                                  minValue: 1,
                                  maxValue: 255,
                                  step: 1,
                                  haptics: true,
                                  textMapper: (numberText) => numberText,
                                  onChanged: (value) =>
                                      setState(() => currentIntValue = value),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  context.l10n.cancel,
                                  style: TextStyle(color: context.primaryColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  ref
                                      .read(
                                        concurrentDownloadsStateProvider
                                            .notifier,
                                      )
                                      .set(currentIntValue);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  context.l10n.ok,
                                  style: TextStyle(color: context.primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                title: Text(context.l10n.concurrent_downloads),
                subtitle: Text(
                  "$concurrentDownloads",
                  style: TextStyle(fontSize: 11, color: context.secondaryColor),
                ),
              ),
            ListTile(
              onTap: () {
                int currentDelay = downloadDelaySeconds;
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.download_delay),
                      content: StatefulBuilder(
                        builder: (context, setState) => SizedBox(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NumberPicker(
                                value: currentDelay,
                                minValue: 0,
                                maxValue: 120,
                                step: 1,
                                haptics: true,
                                textMapper: (numberText) => numberText,
                                onChanged: (value) =>
                                    setState(() => currentDelay = value),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                context.l10n.cancel,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(
                                      downloadDelaySecondsStateProvider
                                          .notifier,
                                    )
                                    .set(currentDelay);
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.ok,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.download_delay),
              subtitle: Text(
                downloadDelaySeconds == 0
                    ? l10n.download_delay_subtitle
                    : "$downloadDelaySeconds s (+ jitter)",
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: _chooseDownloadLocation,
              title: Text(l10n.download_location),
              subtitle: Text(
                downloadLocation.$2.isEmpty
                    ? downloadLocation.$1
                    : downloadLocation.$2,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: _addLocalFolder,
              title: Text(context.l10n.add_local_folder),
            ),
            ListTile(
              onTap: () async => ref.read(scanLocalLibraryProvider.future),
              title: Text(context.l10n.rescan_local_folder),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          context.l10n.local_folder,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        IconButton.outlined(
                          tooltip: context.l10n.local_folder_structure,
                          onPressed: () => _showHelpDialog(context),
                          icon: const Icon(Icons.question_mark),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<LocalFolder?>(
                    future: _defaultFolder,
                    builder: (context, snapshot) => Column(
                      children: [
                        if (snapshot.data?.path != null)
                          _buildLocalFolder(
                            l10n,
                            localFolders,
                            snapshot.data!,
                            isDefault: true,
                          ),
                        ...localFolders.map(
                          (e) => _buildLocalFolder(l10n, localFolders, e),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showLocalFolderNameDialog(
    BuildContext context,
    String initialName,
  ) async {
    if (isMobile && !isTv) {
      return showDialog<String>(
        context: context,
        builder: (_) => MobileSettingsTextDialog(
          title: context.l10n.name,
          initialValue: initialName,
          isValid: (value) => value.trim().isNotEmpty,
        ),
      );
    }
    final controller = TextEditingController(text: initialName);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.name),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: context.l10n.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
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

    Widget buildSubFolder((String, dynamic) data, int level) {
      if (data.$2 is List) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  for (int i = 1; i < level; i++)
                    const WidgetSpan(child: SizedBox(width: 20)),
                  if (level > 0)
                    WidgetSpan(child: Icon(Icons.subdirectory_arrow_right)),
                  WidgetSpan(child: Icon(Icons.folder)),
                  const WidgetSpan(child: SizedBox(width: 5)),
                  TextSpan(text: data.$1),
                ],
              ),
            ),
            ...(data.$2 as List<(String, dynamic)>).map(
              (e) => buildSubFolder(e, level + 1),
            ),
          ],
        );
      }
      return Text.rich(
        TextSpan(
          children: [
            for (int i = 1; i < level; i++)
              const WidgetSpan(child: SizedBox(width: 20)),
            if (level > 0)
              WidgetSpan(child: Icon(Icons.subdirectory_arrow_right)),
            WidgetSpan(child: Icon(data.$2 as IconData)),
            const WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(text: data.$1),
          ],
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        if (isMobile && !isTv) {
          return AlertDialog(
            scrollable: true,
            title: Text(context.l10n.local_folder_structure),
            content: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: buildSubFolder(data, 0),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.l10n.close),
              ),
            ],
          );
        }
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(context.l10n.local_folder_structure),
              content: SizedBox(
                width: context.width(0.6),
                height: context.height(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(child: buildSubFolder(data, 0)),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(context.l10n.cancel),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLocalFolder(
    AppLocalizations l10n,
    List<LocalFolder> localFolders,
    LocalFolder folder, {
    bool isDefault = false,
  }) {
    final folderName = folder.name ?? "";
    final folderPath = folder.path ?? "";
    return Card(
      key: Key('folder_${folderName}_${folderPath.hashCode}'),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary
                  .withValues(alpha: 0.12),
              child: Icon(
                isDefault ? Icons.home_outlined : Icons.folder_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          folderName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isDefault)
                        _buildFolderLabel(l10n.default0)
                      else
                        _buildFolderLabel(l10n.custom),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    folderPath,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (!isDefault)
              IconButton(
                tooltip: l10n.delete,
                onPressed: () => _removeLocalFolder(folder),
                icon: const Icon(Icons.delete_outline),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderLabel(String label) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 58, maxWidth: 82),
      child: Container(
        height: 22,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}
