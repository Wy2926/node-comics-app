import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_text_dialog.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';

import 'providers/reader_state_provider.dart';
import 'reader_settings_labels.dart';
import 'mobile_reader_picker.dart';

class MobileReaderSettingsExpansion extends StatelessWidget {
  const MobileReaderSettingsExpansion({
    super.key,
    required this.storageKey,
    required this.title,
    required this.icon,
    required this.child,
  });
  final String storageKey, title;
  final IconData icon;
  final Widget child;
  @override
  Widget build(BuildContext context) => ExpansionTile(
    key: PageStorageKey(storageKey),
    title: Text(
      title,
      style: NodeLaneReaderScope.activeOf(context)
          ? NodeLaneTokens.of(context).readerLabel
          : NodeLaneTokens.of(context).body
                .copyWith(fontWeight: FontWeight.w500),
    ),
    leading: Icon(
      NodeLaneReaderScope.activeOf(context)
          ? NodeLaneIcons.of(context).readerSetting(icon)
          : icon,
      color: NodeLaneReaderScope.activeOf(context)
          ? NodeLaneTokens.of(context).ink
          : NodeLaneTokens.of(context).accent,
      size: NodeLaneTokens.iconSize,
    ),
    minTileHeight: NodeLaneReaderScope.activeOf(context)
        ? NodeLaneTokens.readerRowHeight
        : null,
    tilePadding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: NodeLaneReaderScope.activeOf(context) ? 0 : 8,
    ),
    shape: const Border(),
    collapsedShape: const Border(),
    children: [child],
  );
}

class MobileReaderPageLayoutSettings extends ConsumerWidget {
  const MobileReaderPageLayoutSettings({super.key, this.readerMode});
  final ReaderMode? readerMode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final split = ref.watch(splitWidePagesStateProvider);
    final rotate = ref.watch(dualPageRotateToFitStateProvider);
    final landscape = ref.watch(landscapeZoomStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MobileSettingsSwitch(
          title: l10n.split_wide_pages,
          icon: Icons.vertical_split_outlined,
          value: split,
          onChanged: ref.read(splitWidePagesStateProvider.notifier).set,
        ),
        if (split)
          MobileSettingsSwitch(
            title: l10n.dual_page_invert,
            icon: Icons.swap_horiz_rounded,
            value: ref.watch(dualPageInvertStateProvider),
            onChanged: ref.read(dualPageInvertStateProvider.notifier).set,
          ),
        MobileSettingsSwitch(
          title: l10n.dual_page_rotate_to_fit,
          icon: Icons.screen_rotation_outlined,
          value: rotate,
          onChanged: ref.read(dualPageRotateToFitStateProvider.notifier).set,
        ),
        if (rotate)
          MobileSettingsSwitch(
            title: l10n.dual_page_rotate_to_fit_invert,
            icon: Icons.rotate_left_rounded,
            value: ref.watch(dualPageRotateToFitInvertStateProvider),
            onChanged: ref
                .read(dualPageRotateToFitInvertStateProvider.notifier)
                .set,
          ),
        MobileSettingsSwitch(
          title: l10n.double_page_single_first_page,
          subtitle: l10n.double_page_single_first_page_subtitle,
          icon: Icons.first_page_rounded,
          value: ref.watch(doublePageSingleFirstPageStateProvider),
          onChanged: ref
              .read(doublePageSingleFirstPageStateProvider.notifier)
              .set,
        ),
        MobileSettingsSwitch(
          title: l10n.double_page_auto,
          subtitle: l10n.double_page_auto_subtitle,
          icon: Icons.view_week_outlined,
          value: ref.watch(doublePageAutoStateProvider),
          onChanged: ref.read(doublePageAutoStateProvider.notifier).set,
        ),
        if (readerMode?.isContinuous != true)
          MobileSettingsSwitch(
            title: l10n.landscape_zoom,
            icon: Icons.zoom_in_rounded,
            value: landscape,
            onChanged: ref.read(landscapeZoomStateProvider.notifier).set,
          ),
        if (landscape && readerMode?.isContinuous != true)
          MobileReaderSettingsChoice<int>(
            title: l10n.zoom_start_position,
            icon: Icons.horizontal_distribute_rounded,
            value: ref.watch(zoomStartPositionStateProvider),
            values: const [0, 1, 2],
            label: (value) => switch (value) {
              0 => l10n.zoom_start_left,
              1 => l10n.zoom_start_right,
              _ => l10n.zoom_start_center,
            },
            onChanged: ref.read(zoomStartPositionStateProvider.notifier).set,
          ),
      ],
    );
  }
}

