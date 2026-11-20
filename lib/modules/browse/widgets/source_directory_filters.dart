import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/source_catalog_metadata.dart';
import 'package:mangayomi/modules/browse/widgets/source_catalog_labels.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
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

  String summary(Set<String> values, AppLocalizations l10n, ItemType type) {
    final labels = options(l10n, type, values);
    return values.isEmpty
        ? l10n.source_selected_count(0)
        : values.map((code) => labels[code]!).join(', ');
  }
}

extension DirectoryMatching on DirectoryFilters {
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

class SourceDirectoryFilterBar extends StatelessWidget {
  const SourceDirectoryFilterBar({
    super.key,
    required this.filters,
    required this.type,
    required this.onOpen,
  });
  final DirectoryFilters filters;
  final ItemType type;
  final ValueChanged<DirectoryFacet> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n, t = NodeLaneTokens.of(context);
    return SingleChildScrollView(
      key: const PageStorageKey('directory-filter-bar'),
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: NodeLaneTokens.space8,
        children: [
          for (final facet in DirectoryFacet.values)
            ActionChip(
              label: Text(switch (filters[facet]) {
                null => facet.label(l10n),
                final values when values.length == 1 =>
                  '${facet.label(l10n)} · ${facet.summary(values, l10n, type)}',
                final values => '${facet.label(l10n)} · ${values.length}',
              }),
              backgroundColor: filters.containsKey(facet)
                  ? t.accentSoft
                  : t.surface,
              onPressed: () => onOpen(facet),
            ),
        ],
      ),
    );
  }
}

class SourceDirectoryFilterSheet extends ConsumerStatefulWidget {
  const SourceDirectoryFilterSheet({
    super.key,
    required this.initial,
    required this.facet,
    required this.directory,
    required this.keyword,
  });
  final DirectoryFilters initial;
  final DirectoryFacet facet;
  final (ItemType, bool) directory;
  final String keyword;

  @override
  ConsumerState<SourceDirectoryFilterSheet> createState() =>
      _SourceDirectoryFilterSheetState();
}

class _SourceDirectoryFilterSheetState
    extends ConsumerState<SourceDirectoryFilterSheet> {
  late final DirectoryFilters draft = {...widget.initial};
  late DirectoryFacet facet = widget.facet;
  final search = TextEditingController();

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final catalog = ref.watch(mobileDirectorySourcesProvider(widget.directory));
    final language = facet == DirectoryFacet.language;
    final options = facet.options(
      l10n,
      widget.directory.$1,
      language
          ? ({
              ...?draft[facet],
              for (final s in catalog) (s.lang ?? '').toLowerCase(),
            }.toList()..sort())
          : const [],
    );
    final defaults = <String>{
      if (language)
        for (final s in catalog)
          if (s.isActive == true) (s.lang ?? '').toLowerCase(),
    };
    final selected = draft[facet] ?? defaults;
    final needle = search.text.trim().toLowerCase();
    final visible = options.entries.where(
      (o) => o.value.toLowerCase().contains(needle),
    );
    final count = catalog.where((s) => draft.matches(s, widget.keyword)).length;
    void choose(String code) => setState(() {
      final next = {...(draft[facet] ?? defaults)};
      if (!next.remove(code)) next.add(code);
      if (!language && next.isEmpty) {
        draft.remove(facet);
      } else {
        draft[facet] = next;
      }
    });
    return NodeLaneCatalogSheet(
      title: l10n.filter,
      heightFactor: .9,
      fitContent: true,
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            liveRegion: true,
            child: Text(
              l10n.search_result_count(count),
              style: NodeLaneTokens.of(context).readerLabel,
            ),
          ),
          const SizedBox(height: NodeLaneTokens.space8),
          NodeLaneModalActions(
            actions: [
              NodeLaneDialogAction(
                label: l10n.action_clear,
                secondary: true,
                onPressed: draft.isEmpty
                    ? null
                    : () => setState(() {
                        draft.clear();
                        search.clear();
                      }),
              ),
              NodeLaneDialogAction(
                label: l10n.action_apply,
                onPressed: () {
                  if (ModalRoute.of(context)?.isCurrent == true) {
                    Navigator.pop(context, draft);
                  }
                },
              ),
            ],
          ),
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: NodeLaneTokens.gutter),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text(
            l10n.source_language_filter_hint,
            style: NodeLaneTokens.of(context).readerSecondary,
          ),
          Wrap(
            spacing: NodeLaneTokens.space8,
            children: [
              for (final group in DirectoryFacet.values)
                ChoiceChip(
                  label: Text(group.label(l10n)),
                  selected: group == facet,
                  onSelected: (_) => setState(() {
                    facet = group;
                    search.clear();
                  }),
                ),
            ],
          ),
          const SizedBox(height: NodeLaneTokens.space8),
          if (language) ...[
            NodeLaneTextField.search(
              controller: search,
              hint: l10n.search_languages,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: NodeLaneTokens.space8),
          ],
          NodeLaneGroupSurface(
            children: [
              if (language && needle.isEmpty)
                NodeLaneRow(
                  title: l10n.source_all_languages,
                  selected:
                      options.isNotEmpty &&
                      options.keys.every(selected.contains),
                  onTap: () =>
                      setState(() => draft[facet] = options.keys.toSet()),
                ),
              for (final option in visible)
                NodeLaneRow(
                  title: option.value,
                  selected: selected.contains(option.key),
                  onTap: () => choose(option.key),
                ),
              if (visible.isEmpty) NodeLaneRow(title: l10n.no_result),
            ],
          ),
        ],
      ),
    );
  }
}
