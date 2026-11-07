import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/language.dart';

enum SourceSearchScopeMode {
  all('全部网站', '全部'),
  pinned('常用网站', '常用'),
  custom('自选网站', '自选');

  const SourceSearchScopeMode(this.label, this.shortLabel);
  final String label, shortLabel;
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
      title: '搜索范围',
      subtitle: '选择本次要搜索的网站',
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
        child: Text('搜索这 $count 个网站', textAlign: TextAlign.center),
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
                          label: Text(option.shortLabel),
                        ),
                    ],
                    onChanged: (value) => setState(() => mode = value),
                  ),
                  const SizedBox(height: NodeLaneTokens.space16),
                  NodeLaneTextField.search(
                    controller: search,
                    hint: '查找网站',
                    onChanged: (_) => setState(() {}),
                    onClear: () => setState(search.clear),
                  ),
                  const SizedBox(height: NodeLaneTokens.space8),
                  Row(
                    children: [
                      Expanded(
                        child: Text('已选 $count 个网站', style: t.readerSecondary),
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
                              ? (keyword.isEmpty ? '清空' : '取消当前结果')
                              : (keyword.isEmpty ? '全选' : '选中当前结果'),
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
                    if (source.isPinned == true) '常用',
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
                  matches.isEmpty ? '没有匹配的网站，试试其他名称或语言。' : '至少选择一个网站后即可搜索。',
                  style: t.readerSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
