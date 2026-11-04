import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Local navigation metadata only. Values, options and writes remain in the
/// destination's existing controls; search never instantiates settings pages.
class SettingsSearchEntry {
  const SettingsSearchEntry({
    required this.title,
    required this.parents,
    required this.route,
    required this.icon,
    this.target = const [],
    this.keywords = '',
    this.extra,
  });

  final String title, route, keywords;
  final List<String> parents, target;
  final IconData icon;
  final Object? extra;

  String get breadcrumb => parents.join(' › ');
  String get location => target.isEmpty
      ? route
      : Uri(path: route, queryParameters: {'setting': target}).toString();

  bool matches(String query) {
    final terms = '$title $breadcrumb $keywords'.toLowerCase();
    return query
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .every(terms.contains);
  }
}

List<SettingsSearchEntry> settingsSearchEntries(
  BuildContext context,
  List<String> hidden,
) {
  final l = context.l10n, i = NodeLaneIcons.of(context);
  final entries = <SettingsSearchEntry>[];

  void page(
    String title,
    String route,
    String parent,
    IconData icon, {
    Object? extra,
  }) {
    entries.add(
      SettingsSearchEntry(
        title: title,
        parents: [parent],
        route: route,
        icon: icon,
        extra: extra,
      ),
    );
  }

  void rows(
    String parent,
    String route,
    IconData icon,
    List<String> titles, {
    List<String> section = const [],
  }) {
    for (final title in titles) {
      entries.add(
        SettingsSearchEntry(
          title: title,
          parents: [parent, ...section],
          route: route,
          icon: icon,
          target: [...section, title],
        ),
      );
    }
  }

  final appearance = l.settings_appearance_interface;
  entries.add(
    SettingsSearchEntry(
      title: l.app_language,
      parents: [appearance],
      route: '/appearance',
      icon: i.web,
      target: [l.app_language],
      keywords: 'display language interface language 语言 显示语言 界面语言 中文 English',
    ),
  );
  rows(appearance, '/appearance', i.palette, [
    l.theme,
    l.color,
    l.color_blend_level,
    l.app_ui_scale,
    l.font,
    l.relative_timestamp,
    l.date_format,
  ]);
  rows(
    appearance,
    '/appearance',
    i.night,
    [l.pure_black_dark_mode],
    section: [l.theme],
  );
  page(
    l.reorder_navigation,
    '/customNavigationSettings',
    appearance,
    i.navigation,
  );
  rows(l.general, '/general', i.settings, [
    l.auto_library_update,
    l.show_nav_double_tap_tooltip,
    l.memory_overlay,
    l.network_settings,
    l.recommendations_weights,
    'Discord',
  ]);
  rows(
    l.general,
    '/general',
    i.wifi,
    [l.auto_library_update_wifi_only],
    section: [l.auto_library_update],
  );
  rows(
    l.general,
    '/general',
    i.web,
    [
      l.dns_over_https,
      l.custom_dns,
      l.default_user_agent,
      l.cloudflare_bypass_proxy,
    ],
    section: [l.network_settings],
  );
  rows(
    l.general,
    '/general',
    i.web,
    [l.dns_provider],
    section: [l.network_settings, l.dns_over_https],
  );
  rows(
    l.general,
    '/general',
    i.adjustments,
    [
      l.recommendations_weights_genre,
      l.recommendations_weights_setting,
      l.recommendations_weights_synopsis,
      l.recommendations_weights_theme,
    ],
    section: [l.recommendations_weights],
  );
  rows(
    l.general,
    '/general',
    i.chat,
    [
      l.enable_discord_rpc,
      l.hide_discord_rpc_incognito,
      l.rpc_show_reading_watching_progress,
      l.rpc_show_title,
      l.rpc_show_cover_image,
    ],
    section: ['Discord'],
  );
  rows(l.settings_security_privacy, '/security', i.security, [l.app_lock]);

  if (!hidden.contains('/MangaLibrary')) {
    final reader = l.settings_manga_reader;
    rows(reader, '/readerMode', i.manga, [
      l.default_reading_mode,
      l.scale_type,
      l.background_color,
      l.show_page_number,
      l.keep_screen_on,
      l.crop_borders,
      l.reader_page_layout,
      l.reader_continuous_options,
      l.navigation_layout,
      l.advanced,
    ]);
    rows(
      reader,
      '/readerMode',
      i.pageLayout,
      [
        l.split_wide_pages,
        l.dual_page_invert,
        l.dual_page_rotate_to_fit,
        l.dual_page_rotate_to_fit_invert,
        l.double_page_single_first_page,
        l.double_page_auto,
        l.landscape_zoom,
        l.zoom_start_position,
      ],
      section: [l.reader_page_layout],
    );
    rows(
      reader,
      '/readerMode',
      i.manga,
      [
        l.webtoon_disable_zoom_out,
        l.webtoon_double_tap_zoom_enabled,
        l.show_page_gaps,
      ],
      section: [l.reader_continuous_options],
    );
    rows(
      reader,
      '/readerMode',
      i.navigation,
      [
        l.use_page_tap_zones,
        l.tapping_inversion,
        l.reader_hide_threshold,
        l.show_navigation_overlay_on_start,
        l.navigate_to_pan,
        l.chapter_swipe_start,
        l.chapter_swipe_end,
      ],
      section: [l.navigation_layout],
    );
    rows(
      reader,
      '/readerMode',
      i.adjustments,
      [
        l.page_preload_amount,
        l.animate_page_transitions,
        l.double_tap_animation_speed,
        l.mark_duplicate_chapters_read,
        l.flash_on_page_change,
      ],
      section: [l.advanced],
    );
    rows(
      reader,
      '/readerMode',
      i.palette,
      [l.flash_color],
      section: [l.advanced, l.flash_on_page_change],
    );
  }
  if (!hidden.contains('/NovelLibrary')) {
    final reader = l.settings_novel_reader;
    rows(reader, '/novelReaderMode', i.novel, [
      l.font,
      l.font_size,
      l.keep_screen_on,
      l.show_scroll_percentage,
      l.theme,
      l.custom,
      l.reader_page_layout,
    ]);
    rows(
      reader,
      '/novelReaderMode',
      i.palette,
      [l.background, l.text],
      section: [l.custom],
    );
    rows(
      reader,
      '/novelReaderMode',
      i.pageLayout,
      [
        l.text_align,
        l.padding,
        l.line_height,
        l.remove_extra_paragraph_spacing,
        l.use_page_tap_zones,
        l.double_page_auto,
      ],
      section: [l.reader_page_layout],
    );
    if (isMobile) {
      page(l.tts, '/ttsSettings', reader, i.novel);
      rows('$reader › ${l.tts}', '/ttsSettings', i.novel, [
        l.tts_speed,
        l.tts_pitch,
        l.tts_language,
      ]);
    }
  }
  if (!hidden.contains('/AnimeLibrary')) {
    for (final (title, route, icon) in [
      (l.internal_player, '/playerMode', i.anime),
      (l.video_audio, '/playerAudioScreen', i.headphones),
      (l.decoder, '/playerDecoderScreen', i.memory),
      (l.custom_buttons, '/customButtonScreen', i.adjustments),
      (l.advanced, '/playerAdvancedScreen', i.code),
    ]) {
      page(title, route, l.player, icon);
    }
    final player = '${l.player} › ${l.internal_player}';
    rows(player, '/playerMode', i.anime, [
      l.default_playback_speed_length,
      l.markEpisodeAsSeenSetting,
      l.default_subtitle_language,
      l.use_libass,
      l.player_controls,
      l.display,
      'AniSkip',
    ]);
    rows(
      player,
      '/playerMode',
      i.adjustments,
      [l.default_skip_intro_length, l.default_skip_forward_skip_length],
      section: [l.player_controls],
    );
    rows(
      player,
      '/playerMode',
      i.anime,
      [l.full_screen_player, l.forceLandscapeMode],
      section: [l.display],
    );
    rows(
      player,
      '/playerMode',
      i.anime,
      [l.enable_aniskip, l.enable_auto_skip, l.aniskip_button_timeout],
      section: ['AniSkip'],
    );
    rows('${l.player} › ${l.video_audio}', '/playerAudioScreen', i.headphones, [
      l.audio_preferred_languages,
      l.audio_channels,
      l.enable_audio_pitch_correction,
      l.volume_boost_cap,
    ]);
    rows('${l.player} › ${l.decoder}', '/playerDecoderScreen', i.memory, [
      l.enable_hardware_accel,
      l.hwdec,
      l.debanding,
      l.use_yuv420p,
      l.enable_gpu_next,
    ]);
    rows('${l.player} › ${l.advanced}', '/playerAdvancedScreen', i.code, [
      l.enable_mpv,
    ]);
  }

  final storage = l.settings_storage_backup;
  page(l.create_backup, '/createBackup', storage, i.backup);
  rows(storage, '/dataAndStorage', i.storage, [
    l.restore_backup,
    l.automatic_backups,
    l.settings_chapter_cache,
    l.settings_cover_cache,
    l.settings_translation_cache,
    l.download_location,
    l.settings_advanced_options,
  ]);
  rows(
    storage,
    '/dataAndStorage',
    i.backup,
    [l.encrypt_backups, l.clear_chapter_or_episode_cache_on_app_launch],
    section: [l.settings_advanced_options],
  );
  rows(l.settings_downloads, '/downloads', i.download, [
    l.only_on_wifi,
    l.allow_concurrent_downloads,
    l.download_delay,
    l.download_location,
    l.save_as_cbz_archive,
    l.delete_download_after_reading,
    l.local_folder,
  ]);
  rows(
    l.settings_downloads,
    '/downloads',
    i.download,
    [l.concurrent_downloads],
    section: [l.allow_concurrent_downloads],
  );
  rows(
    l.settings_downloads,
    '/downloads',
    i.folderOutline,
    [l.add_local_folder, l.rescan_local_folder, l.local_folder_structure],
    section: [l.local_folder],
  );
  rows(l.syncing, '/sync', i.cloud, [l.sync_on, l.advanced, l.about]);
  rows(l.syncing, '/sync', i.cloud, [l.sync_auto], section: [l.sync_on]);
  page(l.manage_trackers, '/manageTrackers', l.tracking, i.tracking);
  rows(l.tracking, '/track', i.tracking, [l.updateProgressAfterReading]);

  final sources = l.settings_source_preferences;
  if (!Platform.isAndroid) {
    page(l.extension_service, '/extensionServer', sources, i.repository);
  }
  for (final (title, type) in [
    (l.manga_extensions_repo, ItemType.manga),
    (l.anime_extensions_repo, ItemType.anime),
    (l.novel_extensions_repo, ItemType.novel),
  ]) {
    page(title, '/SourceRepositories', sources, i.repository, extra: type);
  }
  rows(sources, '/browseS', i.webLink, [
    l.check_for_extension_updates,
    l.auto_extensions_updates,
    l.only_include_pinned_sources,
    l.nsfw_sources_show,
    l.developer_mode,
  ]);
  rows(
    sources,
    '/browseS',
    i.storage,
    [
      l.clean_database,
      l.clear_all_sources,
      l.clear_library,
      l.clear_local_library,
    ],
    section: [l.data_and_storage],
  );
  page(l.error_reports, '/errorReports', l.settings_about_help, i.info);
  rows(l.settings_about_help, '/about', i.info, [
    l.check_for_update,
    l.app_update_auto,
    l.onboarding_replay,
    l.app_diagnostics,
  ]);
  rows(
    l.settings_about_help,
    '/about',
    i.novel,
    [l.logs_on, l.share_app_logs],
    section: [l.app_diagnostics],
  );
  return entries;
}
