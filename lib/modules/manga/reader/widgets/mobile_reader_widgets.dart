import 'package:flutter/material.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';

/// Chrome is an overlay: opening it never changes the page viewport. Hidden
/// controls yield pointer events and semantics to the reader beneath them.
class MobileReaderPanel extends StatelessWidget {
  const MobileReaderPanel({
    super.key,
    required this.visible,
    required this.top,
    required this.child,
  });

  final bool visible, top;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: !visible,
        child: ExcludeSemantics(
          excluding: !visible,
          // Stack only clips layout overflow. A translated panel can otherwise
          // paint outside its bounds into a surrounding safe area when hidden.
          child: ClipRect(
            child: AnimatedSlide(
              offset: visible ? Offset.zero : Offset(0, top ? -1 : 1),
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              child: NodeLaneSurface(
                child: Material(
                  color: colors.surface,
                  borderRadius: top
                      ? null
                      : const BorderRadius.vertical(
                          top: Radius.circular(NodeLaneTokens.modalRadius),
                        ),
                  clipBehavior: Clip.antiAlias,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight:
                          MediaQuery.sizeOf(context).height * (top ? .32 : .48),
                    ),
                    child: SafeArea(
                      top: top,
                      bottom: !top,
                      child: NotificationListener<ScrollNotification>(
                        // Scrolling enlarged controls must not trigger the page's
                        // scroll-to-hide handler.
                        onNotification: (_) => true,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: top ? 4 : 12,
                            vertical: top ? 4 : 8,
                          ),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileReaderHeading extends StatelessWidget {
  const MobileReaderHeading({
    super.key,
    required this.title,
    required this.chapter,
    required this.onBack,
    required this.menu,
  });

  final String title, chapter;
  final VoidCallback onBack;
  final Widget menu;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Row(
      children: [
        IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: onBack,
          icon: Icon(NodeLaneIcons.of(context).back, color: colors.ink),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: colors.ink,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                chapter,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: colors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        menu,
      ],
    );
  }
}

class MobileReaderProgress extends StatelessWidget {
  const MobileReaderProgress({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.label,
    required this.reverse,
    required this.previousLabel,
    required this.nextLabel,
    required this.onChanged,
    required this.onChangeEnd,
    this.onPrevious,
    this.onNext,
  });

  final int currentIndex, totalPages;
  final String label, previousLabel, nextLabel;
  final bool reverse;
  final ValueChanged<int> onChanged, onChangeEnd;
  final VoidCallback? onPrevious, onNext;

  @override
  Widget build(BuildContext context) {
    final maximum = (totalPages - 1).clamp(0, double.maxFinite).toDouble();
    final colors = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    return SliderTheme(
      data: readerSliderTheme(context),
      child: Column(
        children: [
          Text(
            '$label / $totalPages',
            textDirection: TextDirection.ltr,
            style: colors.secondary.copyWith(fontWeight: FontWeight.w500),
          ),
          Directionality(
            textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
            child: Row(
              children: [
                IconButton(
                  tooltip: previousLabel,
                  onPressed: onPrevious,
                  icon: Icon(
                    reverse ? icons.nextChapter : icons.previousChapter,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: maximum,
                    value: currentIndex.toDouble().clamp(0, maximum),
                    divisions: totalPages > 1 ? totalPages - 1 : null,
                    label: label,
                    onChanged: totalPages > 1
                        ? (value) => onChanged(value.toInt())
                        : null,
                    onChangeEnd: totalPages > 1
                        ? (value) => onChangeEnd(value.toInt())
                        : null,
                  ),
                ),
                IconButton(
                  tooltip: nextLabel,
                  onPressed: onNext,
                  icon: Icon(
                    reverse ? icons.previousChapter : icons.nextChapter,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Settings pages already own their scroll views; the sheet only supplies
/// bounded space, tabs, and a close target.
class MobileReaderSettingsTabs extends StatelessWidget {
  const MobileReaderSettingsTabs({
    super.key,
    required this.labels,
    this.title = 'Reader settings',
    required this.closeLabel,
    required this.onClose,
    required this.children,
  });
  final List<String> labels;
  final String title, closeLabel;
  final VoidCallback onClose;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: labels.length,
    child: Column(
      children: [
        NodeLaneReaderHeading(
          title: title,
          closeLabel: closeLabel,
          onClose: onClose,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: NodeLaneTabSegments(
            labels: labels,
            labelStyle: NodeLaneTokens.of(context).readerLabel,
          ),
        ),
        Expanded(child: TabBarView(children: children)),
      ],
    ),
  );
}
