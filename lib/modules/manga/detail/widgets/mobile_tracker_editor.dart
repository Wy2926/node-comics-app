import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/modules/more/widgets/mobile_account_widgets.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_text_dialog.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/constant.dart';

import 'mobile_tracker_date_picker.dart';

/// Keeps temporary choices separate from the subscribed record. The adapter
/// supplies the existing tracker operations and score/status conventions.
class MobileTrackerEditor extends StatefulWidget {
  const MobileTrackerEditor({
    super.key,
    required this.track,
    required this.itemType,
    required this.statuses,
    required this.scoreMax,
    required this.scoreStep,
    required this.scoreLabel,
    required this.startLabel,
    required this.finishLabel,
    required this.onRefresh,
    required this.onUpdate,
    required this.onRemove,
    this.onChangeMatch,
    this.locale,
    this.showService = true,
  });

  final Track track;
  final ItemType itemType;
  final List<TrackStatus> statuses;
  final int scoreMax, scoreStep;
  final String Function(int) scoreLabel;
  final String startLabel, finishLabel;
  final Locale? locale;
  final bool showService;
  final Future<void> Function() onRefresh;
  final Future<void> Function(Track) onUpdate;
  final VoidCallback onRemove;
  final Future<void> Function()? onChangeMatch;

  @override
  State<MobileTrackerEditor> createState() => _MobileTrackerEditorState();
}

