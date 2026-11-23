import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/webview/browser_session_store.dart';
import 'package:mangayomi/modules/webview/mobile_browser_home.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_notice.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart' show createRoute;
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation for the chapter route before pages are ready.
class MobileReaderEntryState extends StatefulWidget {
  const MobileReaderEntryState({
    super.key,
    this.cover,
    this.bookTitle,
    this.chapterTitle,
    this.failureMessage,
    this.failureDescription,
    this.onRetry,
    this.resolveBrowserUrl,
    required this.onBack,
  });

  final ImageProvider? cover;
  final String? bookTitle, chapterTitle, failureMessage, failureDescription;
  final Future<void> Function()? onRetry;
  final Future<String?> Function()? resolveBrowserUrl;
  final VoidCallback onBack;

  @override
  State<MobileReaderEntryState> createState() => _MobileReaderEntryStateState();
}

class _MobileReaderEntryStateState extends State<MobileReaderEntryState> {
  bool _retrying = false;
  bool _openingBrowser = false;

  Future<void> _openBrowser() async {
    if (_openingBrowser || _retrying) return;
    setState(() => _openingBrowser = true);
    try {
      String? url;
      try {
        url = await widget.resolveBrowserUrl?.call();
      } catch (_) {
        // A source without a usable website URL can still open a fresh start page.
      }
      if (!mounted || ModalRoute.isCurrentOf(context) != true) return;
      final title = url == null ? '' : widget.chapterTitle ?? '';
      final String? tabId;
      try {
        tabId = await browserSessionStore.createTab(
          url: url ?? '',
          title: title,
        );
      } catch (_) {
        if (mounted && ModalRoute.isCurrentOf(context) == true) {
          showNodeLaneNotice(
            context.l10n.browser_save_failed,
            kind: NodeLaneNoticeKind.error,
          );
        }
        return;
      }
      if (!mounted || ModalRoute.isCurrentOf(context) != true) return;
      if (tabId == null) {
        showNodeLaneNotice(
          context.l10n.browser_tab_limit(BrowserSessionStore.maxTabs),
        );
      } else if (url != null) {
        // Select by ID: another tab for this chapter may have its own history and position.
        await context.push(
          '/mangawebview',
          extra: {'url': url, 'title': title, 'tabId': tabId},
        );
      } else {
        await Navigator.push(
          context,
          createRoute(page: const MobileBrowserHome()),
        );
      }
    } finally {
      if (mounted) setState(() => _openingBrowser = false);
    }
  }

  Future<void> _retry() async {
    if (_retrying || _openingBrowser || widget.onRetry == null) return;
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
              if (failed)
                NodeLaneIconButton(
                  tooltip: l10n.reader_open_browser,
                  icon: NodeLaneIcons.of(context).browser,
                  busy: _openingBrowser,
                  onPressed: _openBrowser,
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
                                      ? widget.failureDescription
                                      : null,
                                  kind: failed
                                      ? NodeLaneNoticeKind.info
                                      : NodeLaneNoticeKind.progress,
                                ),
                                if (failed && widget.onRetry != null) ...[
                                  const SizedBox(
                                    height: NodeLaneTokens.space16,
                                  ),
                                  FilledButton(
                                    onPressed: _openingBrowser ? null : _retry,
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
