import 'package:mangayomi/providers/l10n_providers.dart';

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
    final labels = metadata.classificationLabels(context.l10n);
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
                sourcePricingLabel(
                  metadata.pricing,
                  source.itemType,
                  context.l10n,
                ),
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
                tooltip: selected!
                    ? context.l10n.source_deselect
                    : context.l10n.source_select,
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
                                            ? context.l10n.source_multilingual
                                            : language.isEmpty
                                            ? context
                                                  .l10n
                                                  .source_language_unknown
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
                            child: _SourceClassifications(
                              labels: labels,
                              onDetails: onDetails,
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
                          label: context.l10n.source_adult_content,
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

class _SourceClassifications extends StatelessWidget {
  const _SourceClassifications({required this.labels, required this.onDetails});

  final List<String> labels;
  final VoidCallback? onDetails;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    // Match Text's inherited font and accessibility overrides when measuring.
    final style = DefaultTextStyle.of(context).style
        .merge(t.sourceMetadata)
        .copyWith(
          color: labels.isEmpty ? t.muted : t.ink,
          fontWeight: MediaQuery.boldTextOf(context) ? FontWeight.bold : null,
          height: MediaQuery.maybeLineHeightScaleFactorOverrideOf(context),
          letterSpacing: MediaQuery.maybeLetterSpacingOverrideOf(context),
          wordSpacing: MediaQuery.maybeWordSpacingOverrideOf(context),
        );
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          locale: Localizations.maybeLocaleOf(context),
          maxLines: 1,
        );
        double widthOf(String text) {
          painter.text = TextSpan(text: text, style: style);
          painter.layout();
          return painter.width;
        }

        var visibleCount = labels.length;
        var counterWidth = 0.0;
        // Try the whole line first so a counter never hides a label needlessly.
        if (widthOf(labels.join(' / ')) > constraints.maxWidth) {
          do {
            visibleCount--;
            counterWidth = math.max(
              NodeLaneTokens.minTapTarget,
              widthOf('+${labels.length - visibleCount}') +
                  NodeLaneTokens.space8,
            );
          } while (visibleCount > 0 &&
              widthOf(labels.take(visibleCount).join(' / ')) +
                      NodeLaneTokens.space8 +
                      counterWidth >
                  constraints.maxWidth);
        }
        painter.dispose();
        final remaining = labels.length - visibleCount;
        return Row(
          children: [
            Expanded(
              child: Text(
                labels.isEmpty
                    ? context.l10n.source_classification_unknown
                    : labels.take(visibleCount).join(' / '),
                maxLines: 1,
                softWrap: false,
                style: style,
              ),
            ),
            if (remaining > 0) ...[
              if (visibleCount > 0)
                const SizedBox(width: NodeLaneTokens.space8),
              SizedBox(
                width: math.min(counterWidth, constraints.maxWidth),
                child: TextButton(
                  onPressed: onDetails,
                  style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: const Size.square(NodeLaneTokens.minTapTarget),
                    padding: const EdgeInsets.symmetric(
                      horizontal: NodeLaneTokens.space4,
                    ),
                  ),
                  child: Semantics(
                    label: context.l10n.source_more_classifications(remaining),
                    child: ExcludeSemantics(
                      child: Text(
                        '+$remaining',
                        maxLines: 1,
                        softWrap: false,
                        style: style.copyWith(color: t.accent),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
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
        tooltip: context.l10n.source_loading_website,
        busy: true,
        onPressed: null,
        style: NodeLaneIconButtonStyle.plain,
      );
    }
    if (action == SourceCardAction.pin || action == SourceCardAction.unpin) {
      return NodeLaneIconButton(
        icon: action == SourceCardAction.unpin ? icons.pinSelected : icons.pin,
        tooltip: action == SourceCardAction.unpin
            ? context.l10n.source_unpin
            : context.l10n.source_pin,
        active: action == SourceCardAction.unpin,
        onPressed: onPressed,
        style: NodeLaneIconButtonStyle.plain,
      );
    }
    final label = switch (action) {
      SourceCardAction.open => context.l10n.source_open,
      SourceCardAction.install => context.l10n.install,
      SourceCardAction.update => context.l10n.update,
      SourceCardAction.retry => context.l10n.retry,
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
      subtitle: context.l10n.source_metadata_hint,
      fitContent: true,
      heightFactor: .85,
      child: ListView(
        shrinkWrap: true,
        padding: NodeLaneTokens.pagePadding,
        children: [
          NodeLaneGroupSurface(
            children: [
              for (final entry in [
                (
                  context.l10n.source_region,
                  metadata.regionLabels(context.l10n),
                ),
                (
                  context.l10n.source_format,
                  metadata.formatLabels(context.l10n),
                ),
                (
                  context.l10n.source_creation,
                  metadata.creationLabels(context.l10n),
                ),
              ])
                NodeLaneRow(
                  title: entry.$1,
                  subtitle: entry.$2.isEmpty
                      ? context.l10n.source_unspecified
                      : entry.$2.join(context.l10n.list_separator),
                ),
              NodeLaneRow(
                title: context.l10n.source_pricing,
                subtitle: sourcePricingLabel(
                  metadata.pricing,
                  source.itemType,
                  context.l10n,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
