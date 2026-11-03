import 'package:flutter/material.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Presentation only. The existing queue screen owns ordering and processing.
class MobileDownloadQueue extends StatefulWidget {
  const MobileDownloadQueue({
    super.key,
    required this.entries,
    required this.isStarting,
    required this.onStart,
    required this.onReorder,
    required this.onSettings,
    required this.onCancel,
    required this.onCancelSeries,
  });

  final List<Download> entries;
  final bool isStarting;
  final VoidCallback onStart, onSettings;
  final void Function(int, int) onReorder;
  final ValueChanged<Download> onCancel, onCancelSeries;

  @override
  State<MobileDownloadQueue> createState() => _MobileDownloadQueueState();
}

enum _DownloadAction { cancelChapter, cancelSeries }

class _MobileDownloadQueueState extends State<MobileDownloadQueue> {
  bool _actionsOpen = false;

  Future<void> _showActions(Download entry) async {
    if (_actionsOpen || widget.isStarting) return;
    setState(() => _actionsOpen = true);
    final l10n = context.l10n;
    final icons = NodeLaneIcons.of(context);
    _DownloadAction? action;
    try {
      action = await showNodeLaneCatalogSheet<_DownloadAction>(
        context,
        Builder(
          builder: (context) => NodeLaneCatalogSheet(
            title: l10n.download_queue_actions,
            subtitle: [
              entry.chapter.value?.manga.value?.name,
              entry.chapter.value?.name,
            ].whereType<String>().where((text) => text.isNotEmpty).join(' · '),
            fitContent: true,
            heightFactor: .9,
            child: SingleChildScrollView(
              padding: NodeLaneTokens.pagePadding,
              child: NodeLaneGroupSurface(
                children: [
                  NodeLaneRow(
                    title: l10n.download_queue_cancel_chapter,
                    icon: icons.delete,
                    destructive: true,
                    onTap: () =>
                        Navigator.pop(context, _DownloadAction.cancelChapter),
                  ),
                  NodeLaneRow(
                    title: l10n.download_queue_cancel_series,
                    icon: icons.delete,
                    destructive: true,
                    onTap: () =>
                        Navigator.pop(context, _DownloadAction.cancelSeries),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _actionsOpen = false);
    }
    if (!mounted || action == null || widget.isStarting) return;
    // Progress can remove or replace this entry while its sheet is open.
    // Dispatch through the latest callbacks and pending list, not the snapshot.
    final current = widget.entries
        .where((candidate) => candidate.id == entry.id)
        .firstOrNull;
    if (current == null) return;
    switch (action) {
      case _DownloadAction.cancelChapter:
        widget.onCancel(current);
      case _DownloadAction.cancelSeries:
        widget.onCancelSeries(current);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    final retry = widget.entries.any((entry) => (entry.failed ?? 0) > 0);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(
          context,
          title: l10n.download_queue,
          actions: [
            NodeLaneIconButton(
              icon: icons.settings,
              tooltip: l10n.downloads,
              onPressed: widget.onSettings,
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          bottom: widget.entries.isEmpty,
          child: widget.entries.isEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        minWidth: constraints.maxWidth,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(NodeLaneTokens.gutter),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icons.downloadQueue,
                              size: NodeLaneTokens.emptyStateIconSize,
                              color: t.muted,
                            ),
                            const SizedBox(height: NodeLaneTokens.space16),
                            Text(
                              l10n.download_queue_empty,
                              textAlign: TextAlign.center,
                              style: t.title,
                            ),
                            const SizedBox(height: NodeLaneTokens.space8),
                            Text(
                              l10n.download_queue_empty_hint,
                              textAlign: TextAlign.center,
                              style: t.readerSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : ReorderableListView.builder(
                  key: const PageStorageKey('mobile-download-queue'),
                  padding: NodeLaneTokens.pagePadding,
                  buildDefaultDragHandles: false,
                  header: Padding(
                    padding: const EdgeInsets.only(
                      top: NodeLaneTokens.space16,
                      bottom: NodeLaneTokens.space16,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final count = Text(
                          l10n.download_queue_count(widget.entries.length),
                          style: t.body.copyWith(fontWeight: FontWeight.w600),
                        );
                        final hint = Text(
                          l10n.download_queue_order_hint,
                          style: t.secondary,
                        );
                        if (MediaQuery.textScalerOf(context).scale(16) > 20 ||
                            constraints.maxWidth < 320) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              count,
                              const SizedBox(height: NodeLaneTokens.space4),
                              hint,
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(child: count),
                            const SizedBox(width: NodeLaneTokens.space12),
                            Expanded(
                              child: Text(
                                l10n.download_queue_order_hint,
                                textAlign: TextAlign.end,
                                style: t.secondary,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  itemCount: widget.entries.length,
                  onReorderItem: (from, to) {
                    if (!widget.isStarting) widget.onReorder(from, to);
                  },
                  itemBuilder: (context, index) {
                    final entry = widget.entries[index];
                    return Padding(
                      key: ValueKey(entry.id),
                      padding: const EdgeInsets.only(
                        bottom: NodeLaneTokens.space12,
                      ),
                      child: _DownloadChapterCard(
                        entry: entry,
                        index: index,
                        canReorder: !widget.isStarting,
                        onActions: widget.isStarting || _actionsOpen
                            ? null
                            : () => _showActions(entry),
                      ),
                    );
                  },
                ),
        ),
        bottomNavigationBar: widget.entries.isEmpty
            ? null
            : SafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(
                  NodeLaneTokens.gutter,
                  NodeLaneTokens.space8,
                  NodeLaneTokens.gutter,
                  NodeLaneTokens.space12,
                ),
                child: FilledButton.icon(
                  onPressed: widget.isStarting ? null : widget.onStart,
                  icon: Icon(
                    retry ? icons.refresh : icons.downloadQueue,
                    size: NodeLaneTokens.smallIconSize,
                  ),
                  label: Text(
                    retry
                        ? l10n.download_queue_retry
                        : l10n.download_queue_start,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }
}

/// A queue-specific composition of the shared group and action controls.
class _DownloadChapterCard extends StatelessWidget {
  const _DownloadChapterCard({
    required this.entry,
    required this.index,
    required this.canReorder,
    required this.onActions,
  });
  final Download entry;
  final int index;
  final bool canReorder;
  final VoidCallback? onActions;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final icons = NodeLaneIcons.of(context);
    final l10n = context.l10n;
    final total = entry.total ?? 0;
    final progress = total > 0
        ? ((entry.succeeded ?? 0) / total).clamp(0.0, 1.0)
        : 0.0;
    final failed = (entry.failed ?? 0) > 0;
    final error = Theme.of(context).colorScheme.error;
    // A started record can still be waiting for a download slot. Until there
    // is progress, avoid presenting every enqueued chapter as actively running.
    final status = failed
        ? l10n.download_queue_failed
        : entry.isStartDownload == true && progress > 0
        ? l10n.download_queue_active
        : l10n.download_queue_waiting;
    final percent = '${(progress * 100).round()}%';
    return NodeLaneGroupSurface(
      child: Padding(
        padding: NodeLaneTokens.groupPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.chapter.value?.manga.value?.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: t.body.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: NodeLaneTokens.space4),
                      Text(
                        entry.chapter.value?.name ?? '',
                        style: t.readerSecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: NodeLaneTokens.space8),
                NodeLaneIconButton(
                  icon: icons.more,
                  tooltip: l10n.more,
                  onPressed: onActions,
                ),
              ],
            ),
            const SizedBox(height: NodeLaneTokens.space12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          if (failed) ...[
                            Icon(
                              icons.error,
                              size: NodeLaneTokens.smallIconSize,
                              color: error,
                            ),
                            const SizedBox(width: NodeLaneTokens.space4),
                          ],
                          Expanded(
                            child: Text(
                              status,
                              style: t.readerSecondary.copyWith(
                                color: failed ? error : t.ink,
                              ),
                            ),
                          ),
                          const SizedBox(width: NodeLaneTokens.space8),
                          Text(percent, style: t.readerSecondary),
                        ],
                      ),
                      const SizedBox(height: NodeLaneTokens.space8),
                      ExcludeSemantics(
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: NodeLaneTokens.progressTrackHeight,
                          borderRadius: BorderRadius.circular(
                            NodeLaneTokens.progressTrackHeight,
                          ),
                          color: failed ? error : t.accent,
                          backgroundColor: t.line,
                          trackGap: 0,
                          stopIndicatorRadius: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: NodeLaneTokens.space8),
                ReorderableDragStartListener(
                  index: index,
                  enabled: canReorder,
                  child: Semantics(
                    label: l10n.download_queue_order_hint,
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SizedBox.square(
                        dimension: NodeLaneTokens.minTapTarget,
                        child: Icon(
                          icons.reorder,
                          size: NodeLaneTokens.smallIconSize,
                          color: canReorder
                              ? t.muted
                              : t.muted.withValues(alpha: .5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
