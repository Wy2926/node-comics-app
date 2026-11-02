import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/modules/browse/widgets/source_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// The extension's mutable filter objects must never be edited by a cancelled
/// route or while a request still holds the previously applied filter list.
List<dynamic> copySourceFilters(List<dynamic> filters) => filters
    .map(
      (value) => switch (value) {
        TextFilter f => TextFilter(f.type, f.name, f.typeName, state: f.state),
        CheckBoxFilter f => CheckBoxFilter(
          f.type,
          f.name,
          f.value,
          f.typeName,
          state: f.state,
        ),
        TriStateFilter f => TriStateFilter(
          f.type,
          f.name,
          f.value,
          f.typeName,
          state: f.state,
        ),
        SelectFilter f => SelectFilter(
          f.type,
          f.name,
          f.state,
          copySourceFilters(f.values),
          f.typeName,
        ),
        SelectFilterOption f => SelectFilterOption(f.name, f.value, f.typeName),
        GroupFilter f => GroupFilter(
          f.type,
          f.name,
          copySourceFilters(f.state),
          f.typeName,
        ),
        SortFilter f => SortFilter(
          f.type,
          f.name,
          SortState(f.state.index, f.state.ascending, f.state.typeName),
          copySourceFilters(f.values),
          f.typeName,
        ),
        HeaderFilter f => HeaderFilter(f.name, f.typeName, type: f.type),
        SeparatorFilter f => SeparatorFilter(f.typeName, type: f.type),
        _ => value, // Unknown values are retained without an editor.
      },
    )
    .toList();

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
      title: '站内筛选',
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
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: () => Navigator.pop(context, _draft),
              child: const Text('应用筛选'),
            ),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text('筛选项由当前网站提供', style: NodeLaneTokens.of(context).readerSecondary),
          const SizedBox(height: 16),
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
      : SourceGroup(children: children);
  Future<void> select(dynamic f) async {
    final int current = f is SortFilter ? f.state.index : f.state;
    final options = <SourceOption<int>>[
      for (var i = 0; i < f.values.length; i++)
        SourceOption(i, f.values[i].name as String),
    ];
    final value = await showSourceChoice<int>(
      context,
      title: f.name,
      current: current,
      options: options,
      hint: '应用筛选后生效。',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.filters.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: widget.nested ? 0 : 12),
            child: Builder(
              builder: (context) {
                final f = widget.filters[i];
                if (f is HeaderFilter) {
                  return Text(
                    f.name,
                    style: t.readerLabel.copyWith(fontWeight: FontWeight.w600),
                  );
                }
                if (f is SeparatorFilter) {
                  return Divider(height: 1, color: t.line);
                }
                if (f is TextFilter) {
                  return group(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextFormField(
                          initialValue: f.state,
                          onChanged: (v) => f.state = v,
                          style: t.readerLabel,
                          decoration: t
                              .searchDecoration(f.name)
                              .copyWith(labelText: f.name),
                        ),
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
                          title: f.name,
                          value: f.state,
                          segments: const [
                            ButtonSegment(value: 0, label: Text('不限')),
                            ButtonSegment(value: 1, label: Text('包含')),
                            ButtonSegment(value: 2, label: Text('排除')),
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
                      SourceRow(
                        title: f.name,
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
                      SourceRow(
                        title: f.name,
                        trailing: Icon(
                          expanded.contains(i) ? icons.down : icons.forward,
                          size: 16,
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
                  final label = n >= 0 && n < f.values.length
                      ? f.values[n].name as String
                      : null;
                  return group(
                    children: [
                      SourceRow(
                        title: f.name,
                        value: label,
                        onTap: f.values.isEmpty ? null : () => select(f),
                      ),
                      if (f is SortFilter)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: NodeLaneSegments<bool>(
                            value: f.state.ascending,
                            labelStyle: t.readerSecondary,
                            segments: const [
                              ButtonSegment(value: false, label: Text('降序')),
                              ButtonSegment(value: true, label: Text('升序')),
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
