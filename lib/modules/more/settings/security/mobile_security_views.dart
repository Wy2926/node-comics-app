import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation only. System authentication and preference writes stay in
/// SecurityScreen; the app's existing lifecycle listener owns relocking.
class MobileSecuritySettingsView extends StatelessWidget {
  const MobileSecuritySettingsView({
    super.key,
    required this.enabled,
    required this.canAuthenticate,
    required this.isChecking,
    required this.isAuthenticating,
    required this.onChanged,
    this.authenticationIncomplete = false,
  });

  final bool enabled, canAuthenticate, isChecking, isAuthenticating;
  final bool authenticationIncomplete;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final subtitle = isChecking
        ? l10n.checking_device_authentication
        : isAuthenticating
        ? l10n.authenticating
        : canAuthenticate
        ? l10n.require_biometric_or_device_credential
        : l10n.biometric_or_device_credential_not_available;
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.security,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              MobileSettingsGroup(
                children: [
                  MobileSettingsSwitch(
                    title: l10n.app_lock,
                    subtitle: subtitle,
                    icon: Icons.lock_outline_rounded,
                    value: enabled,
                    onChanged: onChanged,
                  ),
                ],
              ),
              if (authenticationIncomplete)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 20),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      l10n.device_authentication_incomplete,
                      style: TextStyle(fontSize: 14, color: colors.ink),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: colors.muted,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.app_lock_description,
                        style: TextStyle(fontSize: 14, color: colors.muted),
                      ),
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

class MobileAppLockView extends StatelessWidget {
  const MobileAppLockView({
    super.key,
    required this.isAuthenticating,
    required this.onUnlock,
  });

  final bool isAuthenticating;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    return BlockSemantics(
      child: NodeLaneSurface(
        child: Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (constraints.maxHeight - 48).clamp(
                      0,
                      double.infinity,
                    ),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: colors.accentSoft,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.lock_outline_rounded,
                                size: 36,
                                color: colors.accent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.app_locked,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: colors.ink,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.auth_unlock_msg,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: colors.muted),
                          ),
                          const SizedBox(height: 32),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: colors.accent,
                              foregroundColor: colors.onAccent,
                              disabledBackgroundColor: colors.soft,
                              disabledForegroundColor: colors.muted,
                              minimumSize: const Size(0, 48),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: isAuthenticating ? null : onUnlock,
                            icon: const Icon(Icons.lock_open_rounded),
                            label: Text(
                              isAuthenticating
                                  ? l10n.authenticating
                                  : l10n.unlock,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
