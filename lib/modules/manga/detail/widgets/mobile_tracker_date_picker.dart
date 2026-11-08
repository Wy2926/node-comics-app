import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Keeps the stock calendar and localized date input in a scrollable phone
/// route, without the fixed-height header/actions of DatePickerDialog.
class MobileTrackerDatePicker extends StatefulWidget {
  const MobileTrackerDatePicker({
    super.key,
    required this.title,
    required this.initial,
    required this.first,
    required this.last,
  });
  final String title;
  final DateTime initial, first, last;
  @override
  State<MobileTrackerDatePicker> createState() =>
      _MobileTrackerDatePickerState();
}

class _MobileTrackerDatePickerState extends State<MobileTrackerDatePicker> {
  late DateTime _selected = widget.initial;
  // The editable draft is independent of localization/theme rebuilds.
  final _dateInput = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _input = false;

  @override
  void dispose() {
    _dateInput.dispose();
    super.dispose();
  }

  bool _readInput() {
    if (!_form.currentState!.validate()) return false;
    _selected = MaterialLocalizations.of(context)
        .parseCompactDate(_dateInput.text)!;
    return true;
  }

  void _confirm() {
    if (_input && !_readInput()) return;
    Navigator.pop(context, _selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final material = MaterialLocalizations.of(context);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(context, title: widget.title),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(
                material.formatFullDate(_selected),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  if (_input) {
                    _readInput();
                  } else {
                    _dateInput.text = material.formatCompactDate(_selected);
                  }
                  FocusScope.of(context).unfocus();
                  setState(() => _input = !_input);
                },
                icon: Icon(
                  _input
                      ? NodeLaneIcons.of(context).calendar
                      : NodeLaneIcons.of(context).edit,
                ),
                label: Text(
                  _input
                      ? material.calendarModeButtonLabel
                      : material.inputDateModeButtonLabel,
                ),
              ),
              const SizedBox(height: 16),
              if (_input)
                Form(
                  key: _form,
                  child: NodeLaneTextField(
                    controller: _dateInput,
                    label: material.dateInputLabel,
                    hint: material.dateHelpText,
                    keyboardType: TextInputType.datetime,
                    autofocus: true,
                    validator: (text) {
                      final date = material.parseCompactDate(text ?? '');
                      if (date == null) return material.invalidDateFormatLabel;
                      if (date.isBefore(widget.first) ||
                          date.isAfter(widget.last)) {
                        return material.dateOutOfRangeLabel;
                      }
                      return null;
                    },
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    // The stock calendar caps day text scaling at 2, but narrow
                    // seven-column layouts can still wrap two-digit dates. Bound
                    // only the calendar; the full date and input keep system size.
                    final style =
                        DatePickerTheme.of(context).dayStyle ??
                        DatePickerTheme.defaults(context).dayStyle;
                    final measure = TextPainter(
                      text: TextSpan(text: '88', style: style),
                      textDirection: Directionality.of(context),
                    )..layout();
                    final scale = math.min(
                      2.0,
                      math.max(
                        1.0,
                        ((constraints.maxWidth - 32) / 7 - 16) / measure.width,
                      ),
                    );
                    measure.dispose();
                    return MediaQuery.withClampedTextScaling(
                      maxScaleFactor: scale,
                      child: CalendarDatePicker(
                        initialDate: _selected,
                        firstDate: widget.first,
                        lastDate: widget.last,
                        onDateChanged: (value) =>
                            setState(() => _selected = value),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _confirm,
                child: Text(l10n.dialog_confirm),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
