import 'package:flutter/material.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

typedef CustomButtonDraft = ({
  String title,
  String press,
  String longPress,
  String startup,
});

/// Owns only the editable draft. Scripts are saved by the caller, never executed here.
class MobileCustomButtonEditor extends StatefulWidget {
  const MobileCustomButtonEditor({
    super.key,
    this.button,
    required this.onSave,
  });
  final CustomButton? button;
  final Future<void> Function(CustomButtonDraft) onSave;

  @override
  State<MobileCustomButtonEditor> createState() =>
      _MobileCustomButtonEditorState();
}

class _MobileCustomButtonEditorState extends State<MobileCustomButtonEditor> {
  late final _title = TextEditingController(text: widget.button?.title ?? '');
  late final _press = TextEditingController(
    text: widget.button?.codePress ?? '',
  );
  late final _longPress = TextEditingController(
    text: widget.button?.codeLongPress ?? '',
  );
  late final _startup = TextEditingController(
    text: widget.button?.codeStartup ?? '',
  );
  bool _busy = false, _failed = false;
  bool get _valid => _title.text.isNotEmpty && _press.text.isNotEmpty;

  @override
  void dispose() {
    _title.dispose();
    _press.dispose();
    _longPress.dispose();
    _startup.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !_valid) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      await widget.onSave((
        title: _title.text,
        press: _press.text,
        longPress: _longPress.text,
        startup: _startup.text,
      ));
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _failed = true;
        });
      }
    }
  }

  Widget _field(
    String label,
    TextEditingController controller,
    String key, {
    String? hint,
    bool code = false,
  }) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        if (hint != null) ...[
          const SizedBox(height: 4),
          Text(hint, style: TextStyle(color: NodeLaneTokens.of(context).muted)),
        ],
        const SizedBox(height: 12),
        Semantics(
          label: label,
          child: TextField(
            key: ValueKey(key),
            controller: controller,
            enabled: !_busy,
            minLines: code ? 4 : 1,
            maxLines: code ? null : 1,
            keyboardType: code ? TextInputType.multiline : TextInputType.text,
            autocorrect: !code,
            enableSuggestions: !code,
            smartDashesType: code ? SmartDashesType.disabled : null,
            smartQuotesType: code ? SmartQuotesType.disabled : null,
            style: code
                ? const TextStyle(fontFamily: 'monospace', fontSize: 14)
                : null,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: code ? null : label,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: !_busy,
      child: NodeLaneSurface(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              tooltip: l10n.cancel,
              onPressed: _busy ? null : () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded),
            ),
            title: Text(
              widget.button == null ? l10n.custom_buttons_add : l10n.edit,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                key: const ValueKey('save-custom-button'),
                tooltip: l10n.save,
                onPressed: _busy || !_valid ? null : _save,
                icon: const Icon(Icons.check_rounded),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: ListView(
              key: const PageStorageKey('custom-button-editor'),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                if (_busy) const LinearProgressIndicator(),
                if (_failed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(l10n.failed),
                    ),
                  ),
                MobileSettingsGroup(
                  children: [
                    _field(
                      l10n.custom_buttons_text,
                      _title,
                      'custom-button-title',
                      hint: l10n.custom_buttons_text_req,
                    ),
                    _field(
                      l10n.custom_buttons_js_code,
                      _press,
                      'custom-button-press',
                      hint: l10n.custom_buttons_js_code_req,
                      code: true,
                    ),
                  ],
                ),
                MobileSettingsGroup(
                  children: [
                    ExpansionTile(
                      key: const PageStorageKey('custom-button-extra'),
                      initiallyExpanded:
                          _longPress.text.isNotEmpty ||
                          _startup.text.isNotEmpty,
                      shape: const Border(),
                      collapsedShape: const Border(),
                      title: Text(l10n.advanced),
                      children: [
                        _field(
                          l10n.custom_buttons_js_code_long,
                          _longPress,
                          'custom-button-long-press',
                          code: true,
                        ),
                        _field(
                          l10n.custom_buttons_startup,
                          _startup,
                          'custom-button-startup',
                          code: true,
                        ),
                      ],
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: _busy || !_valid ? null : _save,
                  icon: const Icon(Icons.check_rounded),
                  label: Text(l10n.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
