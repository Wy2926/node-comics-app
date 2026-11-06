import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class MobileAccountField {
  const MobileAccountField({
    required this.id,
    required this.label,
    this.initialValue = '',
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.secret = false,
  });
  final String id, label, initialValue;
  final TextInputType keyboardType;
  final List<String>? autofillHints;
  final bool secret;
}

/// Bounded login form shared by the server-address and Kitsu dialogs.
/// Callers retain validation of service responses and credential handling.
class MobileAccountLoginDialog extends StatefulWidget {
  const MobileAccountLoginDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.submitLabel,
    required this.onSubmit,
  });
  final String title, submitLabel;
  final List<MobileAccountField> fields;
  final Future<(bool, String)> Function(Map<String, String>) onSubmit;
  @override
  State<MobileAccountLoginDialog> createState() =>
      _MobileAccountLoginDialogState();
}

class _MobileAccountLoginDialogState extends State<MobileAccountLoginDialog> {
  late final _controllers = {
    for (final field in widget.fields)
      field.id: TextEditingController(text: field.initialValue),
  };
  late final _focus = {
    for (final field in widget.fields) field.id: FocusNode(),
  };
  final _revealed = <String>{};
  bool _busy = false;
  String? _error;
  bool get _valid => widget.fields.every(
    (field) => field.secret
        ? _controllers[field.id]!.text.isNotEmpty
        : _controllers[field.id]!.text.trim().isNotEmpty,
  );

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final node in _focus.values) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_valid) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await widget.onSubmit({
        for (final entry in _controllers.entries) entry.key: entry.value.text,
      });
      if (!mounted) return;
      if (result.$1) {
        if (widget.fields.any((field) => field.secret)) {
          TextInput.finishAutofillContext();
        }
        Navigator.pop(context);
      } else {
        setState(() {
          _busy = false;
          _error = result.$2.isEmpty ? context.l10n.failed : result.$2;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = context.l10n.failed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: NodeLaneCatalogSheet(
      title: widget.title,
      canClose: !_busy,
      fitContent: true,
      heightFactor: .9,
      bottom: NodeLaneModalActions(
        actions: [
          NodeLaneDialogAction(
            label: widget.submitLabel,
            busy: _busy,
            onPressed: _busy || !_valid ? null : _submit,
          ),
        ],
      ),
      child: AutofillGroup(
        onDisposeAction: AutofillContextAction.cancel,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: NodeLaneTokens.gutter,
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: NodeLaneTokens.space16,
                children: [
                  for (var index = 0; index < widget.fields.length; index++)
                    NodeLaneTextField(
                      key: ValueKey('account-${widget.fields[index].id}'),
                      controller: _controllers[widget.fields[index].id],
                      label: widget.fields[index].label,
                      focusNode: _focus[widget.fields[index].id],
                      enabled: !_busy,
                      keyboardType: widget.fields[index].keyboardType,
                      autofillHints: widget.fields[index].autofillHints,
                      obscureText:
                          widget.fields[index].secret &&
                          !_revealed.contains(widget.fields[index].id),
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: index == widget.fields.length - 1
                          ? TextInputAction.done
                          : TextInputAction.next,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) {
                        if (index == widget.fields.length - 1) {
                          _submit();
                        } else {
                          _focus[widget.fields[index + 1].id]!.requestFocus();
                        }
                      },
                      trailing: !widget.fields[index].secret
                          ? null
                          : NodeLaneIconButton(
                              tooltip:
                                  _revealed.contains(widget.fields[index].id)
                                  ? context.l10n.hide_password
                                  : context.l10n.show_password,
                              onPressed: _busy
                                  ? null
                                  : () => setState(() {
                                      final id = widget.fields[index].id;
                                      if (!_revealed.add(id)) {
                                        _revealed.remove(id);
                                      }
                                    }),
                              icon: _revealed.contains(widget.fields[index].id)
                                  ? NodeLaneIcons.of(context).incognito
                                  : NodeLaneIcons.of(context).visible,
                            ),
                    ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}
