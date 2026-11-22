import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

import 'browser_library_store.dart';
import 'browser_url.dart';
import 'mobile_browser_widgets.dart';

/// One start page for the browser root and every logical blank tab.
class MobileBrowserStartPage extends StatelessWidget {
  const MobileBrowserStartPage({
    super.key,
    required this.sources,
    required this.tabCount,
    required this.onOpen,
    required this.onRequestSource,
    this.onTabs,
    this.onManage,
    this.bottomInset = 0,
    this.engine = BrowserSearchEngine.google,
    this.history = const [],
    this.reading = const [],
    this.onAllReading,
    this.onResume,
    this.onEngine,
    this.onHistory,
    this.onBookmarks,
    this.onMatch,
  });
  final List<Source> sources;
  final int tabCount;
  final void Function(String url, String title) onOpen;
  final VoidCallback onRequestSource;
  final VoidCallback? onManage;
  final ValueChanged<BuildContext>? onTabs, onHistory, onBookmarks;
  final double bottomInset;
  final BrowserSearchEngine engine;
  final List<BrowserPageEntry> reading, history;
  final ValueChanged<BuildContext>? onAllReading;
  final ValueChanged<BrowserPageEntry>? onResume;
  final Future<void> Function(BrowserSearchEngine)? onEngine;
  final ValueChanged<BrowserMatch>? onMatch;

