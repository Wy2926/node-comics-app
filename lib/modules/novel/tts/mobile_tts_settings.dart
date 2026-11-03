import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'tts_language_names.dart';

/// Preference storage and the speech engine stay with the caller. This view
/// owns only loading, draft slider values and feedback for explicit actions.
class MobileTtsSettings extends StatefulWidget {
  const MobileTtsSettings({
    super.key,
    required this.speed,
    required this.pitch,
    required this.language,
    required this.loadLanguages,
    required this.onSpeedChanged,
    required this.onPitchChanged,
    required this.onLanguageChanged,
  });
  final double speed, pitch;
  final String? language;
  final Future<List<dynamic>> Function() loadLanguages;
  final Future<void> Function(double) onSpeedChanged, onPitchChanged;
  final Future<void> Function(String?) onLanguageChanged;

  @override
  State<MobileTtsSettings> createState() => _MobileTtsSettingsState();
}

class _MobileTtsSettingsState extends State<MobileTtsSettings> {
  List<String> _languages = const [];
  bool _busy = false, _picking = false, _loadFailed = false;
  Future<void> Function()? _retryApply;

  @override
  void initState() {
    super.initState();
    unawaited(_loadLanguages());
  }

  Future<void> _loadLanguages() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _loadFailed = false;
    });
    try {
      final languages = await widget.loadLanguages();
      if (!mounted) return;
      setState(() {
        _languages =
            languages
                .whereType<String>()
                .where((code) => code.isNotEmpty)
                .toSet()
                .toList()
              ..sort();
      });
    } catch (_) {
      if (mounted) setState(() => _loadFailed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _apply(Future<void> Function() action) async {
    if (_busy || _picking) return;
    setState(() {
      _busy = true;
      _retryApply = null;
    });
    try {
      await action();
    } catch (_) {
      if (mounted) setState(() => _retryApply = action);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _selectLanguage() async {
    if (_busy || _picking || _loadFailed) return;
    final l10n = context.l10n;
    final previous = widget.language;
    setState(() => _picking = true);
    MobileSettingOption<String?>? selected;
    try {
      selected = await showMobileSettingsPicker<String?>(
        context,
        title: l10n.tts_language,
        current: previous,
        searchable: true,
        options: [
          MobileSettingOption(null, l10n.tts_default),
          if (previous != null && !_languages.contains(previous))
            MobileSettingOption(
              previous,
              _languageLabel(previous),
              subtitle: l10n.tts_language_unavailable,
            ),
          for (final code in _languages)
            MobileSettingOption(
              code,
              _languageLabel(code),
              subtitle: ttsLocaleNames.containsKey(code) ? code : null,
            ),
        ],
      );
    } finally {
      if (mounted) setState(() => _picking = false);
    }
    if (!mounted || selected == null || selected.value == widget.language) {
      return;
    }
    final value = selected.value;
    await _apply(() => widget.onLanguageChanged(value));
  }

  String _languageLabel(String code) => ttsLocaleNames[code] ?? code;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final language = widget.language;
    final enabled = !_busy && !_picking;
    final retryApply = _retryApply;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MobileSettingsGroup(
            children: [
              NodeLaneSliderRow(
                key: const ValueKey('tts-speed'),
                title: l10n.tts_speed,
                value: widget.speed,
                min: 0.1,
                max: 1,
                divisions: 9,
                label: (value) => '${(value * 2).toStringAsFixed(1)}x',
                enabled: enabled,
                onChanged: (value) =>
                    _apply(() => widget.onSpeedChanged(value)),
              ),
              NodeLaneSliderRow(
                key: const ValueKey('tts-pitch'),
                title: l10n.tts_pitch,
                value: widget.pitch,
                min: 0.5,
                max: 2,
                divisions: 15,
                label: (value) => value.toStringAsFixed(1),
                enabled: enabled,
                onChanged: (value) =>
                    _apply(() => widget.onPitchChanged(value)),
              ),
            ],
          ),
          MobileSettingsGroup(
            title: l10n.tts_language,
            children: [
              NodeLaneRow(
                enabled: enabled && !_loadFailed,
                icon: NodeLaneIcons.of(context).web,
                title: language == null
                    ? l10n.tts_default
                    : _languageLabel(language),
                subtitle:
                    language != null && ttsLocaleNames.containsKey(language)
                    ? language
                    : null,
                onTap: enabled && !_loadFailed ? _selectLanguage : null,
              ),
              if (!_busy && _loadFailed)
                _Feedback(
                  message: l10n.tts_languages_failed,
                  retryKey: const ValueKey('tts-retry-languages'),
                  onRetry: _loadLanguages,
                ),
              if (!_busy && !_loadFailed && _languages.isEmpty)
                _Feedback(message: l10n.tts_languages_empty),
              if (!_busy &&
                  !_loadFailed &&
                  language != null &&
                  !_languages.contains(language))
                _Feedback(message: l10n.tts_language_unavailable),
            ],
          ),
          if (_busy) const LinearProgressIndicator(),
          if (retryApply != null)
            _Feedback(
              message: l10n.tts_apply_failed,
              retryKey: const ValueKey('tts-retry-apply'),
              enabled: enabled,
              onRetry: () => _apply(retryApply),
            ),
        ],
      ),
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({
    required this.message,
    this.retryKey,
    this.onRetry,
    this.enabled = true,
  });
  final String message;
  final Key? retryKey;
  final VoidCallback? onRetry;
  final bool enabled;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            message,
            style: NodeLaneTokens.of(context).readerSecondary,
          ),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 8),
          TextButton(
            key: retryKey,
            onPressed: enabled ? onRetry : null,
            child: Text(context.l10n.retry),
          ),
        ],
      ],
    ),
  );
}
