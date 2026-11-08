import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/tracker_library/tracker_item_card.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';

class TrackerLibraryImageCard extends StatelessWidget {
  final TrackSearch track;
  final ItemType itemType;
  final Track? libraryTrack;

  const TrackerLibraryImageCard({
    super.key,
    required this.track,
    required this.itemType,
    this.libraryTrack,
  });

  @override
  Widget build(BuildContext context) {
    final t = NodeLaneTokens.of(context), icons = NodeLaneIcons.of(context);
    final title = track.title ?? context.l10n.unknown;
    return SizedBox(
      width: NodeLaneTokens.detailCoverWidth,
      child: Semantics(
        button: true,
        label: title,
        child: NodeLaneGroupSurface(
          child: InkWell(
            onTap: () => _showCard(context, libraryTrack?.mangaId),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1 / NodeLaneTokens.coverAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      cachedNetworkImage(
                        imageUrl: toImgUrl(track.coverUrl ?? ''),
                        width: NodeLaneTokens.detailCoverWidth,
                        height:
                            NodeLaneTokens.detailCoverWidth *
                            NodeLaneTokens.coverAspectRatio,
                        fit: BoxFit.cover,
                        errorWidget: Icon(
                          icons.manga,
                          size: NodeLaneTokens.emptyStateIconSize,
                          color: t.muted,
                        ),
                      ),
                      PositionedDirectional(
                        top: NodeLaneTokens.space8,
                        end: NodeLaneTokens.space8,
                        child: NodeLaneCoverBadge(
                          track.score?.toString() ?? '—',
                          icon: icons.favorite,
                        ),
                      ),
                      if (libraryTrack?.mangaId != null)
                        PositionedDirectional(
                          bottom: NodeLaneTokens.space8,
                          start: NodeLaneTokens.space8,
                          child: NodeLaneCoverBadge(
                            '',
                            icon: icons.librarySelected,
                            tone: NodeLaneBadgeTone.neutral,
                            semanticsLabel: context.l10n.in_library,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(NodeLaneTokens.space8),
                  child: Text(
                    title,
                    style: t.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCard(BuildContext context, int? mangaId) {
    showDialog(
      context: context,
      builder: (context) =>
          TrackerItemCard(track: track, itemType: itemType, mangaId: mangaId),
    );
  }
}
