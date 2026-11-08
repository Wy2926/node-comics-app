import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/modules/more/widgets/mobile_account_login_dialog.dart';
import 'package:mangayomi/modules/more/widgets/mobile_account_widgets.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_screen.dart';
import 'package:mangayomi/modules/widgets/tracker_account_avatar.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/services/trackers/anilist.dart';
import 'package:mangayomi/services/trackers/kitsu.dart';
import 'package:mangayomi/services/trackers/myanimelist.dart';
import 'package:mangayomi/services/trackers/simkl.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/constant.dart';

class MobileTrackScreen extends ConsumerStatefulWidget {
  const MobileTrackScreen({super.key});
  @override
  ConsumerState<MobileTrackScreen> createState() => _MobileTrackScreenState();
}

class _MobileTrackScreenState extends ConsumerState<MobileTrackScreen> {
  late Stream<List<TrackPreference>> _preferences;
  @override
  void initState() {
    super.initState();
    _preferences = trackRepository.watchAllWithSyncId();
  }

  Future<void> _login(int id) async {
    if (id == TrackerProviders.anilist.syncId) {
      await ref
          .read(anilistProvider(syncId: id, widgetRef: ref).notifier)
          .login();
    } else if (id == TrackerProviders.kitsu.syncId) {
      await showNodeLaneCatalogSheet<void>(
        context,
        MobileAccountLoginDialog(
          title: context.l10n.login_into('Kitsu'),
          submitLabel: context.l10n.login,
          fields: [
            MobileAccountField(
              id: 'email',
              label: context.l10n.email_adress,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [
                AutofillHints.email,
                AutofillHints.username,
              ],
            ),
            MobileAccountField(
              id: 'password',
              label: context.l10n.password,
              keyboardType: TextInputType.visiblePassword,
              autofillHints: const [AutofillHints.password],
              secret: true,
            ),
          ],
          onSubmit: (values) => ref
              .read(kitsuProvider(syncId: id, widgetRef: ref).notifier)
              .login(values['email']!.trim(), values['password']!),
        ),
        dismissible: false,
      );
    } else if (id == TrackerProviders.myAnimeList.syncId) {
      await ref
          .read(
            myAnimeListProvider(
              syncId: id,
              itemType: null,
              widgetRef: ref,
            ).notifier,
          )
          .login();
    } else if (id == TrackerProviders.simkl.syncId) {
      await ref
          .read(
            simklProvider(syncId: id, itemType: null, widgetRef: ref).notifier,
          )
          .login();
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateProgress = ref.watch(updateProgressAfterReadingStateProvider);
    return StreamBuilder(
      stream: _preferences,
      builder: (context, snapshot) => MobileTrackingSettings(
        entries: snapshot.data ?? const [],
        loading: snapshot.connectionState == ConnectionState.waiting,
        loadFailed: snapshot.hasError,
        onRetry: () =>
            setState(() => _preferences = trackRepository.watchAllWithSyncId()),
        updateProgress: updateProgress,
        onUpdateProgress: (value) => ref
            .read(updateProgressAfterReadingStateProvider.notifier)
            .set(value),
        onLogin: _login,
        onLogout: (id) =>
            ref.read(tracksProvider(syncId: id).notifier).logout(),
        onManage: () => context.push('/manageTrackers'),
      ),
    );
  }
}

class MobileTrackingSettings extends StatefulWidget {
  const MobileTrackingSettings({
    super.key,
    required this.entries,
    required this.updateProgress,
    required this.onUpdateProgress,
    required this.onLogin,
    required this.onLogout,
    required this.onManage,
    required this.onRetry,
    this.loading = false,
    this.loadFailed = false,
  });
  final List<TrackPreference> entries;
  final bool updateProgress, loading, loadFailed;
  final ValueChanged<bool> onUpdateProgress;
  final Future<void> Function(int) onLogin;
  final ValueChanged<int> onLogout;
  final VoidCallback onManage, onRetry;
  @override
  State<MobileTrackingSettings> createState() => _MobileTrackingSettingsState();
}

class _MobileTrackingSettingsState extends State<MobileTrackingSettings> {
  static final _ids = [
    TrackerProviders.anilist.syncId,
    TrackerProviders.kitsu.syncId,
    TrackerProviders.myAnimeList.syncId,
    TrackerProviders.simkl.syncId,
  ];
  bool _busy = false, _failed = false;
  Future<void> _account(int id) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      if (widget.entries.any((entry) => entry.syncId == id)) {
        final confirmed = await showNodeLaneConfirmation(
          context,
          title: context.l10n.log_out_from(trackInfos(id).$2),
          confirmLabel: context.l10n.log_out,
        );
        if (mounted && confirmed) widget.onLogout(id);
      } else {
        await widget.onLogin(id);
      }
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    return PopScope(
      canPop: !_busy,
      child: NodeLaneSurface(
        child: Scaffold(
          appBar: nodeLaneAppBar(context, title: l10n.tracking),
          body: SafeArea(
            top: false,
            child: MobileSettingsList(
              key: const PageStorageKey('mobile-tracking-settings'),
              padding: NodeLaneTokens.pagePadding,
              children: [
                MobileSettingsGroup(
                  children: [
                    NodeLaneSwitchRow(
                      title: l10n.updateProgressAfterReading,
                      icon: NodeLaneIcons.of(context).manga,
                      value: widget.updateProgress,
                      onChanged: _busy ? null : widget.onUpdateProgress,
                    ),
                  ],
                ),
                if (_failed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(l10n.failed),
                    ),
                  ),
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
                      for (final id in _ids)
                        MobileServiceAccount(
                          key: ValueKey('tracker-account-$id'),
                          title: trackInfos(id).$2,
                          icon: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ColoredBox(
                              color: trackInfos(id).$3,
                              child: Image.asset(trackInfos(id).$1),
                            ),
                          ),
                          connected: widget.entries.any(
                            (entry) => entry.syncId == id,
                          ),
                          subtitle:
                              widget.entries.any((entry) => entry.syncId == id)
                              ? widget.entries
                                        .where((entry) => entry.syncId == id)
                                        .first
                                        .accountLabel ??
                                    l10n.sync_status_connected
                              : l10n.sync_status_not_configured,
                          onAction: _busy ? null : () => _account(id),
                        ),
                    ],
                  ),
                  MobileSettingsGroup(
                    children: [
                      NodeLaneRow(
                        title: l10n.manage_trackers,
                        enabled: !_busy,
                        onTap: _busy ? null : widget.onManage,
                        icon: NodeLaneIcons.of(context).accountOutline,
                      ),
                    ],
                  ),
                  Text(
                    l10n.tracking_warning_info,
                    style: colors.readerSecondary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
