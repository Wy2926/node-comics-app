import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'reader_settings_labels.dart';

const _pickerRoute = 'reader-setting-choice';

/// Keeps selection routes inside the existing reader sheet. The settings page
/// remains mounted, including its tab, scroll position and paused auto-scroll.
class MobileReaderPickerHost extends StatefulWidget {
  const MobileReaderPickerHost({
    super.key,
    required this.bookTitle,
    required this.onClose,
    required this.child,
  });
  final String bookTitle;
  final VoidCallback onClose;
  final Widget child;

  @override
  State<MobileReaderPickerHost> createState() => _MobileReaderPickerHostState();
}

class _MobileReaderPickerHostState extends State<MobileReaderPickerHost> {
  final _navigator = GlobalKey<NavigatorState>();
  late final _observer = _PickerObserver(_topChanged);
  double? _pickerFraction;

  void _topChanged(double? fraction) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _pickerFraction != fraction) {
        setState(() => _pickerFraction = fraction);
      }
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 180),
    curve: Curves.easeOut,
    height:
        MediaQuery.sizeOf(context).height *
        (_pickerFraction ?? NodeLaneTokens.readerSheetFraction),
    child: SafeArea(
      top: false,
      child: _ReaderPickerScope(
        bookTitle: widget.bookTitle,
        onClose: widget.onClose,
        child: NavigatorPopHandler<Object?>(
          onPopWithResult: (result) => _navigator.currentState?.pop(result),
          child: Navigator(
            key: _navigator,
            observers: [_observer],
            pages: [
              MaterialPage<void>(
                key: const ValueKey('reader-settings'),
                child: ColoredBox(
                  color: NodeLaneTokens.of(context).canvas,
                  child: widget.child,
                ),
              ),
            ],
            onDidRemovePage: (_) {},
          ),
        ),
      ),
    ),
  );
}

class _PickerObserver extends NavigatorObserver {
  _PickerObserver(this.onChanged);
  final ValueChanged<double?> onChanged;

  @override
  void didChangeTop(
    Route<dynamic> topRoute,
    Route<dynamic>? previousTopRoute,
  ) => onChanged(
    topRoute.settings.name == _pickerRoute
        ? topRoute.settings.arguments as double
        : null,
  );
}

class _ReaderPickerScope extends InheritedWidget {
  const _ReaderPickerScope({
    required this.bookTitle,
    required this.onClose,
    required super.child,
  });
  final String bookTitle;
  final VoidCallback onClose;

  static _ReaderPickerScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ReaderPickerScope>();

  @override
  bool updateShouldNotify(_ReaderPickerScope oldWidget) =>
      oldWidget.bookTitle != bookTitle || oldWidget.onClose != onClose;
}

/// Returns an existing option; it never writes a preference or closes the reader.
/// Outside a reader sheet, the same view opens over the global settings page.
Future<MobileSettingOption<T>?> showMobileReaderPicker<T>(
  BuildContext context, {
  required String title,
  required T current,
  required List<MobileSettingOption<T>> options,
  required String description,
}) {
  final host = _ReaderPickerScope.maybeOf(context);
  final fraction = options.firstOrNull?.value is ReaderMode
      ? NodeLaneTokens.readerModePickerFraction
      : NodeLaneTokens.readerPickerFraction;
  final picker = MobileReaderPicker<T>(
    title: title,
    current: current,
    options: options,
    description: description,
    bookTitle: host?.bookTitle,
    onCloseSettings: host?.onClose,
  );
  if (host != null) {
    return Navigator.of(context).push<MobileSettingOption<T>>(
      MaterialPageRoute(
        settings: RouteSettings(name: _pickerRoute, arguments: fraction),
        builder: (_) => picker,
      ),
    );
  }
  return showModalBottomSheet<MobileSettingOption<T>>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    showDragHandle: false,
    shape: NodeLaneTokens.readerSheetShape,
    builder: (context) => NodeLaneReaderSurface(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * fraction,
        child: SafeArea(top: false, child: picker),
      ),
    ),
  );
}

