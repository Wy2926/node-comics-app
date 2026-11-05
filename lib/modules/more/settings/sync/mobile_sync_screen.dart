import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_connection_status_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_progress_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/more/widgets/mobile_account_login_dialog.dart';
import 'package:mangayomi/modules/more/widgets/mobile_account_widgets.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/sync_preference_repository.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:url_launcher/url_launcher.dart';

enum MobileSyncAction { sync, upload, download }

class MobileSyncScreen extends ConsumerStatefulWidget {
  const MobileSyncScreen({super.key, required this.serverUrl});
  final String serverUrl;
  @override
  ConsumerState<MobileSyncScreen> createState() => _MobileSyncScreenState();
}

class _MobileSyncScreenState extends ConsumerState<MobileSyncScreen> {
  late Stream<List<SyncPreference>> _preferences;
  @override
  void initState() {
    super.initState();
    _preferences = syncPreferenceRepository.watchAllWithSyncId();
  }

  @override
  Widget build(BuildContext context) {
    final connection = ref.watch(syncConnectionStateProvider(syncId: 1));
    final progress = ref.watch(syncProgressProvider(syncId: 1));
    return StreamBuilder(
      stream: _preferences,
      builder: (context, snapshot) {
        final preference =
            snapshot.data?.where((value) => value.syncId == 1).firstOrNull ??
            SyncPreference(syncId: 1);
        return MobileSyncSettings(
          preference: preference,
          connection: connection,
          progress: progress,
          loading: snapshot.connectionState == ConnectionState.waiting,
          loadFailed: snapshot.hasError,
          onRetry: () => setState(
            () => _preferences = syncPreferenceRepository.watchAllWithSyncId(),
          ),
          lastSyncLabel: preference.lastSync == null
              ? null
              : '${dateFormat(preference.lastSync!.toString(), ref: ref, context: context)} ${dateFormatHour(preference.lastSync!.toString(), context)}',
          onEnabledChanged: (value) {
            final notifier = ref.read(synchingProvider(syncId: 1).notifier);
            notifier.setSyncOn(value);
            if (!value) notifier.setAutoSyncFrequency(0);
          },
          onFrequencyChanged: (value) => ref
              .read(synchingProvider(syncId: 1).notifier)
              .setAutoSyncFrequency(value),
          onRecheck: () => ref
              .read(syncConnectionStateProvider(syncId: 1).notifier)
              .recheck(),
          onLogout: () =>
              ref.read(synchingProvider(syncId: 1).notifier).logout(),
          onLogin: () => showNodeLaneCatalogSheet<void>(
            context,
            MobileAccountLoginDialog(
              title: context.l10n.login_into('SyncServer'),
              submitLabel: context.l10n.sync_login_browser,
              fields: [
                MobileAccountField(
                  id: 'server',
                  label: context.l10n.sync_server,
                  initialValue: preference.server ?? '',
                  keyboardType: TextInputType.url,
                ),
              ],
              onSubmit: (values) => ref
                  .read(syncServerProvider(syncId: 1).notifier)
                  .login(context.l10n, values['server']!),
            ),
            dismissible: false,
          ),
          onSync: (action) => ref
              .read(syncServerProvider(syncId: 1).notifier)
              .startSync(
                context.l10n,
                false,
                upload: action == MobileSyncAction.upload,
                download: action == MobileSyncAction.download,
              ),
          onServerInfo: () async {
            if (!await launchUrl(
              Uri.parse(widget.serverUrl),
              mode: LaunchMode.externalApplication,
            )) {
              throw StateError('Unavailable');
            }
          },
        );
      },
    );
  }
}

/// Renders the current account and progress. All sync and preference work stays
/// in the existing providers supplied by the adapter above.
class MobileSyncSettings extends StatefulWidget {
  const MobileSyncSettings({
    super.key,
    required this.preference,
    required this.connection,
    required this.progress,
    required this.onEnabledChanged,
    required this.onFrequencyChanged,
    required this.onRecheck,
    required this.onLogin,
    required this.onLogout,
    required this.onSync,
    required this.onServerInfo,
    required this.onRetry,
    this.lastSyncLabel,
    this.loading = false,
    this.loadFailed = false,
  });
  final SyncPreference preference;
  final SyncConnectionStatus connection;
  final SyncProgressState progress;
  final bool loading, loadFailed;
  final String? lastSyncLabel;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<int> onFrequencyChanged;
  final VoidCallback onRecheck, onLogout, onRetry;
  final Future<void> Function() onLogin, onServerInfo;
  final Future<bool> Function(MobileSyncAction) onSync;
  @override
  State<MobileSyncSettings> createState() => _MobileSyncSettingsState();
}

