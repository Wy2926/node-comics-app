import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/widgets/nodelane_setting_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

Future<T?> showSourceChoice<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  required T? current,
  required List<SettingOption<T>> options,
}) async {
  if (options.isEmpty) return null;
  if (options.length <= 8 && !NodeLaneBubbleFlow.contains(context)) {
    final value = await showNodeLaneBubbleMenu<T>(
      context,
      label: title,
      items: [
        for (final o in options)
          CheckedPopupMenuItem<T>(
            value: o.value,
            checked: o.value == current,
            child: Text(o.label),
          ),
      ],
    );
    return value == current ? null : value;
  }
  final option = await showSettingChoice<T?>(
    context,
    title: title,
    current: current,
    options: options,
    searchable: options.length > 8,
    description: subtitle,
  );
  return option?.value == current ? null : option?.value;
}

Future<void> showSourceMultiChoice<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  required Set<T> current,
  required List<SettingOption<T>> options,
  required Future<bool> Function(Set<T>) onChanged,
}) => NodeLaneBubbleFlow.open<void>(
  context,
  title: title,
  child: _SourceMultiSelect<T>(
    title: title,
    subtitle: subtitle,
    options: options,
    initial: current,
    onChanged: onChanged,
  ),
);

class _SourceMultiSelect<T> extends StatefulWidget {
  const _SourceMultiSelect({
    required this.title,
    this.subtitle,
    required this.options,
    required this.initial,
    required this.onChanged,
  });
  final String title;
  final String? subtitle;
  final List<SettingOption<T>> options;
  final Set<T> initial;
  final Future<bool> Function(Set<T>) onChanged;
  @override
  State<_SourceMultiSelect<T>> createState() => _SourceMultiSelectState<T>();
}

class _SourceMultiSelectState<T> extends State<_SourceMultiSelect<T>> {
  final search = TextEditingController();
  late var selected = {...widget.initial};
  bool saving = false, failed = false;
  Future<void> toggle(T value) async {
    if (saving) return;
    final next = {...selected};
    if (!next.remove(value)) next.add(value);
    setState(() {
      saving = true;
      failed = false;
    });
    final saved = await widget.onChanged(next);
    if (mounted) {
      setState(() {
        if (saved) selected = next;
        failed = !saved;
        saving = false;
      });
    }
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), l = context.l10n;
    final needle = search.text.trim().toLowerCase();
    final filtered = widget.options
        .where((o) => o.label.toLowerCase().contains(needle))
        .toList();
    return MobileBrowsePage.form(
      title: widget.title,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          NodeLanePinnedHeader(
            child: NodeLaneTextField.search(
              controller: search,
              hint: l.bookshelf_search_options,
              onChanged: (_) => setState(() {}),
            ),
          ),
          SliverPadding(
            padding: NodeLaneTokens.pagePadding,
            sliver: SliverList.list(
              children: [
                if (widget.subtitle != null)
                  Text(widget.subtitle!, style: t.secondary),
                Text(
                  l.source_selected_count(selected.length),
                  style: t.readerSecondary,
                ),
                if (failed)
                  Text(
                    l.source_settings_save_failed,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                if (filtered.isEmpty) Text(l.no_result, style: t.secondary),
              ],
            ),
          ),
          SliverPadding(
            padding: NodeLaneTokens.pagePadding,
            sliver: SliverList.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final o = filtered[i];
                return NodeLaneRow.card(
                  first: i == 0,
                  last: i == filtered.length - 1,
                  title: o.label,
                  selected: selected.contains(o.value),
                  checkable: true,
                  compact: true,
                  enabled: !saving,
                  onTap: () => toggle(o.value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