MobileSettingOption<T> readerSettingOption<T>(
  BuildContext context,
  T value,
  String label,
) {
  final icons = NodeLaneIcons.of(context);
  final l10n = context.l10n;
  return MobileSettingOption(
    value,
    label,
    leading: switch (value) {
      ReaderMode mode => Icon(switch (mode) {
        ReaderMode.vertical => icons.manga,
        ReaderMode.ltr => icons.readingRight,
        ReaderMode.rtl => icons.readingLeft,
        ReaderMode.verticalContinuous => icons.continuousVertical,
        ReaderMode.webtoon => icons.pageLayout,
        ReaderMode.horizontalContinuous => icons.manga,
        ReaderMode.horizontalContinuousRTL => icons.horizontalPages,
      }),
      ScaleType type => ReaderScaleIllustration(type: type),
      BackgroundColor color => ReaderBackgroundSwatch(value: color),
      _ => null,
    },
    subtitle: switch (value) {
      ScaleType.fitScreen => l10n.reader_scale_fit_screen_hint,
      ScaleType.stretch => l10n.reader_scale_stretch_hint,
      ScaleType.fitWidth => l10n.reader_scale_fit_width_hint,
      ScaleType.fitHeight => l10n.reader_scale_fit_height_hint,
      _ => null,
    },
  );
}

class MobileReaderPicker<T> extends StatefulWidget {
  const MobileReaderPicker({
    super.key,
    required this.title,
    required this.current,
    required this.options,
    required this.description,
    this.bookTitle,
    this.onCloseSettings,
  });
  final String title, description;
  final String? bookTitle;
  final T current;
  final List<MobileSettingOption<T>> options;
  final VoidCallback? onCloseSettings;

  @override
  State<MobileReaderPicker<T>> createState() => _MobileReaderPickerState<T>();
}