class MobileReaderContinuousSettings extends ConsumerWidget {
  const MobileReaderContinuousSettings({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MobileSettingsSwitch(
          title: l10n.webtoon_disable_zoom_out,
          icon: Icons.zoom_out_rounded,
          value: ref.watch(webtoonDisableZoomOutStateProvider),
          onChanged: ref.read(webtoonDisableZoomOutStateProvider.notifier).set,
        ),
        MobileSettingsSwitch(
          title: l10n.webtoon_double_tap_zoom_enabled,
          icon: Icons.touch_app_outlined,
          value: ref.watch(webtoonDoubleTapZoomEnabledStateProvider),
          onChanged: ref
              .read(webtoonDoubleTapZoomEnabledStateProvider.notifier)
              .set,
        ),
        MobileSettingsSwitch(
          title: l10n.show_page_gaps,
          icon: Icons.format_line_spacing_rounded,
          value: ref.watch(showPageGapsStateProvider),
          onChanged: ref.read(showPageGapsStateProvider.notifier).set,
        ),
        MobileReaderSettingsSlider(
          title: (value) => '${l10n.webtoon_side_padding}: $value%',
          value: ref.watch(webtoonSidePaddingStateProvider),
          min: 0,
          max: 50,
          divisions: 50,
          onChanged: ref.read(webtoonSidePaddingStateProvider.notifier).set,
        ),
      ],
    );
  }
}

class MobileReaderNavigationSettings extends ConsumerWidget {
  const MobileReaderNavigationSettings({
    super.key,
    this.readerMode,
    this.includeChapterActions = true,
  });
  final ReaderMode? readerMode;
  final bool includeChapterActions;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MobileSettingsSwitch(
          title: l10n.use_page_tap_zones,
          icon: Icons.touch_app_outlined,
          value: ref.watch(usePageTapZonesStateProvider),
          onChanged: ref.read(usePageTapZonesStateProvider.notifier).set,
        ),
        MobileReaderSettingsChoice<int>(
          title: l10n.navigation_layout,
          icon: Icons.view_quilt_outlined,
          value: ref.watch(readerNavigationLayoutStateProvider),
          values: const [0, 1, 2, 3, 4, 5],
          label: (value) => getReaderNavigationLayoutName(value, context),
          onChanged: ref.read(readerNavigationLayoutStateProvider.notifier).set,
        ),
        MobileReaderSettingsChoice<int>(
          title: l10n.tapping_inversion,
          icon: Icons.swap_horiz_rounded,
          value: ref.watch(tappingInversionStateProvider),
          values: const [0, 1, 2, 3],
          label: (value) => switch (value) {
            1 => l10n.tapping_inversion_horizontal,
            2 => l10n.tapping_inversion_vertical,
            3 => l10n.tapping_inversion_both,
            _ => l10n.tapping_inversion_none,
          },
          onChanged: ref.read(tappingInversionStateProvider.notifier).set,
        ),
        MobileReaderSettingsChoice<int>(
          title: l10n.reader_hide_threshold,
          icon: Icons.swipe_vertical_rounded,
          value: ref.watch(readerHideThresholdStateProvider),
          values: const [0, 1, 2, 3],
          label: (value) => switch (value) {
            0 => l10n.reader_hide_threshold_highest,
            1 => l10n.reader_hide_threshold_high,
            _ =>
              value == 2
                  ? l10n.reader_hide_threshold_low
                  : l10n.reader_hide_threshold_lowest,
          },
          onChanged: ref.read(readerHideThresholdStateProvider.notifier).set,
        ),
        MobileSettingsSwitch(
          title: l10n.show_navigation_overlay_on_start,
          icon: Icons.grid_view_outlined,
          value: ref.watch(showNavigationOverlayOnStartStateProvider),
          onChanged: ref
              .read(showNavigationOverlayOnStartStateProvider.notifier)
              .set,
        ),
        if (readerMode?.isContinuous != true)
          MobileSettingsSwitch(
            title: l10n.navigate_to_pan,
            subtitle: l10n.navigate_to_pan_subtitle,
            icon: Icons.pan_tool_alt_outlined,
            value: ref.watch(navigateToPanStateProvider),
            onChanged: ref.read(navigateToPanStateProvider.notifier).set,
          ),
        if (includeChapterActions) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Semantics(
              header: true,
              child: Text(
                l10n.chapter_swipe_actions,
                style: TextStyle(color: NodeLaneTokens.of(context).muted),
              ),
            ),
          ),
          MobileReaderSettingsChoice<ChapterSwipeAction>(
            title: l10n.chapter_swipe_start,
            icon: Icons.swipe_right_outlined,
            value: ref.watch(chapterSwipeStartActionStateProvider),
            values: ChapterSwipeAction.values,
            label: (value) => getChapterSwipeActionName(value, context),
            onChanged: ref
                .read(chapterSwipeStartActionStateProvider.notifier)
                .set,
          ),
          MobileReaderSettingsChoice<ChapterSwipeAction>(
            title: l10n.chapter_swipe_end,
            icon: Icons.swipe_left_outlined,
            value: ref.watch(chapterSwipeEndActionStateProvider),
            values: ChapterSwipeAction.values,
            label: (value) => getChapterSwipeActionName(value, context),
            onChanged: ref
                .read(chapterSwipeEndActionStateProvider.notifier)
                .set,
          ),
        ],
      ],
    );
  }
}

