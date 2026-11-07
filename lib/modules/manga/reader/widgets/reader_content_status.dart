import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_interactive_region.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// A quiet, full-width status inside the reading flow. The surrounding image
/// retains its reserved dimensions; the status never hides neighboring pages.
class ReaderContentStatus extends StatelessWidget {
  const ReaderContentStatus({
    super.key,
    required this.message,
    this.description,
    this.loading = false,
    this.progress,
    this.onRetry,
  });

  final String message;
  final String? description;
  final bool loading;
  final double? progress;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final validProgress = progress != null && progress!.isFinite
        ? progress!.clamp(0.0, 1.0)
        : null;
    final indicator = loading
        ? SizedBox.square(
            dimension: NodeLaneTokens.space16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: t.accent,
              backgroundColor: t.line,
              value: MediaQuery.disableAnimationsOf(context)
                  ? validProgress ?? .25
                  : validProgress,
            ),
          )
        : Icon(
            NodeLaneIcons.of(context).info,
            size: NodeLaneTokens.smallIconSize,
            color: t.muted,
          );

    return Semantics(
      container: true,
      liveRegion: !loading,
      child: ColoredBox(
        color: t.canvas,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NodeLaneTokens.gutter,
            vertical: NodeLaneTokens.space12,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stackAction =
                  constraints.maxWidth < 320 ||
                  MediaQuery.textScalerOf(context).scale(16) > 21;
              final retry = onRetry == null || loading
                  ? null
                  : ReaderInteractiveRegion(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: t.accent,
                          minimumSize: const Size(
                            NodeLaneTokens.minTapTarget,
                            NodeLaneTokens.minTapTarget,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: NodeLaneTokens.space8,
                          ),
                          textStyle: t.body,
                        ),
                        onPressed: onRetry,
                        child: Text(context.l10n.retry),
                      ),
                    );
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: NodeLaneTokens.minTapTarget,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    indicator,
                    const SizedBox(width: NodeLaneTokens.space12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message,
                            style: loading ? t.readerValue : t.body,
                          ),
                          if (description != null) ...[
                            const SizedBox(height: NodeLaneTokens.space4),
                            Text(description!, style: t.readerSecondary),
                          ],
                          if (stackAction && retry != null) retry,
                        ],
                      ),
                    ),
                    if (!stackAction && retry != null) ...[
                      const SizedBox(width: NodeLaneTokens.space8),
                      retry,
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Only pending/failed/terminal boundaries occupy a list item. A successful
/// boundary is replaced by the next chapter's first real image.
class ReaderChapterBoundary extends StatelessWidget {
  const ReaderChapterBoundary({
    super.key,
    required this.data,
    this.paged = false,
    this.horizontal = false,
  });

  final UChapDataPreload data;
  final bool paged, horizontal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = data.nextChapterState;
    Widget body = ReaderContentStatus(
      message: switch (state) {
        NextChapterState.loading => l10n.reader_loading_next,
        NextChapterState.failed => l10n.reader_next_failed,
        NextChapterState.empty => l10n.reader_no_pages,
        null => l10n.you_have_finished_reading,
      },
      description: state == NextChapterState.failed
          ? l10n.reader_loading_retry_hint
          : null,
      loading: state == NextChapterState.loading,
      onRetry: data.onRetryChapter,
    );
    if (horizontal) {
      body = SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Center(child: body),
      );
    }
    if (paged) {
      body = Center(child: SingleChildScrollView(child: body));
    } else if (!horizontal) {
      // Let the final status scroll clear of the floating page count and
      // auto-scroll control, without leaving a blank page between chapters.
      final media = MediaQuery.of(context);
      body = Padding(
        padding: EdgeInsets.only(
          bottom:
              math.max(
                media.viewPadding.bottom,
                media.systemGestureInsets.bottom,
              ) +
              NodeLaneTokens.minTapTarget +
              NodeLaneTokens.space8,
        ),
        child: body,
      );
    }
    return body;
  }
}

/// A 44-point caption attached to the next image, never an extra reading page.
class ReaderChapterHeading extends StatelessWidget {
  const ReaderChapterHeading({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: NodeLaneTokens.minTapTarget),
      decoration: BoxDecoration(
        color: t.canvas,
        border: Border(top: BorderSide(color: t.line)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: NodeLaneTokens.gutter,
        vertical: NodeLaneTokens.space12,
      ),
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: t.readerSecondary,
      ),
    );
  }
}
