import 'package:flutter/material.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_info_header.dart';
import 'package:mangayomi/modules/manga/detail/widgets/mobile_detail_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

/// Isolated visual fixture: no app initialization, repository or network calls.
/// Run with Flutter's target option to review full metadata on an iOS simulator.
void main() => runApp(const DetailOverviewPreview());
void _noop() {}

class DetailOverviewPreview extends StatelessWidget {
  const DetailOverviewPreview({
    super.key,
    this.onRead = _noop,
    this.onLibrary = _noop,
    this.statusPlaceholder = false,
  });
  final VoidCallback onRead, onLibrary;
  final bool statusPlaceholder;
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
              body: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    if (statusPlaceholder)
                      const SliverToBoxAdapter(child: SizedBox(height: 50)),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 44,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(icons.back),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(icons.download),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(icons.more),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                          reading: MobileDetailButton(
                            label: '继续阅读',
                            icon: icons.manga,
                            primary: true,
                            onPressed: onRead,
                          ),
                          library: MobileDetailButton(
                            label: '已在书架',
                            icon: icons.check,
                            onPressed: onLibrary,
                          ),
                        ),
                        synopsis: MobileDetailSynopsis(
                          title: '简介',
                          text: '一封寄错地址的信，让少女回到久别的海边小镇。在潮汐与旧日回忆之间，她逐渐找到了自己的答案。',
                          expanded: false,
                          onChanged: (_) {},
                          genres: Row(
                            children: [
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
                        ),
                        more: NodeLaneGroupSurface(
                          child: ExpansionTile(
                            minTileHeight: NodeLaneTokens.detailMoreHeight,
                            dense: true,
                            visualDensity: VisualDensity.standard,
                            shape: const Border(),
                            collapsedShape: const Border(),
                            title: Text('更多', style: colors.detailSectionTitle),
                          ),
                        ),
                        chapters: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '章节 · 12',
                                style: colors.detailSectionTitle,
                              ),
                            ),
                            MobileDetailFilterButton(
                              label: '筛选',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: NodeLaneTokens.detailGutter,
                      ),
                      sliver: SliverList.list(
                        children: [
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
