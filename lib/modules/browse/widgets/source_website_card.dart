import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/source_catalog_metadata.dart';
import 'package:mangayomi/modules/browse/widgets/source_catalog_labels.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/language.dart';

enum SourceCardAction { open, install, update, retry, loading, pin, unpin }

/// One directory card for official and third-party sources. Request lifecycle,
/// installation policy and navigation belong to the caller, not this widget.
class SourceWebsiteCard extends StatelessWidget {
  const SourceWebsiteCard({
    super.key,
    required this.source,
    required this.action,
    required this.onAction,
    required this.onOpen,
    required this.onDetails,
    required this.onLongPress,
    this.selected,
  });

  final Source source;
  final SourceCardAction action;
  final VoidCallback? onAction, onOpen;
  final VoidCallback? onDetails, onLongPress;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final metadata = source.catalogMetadata;
    final free = metadata.pricing == SourcePricing.free;
    final unknown = metadata.pricing == SourcePricing.unknown;
    final adult = source.isNsfw == true;
    final labels = metadata.classificationLabels;
    final scaler = MediaQuery.textScalerOf(context);
    final lineHeight = MediaQuery.maybeLineHeightScaleFactorOverrideOf(context);
    double textHeight(TextStyle style) =>
        (scaler.scale(style.fontSize!) * (lineHeight ?? style.height!))
            .ceilToDouble();
    final classificationHeight = math.max(
      NodeLaneTokens.sourceCardClassificationHeight,
      textHeight(t.sourceMetadata) + NodeLaneTokens.space16,
    );
    final cornerWidth = math.max(
      NodeLaneTokens.sourceAdultCornerWidth,
      scaler.scale(t.sourceFooter.fontSize!) * 3 + NodeLaneTokens.space8,
    );
    final cornerHeight = math.max(
      NodeLaneTokens.sourceAdultCornerHeight,
      textHeight(t.sourceFooter) + NodeLaneTokens.space8,
    );
    final band = free
        ? t.accentSoft
        : unknown
        ? t.surface
        : t.sourcePaidBand;
    final priceInk = free
        ? t.accent
        : unknown
        ? t.muted
        : t.ink;
    final priceIcon = switch (metadata.pricing) {
      SourcePricing.free => icons.sourceFree,
      SourcePricing.partial => icons.sourcePartlyPaid,
      SourcePricing.paid => icons.sourcePaid,
      SourcePricing.unknown => icons.sourceUnknown,
    };
    final language = source.lang?.toLowerCase() ?? '';

