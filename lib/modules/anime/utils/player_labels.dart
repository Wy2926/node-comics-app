import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:flutter/painting.dart';

/// Shortens a source quality label like "1080p (Sub)" to "1080-sub"/"1080-dub".
String shortQualityLabel(String raw) {
  final lower = raw.toLowerCase();
  final res = RegExp(r'(\d{3,4})\s*p?').firstMatch(lower)?.group(1);
  final tag = lower.contains('sub')
      ? 'sub'
      : lower.contains('dub')
      ? 'dub'
      : null;
  if (res != null && tag != null) return '$res-$tag';
  if (res != null) return '${res}p';
  return raw;
}

/// Shortens a track name to fit a player pill: the bracketed language tag
/// when there is one, otherwise the leading word, at most 6 characters.
String shortTrackLabel(String raw) {
  var trimmed = raw.trim();
  if (trimmed.isEmpty) return '';
  if (trimmed.startsWith('[')) {
    final closing = trimmed.indexOf(']');
    if (closing > 1) {
      trimmed = trimmed.substring(1, closing).trim();
    } else {
      trimmed = trimmed.substring(1).trim();
    }
  } else if (trimmed.startsWith('(')) {
    final closing = trimmed.indexOf(')');
    if (closing > 1) {
      trimmed = trimmed.substring(1, closing).trim();
    } else {
      trimmed = trimmed.substring(1).trim();
    }
  }
  final clean = trimmed.split(RegExp(r'[\(\[\-]')).first.trim();
  final candidate = clean.isNotEmpty ? clean : trimmed;
  if (candidate.length > 7) {
    return candidate.substring(0, 6);
  }
  return candidate;
}

String fitShortLabel(BoxFit fit, AppLocalizations l10n) => switch (fit) {
  BoxFit.contain => l10n.player_fit_contain,
  BoxFit.cover => l10n.player_fit_cover,
  BoxFit.fill => l10n.player_fit_fill,
  BoxFit.fitHeight => l10n.player_fit_height,
  BoxFit.fitWidth => l10n.player_fit_width,
  BoxFit.scaleDown => l10n.player_fit_scale,
  BoxFit.none => l10n.player_fit_none,
};

/// Localize only presentation; mpv commands and saved shader names stay stable.
String shaderDisplayLabel(AppLocalizations l10n, String name, String command) =>
    switch (command) {
      'clear_anime' => l10n.player_shader_clear,
      'set_luma' => l10n.player_shader_luma,
      _ => name,
    };

String playerStatsLabel(AppLocalizations l10n, String binding) =>
    switch (binding) {
      'stats/display-stats-toggle' => l10n.player_stats_toggle,
      'stats/display-page-1' => l10n.player_stats_general,
      'stats/display-page-2' => l10n.player_stats_frames,
      'stats/display-page-3' => l10n.player_stats_cache,
      'stats/display-page-4' => l10n.player_stats_filters,
      'stats/display-page-5' => l10n.player_stats_log,
      _ => binding,
    };
