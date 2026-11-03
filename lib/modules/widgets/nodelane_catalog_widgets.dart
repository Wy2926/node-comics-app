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
      color: t.accent,
      size: 24,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
      child: ColoredBox(
        color: t.soft,
        child: url == null || url!.isEmpty
            ? fallback
            : cachedNetworkImage(
                imageUrl: url!,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorWidget: fallback,
                useCustomNetworkImage: false,
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
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: t.readerLabel.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                minimumSize: const Size(44, 44),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              child: Text(
                action!,
                style: t.readerSecondary.copyWith(
                  color: t.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Shared sheet shell: a single handle, title, close target and safe area.
class NodeLaneCatalogSheet extends StatelessWidget {
  const NodeLaneCatalogSheet({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.bottom,
    this.heightFactor = .68,
    this.onClose,
  });
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? bottom;
  final double heightFactor;
  final VoidCallback? onClose;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final keyboard = MediaQuery.viewInsetsOf(context).bottom;
      final safeBottom = MediaQuery.paddingOf(context).bottom;
      final available = math.max(
        0.0,
        constraints.maxHeight - keyboard - safeBottom,
      );
      return Padding(
        padding: EdgeInsets.only(bottom: keyboard),
        child: NodeLaneReaderSurface(
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: math.min(
                MediaQuery.sizeOf(context).height * heightFactor,
                available,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NodeLaneReaderHeading(
                    title: title,
                    onClose: onClose ?? () => Navigator.pop(context),
                    closeLabel: MaterialLocalizations.of(context)
                        .closeButtonTooltip,
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Text(
                        subtitle!,
                        style: NodeLaneTokens.of(context).readerSecondary,
                      ),
                    ),
                  Expanded(child: child),
                  if (bottom != null)
                    Padding(padding: const EdgeInsets.all(20), child: bottom!),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<T?> showNodeLaneCatalogSheet<T>(BuildContext context, Widget child) =>
    showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      shape: NodeLaneTokens.readerSheetShape,
      builder: (_) => child,
    );