class _MobileTrackerEditorState extends State<MobileTrackerEditor> {
  bool _busy = false, _working = false, _needsRefresh = false;

  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      if (mounted) await _refresh();
    });
  }

  Future<void> _run(
    Future<void> Function() action, {
    bool refresh = false,
  }) async {
    if (_busy || (_needsRefresh && !refresh)) return;
    setState(() => _busy = true);
    try {
      await action();
      if (mounted && refresh) setState(() => _needsRefresh = false);
    } catch (_) {
      // A failed response may have reached the service. Refresh the original
      // entry before allowing another edit; never silently repeat the write.
      if (mounted) setState(() => _needsRefresh = true);
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _working = false;
        });
      }
    }
  }

  Future<void> _refresh() => _run(() async {
    setState(() => _working = true);
    await widget.onRefresh();
  }, refresh: true);

  Future<void> _update(void Function(Track) change) async {
    if (!mounted) return;
    final draft = Track.fromJson(widget.track.toJson());
    change(draft);
    setState(() => _working = true);
    await widget.onUpdate(draft);
  }

  Future<void> _status() => _run(() async {
    final current = toTrackStatus(
      widget.track.status,
      widget.itemType,
      widget.track.syncId!,
    );
    final selected = await showMobileSettingsPicker(
      context,
      title: context.l10n.status,
      current: current,
      options: [
        for (final status in widget.statuses)
          MobileSettingOption(status, getTrackStatus(status, context)),
      ],
    );
    if (!mounted || selected == null || selected.value == current) return;
    await _update((draft) => draft.status = selected.value);
  });

  Future<void> _progress() => _run(() async {
    final max = (widget.track.totalChapter ?? 0) > 0
        ? widget.track.totalChapter!
        : 10000;
    final selected = await showDialog<String>(
      context: context,
      builder: (_) => MobileSettingsTextDialog(
        title: widget.itemType == ItemType.manga
            ? context.l10n.chapters
            : context.l10n.episodes,
        initialValue: '${widget.track.lastChapterRead ?? 0}',
        helper: '0–$max',
        keyboardType: TextInputType.number,
        isValid: (text) {
          final value = int.tryParse(text.trim());
          return value != null && value >= 0 && value <= max;
        },
      ),
    );
    if (!mounted || selected == null) return;
    final value = int.parse(selected.trim());
    if (value != (widget.track.lastChapterRead ?? 0)) {
      await _update((draft) => draft.lastChapterRead = value);
    }
  });

  Future<void> _score() => _run(() async {
    final selected = await showMobileSettingsPicker(
      context,
      title: context.l10n.score,
      current: widget.track.score ?? 0,
      options: [
        for (var value = 0; value <= widget.scoreMax; value += widget.scoreStep)
          MobileSettingOption(value, widget.scoreLabel(value)),
      ],
    );
    if (!mounted || selected == null || selected.value == widget.track.score) {
      return;
    }
    await _update((draft) => draft.score = selected.value);
  });

  Future<void> _date(bool start) => _run(() async {
    final milliseconds = start
        ? widget.track.startedReadingDate
        : widget.track.finishedReadingDate;
    final stored = (milliseconds ?? 0) > 0
        ? DateTime.fromMillisecondsSinceEpoch(milliseconds!)
        : null;
    final first = DateTime(1900), last = DateTime(2100);
    final initial =
        stored != null && !stored.isBefore(first) && !stored.isAfter(last)
        ? stored
        : DateTime.now();
    final selected = await Navigator.of(context).push<DateTime>(
      MaterialPageRoute(
        builder: (routeContext) => Localizations.override(
          context: routeContext,
          locale: widget.locale,
          child: MobileTrackerDatePicker(
            title: start ? context.l10n.start_date : context.l10n.finish_date,
            initial: initial,
            first: first,
            last: last,
          ),
        ),
      ),
    );
    if (!mounted || selected == null || DateUtils.isSameDay(selected, stored)) {
      return;
    }
    await _update((draft) {
      if (start) {
        draft.startedReadingDate = selected.millisecondsSinceEpoch;
      } else {
        draft.finishedReadingDate = selected.millisecondsSinceEpoch;
      }
    });
  });

  Future<void> _remove() => _run(() async {
    final confirmed = await showMobileSettingsConfirmation(
      context,
      title: context.l10n.remove_tracking,
      message: context.l10n.remove_tracking_confirm(widget.track.title ?? ''),
      confirmLabel: context.l10n.remove,
    );
    if (mounted && confirmed) widget.onRemove();
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final track = widget.track;
    final locked = _busy || _needsRefresh;
    final total = track.totalChapter ?? 0;
    final progress = total > 0
        ? '${track.lastChapterRead ?? 0}/$total'
        : (track.lastChapterRead ?? 0) == 0
        ? l10n.not_started
        : '${track.lastChapterRead}';
    Widget value(
      String title,
      String text,
      IconData icon,
      VoidCallback action,
    ) => NodeLaneRow(
      title: title,
      subtitle: text,
      icon: icon,
      enabled: !locked,
      onTap: locked ? null : action,
    );
    return PopScope(
      canPop: !_busy,
      child: MobileSettingsGroup(
        title: widget.showService ? trackInfos(track.syncId!).$2 : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(track.title ?? l10n.unknown, style: colors.readerLabel),
                if (_working) ...[
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(),
                ],
                if (_needsRefresh) ...[
                  const SizedBox(height: 12),
                  Semantics(
                    liveRegion: true,
                    child: Text(l10n.tracking_refresh_required),
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    TextButton.icon(
                      onPressed: _busy ? null : _refresh,
                      icon: Icon(NodeLaneIcons.of(context).refresh),
                      label: Text(l10n.refresh),
                    ),
                    if (widget.onChangeMatch != null)
                      TextButton.icon(
                        onPressed: locked
                            ? null
                            : () => _run(widget.onChangeMatch!),
                        icon: const Icon(Icons.manage_search_rounded),
                        label: Text(l10n.change_tracking_match),
                      ),
                  ],
                ),
              ],
            ),
          ),
          value(
            l10n.status,
            getTrackStatus(
              toTrackStatus(track.status, widget.itemType, track.syncId!),
              context,
            ),
            Icons.bookmark_outline_rounded,
            _status,
          ),
          value(
            widget.itemType == ItemType.manga ? l10n.chapters : l10n.episodes,
            progress,
            Icons.menu_book_outlined,
            _progress,
          ),
          value(
            l10n.score,
            widget.scoreLabel(track.score ?? 0),
            NodeLaneIcons.of(context).favorite,
            _score,
          ),
          value(
            l10n.start_date,
            widget.startLabel,
            Icons.event_outlined,
            () => _date(true),
          ),
          value(
            l10n.finish_date,
            widget.finishLabel,
            NodeLaneIcons.of(context).calendar,
            () => _date(false),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextButton.icon(
              onPressed: locked ? null : _remove,
              icon: const Icon(Icons.link_off_rounded),
              label: Text(l10n.remove_tracking),
            ),
          ),
        ],
      ),
    );
  }
}
