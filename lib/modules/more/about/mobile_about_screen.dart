import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_brand_mark.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/nodelane_brand.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum _CheckResult { none, noResult, failed }

/// The owner supplies metadata, preferences and the existing update runtime.
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
    required this.updateBuilder,
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
  final Widget Function(UpdateInfo, VoidCallback onDismiss) updateBuilder;
  @override
  State<MobileAboutScreen> createState() => _MobileAboutScreenState();
}

class _MobileAboutScreenState extends State<MobileAboutScreen> {
  bool _checking = false, _logging = false, _sharing = false;
  _CheckResult _result = _CheckResult.none;
  UpdateInfo? _update;

  Future<void> _check() async {
    if (_checking) return;
    setState(() {
      _checking = true;
      _result = _CheckResult.none;
    });
    try {
      final update = await widget.onCheck();
      if (!mounted) return;
      setState(() {
        _update = update;
        _result = update == null ? _CheckResult.noResult : _CheckResult.none;
      });
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
        showNodeLaneNotice(context.l10n.failed, kind: NodeLaneNoticeKind.error);
      }
    } finally {
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
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    final count = widget.reportCount();
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(context, title: l.settings_about_help),
        body: SafeArea(
          top: false,
          child: MobileSettingsList(
            key: const PageStorageKey('mobile-about'),
            padding: NodeLaneTokens.pagePadding,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: NodeLaneTokens.space24,
                ),
                child: Column(
                  children: [
                    const NodeLaneBrandMark(),
                    const SizedBox(height: NodeLaneTokens.space16),
                    Text(
                      l.app_name,
                      textAlign: TextAlign.center,
                      style: t.detailTitle,
                    ),
                    const SizedBox(height: NodeLaneTokens.space8),
                    widget.packageInfo.when(
                      data: (info) => Text(
                        '${l.version} ${info.version}',
                        style: t.readerSecondary,
                      ),
                      loading: () => SizedBox.square(
                        dimension: NodeLaneTokens.smallIconSize,
                        child: CircularProgressIndicator(color: t.muted),
                      ),
                      error: (_, _) => TextButton.icon(
                        onPressed: widget.onRetryPackageInfo,
                        icon: Icon(icons.refresh),
                        label: Text(l.retry),
                      ),
                    ),
                  ],
                ),
              ),
              MobileSettingsGroup(
                title: l.app_updates,
                children: [
                  if (_update case final update?)
                    widget.updateBuilder(update, () {
                      if (mounted) setState(() => _update = null);
                    })
                  else
                    Semantics(
                      liveRegion: true,
                      child: NodeLaneRow(
                        title: _checking
                            ? l.searching_for_updates
                            : l.check_for_update,
                        subtitle: switch (_result) {
                          _CheckResult.noResult => l.update_check_no_result,
                          _CheckResult.failed => l.app_update_failed,
                          _CheckResult.none => null,
                        },
                        icon: icons.refresh,
                        enabled: !_checking,
                        onTap: _check,
                        trailing: _checking
                            ? SizedBox.square(
                                dimension: NodeLaneTokens.smallIconSize,
                                child: CircularProgressIndicator(
                                  color: t.accent,
                                ),
                              )
                            : null,
                      ),
                    ),
                  NodeLaneSwitchRow(
                    title: l.app_update_auto,
                    value: widget.checkForUpdates,
                    onChanged: widget.onAutoCheckChanged,
                  ),
                ],
              ),
              MobileSettingsGroup(
                children: [
                  NodeLaneRow(
                    title: 'GitHub',
                    subtitle: NodeLaneBrand.repository,
                    icon: icons.code,
                    onTap: () => _run(widget.onGitHub),
                  ),
                  if (widget.onOnboarding != null)
                    NodeLaneRow(
                      title: l.onboarding_replay,
                      icon: icons.manga,
                      onTap: widget.onOnboarding,
                    ),
                  NodeLaneRow(
                    title: l.app_upstream_community,
                    subtitle: 'Mangayomi · Discord',
                    icon: icons.chat,
                    onTap: () => _run(widget.onDiscord),
                  ),
                ],
              ),
              NodeLaneDisclosure(
                title: l.app_diagnostics,
                icon: icons.novel,
                child: NodeLaneGroupSurface(
                  children: [
                    NodeLaneRow(
                      title: l.error_reports,
                      subtitle:
                          '${l.error_reports_subtitle}${count == 0 ? '' : ' · $count'}',
                      icon: icons.error,
                      onTap: () => _run(widget.onReports),
                    ),
                    NodeLaneSwitchRow(
                      title: l.logs_on,
                      icon: icons.novel,
                      value: widget.logsEnabled,
                      onChanged: _logging ? null : _changeLogs,
                    ),
                    if (widget.logsEnabled)
                      NodeLaneRow(
                        title: l.share_app_logs,
                        icon: icons.share,
                        enabled: !_sharing && !_logging,
                        onTap: _shareLogs,
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
