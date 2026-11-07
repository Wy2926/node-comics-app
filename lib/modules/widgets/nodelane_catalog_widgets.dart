import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_reader_surface.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/cached_network.dart';

class NodeLaneWebsiteIcon extends StatelessWidget {
  const NodeLaneWebsiteIcon({super.key, this.url, this.icon});
  final String? url;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final fallback = Icon(
      icon ?? NodeLaneIcons.of(context).web,
      color: t.ink,
      size: NodeLaneTokens.iconSize,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
      child: SizedBox.square(
        dimension: NodeLaneTokens.websiteIconSize,
        child: ColoredBox(
          color: t.soft,
          child: url == null || url!.isEmpty
              ? Center(child: fallback)
              : cachedNetworkImage(
                  imageUrl: url!,
                  width: NodeLaneTokens.websiteIconSize,
                  height: NodeLaneTokens.websiteIconSize,
                  fit: BoxFit.contain,
                  errorWidget: Center(child: fallback),
                  useCustomNetworkImage: false,
                ),
        ),
      ),
    );
  }
}

class NodeLaneCatalogHeading extends StatelessWidget {
  const NodeLaneCatalogHeading(
    this.title, {
    super.key,
    this.action,
    this.onAction,
  });
  final String title;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: NodeLaneTokens.space8,
        bottom: NodeLaneTokens.space8,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: NodeLaneTokens.minTapTarget,
        ),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  title,
                  style: t.readerLabel.copyWith(
                    color: t.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (action != null)
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  minimumSize: const Size(
                    NodeLaneTokens.minTapTarget,
                    NodeLaneTokens.minTapTarget,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: NodeLaneTokens.space4,
                  ),
                ),
                child: Text(
                  action!,
                  style: t.label.copyWith(
                    color: t.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Shared sheet shell: a single handle, title, close target and safe area.
class NodeLaneCatalogSheet extends StatefulWidget {
  const NodeLaneCatalogSheet({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.bottom,
    this.heightFactor = .68,
    this.onClose,
    this.canClose = true,
    this.fitContent = false,
    this.onBack,
    this.onHeightChanged,
  });
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? bottom;
  final double heightFactor;
  final VoidCallback? onClose;
  final bool canClose;

  /// Use a shrink-wrapped scroll view as [child] for content-sized choices.
  final bool fitContent;
  final VoidCallback? onBack;

  /// Lets an existing nested reader navigator resize without replacing routes.
  final ValueChanged<double>? onHeightChanged;

  @override
  State<NodeLaneCatalogSheet> createState() => _NodeLaneCatalogSheetState();
}

class _NodeLaneCatalogSheetState extends State<NodeLaneCatalogSheet> {
  final _surfaceKey = GlobalKey();
  bool _measurementQueued = false;
  double? _lastHeight;

  void _measure() {
    if (widget.onHeightChanged == null || _measurementQueued) return;
    _measurementQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measurementQueued = false;
      if (!mounted || ModalRoute.of(context)?.isCurrent == false) return;
      final box = _surfaceKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) return;
      final height = box.size.height;
      if (_lastHeight != null && (height - _lastHeight!).abs() < .5) return;
      _lastHeight = height;
      widget.onHeightChanged?.call(height);
    });
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      _measure();
      final keyboard = MediaQuery.viewInsetsOf(context).bottom;
      final safeBottom = MediaQuery.paddingOf(context).bottom;
      final available = math.max(
        0.0,
        constraints.maxHeight - keyboard - safeBottom,
      );
      final maxHeight = math.min(
        MediaQuery.sizeOf(context).height * widget.heightFactor,
        available,
      );
      final content = NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (_) {
          _measure();
          return false;
        },
        child: SizeChangedLayoutNotifier(
          child: NodeLaneReaderSurface(
            key: _surfaceKey,
            child: SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: widget.fitContent ? 0 : maxHeight,
                  maxHeight: maxHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NodeLaneReaderHeading(
                      title: widget.title,
                      showHandle:
                          widget.canClose &&
                          (ModalRoute.of(context) is! ModalBottomSheetRoute ||
                              (ModalRoute.of(
                                context,
                              ) as ModalBottomSheetRoute).enableDrag),
                      onBack: widget.onBack,
                      onClose: widget.canClose
                          ? widget.onClose ?? () => Navigator.pop(context)
                          : null,
                      closeLabel: MaterialLocalizations.of(context)
                          .closeButtonTooltip,
                    ),
                    if (widget.subtitle != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: Text(
                          widget.subtitle!,
                          style: NodeLaneTokens.of(context).readerSecondary,
                        ),
                      ),
                    Flexible(
                      fit: widget.fitContent ? FlexFit.loose : FlexFit.tight,
                      child: widget.child,
                    ),
                    if (widget.bottom != null)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: widget.bottom!,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      return Padding(
        padding: EdgeInsets.only(bottom: keyboard),
        child: widget.fitContent
            ? Align(
                alignment: Alignment.bottomCenter,
                heightFactor: 1,
                child: content,
              )
            : content,
      );
    },
  );
}

Future<T?> showNodeLaneCatalogSheet<T>(
  BuildContext context,
  Widget child, {
  bool dismissible = true,
}) => showModalBottomSheet<T>(
  context: context,
  useRootNavigator: true,
  useSafeArea: true,
  isScrollControlled: true,
  showDragHandle: false,
  isDismissible: dismissible,
  enableDrag: dismissible,
  backgroundColor: Colors.transparent,
  shape: NodeLaneTokens.readerSheetShape,
  builder: (_) => child,
);
