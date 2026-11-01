import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/color_filter_provider.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_widgets.dart';
import 'package:mangayomi/modules/more/settings/reader/mobile_reader_settings_sections.dart';
import 'package:mangayomi/modules/more/settings/reader/mobile_reader_picker.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_settings_labels.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// The reader owns modes and auto-scroll. Global preference controls are shared
/// with the settings screen; this sheet does not duplicate their persistence.
Future<void> showMobileReaderSettings({
  required BuildContext context,
  required String bookTitle,
  required ProviderListenable<ReaderMode?> currentReaderModeProvider,
  required ValueNotifier<bool> autoScrollPage,
  required ValueNotifier<bool> autoScroll,
  required ValueNotifier<double> pageOffset,
  required void Function(ReaderMode, WidgetRef) onReaderModeChanged,
  required void Function(bool, double) onAutoScrollSave,
  required VoidCallback onAutoPageScroll,
}) async {
  if (!context.mounted || ModalRoute.of(context)?.isCurrent != true) return;
  final container = ProviderScope.containerOf(context, listen: false);
  var resume = autoScroll.value;
  autoScroll.value = false;
  try {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      showDragHandle: false,
      shape: NodeLaneTokens.readerSheetShape,
      builder: (_) => MobileReaderSettings(
        bookTitle: bookTitle,
        currentReaderModeProvider: currentReaderModeProvider,
        autoScrollPage: autoScrollPage,
        pageOffset: pageOffset,
        onReaderModeChanged: (mode, ref) {
          if (!context.mounted ||
              container.read(currentReaderModeProvider) == mode) {
            return;
          }
          onReaderModeChanged(mode, ref);
          // Mode changes may enable the reader's ticker. Keep it paused until
          // the modal actually closes, including while a selection page opens.
          resume = resume || autoScroll.value;
          autoScroll.value = false;
        },
        onAutoScrollChanged: (enabled) {
          if (!context.mounted || autoScrollPage.value == enabled) return;
          onAutoScrollSave(enabled, pageOffset.value);
          autoScrollPage.value = enabled;
          resume = enabled;
        },
        onSpeedChanged: (offset) {
          if (!context.mounted || pageOffset.value == offset) return;
          onAutoScrollSave(autoScrollPage.value, offset);
          pageOffset.value = offset;
        },
      ),
    );
  } finally {
    if (context.mounted &&
        ModalRoute.of(context)?.isCurrent == true &&
        resume &&
        autoScrollPage.value &&
        container.read(currentReaderModeProvider)?.isContinuous == true) {
      autoScroll.value = true;
      onAutoPageScroll();
    }
  }
}

class MobileReaderSettings extends ConsumerStatefulWidget {
  const MobileReaderSettings({
    super.key,
    required this.bookTitle,
    required this.currentReaderModeProvider,
    required this.autoScrollPage,
    required this.pageOffset,
    required this.onReaderModeChanged,
    required this.onAutoScrollChanged,
    required this.onSpeedChanged,
  });
  final String bookTitle;
  final ProviderListenable<ReaderMode?> currentReaderModeProvider;
  final ValueNotifier<bool> autoScrollPage;
  final ValueNotifier<double> pageOffset;
  final void Function(ReaderMode, WidgetRef) onReaderModeChanged;
  final ValueChanged<bool> onAutoScrollChanged;
  final ValueChanged<double> onSpeedChanged;

  @override
  ConsumerState<MobileReaderSettings> createState() =>
      _MobileReaderSettingsState();
}

class _MobileReaderSettingsState extends ConsumerState<MobileReaderSettings> {
  bool _leaving = false;

