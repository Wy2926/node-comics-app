import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_empty_state.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class SettingOption<T> {
  const SettingOption(
    this.value,
    this.label, {
    this.subtitle,
    this.icon,
    this.leading,
    this.enabled = true,
  });
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
  final bool enabled;
}

/// The option itself distinguishes a nullable default from cancellation.
Future<SettingOption<T>?> showSettingChoice<T>(
  BuildContext anchor, {
  required String title,
  required T current,
  required List<SettingOption<T>> options,
  bool searchable = false,
  String? description,
  String? emptyMessage,
}) => NodeLaneBubbleFlow.edit<SettingOption<T>>(
  anchor,
  title: title,
  body: (_, finish) => SettingChoices(
    current: current,
    options: options,
    searchable: searchable,
    description: description,
    emptyMessage: emptyMessage,
    choose: finish,
  ),
);

class SettingChoices<T> extends StatefulWidget {
  const SettingChoices({
    super.key,
    required this.current,
    required this.options,
    this.searchable = false,
    this.description,
    this.emptyMessage,
    required this.choose,
  });
  final T current;
  final List<SettingOption<T>> options;
  final bool searchable;
  final String? description, emptyMessage;
  final ValueChanged<SettingOption<T>> choose;
  @override
  State<SettingChoices<T>> createState() => _ChoicesState<T>();
}

class _ChoicesState<T> extends State<SettingChoices<T>> {
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final options = query.isEmpty
        ? widget.options
        : widget.options
              .where(
                (o) => '${o.label} ${o.subtitle ?? ''}'.toLowerCase().contains(
                  query,
                ),
              )
              .toList();
    return CustomScrollView(
      primary: false,
      shrinkWrap: !widget.searchable && options.length <= 8,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        if (widget.searchable)
          NodeLanePinnedHeader(
            child: NodeLaneTextField.search(
              controller: _search,
              hint: context.l10n.search,
              clearLabel: context.l10n.reset,
              onClear: () => setState(_search.clear),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
          ),
        if (widget.description?.isNotEmpty == true)
          SliverToBoxAdapter(
            child: Padding(
              padding: NodeLaneTokens.groupPadding,
              child: Text(
                widget.description!,
                style: NodeLaneTokens.of(context).readerSecondary,
              ),
            ),
          ),
        if (options.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: NodeLaneTokens.groupPadding,
              child: NodeLaneEmptyState(
                icon: NodeLaneIcons.of(context).search,
                title: query.isEmpty
                    ? widget.emptyMessage ?? context.l10n.no_result
                    : context.l10n.no_result,
                action: query.isEmpty
                    ? null
                    : NodeLaneSecondaryButton(
                        onPressed: () => setState(_search.clear),
                        child: Text(context.l10n.search_clear),
                      ),
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          sliver: SliverList.builder(
            itemCount: options.length,
            itemBuilder: (_, index) {
              final option = options[index];
              return Semantics(
                inMutuallyExclusiveGroup: true,
                child: NodeLaneRow.card(
                  first: index == 0,
                  last: index == options.length - 1,
                  compact: true,
                  title: option.label,
                  subtitle: option.subtitle,
                  icon: option.icon,
                  leading: option.leading,
                  enabled: option.enabled,
                  selected: option.value == widget.current,
                  trailing: Icon(
                    option.value == widget.current
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: option.value == widget.current
                        ? NodeLaneTokens.of(context).accent
                        : NodeLaneTokens.of(context).muted,
                  ),
                  onTap: () => widget.choose(option),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<String?> showSettingText(
  BuildContext anchor, {
  required String title,
  required String initialValue,
  String? hint,
  String? helper,
  TextInputType keyboardType = TextInputType.text,
  bool Function(String)? isValid,
}) => NodeLaneBubbleFlow.edit<String>(
  anchor,
  title: title,
  body: (_, finish) => _TextDraft(
    title: title,
    initialValue: initialValue,
    hint: hint,
    helper: helper,
    keyboardType: keyboardType,
    isValid: isValid,
    finish: finish,
  ),
);

class _TextDraft extends StatefulWidget {
  const _TextDraft({
    required this.title,
    required this.initialValue,
    this.hint,
    this.helper,
    required this.keyboardType,
    this.isValid,
    required this.finish,
  });
  final String title, initialValue;
  final String? hint, helper;
  final TextInputType keyboardType;
  final bool Function(String)? isValid;
  final ValueChanged<String?> finish;
  @override
  State<_TextDraft> createState() => _TextDraftState();
}

class _TextDraftState extends State<_TextDraft> {
  late final _input = TextEditingController(text: widget.initialValue);
  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final valid = widget.isValid?.call(_input.text) ?? true;
    void confirm() {
      if (widget.isValid?.call(_input.text) ?? true) widget.finish(_input.text);
    }

    return LayoutBuilder(
      builder: (context, box) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              primary: false,
              padding: NodeLaneTokens.groupPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: NodeLaneTokens.space8,
                children: [
                  NodeLaneTextField(
                    controller: _input,
                    label: widget.title,
                    autofocus: true,
                    keyboardType: widget.keyboardType,
                    hint: widget.hint ?? '',
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    enableSuggestions: false,
                    onSubmitted: (_) => confirm(),
                    onChanged: (_) => setState(() {}),
                  ),
                  if (widget.helper?.isNotEmpty == true)
                    Text(
                      widget.helper!,
                      style: NodeLaneTokens.of(context).readerSecondary,
                    ),
                ],
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: box.maxHeight * .5),
            child: SingleChildScrollView(
              primary: false,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: OverflowBar(
                children: [
                  TextButton(
                    onPressed: () => widget.finish(null),
                    child: Text(context.l10n.cancel),
                  ),
                  FilledButton(
                    onPressed: valid ? confirm : null,
                    child: Text(context.l10n.dialog_confirm),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
