import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Opt-in presentation for reader groups, including their existing sub-options.
/// Other settings pages keep their own appearance and all writes stay outside.
class NodeLaneReaderScope extends InheritedWidget {
  const NodeLaneReaderScope({super.key, required super.child});
  static bool activeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NodeLaneReaderScope>() != null;
  @override
  bool updateShouldNotify(NodeLaneReaderScope oldWidget) => false;
}

class NodeLaneReaderSurface extends StatelessWidget {
  const NodeLaneReaderSurface({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NodeLaneSheetSurface(
      grouped: true,
      child: Builder(
        builder: (context) {
          final base = Theme.of(context);
          final colors = NodeLaneTokens.of(context);
          return NodeLaneReaderScope(
            child: Theme(
              data: base.copyWith(
                cupertinoOverrideTheme:
                    (base.cupertinoOverrideTheme ?? const CupertinoThemeData())
                        .copyWith(
                          primaryColor: colors.accent,
                          applyThemeToAll: true,
                        ),
                iconTheme: IconThemeData(
                  color: colors.ink,
                  size: NodeLaneTokens.readerIconSize,
                ),
                sliderTheme: readerSliderTheme(context),
                listTileTheme: base.listTileTheme.copyWith(
                  minTileHeight: NodeLaneTokens.readerRowHeight,
                  horizontalTitleGap: NodeLaneTokens.space12,
                  iconColor: colors.ink,
                  titleTextStyle: colors.readerLabel,
                  subtitleTextStyle: colors.readerSecondary,
                ),
              ),
              child: DefaultTextStyle.merge(style: colors.body, child: child),
            ),
          );
        },
      ),
    );
  }
}

SliderThemeData readerSliderTheme(BuildContext context) {
  final colors = NodeLaneTokens.of(context);
  return SliderTheme.of(context).copyWith(
    trackHeight: NodeLaneTokens.readerSliderTrack,
    activeTrackColor: colors.accent,
    inactiveTrackColor: colors.line,
    thumbColor: colors.accent,
    overlayColor: colors.accent.withValues(alpha: .12),
    trackShape: const RoundedRectSliderTrackShape(),
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    showValueIndicator: ShowValueIndicator.never,
    tickMarkShape: SliderTickMarkShape.noTickMark,
  );
}

/// One drag handle, a fixed heading and a 44-point close target for all sheets.
class NodeLaneReaderHeading extends StatelessWidget {
  const NodeLaneReaderHeading({
    super.key,
    required this.title,
    required this.closeLabel,
    required this.onClose,
    this.actions = const [],
    this.onBack,
  });
  final String title, closeLabel;
  final VoidCallback? onClose;
  final VoidCallback? onBack;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.muted.withValues(alpha: .3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: onBack == null ? 20 : 8, right: 12),
            child: Row(
              children: [
                if (onBack != null) ...[
                  IconButton(
                    tooltip: MaterialLocalizations.of(context)
                        .backButtonTooltip,
                    onPressed: onBack,
                    style: IconButton.styleFrom(
                      minimumSize: const Size(44, 44),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: Icon(NodeLaneIcons.of(context).back, size: 24),
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: colors.readerTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                ...actions,
                IconButton(
                  tooltip: closeLabel,
                  onPressed: onClose,
                  constraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 44,
                  ),
                  padding: const EdgeInsets.all(6),
                  style: IconButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.soft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      NodeLaneIcons.of(context).close,
                      size: 18,
                      color: colors.muted,
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
}
