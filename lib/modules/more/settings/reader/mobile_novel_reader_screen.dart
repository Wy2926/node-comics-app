import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
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
        appBar: nodeLaneAppBar(context, title: '${l10n.novel} ${l10n.reader}'),
        body: SafeArea(
          top: false,
          child: ListView(
            key: const PageStorageKey('mobile-novel-reader-settings'),
            padding: NodeLaneTokens.pagePadding,
            children: [
              ?sessionControls,
              MobileSettingsGroup(
                title: l10n.font,
                children: [
                  _NovelChoice<String?>(
                    title: l10n.font,
                    icon: NodeLaneIcons.of(context).font,
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
                  NodeLaneSliderRow(
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
                  NodeLaneSwitchRow(
                    title: l10n.keep_screen_on,
                    icon: NodeLaneIcons.of(context).brightness,
                    value: ref.watch(keepScreenOnReaderStateProvider),
                    onChanged: ref
                        .read(keepScreenOnReaderStateProvider.notifier)
                        .set,
                  ),
                  NodeLaneSwitchRow(
                    title: l10n.show_scroll_percentage,
                    icon: NodeLaneIcons.of(context).percent,
                    value: ref.watch(novelShowScrollPercentageStateProvider),
                    onChanged: ref
                        .read(novelShowScrollPercentageStateProvider.notifier)
                        .set,
                  ),
                  if (onOpenTts != null)
                    NodeLaneRow(
                      title: l10n.tts,
                      icon: NodeLaneIcons.of(context).speech,
                      onTap: onOpenTts!,
                    ),
                ],
              ),
              MobileSettingsGroup(
                children: [
                  NodeLaneDisclosure(
                    key: const PageStorageKey('novel-reader-page-layout'),
                    title: l10n.reader_page_layout,
                    icon: NodeLaneIcons.of(context).manga,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [_NovelPageLayout()],
                    ),
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
          icon: NodeLaneIcons.of(context).palette,
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
        NodeLaneDisclosure(
          key: const PageStorageKey('novel-reader-custom-colors'),
          title: l10n.custom,
          icon: NodeLaneIcons.of(context).palette,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
    icon: NodeLaneIcons.of(context).palette,
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
              style: NodeLaneTokens.of(context).body
                  .copyWith(color: _parse(text!)),
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
          icon: NodeLaneIcons.of(context).alignLeft,
          value: alignment,
          subtitle: alignLabel(alignment),
          options: [
            for (final value in NovelTextAlign.values)
              MobileSettingOption(value, alignLabel(value)),
          ],
          onChanged: ref.read(novelTextAlignStateProvider.notifier).set,
        ),
        NodeLaneSliderRow(
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
        NodeLaneSliderRow(
          title: l10n.line_height,
          value: ref.watch(novelReaderLineHeightStateProvider),
          min: 1,
          max: 3,
          divisions: 20,
          label: (value) => value.toStringAsFixed(1),
          onChanged: ref.read(novelReaderLineHeightStateProvider.notifier).set,
        ),
        NodeLaneSwitchRow(
          title: l10n.remove_extra_paragraph_spacing,
          icon: NodeLaneIcons.of(context).lineSpacing,
          value: ref.watch(novelRemoveExtraParagraphSpacingStateProvider),
          onChanged: ref
              .read(novelRemoveExtraParagraphSpacingStateProvider.notifier)
              .set,
        ),
        NodeLaneSwitchRow(
          title: l10n.use_page_tap_zones,
          icon: NodeLaneIcons.of(context).navigation,
          value: ref.watch(novelTapToScrollStateProvider),
          onChanged: ref.read(novelTapToScrollStateProvider.notifier).set,
        ),
        NodeLaneSwitchRow(
          title: l10n.double_page_auto,
          subtitle: l10n.double_page_auto_subtitle,
          icon: NodeLaneIcons.of(context).rotate,
          value: ref.watch(doublePageAutoStateProvider),
          onChanged: ref.read(doublePageAutoStateProvider.notifier).set,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Text(
            l10n.novel_session_modes_hint,
            style: NodeLaneTokens.of(context).readerSecondary,
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
  Widget build(BuildContext context) => NodeLaneRow(
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
