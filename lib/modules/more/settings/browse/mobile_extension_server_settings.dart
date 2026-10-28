import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_text_dialog.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation state only. The existing settings and service own persistence,
/// startup, shutdown and the meaning of a successful status check.
class MobileExtensionServerSettings extends StatefulWidget {
  const MobileExtensionServerSettings({
    super.key,
    required this.proxyAddress,
    required this.onProxyAddressChanged,
    required this.onGetServer,
    required this.showRuntime,
    required this.autoStart,
    required this.onAutoStartChanged,
    required this.checkRuntime,
    required this.onRuntimeChange,
  });

  final String proxyAddress;
  final ValueChanged<String> onProxyAddressChanged;
  final VoidCallback onGetServer;
  final bool showRuntime, autoStart;
  final ValueChanged<bool> onAutoStartChanged;
  final Future<bool> Function() checkRuntime;
  final Future<void> Function(bool running) onRuntimeChange;

  @override
  State<MobileExtensionServerSettings> createState() =>
      _MobileExtensionServerSettingsState();
}

class _MobileExtensionServerSettingsState
    extends State<MobileExtensionServerSettings> {
  bool? _running;
  bool _busy = false, _failed = false;

  @override
  void initState() {
    super.initState();
    if (widget.showRuntime) unawaited(_updateRuntime());
  }

  Future<void> _updateRuntime({bool? target}) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      if (target != null) {
        await widget.onRuntimeChange(target);
        if (!mounted) return;
      }
      final running = await widget.checkRuntime();
      if (!mounted) return;
      setState(() {
        _running = running;
        _failed = target != null && running != target;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        // The outcome is unknown. Refresh before offering another mutation.
        _running = null;
        _failed = true;
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _editAddress() async {
    final l10n = context.l10n;
    final value = await showDialog<String>(
      context: context,
      builder: (_) => MobileSettingsTextDialog(
        title: l10n.proxy_address,
        initialValue: widget.proxyAddress,
        hint: l10n.proxy_server_ip_hint,
        keyboardType: TextInputType.url,
      ),
    );
    if (!mounted || value == null) return;
    // Preserve the existing dialog's single trailing-slash normalization.
    final segments = value.split('/');
    if (segments.isNotEmpty && segments.last.isEmpty) segments.removeLast();
    widget.onProxyAddressChanged(segments.join('/'));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final status = _running == null
        ? (_busy ? l10n.checking_runtime_status : l10n.unknown)
        : (_running! ? l10n.running : l10n.stopped);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.extension_service,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            key: const PageStorageKey('mobile-extension-service'),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              if (widget.showRuntime)
                MobileSettingsGroup(
                  title: l10n.zero_interpreter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.zero_interpreter_description,
                            style: TextStyle(color: colors.muted),
                          ),
                          const SizedBox(height: 16),
                          Semantics(
                            liveRegion: true,
                            child: Text(
                              '${l10n.runtime_status}: $status',
                              style: TextStyle(
                                color: colors.ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (_busy) ...[
                            const SizedBox(height: 12),
                            const LinearProgressIndicator(),
                          ],
                          if (_failed) ...[
                            const SizedBox(height: 12),
                            Semantics(
                              liveRegion: true,
                              child: Text(
                                l10n.failed,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _busy
                                ? null
                                : () => _updateRuntime(
                                    target: _running == null
                                        ? null
                                        : !_running!,
                                  ),
                            icon: Icon(
                              _running == null
                                  ? Icons.refresh_rounded
                                  : (_running!
                                        ? Icons.stop_circle_outlined
                                        : Icons.play_circle_outline),
                            ),
                            label: Text(
                              _running == null
                                  ? l10n.refresh
                                  : (_running! ? l10n.stop : l10n.start),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MobileSettingsSwitch(
                      title: l10n.start_server_on_launch,
                      icon: Icons.power_settings_new_rounded,
                      value: widget.autoStart,
                      onChanged: widget.onAutoStartChanged,
                    ),
                  ],
                ),
              MobileSettingsGroup(
                title: l10n.proxy_address,
                children: [
                  ListTile(
                    enabled: !_busy,
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      l10n.set_proxy_address,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      widget.proxyAddress.isEmpty ? '—' : widget.proxyAddress,
                      style: TextStyle(color: colors.muted),
                    ),
                    trailing: Icon(Icons.edit_outlined, color: colors.accent),
                    onTap: _busy ? null : _editAddress,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.m_extension_server_description,
                      style: TextStyle(color: colors.muted),
                    ),
                  ),
                  MobileSettingsLink(
                    title: l10n.get_m_extension_server,
                    icon: Icons.open_in_new_rounded,
                    onTap: widget.onGetServer,
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
