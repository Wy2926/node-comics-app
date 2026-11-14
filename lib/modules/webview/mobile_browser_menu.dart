import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

import 'browser_url.dart';

Future<T?> _showBrowserMenu<T>(
  BuildContext anchor,
  List<PopupMenuEntry<T>> items,
) {
  final overlayContext = Navigator.of(
    anchor,
    rootNavigator: true,
  ).overlay!.context;
  final overlay = overlayContext.findRenderObject()! as RenderBox;
  final box = anchor.findRenderObject()! as RenderBox;
  final media = MediaQuery.of(overlayContext);
  final rect = box.localToGlobal(Offset.zero, ancestor: overlay) & box.size;
  var top = rect.bottom;
  var maxHeight = media.size.height * .7;
  // PopupMenuRoute avoids safe areas but does not avoid the editing keyboard.
  if (media.viewInsets.bottom > 0) {
    final above = math.max(
      0.0,
      rect.top - media.viewPadding.top - NodeLaneTokens.space8,
    );
    final below = math.max(
      0.0,
      overlay.size.height -
          media.viewInsets.bottom -
          rect.bottom -
          NodeLaneTokens.space8,
    );
    maxHeight = math.min(maxHeight, math.max(above, below));
    if (above > below) top = rect.top - maxHeight;
  }
  return showMenu<T>(
    context: anchor,
    useRootNavigator: true,
    requestFocus: false,
    position: RelativeRect.fromRect(
      Offset(rect.left, top) & Size(rect.width, 0),
      Offset.zero & overlay.size,
    ),
    constraints: BoxConstraints(
      maxWidth: NodeLaneTokens.menuMaxWidth,
      maxHeight: maxHeight,
    ),
    clipBehavior: Clip.antiAlias,
    items: items,
  );
}

Future<BrowserSearchEngine?> showBrowserSearchEngines(
  BuildContext anchor,
  BrowserSearchEngine selected,
) => _showBrowserMenu(anchor, [
  for (final engine in BrowserSearchEngine.values)
    PopupMenuItem(
      value: engine,
      child: Semantics(
        selected: selected == engine,
        child: Row(
          children: [
            Image.asset(
              engine.logoAsset,
              width: NodeLaneTokens.iconSize,
              height: NodeLaneTokens.iconSize,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: NodeLaneTokens.space12),
            Expanded(child: Text(engine.label)),
            const SizedBox(width: NodeLaneTokens.space8),
            SizedBox(
              width: NodeLaneTokens.smallIconSize,
              child: engine == selected
                  ? Icon(
                      NodeLaneIcons.of(anchor).check,
                      size: NodeLaneTokens.smallIconSize,
                      color: NodeLaneTokens.of(anchor).accent,
                    )
                  : null,
            ),
          ],
        ),
      ),
    ),
]);

Future<String?> showBrowserPageMenu(
  BuildContext anchor, {
  required bool canForward,
  required bool bookmarked,
  required bool pageReady,
  required bool clearingLogins,
}) {
  final l = anchor.l10n, icons = NodeLaneIcons.of(anchor);
  PopupMenuItem<String> row(
    String value,
    String title,
    IconData icon, {
    bool enabled = true,
  }) => PopupMenuItem(
    value: value,
    enabled: enabled,
    child: Row(
      children: [
        Expanded(child: Text(title)),
        const SizedBox(width: NodeLaneTokens.space12),
        Icon(icon, size: NodeLaneTokens.smallIconSize),
      ],
    ),
  );
  return _showBrowserMenu(anchor, [
    PopupMenuItem<String>(
      padding: const EdgeInsets.symmetric(horizontal: NodeLaneTokens.space8),
      child: Builder(
        builder: (context) {
          Widget action(
            String value,
            String title,
            IconData icon, {
            bool enabled = true,
          }) => Expanded(
            child: NodeLaneIconButton(
              tooltip: title,
              icon: icon,
              style: NodeLaneIconButtonStyle.plain,
              onPressed: enabled ? () => Navigator.pop(context, value) : null,
            ),
          );
          return Row(
            children: [
              action(
                'forward',
                l.browser_forward,
                icons.forward,
                enabled: canForward,
              ),
              action('home', l.browser_start_page, icons.browserStart),
              action(
                'bookmark',
                bookmarked ? l.browser_remove_bookmark : l.browser_add_bookmark,
                bookmarked ? icons.bookmark : icons.bookmarkOutline,
              ),
              action('share', l.share, icons.share),
            ],
          );
        },
      ),
    ),
    const PopupMenuDivider(),
    row('bookmarks', l.browser_bookmarks, icons.bookmarkOutline),
    row('history', l.history, icons.history),
    row('find', l.browser_find, icons.search, enabled: pageReady),
    const PopupMenuDivider(),
    row('copy', l.browser_copy_link, icons.copy),
    row('external', l.open_in_browser, icons.external),
    row(
      'cookies',
      l.browser_clear_all_cookies,
      icons.cookies,
      enabled: !clearingLogins,
    ),
  ]);
}
