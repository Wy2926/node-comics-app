import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/manga/home/widget/filter_widget.dart';
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
        _ =>
          value, // Unknown values are retained; FilterWidget cannot edit them.
      },
    )
    .toList();

class MobileSourceFilterPage extends StatefulWidget {
  const MobileSourceFilterPage({
    super.key,
    required this.filters,
    required this.defaults,
  });
  final List<dynamic> filters;
  final List<dynamic> Function() defaults;

  @override
  State<MobileSourceFilterPage> createState() => _MobileSourceFilterPageState();
}

class _MobileSourceFilterPageState extends State<MobileSourceFilterPage> {
  late List<dynamic> _draft = copySourceFilters(widget.filters);
  int _resetVersion = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MobileBrowsePage(
      title: l10n.filter,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: FilterWidget(
          key: ValueKey(_resetVersion),
          mobile: true,
          filterList: _draft,
          onChanged: (value) => setState(() => _draft = value),
        ),
      ),
      bottomAction: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 12,
          runSpacing: 8,
          children: [
            TextButton(
              onPressed: () => setState(() {
                _draft = copySourceFilters(widget.defaults());
                _resetVersion++;
              }),
              child: Text(l10n.reset),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, _draft),
              child: Text(l10n.filter),
            ),
          ],
        ),
      ),
    );
  }
}
