import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Shared result presentation for cross-source search and migration.
class SourceResultSection extends StatelessWidget {
  const SourceResultSection({
    super.key,
    required this.title,
    required this.metadata,
    this.onOpen,
    this.loading = false,
    this.status,
    required this.count,
    required this.itemBuilder,
  });

  final String title, metadata;
  final VoidCallback? onOpen;
  final bool loading;
  final Widget? status;
  final int count;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final heading = InkWell(
      onTap: onOpen,
      child: Wrap(
        spacing: NodeLaneTokens.space8,
        runSpacing: NodeLaneTokens.space4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(title, style: t.title),
          if (metadata.isNotEmpty) Text(metadata, style: t.caption),
        ],
      ),
    );
    final action = onOpen != null && !loading && count > 0
        ? TextButton.icon(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: onOpen,
            label: Text(context.l10n.view_all),
            icon: Icon(icons.forward, size: NodeLaneTokens.smallIconSize),
            iconAlignment: IconAlignment.end,
          )
        : null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NodeLaneTokens.gutter,
        0,
        NodeLaneTokens.gutter,
        NodeLaneTokens.space24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (action == null) return heading;
              final label = TextPainter(
                text: TextSpan(
                  text: context.l10n.view_all,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                textDirection: Directionality.of(context),
                textScaler: MediaQuery.textScalerOf(context),
              )..layout();
              final actionWidth =
                  label.width +
                  NodeLaneTokens.smallIconSize +
                  NodeLaneTokens.space16;
              label.dispose();
              // A translated action must leave enough room for the source name.
              if (actionWidth > constraints.maxWidth * .35) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    heading,
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: action,
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: heading),
                  action,
                ],
              );
            },
          ),
          const SizedBox(height: NodeLaneTokens.space8),
          if (loading)
            Row(
              children: [
                SizedBox.square(
                  dimension: NodeLaneTokens.smallIconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: t.accent,
                  ),
                ),
                const SizedBox(width: NodeLaneTokens.space12),
                Text(
                  context.l10n.search_searching_ellipsis,
                  style: t.readerSecondary,
                ),
              ],
            )
          else if (status != null)
            status!
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final width =
                    ((constraints.maxWidth -
                                NodeLaneTokens.space24 -
                                NodeLaneTokens.resultCoverPeek) /
                            2)
                        .clamp(
                          NodeLaneTokens.shelfCompactWidth,
                          NodeLaneTokens.resultCoverWidth,
                        );
                final height =
                    width / NodeLaneTokens.resultCoverAspectRatio +
                    NodeLaneTokens.space8 +
                    SourceResultCover.captionHeight(context);
                return SizedBox(
                  height: height,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: count,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: NodeLaneTokens.space12),
                    itemBuilder: (context, i) =>
                        SizedBox(width: width, child: itemBuilder(context, i)),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class SourceResultCover extends StatelessWidget {
  const SourceResultCover({
    super.key,
    required this.title,
    required this.cover,
    required this.inLibrary,
    required this.onOpen,
    this.onQuickAdd,
  });
  final String title;
  final Widget cover;
  final bool inLibrary;
  final VoidCallback onOpen;
  final VoidCallback? onQuickAdd;

  static double captionHeight(BuildContext context) {
    final style = NodeLaneTokens.of(context).bookTitle;
    return MediaQuery.textScalerOf(context).scale(style.fontSize!) *
        style.height! *
        NodeLaneTokens.resultTitleLines;
  }

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
          onTap: onOpen,
          onLongPress: onQuickAdd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    NodeLaneTokens.coverRadius,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ExcludeSemantics(
                        child: ColoredBox(color: colors.soft, child: cover),
                      ),
                      if (inLibrary)
                        PositionedDirectional(
                          top: NodeLaneTokens.space8,
                          start: NodeLaneTokens.space8,
                          child: NodeLaneCoverBadge(
                            context.l10n.in_library,
                            tone: NodeLaneBadgeTone.neutral,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: NodeLaneTokens.space8),
              ExcludeSemantics(
                child: SizedBox(
                  height: captionHeight(context),
                  child: Text(
                    title,
                    maxLines: NodeLaneTokens.resultTitleLines,
                    overflow: TextOverflow.ellipsis,
                    style: colors.bookTitle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