    return LayoutBuilder(
      builder: (context, constraints) {
        // Geometry depends on available width and font scale, never on the
        // source's fee/NSFW flag/action. Accessibility grows every card equally.
        final stackedFooter =
            constraints.maxWidth <
            scaler.scale(t.sourceFooter.fontSize!) * 7 +
                NodeLaneTokens.smallIconSize * 2 +
                NodeLaneTokens.space8 * 3 +
                NodeLaneTokens.space16 * 2;
        final footerRowHeight = math.max(
          NodeLaneTokens.sourceCardFooterHeight,
          textHeight(t.sourceFooter) + NodeLaneTokens.space16,
        );
        final visibleCount =
            scaler.scale(t.sourceMetadata.fontSize!) > t.sourceTitle.fontSize!
            ? 2
            : 3;
        final remaining = math.max(0, labels.length - visibleCount);
        final classification = labels.isEmpty
            ? '分类未标注'
            : labels.take(visibleCount).join(' / ');
        final pricing = Row(
          children: [
            ExcludeSemantics(
              child: Icon(
                priceIcon,
                size: NodeLaneTokens.smallIconSize,
                color: priceInk,
              ),
            ),
            const SizedBox(width: NodeLaneTokens.space8),
            Flexible(
              child: Text(
                sourcePricingLabel(metadata.pricing, source.itemType),
                maxLines: 1,
                style: t.sourceFooter.copyWith(color: priceInk),
              ),
            ),
          ],
        );
        final actionWidget = selected == null
            ? _SourceAction(action: action, onPressed: onAction)
            : NodeLaneIconButton(
                icon: selected! ? icons.selected : icons.unselected,
                tooltip: selected! ? '取消选择' : '选择来源',
                active: selected!,
                onPressed: onOpen,
                style: NodeLaneIconButtonStyle.plain,
              );
        final card = Material(
          color: free ? t.sourceFreeSurface : t.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NodeLaneTokens.groupRadius),
            side: BorderSide(
              color: selected == true
                  ? t.accent
                  : free
                  ? t.sourceFreeOutline
                  : t.line,
              width: NodeLaneTokens.glassStroke,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onOpen,
            onLongPress: onLongPress,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        NodeLaneTokens.space16,
                        NodeLaneTokens.sourceCardTopInset,
                        NodeLaneTokens.space16,
                        0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              NodeLaneWebsiteIcon(url: source.iconUrl),
                              const SizedBox(width: NodeLaneTokens.space12),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                    end: adult
                                        ? cornerWidth - NodeLaneTokens.space8
                                        : 0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        source.name ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: t.sourceTitle,
                                      ),
                                      const SizedBox(
                                        height: NodeLaneTokens.space4,
                                      ),
                                      Text(
                                        language == 'all'
                                            ? '多语言'
                                            : language.isEmpty
                                            ? '语言未标注'
                                            : completeLanguageName(language),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: t.sourceMetadata,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: classificationHeight,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    classification,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.sourceMetadata.copyWith(
                                      color: labels.isEmpty ? t.muted : t.ink,
                                    ),
                                  ),
                                ),
                                if (remaining > 0)
                                  TextButton(
                                    onPressed: onDetails,
                                    style: TextButton.styleFrom(
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      minimumSize: const Size.square(
                                        NodeLaneTokens.minTapTarget,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: NodeLaneTokens.space4,
                                      ),
                                    ),
                                    child: Semantics(
                                      label: '查看全部来源资料，另有 $remaining 个分类',
                                      child: ExcludeSemantics(
                                        child: Text(
                                          '+$remaining',
                                          style: t.sourceMetadata.copyWith(
                                            color: t.accent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (adult)
                      PositionedDirectional(
                        top: 0,
                        end: 0,
                        child: Semantics(
                          label: '含 18+ 内容',
                          child: ExcludeSemantics(
                            child: ClipPath(
                              clipper: _AdultCornerClipper(
                                Directionality.of(context),
                              ),
                              child: Container(
                                width: cornerWidth,
                                height: cornerHeight,
                                color: t.sourceAdultSurface,
                                alignment: AlignmentDirectional.centerEnd,
                                padding: const EdgeInsetsDirectional.only(
                                  end: NodeLaneTokens.space8,
                                ),
                                child: Text(
                                  '18+',
                                  style: t.sourceFooter.copyWith(
                                    color: t.sourceAdultInk,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Ink(
                  color: band,
                  child: Stack(
                    children: [
                      if (unknown)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: NodeLaneTokens.glassStroke,
                          child: CustomPaint(
                            painter: _UnknownPricingDivider(t.line),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: NodeLaneTokens.space16,
                        ),
                        child: stackedFooter
                            ? Column(
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: footerRowHeight,
                                    ),
                                    child: pricing,
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: footerRowHeight,
                                    ),
                                    child: Align(
                                      heightFactor: 1,
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: actionWidget,
                                    ),
                                  ),
                                ],
                              )
                            : ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: footerRowHeight,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(child: pricing),
                                    const SizedBox(
                                      width: NodeLaneTokens.space8,
                                    ),
                                    actionWidget,
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        return Semantics(selected: selected, child: card);
      },
    );
  }
}

class _SourceAction extends StatelessWidget {
  const _SourceAction({required this.action, required this.onPressed});
  final SourceCardAction action;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    if (action == SourceCardAction.loading) {
      return NodeLaneIconButton(
        icon: icons.download,
        tooltip: '正在加载网站',
        busy: true,
        onPressed: null,
        style: NodeLaneIconButtonStyle.plain,
      );
    }
    if (action == SourceCardAction.pin || action == SourceCardAction.unpin) {
      return NodeLaneIconButton(
        icon: action == SourceCardAction.unpin ? icons.pinSelected : icons.pin,
        tooltip: action == SourceCardAction.unpin ? '取消常用' : '固定到常用',
        active: action == SourceCardAction.unpin,
        onPressed: onPressed,
        style: NodeLaneIconButtonStyle.plain,
      );
    }
    final label = switch (action) {
      SourceCardAction.open => '进入',
      SourceCardAction.install => '安装',
      SourceCardAction.update => '更新',
      SourceCardAction.retry => '重试',
      _ => '',
    };
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size.square(NodeLaneTokens.minTapTarget),
        padding: const EdgeInsets.symmetric(horizontal: NodeLaneTokens.space4),
        foregroundColor: t.accent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (action == SourceCardAction.retry) ...[
            Icon(icons.refresh, size: NodeLaneTokens.smallIconSize),
            const SizedBox(width: NodeLaneTokens.space4),
          ],
          Text(label, style: t.sourceFooter.copyWith(color: t.accent)),
          if (action == SourceCardAction.open) ...[
            const SizedBox(width: NodeLaneTokens.space4),
            Icon(icons.forward, size: NodeLaneTokens.smallIconSize),
          ],
        ],
      ),
    );
  }
}

class _AdultCornerClipper extends CustomClipper<Path> {
  const _AdultCornerClipper(this.direction);
  final TextDirection direction;
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(NodeLaneTokens.sourceCornerCut, size.height)
      ..close();
    if (direction == TextDirection.ltr) return path;
    return path
        .transform(Matrix4.identity().scaledByDouble(-1, 1, 1, 1).storage)
        .shift(Offset(size.width, 0));
  }

  @override
  bool shouldReclip(_AdultCornerClipper oldClipper) =>
      oldClipper.direction != direction;
}

class _UnknownPricingDivider extends CustomPainter {
  const _UnknownPricingDivider(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = NodeLaneTokens.glassStroke;
    for (var x = 0.0; x < size.width; x += NodeLaneTokens.space8) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(math.min(x + NodeLaneTokens.space4, size.width), 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_UnknownPricingDivider oldDelegate) =>
      oldDelegate.color != color;
}

Future<void> showSourceWebsiteInfo(BuildContext context, Source source) {
  final metadata = source.catalogMetadata;
  return showNodeLaneCatalogSheet<void>(
    context,
    NodeLaneCatalogSheet(
      title: source.name ?? '',
      subtitle: '资料由来源目录提供，分类描述网站覆盖范围。',
      fitContent: true,
      heightFactor: .85,
      child: ListView(
        shrinkWrap: true,
        padding: NodeLaneTokens.pagePadding,
        children: [
          NodeLaneGroupSurface(
            children: [
              for (final entry in [
                ('地区', metadata.regionLabels),
                ('形式', metadata.formatLabels),
                ('创作', metadata.creationLabels),
              ])
                NodeLaneRow(
                  title: entry.$1,
                  subtitle: entry.$2.isEmpty ? '未标注' : entry.$2.join('、'),
                ),
              NodeLaneRow(
                title: '收费',
                subtitle: sourcePricingLabel(metadata.pricing, source.itemType),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