  Future<void> _tools(BuildContext anchor) async {
    final l = anchor.l10n, icons = NodeLaneIcons.of(anchor);
    final action = await showNodeLaneBubble<VoidCallback>(
      anchor,
      label: l.more,
      child: Builder(
        builder: (panel) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onManage != null)
                NodeLaneRow(
                  title: l.source_pinned_websites,
                  icon: icons.pin,
                  onTap: () => Navigator.pop(panel, onManage),
                ),
              if (history.isNotEmpty && onHistory != null)
                NodeLaneRow(
                  title: l.history,
                  icon: icons.history,
                  onTap: () => Navigator.pop(panel, () => onHistory!(anchor)),
                ),
              NodeLaneRow(
                title: l.feedback_source,
                icon: icons.add,
                onTap: () => Navigator.pop(panel, onRequestSource),
              ),
            ],
          ),
        ),
      ),
    );
    if (anchor.mounted) action?.call();
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Builder(
          builder: (anchor) => NodeLaneIconButton(
            tooltip: context.l10n.browser_bookmarks,
            icon: NodeLaneIcons.of(context).bookmarkOutline,
            onPressed: onBookmarks == null ? null : () => onBookmarks!(anchor),
          ),
        ),
        const SizedBox(width: 8),
        MobileBrowserTabsButton(
          count: tabCount,
          onPressed: onTabs,
          tonal: true,
        ),
        const SizedBox(width: 8),
        Builder(
          builder: (anchor) => NodeLaneIconButton(
            tooltip: context.l10n.more,
            icon: NodeLaneIcons.of(context).more,
            onPressed: () => _tools(anchor),
          ),
        ),
      ],
    );
  }

  Widget _heading(
    String title,
    String label,
    IconData icon,
    ValueChanged<BuildContext>? open,
  ) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(child: NodeLaneCatalogHeading(title)),
      Flexible(
        child: Builder(
          builder: (anchor) => TextButton.icon(
            onPressed: open == null ? null : () => open(anchor),
            icon: Icon(icon, size: NodeLaneTokens.smallIconSize),
            label: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
    ],
  );

  Widget _site(BuildContext context, Source source) {
    final host = Uri.parse(source.baseUrl!).host,
        t = NodeLaneTokens.of(context);
    final name = source.name?.isNotEmpty == true ? source.name! : host;
    return NodeLaneGroupSurface(
      outlined: true,
      child: InkWell(
        onTap: () => onOpen(source.baseUrl!, source.name ?? ''),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NodeLaneWebsiteIcon(url: source.iconUrl),
              const SizedBox(height: 8),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.readerLabel,
              ),
              if (name != host)
                Text(
                  host,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.secondary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _sites(BuildContext context, double width, double scale) {
    if (sources.isEmpty) return const [];
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final columns = math.max(1, ((width + 8) / (144 * scale + 8)).floor());
    return [
      SliverToBoxAdapter(
        child: NodeLaneCatalogHeading(
          l.source_pinned_websites,
          action: onManage != null ? l.manage : null,
          onAction: onManage == null ? null : (_) => onManage!(),
        ),
      ),
      SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          mainAxisExtent:
              74 +
              BrowserReadingCard.lineHeight(context, t.readerLabel) +
              BrowserReadingCard.lineHeight(context, t.secondary),
        ),
        itemCount: sources.length,
        itemBuilder: (_, i) => _site(context, sources[i]),
      ),
    ];
  }

  List<Widget> _activity(
    BuildContext context,
    double width,
    double height,
    double scale,
  ) {
    final l = context.l10n,
        icons = NodeLaneIcons.of(context),
        locale = MaterialLocalizations.of(context);
    final columns = math.max(1, ((width + 8) / (268 * scale + 8)).floor());
    final extent = BrowserReadingCard.extent(context);
    final heading =
        math.max(44.0, MediaQuery.textScalerOf(context).scale(18) * 1.4) + 16;
    final row = math.max(44.0, extent - 44);
    final room = height - (reading.isEmpty ? 0 : heading);
    int fit(double space) => math.min(
      reading.length,
      columns * math.max(1, ((space + 8) / (extent + 8)).floor()),
    );
    final allReading = fit(room);
    final readingUrls = {for (final e in reading.take(allReading)) e.url};
    final hasRecent = history.any((e) => !readingUrls.contains(e.url));
    final count = hasRecent ? fit(room - heading - row) : allReading;
    final visibleRows = (count / columns).ceil();
    final readingHeight = math.max(0.0, visibleRows * (extent + 8) - 8);
    final seen = {for (final e in reading.take(count)) e.url};
    final recent = !hasRecent
        ? const <BrowserPageEntry>[]
        : history
              .where((e) => seen.add(e.url))
              .take(
                math.max(1, ((room - heading - readingHeight) / row).floor()),
              )
              .toList();
    final today = DateTime.now();
    return [
      if (count > 0) ...[
        SliverToBoxAdapter(
          child: _heading(
            l.browser_continue,
            l.view_all,
            icons.chapters,
            onAllReading,
          ),
        ),
        SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: extent,
          ),
          itemCount: count,
          itemBuilder: (_, i) => BrowserReadingCard(
            reading[i],
            key: ValueKey(reading[i].url),
            onTap: onResume == null ? null : () => onResume!(reading[i]),
          ),
        ),
      ],
      if (recent.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: _heading(
            l.browser_recent,
            l.history,
            icons.history,
            onHistory,
          ),
        ),
        SliverToBoxAdapter(
          child: NodeLaneGroupSurface(
            children: [
              for (final item in recent)
                NodeLaneRow(
                  compact: true,
                  title: item.displayTitle,
                  titleMaxLines: 1,
                  subtitleMaxLines: 1,
                  subtitle: [
                    if (item.displayTitle != item.host) item.host,
                    DateUtils.isSameDay(today, item.time.toLocal())
                        ? locale.formatTimeOfDay(
                            TimeOfDay.fromDateTime(item.time.toLocal()),
                            alwaysUse24HourFormat:
                                MediaQuery.alwaysUse24HourFormatOf(context),
                          )
                        : locale.formatShortDate(item.time.toLocal()),
                  ].join(' · '),
                  onTap: () => onOpen(item.url, item.title),
                ),
            ],
          ),
        ),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final scale = math.max(
      1.0,
      MediaQuery.textScalerOf(context).scale(16) / 16,
    );
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: LayoutBuilder(
            builder: (context, box) {
              final wide = context.hasPaneWidth(box.maxWidth);
              final pins = (box.maxWidth - 20) * .4;
              return CustomScrollView(
                key: const PageStorageKey('browser-start'),
                primary: false,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverToBoxAdapter(child: _header(context)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 8),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: wide
                                ? math.min(
                                    NodeLaneTokens.searchMaxWidth,
                                    box.maxWidth * .6,
                                  )
                                : box.maxWidth,
                          ),
                          child: MobileBrowserAddressField(
                            engine: engine,
                            onEngine: onEngine,
                            onSubmitted: (url) => onOpen(url, ''),
                            onMatch: onMatch,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (sources.isNotEmpty ||
                      reading.isNotEmpty ||
                      history.isNotEmpty)
                    SliverLayoutBuilder(
                      builder: (context, layout) {
                        final height = math.max(
                          0.0,
                          layout.viewportMainAxisExtent -
                              layout.precedingScrollExtent -
                              bottomInset -
                              12,
                        );
                        final hasActivity =
                            reading.isNotEmpty || history.isNotEmpty;
                        if (!wide) {
                          return SliverMainAxisGroup(
                            slivers: [
                              if (hasActivity)
                                ..._activity(
                                  context,
                                  box.maxWidth,
                                  height,
                                  scale,
                                ),
                              ..._sites(context, box.maxWidth, scale),
                            ],
                          );
                        }
                        return SliverToBoxAdapter(
                          child: SizedBox(
                            height: math.max(100, height),
                            child: Row(
                              children: [
                                if (sources.isNotEmpty)
                                  SizedBox(
                                    width: hasActivity ? pins : box.maxWidth,
                                    child: CustomScrollView(
                                      key: const PageStorageKey('browser-pins'),
                                      primary: false,
                                      slivers: _sites(
                                        context,
                                        hasActivity ? pins : box.maxWidth,
                                        scale,
                                      ),
                                    ),
                                  ),
                                if (sources.isNotEmpty && hasActivity)
                                  const SizedBox(width: 20),
                                if (hasActivity)
                                  Expanded(
                                    child: CustomScrollView(
                                      key: const PageStorageKey(
                                        'browser-reading',
                                      ),
                                      primary: false,
                                      slivers: _activity(
                                        context,
                                        sources.isEmpty
                                            ? box.maxWidth
                                            : box.maxWidth - pins - 20,
                                        height,
                                        scale,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: bottomInset + 12)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
