import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/tts/novel_tts_service.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

import 'tts_language_names.dart';

class TtsSettingsTab extends ConsumerStatefulWidget {
  const TtsSettingsTab({super.key});

  @override
  ConsumerState<TtsSettingsTab> createState() => _TtsSettingsTabState();
}

class _TtsSettingsTabState extends ConsumerState<TtsSettingsTab> {
  List<dynamic> _languages = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    final tts = NovelTtsService.instance;
    final langs = await tts.getLanguages();
    langs.sort((a, b) => a.toString().compareTo(b.toString()));
    if (mounted) {
      setState(() {
        _languages = langs;
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final speed = ref.watch(ttsSpeechRateStateProvider);
    final pitch = ref.watch(ttsPitchStateProvider);
    final language = ref.watch(ttsLanguageStateProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Speed slider
          _SettingSection(
            title: context.l10n.tts_speed,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.speed,
                    size: 22,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16,
                      ),
                      activeTrackColor: Theme.of(context).primaryColor,
                      inactiveTrackColor: Theme.of(context).primaryColor
                          .withValues(alpha: 0.2),
                      thumbColor: Theme.of(context).primaryColor,
                      overlayColor: Theme.of(context).primaryColor
                          .withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: speed,
                      min: 0.1,
                      max: 1.0,
                      divisions: 9,
                      label: '${(speed * 2).toStringAsFixed(1)}x',
                      onChanged: (value) {
                        ref
                            .read(ttsSpeechRateStateProvider.notifier)
                            .set(value);
                        NovelTtsService.instance.setSpeed(value);
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(speed * 2).toStringAsFixed(1)}x',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Pitch slider
          _SettingSection(
            title: context.l10n.tts_pitch,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.tune,
                    size: 22,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16,
                      ),
                      activeTrackColor: Theme.of(context).primaryColor,
                      inactiveTrackColor: Theme.of(context).primaryColor
                          .withValues(alpha: 0.2),
                      thumbColor: Theme.of(context).primaryColor,
                      overlayColor: Theme.of(context).primaryColor
                          .withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: pitch,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15,
                      label: pitch.toStringAsFixed(1),
                      onChanged: (value) {
                        ref.read(ttsPitchStateProvider.notifier).set(value);
                        NovelTtsService.instance.setPitch(value);
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    pitch.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Language dropdown
          if (_loaded)
            _SettingSection(
              title: context.l10n.tts_language,
              child: DropdownButtonFormField<String>(
                // ignore: deprecated_member_use
                value: language,
                isExpanded: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.language,
                    color: Theme.of(context).primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(context.l10n.tts_default),
                  ),
                  ..._languages.map((lang) {
                    final code = lang.toString();
                    final name = ttsLocaleNames[code] ?? code;
                    return DropdownMenuItem<String>(
                      value: code,
                      child: Text('$name ($code)'),
                    );
                  }),
                ],
                onChanged: (value) {
                  ref.read(ttsLanguageStateProvider.notifier).set(value);
                  if (value != null) {
                    NovelTtsService.instance.setLanguage(value);
                  }
                },
              ),
            ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SettingSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor.withValues(alpha: 0.04),
                Colors.transparent,
              ],
            ),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ],
    );
  }
}
