import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
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
        appBar: nodeLaneAppBar(context, title: l10n.security),
        body: SafeArea(
          top: false,
          child: MobileSettingsList(
            padding: NodeLaneTokens.pagePadding,
            children: [
              MobileSettingsGroup(
                children: [
                  NodeLaneSwitchRow(
                    title: l10n.app_lock,
                    subtitle: subtitle,
                    icon: NodeLaneIcons.of(context).security,
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
                      style: colors.readerSecondary.copyWith(color: colors.ink),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      NodeLaneIcons.of(context).info,
                      size: 20,
                      color: colors.muted,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.app_lock_description,
                        style: colors.readerSecondary,
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
                              width: NodeLaneTokens.accountHeroAvatarSize,
                              height: NodeLaneTokens.accountHeroAvatarSize,
                              decoration: BoxDecoration(
                                color: colors.soft,
                                borderRadius: BorderRadius.circular(
                                  NodeLaneTokens.groupRadius,
                                ),
                              ),
                              child: Icon(
                                NodeLaneIcons.of(context).security,
                                size: NodeLaneTokens.accountHeroIconSize,
                                color: colors.ink,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.app_locked,
                            textAlign: TextAlign.center,
                            style: colors.readerTitle,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.auth_unlock_msg,
                            textAlign: TextAlign.center,
                            style: colors.readerSecondary,
                          ),
                          const SizedBox(height: 32),
                          FilledButton.icon(
                            onPressed: isAuthenticating ? null : onUnlock,
                            icon: Icon(NodeLaneIcons.of(context).unlock),
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
