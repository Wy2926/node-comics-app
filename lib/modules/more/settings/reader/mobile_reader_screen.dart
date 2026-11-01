import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'providers/reader_state_provider.dart';
import 'reader_settings_labels.dart';
import 'mobile_reader_settings_sections.dart';

class MobileReaderScreen extends ConsumerWidget {
  const MobileReaderScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = NodeLaneTokens.of(context);
    final scaleNames = getScaleTypeNames(context);
    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.reader,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            key: const PageStorageKey('mobile-reader-settings'),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
                child: Text(
                  l10n.reader_default_mode_hint,
                  style: TextStyle(color: colors.muted),
                ),
              ),
              MobileSettingsGroup(
                title: l10n.reading_mode,
                children: [
                  MobileReaderSettingsChoice<ReaderMode>(
                    title: l10n.default_reading_mode,
                    scopeDescription: l10n.reader_default_mode_hint,
                    icon: Icons.chrome_reader_mode_outlined,
                    value: ref.watch(defaultReadingModeStateProvider),
                    values: ReaderMode.values,
                    label: (value) => getReaderModeName(value, context),
                    onChanged: ref
                        .read(defaultReadingModeStateProvider.notifier)
                        .set,
                  ),
                  MobileReaderSettingsChoice<ScaleType>(
                    title: l10n.scale_type,
                    icon: Icons.fit_screen_rounded,
                    value: ref.watch(scaleTypeStateProvider),
                    values: ScaleType.values.take(scaleNames.length).toList(),
                    label: (value) => value.index < scaleNames.length
                        ? scaleNames[value.index]
                        : l10n.unknown,
                    onChanged: ref.read(scaleTypeStateProvider.notifier).set,
                  ),
                  MobileReaderSettingsChoice<BackgroundColor>(
                    title: l10n.background_color,
                    icon: Icons.palette_outlined,
                    value: ref.watch(backgroundColorStateProvider),
                    values: BackgroundColor.values,
                    label: (value) => getBackgroundColorName(value, context),
                    onChanged: ref
                        .read(backgroundColorStateProvider.notifier)
                        .set,
                  ),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.display,
                children: [
                  MobileSettingsSwitch(
                    title: l10n.show_page_number,
                    icon: Icons.format_list_numbered_rounded,
                    value: ref.watch<dynamic>(
                      showPagesNumberStateProvider,
                    ) as bool,
                    onChanged: ref
                        .read(showPagesNumberStateProvider.notifier)
                        .set,
                  ),
                  MobileSettingsSwitch(
                    title: l10n.keep_screen_on,
                    icon: Icons.light_mode_outlined,
                    value: ref.watch(keepScreenOnReaderStateProvider),
                    onChanged: ref
                        .read(keepScreenOnReaderStateProvider.notifier)
                        .set,
                  ),
                  MobileSettingsSwitch(
                    title: l10n.crop_borders,
                    icon: Icons.crop_rounded,
                    value: ref.watch(cropBordersStateProvider),
                    onChanged: ref.read(cropBordersStateProvider.notifier).set,
                  ),
                ],
              ),
              MobileSettingsGroup(
                children: [
                  MobileReaderSettingsExpansion(
                    storageKey: 'reader-page-layout',
                    title: l10n.reader_page_layout,
                    icon: Icons.auto_stories_outlined,
                    child: const MobileReaderPageLayoutSettings(),
                  ),
                  MobileReaderSettingsExpansion(
                    storageKey: 'reader-continuous',
                    title: l10n.reader_continuous_options,
                    icon: Icons.view_day_outlined,
                    child: const MobileReaderContinuousSettings(),
                  ),
                  MobileReaderSettingsExpansion(
                    storageKey: 'reader-navigation',
                    title: l10n.navigation_layout,
                    icon: Icons.touch_app_outlined,
                    child: const MobileReaderNavigationSettings(),
                  ),
                  MobileReaderSettingsExpansion(
                    storageKey: 'reader-advanced',
                    title: l10n.advanced,
                    icon: Icons.tune_rounded,
                    child: const MobileReaderAdvancedSettings(),
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
