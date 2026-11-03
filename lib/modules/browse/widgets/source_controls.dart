import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class SourceOption<T> {
  const SourceOption(this.value, this.label, {this.subtitle});
  final T value;
  final String label;
  final String? subtitle;
}

Future<T?> showSourceChoice<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  required T? current,
  required List<SourceOption<T>> options,
  String hint = '选择后立即生效。',
}) => showNodeLaneCatalogSheet<T>(
  context,
  _SourceSelection<T>(
    title: title,
    subtitle: subtitle,
    options: options,
    initial: {?current},
    multiple: false,
    hint: hint,
  ),
);

Future<Set<T>?> showSourceMultiChoice<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  required Set<T> current,
  required List<SourceOption<T>> options,
  String? allLabel,
  String? saveLabel,
  bool reset = false,
}) => showNodeLaneCatalogSheet<Set<T>>(
  context,
  _SourceSelection<T>(
    title: title,
    subtitle: subtitle,
    options: options,
    initial: current,
    multiple: true,
    allLabel: allLabel,
    saveLabel: saveLabel,
    reset: reset,
  ),
);

class _SourceSelection<T> extends StatefulWidget {
  const _SourceSelection({
    required this.title,
    required this.options,
    required this.initial,
    required this.multiple,
    this.subtitle,
    this.allLabel,
    this.saveLabel,
    this.reset = false,
    this.hint,
  });
  final String title;
  final String? subtitle, allLabel, saveLabel, hint;
  final List<SourceOption<T>> options;
  final Set<T> initial;
  final bool multiple, reset;
  @override
  State<_SourceSelection<T>> createState() => _SourceSelectionState<T>();
}

class _SourceSelectionState<T> extends State<_SourceSelection<T>> {
  final search = TextEditingController();
  late final selected = {...widget.initial};
  bool leaving = false;
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void selectAll() => setState(() {
    selected
      ..clear()
      ..addAll(widget.options.map((o) => o.value));
  });

  void choose(T value) {
    if (leaving) return;
    if (widget.multiple) {
      setState(() {
        if (!selected.remove(value)) selected.add(value);
      });
    } else {
      leaving = true;
      Navigator.pop(context, widget.initial.contains(value) ? null : value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), l10n = context.l10n;
    final filtered = widget.options
        .where(
          (o) =>
              o.label.toLowerCase().contains(search.text.trim().toLowerCase()),
        )
        .toList();
    final searchable = widget.multiple || widget.options.length > 8;
    return NodeLaneCatalogSheet(
      title: widget.title,
      subtitle: widget.subtitle,
      heightFactor: searchable
          ? .65
          : (.28 + widget.options.length * .06).clamp(.43, .78),
      bottom: widget.multiple
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.allLabel == null) ...[
                  Text('已选择 ${selected.length} 项', style: t.readerSecondary),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    if (widget.reset)
                      NodeLaneSecondaryButton(
                        onPressed: selectAll,
                        child: Text(l10n.reset),
                      )
                    else
                      Expanded(
                        child: NodeLaneSecondaryButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.cancel),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (leaving) return;
                          leaving = true;
                          Navigator.pop(context, {...selected});
                        },
                        child: Text(widget.saveLabel ?? '保存'),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : null,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          if (searchable) ...[
            NodeLaneTextField.search(
              controller: search,
              hint: widget.allLabel == null ? '搜索选项' : '搜索语言',
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
          ],
          NodeLaneGroupSurface(
            children: [
              if (widget.allLabel != null && search.text.isEmpty)
                NodeLaneRow(
                  title: widget.allLabel!,
                  selected: widget.options.every(
                    (o) => selected.contains(o.value),
                  ),
                  onTap: selectAll,
                ),
              for (final option in filtered)
                NodeLaneRow(
                  title: option.label,
                  subtitle: option.subtitle,
                  selected: selected.contains(option.value),
                  onTap: () => choose(option.value),
                ),
            ],
          ),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(l10n.no_result, style: t.readerSecondary),
            ),
          if (!widget.multiple)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(widget.hint ?? '', style: t.readerSecondary),
            ),
        ],
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
}) => showNodeLaneCatalogSheet<String>(
  context,
  SourceTextEditor(
    title: title,
    subtitle: subtitle,
    description: description,
    initialValue: initialValue,
    allowEmpty: allowEmpty,
  ),
);

class SourceTextEditor extends StatefulWidget {
  const SourceTextEditor({
    super.key,
    required this.title,
    required this.initialValue,
    this.subtitle,
    this.description,
    this.allowEmpty = true,
  });
  final String title, initialValue;
  final String? subtitle, description;
  final bool allowEmpty;
  @override
  State<SourceTextEditor> createState() => _SourceTextEditorState();
}

class _SourceTextEditorState extends State<SourceTextEditor> {
  late final controller = TextEditingController(text: widget.initialValue);
  bool leaving = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context);
    return NodeLaneCatalogSheet(
      title: widget.title,
      subtitle: widget.subtitle,
      heightFactor: .43,
      bottom: Row(
        children: [
          Expanded(
            child: NodeLaneSecondaryButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: !widget.allowEmpty && controller.text.trim().isEmpty
                  ? null
                  : () {
                      if (leaving) return;
                      leaving = true;
                      Navigator.pop(context, controller.text);
                    },
              child: const Text('保存'),
            ),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          if (widget.description?.isNotEmpty == true) ...[
            Text(widget.description!, style: t.readerSecondary),
            const SizedBox(height: 16),
          ],
          NodeLaneTextField(
            controller: controller,
            hint: widget.title,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
