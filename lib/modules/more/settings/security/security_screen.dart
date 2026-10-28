import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mangayomi/modules/more/settings/security/providers/security_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'mobile_security_views.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isCheckingAvailability = true;
  bool _isAuthenticating = false;
  bool _authenticationIncomplete = false;
  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final canAuth = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (mounted) {
        setState(() {
          _canCheckBiometrics = canAuth || isDeviceSupported;
          _isCheckingAvailability = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _canCheckBiometrics = false;
          _isCheckingAvailability = false;
        });
      }
    }
  }

  Future<void> _changeAppLock(bool value) async {
    if (!mounted || !_canCheckBiometrics || _isAuthenticating) return;
    setState(() {
      _isAuthenticating = true;
      _authenticationIncomplete = false;
    });
    var authenticated = false;
    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: context.l10n.auth_to_change_security_setting,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      // Cancellation or a platform failure leaves the preference unchanged.
    }
    if (!mounted) return;
    setState(() {
      _isAuthenticating = false;
      _authenticationIncomplete = !authenticated;
    });
    if (authenticated) {
      ref.read(appLockEnabledStateProvider.notifier).set(value);
      if (!value) ref.read(appUnlockedStateProvider.notifier).unlock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appLockEnabled = ref.watch(appLockEnabledStateProvider);
    final onChanged = _canCheckBiometrics && !_isAuthenticating
        ? _changeAppLock
        : null;

    if (isMobile && !isTv) {
      return MobileSecuritySettingsView(
        enabled: appLockEnabled,
        canAuthenticate: _canCheckBiometrics,
        isChecking: _isCheckingAvailability,
        isAuthenticating: _isAuthenticating,
        authenticationIncomplete: _authenticationIncomplete,
        onChanged: onChanged,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.security)),
      body: SingleChildScrollView(
        padding: tvPageInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              value: appLockEnabled,
              title: Text(l10n.app_lock),
              subtitle: Text(
                _canCheckBiometrics
                    ? l10n.require_biometric_or_device_credential
                    : l10n.biometric_or_device_credential_not_available,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              ),
              onChanged: onChanged,
            ),

            const Divider(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.app_lock_description,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
