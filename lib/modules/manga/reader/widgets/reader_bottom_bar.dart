import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/manga/reader/reader_translation.dart';
import 'package:mangayomi/modules/manga/reader/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/manga/reader/widgets/mobile_reader_widgets.dart';

class ReaderBottomBar extends ConsumerWidget {
  const ReaderBottomBar({
    super.key,
    required this.chapter,
    required this.isVisible,
    required this.hasPreviousChapter,
    required this.hasNextChapter,
    this.onPreviousChapter,
    this.onNextChapter,
    this.onChaptersClosed,
    this.onChaptersOpened,
    required this.onSliderChanged,
    required this.onSliderChangeEnd,
    required this.onSettingsPressed,
    required this.currentPageListenable,
    required this.isReverseHorizontal,
    required this.totalPages,
    required this.currentIndexLabel,
    required this.backgroundColor,
  });
  final Chapter chapter;
  final bool isVisible, hasPreviousChapter, hasNextChapter, isReverseHorizontal;
  final VoidCallback? onPreviousChapter,
      onNextChapter,
      onChaptersClosed,
      onChaptersOpened;
  final void Function(int, WidgetRef) onSliderChanged;
  final ValueChanged<int> onSliderChangeEnd;
  final ValueChanged<BuildContext> onSettingsPressed;
  final ValueListenable<int> currentPageListenable;
  final int totalPages;
  final String Function(int) currentIndexLabel;
  final Color Function(BuildContext) backgroundColor;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MobileReaderPanel(
      visible: isVisible,
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: currentPageListenable,
            builder: (context, index, _) => MobileReaderProgress(
              currentIndex: index,
              totalPages: totalPages,
              label: currentIndexLabel(index),
              reverse: isReverseHorizontal,
              previousLabel: context.l10n.previous(context.l10n.chapter),
              nextLabel: context.l10n.next_chapter,
              onPrevious: hasPreviousChapter ? onPreviousChapter : null,
              onNext: hasNextChapter ? onNextChapter : null,
              onChanged: (value) => onSliderChanged(value, ref),
              onChangeEnd: onSliderChangeEnd,
            ),
          ),
          Divider(height: 1, color: NodeLaneTokens.of(context).line),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: btnToShowChapterListDialog(
                  context,
                  context.l10n.chapters,
                  chapter,
                  labeled: true,
                  onChanged: (closed) {
                    if (closed) {
                      onChaptersClosed?.call();
                    } else {
                      onChaptersOpened?.call();
                    }
                  },
                ),
              ),
              Expanded(
                child: ReaderTranslationHost.button(context, labeled: true),
              ),
              Expanded(
                child: NodeLaneToolbarAction(
                  label: context.l10n.comic_reading,
                  icon: NodeLaneIcons.of(context).adjustments,
                  onPressed: () => onSettingsPressed(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