class MobileReaderAdvancedSettings extends ConsumerWidget {
  const MobileReaderAdvancedSettings({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final preload = ref.watch(pagePreloadAmountStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MobileSettingsLink(
          title: l10n.page_preload_amount,
          subtitle: preload.toString(),
          icon: Icons.photo_library_outlined,
          onTap: () async {
            final value = await showDialog<String>(
              context: context,
              builder: (_) => MobileSettingsTextDialog(
                title: l10n.page_preload_amount,
                initialValue: preload.toString(),
                helper: l10n.page_preload_amount_subtitle,
                keyboardType: TextInputType.number,
                isValid: (text) {
                  final number = int.tryParse(text);
                  return number != null && number >= 1 && number <= 20;
                },
              ),
            );
            if (!context.mounted || value == null) return;
            final number = int.parse(value);
            if (number != preload) {
              ref.read(pagePreloadAmountStateProvider.notifier).set(number);
            }
          },
        ),
        MobileSettingsSwitch(
          title: l10n.animate_page_transitions,
          icon: Icons.animation_rounded,
          value: ref.watch(animatePageTransitionsStateProvider),
          onChanged: ref.read(animatePageTransitionsStateProvider.notifier).set,
        ),
        MobileReaderSettingsChoice<int>(
          title: l10n.double_tap_animation_speed,
          icon: Icons.speed_rounded,
          value: ref.watch(doubleTapAnimationSpeedStateProvider),
          values: const [0, 1, 2],
          label: (value) => getAnimationSpeedName(value, context),
          onChanged: ref
              .read(doubleTapAnimationSpeedStateProvider.notifier)
              .set,
        ),
        MobileSettingsSwitch(
          title: l10n.mark_duplicate_chapters_read,
          icon: Icons.done_all_rounded,
          value: ref.watch(autoReadDuplicateChaptersStateProvider),
          onChanged: ref
              .read(autoReadDuplicateChaptersStateProvider.notifier)
              .set,
        ),
        const MobileReaderFlashSettings(),
      ],
    );
  }
}

