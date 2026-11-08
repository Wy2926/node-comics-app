import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/modules/widgets/nodelane_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/widgets/readmore.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';

class TrackerItemCard extends StatelessWidget {
  final TrackSearch track;
  final ItemType itemType;
  final int? mangaId;

  const TrackerItemCard({
    super.key,
    required this.track,
    required this.itemType,
    this.mangaId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n,
        t = NodeLaneTokens.of(context),
        icons = NodeLaneIcons.of(context);
    return NodeLaneAlertDialog(
      title: Text(track.title ?? ''),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(NodeLaneTokens.coverRadius),
                child: cachedNetworkImage(
                  imageUrl: toImgUrl(track.coverUrl ?? ''),
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: NodeLaneTokens.space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.score} ${track.score ?? "—"}',
                      style: t.readerLabel,
                    ),
                    const SizedBox(height: NodeLaneTokens.space8),
                    Text(
                      '${l10n.chapters} ${track.totalChapter ?? "—"}',
                      style: t.readerSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (track.summary?.isNotEmpty == true) ...[
            const SizedBox(height: NodeLaneTokens.space16),
            ReadMoreWidget(
              text: track.summary!,
              initExpanded: false,
              onChanged: (_) {},
            ),
          ],
          const SizedBox(height: NodeLaneTokens.space16),
          NodeLaneGroupSurface(
            children: [
              if (mangaId != null)
                NodeLaneRow(
                  title: l10n.track_library_navigate,
                  icon: icons.manga,
                  onTap: () => _pushLocalLibrary(context),
                ),
              NodeLaneRow(
                title: l10n.track_library_add,
                icon: icons.add,
                onTap: () => _pushMigrationScreen(context),
              ),
              if (track.trackingUrl?.isNotEmpty == true)
                NodeLaneRow(
                  title: l10n.open_in_browser,
                  icon: icons.web,
                  onTap: () => InAppBrowser.openWithSystemBrowser(
                    url: WebUri(track.trackingUrl!),
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        NodeLaneDialogAction(
          label: l10n.close,
          secondary: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  void _pushLocalLibrary(BuildContext context) {
    context.push('/manga-reader/detail', extra: mangaId);
  }

  void _pushMigrationScreen(BuildContext context) {
    context.push(
      "/migrate/tracker",
      extra: (
        Manga(
          name: track.title,
          itemType: itemType,
          source: null,
          author: "",
          artist: "",
          genre: [],
          imageUrl: null,
          lang: null,
          link: null,
          status: Status.unknown,
          description: "",
          sourceId: null,
        ),
        track,
      ),
    );
  }
}
