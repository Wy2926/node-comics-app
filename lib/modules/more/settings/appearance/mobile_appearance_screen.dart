import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/language.dart';

import 'providers/app_font_family.dart';
import 'providers/app_ui_scale_state_provider.dart';
import 'providers/blend_level_state_provider.dart';
import 'providers/date_format_state_provider.dart';
import 'providers/flex_scheme_color_state_provider.dart';
import 'providers/pure_black_dark_mode_state_provider.dart';
import 'providers/theme_mode_state_provider.dart';

class MobileAppearanceScreen extends ConsumerWidget {
  const MobileAppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dark = ref.watch(themeModeStateProvider);
    final followSystem = ref.watch(followSystemThemeStateProvider);
    final mode = followSystem
        ? ThemeMode.system
        : dark
        ? ThemeMode.dark
        : ThemeMode.light;
    final modeOptions = [
      MobileSettingOption(
        ThemeMode.system,
        l10n.follow_system_theme,
        leading: const Icon(Icons.brightness_auto_outlined),
      ),
      MobileSettingOption(
        ThemeMode.light,
        l10n.theme_light,
        leading: const Icon(Icons.light_mode_outlined),
      ),
      MobileSettingOption(
        ThemeMode.dark,
        l10n.theme_dark,
        leading: const Icon(Icons.dark_mode_outlined),
      ),
    ];
    final schemeIndex = ref.watch(
      flexSchemeColorStateProvider.select((value) => value.$2),
    );
    final pureBlack = ref.watch(pureBlackDarkModeStateProvider);
    final blend = ref.watch(blendLevelStateProvider);
    final scale = ref.watch(appUiScaleStateProvider).clamp(.85, 1.25);
    final locale = ref.watch(l10nLocaleStateProvider);
    final font = ref.watch(appFontFamilyProvider.select((value) => value.$1));
    final relative = ref.watch(relativeTimesTampsStateProvider);
    final datePattern = ref.watch(dateFormatStateProvider);
    final relativeLabels = relativeTimestampsList(context);
    String dateExample(String pattern) => dateFormat(
      DateTime.now().millisecondsSinceEpoch.toString(),
      context: context,
      ref: ref,
      dateFormat: pattern,
      useRelativeTimesTamps: false,
    );

    Future<void> select<T>({
      required String title,
      required T current,
      required List<MobileSettingOption<T>> options,
      required ValueChanged<T> apply,
      bool searchable = false,
    }) async {
      final selected = await showMobileSettingsPicker<T>(
        context,
        title: title,
        current: current,
        options: options,
        searchable: searchable,
      );
      if (context.mounted && selected != null && selected.value != current) {
        apply(selected.value);
      }
    }

