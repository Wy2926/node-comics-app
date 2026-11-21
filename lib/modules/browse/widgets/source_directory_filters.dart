import 'package:flutter/material.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/source_catalog_metadata.dart';
import 'package:mangayomi/modules/browse/widgets/source_catalog_labels.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
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
  DirectoryFacet facet = DirectoryFacet.language;
  bool more = false, searching = false;
  final search = TextEditingController();

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final catalog = widget.catalog, filters = widget.filters;
    final language = facet == DirectoryFacet.language;
    final options = facet.options(
      l10n,
      widget.type,
      language
          ? ({
              ...?filters[facet],
              for (final s in catalog) (s.lang ?? '').toLowerCase(),
            }.toList()..sort())
          : const [],
    );
    final selected = filters[facet] ?? const <String>{};
    final allLanguages =
        language && options.isNotEmpty && options.keys.every(selected.contains);
    final needle = search.text.trim().toLowerCase();
    final visible = options.entries.where(
      (o) => o.value.toLowerCase().contains(needle),
    );
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    return NodeLaneGroupSurface(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: NodeLaneTokens.space12,
          vertical: NodeLaneTokens.space4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                for (final group in [
                  DirectoryFacet.language,
                  DirectoryFacet.format,
                  DirectoryFacet.pricing,
                  if (more) ...[DirectoryFacet.region, DirectoryFacet.creation],
                ])
                  Semantics(
                    selected: group == facet,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: group == facet ? t.accent : t.muted,
                        textStyle: t.label,
                      ),
                      onPressed: () => setState(() {
                        facet = group;
                        searching = false;
                        search.clear();
                      }),
                      child: Text(group.label(l10n)),
                    ),
                  ),
                Semantics(
                  expanded: more,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: t.muted,
                      textStyle: t.label,
                    ),
                    icon: Icon(
                      more ? icons.up : icons.down,
                      size: NodeLaneTokens.badgeIconSize,
                    ),
                    label: Text(l10n.source_more_filters),
                    onPressed: () => setState(() {
                      more = !more;
                      if (!more &&
                          (facet == DirectoryFacet.region ||
                              facet == DirectoryFacet.creation)) {
                        facet = DirectoryFacet.language;
                      }
                    }),
                  ),
                ),
              ],
            ),
            if (language && searching)
              NodeLaneTextField.search(
                controller: search,
                hint: l10n.search_languages,
                onChanged: (_) => setState(() {}),
              ),
            SingleChildScrollView(
              key: ValueKey(facet),
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: NodeLaneTokens.space4,
                children: [
                  if (needle.isEmpty)
                    DirectoryFilterChoice(
                      label: l10n.default0,
                      selected: !filters.containsKey(facet),
                      onPressed: () =>
                          widget.onChanged({...filters}..remove(facet)),
                    ),
                  if (language)
                    NodeLaneIconButton(
                      icon: icons.search,
                      tooltip: l10n.search_languages,
                      style: NodeLaneIconButtonStyle.plain,
                      onPressed: () => setState(() {
                        searching = !searching;
                        search.clear();
                      }),
                    ),
                  if (language && needle.isEmpty && options.isNotEmpty)
                    DirectoryFilterChoice(
                      label: l10n.source_all_languages,
                      selected: allLanguages,
                      onPressed: () => widget.onChanged(
                        allLanguages
                            ? ({...filters}..remove(facet))
                            : {...filters, facet: options.keys.toSet()},
                      ),
                    ),
                  for (final option in visible)
                    DirectoryFilterChoice(
                      label: option.value,
                      selected: selected.contains(option.key),
                      onPressed: () =>
                          widget.onChanged(filters.toggle(facet, option.key)),
                    ),
                  if (visible.isEmpty) Text(l10n.no_result, style: t.secondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DirectoryFilterChoice extends StatelessWidget {
  const DirectoryFilterChoice({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
    this.remove = false,
  });
  final String label;
  final bool selected, remove;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    return Semantics(
      checked: remove ? null : selected,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(
            NodeLaneTokens.minTapTarget,
            NodeLaneTokens.minTapTarget,
          ),
          foregroundColor: selected ? t.accent : t.ink,
          textStyle: t.label,
        ),
        onPressed: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? t.accentSoft : t.soft,
            borderRadius: BorderRadius.circular(NodeLaneTokens.controlRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NodeLaneTokens.space8,
              vertical: NodeLaneTokens.space4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: NodeLaneTokens.space4,
              children: [
                if (!remove)
                  Icon(
                    selected ? icons.selected : icons.unselected,
                    size: NodeLaneTokens.badgeIconSize,
                  ),
                Text(
                  label,
                  semanticsLabel: remove
                      ? '${context.l10n.remove} · $label'
                      : null,
                ),
                if (remove)
                  Icon(icons.close, size: NodeLaneTokens.badgeIconSize),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
