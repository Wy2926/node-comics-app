import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/language.dart';

enum SourceSearchScopeMode {
  all,
  pinned,
  custom;

  String label(AppLocalizations l10n) => switch (this) {
    all => l10n.source_all_websites,
    pinned => l10n.source_pinned_websites,
    custom => l10n.source_custom_websites,
  };
  String shortLabel(AppLocalizations l10n) => switch (this) {
    all => l10n.bookshelf_all,
    pinned => l10n.settings_frequent,
    custom => l10n.source_custom_scope,
  };
}

class SourceSearchScope {
  const SourceSearchScope({
    this.mode = SourceSearchScopeMode.all,
    this.ids = const {},
  });
  final SourceSearchScopeMode mode;
  final Set<int> ids;

  bool includes(Source source) => switch (mode) {
    SourceSearchScopeMode.all => true,
    SourceSearchScopeMode.pinned => source.isPinned == true,
    SourceSearchScopeMode.custom => ids.contains(source.id),
  };
}

/// Selection is a local draft; leaving without applying changes nothing.
class SourceSearchScopeSheet extends StatefulWidget {
  const SourceSearchScopeSheet({
    super.key,
    required this.sources,
    required this.current,
  });
  final List<Source> sources;
  final SourceSearchScope current;
  @override
  State<SourceSearchScopeSheet> createState() => _SourceSearchScopeSheetState();
}

class _SourceSearchScopeSheetState extends State<SourceSearchScopeSheet> {
  final search = TextEditingController();
  late final selected = widget.sources
      .where(widget.current.includes)
      .map((s) => s.id)
      .whereType<int>()
      .toSet();
  late var mode = widget.current.mode;
  bool leaving = false;

  SourceSearchScope get draft => SourceSearchScope(mode: mode, ids: selected);

  void _toggle(Source source) => setState(() {
    // Editing a preset starts from exactly the websites it currently includes.
    if (mode != SourceSearchScopeMode.custom) {
      final ids = widget.sources.where(draft.includes).map((s) => s.id);
      selected
        ..clear()
        ..addAll(ids.whereType<int>());
      mode = SourceSearchScopeMode.custom;
    }
    final id = source.id;
    if (id != null && !selected.remove(id)) selected.add(id);
  });

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    final keyword = search.text.trim().toLowerCase();
    final matches = widget.sources
        .where(
          (s) => '${s.name ?? ''} ${completeLanguageName(s.lang ?? '')}'
              .toLowerCase()
              .contains(keyword),
        )
        .toList();
    final count = widget.sources.where(draft.includes).length;
    final allMatchesSelected =
        matches.isNotEmpty && matches.every(draft.includes);
    return NodeLaneCatalogSheet(
      title: context.l10n.search_scope,
      subtitle: context.l10n.search_scope_hint,
      fitContent: true,
      heightFactor: NodeLaneTokens.readerDisplayFraction,
      bottom: FilledButton(
        onPressed: count == 0
            ? null
            : () {
                if (leaving) return;
                leaving = true;
                Navigator.pop(
                  context,
                  SourceSearchScope(mode: mode, ids: {...selected}),
                );
              },
        child: Text(
          context.l10n.search_websites_action(count),
          textAlign: TextAlign.center,
        ),
      ),
      child: CustomScrollView(
        shrinkWrap: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              NodeLaneTokens.gutter,
              NodeLaneTokens.space8,
              NodeLaneTokens.gutter,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NodeLaneSegments<SourceSearchScopeMode>(
                    value: mode,
                    pill: true,
                    segments: [
                      for (final option in SourceSearchScopeMode.values)
                        ButtonSegment(
                          value: option,
                          label: Text(option.shortLabel(context.l10n)),
                        ),
                    ],
                    onChanged: (value) => setState(() => mode = value),
                  ),
                  const SizedBox(height: NodeLaneTokens.space16),
                  NodeLaneTextField.search(
                    controller: search,
                    hint: context.l10n.search_find_website,
                    onChanged: (_) => setState(() {}),
                    onClear: () => setState(search.clear),
                  ),
                  const SizedBox(height: NodeLaneTokens.space8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.search_selected_websites(count),
                          style: t.readerSecondary,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: matches.isEmpty
                            ? null
                            : () => setState(() {
                                final ids = widget.sources
                                    .where(draft.includes)
                                    .map((s) => s.id)
                                    .whereType<int>()
                                    .toSet();
                                final visible = matches
                                    .map((s) => s.id)
                                    .whereType<int>();
                                allMatchesSelected
                                    ? ids.removeAll(visible)
                                    : ids.addAll(visible);
                                selected
                                  ..clear()
                                  ..addAll(ids);
                                mode = SourceSearchScopeMode.custom;
                              }),
                        child: Text(
                          allMatchesSelected
                              ? (keyword.isEmpty
                                    ? context.l10n.action_clear
                                    : context.l10n.search_deselect_results)
                              : (keyword.isEmpty
                                    ? context.l10n.bookshelf_select_all
                                    : context.l10n.search_select_results),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: NodeLaneTokens.gutter,
            ),
            sliver: SliverList.builder(
              itemCount: matches.length,
              itemBuilder: (context, i) {
                final source = matches[i];
                return NodeLaneRow.card(
                  first: i == 0,
                  last: i == matches.length - 1,
                  minHeight: NodeLaneTokens.rowHeight,
                  title: source.name ?? '',
                  icon: NodeLaneIcons.of(context).web,
                  subtitle: [
                    if ((source.lang ?? '').isNotEmpty)
                      completeLanguageName(source.lang!),
                    if (source.isPinned == true) context.l10n.settings_frequent,
                  ].join(' · '),
                  checkable: true,
                  highlightSelected: false,
                  selected: draft.includes(source),
                  onTap: () => _toggle(source),
                );
              },
            ),
          ),
          if (matches.isEmpty || count == 0)
            SliverPadding(
              padding: const EdgeInsets.all(NodeLaneTokens.gutter),
              sliver: SliverToBoxAdapter(
                child: Text(
                  matches.isEmpty
                      ? context.l10n.search_no_websites_hint
                      : context.l10n.search_select_website_hint,
                  style: t.readerSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
