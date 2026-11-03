import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart' show discordRpc;
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/providers/algorithm_weights_state_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_picker.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_text_dialog.dart';
import 'package:mangayomi/modules/more/widgets/mobile_settings_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/http/cf_proxy_store.dart';
import 'package:mangayomi/services/http/doh/doh_custom_store.dart';
import 'package:mangayomi/services/http/doh/doh_providers.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'providers/doh_provider_notifier.dart';
import 'providers/general_state_provider.dart';
import 'providers/memory_probe_provider.dart';

class MobileGeneralScreen extends ConsumerWidget {
  const MobileGeneralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final interval = ref.watch(autoLibraryUpdateIntervalStateProvider);
    String updateLabel(int hours) => switch (hours) {
      12 => l10n.auto_library_update_12_hours,
      24 => l10n.auto_library_update_daily,
      48 => l10n.auto_library_update_2_days,
      168 => l10n.auto_library_update_weekly,
      _ => l10n.auto_library_update_never,
    };

    return NodeLaneSurface(
      child: Scaffold(
        appBar: nodeLaneAppBar(context, title: l10n.general),
        body: SafeArea(
          top: false,
          child: ListView(
            key: const PageStorageKey('mobile-general'),
            padding: NodeLaneTokens.pagePadding,
            children: [
              MobileSettingsGroup(
                title: l10n.library,
                children: [
                  NodeLaneRow(
                    title: l10n.auto_library_update,
                    subtitle: updateLabel(interval),
                    icon: NodeLaneIcons.of(context).refresh,
                    onTap: () async {
                      final selected = await showMobileSettingsPicker<int>(
                        context,
                        title: l10n.auto_library_update,
                        current: interval,
                        options: [
                          for (final hours in libraryUpdateIntervals)
                            MobileSettingOption(hours, updateLabel(hours)),
                        ],
                      );
                      if (context.mounted &&
                          selected != null &&
                          selected.value != interval) {
                        ref
                            .read(
                              autoLibraryUpdateIntervalStateProvider.notifier,
                            )
                            .set(selected.value);
                      }
                    },
                  ),
                  if (interval > 0)
                    NodeLaneSwitchRow(
                      title: l10n.auto_library_update_wifi_only,
                      subtitle: l10n.auto_library_update_wifi_only_subtitle,
                      icon: NodeLaneIcons.of(context).wifi,
                      value: ref.watch(autoLibraryUpdateWifiOnlyStateProvider),
                      onChanged: ref
                          .read(autoLibraryUpdateWifiOnlyStateProvider.notifier)
                          .set,
                    ),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.app_settings,
                children: [
                  NodeLaneSwitchRow(
                    title: l10n.show_nav_double_tap_tooltip,
                    subtitle: l10n.show_nav_double_tap_tooltip_subtitle,
                    icon: NodeLaneIcons.of(context).navigation,
                    value: ref.watch(showNavDoubleTapTooltipStateProvider),
                    onChanged: ref
                        .read(showNavDoubleTapTooltipStateProvider.notifier)
                        .set,
                  ),
                ],
              ),
              MobileSettingsGroup(
                title: l10n.advanced,
                children: [
                  NodeLaneDisclosure(
                    title: l10n.network_settings,
                    icon: NodeLaneIcons.of(context).web,
                    child: const _NetworkSettings(),
                  ),
                  NodeLaneDisclosure(
                    title: l10n.recommendations_weights,
                    icon: NodeLaneIcons.of(context).adjustments,
                    child: const _RecommendationWeights(),
                  ),
                  NodeLaneDisclosure(
                    title: 'Discord',
                    icon: NodeLaneIcons.of(context).chat,
                    child: _DiscordSettings(),
                  ),
                  NodeLaneSwitchRow(
                    title: l10n.memory_overlay,
                    subtitle: l10n.memory_overlay_subtitle,
                    icon: NodeLaneIcons.of(context).memory,
                    value: ref.watch(memoryOverlayVisibleProvider),
                    onChanged: ref
                        .read(memoryOverlayVisibleProvider.notifier)
                        .set,
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

class _NetworkSettings extends ConsumerStatefulWidget {
  const _NetworkSettings();
  @override
  ConsumerState<_NetworkSettings> createState() => _NetworkSettingsState();
}

class _NetworkSettingsState extends ConsumerState<_NetworkSettings> {
  late String _proxyUrl = CfProxyStore.url;

  Future<String?> _edit({
    required String title,
    required String value,
    String? hint,
    String? helper,
    bool Function(String)? isValid,
  }) => showDialog<String>(
    context: context,
    builder: (_) => MobileSettingsTextDialog(
      title: title,
      initialValue: value,
      hint: hint,
      helper: helper,
      keyboardType: TextInputType.url,
      isValid: isValid,
    ),
  );

  Future<void> _chooseDoh(int current) async {
    final l10n = context.l10n;
    final selected = await showMobileSettingsPicker<int>(
      context,
      title: l10n.dns_provider,
      current: current,
      options: [
        for (final provider in ref.read(availableDoHProvidersProvider))
          MobileSettingOption(provider.id, provider.name),
        MobileSettingOption(DoHProviders.customId, l10n.custom),
      ],
    );
    if (!mounted || selected == null) return;
    if (selected.value == DoHProviders.customId) {
      final value = await _edit(
        title: l10n.custom_doh_url,
        value: DohCustomStore.url,
        hint: 'https://example.com/dns-query',
        helper: l10n.custom_doh_url_helper,
        isValid: (value) {
          final uri = Uri.tryParse(value.trim());
          return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
        },
      );
      if (mounted && value != null) {
        ref.read(doHProviderStateProvider.notifier).setCustomDoH(value.trim());
      }
    } else if (selected.value != current) {
      ref
          .read(doHProviderStateProvider.notifier)
          .setDoHProvider(selected.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final doh = ref.watch(doHProviderStateProvider);
    final dns = ref.watch(customDnsStateProvider);
    final userAgent = ref.watch(userAgentStateProvider);
    return Column(
      children: [
        NodeLaneSwitchRow(
          value: doh.enabled,
          title: l10n.dns_over_https,
          onChanged: ref.read(doHProviderStateProvider.notifier).setDoHEnabled,
        ),
        if (doh.enabled)
          NodeLaneRow(
            title: l10n.dns_provider,
            subtitle: doh.providerId == DoHProviders.customId
                ? '${l10n.custom} · ${DohCustomStore.url}'
                : (DoHProviders.byId[doh.providerId ?? 0]?.name ??
                      DoHProviders.cloudflare.name),
            subtitleMaxLines: 2,
            icon: NodeLaneIcons.of(context).repository,
            onTap: () => _chooseDoh(doh.providerId ?? 0),
          )
        else
          NodeLaneRow(
            title: l10n.custom_dns,
            subtitle: dns.isEmpty ? null : dns,
            subtitleMaxLines: 2,
            icon: NodeLaneIcons.of(context).repository,
            onTap: () async {
              final value = await _edit(
                title: l10n.custom_dns,
                value: dns,
                hint: '8.8.8.8',
              );
              if (mounted && value != null && value != dns) {
                ref.read(customDnsStateProvider.notifier).set(value);
              }
            },
          ),
        NodeLaneRow(
          title: l10n.default_user_agent,
          subtitle: userAgent,
          subtitleMaxLines: 2,
          icon: NodeLaneIcons.of(context).web,
          onTap: () async {
            final value = await _edit(
              title: l10n.default_user_agent,
              value: userAgent,
            );
            if (mounted && value != null && value != userAgent) {
              ref.read(userAgentStateProvider.notifier).set(value);
            }
          },
        ),
        NodeLaneRow(
          title: l10n.cloudflare_bypass_proxy,
          subtitle: _proxyUrl.isEmpty ? l10n.cf_proxy_helper : _proxyUrl,
          subtitleMaxLines: 2,
          icon: NodeLaneIcons.of(context).repository,
          onTap: () async {
            final value = await _edit(
              title: l10n.cloudflare_bypass_proxy,
              value: _proxyUrl,
              hint: 'http://localhost:8191/v1',
              helper: l10n.cf_proxy_helper,
              isValid: (value) {
                final trimmed = value.trim();
                return trimmed.isEmpty ||
                    trimmed.startsWith('http://') ||
                    trimmed.startsWith('https://');
              },
            );
            if (mounted && value != null && value.trim() != _proxyUrl) {
              CfProxyStore.setUrl(value.trim());
              setState(() => _proxyUrl = value.trim());
            }
          },
        ),
      ],
    );
  }
}

class _RecommendationWeights extends ConsumerStatefulWidget {
  const _RecommendationWeights();
  @override
  ConsumerState<_RecommendationWeights> createState() =>
      _RecommendationWeightsState();
}

class _RecommendationWeightsState
    extends ConsumerState<_RecommendationWeights> {
  late int _genre, _setting, _synopsis, _theme;

  @override
  void initState() {
    super.initState();
    _load(ref.read(algorithmWeightsStateProvider));
  }

  void _load(AlgorithmWeights weights) {
    _genre = weights.genre!;
    _setting = weights.setting!;
    _synopsis = weights.synopsis!;
    _theme = weights.theme!;
  }

  Widget _slider(
    String label,
    int value,
    ValueChanged<int> onChanged,
    ValueChanged<int> onEnd,
  ) => NodeLaneSliderRow(
    title: label,
    value: value.toDouble(),
    min: 0,
    max: 100,
    label: (value) => (value / 100).toStringAsFixed(2),
    onPreview: (value) {
      HapticFeedback.vibrate();
      setState(() => onChanged(value.toInt()));
    },
    onChanged: (value) => onEnd(value.toInt()),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final notifier = ref.watch(algorithmWeightsStateProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: () {
                final defaults = AlgorithmWeights();
                setState(() => _load(defaults));
                notifier.set(defaults);
              },
              icon: Icon(NodeLaneIcons.of(context).reset),
              label: Text(l10n.reset),
            ),
          ),
        ),
        _slider(
          l10n.recommendations_weights_genre,
          _genre,
          (v) => _genre = v,
          (v) => notifier.setWeights(genre: v),
        ),
        _slider(
          l10n.recommendations_weights_setting,
          _setting,
          (v) => _setting = v,
          (v) => notifier.setWeights(setting: v),
        ),
        _slider(
          l10n.recommendations_weights_synopsis,
          _synopsis,
          (v) => _synopsis = v,
          (v) => notifier.setWeights(synopsis: v),
        ),
        _slider(
          l10n.recommendations_weights_theme,
          _theme,
          (v) => _theme = v,
          (v) => notifier.setWeights(theme: v),
        ),
      ],
    );
  }
}

class _DiscordSettings extends ConsumerWidget {
  const _DiscordSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    Widget toggle(String title, bool value, ValueChanged<bool> onChanged) =>
        NodeLaneSwitchRow(title: title, value: value, onChanged: onChanged);
    return Column(
      children: [
        toggle(
          l10n.enable_discord_rpc,
          ref.watch(enableDiscordRpcStateProvider),
          (value) {
            ref.read(enableDiscordRpcStateProvider.notifier).set(value);
            if (value) {
              discordRpc?.connect(ref);
            } else {
              discordRpc?.disconnect();
            }
          },
        ),
        toggle(
          l10n.hide_discord_rpc_incognito,
          ref.watch(hideDiscordRpcInIncognitoStateProvider),
          ref.read(hideDiscordRpcInIncognitoStateProvider.notifier).set,
        ),
        toggle(
          l10n.rpc_show_reading_watching_progress,
          ref.watch(rpcShowReadingWatchingProgressStateProvider),
          ref.read(rpcShowReadingWatchingProgressStateProvider.notifier).set,
        ),
        toggle(
          l10n.rpc_show_title,
          ref.watch(rpcShowTitleStateProvider),
          ref.read(rpcShowTitleStateProvider.notifier).set,
        ),
        toggle(
          l10n.rpc_show_cover_image,
          ref.watch(rpcShowCoverImageStateProvider),
          ref.read(rpcShowCoverImageStateProvider.notifier).set,
        ),
      ],
    );
  }
}
