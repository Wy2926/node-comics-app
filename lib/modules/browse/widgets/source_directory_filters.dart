import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/source_catalog_metadata.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/modules/browse/widgets/source_catalog_labels.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/mobile_source_catalog.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

typedef DirectoryFilters = Map<DirectoryFacet, Set<String>>;

enum DirectoryFacet {
  language,
  region,
  format,
  creation,
  pricing;

  String label(AppLocalizations l10n) => switch (this) {
    language => l10n.language,
    region => l10n.source_region,
    format => l10n.source_format,
    creation => l10n.source_creation,
    pricing => l10n.source_pricing,
  };

  Map<String, String> options(
    AppLocalizations l10n,
    ItemType type,
    Iterable<String> languages,
  ) => switch (this) {
    language => {
      for (final code in languages) code: sourceLanguageLabel(code, l10n),
    },
    region => sourceRegions(l10n),
    format => sourceFormats(l10n),
    creation => sourceCreations(l10n),
    pricing => {
      for (final price in SourcePricing.values)
        price.name: sourcePricingLabel(price, type, l10n),
    },
  };
}

extension DirectorySelection on DirectoryFilters {
  String summary(AppLocalizations l, ItemType type) => [
    for (final e in entries)
      if (e.value.length == 1)
        e.key.options(l, type, e.value)[e.value.first] ?? e.value.first
      else
        '${e.key.label(l)} (${e.value.length})',
  ].join(' · ');

  DirectoryFilters toggle(DirectoryFacet facet, String value) {
    final values = {...?this[facet]};
    if (!values.remove(value)) values.add(value);
    final result = {...this, facet: values};
    if (values.isEmpty) result.remove(facet);
    return result;
  }

  bool matches(Source source, String keyword) {
    if (!(source.name ?? '').toLowerCase().contains(keyword)) return false;
    final languages = this[DirectoryFacet.language];
    if (!(languages?.contains((source.lang ?? '').toLowerCase()) ??
        (source.isActive == true))) {
      return false;
    }
    late final metadata = source.catalogMetadata;
    return entries.every(
      (filter) => switch (filter.key) {
        DirectoryFacet.language => true,
        DirectoryFacet.region => metadata.regions.any(filter.value.contains),
        DirectoryFacet.format => metadata.formats.any(filter.value.contains),
        DirectoryFacet.creation => metadata.creations.any(
          filter.value.contains,
        ),
        DirectoryFacet.pricing => filter.value.contains(metadata.pricing.name),
      },
    );
  }
}

class SourceDirectoryFilterPanel extends ConsumerStatefulWidget {
  const SourceDirectoryFilterPanel({
    super.key,
    required this.directory,
    required this.keyword,
    required this.initial,
    required this.onChanged,
  });
  final (ItemType, bool) directory;
  final String keyword;
  final DirectoryFilters initial;
  final ValueChanged<DirectoryFilters> onChanged;
  @override
  ConsumerState<SourceDirectoryFilterPanel> createState() =>
      _DirectoryFilterState();
}

class _DirectoryFilterState extends ConsumerState<SourceDirectoryFilterPanel> {
  late DirectoryFilters filters = widget.initial;
  late DirectoryFacet facet =
      filters.keys.lastOrNull ?? DirectoryFacet.language;
  final search = TextEditingController();

  void change(DirectoryFilters next) {
    setState(() => filters = next);
    widget.onChanged(next);
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final (type, thirdParty) = widget.directory;
    final catalog = ref.watch(mobileDirectorySourcesProvider(widget.directory));
    final loading =
        catalog.isEmpty &&
        ((!thirdParty &&
                ref.watch(nodeLaneCatalogLoadProvider(type)).isLoading) ||
            ref.watch(mobileCatalogEntriesProvider(type)).isLoading);
    final count = catalog
        .where((s) => filters.matches(s, widget.keyword))
        .length;
    final group = facet;
    final language = group == DirectoryFacet.language;
    final selected = filters[group] ?? const <String>{};
    final options = group.options(
      l,
      type,
      language
          ? ({
              ...selected,
              for (final s in catalog) (s.lang ?? '').toLowerCase(),
            }.toList()..sort())
          : const [],
    );
    final allLanguages =
        options.isNotEmpty && options.keys.every(selected.contains);
    final needle = search.text.trim().toLowerCase();
    final visible = options.entries.where(
      (o) => o.value.toLowerCase().contains(needle) || o.key.contains(needle),
    );
    final height =
        (MediaQuery.textScalerOf(context).scale(t.label.fontSize!) *
                    t.label.height! +
                NodeLaneTokens.space16)
            .clamp(NodeLaneTokens.minTapTarget, double.infinity);
    Widget choice(String label, bool checked, VoidCallback toggle) =>
        FilterChip(
          label: Text(label),
          selected: checked,
          checkmarkColor: t.accent,
          labelStyle: t.label.copyWith(color: checked ? t.accent : t.ink),
          onSelected: (_) => toggle(),
        );
    final choices = Wrap(
      spacing: NodeLaneTokens.space8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (needle.isEmpty)
          choice(
            l.default0,
            selected.isEmpty,
            () => change({...filters}..remove(group)),
          ),
        if (language && needle.isEmpty && options.isNotEmpty)
          choice(
            l.source_all_languages,
            allLanguages,
            () => change(
              allLanguages
                  ? ({...filters}..remove(group))
                  : {...filters, group: options.keys.toSet()},
            ),
          ),
        for (final o in visible)
          choice(
            o.value,
            selected.contains(o.key),
            () => change(filters.toggle(group, o.key)),
          ),
        if (visible.isEmpty && needle.isNotEmpty)
          Text(l.no_result, style: t.secondary),
      ],
    );
    return NodeLaneBubblePanel(
      title: loading
          ? l.filter
          : '${l.filter} · ${l.search_result_count(count)}',
      subtitle: filters.summary(l, type),
      actions: [
        if (filters.isNotEmpty)
          NodeLaneBubbleAction.clear.button(context, () => change(const {})),
      ],
      child: SingleChildScrollView(
        child: DefaultTabController(
          length: DirectoryFacet.values.length,
          initialIndex: facet.index,
          animationDuration: NodeLaneMotion.time(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: t.accent,
                unselectedLabelColor: t.muted,
                labelStyle: t.label,
                indicatorColor: t.accent,
                dividerColor: t.line,
                onTap: (i) {
                  if (facet == DirectoryFacet.values[i]) return;
                  FocusScope.of(context).unfocus();
                  setState(() {
                    facet = DirectoryFacet.values[i];
                    search.clear();
                  });
                },
                tabs: [
                  for (final f in DirectoryFacet.values)
                    Tab(
                      height: height,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(f.label(l)),
                          if (filters[f] case final values?) ...[
                            const SizedBox(width: NodeLaneTokens.space4),
                            Semantics(
                              label: l.source_selected_count(values.length),
                              excludeSemantics: true,
                              child: Badge.count(
                                count: values.length,
                                backgroundColor: t.accentSoft,
                                textColor: t.accent,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: NodeLaneTokens.space16,
                  vertical: NodeLaneTokens.space8,
                ),
                child: NodeLaneMotion.resize(
                  context,
                  NodeLaneContentMotion(
                    value: group,
                    child: Column(
                      key: ValueKey(group),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (language &&
                            (options.length > 8 || needle.isNotEmpty)) ...[
                          NodeLaneTextField.search(
                            controller: search,
                            hint: l.search_languages,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: NodeLaneTokens.space4),
                        ],
                        choices,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
