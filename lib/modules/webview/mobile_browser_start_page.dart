import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';
import 'package:mangayomi/theme/nodelane_icons.dart';
import 'package:mangayomi/modules/widgets/nodelane_brand_mark.dart';
import 'package:mangayomi/utils/nodelane_brand.dart';

import 'browser_library_store.dart';
import 'browser_url.dart';
import 'mobile_browser_widgets.dart';

/// One start page for the browser root and every logical blank tab.
/// Opening, tab lifecycle and source preferences belong to the caller.
class MobileBrowserStartPage extends StatelessWidget {
  const MobileBrowserStartPage({
    super.key,
    required this.sources,
    required this.tabCount,
    required this.onOpen,
    this.onTabs,
    this.onManage,
    this.bottomInset = 0,
    this.engine = BrowserSearchEngine.google,
    this.recent = const [],
    this.onEngine,
    this.onHistory,
    this.onBookmarks,
  });
  final List<Source> sources;
  final int tabCount;
  final void Function(String url, String title) onOpen;
  final VoidCallback? onTabs, onManage;
  final double bottomInset;
  final BrowserSearchEngine engine;
  final List<BrowserPageEntry> recent;
  final Future<void> Function(BrowserSearchEngine)? onEngine;
  final VoidCallback? onHistory, onBookmarks;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        NodeLaneTokens.gutter,
        NodeLaneTokens.space8,
        NodeLaneTokens.gutter,
        bottomInset + NodeLaneTokens.space24,
      ),
      children: [
        const SizedBox(height: NodeLaneTokens.space24),
        const Center(child: NodeLaneBrandMark()),
        const SizedBox(height: NodeLaneTokens.space12),
        Text(
          NodeLaneBrand.displayName,
          textAlign: TextAlign.center,
          style: NodeLaneTokens.of(context).title,
        ),
        const SizedBox(height: NodeLaneTokens.space8),
        Text(
          context.l10n.browser_start_hint,
          textAlign: TextAlign.center,
          style: NodeLaneTokens.of(context).readerSecondary,
        ),
        const SizedBox(height: NodeLaneTokens.space24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MobileBrowserAddressField(
                engine: engine,
                onEngine: onEngine,
                onSubmitted: (url) => onOpen(url, ''),
              ),
            ),
            const SizedBox(width: NodeLaneTokens.space8),
            Padding(
              padding: const EdgeInsets.only(
                top:
                    (NodeLaneTokens.searchHeight -
                        NodeLaneTokens.minTapTarget) /
                    2,
              ),
              child: MobileBrowserTabsButton(
                count: tabCount,
                onPressed: onTabs,
                tonal: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: NodeLaneTokens.space8),
        Row(
          children: [
            Expanded(
              child: NodeLaneToolbarAction(
                onPressed: onHistory,
                icon: NodeLaneIcons.of(context).history,
                label: context.l10n.history,
              ),
            ),
            Expanded(
              child: NodeLaneToolbarAction(
                onPressed: onBookmarks,
                icon: NodeLaneIcons.of(context).bookmarkOutline,
                label: context.l10n.browser_bookmarks,
              ),
            ),
          ],
        ),
        if (recent.isNotEmpty) ...[
          const SizedBox(height: NodeLaneTokens.space16),
          NodeLaneCatalogHeading(
            context.l10n.browser_recent,
            action: context.l10n.manage,
            onAction: onHistory,
          ),
          for (var i = 0; i < recent.length; i++)
            NodeLaneRow.card(
              title: recent[i].displayTitle,
              titleMaxLines: 1,
              subtitle: recent[i].host,
              subtitleMaxLines: 1,
              leading: NodeLaneWebsiteIcon(url: recent[i].faviconUrl),
              first: i == 0,
              last: i == recent.length - 1,
              onTap: () => onOpen(recent[i].url, recent[i].title),
            ),
        ],
        if (sources.isNotEmpty) ...[
          const SizedBox(height: NodeLaneTokens.space16),
          NodeLaneCatalogHeading(
            context.l10n.source_pinned_websites,
            action: onManage == null ? null : context.l10n.manage,
            onAction: onManage,
          ),
          for (var i = 0; i < sources.length; i++)
            NodeLaneRow.card(
              title: sources[i].name?.isNotEmpty == true
                  ? sources[i].name!
                  : Uri.parse(sources[i].baseUrl!).host,
              titleMaxLines: 1,
              metadata: Uri.parse(sources[i].baseUrl!).host,
              leading: NodeLaneWebsiteIcon(url: sources[i].iconUrl),
              first: i == 0,
              last: i == sources.length - 1,
              onTap: () => onOpen(sources[i].baseUrl!, sources[i].name ?? ''),
            ),
        ] else if (onManage != null) ...[
          const SizedBox(height: NodeLaneTokens.space16),
          NodeLaneRow.card(
            title: context.l10n.source_pinned_websites,
            subtitle: context.l10n.browser_pinned_hint,
            icon: NodeLaneIcons.of(context).pin,
            onTap: onManage,
          ),
        ],
      ],
    ),
  );
}
