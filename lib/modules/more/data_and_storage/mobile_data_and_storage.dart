import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:archive/archive.dart';
import 'package:mangayomi/modules/more/widgets/mobile_account_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/services/translation/translation_service.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
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
    this.onClearCovers = clearCoverImageCache,
  });
  final VoidCallback onCreate;
  final Future<void> Function() onRestore;
  final Future<String?> Function() onChooseDirectory;
  final Future<void> Function(bool) onEncryptionChanged;
  final bool canChooseBackupLocation;
  final List<Widget> maintenance;
  final Future<void> Function() onClearCovers;

  @override
  ConsumerState<MobileDataAndStorage> createState() =>
      _MobileDataAndStorageState();
}

class _MobileDataAndStorageState extends ConsumerState<MobileDataAndStorage> {
  bool _busy = false, _confirming = false;

  Future<void> _run(Future<void> Function() operation) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await operation();
    } catch (_) {
      if (mounted) {
        showNodeLaneNotice(context.l10n.failed, kind: NodeLaneNoticeKind.error);
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

  Future<void> _clear(String title, Future<void> Function() operation) async {
    if (_busy || _confirming) return;
    _confirming = true;
    try {
      final confirmed = await showMobileSettingsConfirmation(
        context,
        title: title,
        message: context.l10n.settings_cache_confirmation(title),
        confirmLabel: context.l10n.settings_cache_clear,
      );
      if (mounted && confirmed) await _run(operation);
    } finally {
      _confirming = false;
    }
  }

  Future<void> _clearTranslation() async {
    final service = ref.read(translationServiceProvider);
    await service.initialize();
    if (service.busy) return;
    await service.clearResults();
    if (!mounted) return;
    showNodeLaneNotice(
      service.error ?? context.l10n.settings_translation_cache_done,
      kind: service.error == null
          ? NodeLaneNoticeKind.success
          : NodeLaneNoticeKind.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n,
        t = NodeLaneTokens.of(context),
        icons = NodeLaneIcons.of(context);
    final frequency = ref.watch(backupFrequencyStateProvider);
    final frequencies = [
      l.off,
      l.every_6_hours,
      l.every_12_hours,
      l.daily,
      l.every_2_days,
      l.weekly,
    ];
    final location = ref.watch(downloadLocationStateProvider);
    final backupLocation = ref.watch(autoBackupLocationStateProvider);
    final compression = ref.watch(backupCompressionLevelProvider);
    final cacheSize = ref.watch(totalChapterCacheSizeStateProvider);
    final translation = ref.watch(translationServiceProvider);

    Widget clearRow(
      String title,
      IconData icon,
      Future<void> Function() action, {
      String? subtitle,
      bool enabled = true,
    }) => NodeLaneRow(
      title: title,
      subtitle: subtitle,
      icon: icon,
      trailing: TextButton(
        onPressed: _busy || !enabled ? null : () => _clear(title, action),
        child: Text(l.settings_cache_clear),
      ),
    );

    return NodeLaneSurface(
      child: PopScope(
        canPop: !_busy,
        child: Scaffold(
          appBar: nodeLaneAppBar(
            context,
            title: l.settings_storage_backup,
            busy: _busy,
          ),
          body: SafeArea(
            top: false,
            child: AbsorbPointer(
              absorbing: _busy,
              child: ListView(
                key: const PageStorageKey('mobile-data-and-storage'),
                padding: NodeLaneTokens.pagePadding,
                children: [
                  MobileSettingsGroup(
                    title: l.backup_and_restore,
                    children: [
                      NodeLaneRow(
                        title: l.create_backup,
                        icon: icons.backup,
                        onTap: widget.onCreate,
                      ),
                      NodeLaneRow(
                        title: l.restore_backup,
                        icon: icons.restore,
                        onTap: () => _run(widget.onRestore),
                      ),
                      NodeLaneRow(
                        title: l.automatic_backups,
                        icon: icons.refresh,
                        value: frequency >= 0 && frequency < frequencies.length
                            ? frequencies[frequency]
                            : l.unknown,
                        onTap: () async {
                          final selected = await showMobileSettingsPicker<int>(
                            context,
                            title: l.backup_frequency,
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
                    ],
                  ),
                  MobileSettingsGroup(
                    title: l.settings_local_cache,
                    children: [
                      clearRow(
                        l.settings_chapter_cache,
                        icons.categories,
                        () => ref
                            .read(totalChapterCacheSizeStateProvider.notifier)
                            .clearCache(),
                        subtitle: cacheSize,
                      ),
                      clearRow(
                        l.settings_cover_cache,
                        icons.image,
                        widget.onClearCovers,
                      ),
                      ListenableBuilder(
                        listenable: translation,
                        builder: (context, _) => clearRow(
                          l.settings_translation_cache,
                          icons.translate,
                          _clearTranslation,
                          subtitle: l.settings_translation_cache_hint,
                          enabled: !translation.busy,
                        ),
                      ),
                    ],
                  ),
                  MobileSettingsGroup(
                    children: [
                      NodeLaneRow(
                        title: l.download_location,
                        icon: icons.folderOutline,
                        value: location.$2.isEmpty
                            ? l.default0
                            : l.custom_location,
                        onTap: () => _downloadLocation(location),
                      ),
                    ],
                  ),
                  NodeLaneDisclosure(
                    title: l.settings_advanced_options,
                    icon: icons.adjustments,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: NodeLaneTokens.groupPadding,
                          child: Text(
                            l.backup_and_restore_warning_info,
                            style: t.readerSecondary,
                          ),
                        ),
                        if (widget.canChooseBackupLocation)
                          NodeLaneRow(
                            title: l.backup_location,
                            subtitle: backupLocation.$2.isEmpty
                                ? backupLocation.$1
                                : backupLocation.$2,
                            icon: icons.folderOutline,
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
                        NodeLaneSwitchRow(
                          title: l.encrypt_backups,
                          subtitle: l.encrypt_backups_info,
                          icon: icons.security,
                          value: ref.watch(backupEncryptionEnabledProvider),
                          onChanged: _busy
                              ? null
                              : (value) => _run(
                                  () => widget.onEncryptionChanged(value),
                                ),
                        ),
                        Padding(
                          padding: NodeLaneTokens.groupPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${l.compression_level} · $compression',
                                style: t.readerLabel,
                              ),
                              const SizedBox(height: NodeLaneTokens.space8),
                              Text(
                                l.compression_info(
                                  DeflateLevel.defaultCompression,
                                ),
                                style: t.readerSecondary,
                              ),
                              Slider(
                                min: 0,
                                max: 9,
                                divisions: 9,
                                value: compression.clamp(0, 9).toDouble(),
                                label: '$compression',
                                semanticFormatterCallback: (value) =>
                                    '${l.compression_level} ${value.round()}',
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
                        NodeLaneSwitchRow(
                          title: l.clear_chapter_or_episode_cache_on_app_launch,
                          icon: icons.delete,
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
                        Padding(
                          padding: NodeLaneTokens.groupPadding,
                          child: Text(
                            '${l.download_location_info}\n${location.$2.isEmpty ? location.$1 : location.$2}',
                            style: t.readerSecondary,
                          ),
                        ),
                        ...widget.maintenance,
                      ],
                    ),
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
