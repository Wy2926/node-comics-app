import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'browser_library_store.dart';

/// The same searchable collection is used from the start page and a live tab.
class MobileBrowserLibrarySheet extends StatefulWidget {
  const MobileBrowserLibrarySheet({
    super.key,
    required this.store,
    this.bookmarks = false,
  });
  final BrowserLibraryStore store;
  final bool bookmarks;

  @override
  State<MobileBrowserLibrarySheet> createState() =>
      _MobileBrowserLibrarySheetState();
}

class _MobileBrowserLibrarySheetState extends State<MobileBrowserLibrarySheet> {
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
      final entries =
          (widget.bookmarks ? widget.store.bookmarks : widget.store.history)
              .where(
                (e) => '${e.title} ${e.url}'.toLowerCase().contains(
                  query.text.trim().toLowerCase(),
                ),
              )
              .toList();
      return NodeLaneCatalogSheet(
        title: widget.bookmarks
            ? context.l10n.browser_bookmarks
            : context.l10n.history,
        heightFactor: .85,
        bottom: !widget.bookmarks && ready && widget.store.history.isNotEmpty
            ? NodeLaneSecondaryButton(
                onPressed: busy ? null : _clear,
                icon: icons.delete,
                child: Text(context.l10n.browser_clear_history),
              )
            : null,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NodeLaneTokens.gutter,
              ),
              child: NodeLaneTextField.search(
                controller: query,
                hint: context.l10n.browser_search_library,
                clearLabel: context.l10n.search_clear,
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (error != null)
              Padding(
                padding: NodeLaneTokens.groupPadding,
                child: Text(
                  error!,
                  style: NodeLaneTokens.of(context).readerSecondary,
                ),
              ),
            const SizedBox(height: NodeLaneTokens.space12),
            Expanded(
              child: failed
                  ? NodeLaneEmptyState.error(
                      message: context.l10n.browser_data_failed,
                      onRetry: _load,
                    )
                  : !ready
                  ? const NodeLaneEmptyState.loading()
                  : entries.isEmpty
                  ? NodeLaneEmptyState(
                      icon: widget.bookmarks
                          ? icons.bookmarkOutline
                          : icons.history,
                      title: context.l10n.browser_library_empty,
                      message: query.text.isNotEmpty
                          ? context.l10n.search_empty_hint
                          : widget.bookmarks
                          ? context.l10n.browser_bookmarks_hint
                          : context.l10n.browser_history_hint,
                      scrollable: true,
                    )
                  : ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.symmetric(
                        horizontal: NodeLaneTokens.gutter,
                      ),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
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
                            if (!widget.bookmarks && newDay)
                              NodeLaneCatalogHeading(
                                MaterialLocalizations.of(context)
                                    .formatMediumDate(date),
                              ),
                            NodeLaneRow.card(
                              title: entry.displayTitle,
                              titleMaxLines: 1,
                              subtitle: entry.url,
                              subtitleMaxLines: 1,
                              metadata: widget.bookmarks
                                  ? null
                                  : MaterialLocalizations.of(
                                      context,
                                    ).formatTimeOfDay(
                                      TimeOfDay.fromDateTime(date),
                                      alwaysUse24HourFormat:
                                          MediaQuery.alwaysUse24HourFormatOf(
                                            context,
                                          ),
                                    ),
                              leading: NodeLaneWebsiteIcon(
                                url: entry.faviconUrl,
                              ),
                              onTap: busy
                                  ? null
                                  : () => Navigator.pop(context, entry.url),
                              trailing: NodeLaneIconButton(
                                icon: icons.delete,
                                tooltip: context.l10n.delete,
                                style: NodeLaneIconButtonStyle.plain,
                                onPressed: busy
                                    ? null
                                    : () => _write(
                                        () => widget.bookmarks
                                            ? widget.store.setBookmarked(
                                                entry.url,
                                                entry.title,
                                                false,
                                              )
                                            : widget.store.removeHistory(entry),
                                      ),
                              ),
                            ),
                            const SizedBox(height: NodeLaneTokens.space8),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );
}