  void _close() {
    if (_leaving || !mounted || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    _leaving = true;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mode = ref.watch(widget.currentReaderModeProvider);
    return NodeLaneReaderSurface(
      child: MobileReaderPickerHost(
        bookTitle: widget.bookTitle,
        onClose: _close,
        child: MobileReaderSettingsTabs(
          title: l10n.reader_settings_title,
          labels: [l10n.reading_mode, l10n.general, l10n.reader_filters],
          closeLabel: l10n.close,
          onClose: _close,
          children: [
            _SettingsList(
              storageKey: 'reader-settings-mode',
              children: [
                Text(
                  widget.bookTitle,
                  style: NodeLaneTokens.of(context).readerLabel
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                _Scope(l10n.reader_settings_book_scope),
                if (mode != null)
                  MobileSettingsGroup(
                    children: [
                      MobileReaderSettingsChoice<ReaderMode>(
                        title: l10n.reading_mode,
                        scopeDescription: l10n.reader_picker_book_scope,
                        icon: Icons.chrome_reader_mode_outlined,
                        value: mode,
                        values: ReaderMode.values,
                        label: (value) => getReaderModeName(value, context),
                        onChanged: (value) {
                          if (!_leaving &&
                              mounted &&
                              ref.read(widget.currentReaderModeProvider) !=
                                  value) {
                            widget.onReaderModeChanged(value, ref);
                          }
                        },
                      ),
                      if (mode.isContinuous)
                        ValueListenableBuilder<bool>(
                          valueListenable: widget.autoScrollPage,
                          builder: (context, enabled, _) => Column(
                            children: [
                              MobileSettingsSwitch(
                                title: l10n.auto_scroll,
                                subtitle: l10n.reader_auto_scroll_pause,
                                icon: Icons.timer_outlined,
                                value: enabled,
                                onChanged: widget.onAutoScrollChanged,
                              ),
                              if (enabled)
                                ValueListenableBuilder<double>(
                                  valueListenable: widget.pageOffset,
                                  builder: (context, speed, _) =>
                                      MobileReaderSettingsSlider(
                                        title: (value) =>
                                            '${l10n.speed}: $value',
                                        value: speed.round(),
                                        min: 2,
                                        max: 30,
                                        divisions: 28,
                                        onChanged: (value) => widget
                                            .onSpeedChanged(value.toDouble()),
                                      ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                _Scope(l10n.reader_settings_global_scope),
                MobileSettingsGroup(
                  children: [
                    MobileSettingsSwitch(
                      title: l10n.crop_borders,
                      icon: Icons.crop_rounded,
                      value: ref.watch(cropBordersStateProvider),
                      onChanged: ref
                          .read(cropBordersStateProvider.notifier)
                          .set,
                    ),
                    MobileReaderSettingsExpansion(
                      storageKey: 'reader-details-page-layout',
                      title: l10n.reader_page_layout,
                      icon: Icons.auto_stories_outlined,
                      child: MobileReaderPageLayoutSettings(readerMode: mode),
                    ),
                    if (mode?.isContinuous == true)
                      MobileReaderSettingsExpansion(
                        storageKey: 'reader-details-continuous',
                        title: l10n.reader_continuous_options,
                        icon: Icons.view_day_outlined,
                        child: const MobileReaderContinuousSettings(),
                      ),
                  ],
                ),
              ],
            ),
            _GeneralSettings(readerMode: mode),
            const _FilterSettings(),
          ],
        ),
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  const _SettingsList({required this.storageKey, required this.children});
  final String storageKey;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => ListView(
    key: PageStorageKey(storageKey),
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
    children: children,
  );
}

class _Scope extends StatelessWidget {
  const _Scope(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: Text(text, style: NodeLaneTokens.of(context).readerSecondary),
  );
}

class _GeneralSettings extends ConsumerWidget {
  const _GeneralSettings({required this.readerMode});
  final ReaderMode? readerMode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scaleNames = getScaleTypeNames(context);
    return _SettingsList(
      storageKey: 'reader-settings-general',
      children: [
        _Scope(l10n.reader_settings_global_scope),
        MobileSettingsGroup(
          children: [
            MobileReaderSettingsChoice<ScaleType>(
              title: l10n.scale_type,
              icon: Icons.fit_screen_rounded,
              value: ref.watch(scaleTypeStateProvider),
              values: ScaleType.values.take(scaleNames.length).toList(),
              label: (value) => value.index < scaleNames.length
                  ? scaleNames[value.index]
                  : l10n.unknown,
              onChanged: ref.read(scaleTypeStateProvider.notifier).set,
            ),
            MobileReaderSettingsChoice<BackgroundColor>(
              title: l10n.background_color,
              icon: Icons.palette_outlined,
              value: ref.watch(backgroundColorStateProvider),
              valueLeading: ReaderBackgroundSwatch(
                value: ref.watch(backgroundColorStateProvider),
                size: NodeLaneTokens.readerValueSwatchSize,
              ),
              values: BackgroundColor.values,
              label: (value) => getBackgroundColorName(value, context),
              onChanged: ref.read(backgroundColorStateProvider.notifier).set,
            ),
            MobileSettingsSwitch(
              title: l10n.show_page_number,
              icon: Icons.format_list_numbered_rounded,
              value: ref.watch(showPagesNumberStateProvider) as bool,
              onChanged: ref.read(showPagesNumberStateProvider.notifier).set,
            ),
            MobileSettingsSwitch(
              title: l10n.keep_screen_on,
              icon: Icons.light_mode_outlined,
              value: ref.watch(keepScreenOnReaderStateProvider),
              onChanged: ref.read(keepScreenOnReaderStateProvider.notifier).set,
            ),
            MobileSettingsSwitch(
              title: l10n.animate_page_transitions,
              icon: Icons.animation_rounded,
              value: ref.watch(animatePageTransitionsStateProvider),
              onChanged: ref
                  .read(animatePageTransitionsStateProvider.notifier)
                  .set,
            ),
          ],
        ),
        MobileSettingsGroup(
          children: [
            MobileReaderSettingsExpansion(
              storageKey: 'reader-details-navigation',
              title: l10n.navigation_layout,
              icon: Icons.touch_app_outlined,
              child: MobileReaderNavigationSettings(
                readerMode: readerMode,
                includeChapterActions: false,
              ),
            ),
            MobileReaderSettingsExpansion(
              storageKey: 'reader-details-flash',
              title: l10n.flash_on_page_change,
              icon: Icons.flash_on_outlined,
              child: const MobileReaderFlashSettings(),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterSettings extends ConsumerWidget {
  const _FilterSettings();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final enabled = ref.watch(enableCustomColorFilterStateProvider);
    final rgba = ref.watch(customColorFilterStateProvider);
    final a = rgba?.a ?? 0,
        r = rgba?.r ?? 0,
        g = rgba?.g ?? 0,
        b = rgba?.b ?? 0;
    return ListTileTheme.merge(
      minTileHeight: NodeLaneTokens.readerFilterRowHeight,
      child: _SettingsList(
        storageKey: 'reader-settings-filter',
        children: [
          _Scope(l10n.reader_filter_scope),
          MobileSettingsGroup(
            children: [
              MobileSettingsSwitch(
                title: l10n.invert_colors,
                icon: Icons.invert_colors_rounded,
                value: ref.watch(invertColorsStateProvider),
                onChanged: ref.read(invertColorsStateProvider.notifier).set,
              ),
              MobileSettingsSwitch(
                title: l10n.grayscale,
                icon: Icons.tonality_rounded,
                value: ref.watch(grayscaleStateProvider),
                onChanged: ref.read(grayscaleStateProvider.notifier).set,
              ),
            ],
          ),
          MobileSettingsGroup(
            title: l10n.color_enhancements,
            spacing: 0,
            children: [
              _EnhancementSlider(
                title: l10n.brightness,
                icon: NodeLaneIcons.of(context).brightness,
                value: ref.watch(readerBrightnessStateProvider),
                min: -1,
                max: 1,
                initial: 0,
                onChanged: ref.read(readerBrightnessStateProvider.notifier).set,
              ),
              _EnhancementSlider(
                title: l10n.contrast,
                icon: NodeLaneIcons.of(context).contrast,
                value: ref.watch(readerContrastStateProvider),
                min: 0,
                max: 2,
                initial: 1,
                onChanged: ref.read(readerContrastStateProvider.notifier).set,
              ),
              _EnhancementSlider(
                title: l10n.saturation,
                icon: NodeLaneIcons.of(context).palette,
                value: ref.watch(readerSaturationStateProvider),
                min: 0,
                max: 2,
                initial: 1,
                onChanged: ref.read(readerSaturationStateProvider.notifier).set,
              ),
            ],
          ),
          MobileSettingsGroup(
            children: [
              MobileSettingsSwitch(
                title: l10n.custom_color_filter,
                icon: Icons.color_lens_outlined,
                value: enabled,
                onChanged: ref
                    .read(enableCustomColorFilterStateProvider.notifier)
                    .set,
              ),
              if (enabled) ...[
                rgbaFilterWidget(a, r, g, b, (change) {
                  // Read the latest other channels, not the values at pointer-down.
                  final current = ref.read(customColorFilterStateProvider);
                  ref
                      .read(customColorFilterStateProvider.notifier)
                      .set(
                        change.$3 == 'a' ? change.$1.toInt() : current?.a ?? 0,
                        change.$3 == 'r' ? change.$1.toInt() : current?.r ?? 0,
                        change.$3 == 'g' ? change.$1.toInt() : current?.g ?? 0,
                        change.$3 == 'b' ? change.$1.toInt() : current?.b ?? 0,
                        change.$2,
                      );
                }, context),
                MobileReaderSettingsChoice<ColorFilterBlendMode>(
                  title: l10n.color_filter_blend_mode,
                  icon: Icons.layers_outlined,
                  value: ref.watch(colorFilterBlendModeStateProvider),
                  values: ColorFilterBlendMode.values,
                  label: (value) => getColorFilterBlendModeName(value, context),
                  onChanged: ref
                      .read(colorFilterBlendModeStateProvider.notifier)
                      .set,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _EnhancementSlider extends StatelessWidget {
  const _EnhancementSlider({
    required this.title,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.initial,
    required this.onChanged,
  });
  final String title;
  final IconData icon;
  final double value, min, max, initial;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 24, color: NodeLaneTokens.of(context).ink),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: NodeLaneTokens.of(context).readerLabel),
            ),
            const SizedBox(width: 12),
            Text(
              value.toStringAsFixed(1),
              style: NodeLaneTokens.of(context).readerValue,
            ),
            IconButton(
              constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              style: IconButton.styleFrom(
                minimumSize: const Size(44, 44),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              tooltip: '${context.l10n.reset}: $title',
              onPressed: (value - initial).abs() < .01
                  ? null
                  : () => onChanged(initial),
              icon: Icon(
                NodeLaneIcons.of(context).reset,
                size: 20,
                color: NodeLaneTokens.of(context).muted,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 48, right: 44),
          child: SizedBox(
            height: 32,
            child: SliderTheme(
              data: readerSliderTheme(context)
                  .copyWith(thumbColor: NodeLaneTokens.of(context).line),
              child: Slider(
                padding: EdgeInsets.zero,
                min: min,
                max: max,
                value: value.clamp(min, max),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
