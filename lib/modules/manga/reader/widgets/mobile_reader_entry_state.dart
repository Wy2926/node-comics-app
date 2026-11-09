import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation for the chapter route before pages are ready. Fetching, cache
/// invalidation and navigation stay with the existing reader controller.
class MobileReaderEntryState extends StatefulWidget {
  const MobileReaderEntryState({
    super.key,
    this.cover,
    this.bookTitle,
    this.chapterTitle,
    this.failureMessage,
    this.onRetry,
    this.onOpenWebView,
    required this.onBack,
  });

  final ImageProvider? cover;
  final String? bookTitle, chapterTitle, failureMessage;
  final Future<void> Function()? onRetry;
  final VoidCallback? onOpenWebView;
  final VoidCallback onBack;

  @override
  State<MobileReaderEntryState> createState() => _MobileReaderEntryStateState();
}

class _MobileReaderEntryStateState extends State<MobileReaderEntryState> {
  bool _retrying = false;

  Future<void> _retry() async {
    if (_retrying || widget.onRetry == null) return;
    setState(() => _retrying = true);
    try {
      await widget.onRetry!();
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) => NodeLaneSurface(
    child: Builder(
      builder: (context) {
        final t = NodeLaneTokens.of(context), l10n = context.l10n;
        final failed = widget.failureMessage != null && !_retrying;
        const placeholder = NodeLaneSkeleton(
          width: NodeLaneTokens.readerEntryCoverWidth,
          height: NodeLaneTokens.readerEntryCoverHeight,
          radius: NodeLaneTokens.coverRadius,
        );
        return Scaffold(
          appBar: nodeLaneAppBar(
            context,
            title: failed
                ? l10n.reader_open_chapter
                : l10n.reader_opening_chapter,
            onBack: widget.onBack,
            actions: [
              if (failed && widget.onOpenWebView != null)
                IconButton(
                  tooltip: l10n.open_in_browser,
                  onPressed: widget.onOpenWebView,
                  icon: const Icon(Icons.public),
                ),
            ],
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  NodeLaneTokens.gutter,
                  (constraints.maxHeight * .12).clamp(
                    NodeLaneTokens.space24,
                    NodeLaneTokens.readerEntryCoverWidth,
                  ),
                  NodeLaneTokens.gutter,
                  NodeLaneTokens.space24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: NodeLaneTokens.dialogMaxWidth,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              NodeLaneTokens.coverRadius,
                            ),
                            child: widget.cover == null
                                ? placeholder
                                : Image(
                                    image: widget.cover!,
                                    width: NodeLaneTokens.readerEntryCoverWidth,
                                    height:
                                        NodeLaneTokens.readerEntryCoverHeight,
                                    fit: BoxFit.cover,
                                    excludeFromSemantics: true,
                                    frameBuilder:
                                        (_, child, frame, synchronous) =>
                                            synchronous || frame != null
                                            ? child
                                            : placeholder,
                                    errorBuilder: (_, _, _) => placeholder,
                                  ),
                          ),
                        ),
                        const SizedBox(height: NodeLaneTokens.space20),
                        if (widget.bookTitle?.isNotEmpty ?? false)
                          Text(
                            widget.bookTitle!,
                            style: t.title,
                            textAlign: TextAlign.center,
                          )
                        else
                          const Center(
                            child: NodeLaneSkeleton(
                              height: NodeLaneTokens.space20,
                              width: 160,
                            ),
                          ),
                        const SizedBox(height: NodeLaneTokens.space8),
                        if (widget.chapterTitle?.isNotEmpty ?? false)
                          Text(
                            widget.chapterTitle!,
                            style: t.readerValue,
                            textAlign: TextAlign.center,
                          )
                        else
                          const Center(
                            child: NodeLaneSkeleton(
                              height: NodeLaneTokens.space12,
                              width: 128,
                            ),
                          ),
                        const SizedBox(height: NodeLaneTokens.space24),
                        NodeLaneGroupSurface(
                          child: Padding(
                            padding: NodeLaneTokens.groupPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                NodeLaneNotice(
                                  contained: false,
                                  message: failed
                                      ? widget.failureMessage!
                                      : l10n.reader_loading_pages,
                                  description: failed
                                      ? l10n.reader_loading_retry_hint
                                      : l10n.reader_loading_pages_hint,
                                  kind: failed
                                      ? NodeLaneNoticeKind.info
                                      : NodeLaneNoticeKind.progress,
                                ),
                                if (failed && widget.onRetry != null) ...[
                                  const SizedBox(
                                    height: NodeLaneTokens.space16,
                                  ),
                                  FilledButton(
                                    onPressed: _retry,
                                    child: Text(l10n.retry),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
