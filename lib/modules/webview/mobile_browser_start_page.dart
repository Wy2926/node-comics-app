import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/widgets/nodelane_catalog_widgets.dart';
import 'package:mangayomi/modules/widgets/nodelane_controls.dart';
import 'package:mangayomi/theme/nodelane_tokens.dart';

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
  });
  final List<Source> sources;
  final int tabCount;
  final void Function(String url, String title) onOpen;
  final VoidCallback? onTabs, onManage;
  final double bottomInset;

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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MobileBrowserAddressField(
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
        if (sources.isNotEmpty) ...[
          const SizedBox(height: NodeLaneTokens.space16),
          NodeLaneCatalogHeading(
            '常用网站',
            action: onManage == null ? null : '管理',
            onAction: onManage,
          ),
          for (var i = 0; i < sources.length; i++)
            NodeLaneRow.card(
              title: sources[i].name?.isNotEmpty == true
                  ? sources[i].name!
                  : Uri.parse(sources[i].baseUrl!).host,
              metadata: Uri.parse(sources[i].baseUrl!).host,
              leading: NodeLaneWebsiteIcon(url: sources[i].iconUrl),
              first: i == 0,
              last: i == sources.length - 1,
              onTap: () => onOpen(sources[i].baseUrl!, sources[i].name ?? ''),
            ),
        ],
      ],
    ),
  );
}
