import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Source requests, saved queries and navigation belong to the owning screen.
class MobileSourceCatalog extends StatelessWidget {
  const MobileSourceCatalog({
    super.key,
    required this.title,
    required this.search,
    required this.onSubmit,
    required this.onClear,
    required this.selected,
    required this.supportsLatest,
    required this.filtering,
    required this.onSelect,
    required this.onOptions,
    required this.results,
    this.onFilter,
  });

  final String title;
  final TextEditingController search;
  final VoidCallback onSubmit, onClear, onOptions;
  final ValueChanged<int> onSelect;
  final VoidCallback? onFilter;
  final int selected;
  final bool supportsLatest, filtering;
  final Widget results;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context), l10n = context.l10n;
    return MobileBrowsePage(
      title: title,
      actions: [
        IconButton(
          tooltip: l10n.more,
          onPressed: onOptions,
          icon: const Icon(Icons.more_horiz_rounded),
        ),
      ],
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * .5,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Semantics(
                            label: l10n.search,
                            child: ValueListenableBuilder(
                              valueListenable: search,
                              builder: (context, value, _) => TextField(
                                controller: search,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (_) => onSubmit(),
                                style: const TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: l10n.search,
                                  filled: true,
                                  fillColor: colors.soft,
                                  contentPadding: const EdgeInsets.all(14),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: value.text.isEmpty
                                      ? null
                                      : IconButton(
                                          tooltip: l10n.reset,
                                          onPressed: onClear,
                                          icon: const Icon(Icons.close_rounded),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          tooltip: l10n.search,
                          constraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                          onPressed: onSubmit,
                          icon: const Icon(Icons.search_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        ChoiceChip(
                          label: Text(l10n.popular),
                          selected: selected == 0,
                          onSelected: (_) => onSelect(0),
                        ),
                        if (supportsLatest)
                          ChoiceChip(
                            label: Text(l10n.latest),
                            selected: selected == 1,
                            onSelected: (_) => onSelect(1),
                          ),
                        if (onFilter != null)
                          FilterChip(
                            label: Text(l10n.filter),
                            selected: filtering,
                            onSelected: (_) => onFilter!(),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: results),
          ],
        ),
      ),
    );
  }
}

class MobileSourceResults extends StatelessWidget {
  const MobileSourceResults({
    super.key,
    required this.controller,
    required this.display,
    required this.count,
    required this.itemBuilder,
    required this.status,
    required this.footer,
    this.gridSize,
    this.notes,
  });
  final ScrollController controller;
  final DisplayType display;
  final int count;
  final int? gridSize;
  final String status;
  final String? notes;
  final IndexedWidgetBuilder itemBuilder;
  final Widget footer;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final available = math.max(1.0, constraints.maxWidth - 40);
      // Honor density within a usable minimum touch/cover width on phones.
      final maxColumns = math.max(1, ((available + 12) / 112).floor());
      final columns =
          (gridSize == null || gridSize == 0
                  ? (available / 200).ceil()
                  : gridSize!)
              .clamp(1, maxColumns);
      final width = (available - 12 * (columns - 1)) / columns;
      final compact = display == DisplayType.compactGrid;
      return CustomScrollView(
        controller: controller,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Text(
                status,
                style: TextStyle(color: NodeLaneTokens.of(context).muted),
              ),
            ),
          ),
          if (notes?.isNotEmpty == true)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(context.l10n.extension_notes('')),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(notes!),
                    ),
                  ],
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: display == DisplayType.list
                ? SliverList.builder(
                    itemCount: count,
                    itemBuilder: itemBuilder,
                    addAutomaticKeepAlives: false,
                  )
                : SliverGrid.builder(
                    itemCount: count,
                    itemBuilder: itemBuilder,
                    addAutomaticKeepAlives: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 20,
                      mainAxisExtent:
                          math.max(
                            width * 1.42,
                            compact
                                ? MediaQuery.textScalerOf(context).scale(15) *
                                          1.3 *
                                          2 +
                                      56
                                : 0,
                          ) +
                          (compact
                              ? 0
                              : 10 +
                                    MediaQuery.textScalerOf(context).scale(15) *
                                        1.3 *
                                        2),
                    ),
                  ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: footer,
            ),
          ),
        ],
      );
    },
  );
}

class MobileSourceMangaCard extends StatelessWidget {
  const MobileSourceMangaCard({
    super.key,
    required this.title,
    required this.cover,
    required this.onOpen,
    required this.onQuickAdd,
    required this.inLibrary,
    this.list = false,
    this.compact = false,
  });
  final String title;
  final Widget cover;
  final VoidCallback onOpen, onQuickAdd;
  final bool inLibrary, list, compact;

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final titleWidget = Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 15,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: compact && !list ? Colors.white : colors.ink,
      ),
    );
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: ColoredBox(
        color: colors.soft,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ExcludeSemantics(child: cover),
            if (compact && !list)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: .8),
                      ],
                    ),
                  ),
                ),
              ),
            if (inLibrary)
              Positioned(
                top: 8,
                left: 8,
                child: Tooltip(
                  message: context.l10n.in_library,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: colors.accent,
                    child: Icon(
                      Icons.bookmark_rounded,
                      size: 18,
                      color: colors.onAccent,
                    ),
                  ),
                ),
              ),
            if (compact && !list)
              Positioned(
                left: 10,
                right: 10,
                bottom: 12,
                child: ExcludeSemantics(child: titleWidget),
              ),
          ],
        ),
      ),
    );
    return Semantics(
      label: title,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onOpen,
          onLongPress: onQuickAdd,
          child: list
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(width: 78, height: 110, child: image),
                      const SizedBox(width: 16),
                      Expanded(child: ExcludeSemantics(child: titleWidget)),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right_rounded, color: colors.muted),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: image),
                    if (!compact)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ExcludeSemantics(child: titleWidget),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class MobileSourceStatus extends StatelessWidget {
  const MobileSourceStatus({
    super.key,
    this.loading = false,
    this.message,
    this.onRetry,
    this.onBrowser,
    this.onLoadMore,
  });
  final bool loading;
  final String? message;
  final VoidCallback? onRetry, onBrowser, onLoadMore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (loading)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(message!, textAlign: TextAlign.center),
          ),
        if (onRetry != null)
          FilledButton.tonal(onPressed: onRetry, child: Text(l10n.retry)),
        if (onBrowser != null)
          TextButton(onPressed: onBrowser, child: Text(l10n.open_in_browser)),
        if (onLoadMore != null && !loading)
          FilledButton.tonal(
            onPressed: onLoadMore,
            child: Text(l10n.load_more),
          ),
      ],
    );
  }
}
