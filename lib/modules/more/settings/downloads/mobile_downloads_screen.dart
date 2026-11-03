import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_text_dialog.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'providers/downloads_state_provider.dart';

class MobileDownloadsScreen extends ConsumerWidget {
  const MobileDownloadsScreen({
    super.key,
    required this.defaultFolder,
    required this.onPickLocation,
    required this.onAddFolder,
    required this.onRemoveFolder,
    required this.onRescan,
    required this.onHelp,
  });

  final Future<LocalFolder?> defaultFolder;
  final VoidCallback onPickLocation, onAddFolder, onRescan, onHelp;
  final ValueChanged<LocalFolder> onRemoveFolder;

  Future<int?> _number(
    BuildContext context, {
    required String title,
    required int value,
    required int min,
    required int max,
    String unit = '',
  }) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => MobileSettingsTextDialog(
        title: title,
        initialValue: '$value',
        helper: '$min–$max$unit',
        keyboardType: TextInputType.number,
        isValid: (text) {
          final number = int.tryParse(text.trim());
          return number != null && number >= min && number <= max;
        },
      ),
    );
    return result == null ? null : int.tryParse(result.trim());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final concurrent = ref.watch(allowConcurrentDownloadsStateProvider);
    final count = ref.watch(concurrentDownloadsStateProvider);
    final delay = ref.watch(downloadDelaySecondsStateProvider);
    final location = ref.watch(downloadLocationStateProvider);
    final folders = ref.watch(localFoldersStateProvider);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(context, title: l10n.downloads),
        body: SafeArea(
          top: false,
          child: ListView(
            key: const PageStorageKey('mobile-download-settings'),
            padding: NodeLaneTokens.pagePadding,
            children: [
              MobileSettingsGroup(
                title: l10n.network_settings,
                children: [
                  NodeLaneSwitchRow(
                    title: l10n.only_on_wifi,
                    icon: NodeLaneIcons.of(context).wifi,
                    value: ref.watch(onlyOnWifiStateProvider),
                    onChanged: ref.read(onlyOnWifiStateProvider.notifier).set,
                  ),
                  NodeLaneSwitchRow(
                    title: l10n.allow_concurrent_downloads,
                    subtitle: l10n.allow_concurrent_downloads_subtitle,
                    icon: NodeLaneIcons.of(context).download,
                    value: concurrent,
                    onChanged: ref
                        .read(allowConcurrentDownloadsStateProvider.notifier)
                        .set,
                  ),
                  if (concurrent)
                    NodeLaneRow(
                      title: l10n.concurrent_downloads,
                      subtitle: '$count',
                      icon: NodeLaneIcons.of(context).pageNumber,
                      onTap: () async {
                        final selected = await _number(
                          context,
                          title: l10n.concurrent_downloads,
                          value: count,
                          min: 1,
                          max: 255,
                        );
                        if (context.mounted &&
                            selected != null &&
                            selected != count) {
                          ref
                              .read(concurrentDownloadsStateProvider.notifier)
                              .set(selected);
                        }
                      },
                    ),
                  NodeLaneRow(
                    title: l10n.download_delay,
                    subtitle: delay == 0
                        ? l10n.off
                        : l10n.download_delay_value(delay),
                    icon: NodeLaneIcons.of(context).timer,
                    onTap: () async {
                      final selected = await _number(
                        context,
                        title: l10n.download_delay,
                        value: delay,
                        min: 0,
                        max: 120,
                        unit: ' s',
                      );
                      if (context.mounted &&
                          selected != null &&
                          selected != delay) {
                        ref
                            .read(downloadDelaySecondsStateProvider.notifier)
                            .set(selected);
                      }
                    },
                  ),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.data_and_storage,
                children: [
                  NodeLaneRow(
                    title: l10n.download_location,
                    subtitle: location.$2.isEmpty ? location.$1 : location.$2,
                    subtitleMaxLines: 2,
                    icon: NodeLaneIcons.of(context).folderOutline,
                    onTap: onPickLocation,
                  ),
                  NodeLaneSwitchRow(
                    title: l10n.save_as_cbz_archive,
                    icon: NodeLaneIcons.of(context).storage,
                    value: ref.watch(saveAsCBZArchiveStateProvider),
                    onChanged: ref
                        .read(saveAsCBZArchiveStateProvider.notifier)
                        .set,
                  ),
                  NodeLaneSwitchRow(
                    title: l10n.delete_download_after_reading,
                    icon: NodeLaneIcons.of(context).delete,
                    value: ref.watch(deleteDownloadAfterReadingStateProvider),
                    onChanged: ref
                        .read(deleteDownloadAfterReadingStateProvider.notifier)
                        .set,
                  ),
                ],
              ),
              FutureBuilder<LocalFolder?>(
                future: defaultFolder,
                builder: (context, snapshot) => MobileSettingsGroup(
                  title: l10n.local_folder,
                  children: [
                    if (snapshot.data?.path != null)
                      _FolderRow(folder: snapshot.data!, isDefault: true),
                    for (final folder in folders)
                      _FolderRow(
                        key: ValueKey((folder.name, folder.path)),
                        folder: folder,
                        isDefault: false,
                        onRemove: () => onRemoveFolder(folder),
                      ),
                    NodeLaneRow(
                      title: l10n.add_local_folder,
                      icon: NodeLaneIcons.of(context).add,
                      onTap: onAddFolder,
                    ),
                    NodeLaneRow(
                      title: l10n.rescan_local_folder,
                      icon: NodeLaneIcons.of(context).refresh,
                      onTap: onRescan,
                    ),
                    NodeLaneRow(
                      title: l10n.local_folder_structure,
                      icon: NodeLaneIcons.of(context).info,
                      onTap: onHelp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FolderRow extends StatelessWidget {
  const _FolderRow({
    super.key,
    required this.folder,
    required this.isDefault,
    this.onRemove,
  });
  final LocalFolder folder;
  final bool isDefault;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    return NodeLaneDisclosure(
      key: PageStorageKey((
        'download-folder',
        isDefault,
        folder.name,
        folder.path,
      )),
      title: folder.name ?? '',
      subtitle: isDefault ? l10n.default0 : l10n.custom,
      icon: isDefault
          ? NodeLaneIcons.of(context).browserStart
          : NodeLaneIcons.of(context).folderOutline,
      child: Padding(
        padding: NodeLaneTokens.groupPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SelectableText(
                folder.path ?? '',
                key: const PageStorageKey('download-folder-path'),
                style: colors.readerSecondary,
              ),
            ),
            if (onRemove != null)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: onRemove,
                  icon: Icon(NodeLaneIcons.of(context).delete),
                  label: Text(l10n.delete),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
