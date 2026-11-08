import 'package:mangayomi/theme/nodelane_icons.dart';

import '../reader_translation.dart';

import 'package:mangayomi/modules/translation/translation_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_reveal.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'comic_reader_preferences.dart';
import 'comic_reader_preferences_provider.dart';

enum _ReaderSection { book, image, defaults }

Future<void> showComicReaderSettings({
  required BuildContext context,
  required int bookId,
  required String bookTitle,
  required ValueNotifier<bool> autoScroll,
}) async {
  final translation = ReaderTranslationHost.controllerOf(context);
  var openTranslation = false;
  autoScroll.value = false;
  await showNodeLaneCatalogSheet<void>(
    context,
    ComicReaderSettingsSheet(
      onTranslation: translation == null
          ? null
          : () {
              openTranslation = true;
              Navigator.of(context, rootNavigator: true).pop();
            },
      bookId: bookId,
      bookTitle: bookTitle,
      autoScroll: autoScroll,
    ),
  );
  if (openTranslation && translation != null && context.mounted) {
    await showTranslationControls(context, translation);
  }
}

class ComicReaderSettingsSheet extends StatefulWidget {
  const ComicReaderSettingsSheet({
    super.key,
    required this.bookId,
    required this.bookTitle,
    this.onTranslation,
    required this.autoScroll,
  });
  final int bookId;
  final String bookTitle;
  final VoidCallback? onTranslation;
  final ValueNotifier<bool> autoScroll;
  @override
  State<ComicReaderSettingsSheet> createState() =>
      _ComicReaderSettingsSheetState();
}

