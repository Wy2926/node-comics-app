import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/calendar/widgets/calendar_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

const _maxEventDots = 3;

class UpcomingCalendar extends StatefulWidget {
  final DateTime selectedYearMonth;
  final Map<DateTime, int> events;
  final ValueChanged<DateTime> setSelectedYearMonth;
  final ValueChanged<DateTime> onClickDay;
  final bool mobile;
  final DateTime? selectedDay;

  const UpcomingCalendar({
    required this.selectedYearMonth,
    required this.events,
    required this.setSelectedYearMonth,
    required this.onClickDay,
    this.mobile = false,
    this.selectedDay,
    super.key,
  });

  @override
  State<UpcomingCalendar> createState() => _UpcomingCalendarState();
}

class _UpcomingCalendarState extends State<UpcomingCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedYearMonth;
  }

  @override
  void didUpdateWidget(covariant UpcomingCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedYearMonth != widget.selectedYearMonth) {
      _focusedDay = widget.selectedYearMonth;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);

    final table = TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 1000)),
      focusedDay: _focusedDay,
      headerVisible: !widget.mobile,
      daysOfWeekHeight: widget.mobile ? 28 : 16,
      rowHeight: widget.mobile ? 48 : 52,
      onCalendarCreated: (controller) => _pageController = controller,
      selectedDayPredicate: widget.mobile
          ? (day) => isSameDay(day, widget.selectedDay)
          : null,
      locale: locale.toLanguageTag(),
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
        formatButtonShowsNext: false,
        titleTextStyle: theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
        ),
        leftChevronIcon: Icon(
          Icons.keyboard_arrow_left,
          color: theme.colorScheme.onSurface,
        ),
        rightChevronIcon: Icon(
          Icons.keyboard_arrow_right,
          color: theme.colorScheme.onSurface,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: theme.colorScheme.onSurface,
        ),
        weekendStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: theme.colorScheme.primary,
        ),
      ),
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.primary,
        ),
        selectedTextStyle: TextStyle(color: theme.colorScheme.onPrimary),
        outsideDaysVisible: true,
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.primary, width: 1.5),
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
        weekendTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.primary,
        ),
        outsideTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        // Disable default marker so we use our custom builder
        markersMaxCount: 0,
      ),
      eventLoader: (day) {
        final key = DateTime(day.year, day.month, day.day);
        final count = widget.events[key] ?? 0;
        return List.generate(
          widget.mobile ? min(count, _maxEventDots) : count,
          (_) => day,
        );
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          final key = DateTime(date.year, date.month, date.day);
          final count = widget.events[key] ?? 0;
          if (count == 0) return null;
          return Positioned(
            bottom: 4,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                min(count, _maxEventDots),
                (index) => CalendarIndicator(
                  index: index,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          );
        },
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() => _focusedDay = focusedDay);
        if (widget.mobile) widget.setSelectedYearMonth(focusedDay);
        widget.onClickDay(
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
        );
      },
      onFormatChanged: (format) {
        setState(() => _calendarFormat = format);
      },
      onPageChanged: (focusedDay) {
        if (widget.mobile) {
          setState(() => _focusedDay = focusedDay);
        } else {
          _focusedDay = focusedDay;
        }
        widget.setSelectedYearMonth(
          widget.mobile
              ? focusedDay
              : DateTime(focusedDay.year, focusedDay.month),
        );
      },
    );
    if (!widget.mobile) return table;
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final formats = {
      CalendarFormat.month: l10n.calendar_month,
      CalendarFormat.twoWeeks: l10n.calendar_two_weeks,
      CalendarFormat.week: l10n.calendar_week,
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.line),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: MaterialLocalizations.of(context).previousPageTooltip,
                onPressed: () => _pageController?.previousPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                ),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(locale.toLanguageTag()).format(_focusedDay),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).nextPageTooltip,
                onPressed: () => _pageController?.nextPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                ),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in formats.entries)
                  ChoiceChip(
                    label: Text(entry.value),
                    selected: _calendarFormat == entry.key,
                    showCheckmark: false,
                    onSelected: (_) =>
                        setState(() => _calendarFormat = entry.key),
                  ),
              ],
            ),
          ),
          // Seven fixed columns need a bounded scale for two-digit days. The
          // heading, controls, selected date and agenda retain the system scale.
          MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.textScalerOf(context)
                  .clamp(maxScaleFactor: 1.25),
            ),
            child: table,
          ),
        ],
      ),
    );
  }
}
