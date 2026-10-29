import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/novel/utils/novel_reader_fonts.dart';
import 'package:mangayomi/modules/novel/utils/novel_reader_palette.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'providers/reader_state_provider.dart';

class MobileNovelReaderScreen extends ConsumerWidget {
  const MobileNovelReaderScreen({
    super.key,
    this.onOpenTts,
    this.sessionControls,
  });
  final VoidCallback? onOpenTts;

  /// Only the in-reader entry supplies controls for the current book.
  final Widget? sessionControls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final font = ref.watch(novelFontFamilyStateProvider);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${l10n.novel} ${l10n.reader}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            key: const PageStorageKey('mobile-novel-reader-settings'),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              ?sessionControls,
              MobileSettingsGroup(
                title: l10n.font,
                children: [
                  _NovelChoice<String?>(
                    title: l10n.font,
                    icon: Icons.font_download_outlined,
                    value: font,
                    subtitle:
                        novelReaderFontOptions
                            .where((option) => option.key == font)
                            .map(
                              (option) => option.key == null
                                  ? l10n.default0
                                  : option.label,
                            )
                            .firstOrNull ??
                        font ??
                        l10n.default0,
                    options: [
                      for (final option in novelReaderFontOptions)
                        MobileSettingOption(
                          option.key,
                          option.key == null ? l10n.default0 : option.label,
                        ),
                    ],
                    onChanged: ref
                        .read(novelFontFamilyStateProvider.notifier)
                        .set,
                  ),
                  _NovelSlider(
                    title: l10n.font_size,
                    value: ref.watch(novelFontSizeStateProvider).toDouble(),
                    min: 8,
                    max: 40,
                    divisions: 32,
                    label: (value) => '${value.round()} px',
                    onChanged: (value) => ref
                        .read(novelFontSizeStateProvider.notifier)
                        .set(value.round()),
                  ),
                ],
              ),
              const _NovelColors(),
              MobileSettingsGroup(
                title: l10n.general,
                children: [
                  MobileSettingsSwitch(
                    title: l10n.keep_screen_on,
                    icon: Icons.light_mode_outlined,
                    value: ref.watch(keepScreenOnReaderStateProvider),
                    onChanged: ref
                        .read(keepScreenOnReaderStateProvider.notifier)
                        .set,
                  ),
                  MobileSettingsSwitch(
                    title: l10n.show_scroll_percentage,
                    icon: Icons.percent_rounded,
                    value: ref.watch(novelShowScrollPercentageStateProvider),
                    onChanged: ref
                        .read(novelShowScrollPercentageStateProvider.notifier)
                        .set,
                  ),
                  if (onOpenTts != null)
                    MobileSettingsLink(
                      title: l10n.tts,
                      icon: Icons.record_voice_over_outlined,
                      onTap: onOpenTts!,
                    ),
                ],
              ),
              MobileSettingsGroup(
                children: [
                  ExpansionTile(
                    key: const PageStorageKey('novel-reader-page-layout'),
                    title: Text(l10n.reader_page_layout),
                    leading: Icon(
                      Icons.auto_stories_outlined,
                      color: NodeLaneTokens.of(context).accent,
                    ),
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: const Border(),
                    collapsedShape: const Border(),
                    children: const [_NovelPageLayout()],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NovelColors extends ConsumerWidget {
  const _NovelColors();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final background = ref.watch(novelReaderThemeStateProvider);
    final text = ref.watch(novelReaderTextColorStateProvider);
    final preset = NovelReaderThemePreset.values
        .where(
          (preset) => preset.background == background && preset.text == text,
        )
        .firstOrNull;
    return MobileSettingsGroup(
      title: l10n.theme,
      children: [
        _NovelChoice<NovelReaderThemePreset?>(
          title: l10n.theme,
          icon: Icons.palette_outlined,
          value: preset,
          subtitle: preset?.label(context) ?? l10n.custom,
          options: [
            for (final option in NovelReaderThemePreset.values)
              MobileSettingOption(
                option,
                option.label(context),
                leading: _ColorSample(option.background, text: option.text),
              ),
          ],
          onChanged: (selected) {
            if (selected == null) return;
            if (selected.background != background) {
              ref
                  .read(novelReaderThemeStateProvider.notifier)
                  .set(selected.background);
            }
            if (selected.text != text) {
              ref
                  .read(novelReaderTextColorStateProvider.notifier)
                  .set(selected.text);
            }
          },
        ),
        ExpansionTile(
          key: const PageStorageKey('novel-reader-custom-colors'),
          title: Text(l10n.custom),
          leading: Icon(
            Icons.color_lens_outlined,
            color: NodeLaneTokens.of(context).accent,
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: const Border(),
          collapsedShape: const Border(),
          children: [
            _colorChoice(
              context,
              title: l10n.background,
              value: background,
              onChanged: ref.read(novelReaderThemeStateProvider.notifier).set,
            ),
            _colorChoice(
              context,
              title: l10n.text,
              value: text,
              onChanged: ref
                  .read(novelReaderTextColorStateProvider.notifier)
                  .set,
            ),
          ],
        ),
      ],
    );
  }

  Widget _colorChoice(
    BuildContext context, {
    required String title,
    required String value,
    required ValueChanged<String> onChanged,
  }) => _NovelChoice<String>(
    title: title,
    icon: Icons.color_lens_outlined,
    value: value,
    subtitle: value,
    options: [
      for (final color in novelReaderColorPalette)
        MobileSettingOption(
          _hex(color),
          _hex(color),
          leading: _ColorSample(_hex(color)),
        ),
    ],
    onChanged: onChanged,
  );

  String _hex(Color color) =>
      '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
}

class _ColorSample extends StatelessWidget {
  const _ColorSample(this.background, {this.text});
  final String background;
  final String? text;

  Color _parse(String hex) =>
      Color(int.parse(hex.replaceFirst('#', 'FF'), radix: 16));

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _parse(background),
        border: Border.all(color: NodeLaneTokens.of(context).line),
        borderRadius: BorderRadius.circular(10),
      ),
      child: text == null
          ? null
          : Text(
              'Aa',
              textScaler: TextScaler.noScaling,
              style: TextStyle(color: _parse(text!), fontSize: 16),
            ),
    ),
  );
}

class _NovelPageLayout extends ConsumerWidget {
  const _NovelPageLayout();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final alignment = ref.watch(novelTextAlignStateProvider);
    String alignLabel(NovelTextAlign value) => switch (value) {
      NovelTextAlign.left => l10n.zoom_start_left,
      NovelTextAlign.center => l10n.zoom_start_center,
      NovelTextAlign.right => l10n.zoom_start_right,
      NovelTextAlign.block => l10n.text_align_justify,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NovelChoice<NovelTextAlign>(
          title: l10n.text_align,
          icon: Icons.format_align_left,
          value: alignment,
          subtitle: alignLabel(alignment),
          options: [
            for (final value in NovelTextAlign.values)
              MobileSettingOption(value, alignLabel(value)),
          ],
          onChanged: ref.read(novelTextAlignStateProvider.notifier).set,
        ),
        _NovelSlider(
          title: l10n.padding,
          value: ref.watch(novelReaderPaddingStateProvider).toDouble(),
          min: 0,
          max: 50,
          divisions: 50,
          label: (value) => '${value.round()} px',
          onChanged: (value) => ref
              .read(novelReaderPaddingStateProvider.notifier)
              .set(value.round()),
        ),
        _NovelSlider(
          title: l10n.line_height,
          value: ref.watch(novelReaderLineHeightStateProvider),
          min: 1,
          max: 3,
          divisions: 20,
          label: (value) => value.toStringAsFixed(1),
          onChanged: ref.read(novelReaderLineHeightStateProvider.notifier).set,
        ),
        MobileSettingsSwitch(
          title: l10n.remove_extra_paragraph_spacing,
          icon: Icons.format_line_spacing_rounded,
          value: ref.watch(novelRemoveExtraParagraphSpacingStateProvider),
          onChanged: ref
              .read(novelRemoveExtraParagraphSpacingStateProvider.notifier)
              .set,
        ),
        MobileSettingsSwitch(
          title: l10n.use_page_tap_zones,
          icon: Icons.touch_app_outlined,
          value: ref.watch(novelTapToScrollStateProvider),
          onChanged: ref.read(novelTapToScrollStateProvider.notifier).set,
        ),
        MobileSettingsSwitch(
          title: l10n.double_page_auto,
          subtitle: l10n.double_page_auto_subtitle,
          icon: Icons.screen_rotation_outlined,
          value: ref.watch(doublePageAutoStateProvider),
          onChanged: ref.read(doublePageAutoStateProvider.notifier).set,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Text(
            l10n.novel_session_modes_hint,
            style: TextStyle(color: NodeLaneTokens.of(context).muted),
          ),
        ),
      ],
    );
  }
}

