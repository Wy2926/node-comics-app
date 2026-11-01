import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/downloaded_only_widget.dart';
import 'package:mangayomi/modules/more/widgets/incognito_mode_widget.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/modules/more/widgets/mobile_nodelane_account.dart';
import 'package:mangayomi/modules/translation/translation_settings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class MobileMoreScreen extends ConsumerWidget {
  const MobileMoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final icons = NodeLaneIcons.of(context);
    final hiddenItems = ref.watch(hideItemsStateProvider);
    return NodeLaneSurface(
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: ListView(
            key: const PageStorageKey('mobile-more'),
            padding: NodeLaneTokens.pagePadding.add(pageBottomInsets(context)),
            children: [
              NodeLanePageHeading(title: l10n.more),
              const SizedBox(height: NodeLaneTokens.space24),
              const MobileNodeLaneAccount(),
              MobileSettingsGroup(
                children: [
                  MobileSettingsLink(
                    title: l10n.settings,
                    icon: icons.settings,
                    onTap: () => context.push('/settings'),
                  ),
                  MobileSettingsLink(
                    title: '漫画翻译',
                    icon: icons.translate,
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
                      icon: icons.history,
                      onTap: () => context.push('/history'),
                    ),
                  MobileSettingsLink(
                    title: l10n.download_queue,
                    icon: icons.download,
                    onTap: () => context.push('/downloadQueue'),
                  ),
                  MobileSettingsLink(
                    title: l10n.categories,
                    icon: icons.categories,
                    onTap: () => context.push('/categories', extra: (false, 0)),
                  ),
                  MobileSettingsLink(
                    title: l10n.data_and_storage,
                    icon: icons.storage,
                    onTap: () => context.push('/dataAndStorage'),
                  ),
                  MobileSettingsLink(
                    title: l10n.statistics,
                    icon: icons.statistics,
                    onTap: () => context.push('/statistics'),
                  ),
                  MobileSettingsLink(
                    title: l10n.calendar,
                    icon: icons.calendar,
                    onTap: () => context.push('/calendarScreen'),
                  ),
                ],
              ),
              MobileSettingsGroup(
                children: [
                  MobileSettingsLink(
                    title: l10n.about,
                    icon: icons.info,
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
