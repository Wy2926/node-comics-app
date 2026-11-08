import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MobileSettingOption<T> {
  const MobileSettingOption(
    this.value,
    this.label, {
    this.subtitle,
    this.icon,
    this.leading,
  });
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
}

/// Returns the selected option, so a null-valued default remains distinct from
/// closing the page. The caller owns all preference writes.
Future<MobileSettingOption<T>?> showMobileSettingsPicker<T>(
  BuildContext context, {
  required String title,
  required T current,
  required List<MobileSettingOption<T>> options,
  bool searchable = false,
  String? description,
  String? emptyMessage,
}) => Navigator.of(context).push<MobileSettingOption<T>>(
  MaterialPageRoute(
    builder: (_) => _MobileSettingsPicker<T>(
      title: title,
      current: current,
      options: options,
      searchable: searchable,
      description: description,
      emptyMessage: emptyMessage,
    ),
  ),
);

class _MobileSettingsPicker<T> extends StatefulWidget {
  const _MobileSettingsPicker({
    required this.title,
    required this.current,
    required this.options,
    required this.searchable,
    this.description,
    this.emptyMessage,
  });
  final String title;
  final T current;
  final List<MobileSettingOption<T>> options;
  final bool searchable;
  final String? description;
  final String? emptyMessage;

  @override
  State<_MobileSettingsPicker<T>> createState() =>
      _MobileSettingsPickerState<T>();
}

class _MobileSettingsPickerState<T> extends State<_MobileSettingsPicker<T>> {
  final _search = TextEditingController();
  String _query = '';
  bool _leaving = false;

  void _choose(MobileSettingOption<T> option) {
    if (_leaving || !mounted || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    _leaving = true;
    Navigator.pop(context, option);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clear() {
    _search.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final colors = NodeLaneTokens.of(context);
    final l10n = context.l10n;
    final query = _query.trim().toLowerCase();
    final options = widget.options
        .where(
          (option) => '${option.label} ${option.subtitle ?? ''}'
              .toLowerCase()
              .contains(query),
        )
        .toList();
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(context, title: widget.title),
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              if (widget.description != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      NodeLaneTokens.space24,
                      NodeLaneTokens.space8,
                      NodeLaneTokens.space24,
                      NodeLaneTokens.space20,
                    ),
                    child: Text(
                      widget.description!,
                      style: colors.readerSecondary,
                    ),
                  ),
                ),
              if (widget.searchable)
                NodeLanePinnedHeader(
                  child: NodeLaneTextField.search(
                    controller: _search,
                    hint: l10n.search,
                    onChanged: (value) => setState(() => _query = value),
                    onClear: _clear,
                    clearLabel: l10n.reset,
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                  ),
                ),
              if (options.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: NodeLaneEmptyState(
                      icon: NodeLaneIcons.of(context).search,
                      title: query.isEmpty
                          ? widget.emptyMessage ?? l10n.no_result
                          : l10n.no_result,
                      message: query.isEmpty ? null : l10n.search_empty_hint,
                      action: query.isEmpty
                          ? null
                          : NodeLaneSecondaryButton(
                              onPressed: _clear,
                              child: Text(l10n.search_clear),
                            ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: NodeLaneTokens.pagePadding.copyWith(top: 0),
                  sliver: SliverList.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final selected = option.value == widget.current;
                      return Semantics(
                        selected: selected,
                        inMutuallyExclusiveGroup: true,
                        child: NodeLaneRow.card(
                          title: option.label,
                          subtitle: option.subtitle,
                          icon: option.icon,
                          leading: option.leading,
                          selected: selected,
                          first: index == 0,
                          last: index == options.length - 1,
                          minHeight: NodeLaneTokens.rowHeight,
                          trailing: SizedBox(
                            width: NodeLaneTokens.iconSize,
                            child: selected
                                ? Icon(
                                    NodeLaneIcons.of(context).check,
                                    color: colors.accent,
                                    size: NodeLaneTokens.iconSize,
                                  )
                                : null,
                          ),
                          onTap: () => _choose(option),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
