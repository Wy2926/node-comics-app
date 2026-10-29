import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Password draft only. Storage and decryption remain with the existing flows.
/// Without [onSave], returns the original input string for decryption.
class MobileBackupPasswordDialog extends StatefulWidget {
  const MobileBackupPasswordDialog({
    super.key,
    this.onSave,
    this.wasIncorrect = false,
  });
  final Future<bool> Function(String)? onSave;
  final bool wasIncorrect;

  @override
  State<MobileBackupPasswordDialog> createState() =>
      _MobileBackupPasswordDialogState();
}

class _MobileBackupPasswordDialogState
    extends State<MobileBackupPasswordDialog> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _confirmFocus = FocusNode();
  bool _obscure = true, _busy = false, _failed = false;
  bool get _setup => widget.onSave != null;
  bool get _valid =>
      _password.text.isNotEmpty &&
      (!_setup || !_obscure || _password.text == _confirm.text);

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_valid) return;
    if (!_setup) {
      Navigator.pop(context, _password.text);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      final saved = await widget.onSave!(_password.text);
      if (!mounted) return;
      if (saved) Navigator.pop(context, true);
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
      child: AlertDialog(
        backgroundColor: colors.surface,
        scrollable: true,
        title: Text(
          _setup ? l10n.set_backup_password : l10n.enter_backup_password,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.wasIncorrect) ...[
              Text(
                l10n.incorrect_password_try_again,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 16),
            ],
            Text(l10n.password),
            const SizedBox(height: 8),
            Semantics(
              label: l10n.password,
              child: TextField(
                key: const ValueKey('backup-password'),
                controller: _password,
                autofocus: true,
                enabled: !_busy,
                obscureText: _obscure,
                autocorrect: false,
                enableSuggestions: false,
                smartDashesType: SmartDashesType.disabled,
                smartQuotesType: SmartQuotesType.disabled,
                textInputAction: _setup && _obscure
                    ? TextInputAction.next
                    : TextInputAction.done,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _setup && _obscure
                    ? _confirmFocus.requestFocus()
                    : _submit(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: _obscure ? l10n.show_password : l10n.hide_password,
                    onPressed: _busy
                        ? null
                        : () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
            ),
            if (_setup && _obscure) ...[
              const SizedBox(height: 16),
              Text(l10n.confirm_password),
              const SizedBox(height: 8),
              Semantics(
                label: l10n.confirm_password,
                child: TextField(
                  key: const ValueKey('backup-password-confirm'),
                  controller: _confirm,
                  focusNode: _confirmFocus,
                  enabled: !_busy,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  smartDashesType: SmartDashesType.disabled,
                  smartQuotesType: SmartQuotesType.disabled,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              if (_confirm.text.isNotEmpty &&
                  _confirm.text != _password.text) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.passwords_do_not_match,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
            if (_busy) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            if (_failed) ...[
              const SizedBox(height: 16),
              Semantics(
                liveRegion: true,
                child: Text(
                  l10n.failed,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: _busy ? null : () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: _busy || !_valid ? null : _submit,
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
