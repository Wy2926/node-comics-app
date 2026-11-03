import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/modules/browse/widgets/source_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

import 'source_filter_labels.dart';

class MobileSourceFilterSheet extends StatefulWidget {
  const MobileSourceFilterSheet({
    super.key,
    required this.filters,
    required this.defaults,
    this.sourceName,
  });
  final List<dynamic> filters;
  final String? sourceName;
  final List<dynamic> Function() defaults;

  @override
  State<MobileSourceFilterSheet> createState() =>
      _MobileSourceFilterSheetState();
}

class _MobileSourceFilterSheetState extends State<MobileSourceFilterSheet> {
  late List<dynamic> _draft = copySourceFilters(widget.filters);
  int _resetVersion = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NodeLaneCatalogSheet(
      title: l10n.filter,
      subtitle: widget.sourceName,
      heightFactor: .82,
      bottom: Row(
        children: [
          NodeLaneSecondaryButton(
            onPressed: () => setState(() {
              _draft = copySourceFilters(widget.defaults());
              _resetVersion++;
            }),
            child: Text(l10n.reset),
          ),
          const SizedBox(width: NodeLaneTokens.space12),
          Expanded(
            child: FilledButton(
              onPressed: () => Navigator.pop(context, _draft),
              child: Text(l10n.source_filter_apply),
            ),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: NodeLaneTokens.gutter),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text(
            l10n.source_filter_scope,
            style: NodeLaneTokens.of(context).readerSecondary,
          ),
          const SizedBox(height: NodeLaneTokens.space16),
          SourceFilterFields(key: ValueKey(_resetVersion), filters: _draft),
        ],
      ),
    );
  }
}

/// Uses the adapter's existing filter objects inside an isolated draft.
class SourceFilterFields extends StatefulWidget {
  const SourceFilterFields({
    super.key,
    required this.filters,
    this.nested = false,
  });
  final List<dynamic> filters;
  final bool nested;
  @override
  State<SourceFilterFields> createState() => _SourceFilterFieldsState();
}

class _SourceFilterFieldsState extends State<SourceFilterFields> {
  late final expanded = <int>{
    for (var i = 0; i < widget.filters.length; i++)
      if (widget.filters[i] is GroupFilter &&
          (widget.filters[i] as GroupFilter).state.length <= 6)
        i,
  };
  Widget group({required List<Widget> children}) => widget.nested
      ? Column(children: children)
      : NodeLaneGroupSurface(children: children);
  Future<void> select(dynamic f) async {
    final l10n = context.l10n;
    final int current = f is SortFilter ? f.state.index : f.state;
    final options = <SourceOption<int>>[
      for (var i = 0; i < f.values.length; i++)
        SourceOption(i, sourceFilterLabel(l10n, f.values[i].name as String)),
    ];
    final value = await showSourceChoice<int>(
      context,
      title: sourceFilterLabel(l10n, f.name),
      current: current,
      options: options,
      hint: l10n.source_filter_apply_hint,
    );
    if (mounted && value != null) {
      setState(() {
        if (f is SortFilter) {
          f.state.index = value;
        } else {
          f.state = value;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final l10n = context.l10n;
    String label(String value) => sourceFilterLabel(l10n, value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.filters.length; i++)
          if (i == 0 ||
              widget.filters[i] is! TextFilter ||
              widget.filters[i - 1] is! TextFilter)
            Padding(
              padding: EdgeInsets.only(
                bottom: widget.nested ? 0 : NodeLaneTokens.space16,
              ),
              child: Builder(
                builder: (context) {
                  final f = widget.filters[i];
                  if (f is HeaderFilter) {
                    return Text(
                      label(f.name),
                      style: t.readerLabel.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }
                  if (f is SeparatorFilter) {
                    return Divider(height: 1, color: t.line);
                  }
                  if (f is TextFilter) {
                    return NodeLaneGroupSurface(
                      first: !widget.nested,
                      last: !widget.nested,
                      children: [
                        for (
                          var j = i;
                          j < widget.filters.length &&
                              widget.filters[j] is TextFilter;
                          j++
                        )
                          NodeLaneTextField(
                            key: ValueKey(j),
                            initialValue:
                                (widget.filters[j] as TextFilter).state,
                            label: label(
                              (widget.filters[j] as TextFilter).name,
                            ),
                            hint: l10n.bookshelf_filter_any,
                            inGroup: true,
                            textInputAction:
                                j + 1 < widget.filters.length &&
                                    widget.filters[j + 1] is TextFilter
                                ? TextInputAction.next
                                : TextInputAction.done,
                            onChanged: (v) =>
                                (widget.filters[j] as TextFilter).state = v,
                          ),
                      ],
                    );
                  }
                  if (f is TriStateFilter) {
                    return group(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: NodeLaneChoiceRow<int>(
                            title: label(f.name),
                            value: f.state,
                            segments: [
                              ButtonSegment(
                                value: 0,
                                label: Text(l10n.bookshelf_filter_any),
                              ),
                              ButtonSegment(
                                value: 1,
                                label: Text(l10n.bookshelf_filter_include),
                              ),
                              ButtonSegment(
                                value: 2,
                                label: Text(l10n.bookshelf_filter_exclude),
                              ),
                            ],
                            onChanged: (v) => setState(() => f.state = v),
                          ),
                        ),
                      ],
                    );
                  }
                  if (f is CheckBoxFilter) {
                    return group(
                      children: [
                        NodeLaneRow(
                          title: label(f.name),
                          trailing: Switch.adaptive(
                            value: f.state,
                            onChanged: (v) => setState(() => f.state = v),
                          ),
                        ),
                      ],
                    );
                  }
                  if (f is GroupFilter) {
                    return group(
                      children: [
                        NodeLaneRow(
                          title: label(f.name),
                          trailing: Icon(
                            expanded.contains(i) ? icons.down : icons.forward,
                            size: NodeLaneTokens.smallIconSize,
                            color: t.muted,
                          ),
                          onTap: () => setState(() {
                            if (!expanded.remove(i)) expanded.add(i);
                          }),
                        ),
                        if (expanded.contains(i))
                          SourceFilterFields(filters: f.state, nested: true),
                      ],
                    );
                  }
                  if (f is SelectFilter || f is SortFilter) {
                    final int n = f is SortFilter ? f.state.index : f.state;
                    final selectedLabel = n >= 0 && n < f.values.length
                        ? label(f.values[n].name as String)
                        : null;
                    return group(
                      children: [
                        NodeLaneRow(
                          title: label(f.name),
                          value: selectedLabel,
                          onTap: f.values.isEmpty ? null : () => select(f),
                        ),
                        if (f is SortFilter)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: NodeLaneSegments<bool>(
                              value: f.state.ascending,
                              labelStyle: t.readerSecondary,
                              segments: [
                                ButtonSegment(
                                  value: false,
                                  label: Text(l10n.bookshelf_sort_descending),
                                ),
                                ButtonSegment(
                                  value: true,
                                  label: Text(l10n.bookshelf_sort_ascending),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => f.state.ascending = v),
                            ),
                          ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
      ],
    );
  }
}