class _NovelChoice<T> extends StatelessWidget {
  const _NovelChoice({
    required this.title,
    required this.icon,
    required this.value,
    required this.subtitle,
    required this.options,
    required this.onChanged,
  });
  final String title, subtitle;
  final IconData icon;
  final T value;
  final List<MobileSettingOption<T>> options;
  final ValueChanged<T> onChanged;
  @override
  Widget build(BuildContext context) => MobileSettingsLink(
    title: title,
    subtitle: subtitle,
    icon: icon,
    onTap: () async {
      final selected = await showMobileSettingsPicker<T>(
        context,
        title: title,
        current: value,
        options: options,
      );
      if (context.mounted && selected != null && selected.value != value) {
        onChanged(selected.value);
      }
    },
  );
}

class _NovelSlider extends StatefulWidget {
  const _NovelSlider({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.onChanged,
  });
  final String title;
  final double value, min, max;
  final int divisions;
  final String Function(double) label;
  final ValueChanged<double> onChanged;
  @override
  State<_NovelSlider> createState() => _NovelSliderState();
}

class _NovelSliderState extends State<_NovelSlider> {
  late double _draft = widget.value.clamp(widget.min, widget.max);
  @override
  void didUpdateWidget(covariant _NovelSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _draft = widget.value.clamp(widget.min, widget.max);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${widget.title}: ${widget.label(_draft)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Slider.adaptive(
          value: _draft,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          label: widget.label(_draft),
          onChanged: (value) => setState(() => _draft = value),
          onChangeEnd: (value) {
            if (value != widget.value) widget.onChanged(value);
          },
        ),
      ],
    ),
  );
}
