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
        appBar: AppBar(
          title: Text(
            l10n.downloads,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            key: const PageStorageKey('mobile-download-settings'),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              MobileSettingsGroup(
                title: l10n.network_settings,
                children: [
                  MobileSettingsSwitch(
                    title: l10n.only_on_wifi,
                    icon: Icons.wifi_rounded,
                    value: ref.watch(onlyOnWifiStateProvider),
                    onChanged: ref.read(onlyOnWifiStateProvider.notifier).set,
                  ),
                  MobileSettingsSwitch(
                    title: l10n.allow_concurrent_downloads,
                    subtitle: l10n.allow_concurrent_downloads_subtitle,
                    icon: Icons.downloading_rounded,
                    value: concurrent,
                    onChanged: ref
                        .read(allowConcurrentDownloadsStateProvider.notifier)
                        .set,
                  ),
                  if (concurrent)
                    MobileSettingsLink(
                      title: l10n.concurrent_downloads,
                      subtitle: '$count',
                      icon: Icons.format_list_numbered_rounded,
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
                  MobileSettingsLink(
                    title: l10n.download_delay,
                    subtitle: delay == 0
                        ? l10n.off
                        : l10n.download_delay_value(delay),
                    icon: Icons.timer_outlined,
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
                  MobileSettingsLink(
                    title: l10n.download_location,
                    subtitle: location.$2.isEmpty ? location.$1 : location.$2,
                    subtitleMaxLines: 2,
                    icon: Icons.folder_open_rounded,
                    onTap: onPickLocation,
                  ),
                  MobileSettingsSwitch(
                    title: l10n.save_as_cbz_archive,
                    icon: Icons.folder_zip_outlined,
                    value: ref.watch(saveAsCBZArchiveStateProvider),
                    onChanged: ref
                        .read(saveAsCBZArchiveStateProvider.notifier)
                        .set,
                  ),
                  MobileSettingsSwitch(
                    title: l10n.delete_download_after_reading,
                    icon: Icons.auto_delete_outlined,
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
                    MobileSettingsLink(
                      title: l10n.add_local_folder,
                      icon: Icons.create_new_folder_outlined,
                      onTap: onAddFolder,
                    ),
                    MobileSettingsLink(
                      title: l10n.rescan_local_folder,
                      icon: Icons.refresh_rounded,
                      onTap: onRescan,
                    ),
                    MobileSettingsLink(
                      title: l10n.local_folder_structure,
                      icon: Icons.help_outline_rounded,
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
    return ExpansionTile(
      key: PageStorageKey((
        'download-folder',
        isDefault,
        folder.name,
        folder.path,
      )),
      shape: const Border(),
      collapsedShape: const Border(),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(
        isDefault ? Icons.home_outlined : Icons.folder_outlined,
        color: colors.accent,
      ),
      title: Text(
        folder.name ?? '',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        isDefault ? l10n.default0 : l10n.custom,
        style: TextStyle(fontSize: 13, color: colors.muted),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SelectableText(
            folder.path ?? '',
            key: const PageStorageKey('download-folder-path'),
            style: TextStyle(fontSize: 13, color: colors.muted),
          ),
        ),
        if (onRemove != null)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline),
              label: Text(l10n.delete),
            ),
          ),
      ],
    );
  }
}
