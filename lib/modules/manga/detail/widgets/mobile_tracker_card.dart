import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_tracker_editor.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_search_widget.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';

/// Connects the phone editor to the same tracker providers as the classic card.
class MobileTrackerCard extends ConsumerWidget {
  const MobileTrackerCard({
    super.key,
    required this.track,
    required this.itemType,
    required this.mangaId,
    required this.syncId,
    this.hide = false,
  });
  final Track track;
  final ItemType itemType;
  final int mangaId, syncId;
  final bool hide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(
      trackStateProvider(
        track: track,
        itemType: itemType,
        widgetRef: ref,
      ).notifier,
    );
    String dateLabel(int? milliseconds) => (milliseconds ?? 0) > 0
        ? dateFormat(
            '$milliseconds',
            ref: ref,
            useRelativeTimesTamps: false,
            context: context,
          )
        : '—';
    return MobileTrackerEditor(
      key: ValueKey((syncId, track.mediaId, mangaId)),
      track: track,
      itemType: itemType,
      showService: !hide,
      statuses: state.getStatusList(),
      scoreMax: state.getScoreMaxValue(),
      scoreStep: state.getScoreStep(),
      scoreLabel: (value) => state.getTextMapper('$value'),
      startLabel: dateLabel(track.startedReadingDate),
      finishLabel: dateLabel(track.finishedReadingDate),
      locale: ref.watch(l10nLocaleStateProvider),
      onRefresh: () async {
        final refreshed = await ref
            .read(
              trackStateProvider(
                track: Track.fromJson(track.toJson()),
                itemType: itemType,
                widgetRef: ref,
              ).notifier,
            )
            .findManga();
        if (!context.mounted) return;
        if (refreshed == null) throw StateError('Tracking entry unavailable');
        ref
            .read(tracksProvider(syncId: syncId).notifier)
            .updateTrackManga(refreshed, itemType);
      },
      onUpdate: (draft) async {
        await ref
            .read(
              trackStateProvider(
                track: draft,
                itemType: itemType,
                widgetRef: ref,
              ).notifier,
            )
            .updateManga();
      },
      onRemove: () => ref
          .read(tracksProvider(syncId: syncId).notifier)
          .deleteTrackManga(track),
      onChangeMatch: hide
          ? null
          : () async {
              final selected = await trackersSearchDraggableMenu(
                context,
                track: track,
                itemType: itemType,
              ) as TrackSearch?;
              if (!context.mounted ||
                  selected == null ||
                  selected.mediaId == track.mediaId) {
                return;
              }
              await ref
                  .read(
                    trackStateProvider(
                      track: null,
                      itemType: itemType,
                      widgetRef: ref,
                    ).notifier,
                  )
                  .setTrackSearch(selected, mangaId, syncId);
            },
    );
  }
}
