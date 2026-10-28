import 'package:flutter/material.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// The existing queue screen owns ordering, cancellation and processing.
class MobileDownloadQueue extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.download_queue,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              tooltip: l10n.downloads,
              onPressed: onSettings,
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          bottom: entries.isEmpty,
          child: entries.isEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: (constraints.maxHeight - 48).clamp(
                          0,
                          double.infinity,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download_outlined,
                            size: 48,
                            color: colors.muted,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.no_downloads,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: colors.ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.download_queue_empty_hint,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: colors.muted),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : ReorderableListView.builder(
                  key: const PageStorageKey('mobile-download-queue'),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  buildDefaultDragHandles: false,
                  header: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.download_queue_count(entries.length),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.download_queue_order_hint,
                          style: TextStyle(fontSize: 13, color: colors.muted),
                        ),
                      ],
                    ),
                  ),
                  itemCount: entries.length,
                  onReorderItem: (from, to) {
                    if (!isStarting) onReorder(from, to);
                  },
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final total = entry.total ?? 0;
                    final progress = total > 0
                        ? ((entry.succeeded ?? 0) / total).clamp(0.0, 1.0)
                        : 0.0;
                    final failed = (entry.failed ?? 0) > 0;
                    return Padding(
                      key: ValueKey(entry.id),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: colors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: colors.line),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReorderableDragStartListener(
                                    index: index,
                                    enabled: !isStarting,
                                    child: SizedBox(
                                      width: 44,
                                      height: 48,
                                      child: Icon(
                                        Icons.drag_handle_rounded,
                                        color: colors.muted,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            entry
                                                    .chapter
                                                    .value
                                                    ?.manga
                                                    .value
                                                    ?.name ??
                                                '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: colors.ink,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            entry.chapter.value?.name ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: colors.muted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton<bool>(
                                    tooltip: l10n.more,
                                    enabled: !isStarting,
                                    icon: const Icon(Icons.more_horiz_rounded),
                                    onSelected: (series) => series
                                        ? onCancelSeries(entry)
                                        : onCancel(entry),
                                    itemBuilder: (_) => [
                                      PopupMenuItem(
                                        value: false,
                                        child: Text(l10n.cancel),
                                      ),
                                      PopupMenuItem(
                                        value: true,
                                        child: Text(
                                          l10n.cancel_all_for_this_series,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      failed
                                          ? l10n.failed
                                          : '${(progress * 100).round()}%',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: failed
                                            ? Theme.of(context)
                                                  .colorScheme
                                                  .error
                                            : colors.muted,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 4,
                                      borderRadius: BorderRadius.circular(4),
                                      color: failed
                                          ? Theme.of(context).colorScheme.error
                                          : colors.accent,
                                      backgroundColor: colors.soft,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        bottomNavigationBar: entries.isEmpty
            ? null
            : SafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: FilledButton.icon(
                  onPressed: isStarting ? null : onStart,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  icon: const Icon(Icons.download_rounded),
                  label: Text(
                    entries.any((entry) => (entry.failed ?? 0) > 0)
                        ? l10n.retry
                        : l10n.start_downloading,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }
}
