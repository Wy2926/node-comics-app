import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/calendar/models/upcoming_ui_model.dart';
import 'package:mangayomi/modules/calendar/widgets/upcoming_calendar.dart';
import 'package:mangayomi/modules/calendar/widgets/upcoming_item.dart'
    as widgets;
import 'package:mangayomi/modules/more/widgets/mobile_media_selector.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

class MobileCalendar extends StatefulWidget {
  const MobileCalendar({
    super.key,
    required this.types,
    required this.itemType,
    required this.data,
    required this.onTypeChanged,
    required this.onRetry,
    required this.onOpen,
  });
  final List<ItemType> types;
  final ItemType? itemType;
  final AsyncValue<List<UpcomingUIModel>> data;
  final ValueChanged<ItemType> onTypeChanged;
  final VoidCallback onRetry;
  final ValueChanged<Manga> onOpen;

  @override
  State<MobileCalendar> createState() => _MobileCalendarState();
}

class _MobileCalendarState extends State<MobileCalendar> {
  late DateTime _focusedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final allItems = widget.data.asData?.value ?? const <UpcomingUIModel>[];
    final events = {
      for (final header in allItems.whereType<UpcomingHeader>())
        header.date: header.mangaCount,
    };
    final date = _selectedDate;
    final items = date == null
        ? allItems
        : allItems
              .where(
                (item) => switch (item) {
                  UpcomingHeader(:final date) => date == _selectedDate,
                  UpcomingItem(:final expectedDate) =>
                    expectedDate == _selectedDate,
                },
              )
              .toList();
    String dateLabel(DateTime date) =>
        DateFormat.yMMMd(Localizations.localeOf(context).toString())
            .format(date);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.calendar,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              tooltip: l10n.help,
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  scrollable: true,
                  title: Text(l10n.calendar),
                  content: Text(l10n.calendar_info),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.ok),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            key: const PageStorageKey('mobile-calendar'),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MobileMediaSelector(
                        types: widget.types,
                        selected: widget.itemType,
                        onChanged: widget.onTypeChanged,
                      ),
                      if (widget.itemType != null) ...[
                        UpcomingCalendar(
                          mobile: true,
                          selectedYearMonth: _focusedDay,
                          selectedDay: date,
                          events: events,
                          setSelectedYearMonth: (day) => _focusedDay = day,
                          onClickDay: (day) =>
                              setState(() => _selectedDate = day),
                        ),
                        const SizedBox(height: 20),
                        if (date != null) ...[
                          Text(
                            dateLabel(date),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: TextButton.icon(
                              onPressed: () =>
                                  setState(() => _selectedDate = null),
                              icon: const Icon(Icons.clear_rounded),
                              label: Text(l10n.calendar_show_all_dates),
                            ),
                          ),
                        ],
                      ],
                      if (widget.data.isLoading)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (widget.data.hasError) ...[
                        Text(l10n.failed),
                        TextButton(
                          onPressed: widget.onRetry,
                          child: Text(l10n.retry),
                        ),
                      ] else if (items.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(l10n.calendar_no_data),
                        ),
                    ],
                  ),
                ),
              ),
              if (!widget.data.isLoading && !widget.data.hasError)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) => switch (items[index]) {
                      UpcomingHeader(:final date, :final mangaCount) => Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Semantics(
                          header: true,
                          child: Text(
                            '${dateLabel(date)} · $mangaCount',
                            style: TextStyle(
                              color: colors.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      UpcomingItem(:final manga) => widgets.UpcomingItem(
                        key: ValueKey('calendar-${manga.id}'),
                        manga: manga,
                        mobile: true,
                        onTap: () => widget.onOpen(manga),
                      ),
                    },
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
