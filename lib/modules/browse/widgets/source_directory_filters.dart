import 'package:flutter/material.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/source_catalog_metadata.dart';
import 'package:mangayomi/theme/nodelane_motion.dart';
import 'package:mangayomi/modules/browse/widgets/source_catalog_labels.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
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

class SourceDirectoryFilterPanel extends StatefulWidget {
  const SourceDirectoryFilterPanel({
    super.key,
    required this.filters,
    required this.type,
    required this.catalog,
    required this.onChanged,
  });
  final DirectoryFilters filters;
  final ItemType type;
  final List<Source> catalog;
  final ValueChanged<DirectoryFilters> onChanged;
  @override
  State<SourceDirectoryFilterPanel> createState() => _DirectoryFilterState();
}

class _DirectoryFilterState extends State<SourceDirectoryFilterPanel> {
  late DirectoryFacet facet =
      widget.filters.keys.lastOrNull ?? DirectoryFacet.language;
  final search = TextEditingController();

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, t = NodeLaneTokens.of(context);
    final group = facet, filters = widget.filters;
    final language = group == DirectoryFacet.language;
    final selected = filters[group] ?? const <String>{};
    final options = group.options(
      l,
      widget.type,
      language
          ? ({
              ...selected,
              for (final s in widget.catalog) (s.lang ?? '').toLowerCase(),
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
            () => widget.onChanged({...filters}..remove(group)),
          ),
        if (language && needle.isEmpty && options.isNotEmpty)
          choice(
            l.source_all_languages,
            allLanguages,
            () => widget.onChanged(
              allLanguages
                  ? ({...filters}..remove(group))
                  : {...filters, group: options.keys.toSet()},
            ),
          ),
        for (final o in visible)
          choice(
            o.value,
            selected.contains(o.key),
            () => widget.onChanged(filters.toggle(group, o.key)),
          ),
        if (visible.isEmpty && needle.isNotEmpty)
          Text(l.no_result, style: t.secondary),
      ],
    );
    return NodeLaneGroupSurface(
      outlined: true,
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
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.sizeOf(context).height * .24,
                        ),
                        child: SingleChildScrollView(
                          primary: false,
                          child: choices,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
