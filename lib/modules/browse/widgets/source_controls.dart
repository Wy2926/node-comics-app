import 'package:flutter/material.dart';
import 'package:mangayomi/modules/browse/widgets/mobile_browse_page.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_text_dialog.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

typedef SourceOption<T> = MobileSettingOption<T>;

Future<T?> showSourceChoice<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  required T? current,
  required List<SourceOption<T>> options,
  String? hint,
}) async {
  final option = await showMobileSettingsPicker<T?>(
    context,
    title: title,
    current: current,
    options: options,
    searchable: options.length > 8,
    description: [
      ?subtitle,
      hint ?? context.l10n.settings_immediate_choice,
    ].join('\n'),
  );
  return option?.value == current ? null : option?.value;
}

Future<Set<T>?> showSourceMultiChoice<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  required Set<T> current,
  required List<SourceOption<T>> options,
}) => pushBrowsePage<Set<T>>(
  context,
  _SourceMultiSelect<T>(
    title: title,
    subtitle: subtitle,
    options: options,
    initial: current,
  ),
);

class _SourceMultiSelect<T> extends StatefulWidget {
  const _SourceMultiSelect({
    required this.title,
    this.subtitle,
    required this.options,
    required this.initial,
  });
  final String title;
  final String? subtitle;
  final List<SourceOption<T>> options;
  final Set<T> initial;
  @override
  State<_SourceMultiSelect<T>> createState() => _SourceMultiSelectState<T>();
}

class _SourceMultiSelectState<T> extends State<_SourceMultiSelect<T>> {
  final search = TextEditingController();
  late final selected = {...widget.initial};
  bool leaving = false;
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
                  onTap: () => setState(() {
                    if (!selected.remove(o.value)) selected.add(o.value);
                  }),
                );
              },
            ),
          ),
        ],
      ),
      bottomAction: FilledButton(
        onPressed: () {
          if (leaving) return;
          leaving = true;
          Navigator.pop(context, {...selected});
        },
        child: Text(l.save),
      ),
    );
  }
}

Future<String?> showSourceTextEditor(
  BuildContext context, {
  required String title,
  String? subtitle,
  String? description,
  required String initialValue,
  bool allowEmpty = true,
}) => showDialog<String>(
  context: context,
  builder: (_) => MobileSettingsTextDialog(
    title: title,
    initialValue: initialValue,
    helper: [?subtitle, ?description].where((s) => s.isNotEmpty).join('\n'),
    isValid: (text) => allowEmpty || text.trim().isNotEmpty,
  ),
);