class _ComicReaderSettingsSheetState extends State<ComicReaderSettingsSheet> {
  _ReaderSection section = _ReaderSection.book;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return NodeLaneCatalogSheet(
      title: switch (section) {
        _ReaderSection.book => l.comic_reading,
        _ReaderSection.image => l.comic_image_title,
        _ReaderSection.defaults => l.comic_defaults_title,
      },
      subtitle: section == _ReaderSection.defaults
          ? l.comic_defaults_hint
          : l.comic_book_scope,
      heightFactor: NodeLaneTokens.readerSheetFraction,
      onBack: section == _ReaderSection.book
          ? null
          : () => setState(() => section = _ReaderSection.book),
      child: SingleChildScrollView(
        key: ValueKey(section),
        padding: NodeLaneTokens.pagePadding,
        child: ValueListenableBuilder<bool>(
          valueListenable: widget.autoScroll,
          builder: (context, scrolling, _) => ComicReaderSettingsContent(
            bookId: section == _ReaderSection.defaults ? null : widget.bookId,
            imageOnly: section == _ReaderSection.image,
            bookTitle: widget.bookTitle,
            onTranslation: widget.onTranslation,
            onImage: () => setState(() => section = _ReaderSection.image),
            onDefaults: () => setState(() => section = _ReaderSection.defaults),
            scrolling: scrolling,
            onAutoScroll: (value) {
              widget.autoScroll.value = value;
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}

/// The same controls serve the in-reader panel and the application settings.
class ComicReaderSettingsContent extends ConsumerWidget {
  const ComicReaderSettingsContent({
    super.key,
    this.bookId,
    this.bookTitle = '',
    this.imageOnly = false,
    this.onImage,
    this.onTranslation,
    this.onDefaults,
    this.scrolling = false,
    this.onAutoScroll,
  });
  final int? bookId;
  final String bookTitle;
  final bool imageOnly;
  final VoidCallback? onImage, onDefaults, onTranslation;
  final bool scrolling;
  final ValueChanged<bool>? onAutoScroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(comicReaderPreferencesProvider);
    final l = context.l10n;
    final t = NodeLaneTokens.of(context);
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
    final rows = <Widget>[];
    if (bookId != null && !imageOnly) {
      rows.add(
        Text(
          bookTitle,
          style: t.readerLabel,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    if (!imageOnly) {
      rows.add(
        ComicSettingOptions<ComicReadingMode>(
          title: l.reading_mode,
          value: profile.mode,
          labels: {
            ComicReadingMode.paged: l.comic_paged,
            ComicReadingMode.scroll: l.comic_scroll,
          },
          onChanged: (mode) => bookId == null
              ? defaults((v) => v.copyWith(mode: mode))
              : book((v) => v.copyWith(mode: mode)),
        ),
      );
      if (profile.mode == ComicReadingMode.paged || bookId == null) {
        rows.add(
          ComicSettingOptions<ComicPageTurn>(
            title: l.comic_turn,
            value: profile.turn,
            labels: {
              ComicPageTurn.left: l.comic_left,
              ComicPageTurn.right: l.comic_right,
              ComicPageTurn.up: l.comic_up,
            },
            onChanged: (turn) => bookId == null
                ? defaults((v) => v.copyWith(turn: turn))
                : book((v) => v.copyWith(turn: turn)),
          ),
        );
        rows.add(
          ComicSettingOptions<ComicPageFit>(
            title: l.comic_fit,
            value: profile.fit,
            labels: {
              ComicPageFit.contain: l.comic_fit_contain,
              ComicPageFit.width: l.comic_fit_width,
              ComicPageFit.height: l.comic_fit_height,
            },
            onChanged: (fit) => bookId == null
                ? defaults((v) => v.copyWith(fit: fit))
                : book((v) => v.copyWith(fit: fit)),
          ),
        );
        if (profile.turn != ComicPageTurn.up || bookId == null) {
          rows.add(
            ComicSettingOptions<ComicPageLayout>(
              title: l.comic_layout,
              hint: l.comic_layout_hint,
              value: profile.layout,
              labels: {
                ComicPageLayout.automatic: l.comic_auto,
                ComicPageLayout.single: l.single_page,
                ComicPageLayout.double: l.double_page,
              },
              onChanged: (layout) => bookId == null
                  ? defaults((v) => v.copyWith(layout: layout))
                  : book((v) => v.copyWith(layout: layout)),
            ),
          );
        }
      } else {
        rows.add(
          ComicSettingOptions<ComicContentWidth>(
            title: l.comic_width,
            value: profile.width,
            labels: {
              ComicContentWidth.full: l.comic_full,
              ComicContentWidth.comfortable: l.comic_comfortable,
              ComicContentWidth.narrow: l.comic_narrow,
            },
            onChanged: (width) => book((v) => v.copyWith(width: width)),
          ),
        );
        rows.add(
          ComicSettingOptions<bool>(
            title: l.comic_gap,
            value: profile.gap,
            labels: {false: l.comic_no_gap, true: l.comic_small_gap},
            onChanged: (gap) => book((v) => v.copyWith(gap: gap)),
          ),
        );
        rows.add(
          NodeLaneGroupSurface(
            children: [
              NodeLaneSliderRow(
                title: l.comic_scroll_speed,
                value: data.scrollSpeed,
                min: 10,
                max: 100,
                divisions: 18,
                label: (v) => '${v.round()} px/s',
                onChanged: (speed) {
                  save((v) => v.copyWith(scrollSpeed: speed));
                },
              ),
              NodeLaneRow(
                title: scrolling ? l.comic_scroll_pause : l.comic_scroll_start,
                subtitle: l.comic_scroll_hint,
                onTap: () => onAutoScroll?.call(!scrolling),
              ),
            ],
          ),
        );
      }
      if (bookId != null) {
        rows.add(
          NodeLaneGroupSurface(
            children: [
              if (onTranslation != null)
                NodeLaneRow(
                  title: '漫画翻译',
                  subtitle: '自动翻译、目标语言与渠道',
                  icon: NodeLaneIcons.of(context).translate,
                  onTap: onTranslation,
                ),
              NodeLaneRow(
                title: l.comic_image_title,
                subtitle: l.comic_image_hint,
                onTap: onImage,
              ),
              NodeLaneRow(title: l.comic_defaults_title, onTap: onDefaults),
              NodeLaneRow(
                title: l.comic_book_reset,
                subtitle: l.comic_book_reset_hint,
                onTap: () => save((value) => value.resetBook(bookId!)),
              ),
            ],
          ),
        );
      }
    } else {
      rows.add(
        NodeLaneGroupSurface(
          child: NodeLaneSwitchRow(
            title: l.crop_borders,
            value: profile.crop,
            onChanged: (crop) => book((v) => v.copyWith(crop: crop)),
          ),
        ),
      );
      if (profile.mode == ComicReadingMode.paged) {
        if (!profile.doublePage(MediaQuery.sizeOf(context).width)) {
          rows.add(
            ComicSettingOptions<ComicWidePage>(
              title: l.comic_wide,
              hint: l.comic_wide_hint,
              value: profile.widePage,
              labels: {
                ComicWidePage.intact: l.comic_intact,
                ComicWidePage.split: l.comic_split,
                ComicWidePage.rotate: l.comic_rotate,
              },
              onChanged: (widePage) =>
                  book((v) => v.copyWith(widePage: widePage)),
            ),
          );
        }
        if (profile.doublePage(MediaQuery.sizeOf(context).width)) {
          rows.add(
            NodeLaneGroupSurface(
              child: NodeLaneSwitchRow(
                title: l.comic_cover,
                value: profile.singleCover,
                onChanged: (singleCover) =>
                    book((v) => v.copyWith(singleCover: singleCover)),
              ),
            ),
          );
        }
      }
      rows.add(
        NodeLaneGroupSurface(
          children: [
            NodeLaneSwitchRow(
              title: l.invert_colors,
              value: profile.invert,
              onChanged: (invert) => book((v) => v.copyWith(invert: invert)),
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
              onTap: () => book(
                (v) => v.copyWith(invert: false, brightness: 0, contrast: 1),
              ),
            ),
          ],
        ),
      );
    }
    if (bookId == null) {
      rows.add(Text(l.comic_habits_hint, style: t.readerSecondary));
      rows.add(
        ComicSettingOptions<ComicCanvas>(
          title: l.comic_canvas,
          value: data.habits.canvas,
          labels: {
            ComicCanvas.system: l.comic_system,
            ComicCanvas.black: l.comic_black,
            ComicCanvas.gray: l.comic_gray,
            ComicCanvas.paper: l.comic_paper,
          },
          onChanged: (canvas) => habits((v) => v.copyWith(canvas: canvas)),
        ),
      );
      rows.add(
        NodeLaneGroupSurface(
          children: [
            NodeLaneSwitchRow(
              title: l.show_page_number,
              value: data.habits.pageNumber,
              onChanged: (pageNumber) =>
                  habits((v) => v.copyWith(pageNumber: pageNumber)),
            ),
            NodeLaneSwitchRow(
              title: l.keep_screen_on,
              value: data.habits.keepAwake,
              onChanged: (keepAwake) =>
                  habits((v) => v.copyWith(keepAwake: keepAwake)),
            ),
            NodeLaneSwitchRow(
              title: l.comic_tap,
              subtitle: l.comic_tap_hint,
              value: data.habits.tapToTurn,
              onChanged: (tapToTurn) =>
                  habits((v) => v.copyWith(tapToTurn: tapToTurn)),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: NodeLaneTokens.space16),
            child: row,
          ),
      ],
    );
  }
}

class ComicSettingOptions<T> extends StatelessWidget {
  const ComicSettingOptions({
    super.key,
    required this.title,
    this.hint,
    required this.value,
    required this.labels,
    required this.onChanged,
  });
  final String title;
  final String? hint;
  final T value;
  final Map<T, String> labels;
  final ValueChanged<T> onChanged;
  @override
  Widget build(BuildContext context) {
    NodeLaneRevealScope.reveal(context, title);
    return Semantics(
      label: title,
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: NodeLaneTokens.of(context).readerLabel),
          const SizedBox(height: NodeLaneTokens.space8),
          NodeLaneSegments<T>(
            value: value,
            segments: [
              for (final entry in labels.entries)
                ButtonSegment(value: entry.key, label: Text(entry.value)),
            ],
            onChanged: onChanged,
          ),
          if (hint != null) ...[
            const SizedBox(height: NodeLaneTokens.space8),
            Text(hint!, style: NodeLaneTokens.of(context).readerSecondary),
          ],
        ],
      ),
    );
  }
}
