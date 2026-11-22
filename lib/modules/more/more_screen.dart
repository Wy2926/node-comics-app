import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/mobile_more_screen.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/downloaded_only_widget.dart';
import 'package:mangayomi/modules/more/widgets/incognito_mode_widget.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/widgets/nodelane_brand_mark.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/main_view/main_screen.dart';
import 'package:mangayomi/modules/more/categories/mobile_categories.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isMobile && !isTv) return const MobileMoreScreen();
    final l10n = l10nLocalizations(context)!;
    final hiddenItems = ref.watch(hideItemsStateProvider);
    final animeOnly = ref.watch(animeOnlyTvModeProvider);
    final categoryTypes = visibleItemTypes(hiddenItems)
        .where((t) => !animeOnly || t == ItemType.anime);
    return Scaffold(
      body: SingleChildScrollView(
        padding: tvPageInsets.add(pageBottomInsets(context)),
        child: Column(
          children: [
            SizedBox(height: AppBar().preferredSize.height),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: NodeLaneBrandMark(size: 100),
            ),
            const Divider(),
            const DownloadedOnlyWidget(),
            const IncognitoModeWidget(),
            const Divider(),
            if (hiddenItems.contains('/browser'))
              ListTileWidget(
                onTap: () {
                  context.go('/browser');
                },
                icon: Icons.tab_outlined,
                title: context.l10n.browser_title,
              ),
            // Downloads are hidden on TV: no offline use case, and the download
            // buttons are hidden there too, so a queue entry would just dangle.
            if (!isTv)
              ListTileWidget(
                onTap: () {
                  context.push('/downloadQueue');
                },
                icon: Icons.download_outlined,
                title: l10n.download_queue,
              ),
            // TV has no detail overflow menu, so expose library-wide migration here.
            if (isTv)
              ListTileWidget(
                onTap: () => context.push(
                  '/massMigration',
                  extra: (ItemType.anime, null),
                ),
                icon: Icons.swap_horiz,
                title: l10n.mass_migration_title,
              ),
            if (categoryTypes.isNotEmpty)
              ListTileWidget(
                onTap: () => showCategoryManager(
                  context,
                  MainScreen.libraryForTools(context) ?? categoryTypes.first,
                ),
                icon: Icons.label_outline_rounded,
                title: l10n.categories,
              ),
            ListTileWidget(
              onTap: () {
                context.push('/statistics');
              },
              icon: Icons.query_stats_outlined,
              title: l10n.statistics,
            ),
            ListTileWidget(
              onTap: () {
                context.push('/calendarScreen');
              },
              icon: Icons.calendar_month_outlined,
              title: l10n.calendar,
            ),
            ListTileWidget(
              onTap: () {
                context.push('/dataAndStorage');
              },
              icon: Icons.storage,
              title: l10n.data_and_storage,
            ),
            const Divider(),
            ListTileWidget(
              onTap: () {
                context.push('/settings');
              },
              icon: Icons.settings_outlined,
              title: l10n.settings,
            ),
            ListTileWidget(
              onTap: () {
                context.push('/about');
              },
              icon: Icons.info_outline,
              title: l10n.about,
            ),
          ],
        ),
      ),
    );
  }
}
