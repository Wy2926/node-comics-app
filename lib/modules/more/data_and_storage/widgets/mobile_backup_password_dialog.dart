import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

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
    final t = NodeLaneTokens.of(context);
    Widget error(String message) => Padding(
      padding: const EdgeInsets.only(top: NodeLaneTokens.space8),
      child: Semantics(
        liveRegion: true,
        child: Text(
          message,
          style: t.readerSecondary.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
    return PopScope(
      canPop: !_busy,
      child: NodeLaneCatalogSheet(
        title: _setup ? l10n.set_backup_password : l10n.enter_backup_password,
        canClose: !_busy,
        fitContent: true,
        heightFactor: .9,
        bottom: NodeLaneModalActions(
          actions: [
            NodeLaneDialogAction(
              label: l10n.ok,
              busy: _busy,
              onPressed: _busy || !_valid ? null : _submit,
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: NodeLaneTokens.gutter,
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.wasIncorrect) ...[
                error(l10n.incorrect_password_try_again),
                const SizedBox(height: NodeLaneTokens.space12),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: NodeLaneTokens.space16,
                children: [
                  NodeLaneTextField(
                    key: const ValueKey('backup-password'),
                    controller: _password,
                    label: l10n.password,
                    autofocus: true,
                    enabled: !_busy,
                    obscureText: _obscure,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: _setup && _obscure
                        ? TextInputAction.next
                        : TextInputAction.done,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _setup && _obscure
                        ? _confirmFocus.requestFocus()
                        : _submit(),
                    trailing: NodeLaneIconButton(
                      tooltip: _obscure
                          ? l10n.show_password
                          : l10n.hide_password,
                      onPressed: _busy
                          ? null
                          : () => setState(() => _obscure = !_obscure),
                      icon: _obscure
                          ? NodeLaneIcons.of(context).visible
                          : NodeLaneIcons.of(context).incognito,
                      style: NodeLaneIconButtonStyle.field,
                    ),
                  ),
                  if (_setup && _obscure)
                    NodeLaneTextField(
                      key: const ValueKey('backup-password-confirm'),
                      controller: _confirm,
                      focusNode: _confirmFocus,
                      label: l10n.confirm_password,
                      enabled: !_busy,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _submit(),
                    ),
                ],
              ),
              if (_setup &&
                  _obscure &&
                  _confirm.text.isNotEmpty &&
                  _confirm.text != _password.text)
                error(l10n.passwords_do_not_match),
              if (_failed) error(l10n.failed),
            ],
          ),
        ),
      ),
    );
  }
}
