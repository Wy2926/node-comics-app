import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'browser_library_store.dart';
import 'mobile_browser_widgets.dart';

enum BrowserCollection {
  history,
  bookmarks,
  reading;

  String title(BuildContext context) => switch (this) {
    history => context.l10n.history,
    bookmarks => context.l10n.browser_bookmarks,
    reading => context.l10n.browser_continue,
  };
}

/// The same searchable collection is used from the start page and a live tab.
class BrowserLibraryPanel extends StatefulWidget {
  const BrowserLibraryPanel._({required this.store, required this.collection});
  static Future<BrowserPageEntry?> show(
    BuildContext context, {
    required BrowserLibraryStore store,
    BrowserCollection collection = BrowserCollection.history,
  }) => showNodeLaneBubble<BrowserPageEntry>(
    context,
    label: collection.title(context),
    width: NodeLaneTokens.bubbleFormWidth,
    child: BrowserLibraryPanel._(store: store, collection: collection),
  );
  final BrowserLibraryStore store;
  final BrowserCollection collection;

  @override
  State<BrowserLibraryPanel> createState() => _BrowserLibraryPanelState();
}

class _BrowserLibraryPanelState extends State<BrowserLibraryPanel> {
  final query = TextEditingController();
  bool ready = false, failed = false, busy = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => failed = false);
    try {
      await widget.store.load();
      if (mounted) setState(() => ready = true);
    } catch (_) {
      if (mounted) setState(() => failed = true);
    }
  }

  Future<void> _write(Future<void> Function() action) async {
    if (busy) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await action();
    } catch (_) {
      if (mounted) setState(() => error = context.l10n.browser_data_failed);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _clear() async {
    final confirmed = await showNodeLaneConfirmation(
      context,
      title: context.l10n.browser_clear_history,
      message: context.l10n.browser_clear_history_hint,
      confirmLabel: context.l10n.clear_all,
      destructive: true,
    );
    if (mounted && confirmed) await _write(widget.store.clearHistory);
  }

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.store,
    builder: (context, _) {
      final icons = NodeLaneIcons.of(context);
      final collection = widget.collection, store = widget.store;
      final history = collection == BrowserCollection.history;
      final term = query.text.trim().toLowerCase();
      final entries =
          (switch (collection) {
                BrowserCollection.history => store.history,
                BrowserCollection.bookmarks => store.bookmarks,
                BrowserCollection.reading => store.reading,
              })
              .where(
                (e) =>
                    term.isEmpty ||
                    '${e.title} ${e.url}'.toLowerCase().contains(term),
              )
              .toList();
      return NodeLaneBubblePanel(
        title: collection.title(context),
        actions: [
          if (history && ready && store.history.isNotEmpty)
            NodeLaneIconButton(
              icon: icons.delete,
              tooltip: context.l10n.browser_clear_history,
              style: NodeLaneIconButtonStyle.plain,
              destructive: true,
              onPressed: busy ? null : _clear,
            ),
        ],
        child: Padding(
          padding: NodeLaneTokens.bubbleContentPadding,
          child: CustomScrollView(
            primary: false,
            shrinkWrap: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    NodeLaneTextField.search(
                      controller: query,
                      hint: context.l10n.browser_search_library,
                      clearLabel: context.l10n.search_clear,
                      onChanged: (_) => setState(() {}),
                    ),
                    if (error != null)
                      Padding(
                        padding: NodeLaneTokens.groupPadding,
                        child: Text(
                          error!,
                          style: NodeLaneTokens.of(context).readerSecondary
                              .copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ),
                    const SizedBox(height: NodeLaneTokens.space12),
                  ],
                ),
              ),
              if (failed || !ready || entries.isEmpty)
                SliverToBoxAdapter(
                  child: failed
                      ? NodeLaneEmptyState.error(
                          message: context.l10n.browser_data_failed,
                          onRetry: _load,
                        )
                      : !ready
                      ? const NodeLaneEmptyState.loading()
                      : NodeLaneEmptyState(
                          icon: switch (collection) {
                            BrowserCollection.bookmarks =>
                              icons.bookmarkOutline,
                            BrowserCollection.history => icons.history,
                            BrowserCollection.reading => icons.library,
                          },
                          title: query.text.isNotEmpty
                              ? context.l10n.search_no_results
                              : context.l10n.browser_library_empty,
                        ),
                )
              else
                SliverList.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final select = busy
                        ? null
                        : () => Navigator.pop(context, entry);
                    final remove = NodeLaneIconButton(
                      icon: icons.delete,
                      tooltip: context.l10n.delete,
                      style: NodeLaneIconButtonStyle.plain,
                      destructive: true,
                      onPressed: busy
                          ? null
                          : () => _write(
                              () => switch (collection) {
                                BrowserCollection.history =>
                                  store.removeHistory(entry),
                                BrowserCollection.bookmarks =>
                                  store.setBookmarked(
                                    entry.url,
                                    entry.title,
                                    false,
                                  ),
                                BrowserCollection.reading =>
                                  store.removeReading(entry.url),
                              },
                            ),
                    );
                    if (collection == BrowserCollection.reading) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: NodeLaneTokens.space8,
                        ),
                        child: BrowserReadingCard(
                          entry,
                          key: ValueKey(entry.url),
                          onTap: select,
                          trailing: remove,
                        ),
                      );
                    }
                    final date = entry.time.toLocal();
                    final newDay =
                        index == 0 ||
                        !DateUtils.isSameDay(
                          entries[index - 1].time.toLocal(),
                          date,
                        );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (history && newDay)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: NodeLaneTokens.space8,
                            ),
                            child: NodeLaneSectionHeading(
                              MaterialLocalizations.of(context)
                                  .formatMediumDate(date),
                            ),
                          ),
                        NodeLaneGroupSurface(
                          outlined: true,
                          child: NodeLaneRow(
                            title: entry.displayTitle,
                            titleMaxLines: 1,
                            subtitle: entry.url,
                            subtitleMaxLines: 1,
                            metadata: !history
                                ? null
                                : MaterialLocalizations.of(context)
                                      .formatTimeOfDay(
                                        TimeOfDay.fromDateTime(date),
                                        alwaysUse24HourFormat:
                                            MediaQuery.alwaysUse24HourFormatOf(
                                              context,
                                            ),
                                      ),
                            leading: NodeLaneWebsiteIcon(url: entry.faviconUrl),
                            onTap: select,
                            trailing: remove,
                          ),
                        ),
                        const SizedBox(height: NodeLaneTokens.space8),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}
