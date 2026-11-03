import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum _CheckResult { none, noResult, available, failed }

/// The existing owner supplies package metadata, preferences and side effects.
class MobileAboutScreen extends StatefulWidget {
  const MobileAboutScreen({
    super.key,
    required this.packageInfo,
    required this.onRetryPackageInfo,
    required this.checkForUpdates,
    required this.onAutoCheckChanged,
    required this.logsEnabled,
    required this.onLogsChanged,
    required this.reportCount,
    required this.onReports,
    required this.onCheck,
    required this.onUpdate,
    required this.onShareLogs,
    required this.onGitHub,
    required this.onDiscord,
    this.onOnboarding,
  });

  final AsyncValue<PackageInfo> packageInfo;
  final VoidCallback onRetryPackageInfo;
  final VoidCallback? onOnboarding;
  final bool checkForUpdates, logsEnabled;
  final ValueChanged<bool> onAutoCheckChanged;
  final Future<void> Function(bool) onLogsChanged;
  final int Function() reportCount;
  final Future<void> Function() onReports, onShareLogs, onGitHub, onDiscord;
  final Future<UpdateInfo?> Function() onCheck;
  final Future<void> Function(UpdateInfo) onUpdate;

  @override
  State<MobileAboutScreen> createState() => _MobileAboutScreenState();
}

class _MobileAboutScreenState extends State<MobileAboutScreen> {
  bool _checking = false, _logging = false, _sharing = false;
  _CheckResult _result = _CheckResult.none;

  Future<void> _check() async {
    if (_checking) return;
    setState(() {
      _checking = true;
      _result = _CheckResult.none;
    });
    try {
      final update = await widget.onCheck();
      if (!mounted) return;
      if (update == null) {
        setState(() => _result = _CheckResult.noResult);
      } else {
        setState(() => _result = _CheckResult.available);
        await widget.onUpdate(update);
      }
    } catch (_) {
      if (mounted) setState(() => _result = _CheckResult.failed);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.failed)));
      }
    } finally {
      // Reports may have been cleared while the child route was open.
      if (mounted) setState(() {});
    }
  }

  Future<void> _changeLogs(bool value) async {
    if (_logging) return;
    setState(() => _logging = true);
    await _run(() => widget.onLogsChanged(value));
    if (mounted) setState(() => _logging = false);
  }

  Future<void> _shareLogs() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    await _run(widget.onShareLogs);
    if (mounted) setState(() => _sharing = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final count = widget.reportCount();
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(context, title: l10n.settings_about_help),
        body: SafeArea(
          top: false,
          child: ListView(
            key: const PageStorageKey('mobile-about'),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              MobileSettingsGroup(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: widget.packageInfo.when(
                      data: (info) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Image.asset(
                              appIconAssets[2],
                              height: 40,
                              color: colors.ink,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            info.appName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l10n.version} · ${l10n.beta_version(info.version)}',
                            style: colors.readerSecondary,
                          ),
                        ],
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, _) => Column(
                        children: [
                          Text(l10n.failed),
                          TextButton.icon(
                            onPressed: widget.onRetryPackageInfo,
                            icon: Icon(NodeLaneIcons.of(context).refresh),
                            label: Text(l10n.retry),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.update,
                children: [
                  NodeLaneSwitchRow(
                    title: l10n.check_for_app_updates,
                    icon: NodeLaneIcons.of(context).refresh,
                    value: widget.checkForUpdates,
                    onChanged: widget.onAutoCheckChanged,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: _checking ? null : _check,
                          icon: Icon(NodeLaneIcons.of(context).refresh),
                          label: Text(l10n.check_for_update),
                        ),
                        if (_checking || _result != _CheckResult.none) ...[
                          const SizedBox(height: 12),
                          if (_checking && _result != _CheckResult.available)
                            const LinearProgressIndicator(),
                          const SizedBox(height: 8),
                          Text(
                            _checking && _result != _CheckResult.available
                                ? l10n.searching_for_updates
                                : switch (_result) {
                                    _CheckResult.noResult =>
                                      l10n.update_check_no_result,
                                    _CheckResult.available =>
                                      l10n.new_update_available,
                                    _CheckResult.failed => l10n.failed,
                                    _CheckResult.none => '',
                                  },
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              MobileSettingsGroup(
                children: [
                  NodeLaneRow(
                    title: l10n.error_reports,
                    subtitle:
                        '${l10n.error_reports_subtitle}${count == 0 ? '' : ' · $count'}',
                    icon: NodeLaneIcons.of(context).error,
                    onTap: () => _run(widget.onReports),
                  ),
                  NodeLaneSwitchRow(
                    title: l10n.logs_on,
                    icon: NodeLaneIcons.of(context).novel,
                    value: widget.logsEnabled,
                    onChanged: _logging ? null : _changeLogs,
                  ),
                  if (widget.logsEnabled)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton.icon(
                        onPressed: _sharing || _logging ? null : _shareLogs,
                        icon: Icon(NodeLaneIcons.of(context).share),
                        label: Text(l10n.share_app_logs),
                      ),
                    ),
                ],
              ),
              if (widget.onOnboarding != null)
                MobileSettingsGroup(
                  children: [
                    NodeLaneRow(
                      title: l10n.onboarding_replay,
                      icon: NodeLaneIcons.of(context).info,
                      onTap: widget.onOnboarding,
                    ),
                  ],
                ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _run(widget.onGitHub),
                    icon: Icon(NodeLaneIcons.of(context).code),
                    label: const Text('GitHub'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _run(widget.onDiscord),
                    icon: Icon(NodeLaneIcons.of(context).chat),
                    label: const Text('Discord'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
