import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'providers/auto_backup.dart';
import 'providers/backup_compression.dart';
import 'providers/backup_encryption.dart';
import 'providers/storage_usage.dart';

class MobileDataAndStorage extends ConsumerStatefulWidget {
  const MobileDataAndStorage({
    super.key,
    required this.onCreate,
    required this.onRestore,
    required this.onChooseDirectory,
    required this.onEncryptionChanged,
    required this.canChooseBackupLocation,
    required this.maintenance,
  });
  final VoidCallback onCreate;
  final Future<void> Function() onRestore;
  final Future<String?> Function() onChooseDirectory;
  final Future<void> Function(bool) onEncryptionChanged;
  final bool canChooseBackupLocation;
  final List<Widget> maintenance;

  @override
  ConsumerState<MobileDataAndStorage> createState() =>
      _MobileDataAndStorageState();
}

class _MobileDataAndStorageState extends ConsumerState<MobileDataAndStorage> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() operation) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await operation();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.failed)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _downloadLocation((String, String) location) async {
    final l10n = context.l10n;
    final selected = await showMobileSettingsPicker<bool>(
      context,
      title: l10n.download_location,
      current: location.$2.isNotEmpty,
      options: [
        MobileSettingOption(false, l10n.default0, subtitle: location.$1),
        MobileSettingOption(
          true,
          l10n.custom_location,
          subtitle: location.$2.isEmpty ? null : location.$2,
        ),
      ],
    );
    if (!mounted || selected == null) return;
    if (!selected.value) {
      if (location.$2.isNotEmpty) {
        ref.read(downloadLocationStateProvider.notifier).set('');
      }
      return;
    }
    await _run(() async {
      final path = await widget.onChooseDirectory();
      if (mounted && path != null && path != location.$2) {
        ref.read(downloadLocationStateProvider.notifier).set(path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final frequency = ref.watch(backupFrequencyStateProvider);
    final frequencies = [
      l10n.off,
      l10n.every_6_hours,
      l10n.every_12_hours,
      l10n.daily,
      l10n.every_2_days,
      l10n.weekly,
    ];
    final location = ref.watch(downloadLocationStateProvider);
    final backupLocation = ref.watch(autoBackupLocationStateProvider);
    final compression = ref.watch(backupCompressionLevelProvider);
    return NodeLaneSurface(
      child: PopScope(
        canPop: !_busy,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.data_and_storage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            bottom: _busy
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(2),
                    child: LinearProgressIndicator(minHeight: 2),
                  )
                : null,
          ),
          body: SafeArea(
            top: false,
            child: AbsorbPointer(
              absorbing: _busy,
              child: ListView(
                key: const PageStorageKey('mobile-data-and-storage'),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  MobileSettingsGroup(
                    title: l10n.backup_and_restore,
                    children: [
                      MobileSettingsLink(
                        title: l10n.create_backup,
                        subtitle: l10n.create_backup_subtitle,
                        icon: Icons.archive_outlined,
                        onTap: widget.onCreate,
                      ),
                      MobileSettingsLink(
                        title: l10n.restore_backup,
                        subtitle: l10n.restore_backup_subtitle,
                        icon: Icons.settings_backup_restore_rounded,
                        onTap: () => _run(widget.onRestore),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 24),
                    child: Text(
                      l10n.backup_and_restore_warning_info,
                      style: TextStyle(color: colors.muted),
                    ),
                  ),
                  MobileSettingsGroup(
                    title: l10n.automatic_backups,
                    children: [
                      MobileSettingsLink(
                        title: l10n.backup_frequency,
                        subtitle:
                            frequency >= 0 && frequency < frequencies.length
                            ? frequencies[frequency]
                            : l10n.unknown,
                        icon: Icons.schedule_rounded,
                        onTap: () async {
                          final selected = await showMobileSettingsPicker<int>(
                            context,
                            title: l10n.backup_frequency,
                            current: frequency,
                            options: [
                              for (var i = 0; i < frequencies.length; i++)
                                MobileSettingOption(i, frequencies[i]),
                            ],
                          );
                          if (mounted &&
                              selected != null &&
                              selected.value != frequency) {
                            ref
                                .read(backupFrequencyStateProvider.notifier)
                                .set(selected.value);
                          }
                        },
                      ),
                      if (widget.canChooseBackupLocation)
                        MobileSettingsLink(
                          title: l10n.backup_location,
                          subtitle: backupLocation.$2.isEmpty
                              ? backupLocation.$1
                              : backupLocation.$2,
                          icon: Icons.folder_copy_outlined,
                          onTap: () => _run(() async {
                            final path = await widget.onChooseDirectory();
                            if (mounted &&
                                path != null &&
                                path != backupLocation.$2) {
                              ref
                                  .read(
                                    autoBackupLocationStateProvider.notifier,
                                  )
                                  .set(path);
                            }
                          }),
                        ),
                    ],
                  ),
                  MobileSettingsGroup(
                    title: l10n.backup_options,
                    children: [
                      MobileSettingsSwitch(
                        title: l10n.encrypt_backups,
                        subtitle: l10n.encrypt_backups_info,
                        icon: Icons.lock_outline_rounded,
                        value: ref.watch(backupEncryptionEnabledProvider),
                        onChanged: _busy
                            ? null
                            : (value) =>
                                  _run(() => widget.onEncryptionChanged(value)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('${l10n.compression_level} · $compression'),
                            const SizedBox(height: 8),
                            Text(
                              l10n.compression_info(
                                DeflateLevel.defaultCompression,
                              ),
                              style: TextStyle(color: colors.muted),
                            ),
                            Slider(
                              min: 0,
                              max: 9,
                              divisions: 9,
                              value: compression.clamp(0, 9).toDouble(),
                              label: '$compression',
                              semanticFormatterCallback: (value) =>
                                  '${l10n.compression_level} ${value.round()}',
                              onChanged: _busy
                                  ? null
                                  : (value) => ref
                                        .read(
                                          backupCompressionLevelProvider
                                              .notifier,
                                        )
                                        .update(value.round()),
                              onChangeEnd: (value) => _run(
                                () => ref
                                    .read(
                                      backupCompressionLevelProvider.notifier,
                                    )
                                    .set(value.round()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  MobileSettingsGroup(
                    title: l10n.storage,
                    children: [
                      MobileSettingsLink(
                        title: l10n.download_location,
                        subtitle: location.$2.isEmpty
                            ? location.$1
                            : location.$2,
                        subtitleMaxLines: 2,
                        icon: Icons.folder_open_rounded,
                        onTap: () => _downloadLocation(location),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          l10n.download_location_info,
                          style: TextStyle(color: colors.muted),
                        ),
                      ),
                      MobileSettingsLink(
                        title: l10n.clear_chapter_and_episode_cache,
                        subtitle: ref.watch(totalChapterCacheSizeStateProvider),
                        icon: Icons.cleaning_services_outlined,
                        onTap: () => _run(
                          () => ref
                              .read(totalChapterCacheSizeStateProvider.notifier)
                              .clearCache(),
                        ),
                      ),
                      MobileSettingsSwitch(
                        title:
                            l10n.clear_chapter_or_episode_cache_on_app_launch,
                        icon: Icons.auto_delete_outlined,
                        value: ref.watch(
                          clearChapterCacheOnAppLaunchStateProvider,
                        ),
                        onChanged: _busy
                            ? null
                            : ref
                                  .read(
                                    clearChapterCacheOnAppLaunchStateProvider
                                        .notifier,
                                  )
                                  .set,
                      ),
                    ],
                  ),
                  MobileSettingsGroup(
                    children: [
                      ExpansionTile(
                        key: const PageStorageKey('storage-maintenance'),
                        shape: const Border(),
                        collapsedShape: const Border(),
                        leading: Icon(
                          Icons.build_outlined,
                          color: colors.accent,
                        ),
                        title: Text(l10n.advanced),
                        children: widget.maintenance,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
