import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Only used before the local book record arrives. Known book content stays in
/// the normal detail view, which replaces just its missing sections below.
class MobileDetailLoadingPage extends StatelessWidget {
  const MobileDetailLoadingPage({super.key});

  @override
  Widget build(BuildContext context) => NodeLaneSurface(
    child: Builder(
      builder: (context) => Scaffold(
        appBar: nodeLaneAppBar(context, title: ''),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                MobileDetailOverview(
                  heading: const MobileDetailHeading(
                    cover: NodeLaneSkeleton(
                      width: NodeLaneTokens.detailCoverWidth,
                      height: NodeLaneTokens.detailCoverHeight,
                      radius: NodeLaneTokens.coverRadius,
                    ),
                    title: NodeLaneSkeleton(height: NodeLaneTokens.space24),
                    metadata: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NodeLaneSkeleton(
                          height: NodeLaneTokens.space12,
                          width: 96,
                        ),
                        SizedBox(height: NodeLaneTokens.space12),
                        NodeLaneSkeleton(
                          height: NodeLaneTokens.space12,
                          width: 64,
                        ),
                      ],
                    ),
                  ),
                  actions: const MobileDetailPrimaryActions(
                    reading: NodeLaneSkeleton(
                      height: NodeLaneTokens.rowHeight,
                      radius: NodeLaneTokens.capsuleRadius,
                    ),
                    library: NodeLaneSkeleton(
                      height: NodeLaneTokens.rowHeight,
                      radius: NodeLaneTokens.capsuleRadius,
                    ),
                  ),
                  synopsis: const MobileDetailSynopsisLoading(),
                  more: const NodeLaneSkeleton(
                    height: NodeLaneTokens.minTapTarget,
                  ),
                  chapters: Text(
                    context.l10n.detail_loading_chapters,
                    style: NodeLaneTokens.of(context).detailSectionTitle,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(NodeLaneTokens.detailGutter),
                  child: MobileChapterListLoading(),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class MobileDetailSynopsisLoading extends StatelessWidget {
  const MobileDetailSynopsisLoading({super.key});

  @override
  Widget build(BuildContext context) => NodeLaneGroupSurface(
    child: Padding(
      padding: NodeLaneTokens.groupPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.manga_synopsis,
            style: NodeLaneTokens.of(context).detailSectionTitle,
          ),
          const SizedBox(height: NodeLaneTokens.space12),
          for (final width in [1.0, .9, .7]) ...[
            FractionallySizedBox(
              widthFactor: width,
              child: const NodeLaneSkeleton(height: NodeLaneTokens.space12),
            ),
            const SizedBox(height: NodeLaneTokens.space8),
          ],
          const Row(
            children: [
              NodeLaneSkeleton(height: NodeLaneTokens.space20, width: 64),
              SizedBox(width: NodeLaneTokens.space8),
              NodeLaneSkeleton(height: NodeLaneTokens.space20, width: 64),
            ],
          ),
        ],
      ),
    ),
  );
}

class MobileChapterListLoading extends StatelessWidget {
  const MobileChapterListLoading({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: context.l10n.detail_loading_chapters,
    liveRegion: true,
    child: NodeLaneGroupSurface(
      child: Column(
        children: [
          for (var index = 0; index < 3; index++) ...[
            if (index > 0) const NodeLaneGroupDivider(),
            SizedBox(
              height: NodeLaneTokens.chapterRowHeight,
              child: Padding(
                padding: NodeLaneTokens.groupPadding,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FractionallySizedBox(
                            widthFactor: index.isEven ? .65 : .8,
                            child: const NodeLaneSkeleton(
                              height: NodeLaneTokens.space12,
                            ),
                          ),
                          const SizedBox(height: NodeLaneTokens.space8),
                          const FractionallySizedBox(
                            widthFactor: .45,
                            child: NodeLaneSkeleton(
                              height: NodeLaneTokens.space8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: NodeLaneTokens.space16),
                    const NodeLaneSkeleton(
                      height: NodeLaneTokens.iconSize,
                      width: NodeLaneTokens.iconSize,
                      radius: NodeLaneTokens.capsuleRadius,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
