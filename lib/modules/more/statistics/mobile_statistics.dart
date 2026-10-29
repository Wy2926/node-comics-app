import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/statistics_provider.dart';
import 'package:mangayomi/modules/more/widgets/mobile_media_selector.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

class MobileStatistics extends ConsumerStatefulWidget {
  const MobileStatistics({super.key, required this.types});
  final List<ItemType> types;

  @override
  ConsumerState<MobileStatistics> createState() => _MobileStatisticsState();
}

class _MobileStatisticsState extends ConsumerState<MobileStatistics> {
  late ItemType? _type = widget.types.firstOrNull;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final type = _type;
    final stats = type == null
        ? null
        : ref.watch(getStatisticsProvider(itemType: type));
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.statistics,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            key: PageStorageKey('mobile-statistics-$type'),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              MobileMediaSelector(
                types: widget.types,
                selected: type,
                onChanged: (value) => setState(() => _type = value),
              ),
              if (type == null)
                Text(l10n.no_result)
              else
                stats!.when(
                  skipLoadingOnRefresh: false,
                  loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => Column(
                    children: [
                      Text(l10n.failed),
                      TextButton(
                        onPressed: () => ref.invalidate(
                          getStatisticsProvider(itemType: type),
                        ),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                  data: (value) => _StatisticsValues(type: type, stats: value),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatisticsValues extends StatelessWidget {
  const _StatisticsValues({required this.type, required this.stats});
  final ItemType type;
  final StatisticsData stats;

  String _duration(int seconds) {
    if (seconds <= 0) return '0m';
    final days = seconds ~/ 86400;
    final hours = (seconds % 86400) ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return [
      if (days > 0) '${days}d',
      if (hours > 0) '${hours}h',
      if (minutes > 0 || (days == 0 && hours == 0)) '${minutes}m',
    ].join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isAnime = type == ItemType.anime;
    // Keep the original statistics formulas and rounding. The provider owns
    // library membership, completion criteria and aggregation queries.
    final completedPercentage = stats.totalItems > 0
        ? stats.completedItems / stats.totalItems * 100
        : 0.0;
    final readPercentage = stats.totalChapters > 0
        ? stats.readChapters / stats.totalChapters * 100
        : 0.0;
    final averageChapters = stats.totalItems > 0
        ? stats.totalChapters / stats.totalItems
        : 0.0;
    final averageSeconds = stats.totalItems > 0
        ? (stats.totalReadingTimeSeconds / stats.totalItems).round()
        : 0;
    final colors = NodeLaneTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Section(l10n.entries),
        _MetricGrid(
          values: [
            (l10n.in_library, '${stats.totalItems}'),
            (l10n.completed, '${stats.completedItems}'),
            (
              l10n.completion_rate,
              '${completedPercentage.toStringAsFixed(1)}%',
            ),
          ],
        ),
        _Section(isAnime ? l10n.episodes : l10n.chapters),
        _MetricGrid(
          values: [
            (l10n.total, '${stats.totalChapters}'),
            (
              isAnime ? l10n.statistics_watched : l10n.read,
              '${stats.readChapters}',
            ),
            (
              isAnime ? l10n.unwatched : l10n.unread,
              '${stats.totalChapters - stats.readChapters}',
            ),
            (l10n.downloaded, '${stats.downloadedItems}'),
          ],
        ),
        const SizedBox(height: 12),
        _MetricCard(
          label: l10n.average_chapters_per_title(type.localized(l10n)),
          value: averageChapters.toStringAsFixed(2),
        ),
        const SizedBox(height: 12),
        _MetricCard(
          label: l10n.read_percentage,
          value: '${readPercentage.toStringAsFixed(1)}%',
          footer: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ExcludeSemantics(
              child: LinearProgressIndicator(
                value: (readPercentage / 100).clamp(0, 1),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
                backgroundColor: colors.soft,
              ),
            ),
          ),
        ),
        _Section(isAnime ? l10n.watching_time : l10n.reading_time),
        _MetricGrid(
          values: [
            (l10n.total, _duration(stats.totalReadingTimeSeconds)),
            (l10n.mean_per_title, _duration(averageSeconds)),
          ],
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 12),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    ),
  );
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.values});
  final List<(String, String)> values;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns =
          constraints.maxWidth >= 320 &&
              MediaQuery.textScalerOf(context).scale(16) <= 24
          ? 2
          : 1;
      final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final (label, value) in values)
            SizedBox(
              width: width,
              child: _MetricCard(label: label, value: value),
            ),
        ],
      );
    },
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, this.footer});
  final String label, value;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: colors.muted)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: colors.ink,
            ),
          ),
          ?footer,
        ],
      ),
    );
  }
}
