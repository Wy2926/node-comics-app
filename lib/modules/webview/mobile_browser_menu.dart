import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_bubble.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'browser_url.dart';

Future<BrowserSearchEngine?> showBrowserSearchEngines(
  BuildContext anchor,
  BrowserSearchEngine selected,
) => showNodeLaneBubble<BrowserSearchEngine>(
  anchor,
  label: anchor.l10n.browser_search_engine,
  requestFocus: false,
  child: Builder(
    builder: (context) => SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          for (final engine in BrowserSearchEngine.values)
            NodeLaneRow(
              compact: true,
              title: engine.label,
              selected: selected == engine,
              leading: Image.asset(
                engine.logoAsset,
                excludeFromSemantics: true,
              ),
              leadingSize: const Size.square(NodeLaneTokens.iconSize),
              onTap: () => Navigator.pop(context, engine),
            ),
        ],
      ),
    ),
  ),
);

Future<String?> showBrowserPageMenu(
  BuildContext anchor, {
  required bool canForward,
  required bool bookmarked,
  required bool pageReady,
  required bool clearingLogins,
  bool hasReader = false,
  bool canClip = false,
  bool canFocus = false,
  bool hasNextChapter = false,
}) {
  final l = anchor.l10n, icons = NodeLaneIcons.of(anchor);
  return showNodeLaneBubble<String>(
    anchor,
    label: l.more,
    child: Builder(
      builder: (context) {
        void select(String action) {
          if (ModalRoute.isCurrentOf(context) == true) {
            Navigator.pop(context, action);
          }
        }

        Widget row(
          String action,
          String title,
          IconData icon, {
          bool enabled = true,
          String? subtitle,
        }) => NodeLaneRow(
          compact: true,
          title: title,
          subtitle: subtitle,
          icon: icon,
          enabled: enabled,
          trailing: const SizedBox.shrink(),
          onTap: enabled ? () => select(action) : null,
        );
        Widget shortcut(
          String action,
          String title,
          IconData icon, {
          bool enabled = true,
        }) => Expanded(
          child: NodeLaneIconButton(
            icon: icon,
            tooltip: title,
            style: NodeLaneIconButtonStyle.plain,
            onPressed: enabled ? () => select(action) : null,
          ),
        );
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              Row(
                children: [
                  shortcut(
                    'forward',
                    l.browser_forward,
                    icons.forward,
                    enabled: canForward,
                  ),
                  shortcut('home', l.browser_start_page, icons.browserStart),
                  shortcut(
                    'bookmark',
                    bookmarked
                        ? l.browser_remove_bookmark
                        : l.browser_add_bookmark,
                    bookmarked ? icons.bookmark : icons.bookmarkOutline,
                  ),
                  shortcut('share', l.share, icons.share),
                ],
              ),
              const NodeLaneGroupDivider(),
              if (canFocus)
                row(
                  'focus',
                  l.browser_focus,
                  icons.fullscreen,
                  subtitle: l.browser_focus_hint,
                ),
              if (canClip)
                row('clip', l.browser_clip_here, icons.bookmarkOutline),
              if (hasNextChapter)
                row('next', l.browser_next_chapter, icons.nextChapter),
              if (hasReader) row('reader', l.browser_open_reader, icons.manga),
              row('find', l.browser_find, icons.search, enabled: pageReady),
              row('bookmarks', l.browser_bookmarks, icons.bookmark),
              row('history', l.history, icons.history),
              const NodeLaneGroupDivider(),
              row('copy', l.browser_copy_link, icons.copy),
              row('external', l.open_in_browser, icons.external),
              row('requestSource', l.feedback_source, icons.chat),
              const NodeLaneGroupDivider(),
              row(
                'siteCookies',
                l.source_clear_cookies,
                icons.cookies,
                enabled: !clearingLogins,
              ),
              row(
                'cookies',
                l.delete_all_cookies,
                icons.cookies,
                enabled: !clearingLogins,
              ),
            ],
          ),
        );
      },
    ),
  );
}
