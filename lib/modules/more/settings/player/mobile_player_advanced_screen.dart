import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

import 'mobile_player_settings_widgets.dart';

class MobilePlayerAdvancedScreen extends StatefulWidget {
  const MobilePlayerAdvancedScreen({
    super.key,
    required this.enabled,
    required this.onEnabledChanged,
    required this.onRestore,
  });
  final bool enabled;
  // null means the user cancelled; false means permission or storage was unavailable.
  final Future<bool?> Function(bool) onEnabledChanged;
  final Future<bool?> Function() onRestore;
  @override
  State<MobilePlayerAdvancedScreen> createState() =>
      _MobilePlayerAdvancedScreenState();
}

class _MobilePlayerAdvancedScreenState
    extends State<MobilePlayerAdvancedScreen> {
  bool _busy = false;
  bool? _result;
  Future<void> _run(Future<bool?> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _result = null;
    });
    try {
      final result = await action();
      if (mounted) setState(() => _result = result);
    } catch (_) {
      if (mounted) setState(() => _result = false);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: !_busy,
      child: MobilePlayerSettingsPage(
        title: l10n.advanced_info,
        storageKey: 'mobile-player-mpv',
        children: [
          MobileSettingsGroup(
            children: [
              MobileSettingsSwitch(
                title: l10n.enable_mpv,
                subtitle: l10n.mpv_info,
                icon: Icons.code_rounded,
                value: widget.enabled,
                onChanged: _busy
                    ? null
                    : (value) => _run(() => widget.onEnabledChanged(value)),
              ),
            ],
          ),
          MobileSettingsGroup(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.mpv_bundled_config_hint),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _busy ? null : () => _run(widget.onRestore),
                      icon: const Icon(Icons.restore_rounded),
                      label: Text(l10n.mpv_restore_bundled),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_busy) const LinearProgressIndicator(),
          if (_result != null)
            Semantics(
              liveRegion: true,
              child: Text(
                _result! ? l10n.completed : l10n.player_operation_incomplete,
              ),
            ),
        ],
      ),
    );
  }
}