    return NodeLaneSurface(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.appearance,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            key: const PageStorageKey('mobile-appearance'),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              MobileSettingsGroup(
                key: const ValueKey('appearance-theme'),
                title: l10n.theme,
                children: [
                  MobileSettingsLink(
                    title: l10n.theme,
                    subtitle: modeOptions
                        .firstWhere((option) => option.value == mode)
                        .label,
                    icon: Icons.brightness_6_outlined,
                    onTap: () => select(
                      title: l10n.theme,
                      current: mode,
                      options: modeOptions,
                      apply: (value) {
                        if (value == ThemeMode.system) {
                          ref
                              .read(followSystemThemeStateProvider.notifier)
                              .set(true);
                        } else {
                          if (ref.read(followSystemThemeStateProvider)) {
                            ref
                                .read(followSystemThemeStateProvider.notifier)
                                .set(false);
                          }
                          ref
                              .read(themeModeStateProvider.notifier)
                              .setTheme(
                                value == ThemeMode.dark
                                    ? Brightness.dark
                                    : Brightness.light,
                              );
                        }
                      },
                    ),
                  ),
                  MobileSettingsLink(
                    title: l10n.color,
                    subtitle: ThemeAA.schemes[schemeIndex].name,
                    icon: Icons.palette_outlined,
                    onTap: () => select(
                      title: l10n.color,
                      current: schemeIndex,
                      searchable: true,
                      options: [
                        for (var i = 0; i < ThemeAA.schemes.length; i++)
                          MobileSettingOption(
                            i,
                            ThemeAA.schemes[i].name,
                            leading: _ColorSample(index: i, dark: dark),
                          ),
                      ],
                      apply: (index) {
                        final scheme = ThemeAA.schemes[index];
                        ref
                            .read(flexSchemeColorStateProvider.notifier)
                            .setTheme(
                              ref.read(themeModeStateProvider)
                                  ? scheme.dark
                                  : scheme.light,
                              index,
                            );
                      },
                    ),
                  ),
                  if (dark)
                    SwitchListTile.adaptive(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(l10n.pure_black_dark_mode),
                      value: pureBlack,
                      onChanged: (value) => ref
                          .read(pureBlackDarkModeStateProvider.notifier)
                          .set(value),
                    ),
                  if (!pureBlack || !dark)
                    _AppearanceSlider(
                      title: l10n.color_blend_level,
                      valueLabel: '${blend.round()}',
                      value: blend,
                      min: 0,
                      max: 40,
                      divisions: 39,
                      onChanged: (value) => ref
                          .read(blendLevelStateProvider.notifier)
                          .setBlendLevel(value),
                      onChangeEnd: (value) => ref
                          .read(blendLevelStateProvider.notifier)
                          .setBlendLevel(value, end: true),
                    ),
                ],
              ),
              MobileSettingsGroup(
                key: const ValueKey('appearance-interface'),
                title: l10n.appearance,
                children: [
                  _AppearanceSlider(
                    title: l10n.app_ui_scale,
                    subtitle: l10n.app_ui_scale_subtitle,
                    valueLabel: '${(scale * 100).round()}%',
                    value: scale,
                    min: .85,
                    max: 1.25,
                    divisions: 8,
                    onChanged: (value) =>
                        ref.read(appUiScaleStateProvider.notifier).set(value),
                    onChangeEnd: (value) => ref
                        .read(appUiScaleStateProvider.notifier)
                        .set(value, end: true),
                  ),
                  MobileSettingsLink(
                    title: l10n.app_language,
                    subtitle: completeLanguageName(locale.toLanguageTag()),
                    icon: Icons.language_rounded,
                    onTap: () => select(
                      title: l10n.app_language,
                      current: locale,
                      searchable: true,
                      options: [
                        for (final value in AppLocalizations.supportedLocales)
                          MobileSettingOption(
                            value,
                            completeLanguageName(value.toLanguageTag()),
                          ),
                      ],
                      apply: ref
                          .read(l10nLocaleStateProvider.notifier)
                          .setLocale,
                    ),
                  ),
                  MobileSettingsLink(
                    title: l10n.font,
                    subtitle: font ?? l10n.default0,
                    icon: Icons.text_fields_rounded,
                    onTap: () => select<String?>(
                      title: l10n.font,
                      current: font,
                      searchable: true,
                      options: [
                        MobileSettingOption(null, l10n.default0),
                        for (final name in GoogleFonts.asMap().keys)
                          MobileSettingOption(name, name),
                      ],
                      apply: ref.read(appFontFamilyProvider.notifier).set,
                    ),
                  ),
                  MobileSettingsLink(
                    title: l10n.reorder_navigation,
                    subtitle: l10n.reorder_navigation_description,
                    icon: Icons.view_column_outlined,
                    onTap: () => context.push('/customNavigationSettings'),
                  ),
                ],
              ),
              MobileSettingsGroup(
                key: const ValueKey('appearance-time'),
                title: l10n.timestamp,
                children: [
                  MobileSettingsLink(
                    title: l10n.relative_timestamp,
                    subtitle: relativeLabels[relative],
                    icon: Icons.schedule_rounded,
                    onTap: () => select(
                      title: l10n.relative_timestamp,
                      current: relative,
                      options: [
                        for (var i = 0; i < relativeLabels.length; i++)
                          MobileSettingOption(i, relativeLabels[i]),
                      ],
                      apply: ref
                          .read(relativeTimesTampsStateProvider.notifier)
                          .set,
                    ),
                  ),
                  MobileSettingsLink(
                    title: l10n.date_format,
                    subtitle: '$datePattern · ${dateExample(datePattern)}',
                    icon: Icons.calendar_today_outlined,
                    onTap: () => select(
                      title: l10n.date_format,
                      current: datePattern,
                      options: [
                        for (final value in dateFormatsList)
                          MobileSettingOption(
                            value,
                            dateExample(value),
                            subtitle: value,
                          ),
                      ],
                      apply: ref.read(dateFormatStateProvider.notifier).set,
                    ),
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

class _ColorSample extends StatelessWidget {
  const _ColorSample({required this.index, required this.dark});
  final int index;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final scheme = ThemeAA.schemes[index];
    final colors = dark ? scheme.dark : scheme.light;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(colors: [colors.primary, colors.secondary]),
      ),
    );
  }
}

class _AppearanceSlider extends StatelessWidget {
  const _AppearanceSlider({
    required this.title,
    this.subtitle,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    required this.onChangeEnd,
  });
  final String title, valueLabel;
  final String? subtitle;
  final double value, min, max;
  final int divisions;
  final ValueChanged<double> onChanged, onChangeEnd;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$title · $valueLabel',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 13,
              color: NodeLaneTokens.of(context).muted,
            ),
          ),
        ],
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: valueLabel,
          semanticFormatterCallback: (_) => valueLabel,
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ],
    ),
  );
}
