import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import '../reader_translation.dart';
import 'comic_reader_preferences.dart';
import 'comic_reader_preferences_provider.dart';
import 'comic_reader_scope.dart';

Future<void> showComicReaderSettings({
  required BuildContext context,
  required int bookId,
  required ValueNotifier<bool> autoScroll,
}) async {
  final translation = ReaderTranslationHost.controllerOf(context);
  autoScroll.value = false;
  await showNodeLaneCatalogSheet<void>(
    context,
    ComicReaderSettingsSheet(
      onTranslation: translation == null
          ? null
          : () => showTranslationControls(context, translation),
      bookId: bookId,
      autoScroll: autoScroll,
    ),
  );
}

class ComicReaderSettingsSheet extends StatelessWidget {
  const ComicReaderSettingsSheet({
    super.key,
    required this.bookId,
    this.onTranslation,
    required this.autoScroll,
  });
  final int bookId;
  final VoidCallback? onTranslation;
  final ValueNotifier<bool> autoScroll;

  @override
  Widget build(BuildContext context) => NodeLaneCatalogSheet(
    title: context.l10n.comic_reading,
    subtitle: context.l10n.comic_book_scope,
    heightFactor: NodeLaneTokens.readerSheetFraction,
    child: SingleChildScrollView(
      padding: NodeLaneTokens.pagePadding,
      child: ValueListenableBuilder<bool>(
        valueListenable: autoScroll,
        builder: (context, scrolling, _) => ComicReaderSettingsContent(
          bookId: bookId,
          onTranslation: onTranslation,
          onDefaults: () => showNodeLaneCatalogSheet<void>(
            context,
            NodeLaneCatalogSheet(
              title: context.l10n.comic_defaults_title,
              heightFactor: NodeLaneTokens.readerSheetFraction,
              child: const SingleChildScrollView(
                padding: NodeLaneTokens.pagePadding,
                child: ComicReaderSettingsContent(),
              ),
            ),
          ),
          scrolling: scrolling,
          onAutoScroll: (value) {
            autoScroll.value = value;
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

/// The same grouped controls serve both entry points and use the same choice,
/// disclosure and slider components as the novel reader. Writes stay here.
class ComicReaderSettingsContent extends ConsumerWidget {
  const ComicReaderSettingsContent({
    super.key,
    this.bookId,
    this.onDefaults,
    this.onTranslation,
    this.scrolling = false,
    this.onAutoScroll,
  });
  final int? bookId;
  final VoidCallback? onDefaults, onTranslation;
  final bool scrolling;
  final ValueChanged<bool>? onAutoScroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(comicReaderPreferencesProvider);
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    final profile = bookId == null
        ? const ComicBookSettings().resolve(data.defaults)
        : data.resolve(bookId!);
    Future<void> save(
      ComicReaderPreferences Function(ComicReaderPreferences) edit,
    ) async {
      try {
        await ref.read(comicReaderPreferencesProvider.notifier).update(edit);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.comic_save_failed)));
        }
      }
    }

    void book(ComicBookSettings Function(ComicBookSettings) edit) =>
        save((value) => value.updateBook(bookId!, edit));
    void defaults(ComicReaderDefaults Function(ComicReaderDefaults) edit) =>
        save((value) => value.copyWith(defaults: edit(value.defaults)));
    void habits(ComicReaderHabits Function(ComicReaderHabits) edit) =>
        save((value) => value.copyWith(habits: edit(value.habits)));
    Widget choice<T>({
      required String title,
      required IconData icon,
      required T value,
      required Map<T, String> labels,
      required ValueChanged<T> onChanged,
      Map<T, String>? hints,
      Map<T, IconData>? optionIcons,
      Widget Function(T)? preview,
    }) => MobileSettingsChoice<T>(
      title: title,
      icon: icon,
      value: value,
      label: (v) => labels[v]!,
      options: [
        for (final entry in labels.entries)
          MobileSettingOption(
            entry.key,
            entry.value,
            subtitle: hints?[entry.key],
            icon: optionIcons?[entry.key],
            leading: preview?.call(entry.key),
          ),
      ],
      onChanged: onChanged,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (bookId == null)
          Padding(
            padding: const EdgeInsets.only(bottom: NodeLaneTokens.space16),
            child: Text(l.comic_defaults_hint, style: t.readerSecondary),
          ),
        MobileSettingsGroup(
          title: bookId == null ? l.default_reading_mode : l.reading_mode,
          children: [
            choice<ComicReadingMode>(
              title: l.reading_mode,
              icon: icons.manga,
              value: profile.mode,
              labels: {
                ComicReadingMode.paged: l.comic_paged,
                ComicReadingMode.scroll: l.comic_scroll,
              },
              optionIcons: {
                ComicReadingMode.paged: icons.manga,
                ComicReadingMode.scroll: icons.continuousVertical,
              },
              onChanged: (mode) => bookId == null
                  ? defaults((v) => v.copyWith(mode: mode))
                  : book((v) => v.copyWith(mode: mode)),
            ),
            if (profile.mode == ComicReadingMode.paged) ...[
              choice<ComicPageTurn>(
                title: l.comic_turn,
                icon: icons.readingLeft,
                value: profile.turn,
                labels: {
                  ComicPageTurn.left: l.comic_left,
                  ComicPageTurn.right: l.comic_right,
                  ComicPageTurn.up: l.comic_up,
                },
                optionIcons: {
                  ComicPageTurn.left: icons.readingLeft,
                  ComicPageTurn.right: icons.readingRight,
                  ComicPageTurn.up: icons.ascending,
                },
                onChanged: (turn) => bookId == null
                    ? defaults((v) => v.copyWith(turn: turn))
                    : book((v) => v.copyWith(turn: turn)),
              ),
              choice<ComicPageFit>(
                title: l.comic_fit,
                icon: icons.fullscreen,
                value: profile.fit,
                labels: {
                  ComicPageFit.contain: l.comic_fit_contain,
                  ComicPageFit.width: l.comic_fit_width,
                  ComicPageFit.height: l.comic_fit_height,
                },
                optionIcons: {
                  ComicPageFit.contain: icons.fullscreen,
                  ComicPageFit.width: icons.fitWidth,
                  ComicPageFit.height: icons.fitHeight,
                },
                onChanged: (fit) => bookId == null
                    ? defaults((v) => v.copyWith(fit: fit))
                    : book((v) => v.copyWith(fit: fit)),
              ),
              if (profile.turn != ComicPageTurn.up)
                choice<ComicPageLayout>(
                  title: l.comic_layout,
                  icon: icons.pageLayout,
                  value: profile.layout,
                  labels: {
                    ComicPageLayout.automatic: l.comic_auto,
                    ComicPageLayout.single: l.single_page,
                    ComicPageLayout.double: l.double_page,
                  },
                  optionIcons: {
                    ComicPageLayout.automatic: icons.automaticPages,
                    ComicPageLayout.single: icons.singlePage,
                    ComicPageLayout.double: icons.horizontalPages,
                  },
                  hints: {ComicPageLayout.automatic: l.comic_layout_hint},
                  onChanged: (layout) => bookId == null
                      ? defaults((v) => v.copyWith(layout: layout))
                      : book((v) => v.copyWith(layout: layout)),
                ),
            ] else if (bookId != null) ...[
              choice<ComicContentWidth>(
                title: l.comic_width,
                icon: icons.fullscreen,
                value: profile.width,
                labels: {
                  ComicContentWidth.full: l.comic_full,
                  ComicContentWidth.comfortable: l.comic_comfortable,
                  ComicContentWidth.narrow: l.comic_narrow,
                },
                onChanged: (width) => book((v) => v.copyWith(width: width)),
              ),
              choice<bool>(
                title: l.comic_gap,
                icon: icons.lineSpacing,
                value: profile.gap,
                labels: {false: l.comic_no_gap, true: l.comic_small_gap},
                optionIcons: {
                  false: icons.seamlessPages,
                  true: icons.spacedPages,
                },
                onChanged: (gap) => book((v) => v.copyWith(gap: gap)),
              ),
            ],
          ],
        ),
        if (bookId != null) ...[
          if (profile.mode == ComicReadingMode.scroll)
            MobileSettingsGroup(
              title: l.auto_scroll,
              children: [
                NodeLaneSliderRow(
                  title: l.comic_scroll_speed,
                  value: data.scrollSpeed,
                  min: 10,
                  max: 100,
                  divisions: 18,
                  label: (v) => '${v.round()} px/s',
                  onChanged: (speed) =>
                      save((v) => v.copyWith(scrollSpeed: speed)),
                ),
                NodeLaneRow(
                  title: scrolling
                      ? l.comic_scroll_pause
                      : l.comic_scroll_start,
                  subtitle: l.comic_scroll_hint,
                  icon: scrolling ? icons.pause : icons.play,
                  onTap: () => onAutoScroll?.call(!scrolling),
                ),
              ],
            ),
          MobileSettingsGroup(
            children: [
              NodeLaneDisclosure(
                title: l.comic_image_title,
                icon: icons.adjustments,
                subtitle: l.comic_image_hint,
                child: Column(
                  children: [
                    NodeLaneSwitchRow(
                      title: l.crop_borders,
                      icon: icons.crop,
                      value: profile.crop,
                      onChanged: (crop) => book((v) => v.copyWith(crop: crop)),
                    ),
                    if (profile.mode == ComicReadingMode.paged) ...[
                      if (!profile.doublePage(MediaQuery.sizeOf(context).width))
                        choice<ComicWidePage>(
                          title: l.comic_wide,
                          icon: icons.horizontalPages,
                          value: profile.widePage,
                          labels: {
                            ComicWidePage.intact: l.comic_intact,
                            ComicWidePage.split: l.comic_split,
                            ComicWidePage.rotate: l.comic_rotate,
                          },
                          optionIcons: {
                            ComicWidePage.intact: icons.intactPage,
                            ComicWidePage.split: icons.horizontalPages,
                            ComicWidePage.rotate: icons.rotate,
                          },
                          hints: {ComicWidePage.split: l.comic_wide_hint},
                          onChanged: (widePage) =>
                              book((v) => v.copyWith(widePage: widePage)),
                        ),
                      if (profile.doublePage(MediaQuery.sizeOf(context).width))
                        NodeLaneSwitchRow(
                          title: l.comic_cover,
                          icon: icons.bookmarkOutline,
                          value: profile.singleCover,
                          onChanged: (singleCover) =>
                              book((v) => v.copyWith(singleCover: singleCover)),
                        ),
                    ],
                    NodeLaneSwitchRow(
                      title: l.invert_colors,
                      icon: icons.contrast,
                      value: profile.invert,
                      onChanged: (invert) =>
                          book((v) => v.copyWith(invert: invert)),
                    ),
                    NodeLaneSliderRow(
                      title: l.brightness,
                      value: profile.brightness,
                      min: -.5,
                      max: .5,
                      divisions: 20,
                      label: (v) => '${(v * 100).round()}%',
                      onChanged: (brightness) =>
                          book((v) => v.copyWith(brightness: brightness)),
                    ),
                    NodeLaneSliderRow(
                      title: l.contrast,
                      value: profile.contrast,
                      min: .5,
                      max: 1.5,
                      divisions: 20,
                      label: (v) => '${(v * 100).round()}%',
                      onChanged: (contrast) =>
                          book((v) => v.copyWith(contrast: contrast)),
                    ),
                    NodeLaneRow(
                      title: l.comic_effects_reset,
                      icon: icons.reset,
                      onTap: () => book(
                        (v) => v.copyWith(
                          invert: false,
                          brightness: 0,
                          contrast: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          MobileSettingsGroup(
            children: [
              if (onTranslation != null)
                NodeLaneRow(
                  title: '漫画翻译',
                  subtitle: '自动翻译、目标语言与渠道',
                  icon: icons.translate,
                  onTap: onTranslation,
                ),
              NodeLaneRow(
                title: l.comic_defaults_title,
                icon: icons.settings,
                onTap: onDefaults,
              ),
              NodeLaneRow(
                title: l.comic_book_reset,
                subtitle: l.comic_book_reset_hint,
                icon: icons.reset,
                onTap: () => save((value) => value.resetBook(bookId!)),
              ),
            ],
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(bottom: NodeLaneTokens.space16),
            child: Text(l.comic_habits_hint, style: t.readerSecondary),
          ),
          MobileSettingsGroup(
            title: l.theme,
            children: [
              choice<ComicCanvas>(
                title: l.comic_canvas,
                icon: icons.palette,
                value: data.habits.canvas,
                labels: {
                  ComicCanvas.system: l.comic_system,
                  ComicCanvas.black: l.comic_black,
                  ComicCanvas.gray: l.comic_gray,
                  ComicCanvas.paper: l.comic_paper,
                },
                preview: (canvas) => Container(
                  width: NodeLaneTokens.readerValueSwatchSize,
                  height: NodeLaneTokens.readerValueSwatchSize,
                  decoration: BoxDecoration(
                    color: canvas.color(context),
                    borderRadius: BorderRadius.circular(
                      NodeLaneTokens.controlRadius,
                    ),
                    border: Border.all(color: t.line),
                  ),
                ),
                onChanged: (canvas) =>
                    habits((v) => v.copyWith(canvas: canvas)),
              ),
            ],
          ),
          MobileSettingsGroup(
            title: l.general,
            children: [
              NodeLaneSwitchRow(
                title: l.show_page_number,
                icon: icons.pageNumber,
                value: data.habits.pageNumber,
                onChanged: (pageNumber) =>
                    habits((v) => v.copyWith(pageNumber: pageNumber)),
              ),
              NodeLaneSwitchRow(
                title: l.keep_screen_on,
                icon: icons.brightness,
                value: data.habits.keepAwake,
                onChanged: (keepAwake) =>
                    habits((v) => v.copyWith(keepAwake: keepAwake)),
              ),
              NodeLaneSwitchRow(
                title: l.comic_tap,
                subtitle: l.comic_tap_hint,
                icon: icons.navigation,
                value: data.habits.tapToTurn,
                onChanged: (tapToTurn) =>
                    habits((v) => v.copyWith(tapToTurn: tapToTurn)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
