import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

import 'providers/reader_state_provider.dart';
import 'reader_settings_labels.dart';
import 'mobile_reader_picker.dart';

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
        NodeLaneSwitchRow(
          title: l10n.split_wide_pages,
          icon: NodeLaneIcons.of(context).pageLayout,
          value: split,
          onChanged: ref.read(splitWidePagesStateProvider.notifier).set,
        ),
        if (split)
          NodeLaneSwitchRow(
            title: l10n.dual_page_invert,
            icon: NodeLaneIcons.of(context).migrate,
            value: ref.watch(dualPageInvertStateProvider),
            onChanged: ref.read(dualPageInvertStateProvider.notifier).set,
          ),
        NodeLaneSwitchRow(
          title: l10n.dual_page_rotate_to_fit,
          icon: NodeLaneIcons.of(context).rotate,
          value: rotate,
          onChanged: ref.read(dualPageRotateToFitStateProvider.notifier).set,
        ),
        if (rotate)
          NodeLaneSwitchRow(
            title: l10n.dual_page_rotate_to_fit_invert,
            icon: NodeLaneIcons.of(context).rotate,
            value: ref.watch(dualPageRotateToFitInvertStateProvider),
            onChanged: ref
                .read(dualPageRotateToFitInvertStateProvider.notifier)
                .set,
          ),
        NodeLaneSwitchRow(
          title: l10n.double_page_single_first_page,
          subtitle: l10n.double_page_single_first_page_subtitle,
          icon: NodeLaneIcons.of(context).novel,
          value: ref.watch(doublePageSingleFirstPageStateProvider),
          onChanged: ref
              .read(doublePageSingleFirstPageStateProvider.notifier)
              .set,
        ),
        NodeLaneSwitchRow(
          title: l10n.double_page_auto,
          subtitle: l10n.double_page_auto_subtitle,
          icon: NodeLaneIcons.of(context).pageLayout,
          value: ref.watch(doublePageAutoStateProvider),
          onChanged: ref.read(doublePageAutoStateProvider.notifier).set,
        ),
        if (readerMode?.isContinuous != true)
          NodeLaneSwitchRow(
            title: l10n.landscape_zoom,
            icon: NodeLaneIcons.of(context).search,
            value: landscape,
            onChanged: ref.read(landscapeZoomStateProvider.notifier).set,
          ),
        if (landscape && readerMode?.isContinuous != true)
          MobileReaderSettingsChoice<int>(
            title: l10n.zoom_start_position,
            icon: NodeLaneIcons.of(context).migrate,
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
        NodeLaneSwitchRow(
          title: l10n.webtoon_disable_zoom_out,
          icon: NodeLaneIcons.of(context).zoomOut,
          value: ref.watch(webtoonDisableZoomOutStateProvider),
          onChanged: ref.read(webtoonDisableZoomOutStateProvider.notifier).set,
        ),
        NodeLaneSwitchRow(
          title: l10n.webtoon_double_tap_zoom_enabled,
          icon: NodeLaneIcons.of(context).navigation,
          value: ref.watch(webtoonDoubleTapZoomEnabledStateProvider),
          onChanged: ref
              .read(webtoonDoubleTapZoomEnabledStateProvider.notifier)
              .set,
        ),
        NodeLaneSwitchRow(
          title: l10n.show_page_gaps,
          icon: NodeLaneIcons.of(context).lineSpacing,
          value: ref.watch(showPageGapsStateProvider),
          onChanged: ref.read(showPageGapsStateProvider.notifier).set,
        ),
        NodeLaneSliderRow(
          title: l10n.webtoon_side_padding,
          value: ref.watch(webtoonSidePaddingStateProvider).toDouble(),
          min: 0,
          max: 50,
          divisions: 50,
          onChanged: (value) => ref
              .read(webtoonSidePaddingStateProvider.notifier)
              .set(value.round()),
          label: (draft) => '${draft.round()}%',
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
        NodeLaneSwitchRow(
          title: l10n.use_page_tap_zones,
          icon: NodeLaneIcons.of(context).navigation,
          value: ref.watch(usePageTapZonesStateProvider),
          onChanged: ref.read(usePageTapZonesStateProvider.notifier).set,
        ),
        MobileReaderSettingsChoice<int>(
          title: l10n.navigation_layout,
          icon: NodeLaneIcons.of(context).extensions,
          value: ref.watch(readerNavigationLayoutStateProvider),
          values: const [0, 1, 2, 3, 4, 5],
          label: (value) => getReaderNavigationLayoutName(value, context),
          onChanged: ref.read(readerNavigationLayoutStateProvider.notifier).set,
        ),
        MobileReaderSettingsChoice<int>(
          title: l10n.tapping_inversion,
          icon: NodeLaneIcons.of(context).migrate,
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
          icon: NodeLaneIcons.of(context).lineSpacing,
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
        NodeLaneSwitchRow(
          title: l10n.show_navigation_overlay_on_start,
          icon: NodeLaneIcons.of(context).extensions,
          value: ref.watch(showNavigationOverlayOnStartStateProvider),
          onChanged: ref
              .read(showNavigationOverlayOnStartStateProvider.notifier)
              .set,
        ),
        if (readerMode?.isContinuous != true)
          NodeLaneSwitchRow(
            title: l10n.navigate_to_pan,
            subtitle: l10n.navigate_to_pan_subtitle,
            icon: NodeLaneIcons.of(context).navigation,
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
                style: NodeLaneTokens.of(context).readerSecondary,
              ),
            ),
          ),
          MobileReaderSettingsChoice<ChapterSwipeAction>(
            title: l10n.chapter_swipe_start,
            icon: NodeLaneIcons.of(context).readingRight,
            value: ref.watch(chapterSwipeStartActionStateProvider),
            values: ChapterSwipeAction.values,
            label: (value) => getChapterSwipeActionName(value, context),
            onChanged: ref
                .read(chapterSwipeStartActionStateProvider.notifier)
                .set,
          ),
          MobileReaderSettingsChoice<ChapterSwipeAction>(
            title: l10n.chapter_swipe_end,
            icon: NodeLaneIcons.of(context).readingLeft,
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
        NodeLaneNumberRow(
          title: l10n.page_preload_amount,
          subtitle: l10n.page_preload_amount_subtitle,
          icon: NodeLaneIcons.of(context).image,
          value: preload,
          min: 1,
          max: 20,
          onChanged: ref.read(pagePreloadAmountStateProvider.notifier).set,
        ),
        NodeLaneSwitchRow(
          title: l10n.animate_page_transitions,
          icon: NodeLaneIcons.of(context).animation,
          value: ref.watch(animatePageTransitionsStateProvider),
          onChanged: ref.read(animatePageTransitionsStateProvider.notifier).set,
        ),
        MobileReaderSettingsChoice<int>(
          title: l10n.double_tap_animation_speed,
          icon: NodeLaneIcons.of(context).speed,
          value: ref.watch(doubleTapAnimationSpeedStateProvider),
          values: const [0, 1, 2],
          label: (value) => getAnimationSpeedName(value, context),
          onChanged: ref
              .read(doubleTapAnimationSpeedStateProvider.notifier)
              .set,
        ),
        NodeLaneSwitchRow(
          title: l10n.mark_duplicate_chapters_read,
          icon: NodeLaneIcons.of(context).check,
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
        NodeLaneSwitchRow(
          title: l10n.flash_on_page_change,
          subtitle: l10n.flash_on_page_change_subtitle,
          icon: NodeLaneIcons.of(context).flash,
          value: flash,
          onChanged: ref.read(flashOnPageChangeStateProvider.notifier).set,
        ),
        if (flash) ...[
          MobileReaderSettingsChoice<int>(
            title: l10n.flash_color,
            icon: NodeLaneIcons.of(context).contrast,
            value: ref.watch(flashColorStateProvider),
            values: const [0, 1, 2],
            label: (value) => switch (value) {
              0 => l10n.flash_color_black,
              1 => l10n.flash_color_white,
              _ => l10n.flash_color_white_black,
            },
            onChanged: ref.read(flashColorStateProvider.notifier).set,
          ),
          NodeLaneSliderRow(
            title: l10n.flash_interval_label,
            value: ref.watch(flashIntervalStateProvider).toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (value) => ref
                .read(flashIntervalStateProvider.notifier)
                .set(value.round()),
            label: (draft) =>
                l10n.flash_interval_value(draft.round().toString()),
          ),
          NodeLaneSliderRow(
            title: l10n.flash_duration_label,
            value: ref.watch(flashDurationStateProvider).toDouble(),
            min: 50,
            max: 500,
            divisions: 9,
            onChanged: (value) => ref
                .read(flashDurationStateProvider.notifier)
                .set(value.round()),
            label: (draft) =>
                l10n.flash_duration_value(draft.round().toString()),
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
  Widget build(BuildContext context) => NodeLaneRow(
    openOnReveal: true,
    title: title,
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
    value: label(value),
  );
}
