import 'package:flutter/material.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_info_header.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_widgets.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_loading.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_actions.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Isolated visual fixture: no app initialization, repository or network calls.
/// Run with Flutter's target option to review full metadata on an iOS simulator.
void main() => runApp(const DetailOverviewPreview());
void _noop() {}

class DetailOverviewPreview extends StatefulWidget {
  const DetailOverviewPreview({
    super.key,
    this.onRead = _noop,
    this.onLibrary = _noop,
    this.loading = false,
  });
  final VoidCallback onRead, onLibrary;
  final bool loading;
  @override
  State<DetailOverviewPreview> createState() => _DetailOverviewPreviewState();
}

class _DetailOverviewPreviewState extends State<DetailOverviewPreview> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: const Locale('zh'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(
      platform: TargetPlatform.iOS,
      colorScheme: const ColorScheme.light(
        primary: NodeLaneTokens.defaultMobileAccent,
      ),
    ),
    home: NodeLaneSurface(
      child: Builder(
        builder: (context) {
          final colors = NodeLaneTokens.of(context);
          final icons = NodeLaneIcons.of(context);
          return RepaintBoundary(
            child: Scaffold(
              appBar: nodeLaneAppBar(
                context,
                title: '',
                onBack: () {},
                actions: [
                  MobileMangaDownloadActionsButton(
                    bookTitle: '海岸来信',
                    hasChapters: true,
                    onSelected: (_) async {},
                  ),
                  const SizedBox(width: NodeLaneTokens.space8),
                  MobileMangaDetailActionsButton(
                    bookTitle: '海岸来信',
                    localArchive: false,
                    favorite: true,
                    onSelected: (_) async {},
                  ),
                ],
              ),
              body: SafeArea(
                top: false,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: MobileDetailOverview(
                        heading: MobileDetailHeading(
                          cover: Container(
                            width: NodeLaneTokens.detailCoverWidth,
                            height: NodeLaneTokens.detailCoverHeight,
                            decoration: BoxDecoration(
                              color: colors.accentSoft,
                              borderRadius: BorderRadius.circular(
                                NodeLaneTokens.coverRadius,
                              ),
                            ),
                            child: Icon(
                              icons.manga,
                              size: 48,
                              color: colors.accent,
                            ),
                          ),
                          title: Text('海岸来信', style: colors.detailTitle),
                          metadata: Text(
                            '作者：海野\n连载中\n示例来源 · 中文',
                            style: colors.detailMetadata,
                          ),
                        ),
                        actions: MobileDetailPrimaryActions(
                          reading: FilledButton.icon(
                            label: Text(widget.loading ? '加载章节…' : '继续阅读'),
                            icon: Icon(
                              icons.manga,
                              size: NodeLaneTokens.iconSize,
                            ),
                            onPressed: widget.loading ? null : widget.onRead,
                          ),
                          library: NodeLaneSecondaryButton(
                            icon: icons.check,
                            onPressed: widget.onLibrary,
                            child: const Text('已在书架'),
                          ),
                        ),
                        synopsis: MobileDetailSynopsis(
                          title: '简介',
                          text: '一封寄错地址的信，让少女回到久别的海边小镇。在潮汐与旧日回忆之间，她逐渐找到了自己的答案。',
                          expanded: _expanded,
                          onChanged: (value) =>
                              setState(() => _expanded = value),
                          genres: [
                            for (final genre in ['日常', '治愈', '成长'])
                              DetailGenreChip(
                                label: genre,
                                mobile: true,
                                libraryLabel: '书架搜索',
                                sourceLabel: '来源搜索',
                                onSelected: (_) {},
                              ),
                          ],
                        ),
                        more: NodeLaneDisclosure(
                          title: '更多',
                          compact: true,
                          child: MobileDetailShortcuts(
                            children: [
                              NodeLaneToolbarAction(
                                label: '网页',
                                icon: icons.webLink,
                                onPressed: () {},
                              ),
                              NodeLaneToolbarAction(
                                label: '推荐',
                                icon: icons.recommend,
                                onPressed: () {},
                              ),
                              NodeLaneToolbarAction(
                                label: '相关作品',
                                icon: icons.related,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        chapters: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.loading ? '章节' : '章节 · 12',
                                style: colors.detailSectionTitle,
                              ),
                            ),
                            NodeLaneIconButton(
                              busy: widget.loading,
                              icon: icons.filter,
                              tooltip: '筛选',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: NodeLaneTokens.gutter,
                      ),
                      sliver: SliverList.list(
                        children: [
                          if (widget.loading)
                            const MobileChapterListLoading()
                          else
                            for (final title in [
                              '第12话  海风的回信',
                              '第11话  潮汐之间',
                              '第10话  夏末的灯塔',
                            ])
                              MobileChapterTile(
                                title: title,
                                metadata: '10月28日 · 海岸汉化组',
                                read: false,
                                bookmarked: false,
                                selecting: false,
                                selected: false,
                                onTap: () {},
                                onLongPress: () {},
                                trailing: SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Icon(
                                    icons.download,
                                    color: colors.accent,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
