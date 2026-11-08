import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/webview/browser_url.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

enum SearchPhase { searching, results, empty, failed }

/// Only presentation metadata is shared; source sections own their requests.
class SourceSearchActivity {
  const SourceSearchActivity(this.phase, {this.count = 0, this.retry});
  final SearchPhase phase;
  final int count;
  final VoidCallback? retry;

  String label(AppLocalizations l10n) => switch (phase) {
    SearchPhase.searching => l10n.search_searching,
    SearchPhase.results => l10n.search_found_results(count),
    SearchPhase.empty => l10n.search_no_results,
    SearchPhase.failed => l10n.search_failed,
  };
}

class SearchActivitySummary extends StatelessWidget {
  const SearchActivitySummary({
    super.key,
    required this.total,
    required this.activity,
    required this.onDetails,
    required this.onScope,
  });
  final int total;
  final Map<int, SourceSearchActivity> activity;
  final VoidCallback onDetails, onScope;

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final completed = activity.values
        .where((a) => a.phase != SearchPhase.searching)
        .length;
    final matched = activity.values.where(
      (a) => a.phase == SearchPhase.results,
    );
    final count = matched.fold(0, (sum, a) => sum + a.count);
    final searching = completed < total;
    final failed = activity.values.any((a) => a.phase == SearchPhase.failed);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NodeLaneTokens.gutter,
        NodeLaneTokens.space12,
        NodeLaneTokens.gutter,
        NodeLaneTokens.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  count > 0
                      ? context.l10n.search_found_titles(count, matched.length)
                      : searching
                      ? context.l10n.search_finding_titles
                      : context.l10n.search_complete,
                  style: t.readerSecondary,
                ),
              ),
              if (searching) ...[
                const SizedBox(width: NodeLaneTokens.space8),
                const _SearchSpinner(),
                const SizedBox(width: NodeLaneTokens.space8),
                Text(context.l10n.search_in_progress, style: t.caption),
              ],
            ],
          ),
          if (count == 0)
            NodeLaneEmptyState(
              icon: NodeLaneIcons.of(context).search,
              title: searching
                  ? context.l10n.search_finding_related
                  : failed
                  ? context.l10n.search_no_results_yet
                  : context.l10n.search_no_matching_titles,
              message: searching
                  ? context.l10n.search_results_appear_hint
                  : failed
                  ? context.l10n.search_failed_websites_hint
                  : context.l10n.search_change_keywords_hint,
              action: searching
                  ? null
                  : TextButton(
                      onPressed: failed ? onDetails : onScope,
                      child: Text(
                        failed
                            ? context.l10n.search_view_details
                            : context.l10n.search_adjust_scope,
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}

class _SearchSpinner extends StatelessWidget {
  const _SearchSpinner();
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: NodeLaneTokens.space16,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: NodeLaneTokens.of(context).accent,
    ),
  );
}

/// Opened explicitly, so unavailable websites never occupy the results feed.
class SearchActivitySheet extends StatelessWidget {
  const SearchActivitySheet({
    super.key,
    required this.query,
    required this.sources,
    required this.activity,
    required this.onOpen,
  });
  final String query;
  final List<Source> sources;
  final ValueListenable<Map<int, SourceSearchActivity>> activity;
  final ValueChanged<Source> onOpen;

  @override
  Widget build(BuildContext context) => NodeLaneCatalogSheet(
    title: context.l10n.search_details,
    subtitle: context.l10n.search_query_websites(query, sources.length),
    heightFactor: NodeLaneTokens.readerSheetFraction,
    child: ValueListenableBuilder(
      valueListenable: activity,
      builder: (context, values, _) => ListView.builder(
        padding: NodeLaneTokens.pagePadding,
        itemCount: sources.length + 2,
        itemBuilder: (context, index) {
          final t = NodeLaneTokens.of(context);
          if (index == 0) {
            final completed = values.values
                .where((a) => a.phase != SearchPhase.searching)
                .length;
            return Padding(
              padding: const EdgeInsets.only(bottom: NodeLaneTokens.space16),
              child: Text(
                context.l10n.search_completed_count(completed, sources.length),
                style: t.readerSecondary,
              ),
            );
          }
          if (index == sources.length + 1) {
            return Padding(
              padding: const EdgeInsets.only(top: NodeLaneTokens.space16),
              child: Text(
                context.l10n.search_retry_website_hint,
                style: t.readerSecondary,
              ),
            );
          }
          final source = sources[index - 1];
          final state =
              values[source.id] ??
              const SourceSearchActivity(SearchPhase.searching);
          final canOpenWebsite =
              state.phase == SearchPhase.failed && isBrowserUrl(source.baseUrl);
          return NodeLaneRow.card(
            first: index == 1,
            last: index == sources.length,
            minHeight: NodeLaneTokens.rowHeight,
            title: source.name ?? '',
            icon: NodeLaneIcons.of(context).web,
            subtitle: state.label(context.l10n),
            trailing: switch (state.phase) {
              SearchPhase.failed => TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: state.retry,
                child: Text(context.l10n.retry),
              ),
              SearchPhase.searching => const _SearchSpinner(),
              SearchPhase.results => Icon(
                NodeLaneIcons.of(context).forward,
                color: t.accent,
                size: NodeLaneTokens.smallIconSize,
              ),
              SearchPhase.empty => null,
            },
            onTap: state.phase == SearchPhase.results
                ? () => onOpen(source)
                : canOpenWebsite
                ? () => context.push(
                    '/mangawebview',
                    extra: {'url': source.baseUrl!, 'title': source.name ?? ''},
                  )
                : null,
          );
        },
      ),
    ),
  );
}