class _MobileReaderPickerState<T> extends State<MobileReaderPicker<T>> {
  final _scroll = ScrollController();
  final _selected = GlobalKey();
  Animation<double>? _entrance;
  bool _leaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final entrance = ModalRoute.of(context)?.animation;
    if (_entrance != entrance) {
      _entrance?.removeStatusListener(_entranceChanged);
      _entrance = entrance;
      _entrance?.addStatusListener(_entranceChanged);
    }
    if (entrance == null || entrance.status == AnimationStatus.completed) {
      _revealSelection();
    }
  }

  void _entranceChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) _revealSelection();
  }

  void _revealSelection() {
    // Wait for both the route and the shorter sheet-height transition. An
    // initial-layout scroll can leave the final row below the resized viewport.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selected = _selected.currentContext;
      if (mounted && !_leaving && selected != null) {
        Scrollable.ensureVisible(
          selected,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
      }
    });
  }

  @override
  void dispose() {
    _entrance?.removeStatusListener(_entranceChanged);
    _scroll.dispose();
    super.dispose();
  }

  void _finish({MobileSettingOption<T>? option, bool closeSettings = false}) {
    if (_leaving || !mounted || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    _leaving = true;
    Navigator.of(context).pop(option);
    if (closeSettings) widget.onCloseSettings?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final l10n = context.l10n;
    return ColoredBox(
      color: colors.canvas,
      child: Column(
        children: [
          NodeLaneReaderHeading(
            title: widget.title,
            closeLabel: l10n.close,
            onBack: () => _finish(),
            onClose: () => _finish(closeSettings: true),
          ),
          Expanded(
            child: CustomScrollView(
              controller: _scroll,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.bookTitle?.isNotEmpty == true) ...[
                          Text(
                            widget.bookTitle!,
                            style: colors.readerLabel.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(widget.description, style: colors.readerSecondary),
                        const SizedBox(height: 12),
                        NodeLaneGroupSurface(
                          outlined: true,
                          child: Column(
                            children: [
                              for (
                                var i = 0;
                                i < widget.options.length;
                                i++
                              ) ...[
                                if (i > 0)
                                  Divider(
                                    height: 1,
                                    indent: 16,
                                    color: colors.line,
                                  ),
                                _row(context, widget.options[i]),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                    child: Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Text(
                        l10n.reader_picker_apply_hint,
                        style: colors.readerSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, MobileSettingOption<T> option) {
    final colors = NodeLaneTokens.of(context);
    final selected = option.value == widget.current;
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: ListTile(
        key: selected ? _selected : null,
        minTileHeight: switch (option.value) {
          ScaleType _ => NodeLaneTokens.readerPickerPreviewRowHeight,
          BackgroundColor _ => NodeLaneTokens.readerPickerColorRowHeight,
          _ => NodeLaneTokens.readerPickerRowHeight,
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        minLeadingWidth: NodeLaneTokens.readerPickerLeadingWidth,
        horizontalTitleGap: 12,
        selected: selected,
        selectedColor: colors.ink,
        tileColor: colors.surface,
        selectedTileColor: colors.accentSoft,
        leading: option.leading == null
            ? null
            : ExcludeSemantics(
                child: SizedBox(
                  width: NodeLaneTokens.readerPickerLeadingWidth,
                  child: Center(
                    child: IconTheme(
                      data: IconThemeData(
                        color: colors.ink,
                        size: NodeLaneTokens.readerPickerIconSize,
                      ),
                      child: option.leading!,
                    ),
                  ),
                ),
              ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(option.label, style: colors.readerLabel),
            if (option.subtitle != null) ...[
              const SizedBox(height: NodeLaneTokens.space4),
              Text(option.subtitle!, style: colors.readerSecondary),
            ],
          ],
        ),
        trailing: selected
            ? Icon(
                NodeLaneIcons.of(context).check,
                color: colors.accent,
                size: 24,
              )
            : const SizedBox(width: 24),
        onTap: () => _finish(option: option),
      ),
    );
  }
}

class ReaderBackgroundSwatch extends StatelessWidget {
  const ReaderBackgroundSwatch({
    super.key,
    required this.value,
    this.size = NodeLaneTokens.readerPickerSwatchSize,
  });
  final BackgroundColor value;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getBackgroundColor(value),
        border: Border.all(color: colors.muted.withValues(alpha: .5)),
        gradient: value == BackgroundColor.automatic
            ? const LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white,
                  Colors.black,
                  Colors.black,
                ],
                stops: [0, .5, .5, 1],
              )
            : null,
      ),
    );
  }
}

/// A small vector diagram only; no image decoding or live reader preview.
class ReaderScaleIllustration extends StatelessWidget {
  const ReaderScaleIllustration({super.key, required this.type});
  final ScaleType type;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: NodeLaneTokens.readerPickerPreviewSize.width,
    height: NodeLaneTokens.readerPickerPreviewSize.height,
    child: CustomPaint(
      painter: _ScaleIllustrationPainter(type, NodeLaneTokens.of(context).ink),
    ),
  );
}

class _ScaleIllustrationPainter extends CustomPainter {
  const _ScaleIllustrationPainter(this.type, this.color);
  final ScaleType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final rect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    canvas.drawRect(rect, paint);
    void arrow(Offset start, Offset end) {
      canvas.drawLine(start, end, paint);
      final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);
      for (final turn in [-math.pi / 4, math.pi / 4]) {
        canvas.drawLine(
          end,
          end - Offset(math.cos(angle + turn), math.sin(angle + turn)) * 4,
          paint,
        );
      }
    }

    switch (type) {
      case ScaleType.fitScreen:
        for (final dx in [-1, 1]) {
          for (final dy in [-1, 1]) {
            final end = rect.center + Offset(dx * 13, dy * 16);
            arrow(end - Offset(dx * 5, dy * 5), end);
          }
        }
      case ScaleType.fitHeight:
        arrow(rect.center, Offset(rect.center.dx, 7));
        arrow(rect.center, Offset(rect.center.dx, size.height - 7));
      default:
        arrow(rect.center, Offset(7, rect.center.dy));
        arrow(rect.center, Offset(size.width - 7, rect.center.dy));
    }
  }

  @override
  bool shouldRepaint(_ScaleIllustrationPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.color != color;
}
