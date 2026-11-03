import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
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
        appBar: nodeLaneAppBar(context, title: l10n.reader),
        body: SafeArea(
          top: false,
          child: ListView(
            key: const PageStorageKey('mobile-reader-settings'),
            padding: NodeLaneTokens.pagePadding,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
                child: Text(
                  l10n.reader_default_mode_hint,
                  style: colors.readerSecondary,
                ),
              ),
              MobileSettingsGroup(
                title: l10n.reading_mode,
                children: [
                  MobileReaderSettingsChoice<ReaderMode>(
                    title: l10n.default_reading_mode,
                    scopeDescription: l10n.reader_default_mode_hint,
                    icon: NodeLaneIcons.of(context).manga,
                    value: ref.watch(defaultReadingModeStateProvider),
                    values: ReaderMode.values,
                    label: (value) => getReaderModeName(value, context),
                    onChanged: ref
                        .read(defaultReadingModeStateProvider.notifier)
                        .set,
                  ),
                  MobileReaderSettingsChoice<ScaleType>(
                    title: l10n.scale_type,
                    icon: NodeLaneIcons.of(context).search,
                    value: ref.watch(scaleTypeStateProvider),
                    values: ScaleType.values.take(scaleNames.length).toList(),
                    label: (value) => value.index < scaleNames.length
                        ? scaleNames[value.index]
                        : l10n.unknown,
                    onChanged: ref.read(scaleTypeStateProvider.notifier).set,
                  ),
                  MobileReaderSettingsChoice<BackgroundColor>(
                    title: l10n.background_color,
                    icon: NodeLaneIcons.of(context).palette,
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
                  NodeLaneSwitchRow(
                    title: l10n.show_page_number,
                    icon: NodeLaneIcons.of(context).pageNumber,
                    value: ref.watch<dynamic>(
                      showPagesNumberStateProvider,
                    ) as bool,
                    onChanged: ref
                        .read(showPagesNumberStateProvider.notifier)
                        .set,
                  ),
                  NodeLaneSwitchRow(
                    title: l10n.keep_screen_on,
                    icon: NodeLaneIcons.of(context).brightness,
                    value: ref.watch(keepScreenOnReaderStateProvider),
                    onChanged: ref
                        .read(keepScreenOnReaderStateProvider.notifier)
                        .set,
                  ),
                  NodeLaneSwitchRow(
                    title: l10n.crop_borders,
                    icon: NodeLaneIcons.of(context).crop,
                    value: ref.watch(cropBordersStateProvider),
                    onChanged: ref.read(cropBordersStateProvider.notifier).set,
                  ),
                ],
              ),
              MobileSettingsGroup(
                children: [
                  NodeLaneDisclosure(
                    title: l10n.reader_page_layout,
                    icon: NodeLaneIcons.of(context).manga,
                    key: PageStorageKey('reader-page-layout'),
                    child: const MobileReaderPageLayoutSettings(),
                  ),
                  NodeLaneDisclosure(
                    title: l10n.reader_continuous_options,
                    icon: NodeLaneIcons.of(context).categories,
                    key: PageStorageKey('reader-continuous'),
                    child: const MobileReaderContinuousSettings(),
                  ),
                  NodeLaneDisclosure(
                    title: l10n.navigation_layout,
                    icon: NodeLaneIcons.of(context).navigation,
                    key: PageStorageKey('reader-navigation'),
                    child: const MobileReaderNavigationSettings(),
                  ),
                  NodeLaneDisclosure(
                    title: l10n.advanced,
                    icon: NodeLaneIcons.of(context).adjustments,
                    key: PageStorageKey('reader-advanced'),
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