class MobileReaderFlashSettings extends ConsumerWidget {
  const MobileReaderFlashSettings({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final flash = ref.watch(flashOnPageChangeStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MobileSettingsSwitch(
          title: l10n.flash_on_page_change,
          subtitle: l10n.flash_on_page_change_subtitle,
          icon: Icons.flash_on_outlined,
          value: flash,
          onChanged: ref.read(flashOnPageChangeStateProvider.notifier).set,
        ),
        if (flash) ...[
          MobileReaderSettingsChoice<int>(
            title: l10n.flash_color,
            icon: Icons.contrast_rounded,
            value: ref.watch(flashColorStateProvider),
            values: const [0, 1, 2],
            label: (value) => switch (value) {
              0 => l10n.flash_color_black,
              1 => l10n.flash_color_white,
              _ => l10n.flash_color_white_black,
            },
            onChanged: ref.read(flashColorStateProvider.notifier).set,
          ),
          MobileReaderSettingsSlider(
            title: (value) => l10n.flash_interval(value.toString()),
            value: ref.watch(flashIntervalStateProvider),
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: ref.read(flashIntervalStateProvider.notifier).set,
          ),
          MobileReaderSettingsSlider(
            title: (value) => l10n.flash_duration(value.toString()),
            value: ref.watch(flashDurationStateProvider),
            min: 50,
            max: 500,
            divisions: 9,
            onChanged: ref.read(flashDurationStateProvider.notifier).set,
          ),
        ],
      ],
    );
  }
}

/// A selection page owns no preferences; only a confirmed selection is saved.
class MobileReaderSettingsChoice<T> extends StatelessWidget {
  const MobileReaderSettingsChoice({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.values,
    required this.label,
    required this.onChanged,
    this.valueLeading,
    this.scopeDescription,
  });
  final String title;
  final IconData icon;
  final T value;
  final List<T> values;
  final String Function(T) label;
  final ValueChanged<T> onChanged;
  final Widget? valueLeading;
  final String? scopeDescription;
  @override
  Widget build(BuildContext context) => MobileSettingsLink(
    title: title,
    subtitle: label(value),
    valueLeading: valueLeading,
    icon: icon,
    onTap: () async {
      if (!context.mounted || ModalRoute.of(context)?.isCurrent != true) return;
      final selected = await showMobileReaderPicker<T>(
        context,
        title: title,
        current: value,
        description:
            scopeDescription ?? context.l10n.reader_picker_global_scope,
        options: [
          for (final option in values)
            readerSettingOption(context, option, label(option)),
        ],
      );
      if (context.mounted && selected != null && selected.value != value) {
        onChanged(selected.value);
      }
    },
  );
}

/// Keeps drag feedback local and persists once, when the gesture ends.
class MobileReaderSettingsSlider extends StatefulWidget {
  const MobileReaderSettingsSlider({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });
  final String Function(int) title;
  final int value, min, max, divisions;
  final ValueChanged<int> onChanged;
  @override
  State<MobileReaderSettingsSlider> createState() =>
      _MobileReaderSettingsSliderState();
}

class _MobileReaderSettingsSliderState
    extends State<MobileReaderSettingsSlider> {
  late int _draft = widget.value.clamp(widget.min, widget.max);
  @override
  void didUpdateWidget(covariant MobileReaderSettingsSlider oldWidget) {
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
          widget.title(_draft),
          style: NodeLaneReaderScope.activeOf(context)
              ? NodeLaneTokens.of(context).readerLabel
              : NodeLaneTokens.of(context).body
                    .copyWith(fontWeight: FontWeight.w500),
        ),
        Slider.adaptive(
          min: widget.min.toDouble(),
          max: widget.max.toDouble(),
          divisions: widget.divisions,
          value: _draft.toDouble(),
          label: _draft.toString(),
          onChanged: (value) => setState(() => _draft = value.round()),
          onChangeEnd: (value) {
            final selected = value.round();
            if (selected != widget.value) widget.onChanged(selected);
          },
        ),
      ],
    ),
  );
}
