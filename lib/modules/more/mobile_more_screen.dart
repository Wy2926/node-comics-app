import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/downloaded_only_widget.dart';
import 'package:mangayomi/modules/more/widgets/incognito_mode_widget.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/translation/translation_settings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class MobileMoreScreen extends ConsumerWidget {
  const MobileMoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final hiddenItems = ref.watch(hideItemsStateProvider);
    return NodeLaneSurface(
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: ListView(
            key: const PageStorageKey('mobile-more'),
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              24,
            ).add(pageBottomInsets(context)),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Semantics(
                  header: true,
                  child: Text(
                    l10n.more,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: NodeLaneTokens.of(context).ink,
                    ),
                  ),
                ),
              ),
              MobileSettingsGroup(
                children: [
                  MobileSettingsLink(
                    title: l10n.settings,
                    icon: Icons.settings_outlined,
                    onTap: () => context.push('/settings'),
                  ),
                  MobileSettingsLink(
                    title: '漫画翻译',
                    icon: Icons.translate_rounded,
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => const TranslationSettings(),
                          ),
                        ),
                  ),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.reading,
                children: const [
                  DownloadedOnlyWidget(mobile: true),
                  IncognitoModeWidget(mobile: true),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.library,
                children: [
                  if (hiddenItems.contains('/history'))
                    MobileSettingsLink(
                      title: l10n.history,
                      icon: Icons.history_rounded,
                      onTap: () => context.push('/history'),
                    ),
                  MobileSettingsLink(
                    title: l10n.download_queue,
                    icon: Icons.download_outlined,
                    onTap: () => context.push('/downloadQueue'),
                  ),
                  MobileSettingsLink(
                    title: l10n.categories,
                    icon: Icons.label_outline_rounded,
                    onTap: () => context.push('/categories', extra: (false, 0)),
                  ),
                  MobileSettingsLink(
                    title: l10n.data_and_storage,
                    icon: Icons.storage_outlined,
                    onTap: () => context.push('/dataAndStorage'),
                  ),
                  MobileSettingsLink(
                    title: l10n.statistics,
                    icon: Icons.query_stats_outlined,
                    onTap: () => context.push('/statistics'),
                  ),
                  MobileSettingsLink(
                    title: l10n.calendar,
                    icon: Icons.calendar_month_outlined,
                    onTap: () => context.push('/calendarScreen'),
                  ),
                ],
              ),
              MobileSettingsGroup(
                children: [
                  MobileSettingsLink(
                    title: l10n.about,
                    icon: Icons.info_outline_rounded,
                    onTap: () => context.push('/about'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
