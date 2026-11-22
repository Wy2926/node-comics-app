import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class NodeLaneNumberRow extends StatelessWidget {
  const NodeLaneNumberRow({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
    this.label,
    this.valueLabel,
    this.icon,
    this.enabled = true,
  });
  final String title;
  final int value, min, max, step;
  final String Function(int)? label;
  final String? valueLabel;
  final IconData? icon;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => NodeLaneNumberButton(
    title: title,
    value: value,
    min: min,
    max: max,
    step: step,
    enabled: enabled,
    label: label,
    onChanged: onChanged,
    builder: (context, open, _) => NodeLaneRow(
      title: title,
      icon: icon,
      enabled: enabled,
      openOnReveal: true,
      value: valueLabel ?? label?.call(value) ?? '$value',
      onOpen: open == null ? null : (_) => open(),
    ),
  );
}

class NodeLaneNumberButton extends StatelessWidget {
  const NodeLaneNumberButton({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.builder,
    this.step = 1,
    this.label,
    this.enabled = true,
    this.openOnMount = false,
    this.onClose,
  }) : assert(min <= max),
       assert(step > 0);
  final String title;
  final int value, min, max, step;
  final String Function(int)? label;
  final ValueChanged<int> onChanged;
  final Widget Function(BuildContext, VoidCallback?, bool) builder;
  final bool enabled, openOnMount;
  final VoidCallback? onClose;
  @override
  Widget build(BuildContext context) => NodeLaneLiveBubbleButton(
    title: title,
    enabled: enabled,
    openOnMount: openOnMount,
    onClose: onClose,
    builder: builder,
    editor: _NumberEditor(
      spec: this,
      write: (next) {
        if (!context.mounted) return;
        final current = context.widget as NodeLaneNumberButton;
        if (current.enabled && next != current.value) current.onChanged(next);
      },
    ),
  );
}

class _NumberEditor extends StatefulWidget {
  const _NumberEditor({required this.spec, required this.write});
  final NodeLaneNumberButton spec;
  final ValueChanged<int> write;
  @override
  State<_NumberEditor> createState() => _NumberEditorState();
}

class _NumberEditorState extends State<_NumberEditor> {
  int? _drag;
  @override
  Widget build(BuildContext context) {
    final s = widget.spec, t = NodeLaneTokens.of(context), l = context.l10n;
    final steps = (s.max - s.min) ~/ s.step;
    final index = (_drag ?? (s.value - s.min) ~/ s.step).clamp(0, steps);
    int at(int i) => s.min + i * s.step;
    String label(int i) => s.label?.call(at(i)) ?? '${at(i)}';
    return SingleChildScrollView(
      primary: false,
      padding: NodeLaneTokens.groupPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: l.decrease,
                icon: const Icon(Icons.remove),
                onPressed: s.enabled && index > 0
                    ? () => widget.write(at(index - 1))
                    : null,
              ),
              Expanded(
                child: Text(
                  label(index),
                  textAlign: TextAlign.center,
                  style: t.readerTitle.copyWith(color: t.accent),
                ),
              ),
              IconButton.filledTonal(
                tooltip: l.increase,
                icon: Icon(NodeLaneIcons.of(context).add),
                onPressed: s.enabled && index < steps
                    ? () => widget.write(at(index + 1))
                    : null,
              ),
            ],
          ),
          Slider(
            min: 0,
            max: steps.toDouble(),
            value: index.toDouble(),
            divisions: steps > 0 ? steps : null,
            semanticFormatterCallback: (v) => label(v.round()),
            onChanged: s.enabled && steps > 0
                ? (v) => setState(() => _drag = v.round())
                : null,
            onChangeEnd: (v) {
              setState(() => _drag = null);
              widget.write(at(v.round()));
            },
          ),
        ],
      ),
    );
  }
}
