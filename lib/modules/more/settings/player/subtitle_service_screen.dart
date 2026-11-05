import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/subtitles/subtitle_preferences.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showSubtitleServiceSettings(BuildContext context) => Navigator.of(
  context,
).push<void>(MaterialPageRoute(builder: (_) => const SubtitleServiceScreen()));

class SubtitleServiceSettingsRow extends StatelessWidget {
  const SubtitleServiceSettingsRow({super.key});

  @override
  Widget build(BuildContext context) => NodeLaneRow(
    title: context.l10n.subtitle_service,
    icon: NodeLaneIcons.of(context).subtitles,
    openOnReveal: true,
    onTap: () => showSubtitleServiceSettings(context),
  );
}

class SubtitleServiceScreen extends ConsumerWidget {
  const SubtitleServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => NodeLaneSurface(
    child: Scaffold(
      appBar: nodeLaneAppBar(context, title: context.l10n.subtitle_service),
      body: SafeArea(
        top: false,
        child: ref
            .watch(subtitlePreferencesProvider)
            .when(
              data: (preferences) => _SubtitleServiceForm(initial: preferences),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Padding(
                padding: NodeLaneTokens.pagePadding,
                child: NodeLaneNotice(
                  message: context.l10n.subtitle_storage_failed,
                  kind: NodeLaneNoticeKind.error,
                  actionLabel: context.l10n.retry,
                  onAction: () => ref.invalidate(subtitlePreferencesProvider),
                ),
              ),
            ),
      ),
    ),
  );
}

class _SubtitleServiceForm extends ConsumerStatefulWidget {
  const _SubtitleServiceForm({required this.initial});
  final SubtitlePreferences initial;

  @override
  ConsumerState<_SubtitleServiceForm> createState() =>
      _SubtitleServiceFormState();
}

class _SubtitleServiceFormState extends ConsumerState<_SubtitleServiceForm> {
  final _form = GlobalKey<FormState>();
  late var _mode = widget.initial.mode;
  late final _key = TextEditingController(
    text: _mode == SubtitleConnectionMode.personalKey
        ? widget.initial.credential
        : '',
  );
  late final _address = TextEditingController(
    text: widget.initial.endpoint?.toString() ?? '',
  );
  late final _token = TextEditingController(
    text: _mode == SubtitleConnectionMode.customService
        ? widget.initial.credential
        : '',
  );
  bool _saving = false, _failed = false;

  @override
  void dispose() {
    _key.dispose();
    _address.dispose();
    _token.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _saving = true;
      _failed = false;
    });
    try {
      final value = switch (_mode) {
        SubtitleConnectionMode.disabled => const SubtitlePreferences.disabled(),
        SubtitleConnectionMode.personalKey => SubtitlePreferences.personalKey(
          _key.text,
        ),
        SubtitleConnectionMode.customService =>
          SubtitlePreferences.customService(_address.text, token: _token.text),
      };
      await ref.read(subtitlePreferencesProvider.notifier).save(value);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String modeLabel(SubtitleConnectionMode mode) => switch (mode) {
      SubtitleConnectionMode.disabled => l.subtitle_service_disabled,
      SubtitleConnectionMode.personalKey => l.subtitle_personal_key,
      SubtitleConnectionMode.customService => l.subtitle_custom_service,
    };
    return PopScope(
      canPop: !_saving,
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          padding: NodeLaneTokens.pagePadding,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AbsorbPointer(
                absorbing: _saving,
                child: MobileSettingsGroup(
                  children: [
                    MobileSettingsChoice<SubtitleConnectionMode>(
                      title: l.subtitle_service_mode,
                      icon: NodeLaneIcons.of(context).subtitles,
                      value: _mode,
                      label: modeLabel,
                      options: [
                        for (final mode in SubtitleConnectionMode.values)
                          MobileSettingOption(mode, modeLabel(mode)),
                      ],
                      onChanged: (mode) => setState(() {
                        _mode = mode;
                        _failed = false;
                      }),
                    ),
                  ],
                ),
              ),
              if (_mode == SubtitleConnectionMode.personalKey) ...[
                NodeLaneTextField(
                  key: const ValueKey('subtitle-key'),
                  controller: _key,
                  label: l.subtitle_key,
                  enabled: !_saving,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: (value) =>
                      value!.trim().isEmpty ||
                          RegExp(r'\s').hasMatch(value.trim())
                      ? l.subtitle_invalid_key
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  l.subtitle_key_hint,
                  style: NodeLaneTokens.of(context).readerSecondary,
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: _saving
                        ? null
                        : () async {
                            try {
                              await launchUrl(
                                Uri.parse('https://store.wyzie.io/redeem'),
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (_) {}
                          },
                    child: Text(l.subtitle_get_key),
                  ),
                ),
              ],
              if (_mode == SubtitleConnectionMode.customService) ...[
                NodeLaneTextField(
                  key: const ValueKey('subtitle-address'),
                  controller: _address,
                  label: l.subtitle_service_address,
                  hint: 'https://example.com/search',
                  enabled: !_saving,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: (value) {
                    final uri = Uri.tryParse(value!.trim());
                    return uri != null && SubtitlePreferences.validEndpoint(uri)
                        ? null
                        : l.subtitle_invalid_address;
                  },
                ),
                const SizedBox(height: 16),
                NodeLaneTextField(
                  key: const ValueKey('subtitle-token'),
                  controller: _token,
                  label: l.subtitle_service_token,
                  enabled: !_saving,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: (value) => RegExp(r'\s').hasMatch(value!.trim())
                      ? l.subtitle_invalid_token
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  l.subtitle_custom_hint,
                  style: NodeLaneTokens.of(context).readerSecondary,
                ),
              ],
              if (_mode == SubtitleConnectionMode.disabled)
                Text(
                  l.subtitle_service_off_hint,
                  style: NodeLaneTokens.of(context).readerSecondary,
                ),
              const SizedBox(height: 24),
              if (_failed)
                NodeLaneNotice(
                  message: l.subtitle_storage_failed,
                  kind: NodeLaneNoticeKind.error,
                ),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? l.mass_migration_loading : l.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
