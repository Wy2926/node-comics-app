import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extension_preferences_providers.dart';
import 'package:mangayomi/modules/browse/widgets/source_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class SourcePreferenceWidget extends StatefulWidget {
  const SourcePreferenceWidget({
    super.key,
    required this.sourcePreference,
    required this.source,
    this.onSave,
  });
  final List<SourcePreference> sourcePreference;
  final Source source;
  final Future<void> Function(SourcePreference, Source)? onSave;
  @override
  State<SourcePreferenceWidget> createState() => _SourcePreferenceWidgetState();
}

class _SourcePreferenceWidgetState extends State<SourcePreferenceWidget> {
  late List<SourcePreference> values = [...widget.sourcePreference];
  bool saving = false;
  int revision = 0;
  String? error;
  bool get mobile => isMobile && !isTv;

  @override
  void didUpdateWidget(SourcePreferenceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source.id != widget.source.id ||
        !identical(oldWidget.sourcePreference, widget.sourcePreference)) {
      revision++;
      values = [...widget.sourcePreference];
      error = null;
    }
  }

  Future<void> save(int index, void Function(SourcePreference) change) async {
    if (saving) return;
    final source = widget.source, generation = revision;
    final copy = SourcePreference.fromJson(values[index].toJson());
    change(copy);
    setState(() {
      saving = true;
      error = null;
    });
    try {
      await (widget.onSave ?? savePreferenceSetting)(copy, source);
      if (mounted && revision == generation) {
        setState(() => values[index] = copy);
      }
    } catch (_) {
      if (mounted && revision == generation) {
        setState(() => error = context.l10n.source_settings_save_failed);
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> edit(int i) async {
    if (saving) return;
    final pref = values[i], owner = revision;
    final subtitle = widget.source.name;
    if (pref.editTextPreference case final text?) {
      final result = mobile
          ? await showSourceTextEditor(
              context,
              title: text.dialogTitle?.isNotEmpty == true
                  ? text.dialogTitle!
                  : text.title ?? '',
              subtitle: subtitle,
              description: text.dialogMessage,
              initialValue: text.value ?? '',
            )
          : await showDialog<String>(
              context: context,
              builder: (_) => EditTextDialogWidget(
                text: text.value ?? '',
                dialogTitle: text.dialogTitle ?? text.title ?? '',
                dialogMessage: text.dialogMessage ?? '',
                onChanged: (v) {},
                returnValue: true,
              ),
            );
      if (mounted &&
          owner == revision &&
          result != null &&
          result != text.value) {
        await save(i, (p) => p.editTextPreference!.value = result);
      }
    } else if (pref.listPreference case final list?) {
      final options = [
        for (var n = 0; n < (list.entries?.length ?? 0); n++)
          SourceOption(n, list.entries![n]),
      ];
      final result = mobile
          ? await showSourceChoice<int>(
              context,
              title: list.title ?? '',
              subtitle: subtitle,
              current: list.valueIndex,
              options: options,
            )
          : await showDialog<int>(
              context: context,
              builder: (ctx) => SimpleDialog(
                title: Text(list.title ?? ''),
                children: [
                  for (final o in options)
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(ctx, o.value),
                      child: Text(o.label),
                    ),
                ],
              ),
            );
      if (mounted &&
          owner == revision &&
          result != null &&
          result != list.valueIndex) {
        await save(i, (p) => p.listPreference!.valueIndex = result);
      }
    } else if (pref.multiSelectListPreference case final list?) {
      final entries = list.entries ?? [], keys = list.entryValues ?? [];
      final options = [
        for (var n = 0; n < entries.length && n < keys.length; n++)
          SourceOption(keys[n], entries[n]),
      ];
      final result = await showSourceMultiChoice<String>(
        context,
        title: list.title ?? '',
        subtitle: subtitle,
        current: {...?list.values},
        options: options,
      );
      if (mounted &&
          owner == revision &&
          result != null &&
          !setEquals(result, {...?list.values})) {
        await save(
          i,
          (p) => p.multiSelectListPreference!.values = result.toList(),
        );
      }
    }
  }

  Widget row(int i) {
    final p = values[i];
    String title = '', summary = '';
    IconData icon = NodeLaneIcons.of(context).settings;
    bool? checked;
    if (p.editTextPreference case final v?) {
      title = v.title ?? '';
      summary = v.summary ?? '';
      icon = NodeLaneIcons.of(context).edit;
    } else if (p.listPreference case final v?) {
      title = v.title ?? '';
      final n = v.valueIndex;
      summary = n != null && n >= 0 && n < (v.entries?.length ?? 0)
          ? v.entries![n]
          : '';
      icon = NodeLaneIcons.of(context).chapters;
    } else if (p.multiSelectListPreference case final v?) {
      title = v.title ?? '';
      summary = [
        for (
          var j = 0;
          j < (v.entries?.length ?? 0) && j < (v.entryValues?.length ?? 0);
          j++
        )
          if (v.values?.contains(v.entryValues![j]) == true) v.entries![j],
      ].join('、');
      icon = NodeLaneIcons.of(context).chapters;
    } else if (p.checkBoxPreference case final v?) {
      title = v.title ?? '';
      summary = v.summary ?? '';
      checked = v.value ?? false;
    } else if (p.switchPreferenceCompat case final v?) {
      title = v.title ?? '';
      summary = v.summary ?? '';
      checked = v.value ?? false;
    } else {
      return const SizedBox.shrink();
    }
    final toggle = checked == null
        ? null
        : NodeLaneSwitch(
            value: checked,
            onChanged: saving
                ? null
                : (v) => save(i, (copy) {
                    if (copy.checkBoxPreference != null) {
                      copy.checkBoxPreference!.value = v;
                    } else {
                      copy.switchPreferenceCompat!.value = v;
                    }
                  }),
          );
    if (mobile) {
      return NodeLaneRow(
        title: title,
        subtitle: checked != null || p.editTextPreference != null
            ? summary
            : null,
        value: checked == null && p.editTextPreference == null ? summary : null,
        icon: icon,
        trailing: toggle,
        onTap: saving || checked != null ? null : () => edit(i),
      );
    }
    return ListTile(
      title: Text(title),
      subtitle: Text(summary),
      trailing: toggle,
      onTap: saving || checked != null ? null : () => edit(i),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (mobile)
        NodeLaneGroupSurface(
          children: [for (var i = 0; i < values.length; i++) row(i)],
        )
      else ...[
        for (var i = 0; i < values.length; i++) row(i),
      ],
      if (saving) const LinearProgressIndicator(),
      if (error != null)
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            error!,
            style: NodeLaneTokens.of(context).readerSecondary,
          ),
        ),
    ],
  );
}

class EditTextDialogWidget extends StatefulWidget {
  final String text;
  final String dialogTitle;
  final String dialogMessage;
  final Function(String) onChanged;
  final bool returnValue;
  const EditTextDialogWidget({
    super.key,
    required this.text,
    required this.onChanged,
    this.returnValue = false,
    required this.dialogTitle,
    required this.dialogMessage,
  });

  @override
  State<EditTextDialogWidget> createState() => _EditTextDialogWidgetState();
}

class _EditTextDialogWidgetState extends State<EditTextDialogWidget> {
  late final _controller = TextEditingController(text: widget.text);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.dialogTitle),
          Text(widget.dialogMessage, style: const TextStyle(fontSize: 13)),
        ],
      ),
      content: NodeLaneTextField(controller: _controller),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            widget.onChanged(_controller.text);
            Navigator.pop(
              context,
              widget.returnValue ? _controller.text : null,
            );
          },
          child: Text(context.l10n.ok),
        ),
      ],
    );
  }
}