class _MobileSyncSettingsState extends State<MobileSyncSettings> {
  bool _busy = false;
  String? _message;
  bool get _logged => widget.preference.authToken?.isNotEmpty ?? false;
  bool get _locked => _busy || widget.progress.active;
  bool get _available =>
      _logged &&
      widget.preference.syncOn &&
      widget.connection == SyncConnectionStatus.connected &&
      !widget.progress.active;

  Future<void> _run(Future<void> Function() action) async {
    if (_locked) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await action();
    } catch (_) {
      if (mounted) setState(() => _message = context.l10n.failed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _account() => _run(() async {
    if (!_logged) {
      await widget.onLogin();
      return;
    }
    final confirmed = await showNodeLaneConfirmation(
      context,
      title: context.l10n.log_out_from('SyncServer'),
      confirmLabel: context.l10n.log_out,
    );
    if (mounted && confirmed) widget.onLogout();
  });

  Future<void> _sync(MobileSyncAction action) => _run(() async {
    if (!_available) return;
    final l10n = context.l10n;
    if (action != MobileSyncAction.sync) {
      final confirmed = await showNodeLaneConfirmation(
        context,
        title: action == MobileSyncAction.upload
            ? l10n.sync_button_upload
            : l10n.sync_button_download,
        message: action == MobileSyncAction.upload
            ? l10n.sync_button_upload_info
            : l10n.sync_button_download_info,
        confirmLabel: l10n.dialog_confirm,
      );
      if (!mounted || !confirmed || !_available) return;
    }
    final completed = await widget.onSync(action);
    if (mounted) {
      setState(
        () => _message = completed ? l10n.sync_finished : l10n.sync_failed,
      );
    }
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final preference = widget.preference;
    final options = [
      MobileSettingOption(0, l10n.sync_auto_off),
      MobileSettingOption(300, l10n.sync_auto_5_minutes),
      MobileSettingOption(600, l10n.sync_auto_10_minutes),
      MobileSettingOption(1800, l10n.sync_auto_30_minutes),
      MobileSettingOption(3600, l10n.sync_auto_1_hour),
      MobileSettingOption(10800, l10n.sync_auto_3_hours),
      MobileSettingOption(21600, l10n.sync_auto_6_hours),
      MobileSettingOption(43200, l10n.sync_auto_12_hours),
    ];
    final (statusIcon, statusLabel) = switch (widget.connection) {
      SyncConnectionStatus.notConfigured => (
        NodeLaneIcons.of(context).tracking,
        l10n.sync_status_not_configured,
      ),
      SyncConnectionStatus.checking => (
        NodeLaneIcons.of(context).tracking,
        l10n.sync_status_checking,
      ),
      SyncConnectionStatus.connected => (
        NodeLaneIcons.of(context).downloaded,
        l10n.sync_status_connected,
      ),
      SyncConnectionStatus.unauthorized => (
        NodeLaneIcons.of(context).error,
        l10n.sync_status_unauthorized,
      ),
      SyncConnectionStatus.unreachable => (
        NodeLaneIcons.of(context).tracking,
        l10n.sync_status_unreachable,
      ),
    };
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(context, title: l10n.syncing),
        body: SafeArea(
          top: false,
          child: MobileSettingsList(
            key: const PageStorageKey('mobile-sync-settings'),
            padding: NodeLaneTokens.pagePadding,
            children: [
              if (widget.loading)
                const LinearProgressIndicator()
              else if (widget.loadFailed) ...[
                Text(l10n.failed),
                OutlinedButton(
                  onPressed: widget.onRetry,
                  child: Text(l10n.retry),
                ),
              ] else ...[
                MobileSettingsGroup(
                  title: l10n.services,
                  children: [
                    MobileServiceAccount(
                      title: 'SyncServer',
                      icon: Icon(
                        NodeLaneIcons.of(context).repository,
                        color: colors.ink,
                      ),
                      connected: _logged,
                      subtitle:
                          [preference.server, if (_logged) preference.email]
                              .whereType<String>()
                              .where((text) => text.isNotEmpty)
                              .join('\n'),
                      onAction: _locked ? null : _account,
                    ),
                    if (_logged)
                      NodeLaneRow(
                        title: statusLabel,
                        trailing: NodeLaneIconButton(
                          tooltip: l10n.refresh,
                          onPressed:
                              _locked ||
                                  widget.connection ==
                                      SyncConnectionStatus.checking
                              ? null
                              : widget.onRecheck,
                          icon: NodeLaneIcons.of(context).refresh,
                        ),
                        icon: statusIcon,
                      ),
                  ],
                ),
                MobileSettingsGroup(
                  children: [
                    NodeLaneSwitchRow(
                      title: l10n.sync_on,
                      icon: NodeLaneIcons.of(context).tracking,
                      value: preference.syncOn,
                      onChanged: !_logged || _locked
                          ? null
                          : widget.onEnabledChanged,
                    ),
                    if (preference.syncOn && _logged)
                      NodeLaneRow(
                        title: l10n.sync_auto,
                        openOnReveal: true,
                        value:
                            options
                                .where(
                                  (option) =>
                                      option.value ==
                                      preference.autoSyncFrequency,
                                )
                                .firstOrNull
                                ?.label ??
                            l10n.unknown,
                        enabled: !_locked,
                        onTap: _locked
                            ? null
                            : () => _run(() async {
                                final selected = await showMobileSettingsPicker(
                                  context,
                                  title: l10n.sync_auto,
                                  current: preference.autoSyncFrequency,
                                  options: options,
                                );
                                if (mounted &&
                                    selected != null &&
                                    widget.preference.syncOn &&
                                    _logged &&
                                    !widget.progress.active &&
                                    selected.value !=
                                        widget.preference.autoSyncFrequency) {
                                  widget.onFrequencyChanged(selected.value);
                                }
                              }),
                        icon: NodeLaneIcons.of(context).history,
                      ),
                  ],
                ),
                if (preference.autoSyncFrequency > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      l10n.sync_auto_warning,
                      style: colors.readerSecondary,
                    ),
                  ),
                FilledButton.icon(
                  onPressed: _available && !_busy
                      ? () => _sync(MobileSyncAction.sync)
                      : null,
                  icon: Icon(NodeLaneIcons.of(context).tracking),
                  label: Text(l10n.sync_button_sync),
                ),
                if (widget.progress.active) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: widget.progress.fraction),
                  Text(
                    widget.progress.fraction == null
                        ? l10n.sync_progress_indeterminate
                        : l10n.sync_progress_percent(
                            (widget.progress.fraction! * 100).round(),
                          ),
                  ),
                ],
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Semantics(liveRegion: true, child: Text(_message!)),
                  ),
                if (widget.lastSyncLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      '${l10n.last_sync}\n${widget.lastSyncLabel}',
                      style: colors.readerSecondary,
                    ),
                  ),
                const SizedBox(height: 24),
                MobileSettingsGroup(
                  children: [
                    NodeLaneDisclosure(
                      key: const PageStorageKey('mobile-sync-advanced'),
                      title: l10n.advanced,
                      child: Padding(
                        padding: NodeLaneTokens.groupPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _available && !_busy
                                    ? () => _sync(MobileSyncAction.upload)
                                    : null,
                                icon: Icon(NodeLaneIcons.of(context).backup),
                                label: Text(l10n.sync_button_upload),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _available && !_busy
                                    ? () => _sync(MobileSyncAction.download)
                                    : null,
                                icon: Icon(NodeLaneIcons.of(context).download),
                                label: Text(l10n.sync_button_download),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                MobileSettingsGroup(
                  children: [
                    NodeLaneDisclosure(
                      key: const PageStorageKey('mobile-sync-about'),
                      title: l10n.about,
                      child: Padding(
                        padding: NodeLaneTokens.groupPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.syncing_subtitle,
                              style: colors.readerSecondary,
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: _locked
                                  ? null
                                  : () => _run(widget.onServerInfo),
                              icon: Icon(NodeLaneIcons.of(context).external),
                              label: Text(l10n.get_sync_server),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
